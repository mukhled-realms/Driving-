const CACHE_NAME = 'cyber-delivery-v1';
const assets = ['index.html', 'driver.html', 'track.html', 'admin.html', 'config.js', 'offline.html'];

self.addEventListener('install', e => {
  e.waitUntil(
    caches.open(CACHE_NAME).then(cache => cache.addAll(assets))
  );
});

self.addEventListener('fetch', e => {
  e.respondWith(
    caches.match(e.request).then(response => {
      return response || fetch(e.request).catch(() => caches.match('offline.html'));
    })
  );
});
