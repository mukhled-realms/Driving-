<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>CyberDelivery | لوحة الإدارة</title>
<meta name="theme-color" content="#05050a">
<link rel="manifest" href="manifest.json">
<link rel="icon" href="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 512 512'%3E%3Crect fill='%2305050a' width='512' height='512' rx='64'/%3E%3Ctext x='256' y='300' font-size='180' text-anchor='middle' fill='%2300ff66' font-family='Arial' font-weight='bold'%3E🚀%3C/text%3E%3C/svg%3E">
<script src="https://cdn.tailwindcss.com"></script>
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Tajawal:wght@400;700;900&family=Noto+Nastaliq+Urdu:wght@400;700&family=Noto+Sans+Bengali:wght@400;700&family=Noto+Sans+Devanagari:wght@400;700&display=swap" rel="stylesheet">
<style>
* { font-family: 'Tajawal', sans-serif; box-sizing: border-box; }
[lang="ar"], [lang="en"] { font-family: 'Tajawal', sans-serif; }
[lang="ur"] { font-family: 'Noto Nastaliq Urdu', serif; line-height: 2.2; }
[lang="bn"] { font-family: 'Noto Sans Bengali', sans-serif; }
[lang="hi"] { font-family: 'Noto Sans Devanagari', sans-serif; }
body { background: linear-gradient(135deg, #05050a 0%, #0b0f19 50%, #1a0f2e 100%); min-height: 100vh; color: #e5e7eb; }
.neon-cyan { color: #00f0ff; text-shadow: 0 0 10px rgba(0,240,255,0.5); }
.neon-green { color: #00ff66; text-shadow: 0 0 10px rgba(0,255,102,0.5); }
.neon-pink { color: #ff0055; text-shadow: 0 0 10px rgba(255,0,85,0.5); }
.glow-cyan { box-shadow: 0 0 20px rgba(0,240,255,0.25); }
.glow-green { box-shadow: 0 0 20px rgba(0,255,102,0.25); }
.glow-pink { box-shadow: 0 0 20px rgba(255,0,85,0.25); }
@keyframes slideUp { from { transform: translateY(20px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }
.slide-up { animation: slideUp 0.4s ease-out; }
@keyframes pulse-red { 0% { box-shadow: 0 0 0 0 rgba(255,0,85,0.7); } 70% { box-shadow: 0 0 0 15px rgba(255,0,85,0); } 100% { box-shadow: 0 0 0 0 rgba(255,0,85,0); } }
.pulse-red { animation: pulse-red 1.5s infinite; }
.card { background: rgba(11,15,25,0.85); backdrop-filter: blur(10px); border: 1px solid rgba(0,240,255,0.2); border-radius: 20px; }
.btn-primary { background: linear-gradient(135deg, #00f0ff 0%, #00ff66 100%); color: #05050a; font-weight: 900; transition: all 0.2s; }
.btn-primary:hover { transform: translateY(-2px); box-shadow: 0 10px 30px rgba(0,240,255,0.4); }
.btn-primary:active { transform: scale(0.97); }
.input-field { background: rgba(0,0,0,0.4); border: 2px solid rgba(255,255,255,0.1); color: #fff; border-radius: 14px; padding: 14px; width: 100%; transition: all 0.2s; }
.input-field:focus { border-color: #00f0ff; outline: none; box-shadow: 0 0 0 3px rgba(0,240,255,0.2); }
.lang-btn { padding: 8px 12px; border-radius: 10px; font-size: 11px; font-weight: 700; background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); transition: all 0.2s; cursor: pointer; }
.lang-btn.active { background: rgba(0,240,255,0.2); border-color: #00f0ff; color: #00f0ff; }
.sidebar-item { padding: 12px; border-radius: 12px; font-size: 13px; font-weight: 700; background: transparent; border: 1px solid transparent; transition: all 0.2s; cursor: pointer; width: 100%; text-align: right; display: flex; align-items: center; gap: 10px; }
.sidebar-item:hover { background: rgba(0,240,255,0.1); }
.sidebar-item.active { background: rgba(0,240,255,0.2); border-color: #00f0ff; color: #00f0ff; }
#adminMap { height: 400px; border-radius: 16px; z-index: 1; }
.status-badge { display: inline-block; padding: 3px 10px; border-radius: 12px; font-size: 11px; font-weight: 700; }
.status-pending { background: rgba(255,204,0,0.2); color: #ffcc00; border: 1px solid #ffcc00; }
.status-accepted { background: rgba(0,240,255,0.2); color: #00f0ff; border: 1px solid #00f0ff; }
.status-at_store { background: rgba(168,85,247,0.2); color: #a855f7; border: 1px solid #a855f7; }
.status-picked_up { background: rgba(236,72,153,0.2); color: #ec4899; border: 1px solid #ec4899; }
.status-in_transit { background: rgba(59,130,246,0.2); color: #3b82f6; border: 1px solid #3b82f6; }
.status-delivered { background: rgba(0,255,102,0.2); color: #00ff66; border: 1px solid #00ff66; }
.status-cancelled { background: rgba(239,68,68,0.2); color: #ef4444; border: 1px solid #ef4444; }
.stat-card { transition: transform 0.3s; }
.stat-card:hover { transform: translateY(-3px); }
.toast { position: fixed; bottom: 24px; left: 50%; transform: translateX(-50%); padding: 14px 24px; border-radius: 14px; font-weight: 700; z-index: 1000; animation: slideUp 0.3s ease-out; }
.toast-success { background: #00ff66; color: #05050a; }
.toast-error { background: #ff0055; color: #fff; }
.toast-info { background: #00f0ff; color: #05050a; }
::-webkit-scrollbar { width: 6px; }
::-webkit-scrollbar-track { background: #0b0f19; }
::-webkit-scrollbar-thumb { background: #00f0ff; border-radius: 3px; }
</style>
</head>
<body>

<div id="loginScreen" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/90 backdrop-blur-sm">
  <div class="card p-8 w-full max-w-sm glow-cyan text-center">
    <div class="text-6xl mb-4">🛡️</div>
    <h1 class="text-2xl font-black neon-cyan mb-2" data-i18n="adminLogin">لوحة الإدارة</h1>
    <p class="text-xs text-gray-400 mb-6" data-i18n="enterPassword">أدخل كلمة المرور</p>
    <input type="password" id="adminPassword" class="input-field text-center text-xl mb-4" placeholder="••••••••">
    <button onclick="adminLogin()" class="btn-primary w-full py-3 rounded-xl text-lg" data-i18n="login">دخول</button>
    <div class="mt-4 flex justify-center gap-1">
      <button onclick="setLang('ar')" class="lang-btn" data-lang="ar">🇸🇦</button>
      <button onclick="setLang('en')" class="lang-btn" data-lang="en">🇬🇧</button>
      <button onclick="setLang('ur')" class="lang-btn" data-lang="ur">🇵🇰</button>
      <button onclick="setLang('bn')" class="lang-btn" data-lang="bn">🇧🇩</button>
      <button onclick="setLang('hi')" class="lang-btn" data-lang="hi">🇮🇳</button>
    </div>
  </div>
</div>

<div id="adminPanel" class="hidden flex min-h-screen">

  <aside class="w-20 md:w-64 bg-[#0b0f19] border-l border-cyan-500/20 p-4 flex flex-col">
    <div class="text-center mb-8">
      <div class="text-3xl">🛡️</div>
      <h2 class="text-sm font-black neon-cyan mt-2 hidden md:block" data-i18n="adminPanel">لوحة الإدارة</h2>
    </div>
    <nav class="space-y-2 flex-grow">
      <button onclick="switchSection('dashboard')" id="nav-dashboard" class="sidebar-item active"><span class="text-xl">📊</span><span class="hidden md:block" data-i18n="dashboard">نظرة عامة</span></button>
      <button onclick="switchSection('orders')" id="nav-orders" class="sidebar-item"><span class="text-xl">📦</span><span class="hidden md:block" data-i18n="orders">الطلبات</span></button>
      <button onclick="switchSection('drivers')" id="nav-drivers" class="sidebar-item"><span class="text-xl">🚗</span><span class="hidden md:block" data-i18n="drivers">المندوبون</span></button>
      <button onclick="switchSection('restaurants')" id="nav-restaurants" class="sidebar-item"><span class="text-xl">🏪</span><span class="hidden md:block" data-i18n="restaurants">المطاعم</span></button>
      <button onclick="switchSection('emergency')" id="nav-emergency" class="sidebar-item"><span class="text-xl">🚨</span><span class="hidden md:block" data-i18n="emergency">الطوارئ</span><span id="emergencyBadge" class="hidden bg-red-600 text-white text-[10px] px-2 py-0.5 rounded-full mr-auto">0</span></button>
      <button onclick="switchSection('map')" id="nav-map" class="sidebar-item"><span class="text-xl">🗺️</span><span class="hidden md:block" data-i18n="liveMap">الخريطة الحية</span></button>
      <button onclick="switchSection('settings')" id="nav-settings" class="sidebar-item"><span class="text-xl">⚙️</span><span class="hidden md:block" data-i18n="settings">الإعدادات</span></button>
    </nav>
    <button onclick="logout()" class="mt-4 sidebar-item text-red-400 hover:bg-red-500/10"><span class="text-xl">🚪</span><span class="hidden md:block" data-i18n="logout">خروج</span></button>
  </aside>

  <main class="flex-grow p-6 overflow-y-auto">

    <section id="section-dashboard" class="space-y-6">
      <div class="flex items-center justify-between">
        <h1 class="text-2xl font-black" data-i18n="dashboard">📊 نظرة عامة</h1>
        <span class="text-xs text-gray-500" id="lastUpdate" data-i18n="lastUpdate">آخر تحديث: الآن</span>
      </div>
      <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
        <div class="stat-card bg-gradient-to-br from-green-900/40 to-green-800/20 border border-green-500/30 rounded-2xl p-5">
          <div class="text-xs text-gray-400 mb-1" data-i18n="totalOrdersToday">إجمالي الطلبات اليوم</div>
          <div class="text-3xl font-black neon-green" id="statTotalOrders">0</div>
        </div>
        <div class="stat-card bg-gradient-to-br from-cyan-900/40 to-cyan-800/20 border border-cyan-500/30 rounded-2xl p-5">
          <div class="text-xs text-gray-400 mb-1" data-i18n="cashToday">الكاش المحصل اليوم</div>
          <div class="text-3xl font-black neon-cyan" id="statCashToday">0</div>
          <div class="text-xs text-cyan-600 mt-2">💰 <span data-i18n="sar">ر.س</span></div>
        </div>
        <div class="stat-card bg-gradient-to-br from-purple-900/40 to-purple-800/20 border border-purple-500/30 rounded-2xl p-5">
          <div class="text-xs text-gray-400 mb-1" data-i18n="activeDrivers">المندوبون النشطون</div>
          <div class="text-3xl font-black text-purple-400" id="statActiveDrivers">0</div>
        </div>
        <div class="stat-card bg-gradient-to-br from-pink-900/40 to-pink-800/20 border border-pink-500/30 rounded-2xl p-5">
          <div class="text-xs text-gray-400 mb-1" data-i18n="pendingOrders">طلبات في الانتظار</div>
          <div class="text-3xl font-black text-pink-400" id="statPendingOrders">0</div>
        </div>
      </div>
      <div class="grid md:grid-cols-2 gap-6">
        <div class="card p-5 border border-red-500/30">
          <h3 class="text-sm font-black text-red-400 mb-4" data-i18n="activeEmergencies">🚨 تنبيهات طوارئ نشطة</h3>
          <div id="dashEmergencyList" class="space-y-2">
            <div class="text-center text-gray-600 py-6 text-sm" data-i18n="noEmergencies">✅ لا توجد تنبيهات طوارئ</div>
          </div>
        </div>
        <div class="card p-5 border border-cyan-500/30">
          <h3 class="text-sm font-black neon-cyan mb-4" data-i18n="recentOrders">📋 آخر الطلبات</h3>
          <div id="dashRecentOrders" class="space-y-2">
            <div class="text-center text-gray-600 py-6 text-sm" data-i18n="loading">جاري التحميل...</div>
          </div>
        </div>
      </div>
      <div class="card p-5 border border-cyan-500/30">
        <h3 class="text-sm font-black neon-cyan mb-4" data-i18n="statusDistribution">📈 توزيع حالات الطلبات</h3>
        <div id="statusChart" class="flex items-end gap-2 h-40"></div>
        <div id="statusLabels" class="flex justify-between text-[10px] text-gray-500 mt-2"></div>
      </div>
    </section>

    <section id="section-orders" class="hidden space-y-6">
      <div class="flex items-center justify-between">
        <h1 class="text-2xl font-black" data-i18n="manageOrders">📦 إدارة الطلبات</h1>
        <div class="flex gap-2">
          <select id="filterStatus" onchange="loadAdminOrders()" class="input-field text-sm py-2">
            <option value="" data-i18n="allStatuses">كل الحالات</option>
            <option value="pending" data-i18n="statusPending">في الانتظار</option>
            <option value="accepted" data-i18n="statusAccepted">مقبول</option>
            <option value="at_store" data-i18n="statusAtStore">في المحل</option>
            <option value="picked_up" data-i18n="statusPickedUp">تم الاستلام</option>
            <option value="delivered" data-i18n="statusDelivered">تم التوصيل</option>
            <option value="cancelled" data-i18n="statusCancelled">ملغي</option>
          </select>
          <button onclick="loadAdminOrders()" class="btn-primary px-4 py-2 rounded-xl text-sm">🔄</button>
        </div>
      </div>
      <div id="adminOrdersList" class="space-y-3">
        <div class="text-center text-gray-600 py-10" data-i18n="loading">جاري التحميل...</div>
      </div>
    </section>

    <section id="section-drivers" class="hidden space-y-6">
      <div class="flex items-center justify-between">
        <h1 class="text-2xl font-black" data-i18n="manageDrivers">🚗 إدارة المندوبين</h1>
        <span class="text-xs text-gray-500" id="driversCount">0 <span data-i18n="drivers">مندوب</span></span>
      </div>
      <div id="adminDriversList" class="grid md:grid-cols-2 gap-4">
        <div class="text-center text-gray-600 py-10 col-span-2" data-i18n="loading">جاري التحميل...</div>
      </div>
    </section>

    <section id="section-restaurants" class="hidden space-y-6">
      <div class="flex items-center justify-between">
        <h1 class="text-2xl font-black" data-i18n="manageRestaurants">🏪 إدارة المطاعم</h1>
        <button onclick="showAddRestaurantModal()" class="btn-primary px-4 py-2 rounded-xl text-sm">➕ <span data-i18n="addRestaurant">إضافة مطعم</span></button>
      </div>
      <div id="adminRestaurantsList" class="grid md:grid-cols-2 gap-4">
        <div class="text-center text-gray-600 py-10 col-span-2" data-i18n="loading">جاري التحميل...</div>
      </div>
    </section>

    <section id="section-emergency" class="hidden space-y-6">
      <h1 class="text-2xl font-black text-red-400" data-i18n="manageEmergency">🚨 إدارة الطوارئ</h1>
      <div id="emergencyList" class="space-y-3">
        <div class="text-center text-gray-600 py-10" data-i18n="loading">جاري التحميل...</div>
      </div>
    </section>

    <section id="section-map" class="hidden space-y-6">
      <h1 class="text-2xl font-black" data-i18n="liveMap">🗺️ الخريطة الحية</h1>
      <div class="card p-4 border border-cyan-500/30">
        <div class="flex gap-2 mb-3 flex-wrap">
          <button onclick="showAllDriversOnMap()" class="px-4 py-2 rounded-xl bg-green-600 text-white text-sm font-bold" data-i18n="showDrivers">🚗 المندوبون</button>
          <button onclick="showPendingOnMap()" class="px-4 py-2 rounded-xl bg-yellow-600 text-white text-sm font-bold" data-i18n="showPending">📦 طلبات معلقة</button>
          <button onclick="showDeliveredOnMap()" class="px-4 py-2 rounded-xl bg-cyan-600 text-white text-sm font-bold" data-i18n="showDelivered">✅ تم توصيلها</button>
        </div>
        <div id="adminMap"></div>
      </div>
    </section>

    <section id="section-settings" class="hidden space-y-6">
      <h1 class="text-2xl font-black" data-i18n="settings">⚙️ الإعدادات</h1>
      <div class="grid md:grid-cols-2 gap-6">
        <div class="card p-5 border border-cyan-500/30 space-y-4">
          <h3 class="text-sm font-black neon-cyan" data-i18n="systemSettings">🔧 إعدادات النظام</h3>
          <div>
            <label class="text-xs text-gray-400 block mb-1" data-i18n="platformCommission">عمولة المنصة (%)</label>
            <input type="number" id="platformCommission" value="15" class="input-field">
          </div>
          <div>
            <label class="text-xs text-gray-400 block mb-1" data-i18n="baseDeliveryFee">رسوم التوصيل الأساسية (ر.س)</label>
            <input type="number" id="baseDeliveryFee" value="10" class="input-field">
          </div>
          <div>
            <label class="text-xs text-gray-400 block mb-1" data-i18n="perKmFee">رسوم كل كيلومتر (ر.س)</label>
            <input type="number" id="perKmFee" value="2" step="0.5" class="input-field">
          </div>
          <button onclick="saveSettings()" class="btn-primary w-full py-3 rounded-xl" data-i18n="saveSettings">💾 حفظ الإعدادات</button>
        </div>
        <div class="card p-5 border border-red-500/30 space-y-4">
          <h3 class="text-sm font-black text-red-400" data-i18n="dangerZone">⚠️ منطقة الخطر</h3>
          <button onclick="cancelAllPending()" class="w-full py-3 rounded-xl bg-red-600/20 border border-red-600 text-red-400 font-bold" data-i18n="cancelAllPending">❌ إلغاء جميع الطلبات المعلقة</button>
          <button onclick="exportData()" class="w-full py-3 rounded-xl bg-yellow-600/20 border border-yellow-600 text-yellow-400 font-bold" data-i18n="exportData">📥 تصدير البيانات (JSON)</button>
          <button onclick="clearAllData()" class="w-full py-3 rounded-xl bg-red-900/40 border-2 border-red-600 text-red-300 font-bold" data-i18n="clearAllData">🗑️ مسح جميع البيانات</button>
        </div>
        <div class="card p-5 border border-green-500/30 space-y-3 md:col-span-2">
          <h3 class="text-sm font-black neon-green" data-i18n="systemLinks">🔗 روابط النظام</h3>
          <div class="grid grid-cols-2 md:grid-cols-4 gap-3 text-sm">
            <a href="index.html" class="bg-green-600/20 border border-green-600 text-green-400 p-3 rounded-xl text-center font-bold hover:bg-green-600/30 transition" data-i18n="restaurantPanel">🏪 لوحة المطعم</a>
            <a href="driver.html" class="bg-cyan-600/20 border border-cyan-600 text-cyan-400 p-3 rounded-xl text-center font-bold hover:bg-cyan-600/30 transition" data-i18n="driverApp">🚗 تطبيق المندوب</a>
            <a href="track.html" class="bg-purple-600/20 border border-purple-600 text-purple-400 p-3 rounded-xl text-center font-bold hover:bg-purple-600/30 transition" data-i18n="customerTrack">📍 تتبع العميل</a>
            <button onclick="copyAdminLink()" class="bg-pink-600/20 border border-pink-600 text-pink-400 p-3 rounded-xl text-center font-bold hover:bg-pink-600/30 transition" data-i18n="copyAdminLink">🔗 نسخ رابط الإدارة</button>
          </div>
        </div>
      </div>
    </section>

  </main>
</div>

<div id="orderModal" class="hidden fixed inset-0 z-50 bg-black/80 backdrop-blur-sm flex items-center justify-center p-4">
  <div class="card p-6 w-full max-w-lg slide-up max-h-[90vh] overflow-y-auto">
    <div class="flex items-center justify-between mb-4">
      <h3 class="text-xl font-black neon-cyan" data-i18n="orderDetails">📦 تفاصيل الطلب</h3>
      <button onclick="closeOrderModal()" class="text-gray-500 hover:text-white text-2xl">✕</button>
    </div>
    <div id="orderModalContent"></div>
  </div>
</div>

<div id="restaurantModal" class="hidden fixed inset-0 z-50 bg-black/80 backdrop-blur-sm flex items-center justify-center p-4">
  <div class="card p-6 w-full max-w-md slide-up">
    <div class="flex items-center justify-between mb-4">
      <h3 class="text-xl font-black neon-green" data-i18n="addNewRestaurant">🏪 إضافة مطعم جديد</h3>
      <button onclick="closeRestaurantModal()" class="text-gray-500 hover:text-white text-2xl">✕</button>
    </div>
    <div class="space-y-3">
      <input type="text" id="restName" class="input-field" placeholder="اسم المطعم" data-i18n-placeholder="restaurantName">
      <input type="text" id="restPhone" class="input-field" placeholder="رقم الجوال" data-i18n-placeholder="phoneNumber">
      <input type="text" id="restAddress" class="input-field" placeholder="العنوان" data-i18n-placeholder="address">
      <div class="grid grid-cols-2 gap-2">
        <input type="number" id="restLat" placeholder="خط العرض" step="0.0001" class="input-field" data-i18n-placeholder="latitude">
        <input type="number" id="restLng" placeholder="خط الطول" step="0.0001" class="input-field" data-i18n-placeholder="longitude">
      </div>
      <button onclick="addRestaurant()" class="btn-primary w-full py-3 rounded-xl" data-i18n="add">✅ إضافة</button>
    </div>
  </div>
</div>

<div id="toastContainer" class="fixed top-4 left-1/2 -translate-x-1/2 z-[2000] space-y-2"></div>

<script>
const SUPABASE_URL = 'https://hhljyqelqnsltmasxgqv.supabase.co';
const SUPABASE_KEY = 'sb_publishable_Xeo54iI9kxJ0n00f71A_yA_QNvmRC3H';
const db = window.supabase.createClient(SUPABASE_URL, SUPABASE_KEY);
const ADMIN_PASSWORD = 'admin2026';

const I18N = {
  ar: { dir: 'rtl', adminLogin: 'لوحة الإدارة', enterPassword: 'أدخل كلمة المرور', login: 'دخول', logout: 'خروج', adminPanel: 'لوحة الإدارة', dashboard: '📊 نظرة عامة', orders: 'الطلبات', drivers: 'المندوبون', restaurants: 'المطاعم', emergency: 'الطوارئ', liveMap: 'الخريطة الحية', settings: 'الإعدادات', lastUpdate: 'آخر تحديث: الآن', totalOrdersToday: 'إجمالي الطلبات اليوم', cashToday: 'الكاش المحصل اليوم', sar: 'ر.س', activeDrivers: 'المندوبون النشطون', pendingOrders: 'طلبات في الانتظار', activeEmergencies: '🚨 تنبيهات طوارئ نشطة', noEmergencies: '✅ لا توجد تنبيهات طوارئ', recentOrders: '📋 آخر الطلبات', loading: 'جاري التحميل...', statusDistribution: '📈 توزيع حالات الطلبات', manageOrders: '📦 إدارة الطلبات', allStatuses: 'كل الحالات', statusPending: 'في الانتظار', statusAccepted: 'مقبول', statusAtStore: 'في المحل', statusPickedUp: 'تم الاستلام', statusDelivered: 'تم التوصيل', statusCancelled: 'ملغي', manageDrivers: '🚗 إدارة المندوبين', manageRestaurants: '🏪 إدارة المطاعم', addRestaurant: 'إضافة مطعم', manageEmergency: '🚨 إدارة الطوارئ', showDrivers: '🚗 المندوبون', showPending: '📦 طلبات معلقة', showDelivered: '✅ تم توصيلها', systemSettings: '🔧 إعدادات النظام', platformCommission: 'عمولة المنصة (%)', baseDeliveryFee: 'رسوم التوصيل الأساسية (ر.س)', perKmFee: 'رسوم كل كيلومتر (ر.س)', saveSettings: '💾 حفظ الإعدادات', dangerZone: '⚠️ منطقة الخطر', cancelAllPending: '❌ إلغاء جميع الطلبات المعلقة', exportData: '📥 تصدير البيانات (JSON)', clearAllData: '🗑️ مسح جميع البيانات', systemLinks: '🔗 روابط النظام', restaurantPanel: '🏪 لوحة المطعم', driverApp: '🚗 تطبيق المندوب', customerTrack: '📍 تتبع العميل', copyAdminLink: '🔗 نسخ رابط الإدارة', orderDetails: '📦 تفاصيل الطلب', addNewRestaurant: '🏪 إضافة مطعم جديد', restaurantName: 'اسم المطعم', phoneNumber: 'رقم الجوال', address: 'العنوان', latitude: 'خط العرض', longitude: 'خط الطول', add: '✅ إضافة', orderStatus: { pending: 'في الانتظار', accepted: 'مقبول', at_store: 'في المحل', picked_up: 'تم الاستلام', in_transit: 'في الطريق', delivered: 'تم التوصيل', cancelled: 'ملغي' }, noOrders: 'لا توجد طلبات', noDrivers: 'لا يوجد مندوبون', noRestaurants: 'لا توجد مطاعم', noEmergenciesList: '✅ لا توجد تنبيهات طوارئ', confirmCancel: 'هل أنت متأكد من إلغاء هذا الطلب؟', confirmCancelAll: '⚠️ هل أنت متأكد؟ سيتم إلغاء جميع الطلبات المعلقة!', confirmClear: '🗑️ تحذير! سيتم مسح جميع البيانات نهائياً. هل أنت متأكد؟', confirmClear2: '⚠️ التأكيد الأخير: هذا الإجراء لا يمكن التراجع عنه!', orderCancelled: '✅ تم إلغاء الطلب', allCancelled: '❌ تم إلغاء جميع الطلبات المعلقة', dataExported: '📥 تم تصدير البيانات', dataCleared: '🗑️ تم مسح البيانات', settingsSaved: '💾 تم حفظ الإعدادات', linkCopied: '🔗 تم نسخ رابط الإدارة', restaurantAdded: '✅ تم إضافة المطعم', restaurantDeleted: '🗑️ تم حذف المطعم', driverBlocked: '🚫 تم حظر المندوب', driverUnblocked: '✅ تم فك الحظر', emergencyResponded: '📞 تم الرد على التنبيه', emergencyResolved: '✅ تم حل التنبيه', newEmergency: '🚨 تنبيه طوارئ جديد!', blockReason: 'سبب الحظر:', call: 'اتصال', block: '🚫 حظر', unblock: '✅ فك الحظر', delete: '🗑️ حذف', activate: '▶️ تفعيل', deactivate: '⏸️ إيقاف', totalDeliveries: 'توصيلة', totalEarnings: 'ريال', rating: 'تقييم', blocked: 'محظور', online: 'متصل', offline: 'غير متصل', active: 'نشط', responded: 'تم الرد', resolved: 'تم الحل', respond: '📞 رد', resolve: '✅ حل', openInMaps: 'فتح في خرائط جوجل', trackingCode: '🔗 رمز التتبع', copy: '📋 نسخ', notes: '💬 ملاحظات', customer: '👤 العميل', restaurant: '🏪 المطعم', driver: '🚗 المندوب', financial: '💰 المالية', orderValue: 'قيمة الطلب:', deliveryFee: 'رسوم التوصيل:', total: 'الإجمالي:', cashCollected: '💵 تم تحصيل:', close: 'إغلاق', cancel: '❌ إلغاء', view: '👁️', now: 'الآن', minAgo: 'د', hoursAgo: 'س', daysAgo: 'يوم' },
  en: { dir: 'ltr', adminLogin: 'Admin Panel', enterPassword: 'Enter password', login: 'Login', logout: 'Logout', adminPanel: 'Admin Panel', dashboard: '📊 Dashboard', orders: 'Orders', drivers: 'Drivers', restaurants: 'Restaurants', emergency: 'Emergency', liveMap: 'Live Map', settings: 'Settings', lastUpdate: 'Last update: now', totalOrdersToday: "Today's Total Orders", cashToday: "Today's Cash Collected", sar: 'SAR', activeDrivers: 'Active Drivers', pendingOrders: 'Pending Orders', activeEmergencies: '🚨 Active Emergencies', noEmergencies: '✅ No emergencies', recentOrders: '📋 Recent Orders', loading: 'Loading...', statusDistribution: '📈 Status Distribution', manageOrders: '📦 Manage Orders', allStatuses: 'All Statuses', statusPending: 'Pending', statusAccepted: 'Accepted', statusAtStore: 'At Store', statusPickedUp: 'Picked Up', statusDelivered: 'Delivered', statusCancelled: 'Cancelled', manageDrivers: '🚗 Manage Drivers', manageRestaurants: '🏪 Manage Restaurants', addRestaurant: 'Add Restaurant', manageEmergency: '🚨 Manage Emergency', showDrivers: '🚗 Drivers', showPending: '📦 Pending', showDelivered: '✅ Delivered', systemSettings: '🔧 System Settings', platformCommission: 'Platform Commission (%)', baseDeliveryFee: 'Base Delivery Fee (SAR)', perKmFee: 'Per KM Fee (SAR)', saveSettings: '💾 Save Settings', dangerZone: '⚠️ Danger Zone', cancelAllPending: '❌ Cancel All Pending', exportData: '📥 Export Data (JSON)', clearAllData: '🗑️ Clear All Data', systemLinks: '🔗 System Links', restaurantPanel: '🏪 Restaurant Panel', driverApp: '🚗 Driver App', customerTrack: '📍 Customer Track', copyAdminLink: '🔗 Copy Admin Link', orderDetails: '📦 Order Details', addNewRestaurant: '🏪 Add New Restaurant', restaurantName: 'Restaurant Name', phoneNumber: 'Phone Number', address: 'Address', latitude: 'Latitude', longitude: 'Longitude', add: '✅ Add', orderStatus: { pending: 'Pending', accepted: 'Accepted', at_store: 'At Store', picked_up: 'Picked Up', in_transit: 'In Transit', delivered: 'Delivered', cancelled: 'Cancelled' }, noOrders: 'No orders', noDrivers: 'No drivers', noRestaurants: 'No restaurants', noEmergenciesList: '✅ No emergencies', confirmCancel: 'Are you sure you want to cancel this order?', confirmCancelAll: '⚠️ Are you sure? All pending orders will be cancelled!', confirmClear: '🗑️ Warning! All data will be permanently deleted. Are you sure?', confirmClear2: '⚠️ Final confirmation: This action cannot be undone!', orderCancelled: '✅ Order cancelled', allCancelled: '❌ All pending orders cancelled', dataExported: '📥 Data exported', dataCleared: '🗑️ Data cleared', settingsSaved: '💾 Settings saved', linkCopied: '🔗 Admin link copied', restaurantAdded: '✅ Restaurant added', restaurantDeleted: '🗑️ Restaurant deleted', driverBlocked: '🚫 Driver blocked', driverUnblocked: '✅ Driver unblocked', emergencyResponded: '📞 Emergency responded', emergencyResolved: '✅ Emergency resolved', newEmergency: '🚨 New emergency alert!', blockReason: 'Block reason:', call: 'Call', block: '🚫 Block', unblock: '✅ Unblock', delete: '🗑️ Delete', activate: '▶️ Activate', deactivate: '⏸️ Deactivate', totalDeliveries: 'deliveries', totalEarnings: 'SAR', rating: 'rating', blocked: 'Blocked', online: 'Online', offline: 'Offline', active: 'Active', responded: 'Responded', resolved: 'Resolved', respond: '📞 Respond', resolve: '✅ Resolve', openInMaps: 'Open in Google Maps', trackingCode: '🔗 Tracking Code', copy: '📋 Copy', notes: '💬 Notes', customer: '👤 Customer', restaurant: '🏪 Restaurant', driver: '🚗 Driver', financial: '💰 Financial', orderValue: 'Order Value:', deliveryFee: 'Delivery Fee:', total: 'Total:', cashCollected: '💵 Cash Collected:', close: 'Close', cancel: '❌ Cancel', view: '👁️', now: 'Now', minAgo: 'm', hoursAgo: 'h', daysAgo: 'd' },
  ur: { dir: 'rtl', adminLogin: 'ایڈمن پینل', enterPassword: 'پاس ورڈ درج کریں', login: 'لاگ ان', logout: 'لاگ آؤٹ', adminPanel: 'ایڈمن پینل', dashboard: '📊 ڈیش بورڈ', orders: 'آرڈرز', drivers: 'ڈرائیور', restaurants: 'ریسٹورنٹ', emergency: 'ایمرجنسی', liveMap: 'لائیو نقشہ', settings: 'سیٹنگز', lastUpdate: 'آخری اپ ڈیٹ: ابھی', totalOrdersToday: 'آج کے کل آرڈرز', cashToday: 'آج کی نقد رقم', sar: 'ریال', activeDrivers: 'فعال ڈرائیور', pendingOrders: 'زیر التواء آرڈرز', activeEmergencies: '🚨 فعال ایمرجنسی', noEmergencies: '✅ کوئی ایمرجنسی نہیں', recentOrders: '📋 حالیہ آرڈرز', loading: 'لوڈ ہو رہا...', statusDistribution: '📈 حالت کی تقسیم', manageOrders: '📦 آرڈرز کا انتظام', allStatuses: 'تمام حالتیں', statusPending: 'زیر التواء', statusAccepted: 'قبول', statusAtStore: 'دکان پر', statusPickedUp: 'اٹھا لیا', statusDelivered: 'پہنچا دیا', statusCancelled: 'منسوخ', manageDrivers: '🚗 ڈرائیورز کا انتظام', manageRestaurants: '🏪 ریسٹورنٹس کا انتظام', addRestaurant: 'ریسٹورنٹ شامل کریں', manageEmergency: '🚨 ایمرجنسی کا انتظام', showDrivers: '🚗 ڈرائیور', showPending: '📦 زیر التواء', showDelivered: '✅ پہنچا دیا', systemSettings: '🔧 سسٹم سیٹنگز', platformCommission: 'پلیٹ فارم کمیشن (%)', baseDeliveryFee: 'بنیادی ڈیلیوری فیس (ریال)', perKmFee: 'فی کلومیٹر فیس (ریال)', saveSettings: '💾 سیٹنگز محفوظ کریں', dangerZone: '⚠️ خطرہ زون', cancelAllPending: '❌ تمام زیر التواء منسوخ کریں', exportData: '📥 ڈیٹا ایکسپورٹ (JSON)', clearAllData: '🗑️ تمام ڈیٹا صاف کریں', systemLinks: '🔗 سسٹم لنکس', restaurantPanel: '🏪 ریسٹورنٹ پینل', driverApp: '🚗 ڈرائیور ایپ', customerTrack: '📍 کسٹمر ٹریک', copyAdminLink: '🔗 ایڈمن لنک کاپی', orderDetails: '📦 آرڈر کی تفصیلات', addNewRestaurant: '🏪 نیا ریسٹورنٹ شامل کریں', restaurantName: 'ریسٹورنٹ کا نام', phoneNumber: 'فون نمبر', address: 'پتہ', latitude: 'عرض البلد', longitude: 'طول البلد', add: '✅ شامل کریں', orderStatus: { pending: 'زیر التواء', accepted: 'قبول', at_store: 'دکان پر', picked_up: 'اٹھا لیا', in_transit: 'راستے میں', delivered: 'پہنچا دیا', cancelled: 'منسوخ' }, noOrders: 'کوئی آرڈر نہیں', noDrivers: 'کوئی ڈرائیور نہیں', noRestaurants: 'کوئی ریسٹورنٹ نہیں', noEmergenciesList: '✅ کوئی ایمرجنسی نہیں', confirmCancel: 'کیا آپ اس آرڈر کو منسوخ کرنا چاہتے ہیں؟', confirmCancelAll: '⚠️ کیا آپ یقینی ہیں؟ تمام زیر التواء آرڈرز منسوخ ہو جائیں گے!', confirmClear: '🗑️ انتباہ! تمام ڈیٹا مستقل طور پر حذف ہو جائے گا۔', confirmClear2: '⚠️ آخری تصدیق: یہ عمل واپس نہیں کیا جا سکتا!', orderCancelled: '✅ آرڈر منسوخ', allCancelled: '❌ تمام زیر التواء منسوخ', dataExported: '📥 ڈیٹا ایکسپورٹ', dataCleared: '🗑️ ڈیٹا صاف', settingsSaved: '💾 سیٹنگز محفوظ', linkCopied: '🔗 ایڈمن لنک کاپی', restaurantAdded: '✅ ریسٹورنٹ شامل', restaurantDeleted: '🗑️ ریسٹورنٹ حذف', driverBlocked: '🚫 ڈرائیور بلاک', driverUnblocked: '✅ ڈرائیور ان بلاک', emergencyResponded: '📞 ایمرجنسی کا جواب', emergencyResolved: '✅ ایمرجنسی حل', newEmergency: '🚨 نئی ایمرجنسی!', blockReason: 'بلاک کی وجہ:', call: 'کال', block: '🚫 بلاک', unblock: '✅ ان بلاک', delete: '🗑️ حذف', activate: '▶️ فعال', deactivate: '⏸️ غیر فعال', totalDeliveries: 'ڈیلیوری', totalEarnings: 'ریال', rating: 'درجہ بندی', blocked: 'بلاک', online: 'آن لائن', offline: 'آف لائن', active: 'فعال', responded: 'جواب دیا', resolved: 'حل', respond: '📞 جواب', resolve: '✅ حل', openInMaps: 'گوگل میپس میں کھولیں', trackingCode: '🔗 ٹریکنگ کوڈ', copy: '📋 کاپی', notes: '💬 نوٹس', customer: '👤 گاہک', restaurant: '🏪 ریسٹورنٹ', driver: '🚗 ڈرائیور', financial: '💰 مالی', orderValue: 'آرڈر کی قیمت:', deliveryFee: 'ڈیلیوری فیس:', total: 'کل:', cashCollected: '💵 نقد رقم:', close: 'بند', cancel: '❌ منسوخ', view: '👁️', now: 'ابھی', minAgo: 'م', hoursAgo: 'گھ', daysAgo: 'د' },
  bn: { dir: 'ltr', adminLogin: 'অ্যাডমিন প্যানেল', enterPassword: 'পাসওয়ার্ড দিন', login: 'লগইন', logout: 'লগআউট', adminPanel: 'অ্যাডমিন প্যানেল', dashboard: '📊 ড্যাশবোর্ড', orders: 'অর্ডার', drivers: 'ড্রাইভার', restaurants: 'রেস্তোরাঁ', emergency: 'জরুরি', liveMap: 'লাইভ মানচিত্র', settings: 'সেটিংস', lastUpdate: 'শেষ আপডেট: এখন', totalOrdersToday: 'আজকের মোট অর্ডার', cashToday: 'আজকের নগদ', sar: 'রিয়াল', activeDrivers: 'সক্রিয় ড্রাইভার', pendingOrders: 'অপেক্ষমাণ অর্ডার', activeEmergencies: '🚨 সক্রিয় জরুরি', noEmergencies: '✅ কোনো জরুরি নেই', recentOrders: '📋 সাম্প্রতিক অর্ডার', loading: 'লোড হচ্ছে...', statusDistribution: '📈 অবস্থা বিতরণ', manageOrders: '📦 অর্ডার ব্যবস্থাপনা', allStatuses: 'সব অবস্থা', statusPending: 'অপেক্ষমাণ', statusAccepted: 'গৃহীত', statusAtStore: 'দোকানে', statusPickedUp: 'নেওয়া', statusDelivered: 'পৌঁছে', statusCancelled: 'বাতিল', manageDrivers: '🚗 ড্রাইভার ব্যবস্থাপনা', manageRestaurants: '🏪 রেস্তোরাঁ ব্যবস্থাপনা', addRestaurant: 'রেস্তোরাঁ যোগ', manageEmergency: '🚨 জরুরি ব্যবস্থাপনা', showDrivers: '🚗 ড্রাইভার', showPending: '📦 অপেক্ষমাণ', showDelivered: '✅ পৌঁছে', systemSettings: '🔧 সিস্টেম সেটিংস', platformCommission: 'প্ল্যাটফর্ম কমিশন (%)', baseDeliveryFee: 'মূল ডেলিভারি ফি (রিয়াল)', perKmFee: 'প্রতি কিমি ফি (রিয়াল)', saveSettings: '💾 সেটিংস সংরক্ষণ', dangerZone: '⚠️ বিপদ অঞ্চল', cancelAllPending: '❌ সব অপেক্ষমাণ বাতিল', exportData: '📥 ডেটা রপ্তানি (JSON)', clearAllData: '🗑️ সব ডেটা মুছুন', systemLinks: '🔗 সিস্টেম লিংক', restaurantPanel: '🏪 রেস্তোরাঁ প্যানেল', driverApp: '🚗 ড্রাইভার অ্যাপ', customerTrack: '📍 গ্রাহক ট্র্যাক', copyAdminLink: '🔗 অ্যাডমিন লিংক কপি', orderDetails: '📦 অর্ডার বিবরণ', addNewRestaurant: '🏪 নতুন রেস্তোরাঁ যোগ', restaurantName: 'রেস্তোরাঁর নাম', phoneNumber: 'ফোন নম্বর', address: 'ঠিকানা', latitude: 'অক্ষাংশ', longitude: 'দ্রাঘিমাংশ', add: '✅ যোগ', orderStatus: { pending: 'অপেক্ষমাণ', accepted: 'গৃহীত', at_store: 'দোকানে', picked_up: 'নেওয়া', in_transit: 'পথে', delivered: 'পৌঁছে', cancelled: 'বাতিল' }, noOrders: 'কোনো অর্ডার নেই', noDrivers: 'কোনো ড্রাইভার নেই', noRestaurants: 'কোনো রেস্তোরাঁ নেই', noEmergenciesList: '✅ কোনো জরুরি নেই', confirmCancel: 'আপনি কি এই অর্ডার বাতিল করতে চান?', confirmCancelAll: '⚠️ আপনি কি নিশ্চিত? সব অপেক্ষমাণ অর্ডার বাতিল হবে!', confirmClear: '🗑️ সতর্কতা! সব ডেটা স্থায়ীভাবে মুছে যাবে।', confirmClear2: '⚠️ চূড়ান্ত নিশ্চিতকরণ: এই কাজ পূর্বাবস্থায় ফেরানো যাবে না!', orderCancelled: '✅ অর্ডার বাতিল', allCancelled: '❌ সব অপেক্ষমাণ বাতিল', dataExported: '📥 ডেটা রপ্তানি', dataCleared: '🗑️ ডেটা মুছে', settingsSaved: '💾 সেটিংস সংরক্ষিত', linkCopied: '🔗 অ্যাডমিন লিংক কপি', restaurantAdded: '✅ রেস্তোরাঁ যোগ', restaurantDeleted: '🗑️ রেস্তোরাঁ মুছে', driverBlocked: '🚫 ড্রাইভার ব্লক', driverUnblocked: '✅ ড্রাইভার আনব্লক', emergencyResponded: '📞 জরুরি সাড়া', emergencyResolved: '✅ জরুরি সমাধান', newEmergency: '🚨 নতুন জরুরি সতর্কতা!', blockReason: 'ব্লকের কারণ:', call: 'কল', block: '🚫 ব্লক', unblock: '✅ আনব্লক', delete: '🗑️ মুছুন', activate: '▶️ সক্রিয়', deactivate: '⏸️ নিষ্ক্রিয়', totalDeliveries: 'ডেলিভারি', totalEarnings: 'রিয়াল', rating: 'রেটিং', blocked: 'ব্লক', online: 'অনলাইন', offline: 'অফলাইন', active: 'সক্রিয়', responded: 'সাড়া', resolved: 'সমাধান', respond: '📞 সাড়া', resolve: '✅ সমাধান', openInMaps: 'গুগল ম্যাপে খুলুন', trackingCode: '🔗 ট্র্যাকিং কোড', copy: '📋 কপি', notes: '💬 নোট', customer: '👤 গ্রাহক', restaurant: '🏪 রেস্তোরাঁ', driver: '🚗 ড্রাইভার', financial: '💰 আর্থিক', orderValue: 'অর্ডার মূল্য:', deliveryFee: 'ডেলিভারি ফি:', total: 'মোট:', cashCollected: '💵 নগদ সংগৃহীত:', close: 'বন্ধ', cancel: '❌ বাতিল', view: '👁️', now: 'এখন', minAgo: 'মি', hoursAgo: 'ঘ', daysAgo: 'দ' },
  hi: { dir: 'ltr', adminLogin: 'एडमिन पैनल', enterPassword: 'पासवर्ड दर्ज करें', login: 'लॉगिन', logout: 'लॉगआउट', adminPanel: 'एडमिन पैनल', dashboard: '📊 डैशबोर्ड', orders: 'ऑर्डर', drivers: 'ड्राइवर', restaurants: 'रेस्तरां', emergency: 'आपातकाल', liveMap: 'लाइव मानचित्र', settings: 'सेटिंग्स', lastUpdate: 'अंतिम अपडेट: अभी', totalOrdersToday: 'आज के कुल ऑर्डर', cashToday: 'आज की नकद', sar: 'रियाल', activeDrivers: 'सक्रिय ड्राइवर', pendingOrders: 'लंबित ऑर्डर', activeEmergencies: '🚨 सक्रिय आपातकाल', noEmergencies: '✅ कोई आपातकाल नहीं', recentOrders: '📋 हाल के ऑर्डर', loading: 'लोड हो रहा...', statusDistribution: '📈 स्थिति वितरण', manageOrders: '📦 ऑर्डर प्रबंधन', allStatuses: 'सभी स्थितियां', statusPending: 'लंबित', statusAccepted: 'स्वीकृत', statusAtStore: 'दुकान पर', statusPickedUp: 'ले लिया', statusDelivered: 'पहुँचा', statusCancelled: 'रद्द', manageDrivers: '🚗 ड्राइवर प्रबंधन', manageRestaurants: '🏪 रेस्तरां प्रबंधन', addRestaurant: 'रेस्तरां जोड़ें', manageEmergency: '🚨 आपातकाल प्रबंधन', showDrivers: '🚗 ड्राइवर', showPending: '📦 लंबित', showDelivered: '✅ पहुँचा', systemSettings: '🔧 सिस्टम सेटिंग्स', platformCommission: 'प्लेटफॉर्म कमीशन (%)', baseDeliveryFee: 'मूल डिलीवरी शुल्क (रियाल)', perKmFee: 'प्रति किमी शुल्क (रियाल)', saveSettings: '💾 सेटिंग्स सहेजें', dangerZone: '⚠️ खतरा क्षेत्र', cancelAllPending: '❌ सभी लंबित रद्द करें', exportData: '📥 डेटा निर्यात (JSON)', clearAllData: '🗑️ सभी डेटा साफ़', systemLinks: '🔗 सिस्टम लिंक', restaurantPanel: '🏪 रेस्तरां पैनल', driverApp: '🚗 ड्राइवर ऐप', customerTrack: '📍 ग्राहक ट्रैक', copyAdminLink: '🔗 एडमिन लिंक कॉपी', orderDetails: '📦 ऑर्डर विवरण', addNewRestaurant: '🏪 नया रेस्तरां जोड़ें', restaurantName: 'रेस्तरां का नाम', phoneNumber: 'फ़ोन नंबर', address: 'पता', latitude: 'अक्षांश', longitude: 'देशांतर', add: '✅ जोड़ें', orderStatus: { pending: 'लंबित', accepted: 'स्वीकृत', at_store: 'दुकान पर', picked_up: 'ले लिया', in_transit: 'रास्ते में', delivered: 'पहुँचा', cancelled: 'रद्द' }, noOrders: 'कोई ऑर्डर नहीं', noDrivers: 'कोई ड्राइवर नहीं', noRestaurants: 'कोई रेस्तरां नहीं', noEmergenciesList: '✅ कोई आपातकाल नहीं', confirmCancel: 'क्या आप इस ऑर्डर को रद्द करना चाहते हैं?', confirmCancelAll: '⚠️ क्या आप सुनिश्चित हैं? सभी लंबित ऑर्डर रद्द हो जाएंगे!', confirmClear: '🗑️ चेतावनी! सभी डेटा स्थायी रूप से हटा दिया जाएगा।', confirmClear2: '⚠️ अंतिम पुष्टि: यह क्रिया पूर्ववत नहीं की जा सकती!', orderCancelled: '✅ ऑर्डर रद्द', allCancelled: '❌ सभी लंबित रद्द', dataExported: '📥 डेटा निर्यात', dataCleared: '🗑️ डेटा साफ़', settingsSaved: '💾 सेटिंग्स सहेजी', linkCopied: '🔗 एडमिन लिंक कॉपी', restaurantAdded: '✅ रेस्तरां जोड़ा', restaurantDeleted: '🗑️ रेस्तरां हटाया', driverBlocked: '🚫 ड्राइवर ब्लॉक', driverUnblocked: '✅ ड्राइवर अनब्लॉक', emergencyResponded: '📞 आपातकाल प्रतिक्रिया', emergencyResolved: '✅ आपातकाल हल', newEmergency: '🚨 नया आपातकाल अलर्ट!', blockReason: 'ब्लॉक का कारण:', call: 'कॉल', block: '🚫 ब्लॉक', unblock: '✅ अनब्लॉक', delete: '🗑️ हटाएं', activate: '▶️ सक्रिय', deactivate: '⏸️ निष्क्रिय', totalDeliveries: 'डिलीवरी', totalEarnings: 'रियाल', rating: 'रेटिंग', blocked: 'ब्लॉक', online: 'ऑनलाइन', offline: 'ऑफलाइन', active: 'सक्रिय', responded: 'प्रतिक्रिया', resolved: 'हल', respond: '📞 प्रतिक्रिया', resolve: '✅ हल', openInMaps: 'गूगल मैप्स में खोलें', trackingCode: '🔗 ट्रैकिंग कोड', copy: '📋 कॉपी', notes: '💬 नोट्स', customer: '👤 ग्राहक', restaurant: '🏪 रेस्तरां', driver: '🚗 ड्राइवर', financial: '💰 वित्तीय', orderValue: 'ऑर्डर मूल्य:', deliveryFee: 'डिलीवरी शुल्क:', total: 'कुल:', cashCollected: '💵 नकद एकत्रित:', close: 'बंद', cancel: '❌ रद्द', view: '👁️', now: 'अभी', minAgo: 'मि', hoursAgo: 'घं', daysAgo: 'दि' }
};

let currentLang = localStorage.getItem('cyberLang') || 'ar';
let adminMap = null;
let mapMarkers = [];

function t(key) {
  const lang = I18N[currentLang];
  if (!lang) return key;
  const keys = key.split('.');
  let val = lang;
  for (const k of keys) { if (val && typeof val === 'object') val = val[k]; else return key; }
  return val || key;
}

function setLang(lang) {
  currentLang = lang;
  localStorage.setItem('cyberLang', lang);
  document.documentElement.lang = lang;
  document.documentElement.dir = I18N[lang].dir;
  document.querySelectorAll('[data-i18n]').forEach(el => {
    const key = el.getAttribute('data-i18n');
    const val = t(key);
    if (typeof val === 'string') el.textContent = val;
  });
  document.querySelectorAll('[data-i18n-placeholder]').forEach(el => {
    const key = el.getAttribute('data-i18n-placeholder');
    el.placeholder = t(key) || el.placeholder;
  });
  document.querySelectorAll('.lang-btn').forEach(btn => { btn.classList.toggle('active', btn.getAttribute('data-lang') === lang); });
}

function showToast(msg, type = 'success') {
  const container = document.getElementById('toastContainer');
  const toast = document.createElement('div');
  toast.className = `toast toast-${type}`;
  toast.textContent = msg;
  container.appendChild(toast);
  setTimeout(() => { toast.style.opacity = '0'; toast.style.transform = 'translateX(-50%) translateY(-20px)'; setTimeout(() => toast.remove(), 300); }, 3000);
}

function adminLogin() {
  const pass = document.getElementById('adminPassword').value;
  if (pass === ADMIN_PASSWORD) {
    sessionStorage.setItem('adminAuth', 'true');
    document.getElementById('loginScreen').classList.add('hidden');
    document.getElementById('adminPanel').classList.remove('hidden');
    initAdmin();
  } else {
    showToast(t('enterPassword'), 'error');
  }
}

function logout() {
  sessionStorage.removeItem('adminAuth');
  location.reload();
}

function checkAuth() {
  if (sessionStorage.getItem('adminAuth') === 'true') {
    document.getElementById('loginScreen').classList.add('hidden');
    document.getElementById('adminPanel').classList.remove('hidden');
    initAdmin();
  }
}

function initAdmin() {
  setLang(currentLang);
  loadDashboard();
  loadAdminOrders();
  loadDrivers();
  loadRestaurants();
  loadEmergency();
  initAdminMap();
  startRealtimeUpdates();
  setInterval(() => { loadDashboard(); document.getElementById('lastUpdate').textContent = t('lastUpdate').replace('الآن', new Date().toLocaleTimeString('ar-SA')).replace('now', new Date().toLocaleTimeString('en-US')); }, 15000);
}

async function loadDashboard() {
  const today = new Date(); today.setHours(0,0,0,0);
  const todayStr = today.toISOString();
  const { count: totalToday } = await db.from('orders').select('*', { count: 'exact', head: true }).gte('created_at', todayStr);
  const { data: delivered } = await db.from('orders').select('cash_collected').eq('status', 'delivered').gte('delivered_at', todayStr);
  const cashToday = (delivered || []).reduce((s, o) => s + (parseFloat(o.cash_collected) || 0), 0);
  const { count: activeDrivers } = await db.from('driver_stats').select('*', { count: 'exact', head: true }).eq('is_online', true);
  const { count: pending } = await db.from('orders').select('*', { count: 'exact', head: true }).eq('status', 'pending');
  const { count: emergencies } = await db.from('emergency_alerts').select('*', { count: 'exact', head: true }).eq('status', 'active');
  document.getElementById('statTotalOrders').textContent = totalToday || 0;
  document.getElementById('statCashToday').textContent = cashToday.toLocaleString('ar-SA');
  document.getElementById('statActiveDrivers').textContent = activeDrivers || 0;
  document.getElementById('statPendingOrders').textContent = pending || 0;
  const badge = document.getElementById('emergencyBadge');
  if (emergencies > 0) { badge.classList.remove('hidden'); badge.textContent = emergencies; document.getElementById('nav-emergency').classList.add('pulse-red'); }
  else { badge.classList.add('hidden'); document.getElementById('nav-emergency').classList.remove('pulse-red'); }
  loadRecentOrders();
  loadStatusChart();
  loadDashEmergency();
}

async function loadRecentOrders() {
  const { data } = await db.from('orders').select('*').order('created_at', { ascending: false }).limit(5);
  const container = document.getElementById('dashRecentOrders');
  if (!data || data.length === 0) { container.innerHTML = `<div class="text-center text-gray-600 py-6 text-sm">${t('noOrders')}</div>`; return; }
  container.innerHTML = data.map(o => `
    <div class="flex items-center justify-between bg-black/30 rounded-xl p-3 cursor-pointer hover:bg-black/50 transition" onclick="showOrderDetails('${o.id}')">
      <div><div class="text-sm font-bold">${o.customer_name}</div><div class="text-[10px] text-gray-500">${o.address}</div></div>
      <div class="text-left"><div class="text-sm font-black neon-green">${parseFloat(o.price)} ${t('sar')}</div><span class="status-badge status-${o.status}">${t('orderStatus.' + o.status)}</span></div>
    </div>
  `).join('');
}

async function loadStatusChart() {
  const statuses = ['pending', 'accepted', 'at_store', 'picked_up', 'delivered', 'cancelled'];
  const colors = ['#ffcc00', '#00f0ff', '#a855f7', '#ec4899', '#00ff66', '#ef4444'];
  let counts = [];
  for (const status of statuses) { const { count } = await db.from('orders').select('*', { count: 'exact', head: true }).eq('status', status); counts.push(count || 0); }
  const max = Math.max(...counts, 1);
  document.getElementById('statusChart').innerHTML = counts.map((c, i) => `<div class="flex-1 rounded-t-lg transition-all duration-500" style="height: ${(c/max)*100}%; min-height: 10px; background: ${colors[i]}" title="${t('orderStatus.' + statuses[i])}: ${c}"></div>`).join('');
  document.getElementById('statusLabels').innerHTML = statuses.map((s, i) => `<span style="color: ${colors[i]}">${t('orderStatus.' + s)} (${counts[i]})</span>`).join('');
}

async function loadDashEmergency() {
  const { data } = await db.from('emergency_alerts').select('*').eq('status', 'active').limit(3);
  const container = document.getElementById('dashEmergencyList');
  if (!data || data.length === 0) { container.innerHTML = `<div class="text-center text-gray-600 py-6 text-sm">${t('noEmergencies')}</div>`; return; }
  container.innerHTML = data.map(e => `
    <div class="bg-red-500/10 border border-red-500/30 rounded-xl p-3 pulse-red">
      <div class="flex justify-between items-center">
        <div><div class="text-sm font-bold text-red-400">🚨 ${e.driver_name || '---'}</div><div class="text-[10px] text-gray-400">${e.message || e.alert_type}</div></div>
        <button onclick="switchSection('emergency')" class="bg-red-600 text-white text-xs px-3 py-1 rounded-lg">${t('view')}</button>
      </div>
    </div>
  `).join('');
}

async function loadAdminOrders() {
  const filter = document.getElementById('filterStatus').value;
  let query = db.from('orders').select('*').order('created_at', { ascending: false }).limit(50);
  if (filter) query = query.eq('status', filter);
  const { data } = await query;
  const container = document.getElementById('adminOrdersList');
  if (!data || data.length === 0) { container.innerHTML = `<div class="text-center text-gray-600 py-10">${t('noOrders')}</div>`; return; }
  container.innerHTML = data.map(o => `
    <div class="card p-4 hover:border-cyan-500/50 transition slide-up">
      <div class="flex items-center justify-between flex-wrap gap-3">
        <div class="flex-1">
          <div class="flex items-center gap-2 mb-1"><span class="font-black">${o.customer_name}</span><span class="status-badge status-${o.status}">${t('orderStatus.' + o.status)}</span></div>
          <div class="text-xs text-gray-500">📍 ${o.address}</div>
          <div class="text-[10px] text-gray-600 mt-1">${o.restaurant_name ? '🏪 ' + o.restaurant_name : ''} ${o.driver_name ? '| 🚗 ' + o.driver_name : ''}</div>
        </div>
        <div class="text-left"><div class="text-lg font-black neon-green">${parseFloat(o.price)} ${t('sar')}</div><div class="text-[10px] text-gray-500">${formatTimeAgo(o.created_at)}</div></div>
        <div class="flex gap-2">
          <button onclick="showOrderDetails('${o.id}')" class="bg-cyan-600/20 border border-cyan-600 text-cyan-400 px-3 py-2 rounded-xl text-sm">${t('view')}</button>
          ${o.status === 'pending' ? `<button onclick="cancelOrder('${o.id}')" class="bg-red-600/20 border border-red-600 text-red-400 px-3 py-2 rounded-xl text-sm">${t('cancel')}</button>` : ''}
        </div>
      </div>
    </div>
  `).join('');
}

async function showOrderDetails(orderId) {
  const { data: o } = await db.from('orders').select('*').eq('id', orderId).single();
  if (!o) return;
  const total = parseFloat(o.price) + parseFloat(o.delivery_fee || 0);
  document.getElementById('orderModalContent').innerHTML = `
    <div class="space-y-4">
      <div class="bg-black/40 rounded-xl p-4 text-center"><span class="status-badge status-${o.status} text-sm px-4 py-2">${t('orderStatus.' + o.status)}</span></div>
      <div class="bg-black/30 rounded-xl p-4"><h4 class="text-xs font-bold text-gray-400 mb-2">${t('customer')}</h4><p class="font-bold">${o.customer_name}</p>${o.customer_phone ? `<p class="text-sm text-gray-400 mt-1">📞 ${o.customer_phone}</p>` : ''}<p class="text-sm text-gray-400 mt-1">📍 ${o.address}</p></div>
      ${o.restaurant_name ? `<div class="bg-black/30 rounded-xl p-4"><h4 class="text-xs font-bold text-gray-400 mb-2">${t('restaurant')}</h4><p class="font-bold">${o.restaurant_name}</p></div>` : ''}
      ${o.driver_name ? `<div class="bg-black/30 rounded-xl p-4"><h4 class="text-xs font-bold text-gray-400 mb-2">${t('driver')}</h4><p class="font-bold">${o.driver_name}</p>${o.driver_phone ? `<p class="text-sm text-gray-400 mt-1">📞 ${o.driver_phone}</p>` : ''}</div>` : ''}
      <div class="bg-black/30 rounded-xl p-4"><h4 class="text-xs font-bold text-gray-400 mb-2">${t('financial')}</h4><div class="flex justify-between text-sm mb-1"><span>${t('orderValue')}</span><span class="font-bold">${parseFloat(o.price)} ${t('sar')}</span></div><div class="flex justify-between text-sm mb-1"><span>${t('deliveryFee')}</span><span class="font-bold">${parseFloat(o.delivery_fee || 0)} ${t('sar')}</span></div><div class="flex justify-between text-sm border-t border-gray-700 pt-2 mt-2"><span class="font-bold">${t('total')}</span><span class="font-black neon-green">${total} ${t('sar')}</span></div>${o.cash_collected ? `<div class="flex justify-between text-sm mt-2 text-green-400"><span>${t('cashCollected')}</span><span class="font-bold">${parseFloat(o.cash_collected)} ${t('sar')}</span></div>` : ''}</div>
      ${o.tracking_code ? `<div class="bg-black/30 rounded-xl p-4 text-center"><h4 class="text-xs font-bold text-gray-400 mb-2">${t('trackingCode')}</h4><p class="font-mono text-lg neon-cyan">${o.tracking_code}</p><button onclick="copyTracking('${o.tracking_code}')" class="mt-2 bg-cyan-600/20 border border-cyan-600 text-cyan-400 px-4 py-1 rounded-lg text-xs">${t('copy')}</button></div>` : ''}
      ${o.notes ? `<div class="bg-black/30 rounded-xl p-4"><h4 class="text-xs font-bold text-gray-400 mb-2">${t('notes')}</h4><p class="text-sm">${o.notes}</p></div>` : ''}
      <button onclick="closeOrderModal()" class="w-full py-3 rounded-xl bg-gray-700 text-white font-bold">${t('close')}</button>
    </div>
  `;
  document.getElementById('orderModal').classList.remove('hidden');
}

function closeOrderModal() { document.getElementById('orderModal').classList.add('hidden'); }

async function cancelOrder(orderId) {
  if (!confirm(t('confirmCancel'))) return;
  await db.from('orders').update({ status: 'cancelled' }).eq('id', orderId);
  showToast(t('orderCancelled'));
  loadAdminOrders();
  loadDashboard();
  closeOrderModal();
}

function copyTracking(code) { navigator.clipboard.writeText(code); showToast(t('linkCopied')); }

async function loadDrivers() {
  const { data } = await db.from('driver_stats').select('*').order('total_deliveries', { ascending: false });
  const container = document.getElementById('adminDriversList');
  document.getElementById('driversCount').textContent = (data || []).length + ' ' + t('drivers');
  if (!data || data.length === 0) { container.innerHTML = `<div class="text-center text-gray-600 py-10 col-span-2">${t('noDrivers')}</div>`; return; }
  container.innerHTML = data.map(d => `
    <div class="card p-5 ${d.is_blocked ? 'border-red-500/50' : ''} hover:border-cyan-500/50 transition">
      <div class="flex items-start justify-between mb-3">
        <div class="flex items-center gap-3">
          <div class="w-12 h-12 rounded-full bg-gradient-to-br from-cyan-500 to-purple-500 flex items-center justify-center text-xl">${getFlag(d.nationality)}</div>
          <div><h3 class="font-black">${d.driver_name}</h3><p class="text-xs text-gray-500">${d.driver_phone || ''}</p></div>
        </div>
        <div class="flex items-center gap-2">${d.is_online ? '<span class="w-2 h-2 bg-green-500 rounded-full animate-pulse"></span>' : '<span class="w-2 h-2 bg-gray-600 rounded-full"></span>'}${d.is_blocked ? `<span class="bg-red-600 text-white text-[10px] px-2 py-0.5 rounded-full">${t('blocked')}</span>` : ''}</div>
      </div>
      <div class="grid grid-cols-3 gap-2 mb-3">
        <div class="bg-black/30 rounded-lg p-2 text-center"><div class="text-sm font-black neon-green">${d.total_deliveries}</div><div class="text-[9px] text-gray-500">${t('totalDeliveries')}</div></div>
        <div class="bg-black/30 rounded-lg p-2 text-center"><div class="text-sm font-black neon-cyan">${(d.total_earnings || 0).toLocaleString('ar-SA')}</div><div class="text-[9px] text-gray-500">${t('totalEarnings')}</div></div>
        <div class="bg-black/30 rounded-lg p-2 text-center"><div class="text-sm font-black text-yellow-400">⭐ ${d.rating}</div><div class="text-[9px] text-gray-500">${t('rating')}</div></div>
      </div>
      <div class="flex gap-2">
        <a href="tel:${d.driver_phone}" class="flex-1 bg-green-600/20 border border-green-600 text-green-400 text-center py-2 rounded-xl text-xs font-bold">📞 ${t('call')}</a>
        ${d.is_blocked ? `<button onclick="unblockDriver('${d.driver_id}')" class="flex-1 bg-green-600 text-white py-2 rounded-xl text-xs font-bold">${t('unblock')}</button>` : `<button onclick="blockDriver('${d.driver_id}')" class="flex-1 bg-red-600/20 border border-red-600 text-red-400 py-2 rounded-xl text-xs font-bold">${t('block')}</button>`}
      </div>
    </div>
  `).join('');
}

function getFlag(nationality) { const flags = { 'سعودي': '🇸🇦', 'باكستاني': '🇵🇰', 'بنغلاديشي': '🇧🇩', 'هندي': '🇮🇳', 'مصري': '🇪🇬', 'سوداني': '🇸🇩', 'فلبيني': '🇵🇭' }; return flags[nationality] || '🚗'; }

async function blockDriver(driverId) { const reason = prompt(t('blockReason')); if (!reason) return; await db.from('driver_stats').update({ is_blocked: true, block_reason: reason }).eq('driver_id', driverId); showToast(t('driverBlocked')); loadDrivers(); }
async function unblockDriver(driverId) { await db.from('driver_stats').update({ is_blocked: false, block_reason: null }).eq('driver_id', driverId); showToast(t('driverUnblocked')); loadDrivers(); }

async function loadRestaurants() {
  const { data } = await db.from('restaurants').select('*').order('created_at', { ascending: false });
  const container = document.getElementById('adminRestaurantsList');
  if (!data || data.length === 0) { container.innerHTML = `<div class="text-center text-gray-600 py-10 col-span-2">${t('noRestaurants')}</div>`; return; }
  container.innerHTML = data.map(r => `
    <div class="card p-5 hover:border-green-500/50 transition">
      <div class="flex items-start justify-between mb-3">
        <div><h3 class="font-black text-lg">${r.name}</h3><p class="text-xs text-gray-500 mt-1">📞 ${r.phone || '---'}</p><p class="text-xs text-gray-500 mt-1">📍 ${r.address || '---'}</p></div>
        <div>${r.is_active ? '<span class="w-2 h-2 bg-green-500 rounded-full animate-pulse"></span>' : '<span class="w-2 h-2 bg-gray-600 rounded-full"></span>'}</div>
      </div>
      <div class="bg-black/30 rounded-lg p-2 text-center mb-3"><div class="text-sm font-black neon-green">${r.total_orders || 0}</div><div class="text-[9px] text-gray-500">${t('totalOrdersToday')}</div></div>
      <div class="flex gap-2">
        <button onclick="toggleRestaurant('${r.id}', ${!r.is_active})" class="flex-1 ${r.is_active ? 'bg-red-600/20 border-red-600 text-red-400' : 'bg-green-600/20 border-green-600 text-green-400'} border py-2 rounded-xl text-xs font-bold">${r.is_active ? t('deactivate') : t('activate')}</button>
        <button onclick="deleteRestaurant('${r.id}')" class="flex-1 bg-red-600/20 border border-red-600 text-red-400 py-2 rounded-xl text-xs font-bold">${t('delete')}</button>
      </div>
    </div>
  `).join('');
}

function showAddRestaurantModal() { document.getElementById('restaurantModal').classList.remove('hidden'); }
function closeRestaurantModal() { document.getElementById('restaurantModal').classList.add('hidden'); }

async function addRestaurant() {
  const name = document.getElementById('restName').value.trim();
  const phone = document.getElementById('restPhone').value.trim();
  const address = document.getElementById('restAddress').value.trim();
  const lat = parseFloat(document.getElementById('restLat').value) || 24.7136;
  const lng = parseFloat(document.getElementById('restLng').value) || 46.6753;
  if (!name) { showToast(t('restaurantName'), 'error'); return; }
  const id = 'rest_' + Date.now();
  const { error } = await db.from('restaurants').insert([{ id, name, phone, address, lat, lng, is_active: true }]);
  if (error) { showToast(t('enterPassword'), 'error'); return; }
  showToast(t('restaurantAdded'));
  closeRestaurantModal();
  loadRestaurants();
  document.getElementById('restName').value = '';
  document.getElementById('restPhone').value = '';
  document.getElementById('restAddress').value = '';
  document.getElementById('restLat').value = '';
  document.getElementById('restLng').value = '';
}

async function toggleRestaurant(id, isActive) { await db.from('restaurants').update({ is_active: isActive }).eq('id', id); showToast(isActive ? t('activate') : t('deactivate')); loadRestaurants(); }
async function deleteRestaurant(id) { if (!confirm(t('confirmCancel'))) return; await db.from('restaurants').delete().eq('id', id); showToast(t('restaurantDeleted')); loadRestaurants(); }

async function loadEmergency() {
  const { data } = await db.from('emergency_alerts').select('*').order('created_at', { ascending: false }).limit(20);
  const container = document.getElementById('emergencyList');
  if (!data || data.length === 0) { container.innerHTML = `<div class="text-center text-gray-600 py-10">${t('noEmergenciesList')}</div>`; return; }
  container.innerHTML = data.map(e => `
    <div class="card p-5 ${e.status === 'active' ? 'border-red-500/50 pulse-red' : ''}">
      <div class="flex items-start justify-between mb-3">
        <div><h3 class="font-black ${e.status === 'active' ? 'text-red-400' : 'text-gray-400'}">🚨 ${e.driver_name || '---'}</h3><p class="text-xs text-gray-500 mt-1">${e.message || e.alert_type}</p><p class="text-[10px] text-gray-600 mt-1">${new Date(e.created_at).toLocaleString('ar-SA')}</p></div>
        <span class="text-xs px-3 py-1 rounded-full font-bold ${e.status === 'active' ? 'bg-red-600 text-white' : e.status === 'responded' ? 'bg-yellow-600 text-white' : 'bg-green-600 text-white'}">${t(e.status)}</span>
      </div>
      ${e.location ? `<div class="bg-black/30 rounded-xl p-3 mb-3"><p class="text-xs text-gray-400">📍 ${t('address')}</p><p class="text-sm font-mono neon-cyan">${JSON.parse(e.location).lat}, ${JSON.parse(e.location).lng}</p><a href="https://www.google.com/maps?q=${JSON.parse(e.location).lat},${JSON.parse(e.location).lng}" target="_blank" class="text-xs text-blue-400 underline mt-1 block">${t('openInMaps')}</a></div>` : ''}
      ${e.status === 'active' ? `<div class="flex gap-2"><button onclick="respondToEmergency('${e.id}')" class="flex-1 bg-yellow-600 text-white py-2 rounded-xl text-sm font-bold">${t('respond')}</button><button onclick="resolveEmergency('${e.id}')" class="flex-1 bg-green-600 text-white py-2 rounded-xl text-sm font-bold">${t('resolve')}</button></div>` : ''}
    </div>
  `).join('');
}

async function respondToEmergency(id) { await db.from('emergency_alerts').update({ status: 'responded' }).eq('id', id); showToast(t('emergencyResponded')); loadEmergency(); }
async function resolveEmergency(id) { await db.from('emergency_alerts').update({ status: 'resolved', resolved_at: new Date().toISOString() }).eq('id', id); showToast(t('emergencyResolved')); loadEmergency(); }

function initAdminMap() { adminMap = L.map('adminMap').setView([24.7136, 46.6753], 12); L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', { maxZoom: 19 }).addTo(adminMap); }

async function showAllDriversOnMap() { clearMapMarkers(); const { data } = await db.from('driver_stats').select('*'); (data || []).forEach(d => { if (d.current_lat && d.current_lng) { const marker = L.marker([d.current_lat, d.current_lng]).addTo(adminMap).bindPopup(`<b>${d.driver_name}</b><br>⭐ ${d.rating}`); mapMarkers.push(marker); } }); showToast(t('showDrivers')); }
async function showPendingOnMap() { clearMapMarkers(); const { data } = await db.from('orders').select('*').eq('status', 'pending'); (data || []).forEach(o => { if (o.customer_lat && o.customer_lng) { const marker = L.marker([o.customer_lat, o.customer_lng]).addTo(adminMap).bindPopup(`<b>${o.customer_name}</b><br>${o.price} ${t('sar')}`); mapMarkers.push(marker); } }); showToast(t('showPending')); }
async function showDeliveredOnMap() { clearMapMarkers(); const { data } = await db.from('orders').select('*').eq('status', 'delivered').limit(20); (data || []).forEach(o => { if (o.customer_lat && o.customer_lng) { const marker = L.marker([o.customer_lat, o.customer_lng]).addTo(adminMap).bindPopup(`<b>✅ ${o.customer_name}</b><br>${o.cash_collected} ${t('sar')}`); mapMarkers.push(marker); } }); showToast(t('showDelivered')); }
function clearMapMarkers() { mapMarkers.forEach(m => adminMap.removeLayer(m)); mapMarkers = []; }

function saveSettings() { const settings = { commission: document.getElementById('platformCommission').value, baseFee: document.getElementById('baseDeliveryFee').value, perKm: document.getElementById('perKmFee').value }; localStorage.setItem('adminSettings', JSON.stringify(settings)); showToast(t('settingsSaved')); }
async function cancelAllPending() { if (!confirm(t('confirmCancelAll'))) return; await db.from('orders').update({ status: 'cancelled' }).eq('status', 'pending'); showToast(t('allCancelled')); loadDashboard(); loadAdminOrders(); }
async function exportData() { const { data: orders } = await db.from('orders').select('*'); const { data: drivers } = await db.from('driver_stats').select('*'); const { data: restaurants } = await db.from('restaurants').select('*'); const exportObj = { exportDate: new Date().toISOString(), orders, drivers, restaurants }; const blob = new Blob([JSON.stringify(exportObj, null, 2)], { type: 'application/json' }); const url = URL.createObjectURL(blob); const a = document.createElement('a'); a.href = url; a.download = 'cyberdelivery-export-' + new Date().toISOString().split('T')[0] + '.json'; a.click(); showToast(t('dataExported')); }
async function clearAllData() { if (!confirm(t('confirmClear'))) return; if (!confirm(t('confirmClear2'))) return; await db.from('orders').delete().neq('id', '00000000-0000-0000-0000-000000000000'); await db.from('emergency_alerts').delete().neq('id', '00000000-0000-0000-0000-000000000000'); showToast(t('dataCleared')); loadDashboard(); }
function copyAdminLink() { navigator.clipboard.writeText(window.location.href); showToast(t('linkCopied')); }

function startRealtimeUpdates() { db.channel('admin-updates').on('postgres_changes', { event: 'INSERT', schema: 'public', table: 'emergency_alerts' }, () => { loadEmergency(); loadDashEmergency(); if (navigator.vibrate) navigator.vibrate([500, 200, 500]); showToast(t('newEmergency')); }).on('postgres_changes', { event: '*', schema: 'public', table: 'orders' }, () => { loadDashboard(); loadAdminOrders(); }).subscribe(); }

function switchSection(section) { ['dashboard', 'orders', 'drivers', 'restaurants', 'emergency', 'map', 'settings'].forEach(s => { document.getElementById('section-' + s).classList.toggle('hidden', s !== section); document.getElementById('nav-' + s).classList.toggle('active', s === section); }); if (section === 'map') setTimeout(() => adminMap.invalidateSize(), 100); }

function formatTimeAgo(ts) { const diff = Math.floor((Date.now() - new Date(ts)) / 1000); if (diff < 60) return t('now'); if (diff < 3600) return Math.floor(diff / 60) + t('minAgo'); if (diff < 86400) return Math.floor(diff / 3600) + t('hoursAgo'); return Math.floor(diff / 86400) + t('daysAgo'); }

window.addEventListener('DOMContentLoaded', checkAuth);
document.getElementById('adminPassword').addEventListener('keypress', (e) => { if (e.key === 'Enter') adminLogin(); });
</script>
</body>
</html>
