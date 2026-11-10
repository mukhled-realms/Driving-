-- ============================================
-- 🗑️ حذف الجداول القديمة (بترتيب آمن)
-- ============================================
DROP TABLE IF EXISTS emergency_alerts CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS driver_stats CASCADE;
DROP TABLE IF EXISTS restaurants CASCADE;

-- ============================================
-- 🏪 جدول المطاعم
-- ============================================
CREATE TABLE IF NOT EXISTS restaurants (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  phone TEXT,
  address TEXT,
  lat DECIMAL(10,7),
  lng DECIMAL(10,7),
  is_active BOOLEAN DEFAULT true,
  total_orders INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- 📦 جدول الطلبات الرئيسي
-- ============================================
CREATE TABLE IF NOT EXISTS orders (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  restaurant_id TEXT,
  restaurant_name TEXT,
  customer_name TEXT NOT NULL,
  customer_phone TEXT,
  address TEXT NOT NULL,
  customer_lat DECIMAL(10,7),
  customer_lng DECIMAL(10,7),
  price DECIMAL(10,2) NOT NULL CHECK (price > 0),
  delivery_fee DECIMAL(10,2) DEFAULT 10,
  notes TEXT,
  status TEXT DEFAULT 'pending' CHECK (
    status IN ('pending', 'accepted', 'at_store', 'picked_up', 'in_transit', 'delivered', 'cancelled')
  ),
  driver_id TEXT,
  driver_name TEXT,
  driver_phone TEXT,
  driver_lat DECIMAL(10,7),
  driver_lng DECIMAL(10,7),
  cash_collected DECIMAL(10,2),
  payment_method TEXT DEFAULT 'cash',
  customer_rating INTEGER CHECK (customer_rating >= 1 AND customer_rating <= 5),
  customer_feedback TEXT,
  admin_notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  accepted_at TIMESTAMPTZ,
  picked_up_at TIMESTAMPTZ,
  delivered_at TIMESTAMPTZ,
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  tracking_code TEXT UNIQUE DEFAULT 'CD-' || substr(md5(random()::text), 1, 8)
);

-- ============================================
-- 📊 جدول إحصائيات المندوبين
-- ============================================
CREATE TABLE IF NOT EXISTS driver_stats (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  driver_id TEXT UNIQUE NOT NULL,
  driver_name TEXT NOT NULL,
  driver_phone TEXT,
  nationality TEXT,
  preferred_language TEXT DEFAULT 'ar',
  total_deliveries INT DEFAULT 0,
  total_earnings DECIMAL(12,2) DEFAULT 0,
  total_distance_km DECIMAL(10,2) DEFAULT 0,
  avg_delivery_time_minutes INT DEFAULT 0,
  rating DECIMAL(3,2) DEFAULT 5.0,
  total_ratings INT DEFAULT 0,
  level INT DEFAULT 1,
  is_online BOOLEAN DEFAULT true,
  is_blocked BOOLEAN DEFAULT false,
  block_reason TEXT,
  current_lat DECIMAL(10,7),
  current_lng DECIMAL(10,7),
  joined_at TIMESTAMPTZ DEFAULT NOW(),
  last_active_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- 🚨 جدول تنبيهات الطوارئ
-- ============================================
CREATE TABLE IF NOT EXISTS emergency_alerts (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  driver_id TEXT NOT NULL,
  driver_name TEXT,
  location JSONB,
  alert_type TEXT DEFAULT 'sos' CHECK (
    alert_type IN ('sos', 'accident', 'theft', 'medical', 'other')
  ),
  message TEXT,
  status TEXT DEFAULT 'active' CHECK (
    status IN ('active', 'responded', 'resolved')
  ),
  admin_response TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  resolved_at TIMESTAMPTZ
);

-- ============================================
-- ⚡ الفهارس (Indexes) للسرعة
-- ============================================
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);
CREATE INDEX IF NOT EXISTS idx_orders_restaurant ON orders(restaurant_id);
CREATE INDEX IF NOT EXISTS idx_orders_driver ON orders(driver_id);
CREATE INDEX IF NOT EXISTS idx_orders_created ON orders(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_orders_status_created ON orders(status, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_orders_tracking ON orders(tracking_code);
CREATE INDEX IF NOT EXISTS idx_orders_customer_location ON orders(customer_lat, customer_lng);
CREATE INDEX IF NOT EXISTS idx_orders_driver_location ON orders(driver_lat, driver_lng);
CREATE INDEX IF NOT EXISTS idx_driver_stats_location ON driver_stats(current_lat, current_lng);
CREATE INDEX IF NOT EXISTS idx_driver_stats_online ON driver_stats(is_online);
CREATE INDEX IF NOT EXISTS idx_emergency_status ON emergency_alerts(status);

-- ============================================
-- 🔄 Trigger لتحديث updated_at تلقائياً
-- ============================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_orders_updated_at ON orders;
CREATE TRIGGER update_orders_updated_at
  BEFORE UPDATE ON orders
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- 📡 تفعيل Realtime
-- ============================================
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_publication_tables WHERE pubname = 'supabase_realtime' AND tablename = 'orders') THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE orders;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_publication_tables WHERE pubname = 'supabase_realtime' AND tablename = 'driver_stats') THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE driver_stats;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_publication_tables WHERE pubname = 'supabase_realtime' AND tablename = 'emergency_alerts') THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE emergency_alerts;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_publication_tables WHERE pubname = 'supabase_realtime' AND tablename = 'restaurants') THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE restaurants;
  END IF;
END $$;

-- ============================================
-- 🔒 Row Level Security (RLS)
-- ============================================
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE driver_stats ENABLE ROW LEVEL SECURITY;
ALTER TABLE emergency_alerts ENABLE ROW LEVEL SECURITY;
ALTER TABLE restaurants ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "allow_all_orders" ON orders;
DROP POLICY IF EXISTS "allow_all_drivers" ON driver_stats;
DROP POLICY IF EXISTS "allow_all_alerts" ON emergency_alerts;
DROP POLICY IF EXISTS "allow_all_rest" ON restaurants;

CREATE POLICY "allow_all_orders" ON orders FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all_drivers" ON driver_stats FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all_alerts" ON emergency_alerts FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all_rest" ON restaurants FOR ALL USING (true) WITH CHECK (true);

-- ============================================
-- 🧪 بيانات تجريبية
-- ============================================
INSERT INTO restaurants (id, name, phone, address, lat, lng) VALUES
('rest_001', 'مطعم البيك', '+966501111111', 'حي العليا، الرياض', 24.7136, 46.6753),
('rest_002', 'بقالة النور', '+966502222222', 'حي الملز، الرياض', 24.6800, 46.7200),
('rest_003', 'مطعم هرفي', '+966503333333', 'حي النخيل، الرياض', 24.7500, 46.7000)
ON CONFLICT (id) DO NOTHING;

INSERT INTO driver_stats (driver_id, driver_name, driver_phone, nationality, preferred_language, total_deliveries, total_earnings, rating) VALUES
('driver_001', 'أحمد السائق', '+966501234567', 'سعودي', 'ar', 127, 8450.00, 4.8),
('driver_002', 'محمد خان', '+966507654321', 'باكستاني', 'ur', 89, 6200.00, 4.6),
('driver_003', 'رحيم الدين', '+966509998887', 'بنغلاديشي', 'bn', 203, 15800.00, 4.9),
('driver_004', 'راجيش كومار', '+966503332221', 'هندي', 'hi', 156, 11200.00, 4.7)
ON CONFLICT (driver_id) DO NOTHING;
