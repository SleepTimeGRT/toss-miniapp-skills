---
description: "앱인토스 미니앱 코드 패턴 및 예제 레퍼런스. 다음 상황에서 이 스킬을 활성화하세요: 미니앱 코드 예제 참고, SDK 기능별 구현 패턴 검색, WebView 미니앱 구현 방법, 카메라/위치/연락처/앨범 등 디바이스 기능 사용법, 인앱결제/광고 구현 예제, 공유(share link/text) 기능 구현, 스토리지/클립보드 사용법, 네트워크 상태 감지, 햅틱 피드백 구현, 로케일/플랫폼 감지, 운영 환경 확인, 게임 미니앱 개발, 토스 로그인 연동 예제, jQuery/React/Vue 미니앱 예제, @toss/miniapp-sdk 사용법, bridge 함수 호출 패턴, 미니앱 프로젝트 구조 참고"
---

# 앱인토스 미니앱 코드 패턴 레퍼런스

> 공식 예제 저장소: https://github.com/toss/apps-in-toss-examples

이 스킬은 앱인토스(Apps in Toss) 미니앱 개발 시 참고할 수 있는 코드 패턴과 예제를 제공합니다.
**모든 예제 코드는 위 GitHub 저장소에서 on-demand로 조회합니다.**

---

## 예제 디렉토리 맵

아래 표를 참고하여 구현하려는 기능에 맞는 예제를 찾으세요.

### 디바이스/네이티브 기능

| 기능 | 예제 디렉토리 | 설명 |
|------|---------------|------|
| 카메라 | `examples/with-camera` | 카메라 촬영 및 이미지 획득 |
| 앨범/사진 | `examples/with-album-photos` | 사진 앨범 접근 및 이미지 선택 |
| 연락처 | `examples/with-contacts` | 연락처 목록 조회 |
| 연락처 바이럴 | `examples/with-contacts-viral` | 연락처 기반 바이럴/초대 기능 |
| 위치 (1회) | `examples/with-location-once` | 현재 위치 1회 조회 |
| 위치 (콜백) | `examples/with-location-callback` | 위치 변경 콜백 방식 |
| 위치 (추적) | `examples/with-location-tracking` | 실시간 위치 추적 |
| 클립보드 | `examples/with-clipboard-text` | 텍스트 클립보드 복사/붙여넣기 |
| 햅틱 피드백 | `examples/with-haptic-feedback` | 진동/햅틱 피드백 |
| 네트워크 상태 | `examples/with-network-status` | 네트워크 연결 상태 감지 |

### 플랫폼/환경 감지

| 기능 | 예제 디렉토리 | 설명 |
|------|---------------|------|
| 로케일 | `examples/with-locale` | 사용자 언어/지역 설정 감지 |
| 플랫폼 OS | `examples/with-platform-os` | iOS/Android 플랫폼 감지 |
| 운영 환경 | `examples/with-operational-environment` | 운영/개발 환경 구분 |

### 수익화 (광고/결제)

| 기능 | 예제 디렉토리 | 설명 |
|------|---------------|------|
| 전면 광고 | `examples/with-interstitial-ad` | 전면(interstitial) 광고 구현 |
| 리워드 광고 | `examples/with-rewarded-ad` | 리워드(보상형) 광고 구현 |
| 인앱결제 | `examples/with-in-app-purchase` | 인앱결제 (IAP) 구현 |

### 공유 기능

| 기능 | 예제 디렉토리 | 설명 |
|------|---------------|------|
| 링크 공유 | `examples/with-share-link` | 딥링크/URL 공유 |
| 텍스트 공유 | `examples/with-share-text` | 텍스트 콘텐츠 공유 |

### 인증/로그인

| 기능 | 예제 디렉토리 | 설명 |
|------|---------------|------|
| 토스 로그인 | `examples/with-app-login` | 토스 앱 로그인 연동 |

### 데이터 저장

| 기능 | 예제 디렉토리 | 설명 |
|------|---------------|------|
| 스토리지 | `examples/with-storage` | 로컬 스토리지 데이터 저장/조회 |

### 게임

| 기능 | 예제 디렉토리 | 설명 |
|------|---------------|------|
| 게임 예제 | `examples/with-game` | 게임 미니앱 기본 구조 |
| 랜덤 볼 | `examples/random-balls` | 게임 예제 (물리/애니메이션) |

### 프레임워크별 예제

| 프레임워크 | 예제 디렉토리 | 설명 |
|------------|---------------|------|
| React | `examples/weekly-todo-react` | React 기반 미니앱 패턴 |
| Vue | `examples/weekly-todo-vue` | Vue 기반 미니앱 패턴 |
| jQuery | `examples/weekly-todo-jquery` | jQuery 기반 미니앱 패턴 |

---

## 코드 조회 방법

예제 코드가 필요할 때는 GitHub 저장소에서 직접 조회합니다.

### 파일 목록 조회

```
WebFetch: https://github.com/toss/apps-in-toss-examples/tree/main/examples/{디렉토리명}
```

### 소스 코드 조회

```
WebFetch: https://raw.githubusercontent.com/toss/apps-in-toss-examples/main/examples/{디렉토리명}/{파일경로}
```

### 주요 조회 대상 파일

각 예제 디렉토리에서 우선적으로 확인해야 할 파일:

1. **`package.json`** - 의존성 및 SDK 버전 확인
2. **`src/App.tsx`** 또는 **`src/App.vue`** 또는 **`src/main.ts`** - 메인 앱 코드
3. **`index.html`** - HTML 엔트리포인트
4. **`src/`** 디렉토리 전체 - 구현 코드
5. **`vite.config.ts`** / **`tsconfig.json`** - 빌드/타입 설정

---

## 기본 프로젝트 구조 (WebView 미니앱)

앱인토스 WebView 미니앱 예제의 일반적인 프로젝트 구조:

```
example-app/
├── index.html              # HTML 엔트리포인트
├── package.json            # 의존성 (@toss/miniapp-sdk 등)
├── tsconfig.json           # TypeScript 설정
├── vite.config.ts          # Vite 빌드 설정
└── src/
    ├── App.tsx             # 메인 앱 컴포넌트
    ├── main.tsx            # React 렌더링 엔트리
    ├── App.css             # 스타일시트
    └── vite-env.d.ts       # Vite 타입 선언
```

---

## SDK 사용 패턴 개요

### WebView 미니앱 SDK (`@toss/miniapp-sdk`)

WebView 기반 미니앱에서 토스 네이티브 기능을 호출할 때 사용하는 SDK입니다.

```typescript
// 일반적인 import 패턴
import { 함수명 } from '@toss/miniapp-sdk';
```

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

1. **사용자가 특정 기능 구현을 요청하면**, 위 디렉토리 맵에서 해당 기능의 예제를 찾으세요.
2. **GitHub 저장소에서 실제 코드를 조회**하여 최신 패턴을 확인하세요.
3. **프로젝트의 기존 코드 스타일에 맞게** 예제를 적용하세요.
4. 예제 코드는 참고용이며, 프로젝트 상황에 맞게 수정이 필요할 수 있습니다.

### 코드 조회 예시

사용자가 "카메라 기능을 구현하고 싶어요"라고 하면:

1. 디렉토리 맵에서 `examples/with-camera` 확인
2. `https://github.com/toss/apps-in-toss-examples/tree/main/examples/with-camera` 에서 파일 목록 조회
3. 주요 소스 파일(App.tsx 등) 내용 조회
4. 패턴을 파악하여 사용자 프로젝트에 맞게 안내
