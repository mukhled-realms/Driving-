// CyberDelivery Config v2.0
const CONFIG = {
  SUPABASE: {
    URL: 'https://hhljyqelqnsltmasxgqv.supabase.co',
    KEY: 'sb_publishable_Xeo54iI9kxJ0n00f71A_yA_QNvmRC3H'
  },
  DRIVER_CONTACT: {
    NAME: 'عبدالله',
    PHONE: '0571835254',
    WHATSAPP: '966571835254'
  },
  LANGUAGES: {
    ar: { dir: 'rtl', label: 'العربية', flag: '🇸🇦' },
    en: { dir: 'ltr', label: 'English', flag: '🇬🇧' },
    ur: { dir: 'rtl', label: 'اردو', flag: '🇵🇰' },
    bn: { dir: 'ltr', label: 'বাংলা', flag: '🇧🇩' },
    hi: { dir: 'ltr', label: 'हिंदी', flag: '🇮🇳' }
  },
  MAP_DEFAULT: { lat: 24.7136, lng: 46.6753 } // الرياض
};

let db;
if (typeof window !== 'undefined' && window.supabase) {
  db = window.supabase.createClient(CONFIG.SUPABASE.URL, CONFIG.SUPABASE.KEY);
}

function t(key, lang) {
  const dict = {
    ar: { app: 'سايبر توصيل', order: 'طلب جديد', track: 'تتبع', call: 'اتصال', whatsapp: 'واتساب', total: 'الإجمالي', sar: 'ر.س', send: 'إرسال الطلب' },
    en: { app: 'CyberDelivery', order: 'New Order', track: 'Track', call: 'Call', whatsapp: 'WhatsApp', total: 'Total', sar: 'SAR', send: 'Send Order' },
    ur: { app: 'سائبر ڈیلیوری', order: 'نیا آرڈر', track: 'ٹریک', call: 'کال', whatsapp: 'واٹس ایپ', total: 'کل', sar: 'ریال', send: 'آرڈر بھیجیں' },
    bn: { app: 'সাইবার ডেলিভারি', order: 'নতুন অর্ডার', track: 'ট্র্যাক', call: 'কল', whatsapp: 'হোয়াটসঅ্যাপ', total: 'মোট', sar: 'রিয়াল', send: 'অর্ডার পাঠান' },
    hi: { app: 'साइबर डिलीवरी', order: 'नया ऑर्डर', track: 'ट्रैक', call: 'कॉल', whatsapp: 'व्हाट्सएप', total: 'कुल', sar: 'रियाल', send: 'ऑर्डर भेजें' }
  };
  return (dict[lang] || dict['ar'])[key] || key;
}
