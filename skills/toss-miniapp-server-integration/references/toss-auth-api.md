# 토스 인증 (본인확인) 상세 API 명세

## 계약 정보

원문 URL: https://developers-apps-in-toss.toss.im/tossauth/contract.md

### 인증 유형 상세

#### 개인정보 기반 인증

클라이언트에서 **이름/생년월일/휴대전화번호**를 입력받아 암호화 후 전송하는 방식이에요.

* **권장 상황**: 가입/전환 화면에서 이미 개인정보를 수집하고 있는 경우, 입력 값과 실제 가입 정보의 일치 여부를 즉시 검증해야 하는 경우
* **흐름**: 사용자 개인정보 입력 → 암호화 전송 → 토스 앱 인증 → 결과 수신(CI, 이름, 휴대전화번호 등)

#### 원터치 인증

클라이언트에서 **개인정보를 입력받지 않고**, 토스 앱을 바로 호출해 한 번의 인증으로 절차를 완료하는 간소화된 방식이에요.

> **원터치 인증 동작 방식**: 기기에 토스인증서가 있다면 PIN/생체인증, 없다면 토스인증서 발급 후 PIN/생체인증

* **권장 상황**: 이탈 최소화/전환율 최적화가 중요한 경우, 앱 내 간결한 로그인/재인증 UX가 필요한 경우
* **흐름**: "본인 인증" 버튼 클릭 → 토스 앱 호출 → 사용자 인증 → 결과 수신

### 운영 팁

* **웹보드/성인물 서비스**: 본인 확인 후 `ageGroup` 기반으로 성인 여부 정책을 적용하세요.
* **재인증 정책**: 장기간 미사용 또는 주요 정보 변경 시 재인증 주기를 정의하세요.
* **개인정보 최소화**: 원터치 인증을 기본으로 검토하고, 필요한 경우에만 입력 기반 인증을 조합하세요.

### 계약 절차

1. **서류 다운로드 및 작성**: 토스 전자 인증 서비스 이용 신청서, 개인(신용)정보 보안관리 약정서
2. **어드민 권한 정보 준비**: 담당자 이메일 주소와 전화번호
3. **서류 제출**: `cert.support@toss.im`으로 이메일 제출
4. **검토 및 안내**: 영업일 기준 7~14일 소요, 인감 날인 하드카피 서류로 진행
5. **계약 완료 및 키 발급**: `client_id`와 `client_secret` 키를 이메일로 발급

> **'본인 확인' vs '토스 로그인'**: 본인 확인은 실명/생년월일/휴대전화번호를 검증하는 서비스이고, 토스 로그인은 간편 인증 방식이에요. 계약 전 반드시 구분하세요.

---

## 개발 API 상세

원문 URL: https://developers-apps-in-toss.toss.im/tossauth/develop.md

### 1단계. AccessToken 받기

* Base URL: `https://oauth2.cert.toss.im`
* Endpoint: `/token`
* Method: `POST`
* Content-Type: `application/x-www-form-urlencoded`

**요청 파라미터**

| 이름 | 타입 | 필수 | 설명 |
|---|---|---|---|
| grant_type | string | Y | 고정 값: `client_credentials` |
| scope | string | Y | 인증 요청 범위 (예: `ca`) |
| client_id | string | Y | 고객사에 발급된 클라이언트 아이디 |
| client_secret | string | Y | 고객사에 발급된 클라이언트 시크릿 |

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
|---|---|---|
| access_token | string | Access Token 값 |
| scope | string | 발급된 인증 범위 |
| token_type | string | 토큰 타입 (항상 `Bearer`) |
| expires_in | number | 토큰 만료 시간(초 단위) |

### 2단계. 인증 요청하기

* BaseURL: `https://cert.toss.im`
* Endpoint: `/api/v2/sign/user/auth/id/request`
* Method: `POST`
* Content-type: `application/json`

#### 2-1. 개인정보 기반 인증 (requestType: USER_PERSONAL)

**요청 파라미터**

| 이름 | 타입 | 필수 | 설명 |
|---|---|---|---|
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
       "sessionKey" : "v1$cc575847-f549-4c1e-89c7-eff11743e05e$XTTyBJntTja9NfUaTaO09bQ..."
    }'
