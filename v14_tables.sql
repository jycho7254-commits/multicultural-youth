-- v14: 비밀답변 + 문항응답 저장 + 플레이리스트 카테고리
alter table eoullim_board add column if not exists admin_reply_secret boolean default false;

alter table eoullim_checks add column if not exists answers jsonb;

alter table eoullim_playlist add column if not exists category text default '위로가 되는 노래';

-- 뷰 갱신 (admin_reply_secret 포함)
drop view if exists eoullim_board_public;
create view eoullim_board_public as
  select id, nick, case when secret then null else text end as text,
         secret, owner_key, warm, cheer,
         admin_reply, admin_reply_secret, react_voters, created_at
  from eoullim_board;
