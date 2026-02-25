---
description: "토스 로그인(토스 미니앱 로그인 연동) 관련 질문에 답변할 때 사용하세요. 다음 키워드가 포함된 질문에 트리거됩니다: 토스 로그인, appLogin, OAuth2, 인가 코드, authorizationCode, 액세스 토큰, accessToken, 리프레시 토큰, refreshToken, userKey, 사용자 정보 복호화, 개인정보 복호화, AES/GCM, 로그인 연동 해제, 연결 끊기, 콜백, referrer, UNLINK, WITHDRAWAL_TERMS, WITHDRAWAL_TOSS, 동의 항목, 약관 등록, scope, CI, DI, 토스 로그인 설정, 복호화 키, 토스 로그인 콘솔, 토스 로그인 개발, 토스 로그인 QA, generate-token, refresh-token, login-me, remove-by-access-token, remove-by-user-key"
---

# 토스 로그인 (앱인토스 미니앱)

## 이해하기

앱인토스에서 토스 회원을 한 번에 연동해 보세요.
한 번의 동의로 가입부터 로그인, 정보 제공까지 이어져 토스 회원 연동을 간단하게 구현할 수 있어요.

> **꼭 확인해 주세요**
> - 미니앱에서 로그인 기능은 토스 로그인만 사용할 수 있어요.
> - 자사 로그인이나 다른 간편 로그인 방식은 사용할 수 없어요.

---

### 토스 로그인이란 무엇인가요

토스 로그인은 토스 계정으로 빠르고 안전하게 로그인할 수 있는 기능이에요.
로그인 과정에서 사용자에게 어떤 정보 제공에 동의받을지 직접 설정할 수 있어요.
또한 앱인토스 서비스를 운영하는 데 필요한 약관과 동의문, 연결 끊기 콜백 정보도 함께 등록할 수 있어요.

---

### 토스 로그인을 사용하면 어떤 점이 좋나요

- 별도의 가입 폼 없이 바로 가입과 로그인이 이뤄져 매끄러운 회원가입 경험을 만들 수 있어요.
- 토스에서 직접 제공하는 신뢰도 높은 사용자 정보를 활용할 수 있어요.
- 재방문할 때 자동 로그인이나 원클릭 로그인이 가능해요.
- 앱을 다시 설치하거나 기기를 바꿔도 같은 사용자로 매칭돼 고객 문의 대응 부담이 줄어들어요.

---

### 참고해 주세요

아래 기능을 사용하려면 토스 로그인을 반드시 연동해야 해요.

- 기능성 푸시와 알림
- 프로모션
- 토스페이

---

## 콘솔 가이드

토스 로그인을 원활히 사용하려면 **콘솔에서 계약 → 설정** 순서로 진행해 주세요.

### 1. 약관 동의

토스 로그인 사용을 위해서는 **약관에 동의해야 해요.**
약관동의는 앱인토스 콘솔에서 진행이 가능하며, **대표관리자로 지정된 분**의 계정에서만 가능해요.

- 약관 동의 방법
  - 앱인토스 콘솔 접속 → 대표 관리자 계정 로그인 → 워크스페이스 선택 → 미니앱 선택 → 좌측 메뉴 중 '토스 로그인' 선택 후 '약관 확인하기' 를 클릭 하여 아래 화면에서 약관 동의 진행

### 2. 설정하기

로그인 연동을 위해 콘솔에서 **사전 설정**을 완료해 주세요.
입력한 정보를 기반으로 **사용자 약관 동의 화면**이 자동으로 구성됩니다.

#### ① 연동할 서비스 : 기존 로그인과 연동하기

이미 토스 로그인을 사용 중인 서비스가 있을 경우 노출되는 영역이에요.
기존 서비스의 회원 식별자(`userKey`)를 **앱인토스 토스 로그인과 동일하게 설정**할 수 있어요.
목록에서 서비스 이름을 선택하면, 선택한 서비스의 `userKey` 값이 **동일하게 매핑돼요.**

