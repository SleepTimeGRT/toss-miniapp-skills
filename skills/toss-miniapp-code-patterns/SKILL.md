---
description: "앱인토스 미니앱 코드 패턴 및 예제 레퍼런스. 다음 상황에서 이 스킬을 활성화하세요: 미니앱 코드 예제 참고, SDK 기능별 구현 패턴 검색, WebView 미니앱 구현 방법, 카메라/위치/연락처/앨범 등 디바이스 기능 사용법, 인앱결제/광고 구현 예제, 공유(share link/text) 기능 구현, 스토리지/클립보드 사용법, 네트워크 상태 감지, 햅틱 피드백 구현, 로케일/플랫폼 감지, 운영 환경 확인, 게임 미니앱 개발, 토스 로그인 연동 예제, jQuery/React/Vue 미니앱 예제, @toss/miniapp-sdk 사용법, bridge 함수 호출 패턴, 미니앱 프로젝트 구조 참고"
---

# 앱인토스 미니앱 코드 패턴 레퍼런스

> 공식 예제 저장소: `toss/apps-in-toss-examples`

이 스킬은 앱인토스(Apps in Toss) 미니앱 개발 시 참고할 수 있는 코드 패턴과 예제를 제공합니다.
**모든 예제 코드는 GitHub 저장소에서 동적으로 탐색·조회합니다.** 하드코딩된 목록에 의존하지 마세요.

---

## 코드 조회 워크플로우

**WebFetch는 사용하지 마세요** — 내부 모델이 코드를 요약해버려 원본이 유실됩니다.

### 1단계: 예제 디렉토리 탐색

저장소에 어떤 예제가 있는지 동적으로 조회합니다. 디렉토리 이름은 기능을 나타냅니다 (예: `with-camera`, `with-storage`, `with-in-app-purchase`).

```bash
gh api repos/toss/apps-in-toss-examples/contents/ \
  --jq '.[] | select(.type=="dir") | .name'
```

사용자의 요청에 맞는 디렉토리를 키워드로 매칭하세요:
- "카메라" → `with-camera`
- "위치" → `with-location-*`
- "광고" → `with-interstitial-ad`, `with-rewarded-ad`
- "결제" → `with-in-app-purchase`
- "공유" → `with-share-*`
- "저장" → `with-storage`

### 2단계: 디렉토리 내부 구조 확인

```bash
gh api repos/toss/apps-in-toss-examples/contents/{디렉토리명}/src \
  --jq '.[] | "\(.type) \(.name) \(.size // 0)B"'
```

하위 디렉토리가 있으면 재귀적으로 탐색하세요:

```bash
gh api repos/toss/apps-in-toss-examples/contents/{디렉토리명}/src/{하위경로} \
  --jq '.[] | "\(.type) \(.name)"'
```

### 3단계: 소스 코드 조회

```bash
curl -s https://raw.githubusercontent.com/toss/apps-in-toss-examples/main/{디렉토리명}/{파일경로}
```

### 조회 우선순위

각 예제에서 우선적으로 확인할 파일:

1. **`package.json`** — 의존성, SDK 버전, 스크립트 확인
2. **`src/pages/index.tsx`** — 메인 페이지 (핵심 구현 코드)
3. **`src/hooks/`** — 커스텀 훅 (SDK 호출 패턴)
4. **`src/components/`** — UI 컴포넌트
5. **`src/_app.tsx`** — 앱 컨테이너
6. **`granite.config.ts`** — Granite 프레임워크 설정

---

## 조회 방법별 토큰 효율

| 방법 | 파일 조회 | 디렉토리 조회 | 권장 |
|------|-----------|---------------|------|
| `curl` raw URL | 순수 코드 (최소) | 불가 | 파일 읽기용 |
| `gh api --jq` | jq+decode 필요 | 이름/크기만 (최소) | 디렉토리 조회용 |
| `gh api` (raw) | JSON+base64 (3.8x) | 전체 JSON (42x) | 비권장 |
| `WebFetch` | 요약문 (코드 유실) | HTML 잡음 | 사용 금지 |
| Playwright | 전체 DOM | 전체 DOM | 사용 금지 |

---

## SDK 사용 패턴 개요

### Granite 프레임워크 (`@apps-in-toss/framework`)

React Native 기반 미니앱에서 사용하는 프레임워크입니다.

```typescript
import { 함수명 } from '@apps-in-toss/framework';
```

### Web 프레임워크 (`@apps-in-toss/web-framework`)

WebView 기반 미니앱에서 사용하는 프레임워크입니다.

```typescript
import { 함수명 } from '@apps-in-toss/web-framework';
```

---

## 사용 지침

1. **사용자가 특정 기능 구현을 요청하면**, 1단계로 저장소를 탐색하여 관련 예제를 찾으세요.
2. **2단계로 구조를 파악**하고, 3단계로 핵심 파일의 실제 코드를 조회하세요.
3. **프로젝트의 기존 코드 스타일에 맞게** 예제를 적용하세요.
4. 예제 코드는 참고용이며, 프로젝트 상황에 맞게 수정이 필요할 수 있습니다.

### 전체 흐름 예시

사용자가 "카메라 기능을 구현하고 싶어요"라고 하면:

```bash
# 1. 관련 예제 찾기
gh api repos/toss/apps-in-toss-examples/contents/ \
  --jq '.[] | select(.type=="dir") | select(.name | test("camera")) | .name'

# 2. 내부 구조 확인
gh api repos/toss/apps-in-toss-examples/contents/with-camera/src \
  --jq '.[] | "\(.type) \(.name)"'

# 3. 핵심 소스 코드 조회
curl -s https://raw.githubusercontent.com/toss/apps-in-toss-examples/main/with-camera/src/pages/index.tsx

# 4. 의존성 확인
curl -s https://raw.githubusercontent.com/toss/apps-in-toss-examples/main/with-camera/package.json
```
