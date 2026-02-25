---
description: "게임 로그인 관련 질문에 사용하세요. 다음 상황에서 트리거됩니다: 게임 로그인 소개 또는 기능 설명 요청, getUserKeyForGame 함수 사용법, 게임 유저 식별 방법(hash), 토스 로그인에서 게임 로그인으로 마이그레이션, 게임 카테고리 미니앱 로그인 구현, 서버 없이 유저 식별, 로그인 이탈률 개선, userKey를 hash로 전환, getIsTossLoginIntegratedService 사용, 게임 로그인 개발 가이드"
---

# 게임 로그인

## 이해하기

게임 로그인은 사용자의 동의 절차 없이도 바로 서비스를 사용할 수 있게 해요.\
이 방식으로 초기 진입 단계에서 발생하는 이탈을 줄여 약 80%의 사용자 이탈을 막는 효과를 기대할 수 있어요.

---

### 게임 로그인이란 무엇인가요

게임 로그인은 별도의 서버를 만들지 않아도, 그리고 사용자 동의 절차 없이도 사용자를 식별할 수 있도록 돕는 기능이에요.

토스 내부 게임 데이터 분석 결과, 약 80퍼센트의 사용자가 로그인 약관 동의 단계에서 이탈하는 것으로 확인됐어요.\
이 과정에서 토스 로그인이 게임 플레이의 진입 장벽으로 작용하고 있었어요.\
이 문제를 해결하기 위해 앱인토스는 게임 안에서의 동의 과정을 제거하고,\
사용자가 즉시 게임을 시작할 수 있도록 게임 로그인 기능을 제공해요.

| **구분** | **토스 로그인** | **게임 로그인** |
| --- | --- | --- |
| 사용 가능 대상 | 모든 제휴사 | 게임 미니앱 전용 |
| 서버 구축 필요 | 필요 | 불필요 |
| 콘솔 설정 | 필요 | 불필요 |
| 유저 동의 | 필요 | 불필요 |
| 프로모션 연동 | 가능 | 가능 |

---

### 게임 로그인을 사용하면 어떤 점이 좋나요

* 서버 간 연동이 필요 없어요.
* 서버 없이도 토스 프로모션 기능을 사용할 수 있어요.
* 로그인 동의 과정이 없어 초기 이탈이 발생하는 지점을 제거할 수 있어요.
* 미니앱 안에서 사용자를 안정적으로 식별할 수 있어요.

---

### 참고해 주세요

