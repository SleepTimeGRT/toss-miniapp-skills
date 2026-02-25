---
description: "앱인토스(토스 미니앱) 서버 연동에 관한 질문에 사용하세요. 트리거 상황: API 연동, mTLS 인증서 발급/설정, 방화벽 IP 허용, 서버 간 통신(S2S), rate limit/QPM, Firebase 연동, Sentry 에러 모니터링/소스맵, 토스 인증/본인확인/원터치 인증 계약·개발·테스트, CI/DI, client_id/client_secret, Access Token 발급, 인증 요청/상태조회/결과조회 API"
---

# 앱인토스 서버 연동 가이드

## 1. API 개요

원문 URL: https://developers-apps-in-toss.toss.im/api/overview.md

앱인토스를 연동하기 위해 필요한 API를 소개드려요.

> **주의**: iframe은 사용할 수 없어요. iframe을 사용할 경우 앱인토스 기능이 정상 동작하지 않고, 내부 보안 심사에서도 반려돼요. 단, YouTube 영상 콘텐츠를 삽입하는 용도는 예외적으로 iframe 사용이 가능해요.

### 서버 mTLS 인증서 발급받기

앱인토스 API를 사용하려면 반드시 **mTLS(mutable Transport Layer Security, 양방향 전송 계층 보안)** 인증서를 설정해야 해요.

mTLS는 클라이언트와 서버가 서로의 신원을 확인하는 방식이에요. 일반 HTTPS는 서버만 인증하지만, mTLS는 **파트너사 서버와 앱인토스 서버가 서로를 인증**해요.

이 인증서를 설정해야 다음을 보장할 수 있어요.

* 통신 구간 암호화
* 허용된 서버만 API 호출 가능
* 위·변조 방지

### 통신 방화벽 확인하기

서버에서 Inbound, Outbound 방화벽을 관리하고 있다면 아래 IP와 포트를 반드시 허용해야 해요. 허용하지 않으면 API 호출이 실패하거나 콜백을 받지 못해요.

#### 가맹점이 허용해야 하는 Inbound IP

앱인토스 → 가맹점

| IP               | Port |
| ---------------- | ---- |
| 117.52.3.11      | 443  |
| 211.115.96.11    | 443  |
| 106.249.5.11     | 443  |
| 117.52.3.80~87   | 443  |
| 211.115.96.80~87 | 443  |
| 106.249.5.80~87  | 443  |

앱인토스가 가맹점 서버로 요청을 보낼 때 사용하는 IP예요. 예를 들어 결제 결과 콜백을 받을 때 필요해요.

#### 가맹점이 허용해야 하는 Outbound IP

가맹점 → 앱인토스

| 기능                                       | 도메인                       | IP                                          | Port |
| ------------------------------------------ | ---------------------------- | ------------------------------------------- | ---- |
| 간편 로그인, 메시지 발송, 토스 포인트 지급 | apps-in-toss-api.toss.im     | 117.52.3.192, 211.115.96.192, 106.249.5.192 | 443  |
| 간편 결제                                  | pay-apps-in-toss-api.toss.im | 117.52.3.195, 211.115.96.195, 106.249.5.195 | 443  |

가맹점 서버에서 앱인토스 API를 호출할 때 필요한 설정이에요. HTTPS 443 포트를 열어야 정상적으로 통신할 수 있어요.

### API 공통 규격

#### 도메인 정보

* https://apps-in-toss-api.toss.im
* https://pay-apps-in-toss-api.toss.im

#### API 공통 응답 형식

모든 API는 공통된 응답 구조를 사용해요. `resultType` 값으로 성공 여부를 먼저 확인하세요.

**성공 응답**

```json
{
  "resultType": "SUCCESS",
  "success": {
    "sample": "data"
  }
}
```

* `resultType`이 `"SUCCESS"`이면 요청이 정상 처리된 상태예요.
* 실제 응답 데이터는 `success` 객체 안에 들어 있어요.
* 각 API마다 `success` 내부 구조는 달라요.

**실패 응답**

```json
{
  "resultType": "FAIL",
  "error": {
    "errorCode": "INVALID_PARAMETER",
    "reason": "요청에 실패했습니다."
  }
}
```

* `resultType`이 `"FAIL"`이면 요청 처리에 실패한 상태예요.
* `errorCode`는 오류 유형을 나타내는 코드예요.
* `reason`에는 사람이 읽을 수 있는 오류 설명이 들어 있어요.
* 잘못된 파라미터를 보내면 `INVALID_PARAMETER`와 같은 코드로 에러를 발생시켜요.

응답을 처리할 때는 반드시 `resultType`을 먼저 검사한 뒤, 성공과 실패 로직을 나눠 구현하세요.

### 요청 제한 정책 (Rate Limit / QPM)

앱인토스 API는 안정적인 서비스 운영을 위해 요청 수를 제한해요.

#### 기본 제한

* 분당 3,000 QPM
* QPM은 Queries Per Minute의 약자로, 1분 동안 호출할 수 있는 API 요청 수를 의미해요.
* 미니앱 기준으로 분당 최대 3,000건까지 요청할 수 있어요.

이 한도를 초과하면 일정 시간 동안 추가 요청이 차단될 수 있어요.

#### QPM 상향이 필요한 경우

기본 3,000 QPM보다 많은 요청이 필요한 경우 채널톡으로 상향을 요청할 수 있어요.

요청할 때는 다음 정보를 함께 전달하세요.

* 사용 목적
* 예상 트래픽 규모
* 피크 시간대 요청량

비즈니스 목적과 트래픽 규모를 검토한 뒤 한도를 조정해요. 대량 트래픽이 예상된다면 서비스 오픈 전에 미리 협의하는 것이 좋아요.

---

## 2. mTLS 기반 API 사용하기

원문 URL: https://developers-apps-in-toss.toss.im/development/integration-process.md

앱인토스 API를 사용하려면 **mTLS 기반의 서버 간(Server-to-Server) 통신 설정이 반드시 필요해요.** mTLS 인증서는 파트너사 서버와 앱인토스 서버 간 통신을 **암호화**하고 **쌍방 신원을 상호 검증**하는 데 사용됩니다.

> **아래 기능은 반드시 mTLS 인증서를 통한 통신이 필요해요**
>
> * 토스 로그인
> * 토스 페이
> * 인앱 결제
> * 기능성 푸시, 알림
> * 프로모션(토스 포인트)

### 통신 구조

앱인토스 API는 파트너사 서버에서 앱인토스 서버로 요청을 전송하고, 앱인토스 서버가 토스 서버에 연동 요청을 전달하는 구조로 동작해요.

### mTLS 인증서 발급 방법

서버용 mTLS 인증서는 **콘솔에서 직접 발급**할 수 있어요.

#### 1. 앱 선택하기

앱인토스 콘솔에 접속해 인증서를 발급받을 앱을 선택하세요. 왼쪽 메뉴에서 **mTLS 인증서** 탭을 클릭한 뒤, **+ 발급받기** 버튼을 눌러 발급을 진행해요.

#### 2. 인증서 다운로드 및 보관

mTLS 인증서가 발급되면 **인증서 파일과 키 파일**을 다운로드할 수 있어요.

> **보관 시 주의하세요**
>
> * 인증서와 키 파일은 유출되지 않도록 **안전한 위치에 보관**하세요.
> * 인증서가 **만료되기 전에 반드시 재발급**해 주세요.

