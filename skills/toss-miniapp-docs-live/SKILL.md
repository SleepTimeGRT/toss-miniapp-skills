---
description: "앱인토스 공식 문서 실시간 검색 및 조회. 다음 상황에서 이 스킬을 활성화하세요: 앱인토스 최신 문서 확인, SDK API 레퍼런스 조회, 공식 가이드 검색, 스킬에 있는 정보가 outdated 되었을 수 있을 때, 인앱결제/광고/로그인/프로모션 등의 최신 개발 문서가 필요할 때, 앱인토스 개발자센터 문서 검색, bedrock reference 조회, 앱인토스 FAQ 검색, 최신 SDK 변경사항 확인"
---

# 앱인토스 공식 문서 실시간 조회

> 공식 문서: https://developers-apps-in-toss.toss.im/

이 스킬은 앱인토스 개발자센터에서 **최신 공식 문서를 실시간으로 검색·조회**합니다.
다른 스킬의 정보가 outdated 되었을 수 있으므로, 정확한 정보가 필요할 때 이 스킬을 사용하세요.

**Playwright MCP 도구를 사용합니다.**

---

## 문서 조회 파이프라인

### 방법 1: 키워드 검색 (권장)

특정 기능이나 API를 찾을 때 사용합니다.

```
1. browser_navigate → https://developers-apps-in-toss.toss.im/
2. browser_click    → Search 버튼 클릭
3. browser_type     → 검색어 입력 (예: "인앱결제", "getUserKeyForGame", "토스 로그인")
4. browser_snapshot → 검색 결과 목록 확인 (링크 URL 포함)
5. browser_click    → 가장 관련성 높은 결과 클릭
6. browser_snapshot → filename 파라미터로 파일에 저장
7. Read             → 저장된 파일에서 필요한 부분만 읽기
```

#### 단계별 상세

**1~2. 사이트 열고 검색창 활성화**

```
browser_navigate: url="https://developers-apps-in-toss.toss.im/"
browser_click: ref=Search 버튼의 ref
```

**3. 검색어 입력**

```
browser_type: ref=검색 입력창의 ref, text="검색어"
```

> 검색어 팁:
> - 한국어 기능명: "인앱결제", "토스 로그인", "위치 권한"
> - SDK 함수명: "getUserKeyForGame", "createOneTimePurchaseOrder"
> - 영문 키워드: "storage", "camera", "haptic"

**4. 검색 결과 확인**

```
browser_snapshot
```

검색 결과는 `listbox > option` 형태로 나타납니다.
각 option에 링크 URL이 포함되어 있으므로, 가장 관련성 높은 결과를 선택하세요.

**5. 결과 클릭하여 문서 페이지 이동**

```
browser_click: ref=선택한 결과의 ref
```

**6. 문서 내용을 파일로 저장**

```
browser_snapshot: filename="/tmp/docs-page.md"
```

> **중요**: `filename` 파라미터를 사용하면 snapshot이 파일에 저장되어 컨텍스트 윈도우를 소비하지 않습니다.

**7. 필요한 부분만 읽기**

```
Read: file_path="/tmp/docs-page.md"
```

파일이 길면 `offset`과 `limit`을 사용하여 필요한 섹션만 읽으세요.

---

### 방법 2: 직접 URL 접근

문서 경로를 이미 알고 있을 때 사용합니다.

```
1. browser_navigate → 문서 URL 직접 접근
2. browser_snapshot → filename 파라미터로 파일에 저장
3. Read             → 필요한 부분만 읽기
```

#### 사이트 주요 섹션 경로

| 섹션 | 경로 |
|------|------|
| 시작 (소개) | `/intro/overview` |
| 디자인 | `/design/overview` |
| 개발 | `/development/overview` |
| 출시/검수 | `/checklist/app-game` |
| 마케팅 | `/marketing/overview` |
| 수익화 | `/revenue/overview` |
| API & SDK | `/api/overview` |
| FAQ | `/faq` |

> 이 경로는 변경될 수 있으므로, 404가 발생하면 방법 1(검색)으로 전환하세요.

---

### 방법 3: Markdown 직접 다운로드 (가장 토큰 효율적)

문서 페이지에 "Copy as Markdown" 버튼이 있는 경우, `browser_evaluate`로 마크다운을 직접 추출할 수 있습니다.

```
1. browser_navigate → 문서 URL 접근
2. browser_evaluate → 페이지의 main content 영역 텍스트 추출
```

```javascript
// browser_evaluate 예시
document.querySelector('.vp-doc')?.innerText
```

---

## 토큰 효율 최적화 전략

| 방법 | 토큰 소비 | 적합한 상황 |
|------|-----------|-------------|
| snapshot + filename → Read(offset/limit) | 최소 | 긴 문서에서 특정 섹션만 필요할 때 |
| browser_evaluate(innerText) | 적음 | 페이지 전체 텍스트가 필요할 때 |
| snapshot (inline) | 많음 | 짧은 페이지거나 구조 파악이 필요할 때 |

### 핵심 원칙

1. **snapshot은 가능한 filename으로 파일에 저장** — 컨텍스트 윈도우를 보호합니다.
2. **긴 문서는 offset/limit으로 필요한 부분만 Read** — 전체를 읽지 마세요.
3. **검색 결과 snapshot은 inline** — 결과 목록은 짧으므로 바로 확인합니다.
4. **문서 본문은 file 저장 후 Read** — 본문은 길므로 파일로 우회합니다.

---

## 사용 예시

### "인앱결제 개발 방법 알려줘"

```
browser_navigate → https://developers-apps-in-toss.toss.im/
browser_click    → Search 버튼
browser_type     → "인앱결제"
browser_snapshot → 검색 결과 확인 (inline)
browser_click    → "개발하기 > 2. 인앱결제 요청하기" 클릭
browser_snapshot → filename="/tmp/iap-develop.md"
Read             → /tmp/iap-develop.md (필요한 섹션만)
```

### "getUserKeyForGame 함수 사용법"

```
browser_navigate → https://developers-apps-in-toss.toss.im/
browser_click    → Search 버튼
browser_type     → "getUserKeyForGame"
browser_snapshot → 검색 결과 확인 (inline)
browser_click    → 가장 관련 높은 결과
browser_snapshot → filename="/tmp/getUserKeyForGame.md"
Read             → /tmp/getUserKeyForGame.md
```

---

## 다른 스킬과의 관계

이 스킬은 다른 `toss-miniapp-*` 스킬이 제공하는 정보가 최신인지 확신이 없을 때 **보완적으로** 사용합니다.

- 다른 스킬의 정보로 충분하면 → 그대로 사용
- 정보가 부족하거나 outdated 의심 → 이 스킬로 최신 문서 확인
- SDK 버전별 변경사항 확인 → 이 스킬로 공식 문서 조회