> **회원을 관리해보세요**
> 토스 로그인을 연동하면 회원 정보를 쉽게 조회할 수 있어요.
> 사용자 정보 받기 API를 통해 사용자 식별자 `userKey`를 전달받을 수 있으며, `userKey`는 회원별 유니크한 값으로 **통합 회원 관리**에 유용해요.
> 단, 미니앱(서비스)마다 `userKey`는 다를 수 있어요.

#### ② 동의 항목 : 사용자 권한 범위 설정

토스 로그인을 통해 수집할 **사용자 권한(스코프)** 을 선택해 주세요.

> **꼭 확인해 주세요**
> 이름, 이메일, 성별 외의 항목을 선택한 경우, **연결 끊기 콜백 정보**를 반드시 입력해야 해요.

| 항목 | 설명 |
|------|------|
| 이름 (USER_NAME) | 사용자의 이름이에요. |
| 이메일 (USER_EMAIL) | 사용자의 이메일이에요. (토스 가입 시 필수가 아니어서 값이 없을 수 있고, 이 경우 null로 전달돼요.) |
| 성별 (USER_GENDER) | 사용자의 성별이에요. |
| 생일 (USER_BIRTHDAY) | 사용자의 생년월일이에요. |
| 국적 (USER_NATIONALITY) | 사용자의 국적이에요. |
| 전화번호 (USER_PHONE) | 사용자의 전화번호예요. |
| CI (USER_CI) | 사용자를 식별하는 고유한 KEY 값이에요. (Connection Information) |

> **CI란?**
> CI(Connection Information)는 본인인증 기관에서 발급하는 **고유 식별값**이에요.
> 동일한 사용자가 여러 서비스에 가입하더라도, **같은 본인으로 식별할 수 있도록 생성되는 불변값**이에요.
> CI는 사용자 실명 인증이 필요한 서비스에서 **중복가입 방지나 본인 식별** 목적으로 자주 활용돼요.
> 개인정보보호법상 **개인식별정보(PII)** 에 해당하므로, 저장하거나 사용할 때 반드시 **암호화 및 최소 수집 원칙**을 지켜야 해요.

#### ③ 약관 등록

> **주의해 주세요**
> 이 영역은 **법적 요건을 충족해야 하는 부분**이에요.
> 서비스 성격에 따라 내용이 달라질 수 있으니 **최신 법령과 가이드라인을 확인하고, 법률 자문을 받는 것**을 권장해요.

앱인토스에서 서비스를 운영하려면 약관을 등록해야 해요.
**토스 로그인 필수 약관(서비스 약관 / 개인정보 제3자 제공 동의)** 은 자동으로 포함되며,
**파트너사 서비스 약관 / 개인정보 수집·이용 동의 / 마케팅 정보 수신 동의(선택)** 등은 직접 등록해야 해요.
서비스 목적에 맞는 **정확한 약관 링크**를 첨부해 주세요.

약관 유형은 기본 제공 예시 중에서 선택하거나 직접 입력할 수 있어요.
약관을 구분해서 관리하고 싶다면 직접 입력하는 걸 추천드려요.

**등록 가능한 약관 예시**

- **(1) 서비스 이용약관**: 권리·의무, 책임 범위, 중단/종료, 분쟁 해결, 약관 변경 고지, (유료 시) 결제/환불 규정
- **(2) 개인정보 수집·이용 동의**: 수집 항목, 이용 목적, 보유·이용 기간, 동의 거부 시 불이익
- **(3) 마케팅 정보 수신 동의(선택)**: 수집 항목, 이용 목적, 보유 기간, 거부 시 불이익, 전자적 전송매체 광고 수신 동의
- **(4) 야간 혜택 수신 동의(선택)**: 야간(21:00~08:00) 발송 여부 명시

모든 약관 링크가 **정확히 연결**되고, 화면에 **명확하게 노출**되는지 확인해 주세요.

#### ④ 연결 끊기 콜백 정보

사용자가 토스앱에서 **로그인 연결을 해제**하면, 등록한 **콜백 URL**로 이벤트를 받을 수 있어요.

