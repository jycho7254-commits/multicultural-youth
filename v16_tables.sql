-- v16: 비밀글 비밀번호 + 검증 RPC + 삭제 권한
alter table eoullim_board add column if not exists pw_hash text;

create or replace function verify_post_pw(post_id bigint, input_hash text)
returns boolean language plpgsql security definer as $$
declare rec record;
begin
  select pw_hash into rec from eoullim_board where id = post_id;
  if rec.pw_hash is null then return false; end if;
  return rec.pw_hash = input_hash;
end $$;

-- 상담/체크 삭제 권한 (운영툴)
drop policy if exists "counsel_del" on eoullim_counsel;
create policy "counsel_del" on eoullim_counsel for delete using (true);
drop policy if exists "checks_del" on eoullim_checks;
create policy "checks_del" on eoullim_checks for delete using (true);