```

**성공 응답**

| 이름 | 타입 | 설명 |
|---|---|---|
| resultType | string | `SUCCESS` / `FAIL` |
| success.txId | string | 인증 요청 트랜잭션 아이디 (반드시 저장) |
| success.requestedDt | string | 최초 요청 시각 (ISO 8601) |
| success.appScheme | string | 토스 인증 화면 앱 스킴 |
| success.androidAppUri | string | 안드로이드 인증 앱 스킴 값 |
| success.iosAppUri | string | iOS 인증 앱 스킴 값 |

**실패 응답**

| 이름 | 타입 | 설명 |
|---|---|---|
| error.errorType | number | 에러 유형 |
| error.errorCode | string | 에러 코드 (예: `CE1000`) |
| error.reason | string | 에러 메시지 |

#### 2-2. 원터치 인증 (requestType: USER_NONE)

**요청 파라미터**

| 이름 | 타입 | 필수 | 설명 |
|---|---|---|---|
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

### 3단계. 인증 화면 호출하기

응답에서 받은 `txId`를 사용해 `appsInTossSignTossCert` 함수를 호출하면, 토스앱 인증 화면이 실행돼요.

### 4단계. 본인확인 상태 조회하기

* Endpoint: `POST /api/v2/sign/user/auth/id/status`
* 요청 파라미터: `txId` (string, 필수)

**status 값**

| 값 | 설명 |
|---|---|
| REQUESTED | 토스 인증서버에서 사용자의 토스 앱으로 인증이 요청된 상태 |
| IN_PROGRESS | 사용자가 인증을 진행 중인 상태 |
| COMPLETED | 고객이 인증을 완료한 상태 (최종 확정은 결과조회 API로 판단) |
| EXPIRED | 유효시간 만료로 인증 진행이 불가한 상태 |

> **주의**: 상태조회 API는 진행 상태 확인용이에요. 최종 인증 성공 여부는 결과조회 API로 판별해야 해요.

### 5단계. 본인확인 결과 조회하기

* Endpoint: `POST /api/v2/sign/user/auth/id/result`
* 요청 파라미터: `txId` (string, 필수), `sessionKey` (string, 필수 - 매 요청마다 새로 생성, 인증요청에서 사용한 세션키 재사용 금지)

> **주의**: 성공 기준 최대 2회 조회 가능, 인증 완료 후 60분 이내 결과 조회 필수

**personalData (인증을 진행한 사용자 개인정보) Object**

| 이름 | 타입 | 설명 |
|---|---|---|
| ci | string | 암호화된 사용자의 CI |
| name | string | 암호화된 사용자의 이름 |
| birthday | string | 암호화된 생년월일 8자리 |
| gender | string | 암호화된 성별 정보 (`MALE` / `FEMALE`) |
| nationality | string | 암호화된 국적 (`LOCAL` / `FOREIGNER`) |
| di | string | 암호화된 사용자의 DI |
| ageGroup | string | 암호화된 성인여부 (`ADULT` / `MINOR`) |

**성공 응답 예시**

```json
{
  "resultType": "SUCCESS",
  "success": {
    "txId": "c1ce9214-9878-4751-b433-0c96641b0e13",
    "status": "COMPLETED",
    "signature": "MIIJCAYJKoZIhvcN...(생략)",
    "completedDt": "2022-02-13T18:01:53+09:00",
    "requestedDt": "2022-02-13T18:00:26+09:00",
    "personalData": {
      "ci": "v1$b88f8717...$X3g52aAyCBirz0UVp1oN...",
      "name": "v1$b88f8717...$9oiJBRei1KI/SgXtXGmkfN...",
      "birthday": "v1$b88f8717...$LQgw26ExChwWi8cQQz6G...",
      "gender": "v1$b88f8717...$WnREqd1HM/Ci7p+3KIqR...",
      "nationality": "v1$b88f8717...$UH5Kqd3dPV1daxw0i23e...",
      "di": "v1$2e161d9d...$6GKr2zaUWWfI6rpJ6/AV...",
      "ageGroup": "encrypted_value"
    }
  }
}
```

---

## 테스트 환경

원문 URL: https://developers-apps-in-toss.toss.im/tossauth/test.md

### 테스트 자격증명

* client_id: `test_a8e23336d673ca70922b485fe806eb2d`
* client_secret: `test_418087247d66da09fda1964dc4734e453c7cf66a7a9e3`

### 최소 토스앱 버전

* 본인확인: 5.233.0 이상
* 원터치 인증: 5.236.0 이상

### 방화벽 설정 (Outbound 허용 IP)

* 117.52.3.222
* 117.52.3.235
* 211.115.96.222
* 211.115.96.235

모든 통신은 443 포트(HTTPS). 토스 인증 서버는 Inbound가 오픈되어 있어 별도 설정 불필요.

### 라이브 환경과의 차이점

* **인증 사용료 무료**: 테스트 환경에서는 과금되지 않아요.
* **테스트 자격증명**: `test_` 접두어로 운영 환경과 구분.
* **Access Token 유효기간**: 테스트에서는 1년(31536000초), 운영 환경에서는 다를 수 있어요.
* **가상 개인정보 제공**: 테스트 환경에서는 실제 사용자 정보 대신 가상 인물 정보가 전달돼요.

> **테스트 가상 개인정보 예시**: 이름: 김토스, 생년월일: 19930324, 성별: FEMALE
