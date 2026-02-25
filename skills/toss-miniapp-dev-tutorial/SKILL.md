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

> **기존 RN 프로젝트가 있는 경우**
> 이미 React Native로 만든 서비스가 있어도 앱인토스에서 동작하려면 **Granite 기반으로 스캐폴딩** 해야 해요.

Granite을 사용해 "Welcome!"페이지가 표시되는 서비스를 만들어볼게요.
이를 통해 로컬 서버를 연결하는 방법과 파일 기반 라우팅을 배울 수 있어요.

### 스캐폴딩

앱을 만들 위치에서 다음 명령어를 실행하세요.

이 명령어는 프로젝트를 초기화하고 필요한 파일과 디렉토리를 자동으로 생성해요.

```sh [npm]
$ npm create granite-app
```

```sh [pnpm]
$ pnpm create granite-app
```

```sh [yarn]
$ yarn create granite-app
```

#### 1. 앱 이름 지정하기

앱 이름은 [kebab-case](https://developer.mozilla.org/en-US/docs/Glossary/Kebab_case) 형식으로 만들어 주세요.
예를 들어, 아래와 같이 입력해요.

```shell
# 예시
my-granite-app
```

#### 2. 도구 선택하기

`granite`에서는 프로젝트를 생성할 때 필요한 도구를 선택할 수 있어요. 현재 제공되는 선택지는 다음 두 가지예요. 둘 중 한 가지 방법을 선택해서 개발 환경을 세팅하세요.

* `prettier` + `eslint`: 코드 포맷팅과 린팅을 각각 담당하며, 세밀한 설정과 다양한 플러그인으로 유연한 코드 품질 관리를 지원해요.
* `biome`: Rust 기반의 빠르고 통합적인 코드 포맷팅과 린팅 도구로, 간단한 설정으로 효율적인 작업이 가능해요.

#### 3. 의존성 설치하기

프로젝트 디렉터리로 이동한 뒤, 사용 중인 패키지 관리자에 따라 의존성을 설치하세요.

```sh [npm]
$ cd my-granite-app
$ npm install
```

```sh [pnpm]
$ cd my-granite-app
$ pnpm install
```

```sh [yarn]
$ cd my-granite-app
$ yarn install
```

스캐폴딩을 마쳤다면 프로젝트 구조가 생성돼요.

### 환경 구성하기

ReactNative SDK를 이용해 번들 파일을 생성하고 출시하는 방법을 소개해요.

#### 설치하기

앱인토스 미니앱을 개발하려면 `@apps-in-toss/framework` 패키지를 설치해야 해요. 사용하는 패키지 매니저에 따라 아래 명령어를 실행하세요.

```sh [npm]
$ npm install @apps-in-toss/framework
```

```sh [pnpm]
$ pnpm install @apps-in-toss/framework
```

```sh [yarn]
$ yarn add @apps-in-toss/framework
```

#### 설정파일 구성하기

`ait init` 명령어로 앱 개발에 필요한 기본 환경을 구성할 수 있어요.
자세한 설정 방법은 [공통 설정](/bedrock/reference/framework/UI/Config.html) 문서를 확인해 주세요.

1. 아래 명령어 중 사용하는 패키지 관리자에 맞는 명령어를 실행하세요.

```sh [npm]
npx ait init
```

```sh [pnpm]
pnpm ait init
```

```sh [yarn]
yarn ait init
```

2. 프레임워크를 선택하세요.

3. 앱 이름(`appName`)을 입력하세요.

   이 이름은 앱인토스 콘솔에서 앱을 만들 때 사용한 이름과 같아야 해요. 앱인토스 콘솔에서 앱 이름을 확인할 수 있어요.

모든 과정을 완료하면 프로젝트 루트에 `granite.config.ts` 파일이 생성돼요. 이 파일은 앱 설정을 관리하는 데 사용돼요.
자세한 설정 방법은 [공통 설정](/bedrock/reference/framework/UI/Config.html) 문서를 확인해 주세요.

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

* `<app-name>`: 앱인토스에서 만든 앱 이름이에요.
* `brand`: 앱 브랜드와 관련된 구성이에요.
  * `displayName`: 내비게이션 바에 표시할 앱 이름이에요.
  * `icon`: 앱 아이콘 이미지 주소예요. 사용자에게 앱 브랜드를 전달해요.
  * `primaryColor`: Toss 디자인 시스템(TDS) 컴포넌트에서 사용할 대표 색상이에요. RGB HEX 형식(eg. `#3182F6`)으로 지정해요.
* `permissions`: [권한이 필요한 함수 앱 설정하기](/bedrock/reference/framework/권한/permission) 문서를 참고해서 설정하세요.

#### React Native TDS 패키지 설치하기

**TDS (Toss Design System)** 패키지는 RN 기반 미니앱이 일관된 UI/UX를 유지하도록 돕는 토스의 디자인 시스템이에요.
`@apps-in-toss/framework`를 사용하려면 TDS React Native 패키지를 추가로 설치해야 해요.
모든 비게임 React Native 미니앱은 TDS 사용이 필수이며, 검수 승인 기준에도 포함돼요.

| @apps-in-toss/framework 버전 | 사용할 패키지                    |
| ---------------------------- | -------------------------------- |
| < 1.0.0                      | @toss-design-system/react-native |
| >= 1.0.0                     | @toss/tds-react-native           |

TDS에 대한 자세한 가이드는 [React Native TDS](https://tossmini-docs.toss.im/tds-react-native/)를 참고해 주세요.

> **TDS 테스트**
> 로컬 브라우저에서는 TDS가 동작하지 않아, 테스트할 수 없어요.
> 번거로우시더라도 [샌드박스앱](/development/test/sandbox)을 통한 테스트를 부탁드려요.

#### 번들 파일 생성하기

번들 파일은 `.ait` 확장자를 가진 파일로, 빌드된 프로젝트를 패키징한 결과물이에요. 이를 생성하려면 아래 명령어를 실행하세요.

```sh [npm]
npm run build
```

```sh [pnpm]
pnpm build
```

```sh [yarn]
yarn build
```

위 명령어를 실행하면 프로젝트 루트 디렉터리에 `<서비스명>.ait` 파일이 생성돼요. 해당 파일은 앱을 출시할 때 사용해요.

#### 앱 출시하기

앱을 출시하는 방법은 [앱 출시하기](/development/test/toss) 문서를 참고하세요.

### 코드 확인해보기

프로젝트의 `_app.tsx` 파일에 다음과 같은 코드가 들어있을 거예요.

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

#### 스캐폴딩 된 코드 알아보기

스캐폴딩 명령어를 실행하면 다음과 같은 파일이 생성돼요.

```tsx [/pages/index.tsx]
import { createRoute } from '@granite-js/react-native';
import React from 'react';
import { StyleSheet, View, Text, TouchableOpacity } from 'react-native';

export const Route = createRoute('/', {
  component: Page,
});

function Page() {
  const navigation = Route.useNavigation();

  const goToAboutPage = () => {
    navigation.navigate('/about');
  };

  return (
    <Container>
      <Text style={styles.title}>🎉 Welcome! 🎉</Text>
      <Text style={styles.subtitle}>
        This is a demo page for the <Text style={styles.brandText}>Granite</Text> Framework.
      </Text>
      <Text style={styles.description}>This page was created to showcase the features of the Granite.</Text>
      <TouchableOpacity style={styles.button} onPress={goToAboutPage}>
        <Text style={styles.buttonText}>Go to About Page</Text>
      </TouchableOpacity>
    </Container>
  );
}

function Container({ children }: { children: React.ReactNode }) {
  return <View style={styles.container}>{children}</View>;
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 16,
    backgroundColor: 'white',
    justifyContent: 'center',
    alignItems: 'center',
  },
  brandText: {
    color: '#0064FF',
    fontWeight: 'bold',
  },
  text: {
    fontSize: 24,
    color: '#202632',
    textAlign: 'center',
    marginBottom: 10,
  },
  title: {
    fontSize: 32,
    fontWeight: 'bold',
    color: '#1A202C',
    textAlign: 'center',
    marginBottom: 16,
  },
  subtitle: {
    fontSize: 18,
    color: '#4A5568',
    textAlign: 'center',
    marginBottom: 24,
  },
  description: {
    fontSize: 16,
    color: '#718096',
    textAlign: 'center',
    marginBottom: 32,
    lineHeight: 24,
  },
  button: {
    backgroundColor: '#0064FF',
    paddingVertical: 12,
    paddingHorizontal: 32,
    borderRadius: 8,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.25,
    shadowRadius: 3.84,
    elevation: 5,
  },
  buttonText: {
    color: 'white',
    fontSize: 16,
    fontWeight: 'bold',
    textAlign: 'center',
  },
  codeContainer: {
    padding: 8,
    backgroundColor: '#333',
    borderRadius: 4,
    width: '100%',
  },
  code: {
    color: 'white',
    fontFamily: 'monospace',
    letterSpacing: 0.5,
    fontSize: 14,
  },
});
```

### 파일 기반 라우팅 이해하기

Granite 개발 환경은 Next.js와 비슷한 [파일 시스템 기반의 라우팅](https://nextjs.org/docs/app/building-your-application/routing#roles-of-folders-and-files)을 사용해요.

파일 기반 라우팅은 파일 구조에 따라 자동으로 경로(URL 또는 스킴)가 결정되는 시스템이에요. 예를 들어, pages라는 디렉토리에 `detail.ts` 파일이 있다면, 이 파일은 자동으로 `/detail` 경로로 연결돼요.

Granite 애플리케이션에서는 이 개념이 스킴과 연결돼요. 스킴은 특정 화면으로 연결되는 주소인데요. 예를 들어, `pages/detail.ts`라는 파일은 자동으로 `intoss://my-granite-app/detail` 이라는 스킴으로 접근할 수 있는 화면이에요. 모든 Granite 화면은 `intoss://` 스킴으로 시작해요.

```
my-granite-app
└─ pages
    ├─ index.tsx       // intoss://my-granite-app
    ├─ detail.tsx      // intoss://my-granite-app/detail
    └─ item
        ├─ index.tsx    // intoss://my-granite-app/item
        └─ detail.tsx    // intoss://my-granite-app/item/detail
```

* `index.tsx` 파일: `intoss://my-granite-app`
* `detail.tsx` 파일: `intoss://my-granite-app/detail`
* `item/index.tsx` 파일: `intoss://my-granite-app/item`
* `item/detail.tsx` 파일: `intoss://my-granite-app/item/detail`

```
┌─ 모든 Granite 화면을 가리키는 스킴은
│  intoss:// 으로 시작해요
│
-------------
intoss://my-granite-app/detail
         ==============~~~~~~~
             │           └─ pages 하위에 있는 경로를 나타내요
             │
             └─ 서비스 이름을 나타내요
```

이렇게 개발자는 별도로 라우팅 설정을 하지 않아도, 파일을 추가하기만 하면 새로운 화면이 자동으로 설정돼요.

### 서버 실행하기

#### 로컬 개발 서버 실행하기

이제 여러분만의 Granite 페이지를 만들 준비가 끝났어요.
다음으로 로컬에서 `my-granite-app` 서비스를 실행해 볼게요.

> **앱 실행 환경을 먼저 설정하세요.**
> * [iOS 환경설정](/development/client/ios)
> * [Android 환경설정](/development/client/android)

스캐폴딩된 프로젝트 디렉터리로 이동한 뒤, 선택한 패키지 매니저를 사용해 `dev` 스크립트를 실행하세요. 이렇게 하면 개발 서버가 시작돼요.

```sh [npm]
$ cd my-granite-app
$ npm run dev
```

```sh [pnpm]
$ cd my-granite-app
$ pnpm dev
```

```sh [yarn]
$ cd my-granite-app
$ yarn dev
```

명령어를 실행하면 아래와 같은 화면이 표시돼요.
![Metro 실행 예시](/assets/local-develop-js-1.B_LK2Zlw.png)

> **참고하세요**
> 개발 서버 실행 중 too many open files 에러가 발생한다면, node_modules 디렉터리를 삭제한 뒤 다시 의존성을 설치해 보세요.
>
> ```sh
> rm -rf node_modules
> npm install  # 또는 yarn, pnpm에 맞게
> ```

> **실행 혹은 빌드시 '[Apps In Toss Plugin] 플러그인 옵션이 올바르지 않습니다' 에러가 발생한다면?**
> '[Apps In Toss Plugin] 플러그인 옵션이 올바르지 않습니다. granite.config.ts 구성을 확인해주세요.'
> 라는 메시지가 보인다면, `granite.config.ts`의 `icon` 설정을 확인해주세요.
> 아이콘을 아직 정하지 않았다면 ''(빈 문자열)로 비워둔 상태로도 테스트할 수 있어요.
>
> ```ts
> ...
> displayName: 'test-app', // 화면에 노출될 앱의 한글 이름으로 바꿔주세요.
> primaryColor: '#3182F6', // 화면에 노출될 앱의 기본 색상으로 바꿔주세요.
> icon: '',// 화면에 노출될 앱의 아이콘 이미지 주소로 바꿔주세요.
> ...
> ```

### 미니앱 실행하기(시뮬레이터·실기기)

> **준비가 필요해요**
> 미니앱은 샌드박스 앱을 통해서만 실행되기때문에 **샌드박스 앱(테스트앱)** 설치가 필수입니다.
> 개발 및 테스트를 위해 [샌드박스앱](/development/test/sandbox)을 설치해주세요.

#### iOS 시뮬레이터(샌드박스앱)에서 실행하기

1. **앱인토스 샌드박스 앱**을 실행해요.
2. 샌드박스 앱에서 스킴을 실행해요. 예를 들어 서비스 이름이 `kingtoss`라면, `intoss://kingtoss`를 입력하고 "스키마 열기" 버튼을 눌러주세요.
3. Metro 서버가 실행 중이라면 시뮬레이터와 자동으로 연결돼요. 화면 상단에 `Bundling {n}%...`가 표시되면 연결이 성공한 거예요.

아래는 iOS 시뮬레이터에서 로컬 서버를 연결한 후 "Welcome!" 페이지를 표시하는 예시예요.

#### iOS 실기기에서 실행하기

##### 서버 주소 입력하기

아이폰에서 **앱인토스 샌드박스 앱**을 실행하려면 로컬 서버와 같은 와이파이에 연결되어 있어야 해요. 아래 단계를 따라 설정하세요.

1. **샌드박스 앱**을 실행하면 **"로컬 네트워크" 권한 요청 메시지**가 표시돼요. 이때 **"허용"** 버튼을 눌러주세요.

2. **샌드박스 앱**에서 서버 주소를 입력하는 화면이 나타나요.

3. 컴퓨터에서 로컬 서버 IP 주소를 확인하고, 해당 주소를 입력한 뒤 저장해주세요.
   * IP 주소는 한 번 저장하면 앱을 다시 실행해도 변경되지 않아요.
   * macOS를 사용하는 경우, 터미널에서 `ipconfig getifaddr en0` 명령어로 로컬 서버의 IP 주소를 확인할 수 있어요.

4. **"스키마 열기"** 버튼을 눌러주세요.

5. 화면 상단에 `Bundling {n}%...` 텍스트가 표시되면 로컬 서버에 성공적으로 연결된 거예요.

> **"로컬 네트워크"를 수동으로 허용하는 방법**
> "로컬 네트워크" 권한을 허용하지 못한 경우, 아래 방법으로 수동 설정이 가능해요.
>
> 1. 아이폰의 [설정] 앱에서 **"앱인토스"** 를 검색해 이동해요.
> 2. **"로컬 네트워크"** 옵션을 찾아 켜주세요.

---

#### Android 실기기 또는 에뮬레이터 연결하기

1. Android 실기기(휴대폰 또는 태블릿)를 컴퓨터와 USB로 연결하세요. ([USB 연결 가이드](/development/client/android.html#기기-연결하기))

2. `adb` 명령어를 사용해서 `8081` 포트와 `5173`포트를 연결하고 연결 상태를 확인해요.

   **8081 포트, 5173 포트 연결하기**

   기기가 하나만 연결되어 있다면 아래 명령어만 실행해도 돼요.

   ```shell
   adb reverse tcp:8081 tcp:8081
   adb reverse tcp:5173 tcp:5173
   ```

   특정 기기를 연결하려면 `-s` 옵션과 디바이스 아이디를 추가해요.

   ```shell
   adb -s {디바이스아이디} reverse tcp:8081 tcp:8081
   # 예시: adb -s R3CX30039GZ reverse tcp:8081 tcp:8081
   adb -s {디바이스아이디} reverse tcp:5173 tcp:5173
   # 예시: adb -s R3CX30039GZ reverse tcp:5173 tcp:5173
   ```

   **연결 상태 확인하기**

   연결된 기기와 포트를 확인하려면 아래 명령어를 사용하세요.

   ```shell
   adb reverse --list
   # 연결된 경우 예시: UsbFfs tcp:8081 tcp:8081
   ```

   특정 기기를 확인하려면 `-s` 옵션을 추가해요.

   ```shell
   adb -s {디바이스아이디} reverse --list
   # 예시: adb -s R3CX30039GZ reverse --list

   # 연결된 경우 예시: UsbFfs tcp:8081 tcp:8081
   ```

3. **앱인토스 샌드박스 앱**에서 스킴을 실행하세요. 예를 들어, 서비스 이름이 `kingtoss`라면 `intoss://kingtoss`를 입력하고 실행 버튼을 누르세요.

4. Metro 서버가 실행 중이라면 실기기 또는 에뮬레이터와 자동으로 연결돼요. 화면 상단에 번들링 프로세스가 진행 중이면 연결이 완료된 거예요.

   아래는 Android 시뮬레이터에서 로컬 서버를 연결한 후 "Welcome!" 페이지를 표시하는 예시예요.

#### 자주 쓰는 `adb` 명령어(Android)

개발 중에 자주 쓰는 `adb` 명령어를 정리했어요.

**연결 끊기**

```shell
adb kill-server
```

**8081 포트 연결하기**

```shell
adb reverse tcp:8081 tcp:8081
adb reverse tcp:5173 tcp:5173
# 특정 기기 연결: adb -s {디바이스아이디} reverse tcp:8081 tcp:8081
```

**연결 상태 확인하기**

```shell
adb reverse --list
# 특정 기기 확인: adb -s {디바이스아이디} reverse --list
```

### 트러블슈팅 (React Native)

**Q. Metro 개발 서버가 열려 있는데 `잠시 문제가 생겼어요`라는 메시지가 표시돼요.**

개발 서버에 제대로 연결되지 않은 문제일 수 있어요. `adb` 연결을 끊고 다시 `8081` 포트를 연결하세요.

**Q. PC웹에서 Not Found 오류가 발생해요.**

8081 포트는 샌드박스 내에서 인식하기 위한 포트예요.
PC웹에서 8081 포트는 Not Found 오류가 발생해요.

**연결 가능한 기기가 없다고 떠요**

React Native View가 나타나는 시점에 개발 서버와 기기가 연결됩니다. 만약 연결 가능한 기기가 없다고 뜬다면, 개발 서버가 제대로 빌드되고 있는지 확인해 보세요. 다음 화면처럼 개발 서버가 빌드를 시작했다면 기기와의 연결이 정상적으로 이루어진 것입니다.

![개발 서버 연결 상태 확인 이미지](/assets/debugging-22.B1aIn4qo.png)

**REPL가 동작하지 않아요**

React Native의 버그로 인해 가끔 REPL이 멈추는 현상이 발생할 수 있어요. 이 문제를 해결하려면, 콘솔 탭 옆에 있는 눈 모양 아이콘을 클릭하고 입력 필드에 임의의 코드를 작성하고 평가해 보세요. 예를 들어 `__DEV__`, `1`, `undefined` 등의 코드를 입력하면 돼요.

![REPL 프리징 해결 방법 이미지](/resources/learn-more/debugging/debugging-23.png)

**네트워크 인스펙터가 동작하지 않아요**

React Native 애플리케이션에서 여러 개의 인스턴스가 생성될 수 있는데, 현재 네트워크 인스펙터는 다중 인스턴스를 지원하지 않아요. 따라서 가장 최근에 생성된 인스턴스와만 데이터를 주고받게 됩니다. 이로 인해 소켓 커넥션이 꼬여 네이티브에서 전송하는 데이터를 인스펙터가 받지 못할 수 있어요.

이 문제를 해결하려면 다음을 시도해 보세요.

1. 앱을 완전히 종료해요.
2. 개발 서버를 중단하고 네트워크 인스펙터를 닫아요.
3. 앱을 다시 시작하고 `dev` 스크립트를 실행해 개발 서버를 재실행해요.

이 절차로도 문제가 해결되지 않으면, 담당자에게 제보해 주세요.

### 토스앱에서 테스트하기

토스앱에서 테스트하는 방법은 [토스앱](/development/test/toss) 문서를 참고하세요.

### 출시하기

출시하는 방법은 [미니앱 출시](/development/deploy) 문서를 참고하세요.

---

## WebView 튜토리얼

> 출처: https://developers-apps-in-toss.toss.im/tutorials/webview.md

> **새 웹 프로젝트를 시작하시나요?**
> 이 가이드에서는 이해를 돕기 위해 **Vite(React + TypeScript)** 기준으로 설명합니다.
> 다른 빌드 환경을 사용하셔도 괜찮아요.
>
> ```bash [npm]
> npm create vite@latest {project명} -- --template react-ts
> cd {project명}
> npm install
> npm run dev
> ```
>
> ```bash [yarn]
> yarn create vite {project명} --template react-ts
> cd {project명}
> yarn
> yarn dev
> ```
>
> ```bash [pnpm]
> pnpm create vite@latest {project명} --template react-ts
> cd {project명}
> pnpm install
> pnpm dev
> ```
>
> 기존 웹 서비스가 이미 있으시다면, 아래 가이드에 따라 `@apps-in-toss/web-framework`를 설치해주세요.

기존 웹 프로젝트에 `@apps-in-toss/web-framework`를 설치하면 앱인토스 샌드박스에서 바로 개발하고 배포할 수 있어요.

### 설치하기

기존 웹 프로젝트에 아래 명령어 중 사용하는 패키지 매니저에 맞는 명령어를 실행하세요.

```sh [npm]
npm install @apps-in-toss/web-framework
```

```sh [pnpm]
pnpm install @apps-in-toss/web-framework
```

```sh [yarn]
yarn add @apps-in-toss/web-framework
```

### 환경 구성하기

`ait init` 명령어를 실행해 환경을 구성할 수 있어요.

1. `ait init` 명령어를 실행하세요.

```sh [npm]
npx ait init
```

```sh [pnpm]
pnpm ait init
```

```sh [yarn]
yarn ait init
```

> **Cannot set properties of undefined (setting 'dev') 오류가 발생한다면?**
>
> package.json scripts 필드의 dev 필드에, 원래 사용하던 번들러의 개발 모드를 띄우는 커맨드를 입력 후 다시 시도해주세요.

2. `web-framework`를 선택하세요.
3. 앱 이름(`appName`)을 입력하세요.

> **appName 입력 시 주의하세요**
>
> * 이 이름은 앱인토스 콘솔에서 앱을 만들 때 사용한 이름과 같아야 해요.
> * 앱 이름은 각 앱을 식별하는 **고유한 키**로 사용돼요.
> * appName은 `intoss://{appName}/path` 형태의 딥링크 경로나 테스트·배포 시 사용하는 앱 전용 주소 등에서도 사용돼요.
> * 샌드박스 앱에서 테스트할 때도 `intoss://{appName}`으로 접근해요.
>   단, 출시하기 메뉴의 QR 코드로 테스트할 때는 `intoss-private://{appName}`이 사용돼요.

4. 웹 번들러의 dev 명령어를 입력해주세요.
5. 웹 번들러의 build 명령어를 입력해주세요.
6. 웹 개발 서버에서 사용할 포트 번호를 입력하세요.

#### 설정 파일 확인하기

설정을 완료하면 설정 파일인 `granite.config.ts` 파일이 생성돼요.
자세한 설정 방법은 [공통 설정](/bedrock/reference/framework/UI/Config.html) 문서를 확인해 주세요.

```ts [granite.config.ts]
import { defineConfig } from '@apps-in-toss/web-framework/config';

export default defineConfig({
  appName: 'ping-pong', // 앱인토스 콘솔에서 설정한 앱 이름
  brand: {
    displayName: '%%appName%%', // 화면에 노출될 앱의 한글 이름으로 바꿔주세요.
    primaryColor: '#3182F6', // 화면에 노출될 앱의 기본 색상으로 바꿔주세요.
    icon: https://static.toss.im/appsintoss/0000/granite.png, // 콘솔에서 업로드한 이미지의 URL(콘솔의 앱 정보에서 업로드한 이미지를 우클릭해 링크 복사 후 넣어주세요)
  },
  web: {
    host: 'localhost', // 앱 내 웹뷰에 사용될 host
    port: 5173,
    commands: {
      dev: 'vite', // 개발 모드 실행 (webpack serve도 가능)
      build: 'vite build', // 빌드 명령어 (webpack도 가능)
    },
  },
  permissions: [],
});
```

* `brand`: 앱 브랜드와 관련된 구성이에요.
  * `displayName`: 브릿지 뷰에 표시할 앱 이름이에요. 미니앱 이름과 동일하게 넣어주세요.
  * `icon`: 앱의 로고 이미지 URL을 입력해 주세요. 콘솔의 앱 정보에서 업로드한 이미지를 우클릭해 링크 복사 후 넣어 주세요.
  * `primaryColor`: Toss 디자인 시스템(TDS) 컴포넌트에서 사용할 대표 색상이에요. RGB HEX 형식(eg. `#3182F6`)으로 지정해요.
* `web.commands.dev` 필드는 `granite dev` 명령어 실행 시 함께 실행할 명령어예요. 번들러의 개발 모드를 시작하는 명령어를 입력해주세요.
* `web.commands.build` 필드는 `granite build` 명령어 실행 시 함께 실행할 명령어예요. 번들러의 빌드 명령어를 입력해주세요.
* `webViewProps.type` 미니앱에 맞게 내비게이션 바를 설정할 수 있어요.
  * `partner`: 비게임 파트너사 콘텐츠에 사용하는 기본 웹뷰예요. 다른 값을 설정하지 않으면 이 값이 기본으로 사용돼요.
  * `game`: 게임 미니앱에서 사용해요.

> **웹 빌드 시 주의사항**
>
> `granite build`를 실행하면 `web.commands.build`가 실행되고, 이 과정에서 생성된 결과물을 바탕으로 `.ait` 파일을 만들어요. `web.commands.build`의 결과물은 `granite.config.ts`의 `outdir` 경로와 같아야 해요.
>
> `outdir`의 기본값은 프로젝트 경로의 `dist` 폴더지만, 필요하면 `granite.config.ts`에서 수정할 수 있어요. 만약 빌드 결과물이 `outdir`과 다른 경로에 저장되면 배포가 정상적으로 이루어지지 않을 수 있으니 주의하세요.

#### WebView TDS 패키지 설치하기

**TDS (Toss Design System)** 패키지는 웹뷰 기반 미니앱이 일관된 UI/UX를 유지하도록 돕는 토스의 디자인 시스템이에요.
`@apps-in-toss/web-framework`를 사용하려면 TDS WebView 패키지를 추가로 설치해야 해요.
모든 비게임 WebView 미니앱은 TDS 사용이 필수이며, 검수 승인 기준에도 포함돼요.

| @apps-in-toss/web-framework 버전 | 사용할 패키지              |
| -------------------------------- | -------------------------- |
| < 1.0.0                          | @toss-design-system/mobile |
| >= 1.0.0                         | @toss/tds-mobile           |

TDS에 대한 자세한 가이드는 [WebView TDS](https://tossmini-docs.toss.im/tds-mobile/)를 참고해주세요.

> **TDS 테스트**
> 로컬 브라우저에서는 TDS가 동작하지 않아, 테스트할 수 없어요.
> 번거로우시더라도 [샌드박스앱](/development/test/sandbox)을 통한 테스트를 부탁드려요.

### 서버 실행하기

#### 로컬 개발 서버 실행하기

로컬 개발 서버를 실행하면 웹 개발 서버와 React Native 개발 서버가 함께 실행돼요.
웹 개발 서버는 `granite.config.ts` 파일의 `web.commands.dev` 필드에 설정한 명령어를 사용해 실행돼요.

또, HMR(Hot Module Replacement)을 지원해서 코드 변경 사항을 실시간으로 반영할 수 있어요.

다음은 개발 서버를 실행하는 명령어에요.

Granite으로 스캐폴딩된 서비스는 `dev` 스크립트를 사용해서 로컬 서버를 실행할 수 있어요. 서비스의 루트 디렉터리에서 아래 명령어를 실행해 주세요.

```sh [npm]
npm run dev
```

```sh [pnpm]
pnpm run dev
```

```sh [yarn]
yarn dev
```

명령어를 실행하면 아래와 같은 화면이 표시돼요.
![Metro 실행 예시](/assets/local-develop-js-1.B_LK2Zlw.png)

> **실행 혹은 빌드시 '[Apps In Toss Plugin] 플러그인 옵션이 올바르지 않습니다' 에러가 발생한다면?**
> '[Apps In Toss Plugin] 플러그인 옵션이 올바르지 않습니다. granite.config.ts 구성을 확인해주세요.'
> 라는 메시지가 보인다면, `granite.config.ts`의 `icon` 설정을 확인해주세요.
> 아이콘을 아직 정하지 않았다면 ''(빈 문자열)로 비워둔 상태로도 테스트할 수 있어요.
>
> ```ts
> ...
> displayName: 'test-app', // 화면에 노출될 앱의 한글 이름으로 바꿔주세요.
> primaryColor: '#3182F6', // 화면에 노출될 앱의 기본 색상으로 바꿔주세요.
> icon: '',// 화면에 노출될 앱의 아이콘 이미지 주소로 바꿔주세요.
> ...
> ```

#### 개발 서버를 실기기에서 접근 가능하게 설정하기

실기기에서 테스트하려면 번들러를 실행할 때 `--host` 옵션을 활성화하고, `web.host`를 실 기기에서 접근할 수 있는 네트워크 주소로 설정해야 해요.

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

### 미니앱 실행하기(시뮬레이터·실기기)

> **준비가 필요해요**
> 미니앱은 샌드박스 앱을 통해서만 실행되기때문에 **샌드박스 앱(테스트앱)** 설치가 필수입니다.
> 개발 및 테스트를 위해 [샌드박스앱](/development/test/sandbox)을 설치해주세요.

#### iOS 시뮬레이터(샌드박스앱)에서 실행하기

1. **앱인토스 샌드박스 앱**을 실행해요.
2. 샌드박스 앱에서 스킴을 실행해요. 예를 들어 서비스 이름이 `kingtoss`라면, `intoss://kingtoss`를 입력하고 "스키마 열기" 버튼을 눌러주세요.

아래는 로컬 서버를 실행한 후, iOS 시뮬레이터의 샌드박스앱에서 서버에 연결하는 예시예요.

#### iOS 실기기에서 실행하기

##### 서버 주소 입력하기

아이폰에서 **앱인토스 샌드박스 앱**을 실행하려면 로컬 서버와 같은 와이파이에 연결되어 있어야 해요. 아래 단계를 따라 설정하세요.

1. **샌드박스 앱**을 실행하면 **"로컬 네트워크" 권한 요청 메시지**가 표시돼요. 이때 **"허용"** 버튼을 눌러주세요.

2. **샌드박스 앱**에서 서버 주소를 입력하는 화면이 나타나요.

3. 컴퓨터에서 로컬 서버 IP 주소를 확인하고, 해당 주소를 입력한 뒤 저장해주세요.
   * IP 주소는 한 번 저장하면 앱을 다시 실행해도 변경되지 않아요.
   * macOS를 사용하는 경우, 터미널에서 `ipconfig getifaddr en0` 명령어로 로컬 서버의 IP 주소를 확인할 수 있어요.

4. **"스키마 열기"** 버튼을 눌러주세요.

5. 화면 상단에 `Bundling {n}%...` 텍스트가 표시되면 로컬 서버에 성공적으로 연결된 거예요.

> **"로컬 네트워크"를 수동으로 허용하는 방법**
> "로컬 네트워크" 권한을 허용하지 못한 경우, 아래 방법으로 수동 설정이 가능해요.
>
> 1. 아이폰의 [설정] 앱에서 **"앱인토스"** 를 검색해 이동해요.
> 2. **"로컬 네트워크"** 옵션을 찾아 켜주세요.

---

#### Android 실기기 또는 에뮬레이터 연결하기

1. Android 실기기(휴대폰 또는 태블릿)를 컴퓨터와 USB로 연결하세요. ([USB 연결 가이드](/development/client/android.html#기기-연결하기))

2. `adb` 명령어를 사용해서 `8081` 포트와 `5173`포트를 연결하고 연결 상태를 확인해요.

   **8081 포트, 5173 포트 연결하기**

   기기가 하나만 연결되어 있다면 아래 명령어만 실행해도 돼요.

   ```shell
   adb reverse tcp:8081 tcp:8081
   adb reverse tcp:5173 tcp:5173
   ```

   특정 기기를 연결하려면 `-s` 옵션과 디바이스 아이디를 추가해요.

   ```shell
   adb -s {디바이스아이디} reverse tcp:8081 tcp:8081
   # 예시: adb -s R3CX30039GZ reverse tcp:8081 tcp:8081
   adb -s {디바이스아이디} reverse tcp:5173 tcp:5173
   # 예시: adb -s R3CX30039GZ reverse tcp:5173 tcp:5173
   ```

   **연결 상태 확인하기**

   연결된 기기와 포트를 확인하려면 아래 명령어를 사용하세요.

   ```shell
   adb reverse --list
   # 연결된 경우 예시: UsbFfs tcp:8081 tcp:8081
   ```

   특정 기기를 확인하려면 `-s` 옵션을 추가해요.

   ```shell
   adb -s {디바이스아이디} reverse --list
   # 예시: adb -s R3CX30039GZ reverse --list

   # 연결된 경우 예시: UsbFfs tcp:8081 tcp:8081
   ```

3. **앱인토스 샌드박스 앱**에서 스킴을 실행하세요. 예를 들어, 서비스 이름이 `kingtoss`라면 `intoss://kingtoss`를 입력하고 실행 버튼을 누르세요.

   아래는 Android 시뮬레이터에서 로컬 서버를 연결한 후 서비스를 표시하는 예시예요.

#### 자주 쓰는 `adb` 명령어 (Android)

개발 중에 자주 쓰는 `adb` 명령어를 정리했어요.

**연결 끊기**

```shell
adb kill-server
```

**8081 포트 연결하기**

```shell
adb reverse tcp:8081 tcp:8081
adb reverse tcp:5173 tcp:5173
# 특정 기기 연결: adb -s {디바이스아이디} reverse tcp:8081 tcp:8081
```

**연결 상태 확인하기**

```shell
adb reverse --list
# 특정 기기 확인: adb -s {디바이스아이디} reverse --list
```

### 트러블슈팅 (WebView)

**Q. `서버에 연결할 수 없습니다` 에러가 발생해요.**

`granite.config.ts` 의 `web.commands`에 '--host'를 추가 후, 서비스를 실행하여 어떤 호스트 주소로 서비스가 실행되는지 확인해요

```tsx
// granite.config.ts
  web: {
    ...
    commands: {
      dev: 'vite --host', // --host를 추가해요.
      build: 'tsc -b && vite build',
    },
    ...
  },
```

'--host' 추가 후, 서비스를 실행하여 주소를 확인해요

```tsx
// granite.config.ts
  web: {
     host: 'x.x.x.x', // 서비스가 실행되는 호스트 주소를 입력해요.
     ...
  },
```

샌드박스 앱에서 서비스 실행 전, metro 서버 주소도 호스트 주소로 변경해주세요.

**Q. Metro 개발 서버가 열려 있는데 `잠시 문제가 생겼어요`라는 메시지가 표시돼요.**

개발 서버에 제대로 연결되지 않은 문제일 수 있어요. `adb` 연결을 끊고 다시 `8081` 포트를 연결하세요.

**Q. PC웹에서 Not Found 오류가 발생해요.**

8081 포트는 샌드박스 내에서 인식하기 위한 포트예요.
PC웹에서 8081 포트는 Not Found 오류가 발생해요.

### 토스앱에서 테스트하기

토스앱에서 테스트하는 방법은 [토스앱](/development/test/toss) 문서를 참고하세요.

### 출시하기

출시하는 방법은 [미니앱 출시](/development/deploy) 문서를 참고하세요.

---

## AI 개발 가이드

> 출처: https://developers-apps-in-toss.toss.im/development/llms.md

AI가 프로젝트의 문맥을 이해하면 더 정확한 코드와 답변을 제공할 수 있어요.
Cursor에서는 **문서(URL)** 또는 **llms.txt** 파일을 등록해 AI가 참고할 컨텍스트를 제공할 수 있으며,
추가로 **MCP 서버를 사용하면** 훨씬 깊은 수준의 프로젝트 정보를 AI가 활용할 수 있어요.

> **왜 컨텍스트가 필요한가요?**
> AI는 기본적으로 프로젝트의 도메인 지식을 알고 있지 않아요.
> SDK 사용법, API 구조, 에러 규칙 등 필요한 정보를 함께 제공하면 **정확도**와 **일관성**이 크게 향상돼요.

### 1. MCP(Model Context Protocol) 서버 사용하기

Cursor는 **MCP(Model Context Protocol)** 를 지원해요.
MCP는 IDE와 AI 모델 사이에서 프로젝트 정보를 더 구조적으로 전달하는 표준 프로토콜로,
AI가 코드베이스의 맥락을 더 깊이 이해할 수 있도록 도와주는 역할을 해요.

앱인토스는 다양한 **SDK와 API(인앱 광고, 인앱 결제, 딥링크 등)** 를 제공하고 있는데,
MCP를 함께 사용하면 다음과 같은 장점이 있어요:

* AI가 앱인토스 SDK 문서, API 스펙, 설정 파일을 자동으로 참조
* 인앱 광고, 인앱 결제 등 앱인토스의 기능을 더 짧은 코드로 빠르게 구현
* 잘못된 API 사용이나 누락된 파라미터 등을 AI가 조기에 감지
* 프로젝트 전체 구조(폴더, 설정, 자원 파일 등)를 기반으로 정확한 자동 생성 코드 구현

즉, MCP를 사용하면

> **앱인토스가 제공하는 기능을 훨씬 쉽게, 더 정확하게 구현할 수 있는 개발 환경을 만들 수 있어요.**
> 기존 문서 기반 컨텍스트보다 더 깊은 통합을 제공한다는 점이 핵심입니다.

#### 설치하기

```[MacOS]
brew tap toss/tap && brew install ax
```

```[Windows]
scoop bucket add toss  https://github.com/toss/scoop-bucket.git
scoop install ax
```

#### Cursor에 MCP 서버 연결하기

버튼이 작동하지 않을 경우, `.cursor/mcp.json` 파일을 생성하거나 수정해 아래 내용을 추가하세요.

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

Cursor 외에도 Claude, Codex 같은 LLM 환경에서 앱인토스 공식 문서를 기반으로 답변을 받고 싶다면
**Apps In Toss Skills**를 사용할 수 있어요.

#### Apps In Toss Skills란?

Claude, Codex 등에서 사용 가능한 앱인토스 전용 에이전트 스킬 모음이에요.
현재 제공되는 스킬은 다음과 같아요.

* `docs-search`
  * 앱인토스 `llms-full.txt` 문서를 다운로드·캐시하여 키워드 + 의미 유사도 기반으로 관련 스니펫을 검색해요.

#### Codex (skill-installer UI)

1. `$skill-installer`를 실행하세요.
2. 다음 프롬프트를 입력해 스킬을 설치하세요.

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

앱인토스 문서를 AI에 연결하려면 Cursor의 **Docs 인덱싱** 기능을 사용하세요.
아래 단계에 따라 필요한 문서를 빠르게 등록할 수 있어요.

1. Cursor 화면 우측 상단의 **톱니바퀴(⚙️)** 아이콘을 클릭하세요.
2. 왼쪽 메뉴에서 **Indexing & Docs**를 선택하세요.
3. 화면 하단의 **Docs** 섹션으로 이동하세요.
4. `+Add Doc` 버튼을 클릭해 문서를 추가하세요.

#### 추가할 수 있는 문서 URL

| 유형                           | 설명                                                                                             | URL                                                             |
| ------------------------------ | ------------------------------------------------------------------------------------------------ | --------------------------------------------------------------- |
| **기본 문서 (권장)**           | 앱인토스 기능을 사용하는 데 필요한 핵심 정보들이 포함돼 있어요.                                  | `https://developers-apps-in-toss.toss.im/llms.txt`              |
| **모든 기능 포함 문서 (Full)** | 전체 문서를 포함한 확장 버전이에요. 컨텍스트는 풍부하지만 **토큰 소모량이 증가**할 수 있어요. | `https://developers-apps-in-toss.toss.im/llms-full.txt`         |
| **예제 전용 문서**             | 앱인토스 예제 코드만 빠르게 참고하고 싶을 때 사용해요.                                           | `https://developers-apps-in-toss.toss.im/tutorials/examples.md` |
| **TDS 문서 (WebView)**         | TDS WebView 관련 정보가 포함돼 있어요.                                                           | `https://tossmini-docs.toss.im/tds-mobile/llms-full.txt`        |
| **TDS 문서 (React Native)**    | TDS React Native 정보가 포함돼 있어요.                                                           | `https://tossmini-docs.toss.im/tds-react-native/llms-full.txt`  |

![llms-1](/assets/llms-1.Ddl9380t.png)

### 4. 문서를 기반으로 AI 활용하기

문서를 등록하면 AI가 해당 문서를 기반으로 더 정확한 답변을 생성할 수 있어요.
특히 Cursor에서는 `@docs` 명령을 사용하여 *지정된 문서를 우선적으로 참고*하도록 요청할 수 있어요.

```
@docs 앱인토스 인앱광고 샘플 코드 작성해줘
```

> **@docs는 언제 사용하나요?**
>
> * SDK처럼 **정확한 규칙 기반 코드**가 필요한 경우
> * 문서 기반 의존도가 높은 기능을 사용할 때
> * AI에게 "문서를 기반으로 답변해 달라"고 명확히 전달하고 싶을 때
>
> `@docs`를 사용하면 AI는 문서를 우선적으로 참고해 더 안정적인 답변을 제공합니다.

AI는 `@docs` 없이도 문서를 자동으로 참고하지만,
**정밀한 문맥 이해가 필요할 때는 `@docs`를 사용해 명시적으로 지시하는 것이 좋아요.**

---

## Unity WebGL 미니앱 가이드

> 출처: https://developers-apps-in-toss.toss.im/unity/intro/overview.md

Unity로 만든 게임을 앱인토스 미니앱 환경에 빠르게 전환할 수 있는 가이드예요.
기존 Unity 프로젝트를 그대로 유지하면서, WebGL을 통해 앱인토스 미니앱 플랫폼에 손쉽게 적용할 수 있어요.

### 소개

앱인토스 Unity WebGL 미니앱 가이드는 기존 Unity 게임을 미니앱으로 옮길 때,
엔진 교체나 핵심 코드 수정 없이도 앱인토스 플랫폼에서 그대로 실행할 수 있도록 돕습니다.

이 가이드의 목표는 개발 리소스를 최소화하고, Unity 프로젝트를 효율적으로 전환하는 거예요.
기존 빌드 환경과 코드베이스를 그대로 유지하면서 앱인토스 미니앱 런타임에 자연스럽게 통합되도록 설계됐어요.

### 문서 구조

#### 기본 문서

* [소개](/unity/intro/overview) - 프로젝트 개요 및 특징
* [입문 가이드](/unity/intro/migration-guide) - 단계별 개발 가이드

#### 호환성 및 평가

* [기술 원리](/unity/guide/runtime-structure) - 기술 아키텍처 개요
* [호환성 평가](/unity/guide/precheck) - 게임 적합성 검사
* [권장 Unity 버전](/unity/guide/recommend-engine) - 버전별 지원 현황

#### 성능 최적화

* [성능 최적화 개요](/unity/optimization/perf-optimization) - 최적화 전략
* [시작 속도 향상](/unity/optimization/start/startup-speed) - 로딩 최적화
* [메모리 최적화](/unity/optimization/runtime/memory) - 메모리 관리
* [렌더링 최적화](/unity/optimization/runtime/performance) - 그래픽 성능

#### 개발 도구

* [디버깅 가이드](/unity/debug/debug-exception) - 오류 해결
* [프로파일링](/unity/optimization/runtime/profile) - 성능 분석

### 지원 및 도움말

커뮤니티: [앱인토스 개발자 포럼](https://techchat-apps-in-toss.toss.im/)
API 문서: [앱인토스 개발자센터](https://developers-apps-in-toss.toss.im/)
