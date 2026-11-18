create extension if not exists "uuid-ossp";

create table orders (
  id uuid default uuid_generate_v4() primary key,
  tracking_code text unique default 'CD-' || upper(substr(md5(random()::text), 1, 6)),
  customer_name text not null,
  customer_phone text,
  address text not null,
  price numeric not null,
  notes text,
  status text default 'pending' check (status in ('pending', 'accepted', 'in_transit', 'delivered', 'cancelled')),
  driver_name text,
  driver_phone text,
  created_at timestamp with time zone default timezone('utc'::text, now())
);

alter publication supabase_realtime add table orders;
