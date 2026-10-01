create extension if not exists pgcrypto;

create table if not exists festivals (
  id text primary key,
  name text not null,
  theme text,
  city text,
  starts_at timestamptz,
  ends_at timestamptz,
  published boolean not null default false,
  config jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create table if not exists checkpoints (
  id uuid primary key default gen_random_uuid(),
  festival_id text not null references festivals(id) on delete cascade,
  slug text not null,
  name text not null,
  place text,
  clue text,
  lat double precision not null,
  lon double precision not null,
  radius_m integer not null default 35 check(radius_m between 10 and 500),
  xp integer not null default 100 check(xp >= 0),
  verification_secret_hash text,
  sort_order integer not null default 0,
  published boolean not null default false,
  unique(festival_id,slug)
);

create table if not exists quest_events (
  id bigint generated always as identity primary key,
  festival_id text not null references festivals(id) on delete cascade,
  session_id uuid not null,
  event_type text not null,
  checkpoint_slug text,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create table if not exists rewards (
  id uuid primary key default gen_random_uuid(),
  festival_id text not null references festivals(id) on delete cascade,
  name text not null,
  inventory integer check(inventory is null or inventory >= 0),
  active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists redemptions (
  id uuid primary key default gen_random_uuid(),
  reward_id uuid not null references rewards(id),
  session_id uuid not null,
  token_hash text not null unique,
  redeemed_at timestamptz,
  created_at timestamptz not null default now()
);

alter table festivals enable row level security;
alter table checkpoints enable row level security;
alter table quest_events enable row level security;
alter table rewards enable row level security;
alter table redemptions enable row level security;

create policy "published festivals readable" on festivals for select using (published=true);
create policy "published checkpoints readable" on checkpoints for select using (published=true);
create policy "active rewards readable" on rewards for select using (active=true);
create policy "anonymous event insert" on quest_events for insert with check (event_type in ('quest_start','checkpoint_complete','quest_complete','reward_view','accessibility_change'));

create index if not exists quest_events_festival_created_idx on quest_events(festival_id,created_at);
create index if not exists checkpoints_festival_order_idx on checkpoints(festival_id,sort_order);

-- Organizer writes should be performed through authenticated server/admin tooling.
-- Never expose service-role keys or verification secrets in the browser.
