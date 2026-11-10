const CONFIG = {
  SUPABASE: {
    URL: 'https://hhljyqelqnsltmasxgqv.supabase.co',
    KEY: 'sb_publishable_Xeo54iI9kxJ0n00f71A_yA_QNvmRC3H'
  },
  ROLES: {
    ADMIN: 'admin', RESTAURANT_OWNER: 'restaurant_owner', RESTAURANT_STAFF: 'restaurant_staff', DRIVER: 'driver', CUSTOMER: 'customer'
  },
  LANGUAGES: {
    AR: { code: 'ar', dir: 'rtl', label: 'العربية', flag: '🇸🇦', font: 'Tajawal', speechCode: 'ar-SA' },
    EN: { code: 'en', dir: 'ltr', label: 'English', flag: '🇬🇧', font: 'Tajawal', speechCode: 'en-US' },
    UR: { code: 'ur', dir: 'rtl', label: 'اردو', flag: '🇵🇰', font: 'Noto Nastaliq Urdu', speechCode: 'ur-PK' },
    BN: { code: 'bn', dir: 'ltr', label: 'বাংলা', flag: '🇧🇩', font: 'Noto Sans Bengali', speechCode: 'bn-BD' },
    HI: { code: 'hi', dir: 'ltr', label: 'हिंदी', flag: '🇮🇳', font: 'Noto Sans Devanagari', speechCode: 'hi-IN' }
  },
  DEFAULT_LANGUAGE: 'ar',
  PRICING: {
    BASE_FEE: 10, PER_KM_FEE: 2, PLATFORM_COMMISSION_PERCENT: 15, DRIVER_SHARE_PERCENT: 85,
    MIN_ORDER_AMOUNT: 15, MAX_CASH_AMOUNT: 1000, NIGHT_MULTIPLIER: 1.2, NIGHT_START_HOUR: 22,
    NIGHT_END_HOUR: 6, RUSH_HOUR_MULTIPLIER: 1.15, RUSH_HOURS: [12, 13, 14, 19, 20, 21]
  },
  ORDER_STATUS: { PENDING: 'pending', ACCEPTED: 'accepted', AT_STORE: 'at_store', PICKED_UP: 'picked_up', IN_TRANSIT: 'in_transit', DELIVERED: 'delivered', CANCELLED: 'cancelled' },
  EMERGENCY_TYPES: { SOS: 'sos', ACCIDENT: 'accident', THEFT: 'theft', MEDICAL: 'medical', VEHICLE_BREAKDOWN: 'vehicle_breakdown', OTHER: 'other' },
  EMERGENCY_STATUS: { ACTIVE: 'active', RESPONDED: 'responded', RESOLVED: 'resolved' },
  GEOCODING: {
    NOMINATIM_URL: 'https://nominatim.openstreetmap.org/search',
    REVERSE_URL: 'https://nominatim.openstreetmap.org/reverse',
    USER_AGENT: 'CyberDelivery/1.0', RATE_LIMIT_MS: 1000,
    DEFAULT_LOCATION: { lat: 24.7136, lng: 46.6753, city: 'Riyadh', country: 'Saudi Arabia' },
    SEARCH_RADIUS_KM: 50
  },
  WEB_PUSH: { VAPID_PUBLIC_KEY: 'YOUR_VAPID_PUBLIC_KEY_HERE', SERVICE_WORKER_PATH: '/sw.js', NOTIFICATION_PERMISSION: 'default', AUTO_SUBSCRIBE: true },
  SYSTEM: { REFRESH_INTERVAL_MS: 15000, LOCATION_WATCH_INTERVAL_MS: 5000, MAX_LOG_ENTRIES: 50, SESSION_TIMEOUT_MS: 3600000, PIN_LENGTH: 4, MAX_LOGIN_ATTEMPTS: 5, CACHE_VERSION: 'v4.0.0', APP_VERSION: '1.0.0' },
  COLORS: { PRIMARY: '#00f0ff', SUCCESS: '#00ff66', DANGER: '#ff0055', WARNING: '#ffcc00', BACKGROUND: '#05050a', CARD: '#0b0f19' },
  DRIVER: {
    MAX_DISTANCE_KM: 30, IDLE_TIMEOUT_MS: 300000, MIN_RATING: 3.0, MAX_ACTIVE_ORDERS: 3,
    LEVELS: [
      { min: 0, name: 'مبتدئ', icon: '🌱', color: '#8b5cf6' }, { min: 10, name: 'نشيط', icon: '🏃', color: '#3b82f6' },
      { min: 30, name: 'محترف', icon: '⭐', color: '#eab308' }, { min: 60, name: 'خبير', icon: '🏆', color: '#f97316' },
      { min: 100, name: 'أسطورة', icon: '👑', color: '#ef4444' }, { min: 200, name: 'إمبراطور', icon: '🦁', color: '#ec4899' }
    ]
  },
  RESTAURANT: { MAX_BRANCHES: 10, ORDER_TIMEOUT_MINUTES: 30, AUTO_CANCEL_PENDING_HOURS: 2 },
  PWA: { NAME: 'سايبر توصيل', SHORT_NAME: 'CyberDel', DESCRIPTION: 'نظام توصيل ذكي للرياض', THEME_COLOR: '#05050a', BACKGROUND_COLOR: '#05050a', DISPLAY: 'standalone', ORIENTATION: 'portrait' },
  SECURITY: { ENABLE_RLS: true, ALLOW_UNAUTHENTICATED_READ: true, MAX_REQUEST_RATE: 100, ENABLE_RATE_LIMITING: true, SANITIZE_INPUTS: true },
  ANALYTICS: { ENABLED: true, TRACK_PAGE_VIEWS: true, TRACK_EVENTS: true, RETENTION_DAYS: 90 },
  URLS: { WEBSITE: 'https://cyberdelivery.sa', SUPPORT_EMAIL: 'support@cyberdelivery.sa', SUPPORT_PHONE: '+966500000000', PRIVACY_POLICY: '/privacy.html', TERMS_OF_SERVICE: '/terms.html', GOOGLE_MAPS: 'https://www.google.com/maps/dir/?api=1&destination=', WHATSAPP_SHARE: 'https://api.whatsapp.com/send?text=' }
};

