---
description: "앱인토스(토스 미니앱) 서버 연동에 관한 질문에 사용하세요. 트리거 상황: API 연동, mTLS 인증서 발급/설정, 방화벽 IP 허용, 서버 간 통신(S2S), rate limit/QPM, Firebase 연동, Sentry 에러 모니터링/소스맵, 토스 인증/본인확인/원터치 인증 계약·개발·테스트, CI/DI, client_id/client_secret, Access Token 발급, 인증 요청/상태조회/결과조회 API"
---

# 앱인토스 서버 연동 가이드

## 1. API 개요

원문 URL: https://developers-apps-in-toss.toss.im/api/overview.md

앱인토스를 연동하기 위해 필요한 API를 소개드려요.

> **주의**: iframe은 사용할 수 없어요. iframe을 사용할 경우 앱인토스 기능이 정상 동작하지 않고, 내부 보안 심사에서도 반려돼요. 단, YouTube 영상 콘텐츠를 삽입하는 용도는 예외적으로 iframe 사용이 가능해요.

### 서버 mTLS 인증서 발급받기

앱인토스 API를 사용하려면 반드시 **mTLS(양방향 전송 계층 보안)** 인증서를 설정해야 해요. 일반 HTTPS는 서버만 인증하지만, mTLS는 **파트너사 서버와 앱인토스 서버가 서로를 인증**해요. 이를 통해 통신 구간 암호화, 허용된 서버만 API 호출 가능, 위변조 방지를 보장해요.

### 통신 방화벽 확인하기

서버에서 Inbound, Outbound 방화벽을 관리하고 있다면 아래 IP와 포트를 반드시 허용해야 해요.

#### Inbound IP (앱인토스 → 가맹점)

| IP               | Port |
| ---------------- | ---- |
| 117.52.3.11      | 443  |
| 211.115.96.11    | 443  |
| 106.249.5.11     | 443  |
| 117.52.3.80~87   | 443  |
| 211.115.96.80~87 | 443  |
| 106.249.5.80~87  | 443  |

#### Outbound IP (가맹점 → 앱인토스)

| 기능                                       | 도메인                       | IP                                          | Port |
| ------------------------------------------ | ---------------------------- | ------------------------------------------- | ---- |
| 간편 로그인, 메시지 발송, 토스 포인트 지급 | apps-in-toss-api.toss.im     | 117.52.3.192, 211.115.96.192, 106.249.5.192 | 443  |
| 간편 결제                                  | pay-apps-in-toss-api.toss.im | 117.52.3.195, 211.115.96.195, 106.249.5.195 | 443  |

### API 공통 규격

**도메인**: `https://apps-in-toss-api.toss.im`, `https://pay-apps-in-toss-api.toss.im`

**공통 응답 형식**: 모든 API는 `resultType`으로 성공 여부를 판별해요.

```json
// 성공
{ "resultType": "SUCCESS", "success": { "sample": "data" } }

// 실패
{ "resultType": "FAIL", "error": { "errorCode": "INVALID_PARAMETER", "reason": "요청에 실패했습니다." } }
```

### 요청 제한 정책 (Rate Limit)

* 분당 **3,000 QPM** (Queries Per Minute)
* 상향이 필요하면 채널톡으로 사용 목적, 예상 트래픽 규모, 피크 시간대 요청량을 전달하세요.

---

## 2. mTLS 기반 API 사용하기

원문 URL: https://developers-apps-in-toss.toss.im/development/integration-process.md

앱인토스 API를 사용하려면 **mTLS 기반의 서버 간(Server-to-Server) 통신 설정이 반드시 필요해요.**

> **아래 기능은 반드시 mTLS 인증서를 통한 통신이 필요해요**: 토스 로그인, 토스 페이, 인앱 결제, 기능성 푸시/알림, 프로모션(토스 포인트)

### mTLS 인증서 발급 방법

1. **앱 선택**: 앱인토스 콘솔 → mTLS 인증서 탭 → **+ 발급받기**
2. **다운로드 및 보관**: 인증서 파일과 키 파일을 안전한 위치에 보관. 만료 전 반드시 재발급. 무중단 교체를 위해 다중 인증서 등록 가능.

### API 요청 시 인증서 설정

발급받은 인증서/키 파일을 서버 애플리케이션에 등록해야 해요.

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

