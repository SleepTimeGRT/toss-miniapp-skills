# WebView 미니앱 튜토리얼

> 출처: https://developers-apps-in-toss.toss.im/tutorials/webview.md

## 새 웹 프로젝트 시작하기

Vite(React + TypeScript) 기준 예시:

```bash
npm create vite@latest {project명} -- --template react-ts
cd {project명}
npm install
npm run dev
```

> npm 기준. pnpm/yarn도 동일하게 사용 가능해요.

기존 웹 서비스가 이미 있다면, 아래 가이드에 따라 `@apps-in-toss/web-framework`를 설치해주세요.

## 설치하기

```sh
npm install @apps-in-toss/web-framework
```

> npm 기준. pnpm/yarn도 동일.

## 환경 구성하기

`ait init` 명령어를 실행해 환경을 구성할 수 있어요.

```sh
npx ait init
```

> npm 기준. pnpm은 `pnpm ait init`, yarn은 `yarn ait init`.

> **Cannot set properties of undefined (setting 'dev') 오류가 발생한다면?**
>
> package.json scripts 필드의 dev 필드에, 원래 사용하던 번들러의 개발 모드를 띄우는 커맨드를 입력 후 다시 시도해주세요.

1. `web-framework`를 선택하세요.
2. 앱 이름(`appName`)을 입력하세요.

> **appName 입력 시 주의하세요**
>
> * 이 이름은 앱인토스 콘솔에서 앱을 만들 때 사용한 이름과 같아야 해요.
> * 앱 이름은 각 앱을 식별하는 **고유한 키**로 사용돼요.
> * appName은 `intoss://{appName}/path` 형태의 딥링크 경로나 테스트/배포 시 사용하는 앱 전용 주소 등에서도 사용돼요.
> * 샌드박스 앱에서 테스트할 때도 `intoss://{appName}`으로 접근해요.

3. 웹 번들러의 dev 명령어를 입력해주세요.
4. 웹 번들러의 build 명령어를 입력해주세요.
5. 웹 개발 서버에서 사용할 포트 번호를 입력하세요.

### 설정 파일 확인하기

설정을 완료하면 `granite.config.ts` 파일이 생성돼요.
자세한 설정 방법은 [공통 설정](/bedrock/reference/framework/UI/Config.html) 문서를 확인해 주세요.

```ts [granite.config.ts]
import { defineConfig } from '@apps-in-toss/web-framework/config';

export default defineConfig({
  appName: 'ping-pong', // 앱인토스 콘솔에서 설정한 앱 이름
  brand: {
    displayName: '%%appName%%', // 화면에 노출될 앱의 한글 이름으로 바꿔주세요.
    primaryColor: '#3182F6', // 화면에 노출될 앱의 기본 색상으로 바꿔주세요.
    icon: https://static.toss.im/appsintoss/0000/granite.png, // 콘솔에서 업로드한 이미지의 URL
  },
  web: {
    host: 'localhost', // 앱 내 웹뷰에 사용될 host
    port: 5173,
    commands: {
      dev: 'vite', // 개발 모드 실행
      build: 'vite build', // 빌드 명령어
    },
  },
  permissions: [],
});
```

* `brand`: 앱 브랜드와 관련된 구성이에요.
  * `displayName`: 브릿지 뷰에 표시할 앱 이름이에요.
  * `icon`: 앱의 로고 이미지 URL. 콘솔의 앱 정보에서 업로드한 이미지를 우클릭해 링크 복사 후 입력.
  * `primaryColor`: TDS 컴포넌트에서 사용할 대표 색상. RGB HEX 형식(eg. `#3182F6`).
* `web.commands.dev`: `granite dev` 실행 시 함께 실행할 명령어.
* `web.commands.build`: `granite build` 실행 시 함께 실행할 명령어.
* `webViewProps.type`: 미니앱에 맞게 내비게이션 바를 설정할 수 있어요.
  * `partner`: 비게임 파트너사 콘텐츠 기본 웹뷰 (기본값).
  * `game`: 게임 미니앱에서 사용.

> **웹 빌드 시 주의사항**
>
> `granite build`를 실행하면 `web.commands.build`가 실행되고, 결과물을 바탕으로 `.ait` 파일을 만들어요. `web.commands.build`의 결과물은 `granite.config.ts`의 `outdir` 경로와 같아야 해요.
> `outdir`의 기본값은 프로젝트 경로의 `dist` 폴더이며, 필요하면 수정 가능해요.

### WebView TDS 패키지 설치하기

**TDS (Toss Design System)** 패키지는 웹뷰 기반 미니앱이 일관된 UI/UX를 유지하도록 돕는 토스의 디자인 시스템이에요.
모든 비게임 WebView 미니앱은 TDS 사용이 필수이며, 검수 승인 기준에도 포함돼요.

| @apps-in-toss/web-framework 버전 | 사용할 패키지              |
| -------------------------------- | -------------------------- |
| < 1.0.0                          | @toss-design-system/mobile |
| >= 1.0.0                         | @toss/tds-mobile           |

TDS 가이드: [WebView TDS](https://tossmini-docs.toss.im/tds-mobile/)

> **TDS 테스트**: 로컬 브라우저에서는 TDS가 동작하지 않아요. [샌드박스앱](/development/test/sandbox)을 통해 테스트하세요.

## 서버 실행하기

```sh
npm run dev
```

> npm 기준. pnpm/yarn도 동일.

로컬 개발 서버를 실행하면 웹 개발 서버와 React Native 개발 서버가 함께 실행돼요. HMR(Hot Module Replacement)도 지원해요.

> **'[Apps In Toss Plugin] 플러그인 옵션이 올바르지 않습니다' 에러 발생 시**
> `granite.config.ts`의 `icon` 설정을 확인해주세요. 아이콘을 아직 정하지 않았다면 `''`(빈 문자열)로 비워둔 상태로도 테스트할 수 있어요.

### 실기기에서 접근 가능하게 설정하기

실기기에서 테스트하려면 번들러에 `--host` 옵션을 활성화하고, `web.host`를 실기기에서 접근할 수 있는 IP 주소로 설정하세요.

```ts [granite.config.ts]
import { defineConfig } from '@apps-in-toss/web-framework/config';

export default defineConfig({
  appName: 'ping-pong',
  web: {
    host: '192.168.0.100', // 실 기기에서 접근할 수 있는 IP 주소로 변경
    port: 5173,
    commands: {
      dev: 'vite --host', // --host 옵션 활성화
      build: 'vite build',
    },
  },
  permissions: [],
});
```

## 미니앱 실행하기(시뮬레이터/실기기)

샌드박스 앱 설치가 필수예요. [샌드박스앱](/development/test/sandbox) 참고.

### iOS 시뮬레이터

1. 앱인토스 샌드박스 앱 실행
2. `intoss://{서비스이름}` 입력 후 "스키마 열기" 클릭

### iOS 실기기

로컬 서버와 같은 와이파이에 연결되어 있어야 해요.

1. 샌드박스 앱 실행 후 "로컬 네트워크" 권한 허용
2. 서버 주소 입력 (macOS에서 `ipconfig getifaddr en0`으로 확인)
3. "스키마 열기" 클릭

### Android

1. USB 연결 후 adb reverse 설정:
   ```shell
   adb reverse tcp:8081 tcp:8081
   adb reverse tcp:5173 tcp:5173
   ```
2. 샌드박스 앱에서 `intoss://{서비스이름}` 실행

## 출시하기

출시 방법은 [미니앱 출시](/development/deploy) 문서를 참고하세요.