function createSupabaseClient() {
  if (typeof window === 'undefined' || typeof window.supabase === 'undefined') return null;
  return window.supabase.createClient(CONFIG.SUPABASE.URL, CONFIG.SUPABASE.KEY);
}
function getCurrentLanguage() { return localStorage.getItem('cyberLang') || CONFIG.DEFAULT_LANGUAGE; }
function getLanguageConfig(langCode) { return Object.values(CONFIG.LANGUAGES).find(l => l.code === langCode) || CONFIG.LANGUAGES.AR; }
function isRushHour() { return CONFIG.PRICING.RUSH_HOURS.includes(new Date().getHours()); }
function isNightTime() { const h = new Date().getHours(); return h >= CONFIG.PRICING.NIGHT_START_HOUR || h < CONFIG.PRICING.NIGHT_END_HOUR; }
function calculateDeliveryFee(distanceKm) { let f = CONFIG.PRICING.BASE_FEE + (distanceKm * CONFIG.PRICING.PER_KM_FEE); if (isNightTime()) f *= CONFIG.PRICING.NIGHT_MULTIPLIER; if (isRushHour()) f *= CONFIG.PRICING.RUSH_HOUR_MULTIPLIER; return Math.round(f * 100) / 100; }
function calculateDriverShare(totalFee) { return Math.round((totalFee * CONFIG.PRICING.DRIVER_SHARE_PERCENT / 100) * 100) / 100; }
function calculatePlatformShare(totalFee) { return Math.round((totalFee * CONFIG.PRICING.PLATFORM_COMMISSION_PERCENT / 100) * 100) / 100; }
function getDriverLevel(totalDeliveries) { let c = CONFIG.DRIVER.LEVELS[0], n = CONFIG.DRIVER.LEVELS[1]; for (let i = 0; i < CONFIG.DRIVER.LEVELS.length; i++) { if (totalDeliveries >= CONFIG.DRIVER.LEVELS[i].min) { c = CONFIG.DRIVER.LEVELS[i]; n = CONFIG.DRIVER.LEVELS[i + 1] || null; } } return { currentLevel: c, nextLevel: n }; }
function formatCurrency(amount) { return new Intl.NumberFormat('ar-SA', { style: 'decimal', minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(amount) + ' ر.س'; }
function formatTimeAgo(timestamp) { const d = Math.floor((Date.now() - new Date(timestamp)) / 1000); if (d < 60) return 'الآن'; if (d < 3600) return `منذ ${Math.floor(d / 60)} د`; if (d < 86400) return `منذ ${Math.floor(d / 3600)} س`; return `منذ ${Math.floor(d / 86400)} يوم`; }
function calculateDistance(lat1, lon1, lat2, lon2) { const R = 6371; const dLat = (lat2 - lat1) * Math.PI / 180; const dLon = (lon2 - lon1) * Math.PI / 180; const a = Math.sin(dLat / 2) ** 2 + Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) * Math.sin(dLon / 2) ** 2; return R * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a)); }
function sanitizeInput(input) { if (typeof input !== 'string') return input; return input.replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#039;').trim(); }
function isValidSaudiPhone(phone) { return /^(\+966|0)?5\d{8}$/.test(phone.replace(/\s/g, '')); }
function isValidEmail(email) { return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email); }

if (typeof window !== 'undefined') {
  window.CONFIG = CONFIG;
  window.createSupabaseClient = createSupabaseClient;
  window.getCurrentLanguage = getCurrentLanguage;
  window.getLanguageConfig = getLanguageConfig;
  window.isRushHour = isRushHour;
  window.isNightTime = isNightTime;
  window.calculateDeliveryFee = calculateDeliveryFee;
  window.calculateDriverShare = calculateDriverShare;
  window.calculatePlatformShare = calculatePlatformShare;
  window.getDriverLevel = getDriverLevel;
  window.formatCurrency = formatCurrency;
  window.formatTimeAgo = formatTimeAgo;
  window.calculateDistance = calculateDistance;
  window.sanitizeInput = sanitizeInput;
  window.isValidSaudiPhone = isValidSaudiPhone;
  window.isValidEmail = isValidEmail;
  window.db = createSupabaseClient();
}
if (typeof module !== 'undefined' && module.exports) module.exports = { CONFIG, createSupabaseClient };
console.log('[CONFIG] CyberDelivery configuration loaded successfully');
console.log('[CONFIG] App version:', CONFIG.SYSTEM.APP_VERSION);
console.log('[CONFIG] Cache version:', CONFIG.SYSTEM.CACHE_VERSION);