> 다른 언어 예시(Kotlin, C#, C++, PHP)는 `references/mtls-examples.md` 참조

### 자주 묻는 질문

**`ERR_NETWORK` 에러가 발생해요.** → mTLS 미적용 상태에서 API를 호출하면 발생해요.

---

## 3. Firebase 연동하기

원문 URL: https://developers-apps-in-toss.toss.im/firebase/intro.md

앱인토스 WebView 환경에서 Firebase를 연동할 수 있어요. **Vite(React + TypeScript)** 기반 프로젝트 기준이며, 보안 설정과 환경 변수 관리가 중요해요. Firebase 콘솔에서 프로젝트를 생성하고, 구성 정보를 `.env`로 관리한 뒤, 모듈식 SDK(v12+)로 초기화하세요. Firestore/Storage 보안 규칙은 배포 전 반드시 인증된 사용자만 접근하도록 수정하세요. 허용 대상 도메인은 `https://*.apps.tossmini.com` (서비스), `https://*.private-apps.tossmini.com` (QR 테스트)이에요.

> 상세 내용은 `references/firebase-integration.md` 참조

---

## 4. Sentry 에러 모니터링 설정하기

원문 URL: https://developers-apps-in-toss.toss.im/learn-more/sentry-monitoring.md

앱에 Sentry를 연동하면 JavaScript에서 발생한 오류를 자동으로 감지하고 모니터링할 수 있어요. 소스맵 업로드 명령:

```bash
npx ait sentry upload-sourcemap \
  --api-key <API_KEY> \
  --app-name <APP_NAME> \
  --deployment-id <DEPLOYMENT_ID>
```

> 전체 설정 과정, 플러그인 구성 코드는 `references/sentry-setup.md` 참조

---

## 5. 토스 인증 (본인확인)

### 5-1. 개요 및 계약

원문 URL: https://developers-apps-in-toss.toss.im/tossauth/contract.md

토스 인증은 사용자의 **실명/생년월일/휴대전화번호**를 검증하여 신원을 확인하는 서비스예요. CI(연계정보)를 포함한 식별자를 확보할 수 있어요.

> **웹보드 게임은 본인 확인이 필수예요** (관련 법령)

**인증 유형**:
* **개인정보 기반 인증**: 이름/생년월일/휴대전화번호를 암호화 후 전송. 입력값 검증에 유리하나 이탈률이 다소 높음.
* **원터치 인증**: 개인정보 입력 없이 토스 앱을 바로 호출. UX가 간결하고 전환율 최적화에 유리.

**계약**: `cert.support@toss.im`으로 서류 제출, 영업일 기준 7~14일 소요. 완료 시 `client_id`와 `client_secret` 발급.

### 5-2. 개발 흐름

원문 URL: https://developers-apps-in-toss.toss.im/tossauth/develop.md

> **최소 버전**: SDK 1.2.1+, 토스앱(본인확인) 5.233.0+, 토스앱(원터치) 5.236.0+. `getTossAppVersion`으로 체크 가능.

**5단계 흐름**:

1. **AccessToken 받기**: `POST https://oauth2.cert.toss.im/token` (Content-Type: `application/x-www-form-urlencoded`, grant_type: `client_credentials`, scope: `ca`)
2. **인증 요청**: `POST https://cert.toss.im/api/v2/sign/user/auth/id/request`
   - 개인정보 기반: `requestType: "USER_PERSONAL"` + 암호화된 userName/userPhone/userBirthday/sessionKey
   - 원터치: `requestType: "USER_NONE"` + requestUrl
   - 응답으로 `txId` 수신
3. **인증 화면 호출**: `txId`로 `appsInTossSignTossCert` SDK 함수 호출
4. **상태 조회**: `POST /api/v2/sign/user/auth/id/status` → status: REQUESTED / IN_PROGRESS / COMPLETED / EXPIRED
5. **결과 조회**: `POST /api/v2/sign/user/auth/id/result` → personalData(ci, name, birthday, gender, nationality, di, ageGroup 등 암호화 값)

> **주의**: 결과조회는 성공 기준 **최대 2회**, 인증 완료 후 **60분 이내** 조회 필수.

> 상세 API 스펙은 `references/toss-auth-api.md` 참조

### 5-3. 테스트하기

원문 URL: https://developers-apps-in-toss.toss.im/tossauth/test.md

계약 전에도 테스트 환경에서 인증 연동을 진행할 수 있어요.

**테스트 자격증명**:
* client_id: `test_a8e23336d673ca70922b485fe806eb2d`
* client_secret: `test_418087247d66da09fda1964dc4734e453c7cf66a7a9e3`

**방화벽 Outbound 허용 IP** (443 포트): 117.52.3.222, 117.52.3.235, 211.115.96.222, 211.115.96.235

**라이브 환경과의 차이점**: 인증 사용료 무료, Access Token 유효기간 1년(운영 환경은 다를 수 있음), 가상 개인정보 제공(이름: 김토스, 생년월일: 19930324, 성별: FEMALE).

> 상세 테스트 환경 정보는 `references/toss-auth-api.md` 참조