> **참고하세요**
> 사용자가 연결 해제를 하면 토스는 **동의 약관·로그인 정보**를 모두 삭제해요.
> 서비스에서도 세션이나 토큰 정리 등 후처리를 꼭 해 주세요.
>
> 또한, 사용자가 토스앱에서 로그인 연결을 해제하면 서비스에서도 **자동 로그아웃 처리** 또는 **재로그인 요청 안내**를 제공하는 걸 권장해요.
> 예를 들어, "토스 연결이 해제되어 로그인이 필요합니다." 같은 문구를 노출해 주세요.

| 항목 | 설명 |
|------|------|
| 콜백 URL | 사용자가 로그인연결을 해제했을 때 호출할 URL이에요. |
| HTTP 메서드 | `GET` 또는 `POST` 중 하나를 선택해 주세요. |
| Basic Auth 헤더 | 호출 시 base64로 인코딩돼요. 디코딩 후 콘솔에 입력한 값과 일치하는지 검증해 주세요. |

**연결 끊기 이벤트 경로**

사용자가 토스앱에서 로그인 연결을 해제하는 경로는 총 **3가지**예요.
콜백 요청 시 `referrer`값으로 구분할 수 있어요.

| referrer | 설명 |
|----------|------|
| `UNLINK` | 사용자가 **앱에서 직접 연결을 끊었을 때** 호출돼요. 미니앱에서는 이 이벤트를 받으면 **로그아웃 처리**를 해 주세요. (경로: 토스 앱 > 설정 > 인증 및 보안 > 토스로 로그인한 서비스 > '연결 끊기') |
| `WITHDRAWAL_TERMS` | 사용자가 **로그인 서비스 약관을 철회할 때** 호출돼요. (경로: 토스 앱 > 설정 > 법적 정보 및 기타 > 약관 및 개인정보 처리 동의 > 서비스별 동의 내용 : "토스 로그인" > '동의 철회하기') |
| `WITHDRAWAL_TOSS` | 사용자가 **토스 회원을 탈퇴할 때** 호출돼요. |

### 복호화 키 확인하기

토스 로그인 정보 등록이 완료되면 **복호화 키**를 확인할 수 있어요.
이 키는 토스 로그인 응답 데이터를 복호화할 때 사용돼요.
**'이메일로 복호화 키 받기'** 버튼을 눌러 안전하게 받아보세요.

> **유의사항**
> 복호화 키는 **민감한 보안 정보**예요.
> - 절대 외부에 노출하지 마세요.
> - 안전한 내부 비밀 저장소(Secret Manager 등)에 보관해 주세요.
> - 재발급이 필요한 경우, 채널톡으로 문의해 주세요.

---

## 개발하기

> **BaseURL**
> `https://apps-in-toss-api.toss.im`

### 1. 인가 코드 받기

**SDK를 통해 연동해주세요.**

사용자의 인증을 요청하고, 사용자가 인증에 성공하면 인가 코드를 메소드 응답으로 전달드려요.
`appLogin` 함수를 사용해서 인가 코드(`authorizationCode`)와 `referrer`를 받을 수 있어요.

- 샌드박스앱에서는 `referrer` 가 `sandbox`가 반환돼요
- 토스앱에서는 `referrer` 가 `DEFAULT` 가 반환돼요

> **참고하세요**
> 인가코드의 유효시간은 10분입니다.

**토스 로그인을 처음 진행할 때**

`appLogin` 함수를 호출하면 토스 로그인 창이 열리고, 앱인토스 콘솔에서 등록한 약관 동의 화면이 노출돼요.
사용자가 필수 약관에 동의하면 인가 코드가 반환돼요.

**토스 로그인을 이미 진행했을 때**

`appLogin` 함수를 호출하면 별도의 로그인 창 없이 바로 인가 코드가 반환돼요.

### 2. AccessToken 받기

사용자 정보 조회 API 호출을 위한 **접근 토큰을 발급해요.**

- Content-Type: `application/json`
- Method: `POST`
- URL: `/api-partner/v1/apps-in-toss/user/oauth2/generate-token`

