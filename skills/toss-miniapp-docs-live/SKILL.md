---
description: "앱인토스 공식 문서 실시간 검색 및 조회. 다음 상황에서 이 스킬을 활성화하세요: 앱인토스 최신 문서 확인, SDK API 레퍼런스 조회, 공식 가이드 검색, 스킬에 있는 정보가 outdated 되었을 수 있을 때, 인앱결제/광고/로그인/프로모션 등의 최신 개발 문서가 필요할 때, 앱인토스 개발자센터 문서 검색, bedrock reference 조회, 앱인토스 FAQ 검색, 최신 SDK 변경사항 확인"
---

# 앱인토스 공식 문서 실시간 조회

> 공식 문서: https://developers-apps-in-toss.toss.im/

다른 `toss-miniapp-*` 스킬의 정보가 outdated 되었을 수 있을 때, 최신 공식 문서를 실시간으로 조회합니다.

---

## 방법 1: llms-full.txt (권장)

앱인토스 개발자센터는 LLM용 문서 번들을 제공합니다. 1회 fetch로 전체 문서 조회 가능.

| 유형 | URL |
|------|-----|
| 인덱스 (목차) | `https://developers-apps-in-toss.toss.im/llms.txt` |
| 전체 문서 번들 | `https://developers-apps-in-toss.toss.im/llms-full.txt` |
| TDS WebView | `https://tossmini-docs.toss.im/tds-mobile/llms-full.txt` |
| TDS React Native | `https://tossmini-docs.toss.im/tds-react-native/llms-full.txt` |

**키워드 검색:**
```bash
curl -sL --compressed https://developers-apps-in-toss.toss.im/llms-full.txt > /tmp/llms-full.txt
```
```
Grep: pattern="검색어" path="/tmp/llms-full.txt" output_mode="content" -C=10
```

> llms.txt/llms-full.txt는 gzip 압축 전송. `curl`에 `--compressed` 필수.

각 문서는 YAML frontmatter(`url:`, `description:`)로 구분됩니다.

---

## 방법 2: WebFetch

특정 문서 URL을 알 때 직접 조회:
```
WebFetch: url="https://developers-apps-in-toss.toss.im/tutorials/webview.html"
          prompt="이 페이지의 전체 내용을 상세하게 추출해줘"
```

주요 경로: `/intro/overview`, `/design/overview`, `/development/overview`, `/checklist/app-game`, `/checklist/app-nongame`, `/api/overview`, `/bedrock/reference/framework/시작하기/overview`, `/faq`, `/release-note`

---

## 방법 3: Playwright (폴백)

curl/WebFetch 실패 시에만 사용. Playwright MCP 필요.
```
browser_navigate → browser_snapshot(ref 확인) → browser_click(Search) → browser_type(검색어) → browser_snapshot → browser_click(결과) → browser_snapshot(filename="/tmp/page.md") → Read
```

---

## 판단 기준

| 상황 | 방법 |
|------|------|
| SDK 함수/API 스펙 확인 | 방법 1 (llms-full.txt grep) |
| 특정 페이지 확인 | 방법 2 (WebFetch) |
| 키워드 모를 때 | 방법 1 (llms.txt 인덱스) |
| 스킬 전체 최신화 | `toss-miniapp-maintenance` 스킬 사용 |
