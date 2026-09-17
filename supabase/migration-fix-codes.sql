-- VIC-CONNECT — Migration corrective des codes d'accès
-- NON DESTRUCTIVE : ne supprime aucune table et ne supprime aucune donnée.
-- À exécuter dans Supabase SQL Editor.

create extension if not exists pgcrypto with schema extensions;

-- Le problème observé venait de digest() : dans Supabase/pgcrypto,
-- la fonction peut être installée dans le schéma extensions alors que
-- les fonctions VIC-CONNECT utilisent search_path=public.
-- On qualifie donc explicitement extensions.digest().
create or replace function public.hash_code(p_code text)
returns text
language sql
immutable
strict
set search_path = public, extensions
as $$
  select encode(
    extensions.digest(
      convert_to(upper(trim(p_code)), 'UTF8'),
      'sha256'::text
    ),
    'hex'
  );
$$;

-- Fonction serveur pour créer un parent seul avec un code unique de 4 caractères.
-- Elle évite de générer le code dans le navigateur et garantit la cohérence
-- avec login_with_access_code().
create or replace function public.admin_create_parent(
  p_full_name text,
  p_phone text default null
)
returns jsonb
language plpgsql
security definer
set search_path = public, extensions
as $$
declare
  v_parent_id uuid;
  v_code text;
begin
  if not public.is_admin() then
    raise exception 'Accès Direction requis.';
  end if;

  if nullif(trim(p_full_name), '') is null then
    raise exception 'Nom du parent obligatoire.';
  end if;

  loop
    v_code := public.make_code(4);
    exit when not exists (
      select 1 from public.parents
      where access_code_hash = public.hash_code(v_code)
    );
  end loop;

  insert into public.parents(full_name, phone, access_code_hash)
  values (trim(p_full_name), nullif(trim(p_phone), ''), public.hash_code(v_code))
  returning id into v_parent_id;

  return jsonb_build_object(
    'success', true,
    'parent_id', v_parent_id,
    'parent_code', v_code
  );
end;
$$;

grant execute on function public.admin_create_parent(text, text) to authenticated;
