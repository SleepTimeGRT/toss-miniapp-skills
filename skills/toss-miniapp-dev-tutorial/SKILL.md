---
description: "앱인토스 미니앱 개발 튜토리얼 관련 질문에 사용하세요. 다음 상황에서 이 스킬을 활성화하세요: React Native 미니앱 개발 시작, WebView 미니앱 개발 시작, Granite 프레임워크 설정, granite.config.ts 구성, ait init 명령어 사용, 번들(.ait) 파일 생성, Metro 개발 서버 실행, 파일 기반 라우팅, iOS/Android 샌드박스 앱 연결, adb reverse 포트 설정, TDS(Toss Design System) 패키지 설치, @apps-in-toss/framework 또는 @apps-in-toss/web-framework 설치, LLM/AI 도구 설정, MCP 서버 연결, Cursor @docs 기능, llms.txt 활용, Unity WebGL 미니앱 전환 방법"
---

# 앱인토스 미니앱 개발 튜토리얼

## 목차

1. [React Native 튜토리얼](#react-native-튜토리얼)
2. [WebView 튜토리얼](#webview-튜토리얼)
3. [AI 개발 가이드 (LLM/MCP)](#ai-개발-가이드)
4. [Unity WebGL 미니앱 가이드](#unity-webgl-미니앱-가이드)

---

## React Native 튜토리얼

> 출처: https://developers-apps-in-toss.toss.im/tutorials/react-native.md

> **기존 RN 프로젝트가 있는 경우**: 앱인토스에서 동작하려면 **Granite 기반으로 스캐폴딩**해야 해요.

### 스캐폴딩

```sh
npm create granite-app
```

> npm 기준. pnpm/yarn도 동일.

1. **앱 이름 지정**: [kebab-case](https://developer.mozilla.org/en-US/docs/Glossary/Kebab_case) 형식 (예: `my-granite-app`)
2. **도구 선택**: `prettier + eslint` 또는 `biome` 중 선택
3. **의존성 설치**: `cd my-granite-app && npm install`

### 환경 구성하기

#### 설치하기

```sh
npm install @apps-in-toss/framework
```

> npm 기준. pnpm/yarn도 동일.

#### 설정파일 구성하기

`ait init` 명령어로 앱 개발에 필요한 기본 환경을 구성해요.

```sh
npx ait init
```

> npm 기준. pnpm은 `pnpm ait init`, yarn은 `yarn ait init`.

1. 프레임워크를 선택하세요.
2. 앱 이름(`appName`)을 입력하세요. (앱인토스 콘솔에서 만든 앱 이름과 동일해야 해요)

완료하면 프로젝트 루트에 `granite.config.ts`가 생성돼요.

```ts [granite.config.ts]
import { appsInToss } from '@apps-in-toss/framework/plugins';
import { defineConfig } from '@granite-js/react-native/config';

export default defineConfig({
  appName: '<app-name>',
  plugins: [
    appsInToss({
      brand: {
        displayName: '%%appName%%', // 화면에 노출될 앱의 한글 이름으로 바꿔주세요.
        primaryColor: '#3182F6', // 화면에 노출될 앱의 기본 색상으로 바꿔주세요.
        icon: null, // 화면에 노출될 앱의 아이콘 이미지 주소로 바꿔주세요.
      },
      permissions: [],
    }),
  ],
});
```

* `<app-name>`: 앱인토스에서 만든 앱 이름
* `brand.displayName`: 내비게이션 바에 표시할 앱 이름
* `brand.icon`: 앱 아이콘 이미지 주소
* `brand.primaryColor`: TDS 컴포넌트 대표 색상 (RGB HEX, eg. `#3182F6`)
* `permissions`: [권한 설정](/bedrock/reference/framework/권한/permission) 참고

#### React Native TDS 패키지 설치하기

**TDS (Toss Design System)** 패키지는 필수이며, 검수 승인 기준에 포함돼요.

| @apps-in-toss/framework 버전 | 사용할 패키지                    |
| ---------------------------- | -------------------------------- |
| < 1.0.0                      | @toss-design-system/react-native |
| >= 1.0.0                     | @toss/tds-react-native           |

TDS 가이드: [React Native TDS](https://tossmini-docs.toss.im/tds-react-native/)

> **TDS 테스트**: 로컬 브라우저에서는 TDS가 동작하지 않아요. [샌드박스앱](/development/test/sandbox)을 통해 테스트하세요.

#### 번들 파일 생성하기

```sh
npm run build
```

> npm 기준. pnpm/yarn도 동일.

프로젝트 루트에 `<서비스명>.ait` 파일이 생성돼요. 출시 시 이 파일을 사용해요.

### 코드 확인해보기

`_app.tsx` 파일 구조:

```tsx [_app.tsx]
import { AppsInToss } from '@apps-in-toss/framework';
import { PropsWithChildren } from 'react';
import { InitialProps } from '@granite-js/react-native';
import { context } from '../require.context';

function AppContainer({ children }: PropsWithChildren<InitialProps>) {
  return <>{children}</>;
}

export default AppsInToss.registerApp(AppContainer, { context });
```

스캐폴딩 시 `pages/index.tsx`에 `createRoute`를 사용한 Welcome 페이지가 생성돼요. `Route.useNavigation()`으로 페이지 이동이 가능해요.

### 파일 기반 라우팅 이해하기

Granite은 [파일 시스템 기반 라우팅](https://nextjs.org/docs/app/building-your-application/routing#roles-of-folders-and-files)을 사용해요. 파일 구조에 따라 자동으로 스킴이 결정돼요.

```
my-granite-app
└─ pages
    ├─ index.tsx       // intoss://my-granite-app
    ├─ detail.tsx      // intoss://my-granite-app/detail
    └─ item
        ├─ index.tsx    // intoss://my-granite-app/item
        └─ detail.tsx    // intoss://my-granite-app/item/detail
```

모든 Granite 화면은 `intoss://` 스킴으로 시작해요: `intoss://{서비스이름}/{pages 하위 경로}`.

### 서버 실행하기

```sh
npm run dev
```

> npm 기준. pnpm/yarn도 동일. 앱 실행 환경 설정: [iOS](/development/client/ios) | [Android](/development/client/android)

### 미니앱 실행하기(시뮬레이터/실기기)

> 샌드박스 앱 설치가 필수예요. [샌드박스앱](/development/test/sandbox) 참고.

**iOS 시뮬레이터**: 샌드박스 앱에서 `intoss://{서비스이름}` 입력 후 "스키마 열기" 클릭. Metro 서버가 실행 중이면 자동 연결돼요.

**iOS 실기기**: 로컬 서버와 같은 와이파이에 연결 필요. 샌드박스 앱에서 로컬 서버 IP 주소 입력 (macOS: `ipconfig getifaddr en0`).

**Android**: USB 연결 후 `adb reverse tcp:8081 tcp:8081 && adb reverse tcp:5173 tcp:5173` 실행, 샌드박스 앱에서 스킴 실행.

> 트러블슈팅은 `references/troubleshooting.md`를 참고하세요.

### 토스앱에서 테스트하기 / 출시하기

* 토스앱 테스트: [토스앱](/development/test/toss) 문서 참고
* 출시: [미니앱 출시](/development/deploy) 문서 참고

---

## WebView 튜토리얼

> 출처: https://developers-apps-in-toss.toss.im/tutorials/webview.md

WebView 미니앱은 기존 웹 프로젝트에 `@apps-in-toss/web-framework`를 설치하여 개발해요. Vite, Webpack 등 어떤 빌드 환경이든 사용 가능하며, `npx ait init`으로 `granite.config.ts`를 생성한 뒤 `npm run dev`로 개발 서버를 실행하면 샌드박스 앱에서 바로 테스트할 수 있어요. TDS(Toss Design System) 패키지 설치가 필수이며, 비게임 WebView 미니앱은 검수 승인 기준에 포함돼요.

> 상세 설정/실행 가이드: `references/webview-tutorial.md`

---

## AI 개발 가이드

> 출처: https://developers-apps-in-toss.toss.im/development/llms.md

AI가 프로젝트의 문맥을 이해하면 더 정확한 코드와 답변을 제공할 수 있어요.

### 1. MCP(Model Context Protocol) 서버 사용하기

MCP를 사용하면 AI가 앱인토스 SDK 문서, API 스펙, 설정 파일을 자동으로 참조하여 더 정확한 코드를 생성할 수 있어요.

#### 설치하기

```[MacOS]
brew tap toss/tap && brew install ax
```

```[Windows]
scoop bucket add toss  https://github.com/toss/scoop-bucket.git
scoop install ax
```

#### Cursor에 MCP 서버 연결하기

`.cursor/mcp.json` 파일을 생성하거나 수정해 아래 내용을 추가하세요.

```json
{
 "mcpServers": {
   "apps-in-toss": {
     "command": "ax",
     "args": [
       "mcp", "start"
     ]
   }
 }
}
```

#### Claude Code에서 MCP 연결하기

```
claude mcp add --transport stdio apps-in-toss ax mcp start
```

---

### 2. IDE 외 LLM에서 앱인토스 문서 활용하기

Claude, Codex 등에서 앱인토스 공식 문서를 기반으로 답변을 받으려면 **Apps In Toss Skills**를 사용하세요.

* `docs-search`: 앱인토스 `llms-full.txt` 문서를 다운로드/캐시하여 키워드 + 의미 유사도 기반으로 관련 스니펫을 검색

#### Codex (skill-installer UI)

```bash
install GitHub repo toss/apps-in-toss-skills path apps-in-toss
```

#### Claude Code (plugin)

```bash
/plugin marketplace add toss/apps-in-toss-skills
/plugin install knowlege-skills@apps-in-toss-skills
```

#### 프롬프트 예시

```
Search guide with docs-search "How to develop Apps In Toss Mini App"
```

---

### 3. 문서 URL 등록하기 (@docs)

Cursor의 **Docs 인덱싱** 기능으로 앱인토스 문서를 AI에 연결할 수 있어요. Settings > Indexing & Docs > Docs > +Add Doc.

| 유형                   | URL                                                             |
| ---------------------- | --------------------------------------------------------------- |
| 기본 문서 (권장)       | `https://developers-apps-in-toss.toss.im/llms.txt`              |
| 전체 문서 (Full)       | `https://developers-apps-in-toss.toss.im/llms-full.txt`         |
| 예제 전용              | `https://developers-apps-in-toss.toss.im/tutorials/examples.md` |
| TDS (WebView)          | `https://tossmini-docs.toss.im/tds-mobile/llms-full.txt`        |
| TDS (React Native)     | `https://tossmini-docs.toss.im/tds-react-native/llms-full.txt`  |

### 4. 문서를 기반으로 AI 활용하기

```
@docs 앱인토스 인앱광고 샘플 코드 작성해줘
```

`@docs`를 사용하면 AI는 문서를 우선적으로 참고해 더 안정적인 답변을 제공해요. SDK처럼 정확한 규칙 기반 코드가 필요한 경우에 특히 유용해요.

---

## Unity WebGL 미니앱 가이드

> 출처: https://developers-apps-in-toss.toss.im/unity/intro/overview.md

Unity로 만든 게임을 앱인토스 미니앱 환경에 빠르게 전환할 수 있어요. 기존 Unity 프로젝트를 그대로 유지하면서 WebGL을 통해 엔진 교체나 핵심 코드 수정 없이 앱인토스 플랫폼에서 실행할 수 있도록 돕습니다. 문서 구조, 호환성 평가, 성능 최적화, 디버깅 가이드 등 상세 내용은 아래를 참고하세요.

> 상세 가이드: `references/unity-webgl.md`

커뮤니티: [앱인토스 개발자 포럼](https://techchat-apps-in-toss.toss.im/) | API 문서: [앱인토스 개발자센터](https://developers-apps-in-toss.toss.im/)