인증서는 일반적으로 하나만 사용하지만, **무중단 교체**를 위해 **두 개 이상 등록해 둘 수도 있어요.** 콘솔에서는 이를 위해 **다중 인증서 관리 기능을** 제공해요.

### API 요청 시 인증서 설정

앱인토스 서버에 요청하려면, 발급받은 **인증서/키 파일**을 서버 애플리케이션에 등록해야 해요.

아래는 주요 언어별 mTLS 요청 예제예요. 환경에 맞게 경로, 알고리즘, TLS 버전 등을 조정하세요.

#### Kotlin 예제

```kotlin
import java.security.KeyStore
import java.security.cert.X509Certificate
import java.security.KeyFactory
import java.security.spec.PKCS8EncodedKeySpec
import java.io.FileReader
import java.io.ByteArrayInputStream
import java.util.Base64
import javax.net.ssl.*

class TLSClient {
    fun createSSLContext(certPath: String, keyPath: String): SSLContext {
        val cert = loadCertificate(certPath)
        val key = loadPrivateKey(keyPath)

        val keyStore = KeyStore.getInstance(KeyStore.getDefaultType())
        keyStore.load(null, null)
        keyStore.setCertificateEntry("client-cert", cert)
        keyStore.setKeyEntry("client-key", key, "".toCharArray(), arrayOf(cert))

        val kmf = KeyManagerFactory.getInstance(KeyManagerFactory.getDefaultAlgorithm())
        kmf.init(keyStore, "".toCharArray())

        return SSLContext.getInstance("TLS").apply {
            init(kmf.keyManagers, null, null)
        }
    }

    private fun loadCertificate(path: String): X509Certificate {
        val content = FileReader(path).readText()
            .replace("-----BEGIN CERTIFICATE-----", "")
            .replace("-----END CERTIFICATE-----", "")
            .replace("\\s".toRegex(), "")
        val bytes = Base64.getDecoder().decode(content)
        return CertificateFactory.getInstance("X.509")
            .generateCertificate(ByteArrayInputStream(bytes)) as X509Certificate
    }

    private fun loadPrivateKey(path: String): java.security.PrivateKey {
        val content = FileReader(path).readText()
            .replace("-----BEGIN PRIVATE KEY-----", "")
            .replace("-----END PRIVATE KEY-----", "")
            .replace("\\s".toRegex(), "")
        val bytes = Base64.getDecoder().decode(content)
        val spec = PKCS8EncodedKeySpec(bytes)
        return KeyFactory.getInstance("RSA").generatePrivate(spec)
    }

    fun makeRequest(url: String, context: SSLContext): String {
        val connection = (URL(url).openConnection() as HttpsURLConnection).apply {
            sslSocketFactory = context.socketFactory
            requestMethod = "GET"
            connectTimeout = 5000
            readTimeout = 5000
        }

        return connection.inputStream.bufferedReader().use { it.readText() }.also {
            connection.disconnect()
        }
    }
}

fun main() {
    val client = TLSClient()
    val context = client.createSSLContext("/path/to/client-cert.pem", "/path/to/client-key.pem")
    val response = client.makeRequest("https://apps-in-toss-api.toss.im/endpoint", context)
    println(response)
}
```

#### Python 예제

```python
import requests

class TLSClient:
    def __init__(self, cert_path, key_path):
        self.cert_path = cert_path
        self.key_path = key_path

    def make_request(self, url):
        response = requests.get(
            url,
            cert=(self.cert_path, self.key_path),
            headers={'Content-Type': 'application/json'}
        )
        return response.text

if __name__ == '__main__':
    client = TLSClient(
        cert_path='/path/to/client-cert.pem',
        key_path='/path/to/client-key.pem'
    )
    result = client.make_request('https://apps-in-toss-api.toss.im/endpoint')
    print(result)
```

#### JavaScript (Node.js) 예제

```js
const https = require('https');
const fs = require('fs');

const options = {
  cert: fs.readFileSync('/path/to/client-cert.pem'),
  key: fs.readFileSync('/path/to/client-key.pem'),
  rejectUnauthorized: true,
};

const req = https.request(
  'https://apps-in-toss-api.toss.im/endpoint',
  { method: 'GET', ...options },
  (res) => {
    let data = '';
    res.on('data', (chunk) => (data += chunk));
    res.on('end', () => {
      console.log('Response:', data);
    });
  }
);

req.on('error', (e) => console.error(e));
req.end();
```

#### C# 예제

```csharp
using System;
using System.Net.Http;
using System.Security.Cryptography.X509Certificates;
using System.Threading.Tasks;

class Program {
    static async Task Main(string[] args) {
        var handler = new HttpClientHandler();
        handler.ClientCertificates.Add(
            new X509Certificate2("/path/to/client-cert.pem")
        );

        using var client = new HttpClient(handler);
        var response = await client.GetAsync("https://apps-in-toss-api.toss.im/endpoint");
        string body = await response.Content.ReadAsStringAsync();
        Console.WriteLine(body);
    }
}
```

#### C++ 예제 (libcurl 사용)

```cpp
#include <curl/curl.h>
#include <iostream>
#include <string>

size_t WriteCallback(void* contents, size_t size, size_t nmemb, std::string* userp) {
    userp->append((char*)contents, size * nmemb);
    return size * nmemb;
}

int main() {
    CURL* curl = curl_easy_init();
    if (curl) {
        std::string response;
        curl_easy_setopt(curl, CURLOPT_URL, "https://apps-in-toss-api.toss.im/endpoint");
        curl_easy_setopt(curl, CURLOPT_SSLCERT, "/path/to/client-cert.pem");
        curl_easy_setopt(curl, CURLOPT_SSLKEY, "/path/to/client-key.pem");
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &response);

        CURLcode res = curl_easy_perform(curl);
        if (res == CURLE_OK) {
            std::cout << "Response: " << response << std::endl;
        } else {
            std::cerr << "Error: " << curl_easy_strerror(res) << std::endl;
        }

        curl_easy_cleanup(curl);
    }

    return 0;
}
```

#### PHP 예제

```
// PHP - curl을 사용한 mTLS 요청 예시
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, 'https://apps-in-toss-api.toss.im/endpoint');
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_SSLCERT, '/path/to/client-cert.pem');
curl_setopt($ch, CURLOPT_SSLKEY, '/path/to/client-key.pem');

$response = curl_exec($ch);
curl_close($ch);
```

### 자주 묻는 질문

**`ERR_NETWORK` 에러가 발생해요.**

mTLS 미적용 상태에서 API를 호출하면 발생해요.

---

## 3. Firebase 연동하기

원문 URL: https://developers-apps-in-toss.toss.im/firebase/intro.md

앱인토스(미니앱) Webview 환경에서 Firebase를 연동하는 방법을 안내해요. 이 문서는 **Vite(React + TypeScript)** 기반 프로젝트를 기준으로 작성되었어요.

### 개요

Firebase는 인증, 데이터베이스, 파일 저장 등 다양한 기능을 제공하는 서비스예요. 앱인토스 WebView 환경에서도 동일하게 사용할 수 있지만, **보안 설정과 환경 변수 관리**가 중요해요.

### 1. 준비하기

