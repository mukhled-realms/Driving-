const CACHE_NAME = 'cyberdelivery-v4.0.0';
const OFFLINE_URL = '/offline.html';

const CORE_ASSETS = [
  '/', '/index.html', '/driver.html', '/track.html', '/admin.html',
  '/config.js', '/manifest.json', '/offline.html'
];

const CDN_ASSETS = [
  'https://cdn.tailwindcss.com',
  'https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2',
  'https://unpkg.com/leaflet@1.9.4/dist/leaflet.js',
  'https://unpkg.com/leaflet@1.9.4/dist/leaflet.css',
  'https://fonts.googleapis.com/css2?family=Tajawal:wght@400;700;900&family=Noto+Nastaliq+Urdu:wght@400;700&family=Noto+Sans+Bengali:wght@400;700&family=Noto+Sans+Devanagari:wght@400;700&display=swap'
];

self.addEventListener('install', (event) => {
  console.log('[SW] Installing...', CACHE_NAME);
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      return Promise.all([
        cache.addAll(CORE_ASSETS).catch(err => console.warn(err)),
        ...CDN_ASSETS.map(url => cache.add(url).catch(err => console.warn(err)))
      ]);
    }).then(() => self.skipWaiting())
  );
});

self.addEventListener('activate', (event) => {
  console.log('[SW] Activating...', CACHE_NAME);
  event.waitUntil(
    Promise.all([
      caches.keys().then((cacheNames) => {
        return Promise.all(
          cacheNames.filter(name => name !== CACHE_NAME).map(name => caches.delete(name))
        );
      }),
      self.clients.claim()
    ])
  );
});

self.addEventListener('fetch', (event) => {
  const url = new URL(event.request.url);
  if (url.pathname.includes('/realtime/v1/websocket')) return;
  
  if (event.request.method !== 'GET') {
    event.respondWith(networkFirst(event.request));
    return;
  }
  
  if (CDN_ASSETS.some(cdn => url.href.startsWith(cdn))) {
    event.respondWith(cacheFirst(event.request));
  } else {
    event.respondWith(staleWhileRevalidate(event.request));
  }
});

async function cacheFirst(request) {
  const cached = await caches.match(request);
  if (cached) return cached;
  try {
    const response = await fetch(request);
    if (response.ok) {
      const cache = await caches.open(CACHE_NAME);
      cache.put(request, response.clone());
    }
    return response;
  } catch (error) {
    return new Response('', { status: 503 });
  }
}

async function networkFirst(request) {
  try {
    const response = await fetch(request);
    if (response.ok) {
      const cache = await caches.open(CACHE_NAME);
      cache.put(request, response.clone());
    }
    return response;
  } catch (error) {
    const cached = await caches.match(request);
    return cached || new Response(JSON.stringify({ error: 'Offline' }), { status: 503, headers: { 'Content-Type': 'application/json' } });
  }
}

async function staleWhileRevalidate(request) {
  const cache = await caches.open(CACHE_NAME);
  const cached = await cache.match(request);
  const fetchPromise = fetch(request).then((response) => {
    if (response.ok) cache.put(request, response.clone());
    return response;
  }).catch(() => cached);
  return cached || fetchPromise;
}

self.addEventListener('push', (event) => {
  let data = { title: 'سايبر توصيل', body: 'لديك إشعار جديد' };
  try { if (event.data) data = event.data.json(); } catch (e) {}
  
  const options = {
    body: data.body || 'لديك إشعار جديد',
    icon: data.icon || generateIconSVG('🚀'),
    badge: data.badge || generateIconSVG('📦'),
    image: data.image || null,
    tag: data.tag || 'cyberdelivery-' + Date.now(),
    requireInteraction: data.requireInteraction || false,
    silent: data.silent || false,
    vibrate: data.vibrate || [200, 100, 200],
    data: { url: data.url || '/', orderId: data.orderId || null, type: data.type || 'general' },
    actions: data.actions || [{ action: 'view', title: 'عرض' }, { action: 'dismiss', title: 'إغلاق' }]
  };
  
  event.waitUntil(self.registration.showNotification(data.title || 'سايبر توصيل', options));
});