> **참고하세요**
> AccessToken의 유효시간은 1시간이에요.

**요청**

| 이름 | 타입 | 필수값 여부 | 설명 |
|------|------|-------------|------|
| authorizationCode | string | Y | 인가코드 |
| referrer | string | Y | referrer |

**성공 응답**

| 이름 | 타입 | 필수값 여부 | 설명 |
|------|------|-------------|------|
| tokenType | string | Y | bearer 로 고정 |
| accessToken | string | Y | accessToken |
| refreshToken | string | Y | refreshToken |
| expiresIn | string | Y | 만료시간(초) |
| scope | string | Y | 인가된 scope(구분) |

```json
{
  "resultType": "SUCCESS",
  "success": {
    "accessToken": "eyJraWQiOiJjZXJ0IiwiYWxnIjoiUlMyNTYifQ.eyJzdWIiOiJtMHVmMmhaUmpJTnNEQTdLNHVuVHhMb3IwcWNSa2JNPSIsImF1ZCI6IjNlenQ2ZTF0aDg2b2RheTlwOWN1eTg0dTRvdm5nNnNzIiwibmJmIjoxNzE4MjU0ODM2LCJzY29wZSI6WyJ1c2VyX2NpIiwidXNlcl9iaXJ0aGRheSIsInVzZXJfbmF0aW9uYWxpdHkiLCJ1c2VyX25hbWUiLCJ1c2VyX3Bob25lIiwidXNlcl9nZW5kZXIiXSwiaXNzIjoiaHR0cHM6Ly9jZXJ0LnRvc3MuaW0iLCJleHAiOjE3MTgyNTg0MzYsImlhdCI6MTcxODI1NDgzNiwianRpIjoiMTJkYjYwZjYtMjEzYS00NWQ3LTllOTItODBjMzBdseY2JkMGQ3In0.W1cjoeMN8pd3Jqgh6h8YzSVQ1PUNldulJJgy6bgH1AoDbv5xFTlBLzz9Slb_u52zUpyZbhglwblQmNJs7GT6-us7XtfxSGxTUY3ORqIhF_PPGQ6soi_Qgsi-hmX165CCAilf8cltSTTuTt8xOiEbLuSTY-cecxo7SkPUonQ_0v4_Ik0kwOiOBuYZyuch3KmlYQZTqsJmxlwJAPB8M9tZTtDpLOv9MEPU35YS7CZyN0l7lwn1EKrDHJdzA5CnstqEdz2I0eREmMgZoG9mSEybgD4NtPmVJos6AJerUGgSmzP_TwwlybVATuGpnAUmH1idaZJ-MHZJhUhR82z4zTn3bw",
    "refreshToken": "xNEYPASwWw0n1AxZUHU9KeGj8BitDyYo4wi8rpfkUcJwByVxpAdUzwtIaWGVL6vHdrXLCxIlHAQRPF9hHnFleTsHkqUXzc-_78sD_r1Uh5Ff9UCYfArx8LTn1Vk99dDb",
    "scope": "user_ci user_birthday user_nationality user_name user_phone user_gender",
    "tokenType": "Bearer",
    "expiresIn": 3599
  }
}
```

**실패 응답**

인가 코드가 만료되었거나 동일한 인가 코드로 AccessToken 을 중복으로 요청할 경우

```json
{
  "error": "invalid_grant"
}
```

```json
{
  "resultType": "FAIL",
  "error": {
    "errorCode": "INTERNAL_ERROR",
    "reason": "요청을 처리하는 도중에 문제가 발생했습니다."
  }
}
```

### 3. AccessToken 재발급 받기

사용자 정보 조회 API를 호출하기 위한 접근 토큰을 재발급해요.

- Content-type: `application/json`
- Method: `POST`
- URL: `/api-partner/v1/apps-in-toss/user/oauth2/refresh-token`

> **참고하세요**
> refreshToken 유효시간은 14일이에요.

**요청**

| 이름 | 타입 | 필수값 여부 | 설명 |
|------|------|-------------|------|
| refreshToken | string | Y | 발급받은 RefreshToken |