* Firebase 콘솔 계정 (https://console.firebase.google.com)
* Vite(React + TypeScript)로 만든 프로젝트
* Node.js, npm (또는 yarn, pnpm)

### 2. Firebase 프로젝트 만들기

1. Firebase 콘솔에서 **프로젝트 생성**을 눌러 새 프로젝트를 만들어요.
2. 프로젝트 설정 → **앱 추가** → **웹(</>)** 을 선택해요.
3. 앱 닉네임을 입력하고 등록하면, 아래처럼 구성 정보(firebaseConfig)가 표시돼요.

```js
const firebaseConfig = {
  apiKey: '...',
  authDomain: '...',
  databaseURL: '...',
  projectId: '...',
  storageBucket: '...',
  messagingSenderId: '...',
  appId: '...',
  measurementId: '...'
}
```

### 3. 환경 변수 설정하기

Firebase 구성 정보는 보안을 위해 Vite 환경 변수로 관리하는 걸 권장해요.

프로젝트 루트에 `.env` 파일을 만들고 아래처럼 작성하세요.

```bash
VITE_FIREBASE_API_KEY=your_api_key
VITE_FIREBASE_AUTH_DOMAIN=your-project.firebaseapp.com
VITE_FIREBASE_PROJECT_ID=your-project-id
VITE_FIREBASE_STORAGE_BUCKET=your-project.appspot.com
VITE_FIREBASE_MESSAGING_SENDER_ID=your_sender_id
VITE_FIREBASE_APP_ID=your_app_id
```

코드에서는 `import.meta.env.VITE_FIREBASE_API_KEY`처럼 불러와요.

### 4. Firebase 설치 및 초기화

최신 Firebase 모듈식 SDK(v12+) 기준으로 작성했어요.

```bash
npm install firebase
# 또는
yarn add firebase
```

`src/firebase/init.ts`

```ts
import { initializeApp, getApps } from 'firebase/app'
import { getAuth } from 'firebase/auth'
import { getFirestore } from 'firebase/firestore'
import { getStorage } from 'firebase/storage'

const firebaseConfig = {
  apiKey: import.meta.env.VITE_FIREBASE_API_KEY,
  authDomain: import.meta.env.VITE_FIREBASE_AUTH_DOMAIN,
  projectId: import.meta.env.VITE_FIREBASE_PROJECT_ID,
  storageBucket: import.meta.env.VITE_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: import.meta.env.VITE_FIREBASE_MESSAGING_SENDER_ID,
  appId: import.meta.env.VITE_FIREBASE_APP_ID,
}

const app = getApps().length ? getApps()[0] : initializeApp(firebaseConfig)

export const auth = getAuth(app)
export const db = getFirestore(app)
export const storage = getStorage(app)
```

> **참고:**
>
> * `databaseURL`은 **Realtime Database**를 사용할 때만 필요해요. Firestore를 사용한다면 생략해도 괜찮아요.
> * `measurementId`는 **Firebase Analytics**(Google Analytics)를 쓸 때 필요해요.

### 5. Firestore 사용 예제

Firestore를 초기화했다면, React 컴포넌트 안에서 데이터를 읽거나 쓸 수 있어요. 아래는 `App.tsx`에서 단일 문서를 읽고 저장하는 가장 간단한 예시예요.

```tsx
import { useState, useEffect } from 'react'
import { db } from './firebase/init'
import { doc, getDoc, setDoc } from 'firebase/firestore'

function App() {
  const [name, setName] = useState('')
  const [savedName, setSavedName] = useState('')

  // Firestore에서 데이터 읽기
  useEffect(() => {
    const fetchData = async () => {
      const ref = doc(db, 'users', 'exampleUser')
      const snap = await getDoc(ref)
      if (snap.exists()) {
        setSavedName(snap.data().name)
      }
    }
    fetchData()
  }, [])

  // Firestore에 데이터 쓰기
  const handleSave = async () => {
    const ref = doc(db, 'users', 'exampleUser')
    await setDoc(ref, { name })
    setSavedName(name)
    setName('')
  }

  return (
    <div style={{ padding: 24 }}>
      <h1>Firestore 간단 예제</h1>
      <input
        value={name}
        onChange={(e) => setName(e.target.value)}
        placeholder="이름 입력"
      />
      <button onClick={handleSave}>저장</button>
      <p>저장된 이름: {savedName || '(없음)'}</p>
    </div>
  )
}

export default App
```

#### 동작 방식

* 데이터 읽기 (`getDoc`): Firestore의 users/exampleUser 문서를 한 번만 불러와요. 문서가 존재하면 snap.data()의 값을 화면에 표시해요.
* 데이터 쓰기 (`setDoc`): 입력한 이름을 Firestore에 덮어써 저장해요. 문서가 없으면 자동으로 새로 생성돼요.

> Firestore는 단일 문서 외에도 여러 기능을 지원해요.
>
> * 실시간 구독: `onSnapshot(doc(...))`을 사용하면 문서가 변경될 때마다 UI가 자동으로 갱신돼요.
> * 컬렉션 다루기: `collection()`, `addDoc()`을 사용하면 여러 문서를 추가하고 불러올 수 있어요.
> * 파일 저장: `getStorage()`로 `Storage`를 연결해 이미지나 파일을 업로드할 수 있어요.
> * 인증 연동: `getAuth()`와 함께 사용하면 사용자별 데이터 저장이 가능해요.

### 6. 보안 체크리스트

* **민감한 정보 환경 변수로 관리하기**: Firebase API Key, 서비스 계정 키 등은 코드에 직접 작성하지 않고 `.env`로 관리하세요.
* **환경 파일을 Git 등에 업로드하지 않기**: `.env` 파일은 `.gitignore`에 반드시 추가하세요. 키가 노출되면 Firebase 콘솔에서 즉시 재발급하고, 관련 프로젝트 권한을 점검하세요.
* **Firebase 보안 규칙 설정하기**: Firestore / Storage는 기본적으로 모든 사용자에게 공개되어 있어요. 배포 전에 반드시 인증된 사용자만 접근하도록 규칙을 수정하세요.
* **출처(Origin) 제한 확인하기**: Firebase 콘솔의 Authentication / Hosting / API Key 설정에서 허용 도메인을 제한해두세요. 미니앱(WebView) 도메인만 허용하면 무단 접근을 예방할 수 있어요.

> **허용 대상 도메인**
>
> * `https://*.apps.tossmini.com` : 실제 서비스 환경
> * `https://*.private-apps.tossmini.com` : 콘솔 QR 테스트 환경

---

## 4. Sentry 에러 모니터링 설정하기

원문 URL: https://developers-apps-in-toss.toss.im/learn-more/sentry-monitoring.md

앱에 **Sentry**를 연동하면 JavaScript에서 발생한 오류를 자동으로 감지하고 모니터링할 수 있어요. 이를 통해 앱의 안정성을 높이고, 사용자에게 더 나은 경험을 제공할 수 있어요.

> **WebView에서 Sentry 연동**: https://docs.sentry.io/platforms/javascript/ 를 참고하여 연동해주세요.

### 1. Sentry 초기 설정

https://docs.sentry.io/platforms/react-native 를 참고하여 앱에서 Sentry를 초기화해주세요.

앱인토스 환경에서는 네이티브 오류 추적 기능을 사용할 수 없으므로 `enableNative` 옵션을 `false`로 설정해야 해요.

> **네이티브 오류 추적은 지원되지 않아요**: 앱인토스 환경에서는 JavaScript 오류만 추적할 수 있어요.

```ts
import * as Sentry from '@sentry/react-native';

Sentry.init({
  // ...
  enableNative: false,
});
```

### 2. Sentry 플러그인 설치

프로젝트 루트 디렉터리에서 사용 중인 패키지 관리자에 맞는 명령어를 실행해 Sentry 플러그인을 설치하세요.

```sh
# npm
npm install @granite-js/plugin-sentry

# pnpm
pnpm install @granite-js/plugin-sentry

# yarn
yarn add @granite-js/plugin-sentry
```

### 3. 플러그인 구성

설치한 `@granite-js/plugin-sentry`를 `granite.config.ts` 파일의 `plugins` 항목에 추가하세요. 앱인토스 환경에서는 **`useClient` 옵션을 반드시 `false`로 설정**해야 해요.

> **왜 `useClient` 옵션을 꺼야 하나요?**
>
> `useClient`를 `false`로 설정하면 앱 빌드 시 Sentry에 소스맵이 자동으로 업로드되지 않아요. 앱인토스 환경에서는 빌드 후 **수동으로 소스맵을 업로드**해야 하므로, 이 옵션을 꺼야 해요.

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

### 4. 앱 출시하기

앱을 출시하는 방법은 미니앱 출시 문서를 참고하세요.

### 5. Sentry에 소스맵 업로드

출시된 미니앱의 오류를 정확히 추적하려면 빌드 후 생성된 **소스맵을 Sentry에 업로드**해야 해요.

아래 명령어를 실행하면 소스맵이 업로드돼요.

> **입력값 안내**
>
> * `<API_KEY>`: 앱인토스 콘솔에서 발급받은 API 키예요.
> * `<APP_NAME>`: Sentry에 등록된 서비스 이름이에요.
> * `<DEPLOYMENT_ID>`: 앱을 배포할 때 사용한 배포 ID예요.

```sh
# npm
npx ait sentry upload-sourcemap \
  --api-key <API_KEY> \
  --app-name <APP_NAME> \
  --deployment-id <DEPLOYMENT_ID>

# pnpm
pnpm ait sentry upload-sourcemap \
  --api-key <API_KEY> \
  --app-name <APP_NAME> \
  --deployment-id <DEPLOYMENT_ID>

# yarn
yarn ait sentry upload-sourcemap \
  --api-key <API_KEY> \
  --app-name <APP_NAME> \
  --deployment-id <DEPLOYMENT_ID>
```

명령어 실행 후 Sentry의 조직(Org), 프로젝트(Project), 인증 토큰 입력이 요청됩니다. 모든 정보를 입력하면 해당 서비스의 소스맵이 Sentry에 업로드돼요.

---

## 5. 토스 인증 (본인확인)

### 5-1. 토스 인증 개요 및 계약

원문 URL: https://developers-apps-in-toss.toss.im/tossauth/contract.md

토스 인증은 사용자가 입력한 정보(또는 토스 앱 내 저장된 정보)를 기반으로 **실명·생년월일·휴대전화번호 등**을 안전하게 확인하고, 토스 앱 인증을 통해 **신원을 검증하는 서비스**예요.

로그인, 가입, 조회 등 사용자 식별이 필요한 서비스에서 **CI(연계정보)** 를 포함한 식별자를 안정적으로 확보할 수 있어요.

> **웹보드 게임은 본인 확인이 필수예요**: 관련 법령에 따라 **웹보드 게임은 본인 확인 절차가 반드시 필요**해요. 토스 인증을 연동하면 간편하게 본인 확인(필요 시 성인 인증까지)을 진행할 수 있어요.

#### 토스 인증 유형

토스 인증은 두 가지 방식을 제공해요. 두 방식 모두 최종적으로 **토스 앱 인증**을 통해 사용자를 확인한다는 점은 같으며, **클라이언트에서 개인정보를 입력받는지 여부**가 가장 큰 차이예요.

##### ① 개인정보 기반 인증

클라이언트에서 **이름·생년월일·휴대전화번호** 를 입력받아 암호화 후 전송하는 방식이에요.

* **권장 상황**
  * 가입 또는 전환 화면에서 이미 개인정보를 수집하고 있는 경우
  * 입력 값과 **실제 가입 정보의 일치 여부**를 즉시 검증해야 하는 경우

* **흐름**
  1. 사용자가 화면에서 개인정보 입력
  2. 입력값을 암호화하여 토스 인증으로 전송
  3. 토스 앱 인증(푸시 또는 생체인증 등)
  4. 결과 수신(CI, 이름, 휴대전화번호, 인증 시각 등)

* **특징**
  * 입력값 검증(형식, 오타 등)에 유리
  * 입력 과정이 있어 사용자의 이탈률이 다소 높을 수 있음

##### ② 원터치 인증

클라이언트에서 **개인정보를 입력받지 않고**, 토스 앱을 바로 호출해 한 번의 인증으로 절차를 완료하는 간소화된 방식이에요.

> **원터치 인증 동작 방식**
>
> * 기기에 토스인증서가 있다면, PIN 인증 또는 단말 생체 인증 (Face ID, 지문인증 등)
> * 기기에 토스인증서가 없다면, 토스인증서 발급 후 PIN 인증 또는 단말 생체 인증

* **권장 상황**
  * **이탈 최소화 / 전환율 최적화**가 중요한 경우
  * 앱 내 간결한 로그인·재인증 UX가 필요한 경우

* **흐름**
  1. "본인 인증" 버튼 클릭
  2. 토스 앱 호출 → 사용자 인증
  3. 결과 수신(CI, 인증 시각 등)

* **특징**
  * 입력 단계가 없어 **UX가 매우 간결**
  * 기존 계정과의 매칭 로직(CI 등) 설계가 중요

#### 운영 팁

* **웹보드·성인물 서비스**: 본인 확인 후 서비스 정책에 따라 **성인 여부(ageGroup 기반 정책)** 를 적용하세요.
* **재인증 정책**: 장기간 미사용 또는 주요 정보 변경(이름·번호 변경 등) 시 **재인증 주기**를 정의하면 안전해요.
* **개인정보 최소화**: 원터치 인증을 기본으로 검토하고, 필요한 경우에만 입력 기반 인증을 조합해 **개인정보 수집을 최소화**하세요.

#### 계약하기

토스 인증을 사용하려면 **사전 계약**이 필요해요. 계약 진행에는 **영업일 기준 7~14일**이 소요될 수 있어요.

> **'본인 확인' vs '토스 로그인'**
>
> 앱인토스는 제휴사에 **토스 인증의 '본인 확인' 기능**을 제공해요. '본인 확인'은 사용자의 **이름·생년월일·휴대전화번호를 검증해 신원을 확인하는 서비스**예요. 이 서비스는 **연령 확인, 실명 인증, 웹보드 게임 등 법적 신원 확인이 필요한 경우**에 사용됩니다.
>
> 반면, **'토스 로그인'은 간편 인증 방식으로,** 사용자가 별도의 정보 입력 없이 **토스앱을 통해 간편하게 로그인할 수 있는 기능**이에요. '본인 확인'과는 **목적과 계약 구조가 다르며,** 토스 로그인 연동을 원하신다면 토스 로그인 가이드 문서를 참고해 주세요.
>
> 일부 파트너사에서 두 서비스를 혼동해 잘못 계약한 사례가 있었어요. **계약 전 반드시 요청하시는 서비스가 '본인 확인'인지 '토스 로그인'인지 확인해 주세요.**

> **콘솔에서 계약이 진행되지 않아요**: 토스 인증 계약은 인증팀에서 **직접** 진행하고 있어요. 콘솔을 통해 계약할 수 없으니, 아래 절차를 참고해 주세요.

**계약 절차**

1. **서류 다운로드 및 작성**: 아래 서류를 다운로드해 작성해 주세요.
   * 토스 전자 인증 서비스 이용 신청서, 개인(신용)정보 보안관리 약정서

2. **어드민 권한 정보 준비**: 토스 전자 인증 서비스 제휴사 어드민을 통해 **정산 금액**을 확인할 수 있어요. 어드민 접속 권한이 필요한 담당자의 **이메일 주소**와 **전화번호**를 준비해 주세요.

3. **서류 제출**: 아래 항목을 모두 포함해 `cert.support@toss.im` 이메일로 제출해주세요.
   * 작성 완료된 **신청서 및 약정서**
   * 어드민 접속 권한이 필요한 담당자 **이메일 주소와 전화번호**

4. **검토 및 안내**
   * 담당 부서에서 서류를 검토한 후 진행 절차를 안내드려요.
   * 토스 전자 인증 서비스 계약은 내부 규정에 따라 **인감 날인된 하드카피 서류**로 진행돼요.
   * 서류 검토 및 우편 송부 과정을 포함하여, **영업일 기준 7~14일** 정도 소요돼요.
   * 계약서 내용 수정 요청이 있는 경우, 추가 검토로 인해 기간이 더 길어질 수 있어요.

5. **계약 완료 및 키 발급**
   * 계약이 완료되면 인증팀에서 `client_id`와 `client_secret` 키를 이메일로 발급해 드려요.
   * 메일 수신 후, 발급받은 키를 확인하여 개발 환경에 적용해 주세요.

---

### 5-2. 토스 인증 개발하기

원문 URL: https://developers-apps-in-toss.toss.im/tossauth/develop.md

> **최소 버전을 확인하세요**
>
> * **SDK**: 1.2.1 이상
> * **토스앱 (본인확인)**: 5.233.0 이상
> * **토스앱 (원터치 인증)**: 5.236.0 이상
>
> `getTossAppVersion` 함수를 사용하여 토스앱 버전을 체크해보세요.

#### 1단계. AccessToken 받기

토스 본인확인을 위한 **Access Token**을 발급받아요. 발급된 토큰은 이후 모든 API 호출의 **Authorization** 헤더에 사용돼요.

토큰에는 **만료 시간(`expires_in`)** 이 있어요. 만료 시 새 토큰을 발급해야 하고, **유효한 토큰이 있으면 재발급을 피해서** 불필요한 호출을 줄여 주세요.

* Base URL: `https://oauth2.cert.toss.im`
* Endpoint: `/token`
* Method: `POST`
* Content-Type: `application/x-www-form-urlencoded`

**요청 헤더**

| 이름 | 타입 | 필수값 여부 | 설명 |
|---|---|---|---|
| Content-Type | string | Y | `application/x-www-form-urlencoded` |

**요청 파라미터**

| 이름 | 타입 | 필수값 여부 | 설명 |
| --- | --- | --- | --- |
| grant\_type | string | Y | 고정 값: `client_credentials` |
| scope | string | Y | 인증 요청 범위 (예: `ca`) |
| client\_id | string | Y | 고객사에 발급된 클라이언트 아이디 |
| client\_secret | string | Y | 고객사에 발급된 클라이언트 시크릿 |

**요청 예시 (Shell curl)**

```bash
curl --request POST 'https://oauth2.cert.toss.im/token' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'grant_type=client_credentials' \
--data-urlencode 'client_id=test_a8e23336d673ca70922b485fe806eb2d' \
--data-urlencode 'client_secret=test_418087247d66da09fda1964dc4734e453c7cf66a7a9e3' \
--data-urlencode 'scope=ca'
```

**요청 예시 (Java)**

```java
URL url = new URL("https://oauth2.cert.toss.im/token");
HttpURLConnection httpConn = (HttpURLConnection) url.openConnection();
httpConn.setRequestMethod("POST");

httpConn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
httpConn.setDoOutput(true);
OutputStreamWriter writer = new OutputStreamWriter(httpConn.getOutputStream());
writer.write("grant_type=client_credentials&" +
        "client_id=test_a8e23336d673ca70922b485fe806eb2d&" +
        "client_secret=test_418087247d66da09fda1964dc4734e453c7cf66a7a9e3&" +
        "scope=ca");
writer.flush();
writer.close();

httpConn.getOutputStream().close();
InputStream responseStream = httpConn.getResponseCode() == 200
        ? httpConn.getInputStream()
        : httpConn.getErrorStream();
Scanner s = new Scanner(responseStream).useDelimiter("\\A");
String response = s.hasNext() ? s.next() : "";
System.out.println(response);
```

**응답**

| 이름 | 타입 | 설명 |
| --- | --- | --- |
| access\_token | string | Access Token 값 |
| scope | string | 발급된 인증 범위 |
| token\_type | string | 토큰 타입 (항상 `Bearer`) |
| expires\_in | number | 토큰 만료 시간(초 단위) |

```json
{
  "access_token": "eyJraWQiOiJjZXJ0IiwiYWxnIjoiUlMyNTYifQ.eyJzdWIiOiJ0ZXN0X2E4ZTIzMzM2ZDY3M2NhNzA5MjJiNDg1ZmU4MDZlYjJkIiwiYXVkIjoidGVzdF9hOGUyMzMzNmQ2NzNjYTcwOTIyYjQ4NWZlODA2ZWIyZCIsIm5iZiI6MTY0OTIyMjk3OCwic2NvcGUiOlsiY2EiXSwiaXNzIjoiaHR0cHM6XC9cL2NlcnQudG9zcy5pbSIsImV4cCI6MTY4MDc1ODk3OCwiaWF0IjoxNjQ5MjIyOTc4LCJqdGkiOiI4MDNjNDBjOC1iMzUxLTRmOGItYTIxNC1iNjc5MmNjMzBhYTcifQ.cjDZ0lAXbuf-KAgi3FlG1YGxvgvT3xrOYKDTstfbUz6CoNQgvd9TqI6RmsGZuona9jIP6H12Z1Xb07RIfAVoTK-J9iC5_Yp8ZDdcalsMNj51pPP8wso86rn-mKsrx1J5Rdi3GU58iKt0zGr4KzqSxUJkul9G4rY03KInwvl692HU19kYA9y8uTI4bBX--UPfQ02G0QH9HGTPHs7lZsISDtyD8sB2ikz5p7roua7U467xWy4BnRleCEWO2uUaNNGnwd7SvbjhmsRZqohs9KzDUsFjVhSiRNdHL53XJQ5zFHwDF92inRZFLu6Dw8xttPtNHwAD1kT84uXJcVMfEHtwkQ",
  "scope": "ca",
  "token_type": "Bearer",
  "expires_in": 31536000
}
```

#### 2단계. 인증 요청하기

토스 인증 서버에서 `txId`를 발급받아 본인확인 절차를 시작해요.

* BaseURL: `https://cert.toss.im`
* Endpoint: `/api/v2/sign/user/auth/id/request`
* Method: `POST`
* Content-type: `application/json`

##### 2-1. 개인정보 기반 인증 (requestType: USER_PERSONAL)

고객의 **이름·생년월일·전화번호** 를 **암호화 후 전송**하는 방식이에요. 보안을 위해 세션키(sessionKey)는 매 요청마다 새로 생성하세요.

**요청 헤더**

| 이름 | 타입 | 필수값 여부 | 설명 |
|---|---|---|---|
| Authorization | string | Y | `Bearer {Access Token}` |
| Content-Type | string | Y | `application/json` |

**요청 파라미터**

| 이름 | 타입 | 필수값 여부 | 설명 |
| --- | --- | --- | --- |
| requestUrl | string | Y | 토스 본인확인 사용 시 돌아갈 고객사 앱스킴 |
| requestType | string | Y | `USER_PERSONAL` |
| triggerType | string | Y | `APP_SCHEME` |
| userName | string | Y | 암호화 필수 |
| userPhone | string | Y | 숫자만, 암호화 필수 |
| userBirthday | string | Y | `YYYYMMDD`, 암호화 필수 |
| sessionKey | string | Y | AES 암복호화용, 매 요청마다 신규 생성 필요 |

**요청 예시 (Shell curl)**

```bash
curl --location --request POST 'https://cert.toss.im/api/v2/sign/user/auth/id/request' \
--header 'Authorization: Bearer {ACCESS_TOKEN}' \
--header 'Content-Type: application/json' \
--data-raw '{
       "requestType" : "USER_PERSONAL",
       "requestUrl" : "intoss://my-granite-app",
       "triggerType" : "APP_SCHEME",
       "userName" : "v1$cc575847-f549-4c1e-89c7-eff11743e05e$5AfwdVLSmDoxBERDIV8gDny2QLcOzYOqvgt1l4gqEA==",
       "userPhone" : "v1$cc575847-f549-4c1e-89c7-eff11743e05e$OKtwqMR/RI+N3vx0FNtcx8GAoejDq5lb3wIr",
       "userBirthday" : "v1$cc575847-f549-4c1e-89c7-eff11743e05e$OaNxoMR2RYaPiH7km5yJyZQ472+uWNEy",
       "sessionKey" : "v1$cc575847-f549-4c1e-89c7-eff11743e05e$XTTyBJntTja9NfUaTaO09bQCtEApnn3dd7lN8s+jPA6qn5q5kBbSJEptazpSMqGFyB7P0XhnJSkRwukAuunesbm+e0p5tdQ7wiOkauM44FvZj/IwETTA74iLZTNrwmE3aYXv8b1wbIfQx/oT8k9+XNEPkHA0foCFtjF8MRnyjwpzR4hoi2sFk33xhoJa46kLGxz7d3z6r/KYKMFbwkQFOm81Nk8W+oJkT0AjdlOD075QrJ4zm9VReVvE4fT4Q1jY/5VzROt4GkqVvrziYbWRp9/v1/ETVyi5Lf+MceWHLS1MGicqUXfrfnFdqvOcZZytUkvb0AAyg75Sr5tgja55ma3t5AEu65IrO1Cop4wS/XhIwKpWUrMav5JI5X1iZ1tRznE7VRT/dsRLjgIX/wtZajY2ATG+feld2mmxD/mP/ET3JXsYKfmN3DkO10fQZY9915eUyDYm7NMS/U3l+VP8wMzd5WpWVjfxUvYP5eRwPM83hG9wFhHXV4ykodiX0BLRoERXou416uKDJR61b8xFFX+iDPnOfaeROlFFWj6zbK4tPfjRzyaWVQMmSM8igq7iBglehFo+EyyQnAAcUeda+P/7fQmwFDE1a8bQuXFBCwxNOOyPiJLV2+29pzKELcHa+WCrvcbHkOgG4EwjHHWmd17vUVXZGXOERsRuLQMM3mM="
    }'
```

**성공 응답**

| 이름 | 타입 | 설명 |
| --- | --- | --- |
| resultType | string | 요청 결과 (성공: `SUCCESS`, 실패: `FAIL`) |
| success.txId | string | 인증 요청 트랜잭션 아이디. 특정 거래를 고유할 수 있는 값이므로 반드시 저장 관리해야 합니다. |
| success.requestedDt | string | 최초 요청 시각 (`YYYY-MM-DDThh:mm:ss±hh:mm`) |
| success.appScheme | string | 토스 인증 화면을 띄울 수 있는 앱 스킴 정보 |
| success.androidAppUri | string | 안드로이드 인증 앱 스킴 값 (Chrome Intent 사용, 토스 앱 설치 유무 판별 가능) |
| success.iosAppUri | string | iOS 인증 앱 스킴 값 (Universal Link 사용, 토스 앱 설치 유무 판별 가능) |

```json
{
    "resultType": "SUCCESS",
    "success": {
        "txId": "d7b7273b-407b-46be-a9d8-97d2e895b009",
        "appScheme": "null",
        "androidAppUri": "null",
        "iosAppUri": "null",
        "requestedDt": "2022-02-13T17:52:22+09:00"
    }
}
```

**실패 응답**

| 이름 | 타입 | 설명 |
| --- | --- | --- |
| resultType | string | 실패 시 `FAIL` |
| error.errorType | number | 에러 유형 |
| error.errorCode | string | 에러 코드 (예: `CE1000`) |
| error.reason | string | 에러 메시지 |
| error.data | object | 부가 데이터(있을 경우) |
| error.title | string/null | 에러 제목(있을 경우) |

```json
{
  "resultType": "FAIL",
  "error": {
    "errorType": 0,
    "errorCode": "CE1000",
    "reason": "토큰이 유효하지 않습니다.",
    "data": {},
    "title": null
  },
  "success": null
}
```

> 응답의 txId를 사용해 `appsInTossSignTossCert` 함수를 호출하면 토스앱 인증 화면이 실행됩니다.

##### 2-2. 원터치 인증 (requestType: USER_NONE)

클라이언트에서 **개인정보 입력 없이** 토스앱을 호출해 **한 번에 인증을 완료**해요.

**요청 헤더**

| 이름 | 타입 | 필수 | 설명 |
| --- | --- | --- | --- |
| Authorization | string | Y | `Bearer {Access Token}` |
| Content-Type | string | Y | `application/json` |

**요청 파라미터**

| 이름 | 타입 | 필수 | 설명 |
| --- | --- | --- | --- |
| requestType | string | Y | `"USER_NONE"` |
| requestUrl | string | Y | 인증 완료 후 돌아올 앱스킴 |

**요청 예시 (Shell curl)**

```bash
curl --location --request POST 'https://cert.toss.im/api/v2/sign/user/auth/id/request' \
--header 'Authorization: Bearer {ACCESS_TOKEN}' \
--header 'Content-Type: application/json' \
--data-raw '{
       "requestType" : "USER_NONE",
       "requestUrl" : "intoss://my-granite-app"
    }'
```

**성공 응답**

```json
{
    "resultType": "SUCCESS",
    "success": {
        "txId": "d7b7273b-407b-46be-a9d8-97d2e895b009",
        "requestedDt": "2022-02-13T17:52:22+09:00"
    }
}
```

#### 3단계. 인증 화면 호출하기

**SDK를 통해 연동해주세요.**

응답에서 받은 `txId`를 사용해 `appsInTossSignTossCert` 함수를 호출하면, 토스앱 인증 화면이 실행돼요.

> **토스앱 최소 버전을 확인하세요**
>
> * 토스 인증 (requestType: USER\_PERSONAL): 토스앱 5.233.0 이상
> * 토스 원터치 인증 (requestType: USER\_NONE): 토스앱 5.236.0 이상
>
> `getTossAppVersion` 함수를 사용하여 토스앱 버전을 체크해보세요.

#### 4단계. 본인확인 상태 조회하기

사용자의 현재 인증 **진행 상태**를 조회해요. `txId`를 사용해 현재의 인증 단계 (`REQUESTED`, `IN_PROGRESS`, `COMPLETED`, `EXPIRED`)를 확인할 수 있어요.

> **주의하세요**: 상태조회 API는 **진행 상태 확인용**이에요. 최종 인증 성공 여부는 **결과조회 API**로 판별해야 해요.

* BaseURL: `https://cert.toss.im`
* Endpoint: `/api/v2/sign/user/auth/id/status`
* Method: `POST`
* Content-type: `application/json`

**요청 헤더**

| 이름 | 타입 | 필수값 여부 | 설명 |
|---|---|---|---|
| Authorization | string | Y | `Bearer {Access Token}` |
| Content-Type | string | Y | `application/json` |

**요청 파라미터**

| 이름 | 타입 | 필수값 여부 | 설명 |
|---|---|---|---|
| txId | string | Y | 상태 확인이 필요한 인증 요청 트랜잭션 아이디 |

**요청 예시 (Shell curl)**

```bash
curl --location --request POST 'https://cert.toss.im/api/v2/sign/user/auth/id/status' \
--header 'Authorization: Bearer {ACCESS_TOKEN}' \
--header 'Content-Type: application/json' \
--data-raw '{
      "txId": "633f3e1b-1a11-4e7c-9b35-dd391f440be4"
    }'
```

**성공 응답**

| 이름 | 타입 | 설명 |
|---|---|---|
| resultType | string | 요청 결과. 성공 시 `SUCCESS` |
| success.txId | string | 조회한 인증 트랜잭션 ID |
| success.status | string | 인증 진행 상태 (아래 "status 값" 표 참고) |
| success.requestedDt | string | 최초 인증 요청 시각 (`YYYY-MM-DDThh:mm:ss±hh:mm`, ISO 8601) |

```json
{
  "resultType": "SUCCESS",
  "success": {
    "txId": "633f3e1b-1a11-4e7c-9b35-dd391f440be4",
    "status": "REQUESTED",
    "requestedDt": "2022-02-13T18:00:26+09:00"
  }
}
```

**실패 응답**

```json
{
  "resultType": "FAIL",
  "error": {
    "errorType": 0,
    "errorCode": "CE3100",
    "reason": "존재하지 않는 요청입니다",
    "data": {},
    "title": null
  },
  "success": null
}
```

**status 값**

| 값 | 설명 |
|---|---|
| REQUESTED | 토스 인증서버에서 사용자의 토스 앱으로 인증이 요청된 상태 |
| IN\_PROGRESS | 사용자가 인증을 진행 중인 상태 |
| COMPLETED | 고객이 인증을 완료한 상태 *(최종 확정은 결과조회 API로 판단해야 해요)* |
| EXPIRED | 유효시간 만료로 인증 진행이 불가한 상태 |

#### 5단계. 본인확인 결과 조회하기

인증이 완료된 사용자의 **결과 정보**를 조회해요. 조회는 반드시 **서버-서버 통신**으로 진행해 주세요. 본인확인 결과로 수집한 정보는 서버에 안전하게 저장하고, 이후 전자서명/간편인증 시 해당 정보와 비교·검증 해 주세요.

> **주의하세요**
>
> * 결과조회 API는 성공 기준으로 **최대 2회**까지만 조회가 가능해요.
> * 사용자 인증을 끝마친 후 **60분(1시간) 이내** 결과 조회를 끝내야 해요.
> * 60분을 초과하면 결과 조회가 제한되며 인증 요청 API부터 다시 시작해야 해요.

* BaseURL: `https://cert.toss.im`
* Endpoint: `/api/v2/sign/user/auth/id/result`
* Method: `POST`
* Content-type: `application/json`

**요청 헤더**

| 이름 | 타입 | 필수값 여부 | 설명 |
|---|---|---|---|
| Authorization | string | Y | `Bearer {Access Token}` |
| Content-Type | string | Y | `application/json` |

**요청 파라미터**

| 이름 | 타입 | 필수값 여부 | 설명 |
|---|---|---|---|
| txId | string | Y | 결과 확인이 필요한 인증 요청 트랜잭션 아이디 |
| sessionKey | string | Y | 결과조회에서는 인증수단과 무관하게 `txId`와 함께 필수로 전달. 요청/응답 AES 암·복호화용 세션 키로, 매 요청마다 새로 생성하고 인증요청에서 사용한 세션키는 재사용 금지 |

**요청 예시 (Shell curl)**

```bash
curl --location --request POST 'https://cert.toss.im/api/v2/sign/user/auth/id/result' \
--header 'Authorization: Bearer {ACCESS_TOKEN}' \
--header 'Content-Type: application/json' \
--data-raw '{
       "txId" : "c1ce9214-9878-4751-b433-0c96641b0e13",
       "sessionKey" : "v1$71c3d6cd-6a74-48a8-8ab2-b48e6133ae6f$Q0U7Bdg4dWd0XXucjsM/mda89bFU7eHnoUhgQ3k+cGQ9gv37jvWC+8isrkO2CR4+qgoPg+U+K7/tQH2m+uU7L8Ab0gzbQo6ASX39NpcP6RHpI+VBi323ssYnBmJL7n0z4aNm6raUEsMoNwrOaMDe0DqfalgOeZgZUztWew1pfZul2Q3/WIBMdp+npS4sFnBRoBrzLroVsuNRTLK0XT6m5hak+ys+vBg5vZFoI0JN7j7zsr8lqGi6piSkygl1PLPugnSC9cOezxMoVN5c/csEVQxMsfkwqTIASaZVECnP50dO70TydYhBFCqxw3DpEDBHcXNDucOtdVOPslCPNx3NZv1i0IH0r92ULb3w2Y0Fncy4/xL1dPSS+TbA5540u2Wb3cxqVNHib7WwSMHBwQtXAnFSFZmcvQQPXtTeQ7SCvNnhA8k3gbboSpbDBg60RWn/1zF/ogBYRldO1BFtq7KP+jOm6I2OSSVpagH1Wu5MXhEtiTmsx7M8j/IM8EfnXbD9axJnlW2fKHZVvAj+5KNhqy90PUimBCKiXqjvUwOqb9hGGEzJ4JVKbIIiy1EYOaRkPTK9GurZwQaqM4o4c8pzOYRQR/3XIPWHxLv/jwsaMcfUIQFyKE+w898g+l1zO0jcck59/R64kZcirT9AsGFnRUWrsHGIkM95jdYlpUsnCXw="
  }'
```

**성공 응답**

| 이름 | 타입 | 설명 |
|---|---|---|
| resultType | string | 성공 시 `SUCCESS` |
| success.txId | string | 결과를 조회한 인증 트랜잭션 아이디 |
| success.status | string | `COMPLETED` *(결과 조회가 정상 처리된 상태)* |
| success.userIdentifier | string/null | 현재 버전 미사용 (`null`) |
| success.userCiToken | string/null | 현재 버전 미사용 (`null`) |
| success.signature | string | 사용자가 서명한 전자서명 값(Base64 인코딩된 DER). **txId와 함께 저장 관리 필수** |
| success.randomValue | string/null | 현재 버전 미사용 (`null`) |
| success.completedDt | string | 사용자 인증 완료 시각 (`YYYY-MM-DDThh:mm:ss±hh:mm`, ISO 8601) |
| success.requestedDt | string | 최초 인증 요청 시각 (`YYYY-MM-DDThh:mm:ss±hh:mm`, ISO 8601) |
| success.personalData | object | 인증에 사용된 **개인정보(암호화 값)**. 하위 필드 표 참고 |

**personalData (인증을 진행한 사용자 개인정보) Object**

| 이름 | 타입 | 설명 |
|---|---|---|
| ci | string | 암호화된 사용자의 CI |
| name | string | 암호화된 사용자의 이름 |
| birthday | string | 암호화된 생년월일 8자리 |
| gender | string | 암호화된 성별 정보 (`MALE` \| `FEMALE`) |
| nationality | string | 암호화된 국적 (`LOCAL` \| `FOREIGNER`) |
| ci2 | string/null | 예측 불가 상황에서 ci 유출 대응을 위한 임시 파라미터, `null` 고정 |
| di | string | 암호화된 사용자의 DI |
| ciUpdate | string/null | 예측 불가 상황에서 ci 유출 대응을 위한 임시 파라미터, `null` 고정 |
| ageGroup | string | 암호화된 성인여부 (`ADULT` \| `MINOR`) |

```json
// 결과조회 응답에서는 인증을 호출하는 방식에 상관없이 동일한 바디 파라미터를 제공합니다.
{
  "resultType": "SUCCESS",
  "success": {
    "txId": "c1ce9214-9878-4751-b433-0c96641b0e13",
    "status": "COMPLETED",
    "userIdentifier": null,
    "userCiToken": null,
    "signature": "MIIJCAYJKoZIhvcN...(생략)",
    "randomValue": null,
    "completedDt": "2022-02-13T18:01:53+09:00",
    "requestedDt": "2022-02-13T18:00:26+09:00",
    "personalData": {
      "ci": "v1$b88f8717-8e76-4276-bed0-f769a8baf7be$X3g52aAyCBirz0UVp1oNRq0SfGtj66vGtUT3rp1aSdm1h//xmpm7vdf48fbGI2i7VTBj6TKG2rqanP6Yo9MiTQu63C8kLWayzWAMp+RLyXLovvnFb9SxxdblRtZbj5KRNlBWK9t2VXI=",
      "name": "v1$b88f8717-8e76-4276-bed0-f769a8baf7be$9oiJBRei1KI/SgXtXGmkfNHu+pdAUHXBxA==",
      "birthday": "v1$b88f8717-8e76-4276-bed0-f769a8baf7be$LQgw26ExChwWi8cQQz6GrdMAdMZGyaEI",
      "gender": "v1$b88f8717-8e76-4276-bed0-f769a8baf7be$WnREqd1HM/Ci7p+3KIqROusVkYeSAQ==",
      "nationality": "v1$b88f8717-8e76-4276-bed0-f769a8baf7be$UH5Kqd3dPV1daxw0i23eMWjeXcXC",
      "ci2": null,
      "di": "v1$2e161d9d-e620-443e-9a27-8db41cc96cf9$6GKr2zaUWWfI6rpJ6/AV9U4W0S4nhAMFIFLkt5CS6N8Gjb1Oc/dpitkMSSvLroDO5b6zdl9bufGSQ6SiVQdlYN2OWYFBr/Hb4e4AYwQpFxDbpi9ksYt52aFa3G2DwaNOQMUBkyQ1IWc=",
      "ciUpdate": null
    }
  }
}
```

**실패 응답**

```json
{
  "resultType": "FAIL",
  "error": {
    "errorType": 0,
    "errorCode": "CE3102",
    "reason": "요청이 아직 완료되지 않았습니다.",
    "data": {},
    "title": null
  },
  "success": null
}
```

---

### 5-3. 토스 인증 테스트하기

원문 URL: https://developers-apps-in-toss.toss.im/tossauth/test.md

계약이 완료되지 않아도 **토스인증 테스트 환경**에서 인증 연동을 진행해 볼 수 있어요. 먼저 연동을 진행한 뒤 테스트를 수행해 주세요. 테스트 시에는 **앱 스토어에서 설치한 최신 버전의 토스앱**을 이용하세요. **본인확인**과 **원터치 인증** 방식 모두 테스트가 가능합니다.

> **테스트 환경 자격증명**
>
> * client\_id: `test_a8e23336d673ca70922b485fe806eb2d`
> * client\_secret: `test_418087247d66da09fda1964dc4734e453c7cf66a7a9e3`

#### 토스 앱 버전

* **토스앱 (본인확인)**: 5.233.0 이상
* **토스앱 (원터치 인증)**: 5.236.0 이상

`getTossAppVersion` 함수를 사용하여 토스앱 버전을 체크해보세요.

#### 방화벽 설정

요청 서버의 **아웃바운드(Outbound)** 설정에 아래 토스인증 IP를 허용해주세요. 모든 통신은 **443 포트(HTTPS)** 를 사용해요.

토스 인증 서버는 **인바운드(Inbound)** 가 제한 없이 오픈되어 있어, 별도 설정 없이 바로 통신 테스트를 진행할 수 있어요.

> **본인확인 Outbound 허용 IP**
>
> * 117.52.3.222
> * 117.52.3.235
> * 211.115.96.222
> * 211.115.96.235

#### 라이브 환경과의 차이점

**인증 사용료 무료**

테스트 환경에서는 인증을 성공적으로 완료하더라도 **과금되지 않아요.**

**테스트 환경 자격증명**

테스트 환경의 **클라이언트 자격증명(client\_id, client\_secret)** 은 모두 `test_` 로 시작해요. 이 접두어(prefix)를 통해 **운영 환경 정보와 쉽게 구분**할 수 있어요.

**Access Token 유효기간**

테스트 환경에서는 연동 편의를 위해 **1년(31536000초)** 유효기간이 적용된 Access Token을 제공해요. 운영 환경에서는 **사업자가 신청한 네트워크 방식**에 따라 유효기간이 달라질 수 있으니 참고해주세요.

**가상의 개인정보 제공**

테스트 환경에서 인증이 완료되면, 토스에 가입된 사용자의 암호화된 개인정보 대신 **토스가 생성한 가상 인물의 고정된 개인정보**가 전달돼요.

이는 실제 사용자 정보를 보호하기 위한 조치이며, 정확한 사용자 정보가 필요하다면 **토스로부터 제공받은 이용기관 고유 키**를 사용해 운영 환경과 연동해야 해요.

> **테스트 환경에서 제공되는 가상 개인정보 예시**
>
> * CI: `CI0110000000001 ...`
> * DI: `DI0110000000001 ...`
> * 이름: 김토스
> * 생년월일: 19930324
> * 성별: FEMALE
> * 내외국인: LOCAL