self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  const urlToOpen = event.notification.data?.url || '/';
  if (event.action === 'dismiss') return;
  
  event.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then((windowClients) => {
      for (let client of windowClients) {
        if (client.url.includes(urlToOpen) && 'focus' in client) return client.focus();
      }
      if (clients.openWindow) return clients.openWindow(urlToOpen);
    })
  );
});

self.addEventListener('sync', (event) => {
  if (event.tag === 'sync-orders') event.waitUntil(syncPendingOrders());
  else if (event.tag === 'sync-location') event.waitUntil(syncDriverLocation());
});

async function syncPendingOrders() {
  try {
    const db = await openDatabase();
    const transaction = db.transaction(['pending_orders'], 'readonly');
    const store = transaction.objectStore('pending_orders');
    const pendingOrders = await getAllFromStore(store);
    
    for (const order of pendingOrders) {
      try {
        const response = await fetch('/api/orders', {
          method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(order.data)
        });
        if (response.ok) {
          const deleteTx = db.transaction(['pending_orders'], 'readwrite');
          deleteTx.objectStore('pending_orders').delete(order.id);
        }
      } catch (error) {}
    }
  } catch (error) {}
}

async function syncDriverLocation() {
  try {
    const lastLocation = await getLastLocation();
    if (lastLocation) {
      await fetch('/api/driver/location', {
        method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(lastLocation)
      });
    }
  } catch (error) {}
}

function openDatabase() {
  return new Promise((resolve, reject) => {
    const request = indexedDB.open('CyberDeliveryDB', 1);
    request.onupgradeneeded = (event) => {
      const db = event.target.result;
      if (!db.objectStoreNames.contains('pending_orders')) db.createObjectStore('pending_orders', { keyPath: 'id' });
      if (!db.objectStoreNames.contains('driver_locations')) db.createObjectStore('driver_locations', { keyPath: 'timestamp' });
    };
    request.onsuccess = (event) => resolve(event.target.result);
    request.onerror = (event) => reject(event.target.error);
  });
}

function getAllFromStore(store) {
  return new Promise((resolve, reject) => {
    const request = store.getAll();
    request.onsuccess = () => resolve(request.result);
    request.onerror = () => reject(request.error);
  });
}

async function getLastLocation() {
  try {
    const db = await openDatabase();
    const transaction = db.transaction(['driver_locations'], 'readonly');
    const store = transaction.objectStore('driver_locations');
    const allLocations = await getAllFromStore(store);
    return allLocations.length > 0 ? allLocations[allLocations.length - 1] : null;
  } catch (error) { return null; }
}

function generateIconSVG(emoji) {
  const svg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512"><rect fill="#05050a" width="512" height="512" rx="64"/><text x="256" y="300" font-size="200" text-anchor="middle" fill="#00ff66" font-family="Arial">${emoji}</text></svg>`;
  return 'data:image/svg+xml,' + encodeURIComponent(svg);
}

self.addEventListener('online', () => self.registration.sync.register('sync-orders').catch(() => {}));
self.addEventListener('offline', () => {});

self.addEventListener('message', (event) => {
  if (event.data && event.data.type === 'SKIP_WAITING') self.skipWaiting();
  if (event.data && event.data.type === 'CACHE_URLS') {
    event.waitUntil(caches.open(CACHE_NAME).then(cache => cache.addAll(event.data.urls)));
  }
  if (event.data && event.data.type === 'CLEAR_CACHE') {
    event.waitUntil(caches.keys().then(keys => Promise.all(keys.map(k => caches.delete(k)))));
  }
});

console.log('[SW] Service Worker loaded successfully');
