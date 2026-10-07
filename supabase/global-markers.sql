-- Global treasure marker metadata / images.
-- The production admin key is NOT stored in this repository.
-- Replace CHANGE_ME_WITH_A_STRONG_ADMIN_KEY only when bootstrapping a fresh project.

create schema if not exists private;

create table if not exists private.treasure_admin_settings (
  singleton boolean primary key default true check (singleton),
  key_hash text not null,
  updated_at timestamptz not null default now()
);

insert into private.treasure_admin_settings(singleton,key_hash)
values (true, encode(digest('CHANGE_ME_WITH_A_STRONG_ADMIN_KEY','sha256'),'hex'))
on conflict (singleton) do nothing;

create table if not exists public.treasure_point_overrides (
  route text not null check (route in ('blu','gialla','rossa')),
  point integer not null check (point > 0 and point < 1000),
  x double precision,
  y double precision,
  title text,
  description text,
  image_url text,
  active boolean not null default true,
  updated_at timestamptz not null default now(),
  primary key (route, point),
  check (
    active = false or (
      x is not null and y is not null
      and x between 0 and 2048
      and y between 0 and 1590
    )
  )
);

alter table public.treasure_point_overrides enable row level security;
revoke all on table public.treasure_point_overrides from anon, authenticated;

insert into storage.buckets (id,name,public,file_size_limit,allowed_mime_types)
values ('treasure-images','treasure-images',true,8388608,array['image/webp','image/jpeg','image/png'])
on conflict (id) do update set
  public=true,
  file_size_limit=8388608,
  allowed_mime_types=array['image/webp','image/jpeg','image/png'];

-- RPC definitions are applied in production migrations.
-- See the Supabase migration history for the authoritative deployed version.