**성공 응답**

| 이름 | 타입 | 필수값 여부 | 설명 |
|------|------|-------------|------|
| tokenType | string | Y | bearer 로 고정 |
| accessToken | string | Y | accessToken |
| refreshToken | string | Y | refreshToken |
| expiresIn | string | Y | 만료시간(초) |
| scope | string | Y | 인가된 scope(구분) |

**실패 응답**

| 이름 | 타입 | 필수값 여부 | 설명 |
|------|------|-------------|------|
| errorCode | string | Y | 에러 코드 |
| reason | string | Y | 에러 메시지 |

### 4. 사용자 정보 받기

사용자 정보를 조회해요.
`DI`는 `null`로 내려오며, 횟수 제한 없이 호출할 수 있어요.
개인정보 보호를 위해 모든 개인정보는 **암호화된 형태**로 제공돼요.

- Content-type: `application/json`
- Method: `GET`
- URL: `/api-partner/v1/apps-in-toss/user/oauth2/login-me`

> **`scope` 에 `user_key` 값이 추가될 예정이에요**
> `scope` 파라미터는 **콘솔에서 선택한 항목 중 사용자가 동의한 값만** 내려와요.
> **2026년 1월 2일부터 `scope` 값에 `user_key` 항목이 추가돼요.**
> 신규 scope 추가로 인해 **기존에 정의되지 않은 값이 포함될 수 있으니,** scope 처리 시 예외가 발생하지 않도록 주의해주세요.

**요청 헤더**

| 이름 | 타입 | 필수값 여부 | 설명 |
|------|------|-------------|------|
| Authorization | string | Y | AccessToken으로 인증 요청 `Authorization: Bearer ${AccessToken}` |

**성공 응답**

| 이름 | 타입 | 필수값 여부 | 암호화 여부 | 설명 |
|------|------|-------------|-------------|------|
| userKey | number | Y | N | 사용자를 식별하기 위한 고유 값이에요. |
| scope | string | Y | N | 인가된 scope 목록이에요. 콘솔에서 선택한 항목 중 사용자가 동의한 값과 `user_key` 항목이 포함돼요. |
| agreedTerms | list | Y | N | 사용자가 동의한 약관 목록이에요. |
| name | string | N | Y | 사용자 이름이에요. |
| phone | string | N | Y | 사용자 휴대전화번호예요. |
| birthday | string | N | Y | 사용자 생년월일이에요.(yyyyMMdd) |
| ci | string | N | Y | 사용자 CI값이에요. |
| di | string | N | Y | 항상 `null` 값으로 내려와요. |
| gender | string | N | Y | 사용자 성별 정보예요.(MALE/FEMALE) |
| nationality | string | N | Y | 사용자 내/외국인 여부예요.(LOCAL/FOREIGNER) |
| email | string | N | Y | 사용자 이메일 정보예요. 점유 인증은 하지 않은 값이에요. |

```json
{
  "resultType": "SUCCESS",
  "success": {
    "userKey": 443731104,
    "scope": "user_ci,user_birthday,user_nationality,user_name,user_phone,user_gender, user_key",
    "agreedTerms": ["terms_tag1", "terms_tag2"],
    "name": "ENCRYPTED_VALUE",
    "phone": "ENCRYPTED_VALUE",
    "birthday": "ENCRYPTED_VALUE",
    "ci": "ENCRYPTED_VALUE",
    "di": null,
    "gender": "ENCRYPTED_VALUE",
    "nationality": "ENCRYPTED_VALUE",
    "email": null
  }
}
```

**실패 응답**

유효하지 않은 토큰을 사용할 경우, 현재 사용 중인 access_token의 유효시간을 확인하고 재발급을 진행해주세요.

```json
{
  "error": "invalid_grant"
}
```

**서버 에러 응답 예시**

