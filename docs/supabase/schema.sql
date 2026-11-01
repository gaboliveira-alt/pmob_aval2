create table if not exists public.items (
  id          uuid primary key default gen_random_uuid(),
  name        text not null check (char_length(btrim(name)) between 1 and 60),
  description text not null check (char_length(btrim(description)) between 1 and 200),
  location    text not null check (char_length(btrim(location)) > 0),
  situation   text not null check (situation in ('lost', 'found')),
  created_at  timestamptz not null default now()
);

create index if not exists items_created_at_idx on public.items (created_at desc);

alter table public.items enable row level security;

create policy "anon can select items"
  on public.items for select
  to anon
  using (true);

create policy "anon can insert items"
  on public.items for insert
  to anon
  with check (true);