* 게임 로그인은 게임 카테고리의 미니앱에서만 제공돼요.
* 비게임 미니앱은 반드시 토스 로그인을 사용해야 해요. 토스 로그인에 대한 자세한 내용은 [가이드 문서](https://developers-apps-in-toss.toss.im/login/intro.html)를 참고해 주세요.

---

## 개발하기

**SDK를 통해 연동해 주세요.**

`getUserKeyForGame` 함수는 게임 미니앱에서 유저를 식별할 수 있는 **고유 키 값**을 반환합니다.\
이 함수를 사용하면 **서버 연동 없이도 토스 로그인과 동일한 수준의 유저 식별**이 가능해요.

반환되는 유저 식별자(`hash`)는 **미니앱별로 고유**하며, **프로모션(토스 포인트)** 기능에서도 함께 사용할 수 있어요.

자세한 내용은 [getUserKeyForGame](https://developers-apps-in-toss.toss.im/bedrock/reference/framework/게임/getUserKeyForGame.md) 페이지를 확인해주세요.

### 주의사항

* 이 함수는 **게임 카테고리 미니앱에서만** 사용할 수 있어요.\
  비게임 카테고리에서 호출하면 오류가 발생해요.
* **SDK 1.4.0 이상 버전, 토스앱 5.232.0 이상 버전**에서 지원돼요.\
  그 이하 버전에서는 `undefined`를 반환해요.
* 모든 유저의 식별자를 안정적으로 확보하기 위해, **토스앱 최소 지원 버전이 5.232.0 버전으로 상향**되었어요.\
  하위 버전에서는 **업데이트 안내 화면**이 표시돼요.
* 게임 유저 식별자는 **게임사 내부 유저 식별용 키**로만 사용되며, 해당 키로 **토스 서버에 직접 요청할 수 없어요.**
* 샌드박스에서는 mock 데이터가 내려가고 있어, QR 코드로 테스트를 부탁드려요.

---

## 토스 로그인 마이그레이션

**토스 로그인(`userKey`)** 을 사용하는 미니앱을 **게임 로그인(`hash`)** 으로 전환하는 방법을 안내해요.

이 문서를 따라 하면, 현재 토스 로그인을 쓰는 유저를 점진적으로 게임 로그인으로 매핑하고,\
모든 유저가 이전되면 토스 로그인 의존성을 완전히 제거할 수 있어요.

### 언제 이 가이드를 사용하나요?

* 기존에 토스 로그인 `userKey` 로 사용자 식별을 하고 있어요.
* 앞으로는 게임 로그인 `hash`값을 표준 식별자로 쓰고 싶어요.
* 토스 로그인 과정에서의 이탈을 줄이고 싶어요.

> 토스 로그인은 약관 동의 과정에서 **이탈율이 높습니다.**\
> 게임 로그인으로 전환하면 사용자 접근성과 전환율을 크게 개선할 수 있어요.

### 핵심 개념

* **게임 로그인 hash**: [`getUserKeyForGame()`](https://developers-apps-in-toss.toss.im/bedrock/reference/framework/게임/getUserKeyForGame.html) 호출로 발급되는 게임용 고유 식별자
* **토스 로그인 userKey**: 기존 토스 로그인 기반 사용자 식별자
* **매핑**: 동일 사용자의 `userKey` 와 `hash` 값을 1:1로 연결한 상태

> 각 게임별로 `hash` 값은 상이합니다.

### 전체 전환 흐름

1. 클라이언트에서 `getUserKeyForGame()` 으로 게임 `hash` 값을 발급받아요.
2. `getIsTossLoginIntegratedService()` 으로 토스 로그인 연동 여부를 확인해요.
3. 파트너사 서버에 매핑 여부를 조회해요.
4. 매핑되지 않았다면 `appLogin()` 을 통해 토스 로그인을 진행하고, `hash` 값을 서버로 전송해요.
5. 서버에서 토스 로그인 `userKey` 와 게임 로그인 `hash` 값을 매핑 테이블에 저장해요.
6. 이후에는 `hash` 값만으로 사용자를 식별할 수 있어요. 모든 유저가 매핑되면 토스 로그인 의존성을 제거하세요.

### 사전 구현이 필요한 API

파트너사는 아래 두 가지 API를 **직접 구현해야 해요.**\
이 API들은 앱인토스에서 제공하지 않으며, 아래 예시를 참고해 파트너사 서버에서 자체적으로 개발해 주세요.

* **매핑 여부 조회**
  * `POST /api/auth/migration/status`
  * **Req**: `{ hash: string }`
  * **Res**: `{ isMapped: boolean }`

* **매핑 생성**
  * `POST /api/auth/migration/link`
  * **Req**: `{  hash: string; authorizationCode: string; referrer?: string }`
  * **Res**: `{ success: true }`

---

### 클라이언트 구현 단계

#### 1. SDK 가져오기

```tsx
import { getUserKeyForGame, getIsTossLoginIntegratedService, appLogin } from '@apps-in-toss/web-framework';
```

#### 2. 게임 hash 값 발급

```tsx
  const result = await getUserKeyForGame();
  if (!result) return console.warn('지원하지 않는 앱 버전이에요.');
  if (result === 'INVALID_CATEGORY') return console.error('게임 카테고리가 아닌 미니앱이에요.');
  if (result === 'ERROR') return console.error('사용자 키 조회 중 오류가 발생했어요.');
  if (result.type !== 'HASH') return console.error('알 수 없는 반환값입니다.');
  const { hash } = result;
```

#### 3. 토스 로그인 연동 여부 확인

```tsx
  const status = await getIsTossLoginIntegratedService();
  if (status === 'INVALID_CLIENT') {
    console.log('토스 로그인이 연동되어 있지 않은 미니앱이에요.');
    return;
  }
```

자세한 내용은 [토스 로그인 연동 확인](https://developers-apps-in-toss.toss.im/bedrock/reference/framework/로그인/getIsTossLoginIntegratedService.md) 문서를 확인해주세요.

#### 4. 파트너사 서버에 매핑 여부 조회 및 매핑

```tsx
  if (status === true) { // 토스 로그인 연동된 유저
    const { isMapped } = await fetch('/api/auth/migration/status', { // 매핑 여부 확인
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ hash }),
    }).then((r) => r.json());

    if (!isMapped) {
      const { authorizationCode, referrer } = await appLogin(); // 미매핑이면 토스 로그인 후 매핑 생성
      await fetch('/api/auth/migration/link', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ authorizationCode, referrer, hash }),
      });
    }

    console.log('매핑 완료 또는 이미 매핑된 사용자에요.');
    return;
  }

  console.log ('토스 로그인 미연동 사용자에요.') // status === false

```

#### 5. 게임 로그인 hash 사용

이제 사용자 식별은 게임 로그인 `hash`값을 기준으로 하면 됩니다.\
토스로그인 `userKey` 대신, `getUserKeyForGame()` 으로 발급받은 게임 `hash`값을 서버와 클라이언트 모두에서 사용자 식별자로 사용하세요.

### 전체 예시 코드

```tsx
import { getUserKeyForGame, getIsTossLoginIntegratedService, appLogin } from '@apps-in-toss/web-framework';

async function migrateIfNeeded() {
  const res = await getUserKeyForGame();
  if (!res) return console.warn('지원하지 않는 앱 버전이에요.');
  if (res === 'INVALID_CATEGORY') return console.error('게임 카테고리가 아닌 미니앱이에요.');
  if (res === 'ERROR') return console.error('사용자 키 조회 중 오류가 발생했어요.');
  if (res.type !== 'HASH') return console.error('알 수 없는 반환값입니다.');
  const { hash } = res;

  let status: boolean;
  try {
    status = await getIsTossLoginIntegratedService();
  } catch (error: any) {
    console.error('토스 로그인 연동 여부 확인 중 오류 발생:', error);
    return;
  }

  if (status === true) {
    // 매핑 여부 조회
    const { isMapped } = await fetch('/api/auth/migration/status', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ hash }),
    }).then((r) => r.json());

    if (!isMapped) {
      // 미매핑이면 토스 로그인 후 매핑 생성
      const { authorizationCode, referrer } = await appLogin();

      await fetch('/api/auth/migration/link', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ authorizationCode, referrer, hash }),
      });
    }

    console.log('매핑 완료 또는 이미 매핑된 사용자입니다.');
    return;
  }

  // status === false : 토스 로그인 기능은 있으나 현재 유저는 미연동
  console.log('토스 로그인 미연동 사용자입니다.');
}

```

### 예외 처리

토스 로그인을 사용하지 않는 미니앱에서\
`getIsTossLoginIntegratedService()`를 호출하면 아래 예외가 발생할 수 있어요.

```tsx
@throw {message: "oauth2ClientId 설정이 필요합니다."}
```

> 이 경우 토스 로그인 기능이 없는 환경이므로 별도 처리가 필요하지 않습니다.