| errorCode | 설명 |
|-----------|------|
| INTERNAL_ERROR | 내부 서버 에러 |
| USER_KEY_NOT_FOUND | 로그인 서비스에 접속한 유저 키 값을 찾을 수 없음 |
| USER_NOT_FOUND | 토스 유저 정보를 찾을 수 없음 |
| BAD_REQUEST_RETRIEVE_CERT_RESULT_EXCEEDED_LIMIT | 조회 가능 횟수 초과. 동일한 토큰으로 `/api/login/user/me/without-di` API 조회하면 정상적으로 조회되나, di 필드는 null 값으로 내려감 |

```json
{
  "resultType": "FAIL",
  "error": {
    "errorCode": "INTERNAL_ERROR",
    "reason": "요청을 처리하는 도중에 문제가 발생했습니다."
  }
}
```

### 5. 사용자 정보 복호화하기

콘솔을 통해 이메일로 받은 `복호화 키`와 `AAD(Additional Authenticated DATA)` 로 진행해주세요.

**암호화 알고리즘**

- AES 대칭키 암호화
- 키 길이 : 256비트
- 모드 : GCM
- AAD : 복호화 키와 함께 이메일로 전달드려요.

**데이터 교환방식**

- 암호화된 데이터의 앞 부분에는 IV(NONCE)가 포함돼 있어요.
- 복호화 시 암호문에서 IV를 추출해 사용해야 정상적으로 복호화돼요.

**복호화 샘플 코드 - Kotlin**

```kotlin
import java.util.Base64
import javax.crypto.Cipher
import javax.crypto.spec.GCMParameterSpec
import javax.crypto.spec.SecretKeySpec

class Test {
    fun decrypt(
        encryptedText: String,
        base64EncodedAesKey: String,
        add: String,
    ): String {
        val IV_LENGTH = 12
        val decoded = Base64.getDecoder().decode(encryptedText)
        val cipher = Cipher.getInstance("AES/GCM/NoPadding")
        val keyByteArray = Base64.getDecoder().decode(base64EncodedAesKey)
        val key = SecretKeySpec(keyByteArray, "AES")
        val iv = decoded.copyOfRange(0, IV_LENGTH)
        val nonceSpec = GCMParameterSpec(16 * Byte.SIZE_BITS, iv)

        cipher.init(Cipher.DECRYPT_MODE, key, nonceSpec)
        cipher.updateAAD(add.toByteArray())

        return String(cipher.doFinal(decoded, IV_LENGTH, decoded.size - IV_LENGTH))
    }
}
```

**복호화 샘플 코드 - PHP**

```php
<?php

class Test {
    public function decrypt($encryptedText, $base64EncodedAesKey, $add) {
        $IV_LENGTH = 12;
        $decoded = base64_decode($encryptedText);
        $keyByteArray = base64_decode($base64EncodedAesKey);
        $iv = substr($decoded, 0, $IV_LENGTH);
        $ciphertext = substr($decoded, $IV_LENGTH);

        $tag = substr($ciphertext, -16);
        $ciphertext = substr($ciphertext, 0, -16);

        $decrypted = openssl_decrypt(
            $ciphertext,
            'aes-256-gcm',
            $keyByteArray,
            OPENSSL_RAW_DATA,
            $iv,
            $tag,
            $add
        );

        return $decrypted;
    }
}


// 사용 예제
$test = new Test();
$encryptedText = "Encrypted Text"; // Encrypted Text 입력
$base64EncodedAesKey = "Key"; // Key 입력
$add = "TOSS";

$result = $test->decrypt($encryptedText, $base64EncodedAesKey, $add);
echo $result;

?>
```

**복호화 샘플 코드 - Java**

```java
public class Test {
    public String decrypt(
        String encryptedText,
        String base64EncodedAesKey,
        String add
    ) throws Exception {
        final int IV_LENGTH = 12;
        byte[] decoded = Base64.getDecoder().decode(encryptedText);
        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        byte[] keyByteArray = Base64.getDecoder().decode(base64EncodedAesKey);
        SecretKeySpec key = new SecretKeySpec(keyByteArray, "AES");
        byte[] iv = new byte[IV_LENGTH];
        System.arraycopy(decoded, 0, iv, 0, IV_LENGTH);
        GCMParameterSpec nonceSpec = new GCMParameterSpec(16 * Byte.SIZE, iv);

        cipher.init(Cipher.DECRYPT_MODE, key, nonceSpec);
        cipher.updateAAD(add.getBytes());

        byte[] decrypted = cipher.doFinal(decoded, IV_LENGTH, decoded.length - IV_LENGTH);
        return new String(decrypted);
    }
}
```

