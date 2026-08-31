# ARCHITECTURE — 어울림 마음쉼터 (v14, 최신)

> v14: 비밀답변, 마음체크 개인정보 필수화+문항별 응답 저장, 운영툴 문항 분석,
> 카테고리별 플레이리스트 + YT 미리듣기/신청곡 검색 링크

## 전체 구조

```
┌─────────────── GitHub Pages (정적) ───────────────┐
│  index.html (방문자 7탭 SPA)                       │
│  admin.html (운영툴 — 비밀번호 게이트)              │
└───────────────────────┬───────────────────────────┘
                        │ REST (fetch)
┌─────────────── Supabase ──────────────────────────┐
│ eoullim_board      글+반응+admin_reply(+secret)     │
│ eoullim_checks     점수+answers(jsonb)+개인정보     │
│ eoullim_counsel    상담 신청 (status: new/done)     │
│ eoullim_songs      신청곡                           │
│ eoullim_playlist   카테고리별 편성                   │
│ view board_public  비밀글 text=null 마스킹           │
│ RPC admin_delete_post (pw 검증 후 삭제)             │
└───────────────────────────────────────────────────┘
```

## 주요 메커니즘

### 1. 답글/비밀답변 (v14)
```
운영툴: 답글 입력 + "비밀답변" 체크 → PATCH admin_reply, admin_reply_secret
방문자 렌더:
  reply && (!reply_secret || _canSeeReply)
  _canSeeReply = !reply_secret || (owner_key === 내 브라우저 키)
  → 공개글에 단 비밀답변도 '글 작성자'만 열람 (v14 권한 분리)
```

### 2. 마음체크 파이프라인 (v14)
```
응답 완료 → 필수 검증(닉네임/나이대/동의) → 즉시 채점/결과 표시
           → 서버 저장: score + level + answers 배열 + nick/age/contact
운영툴:
  문항별 평균 바그래프 (9문항 호소도)
  개인별 문항 칩 (양성 문항만 표시)
  자살사고 문항(9번) 양성 → 빨간 배지
```

### 3. 플레이리스트 카테고리 (v14)
```
운영툴: 곡 추가 시 카테고리 지정 (5종) + 검색어 → DB
방문자: PLAYLIST_DB 로드 → 카테고리 헤더 그룹 렌더 (다국어 카테고리명)
신청곡: 운영툴에서 ▶ 유튜브뮤직 검색 링크로 미리듣기 → 승인 시 카테고리에 편성
편성곡 없으면 기본 5종 폴백
```

### 4. i18n 3계층 + 콘텐츠 (다국어 잔존 0)
- I18N 141키(정적) / DYN 34키(동적) / 문항·따뜻함·카테고리 배열

## 테이블 스키마 변경 이력

| 버전 | 변경 |
|---|---|
| v12 | counsel/checks 테이블, admin_delete_post RPC |
| v13 | board.admin_reply, playlist 테이블 |
| v14 | board.admin_reply_secret, checks.answers(jsonb), playlist.category |

## 운영툴 기능 요약

| 탭 | 기능 |
|---|---|
| 게시판 | 비밀글 원문 열람 · 답글(비밀 설정) · 삭제(RPC) · 통계 |
| 상담 신청 | NEW 배지 · 확인완료 처리 |
| 마음체크 | 문항 평균 그래프 · 개인별 칩 · 자살사고 양성 배지 · 위험 하이라이트 |
| 음악 관리 | 카테고리 편성 · YT 미리듣기 · 신청곡 승인/삭제 |

## OMP 검증 이력

v3~v13 전과정 → **v14 최종 14/14** (비밀답변 저장/숨김·필수 차단·결과 즉시·문항저장·분석 표시·카테고리 편성/반영·승인 이동·JS 0)
