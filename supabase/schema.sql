create extension if not exists pgcrypto;
create table public.profiles(id uuid primary key references auth.users(id) on delete cascade,email text,role text not null default 'customer' check(role in ('customer','admin')),created_at timestamptz default now());
create table public.products(id uuid primary key default gen_random_uuid(),name text not null,description text default '',price numeric(10,2) not null default 0 check(price>=0),duration text not null default 'Lifetime',active boolean not null default true,created_at timestamptz default now());
create table public.orders(id uuid primary key default gen_random_uuid(),user_id uuid not null references auth.users(id) on delete cascade,product_id uuid not null references public.products(id),amount numeric(10,2) not null,payment_method text not null check(payment_method in ('binance','stars')),proof_path text,status text not null default 'pending' check(status in ('pending','approved','rejected')),created_at timestamptz default now());
create table public.licenses(id uuid primary key default gen_random_uuid(),user_id uuid not null references auth.users(id) on delete cascade,product_id uuid not null references public.products(id),order_id uuid references public.orders(id),starts_at timestamptz default now(),expires_at timestamptz,created_at timestamptz default now());
create or replace function public.new_profile() returns trigger language plpgsql security definer set search_path=public as $$ begin insert into public.profiles(id,email) values(new.id,new.email); return new; end; $$;
create trigger auth_user_profile after insert on auth.users for each row execute procedure public.new_profile();
alter table public.profiles enable row level security; alter table public.products enable row level security; alter table public.orders enable row level security; alter table public.licenses enable row level security;
create policy "read own profile" on public.profiles for select to authenticated using(id=auth.uid());
create policy "read active products" on public.products for select to anon,authenticated using(active=true);
create policy "read own orders" on public.orders for select to authenticated using(user_id=auth.uid());
create policy "insert own pending orders" on public.orders for insert to authenticated with check(user_id=auth.uid() and status='pending');
create policy "read own licenses" on public.licenses for select to authenticated using(user_id=auth.uid());
insert into storage.buckets(id,name,public,file_size_limit,allowed_mime_types) values('payment-proofs','payment-proofs',false,8388608,array['image/png','image/jpeg','image/webp','application/pdf']) on conflict(id) do nothing;
create policy "upload own payment proof" on storage.objects for insert to authenticated with check(bucket_id='payment-proofs' and (storage.foldername(name))[1]=auth.uid()::text);
-- After registering your own account, promote it: update public.profiles set role='admin' where email='YOUR_EMAIL';
insert into public.products(name,description,price,duration) values
('Bot Access — 3 Days','Three days of bot access.',0,'3 Days'),
('Bot Access — 1 Week','One week of bot access.',0,'1 Week'),
('Bot Access — 1 Month','One month of bot access.',0,'1 Month'),
('Bot Access — Lifetime','Lifetime bot access.',0,'Lifetime'),
('CPM1 Access — Lifetime','Full Unlocked + 200 HD Logo/Design Cars.',0,'Lifetime'),
('Source Codes','Source code delivery arranged through Telegram.',0,'Manual delivery');
