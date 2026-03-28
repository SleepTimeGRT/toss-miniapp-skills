# Sentry 에러 모니터링 상세 설정

원문 URL: https://developers-apps-in-toss.toss.im/learn-more/sentry-monitoring.md

## 1. Sentry 초기 설정

https://docs.sentry.io/platforms/react-native 를 참고하여 앱에서 Sentry를 초기화해주세요.

앱인토스 환경에서는 네이티브 오류 추적 기능을 사용할 수 없으므로 `enableNative` 옵션을 `false`로 설정해야 해요.

```ts
import * as Sentry from '@sentry/react-native';

Sentry.init({
  // ...
  enableNative: false,
});
```

## 2. Sentry 플러그인 설치

```bash
npm install @granite-js/plugin-sentry
```

> yarn, pnpm 사용 시 각각 `yarn add`, `pnpm install`로 대체하세요.

## 3. 플러그인 구성

`granite.config.ts` 파일의 `plugins` 항목에 추가하세요. 앱인토스 환경에서는 **`useClient` 옵션을 반드시 `false`로 설정**해야 해요.

> **왜 `useClient` 옵션을 꺼야 하나요?**
>
> `useClient`를 `false`로 설정하면 앱 빌드 시 Sentry에 소스맵이 자동으로 업로드되지 않아요. 앱인토스 환경에서는 빌드 후 수동으로 소스맵을 업로드해야 하므로, 이 옵션을 꺼야 해요.

```ts
// granite.config.ts
import { defineConfig } from '@granite-js/react-native/config';
import { sentry } from '@granite-js/plugin-sentry';
import { appsInToss } from '@apps-in-toss/framework/plugins';

export default defineConfig({
  // ...,
  plugins: [
    sentry({ useClient: false }),
    appsInToss({
      // ...
    }),
  ],
});
```

## 4. 앱 출시하기

앱을 출시하는 방법은 미니앱 출시 문서를 참고하세요.

## 5. Sentry에 소스맵 업로드

출시된 미니앱의 오류를 정확히 추적하려면 빌드 후 생성된 소스맵을 Sentry에 업로드해야 해요.

> **입력값 안내**
>
> * `<API_KEY>`: 앱인토스 콘솔에서 발급받은 API 키
> * `<APP_NAME>`: Sentry에 등록된 서비스 이름
> * `<DEPLOYMENT_ID>`: 앱을 배포할 때 사용한 배포 ID

```bash
npx ait sentry upload-sourcemap \
  --api-key <API_KEY> \
  --app-name <APP_NAME> \
  --deployment-id <DEPLOYMENT_ID>
```

> pnpm/yarn 사용 시 `npx`를 `pnpm`/`yarn`으로 대체하세요.

명령어 실행 후 Sentry의 조직(Org), 프로젝트(Project), 인증 토큰 입력이 요청됩니다. 모든 정보를 입력하면 해당 서비스의 소스맵이 Sentry에 업로드돼요.
