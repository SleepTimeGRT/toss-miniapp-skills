---
description: "앱인토스 스킬 최신화 및 유지보수. 다음 상황에서 이 스킬을 활성화하세요: 스킬 업데이트, 문서 최신화, stale 체크, 스킬 freshness 확인, toss-miniapp 스킬 갱신, 플러그인 유지보수, 앱인토스 문서 변경사항 반영"
---

# 앱인토스 스킬 최신화 (Freshness Check & Update)

`toss-miniapp-*` 스킬의 내용이 outdated되었는지 확인하고 업데이트하는 워크플로우입니다.

---

## 최신화 확인 (Freshness Check)

### Step 1: 최신 문서 다운로드

```bash
curl -sL --compressed https://developers-apps-in-toss.toss.im/llms-full.txt > /tmp/llms-full-latest.txt
```

### Step 2: 스킬 파일 목록 확인

```
Glob: pattern="skills/*/SKILL.md"
```

### Step 3: 각 스킬과 최신 문서 비교

각 스킬에 대해:
1. SKILL.md의 핵심 키워드를 추출
2. `/tmp/llms-full-latest.txt`에서 해당 키워드로 grep
3. SDK 함수 시그니처, API 엔드포인트, 절차 변경 여부 확인

### 스킬별 비교 키워드

| 스킬 | llms-full.txt 검색 키워드 |
|------|--------------------------|
| toss-miniapp-onboarding | `console-workspace`, `register-business`, `onboarding-process` |
| toss-miniapp-design | `miniapp-branding`, `ux-writing`, `consumer-ux`, `components` |
| toss-miniapp-dev-tutorial | `tutorials/webview`, `tutorials/react-native`, `development/llms` |
| toss-miniapp-toss-login | `login/develop`, `appLogin`, `generateOauth2Token` |
| toss-miniapp-game-login | `game-login/develop`, `getUserKeyForGame` |
| toss-miniapp-iap | `iap/develop`, `createOneTimePurchaseOrder`, `getIapOrderStatus` |
| toss-miniapp-tosspay | `tosspay/develop`, `checkoutPayment`, `makePayment` |
| toss-miniapp-ads | `ads/develop`, `loadAppsInTossAdMob`, `IntegratedAd` |
| toss-miniapp-server-integration | `integration-process`, `sentry-monitoring`, `tossauth` |
| toss-miniapp-testing-deploy | `test/sandbox`, `test/toss`, `debugging`, `deploy.md` |
| toss-miniapp-checklist | `checklist/app-game`, `checklist/app-nongame` |

### Step 4: 리포트

| 상태 | 의미 |
|------|------|
| FRESH | 최신 문서와 스킬 내용이 일치 |
| STALE | 변경된 내용이 있음 (구체적 diff 기술) |
| MISSING | 최신 문서에 있지만 어떤 스킬에서도 다루지 않는 새 주제 |

---

## 스킬 업데이트 (Update)

STALE로 판정된 스킬을 업데이트:

1. `/tmp/llms-full-latest.txt`에서 해당 주제의 최신 내용 추출
2. SKILL.md의 YAML frontmatter `description` 유지 (새 기능 추가 시 키워드 보강)
3. 변경된 SDK 코드 예시, API 파라미터, 절차를 업데이트
4. references/ 파일도 함께 업데이트
5. 한국어 작성 스타일 유지