### 6. 로그인 끊기

발급받은 AccessToken을 더 이상 사용하지 않거나 사용자의 요청으로 토큰을 만료시켜야 할 경우 토큰을 삭제(만료)해주세요.

- Content-type: `application/json`
- Method: `POST`
- URL:
  - accessToken 으로 연결 끊기: `/api-partner/v1/apps-in-toss/user/oauth2/access/remove-by-access-token`
  - userKey 로 연결 끊기: `/api-partner/v1/apps-in-toss/user/oauth2/access/remove-by-user-key`

**AccessToken 으로 로그인 연결 끊기**

```
// 포맷
curl --request POST 'https://apps-in-toss-api.toss.im/api-partner/v1/apps-in-toss/user/oauth2/access/remove-by-access-token' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer $access_token'

// 예시
curl --request POST 'https://apps-in-toss-api.toss.im/api-partner/v1/apps-in-toss/user/oauth2/access/remove-by-access-token' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer eyJraWQiOiJjZXJ0IizzYWxnIjoiUlMyNTYifQ.eyJzdWIiOiJtMHVmMmhaUmpJTnNEQTdLNHVuVHhMb3IwcWNSa2JNPSIsImF1ZCI6IjNlenQ2ZTF0aDg2b2RheTlwOWN1eTg0dTRvdm5nNnNzIiwibmJmIjoxNzE4MjU0ODM2LCJzY29wZSI6WyJ1c2VyX2NpIiwidXNlcl9iaXJ0aGRheSIsInVzZXJfbmF0aW9uYWxpdHkiLCJ1c2VyX25hbWUiLCJ1c2VyX3Bob25lIiwidXNlcl9nZW5kZXIiXSwiaXNzIjoiaHR0cHM6Ly9jZXJ0LnRvc3MuaW0iLCJleHAiOjE3MTgyNTg0MzYsImlhdCI6MTcxODI1NDgzNiwianRpIjoiMTJkYjYwZjYtMjEzYS00NWQ3LTllOTItODBjMzBmY2JkMGQ3In0.W1cjoeMN8pd3Jqgh6h8YzSVQ1PUNldulJJgy6bgH1AoDbv5xFTlBLwk9Slb_u52zUpyZbhglwblQmNJs7GT6-us7XtfxSGxTUY3ORqIhF_PPGQ6soi_Qgsi-hmX165CCAilf8cltSTTuTt8xOiEbLuSTY-cecxo7SkPUonQ_0v4_Ik0kwOiOBuYZyuch3KmlYQZTqsJmxlwJAPB8M9tZTtDpLOv9MEPU35YS7CZyN0l7lwn1EKrDHJdzA5CnstqEdz2I0eREmMgZoG9mSEybgD4NtPmVJos6AJerUGgSmzP_TwwlybVATuGpnAUmH1idaZJ-MHZJhUhR82z4zTn3bw'
```

**userKey 로 로그인 연결 끊기**

> **참고하세요**
> 하나의 userKey에 연결된 AccessToken이 많을 경우 **readTimeout(3초)** 이 발생할 수 있어요.
> 이 경우 요청을 재시도하지 말고, 일정 시간 후 다시 시도해 주세요.

```
// 포맷
curl --request POST 'https://apps-in-toss-api.toss.im/api-partner/v1/apps-in-toss/user/oauth2/access/remove-by-user-key' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer $access_token' \
--data '{"userKey": $user_key}'

// 예시
curl --request POST 'https://apps-in-toss-api.toss.im/api-partner/v1/apps-in-toss/user/oauth2/access/remove-by-user-key' \
--header 'Content-Type: application/json' \
--data '{"userKey": 443731103}'
```

