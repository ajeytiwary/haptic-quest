create extension if not exists pgcrypto;
create extension if not exists postgis;

create table if not exists festivals (
  id text primary key, name text not null, theme text, city text,
  starts_at timestamptz, ends_at timestamptz, published boolean not null default false,
  config jsonb not null default '{}'::jsonb, created_at timestamptz not null default now()
);

create table if not exists checkpoints (
  id uuid primary key default gen_random_uuid(),
  festival_id text not null references festivals(id) on delete cascade,
  slug text not null, name text not null, place text, clue text,
  lat double precision not null, lon double precision not null,
  location geography(point,4326) generated always as (st_setsrid(st_makepoint(lon,lat),4326)::geography) stored,
  radius_m integer not null default 35 check(radius_m between 10 and 500),
  xp integer not null default 100 check(xp >= 0),
  verification_secret_hash text, nfc_tag_id_hash text,
  sort_order integer not null default 0, published boolean not null default false,
  unique(festival_id,slug)
);

create table if not exists quest_events (
  id bigint generated always as identity primary key,
  festival_id text not null references festivals(id) on delete cascade,
  session_id uuid not null, event_type text not null, checkpoint_slug text,
  metadata jsonb not null default '{}'::jsonb, created_at timestamptz not null default now()
);

create table if not exists rewards (
  id uuid primary key default gen_random_uuid(), festival_id text not null references festivals(id) on delete cascade,
  name text not null, inventory integer check(inventory is null or inventory >= 0),
  active boolean not null default true, created_at timestamptz not null default now()
);

create table if not exists redemptions (
  id uuid primary key default gen_random_uuid(), reward_id uuid not null references rewards(id),
  session_id uuid not null, token_hash text not null unique, redeemed_at timestamptz,
  created_at timestamptz not null default now()
);

create or replace function nearby_checkpoints(p_festival text,p_lat double precision,p_lon double precision,p_radius integer default 1000)
returns table(slug text,name text,place text,clue text,lat double precision,lon double precision,radius_m integer,xp integer,distance_m double precision)
language sql stable security invoker set search_path=public as $$
 select c.slug,c.name,c.place,c.clue,c.lat,c.lon,c.radius_m,c.xp,
        st_distance(c.location,st_setsrid(st_makepoint(p_lon,p_lat),4326)::geography) distance_m
 from checkpoints c
 where c.festival_id=p_festival and c.published=true
   and st_dwithin(c.location,st_setsrid(st_makepoint(p_lon,p_lat),4326)::geography,p_radius)
 order by distance_m;
$$;

create or replace view organizer_daily_metrics as
select festival_id,date_trunc('day',created_at) day,event_type,count(*) event_count,count(distinct session_id) sessions
from quest_events group by festival_id,date_trunc('day',created_at),event_type;

alter table festivals enable row level security;
alter table checkpoints enable row level security;
alter table quest_events enable row level security;
alter table rewards enable row level security;
alter table redemptions enable row level security;

create policy "published festivals readable" on festivals for select using (published=true);
create policy "published checkpoints readable" on checkpoints for select using (published=true);
create policy "active rewards readable" on rewards for select using (active=true);
create policy "privacy safe event insert" on quest_events for insert with check (
 event_type in ('quest_start','checkpoint_complete','quest_complete','reward_view','reward_claim','accessibility_change','map_view')
 and not (metadata ?| array['lat','lon','latitude','longitude','accuracy','position','location'])
);

create index if not exists checkpoints_location_gix on checkpoints using gist(location);
create index if not exists quest_events_festival_created_idx on quest_events(festival_id,created_at);
create index if not exists quest_events_session_idx on quest_events(festival_id,session_id,event_type);
create index if not exists checkpoints_festival_order_idx on checkpoints(festival_id,sort_order);

-- Raw GPS stays client-side. Analytics accepts derived interaction events only.
-- Organizer writes and verification secrets require authenticated server/admin tooling.
