-- 읽기 권한 추가 (운영툴용)
drop policy if exists "counsel_read" on eoullim_counsel;
create policy "counsel_read" on eoullim_counsel for select using (true);
drop policy if exists "checks_read" on eoullim_checks;
create policy "checks_read" on eoullim_checks for select using (true);