```json
{
  "resultType": "SUCCESS",
  "success": {
    "userKey": 443731103
  }
}
```

### 7. 콜백을 통해 로그인 끊기

사용자가 토스앱 내에서 서비스와의 연결을 해제한 경우 가맹점 서버로 알려드려요.
서비스에서 연결이 끊긴 사용자에 대한 처리가 필요한 경우 활용할 수 있어요.
콜백을 받을 URL과 basic Auth 헤더는 콘솔에서 입력할 수 있어요.

> **꼭 확인해 주세요**
> 서비스에서 직접 로그인 연결 끊기 API를 호출한 경우에는 **콜백이 호출되지 않아요.**

**GET 방식**

요청 requestParam에 `userKey`와 `referrer`을 포함합니다.

```
// 포맷
curl --request GET '$callback_url?userKey=$userKey&referrer=$referrer'

// 예시
curl --request GET '$callback_url?userKey=443731103&referrer=UNLINK'
```

**POST 방식**

요청 body에 `userKey`와 `referrer`을 포함합니다.

```
// 포맷
curl --request POST '$callback_url' \
--header 'Content-Type: application/json' \
--data '{"userKey": $user_key, "referrer": $referrer}'

// 예시
curl --request POST '$callback_url' \
--header 'Content-Type: application/json' \
--data '{"userKey": 443731103, "referrer": "UNLINK"}'
```

referrer 은 연결 끊기 요청 경로예요.

| referrer | 설명 |
|----------|------|
| `UNLINK` | 사용자가 토스앱에서 직접 연결을 끊었을 때 호출돼요. (경로: 토스앱 → 설정 → 인증 및 보안 → 토스로 로그인한 서비스 → '연결 끊기') |
| `WITHDRAWAL_TERMS` | 사용자가 로그인 서비스 약관 동의를 철회할 때 호출돼요. (경로: 토스앱 → 설정 → 법적 정보 및 기타 → 약관 및 개인정보 처리 동의 → 서비스별 동의 내용 : "토스 로그인" → '동의 철회하기') |
| `WITHDRAWAL_TOSS` | 사용자가 토스 회원을 탈퇴할 때 호출돼요. |

### 트러블슈팅

#### 로컬 개발 중 인증 에러가 발생할 때

로컬에서 개발할 때 인증 에러가 발생하는 원인은 주로 두가지예요.

1. 인증 토큰이 만료됨
   기존에 발급받은 인증 토큰이 만료되었을 수 있어요. 새로운 토큰을 발급받아 다시 시도해보세요.

2. 개발자 로그인이 되지 않음
   샌드박스 환경에서 개발자 계정으로 로그인하지 않은 상태일 수 있어요. 샌드박스 앱을 참고해 로그인을 진행한 뒤 다시 시도해보세요.

---

## QA 진행하기

토스 로그인 연동을 마쳤다면 아래 항목을 **꼼꼼히 점검**해 주세요.

| 항목 | 내용 |
|------|------|
| 사전 체크 | 콘솔 계약/설정이 승인 상태인지, 약관 링크가 정상 열리는지 확인해주세요. |
| 최초 로그인 | 인가 코드 수신 → 서버 교환 → 사용자 정보 복호화/저장 후 홈으로 진입되는지 확인해주세요. |
| 재로그인 | 약관 동의 없이 인가 코드를 즉시 수신하고 정상 진입하는지 확인해주세요. |
| 토큰 만료 직전 호출 | 자동 리프레시로 토큰이 갱신되고 재시도가 성공하는지(실패 시 재로그인 요구) 확인해주세요. |
| 로그인 끊기 콜백 | 서버에서 토큰이 즉시 폐기되고, 재진입 시 로그인 요구되는지 확인해주세요. |
|  | 콜백을 수신·검증해 세션을 해제하고 사용자에게 안내 후 재로그인을 유도하는지 확인해주세요. |
| 네트워크 장애 | 지수 백오프/재시도 적용, 사용자 안내 문구 노출, 복구 후 자동 재시도가 성공하는지 확인해주세요. |
