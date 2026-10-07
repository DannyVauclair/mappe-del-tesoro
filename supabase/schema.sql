-- Wildlands Mappe del Tesoro — stato condiviso per gruppi
-- Eseguire nel progetto Supabase una sola volta.

create extension if not exists pgcrypto;

create table if not exists public.treasure_group_state (
  group_hash text not null,
  route text not null check (route in ('blu','gialla','rossa')),
  point integer not null,
  status text not null check (status in ('empty','spawned')),
  updated_by text not null default 'Anonimo',
  updated_at timestamptz not null default now(),
  primary key (group_hash, route, point)
);

alter table public.treasure_group_state enable row level security;
revoke all on table public.treasure_group_state from anon, authenticated;

create or replace function public.treasure_group_hash(p_group_code text)
returns text
language sql
immutable
security definer
set search_path = public, extensions
as $$
  select encode(digest(lower(trim(p_group_code)), 'sha256'), 'hex');
$$;

create or replace function public.get_treasure_group_state(p_group_code text)
returns table (
  route text,
  point integer,
  status text,
  updated_by text,
  updated_at timestamptz
)
language plpgsql
security definer
set search_path = public, extensions
as $$
begin
  if length(trim(coalesce(p_group_code,''))) < 6 then
    raise exception 'Codice gruppo troppo corto';
  end if;

  return query
  select s.route, s.point, s.status, s.updated_by, s.updated_at
  from public.treasure_group_state s
  where s.group_hash = public.treasure_group_hash(p_group_code)
  order by s.route, s.point;
end;
$$;

create or replace function public.set_treasure_point_state(
  p_group_code text,
  p_route text,
  p_point integer,
  p_status text,
  p_updated_by text
)
returns void
language plpgsql
security definer
set search_path = public, extensions
as $$
declare
  v_hash text;
  v_name text;
begin
  if length(trim(coalesce(p_group_code,''))) < 6 then
    raise exception 'Codice gruppo troppo corto';
  end if;
  if p_route not in ('blu','gialla','rossa') then
    raise exception 'Percorso non valido';
  end if;
  if p_status not in ('unchecked','empty','spawned') then
    raise exception 'Stato non valido';
  end if;

  v_hash := public.treasure_group_hash(p_group_code);
  v_name := left(coalesce(nullif(trim(p_updated_by),''),'Anonimo'), 40);

  if p_status = 'unchecked' then
    delete from public.treasure_group_state
    where group_hash = v_hash and route = p_route and point = p_point;
  else
    insert into public.treasure_group_state(group_hash, route, point, status, updated_by, updated_at)
    values (v_hash, p_route, p_point, p_status, v_name, now())
    on conflict (group_hash, route, point)
    do update set
      status = excluded.status,
      updated_by = excluded.updated_by,
      updated_at = excluded.updated_at;
  end if;
end;
$$;

create or replace function public.reset_treasure_group_state(p_group_code text)
returns void
language plpgsql
security definer
set search_path = public, extensions
as $$
begin
  if length(trim(coalesce(p_group_code,''))) < 6 then
    raise exception 'Codice gruppo troppo corto';
  end if;

  delete from public.treasure_group_state
  where group_hash = public.treasure_group_hash(p_group_code);
end;
$$;

revoke all on function public.treasure_group_hash(text) from public, anon, authenticated;
revoke all on function public.get_treasure_group_state(text) from public;
revoke all on function public.set_treasure_point_state(text,text,integer,text,text) from public;
revoke all on function public.reset_treasure_group_state(text) from public;

grant execute on function public.get_treasure_group_state(text) to anon, authenticated;
grant execute on function public.set_treasure_point_state(text,text,integer,text,text) to anon, authenticated;
grant execute on function public.reset_treasure_group_state(text) to anon, authenticated;
