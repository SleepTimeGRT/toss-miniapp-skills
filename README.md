# 토스 미니앱 개발 가이드 Skills

토스 미니앱(Apps in Toss) 개발에 필요한 전체 라이프사이클을 지원하는 AI 에이전트 스킬 모음입니다.

온보딩부터 디자인, 개발, 결제, 광고, 배포까지 — 미니앱 개발 중 궁금한 것을 AI에게 물어보세요.

## 포함된 스킬

| 스킬 | 설명 |
|------|------|
| `toss-miniapp-onboarding` | 앱인토스 소개, 콘솔 설정, 앱 등록 |
| `toss-miniapp-design` | 디자인 가이드라인, TDS(Toss Design System) |
| `toss-miniapp-dev-tutorial` | React Native / WebView / Unity 개발 튜토리얼 |
| `toss-miniapp-toss-login` | 토스 로그인 연동 |
| `toss-miniapp-game-login` | 게임 로그인 (서버 없이 유저 식별) |
| `toss-miniapp-tosspay` | 토스페이 결제 연동 |
| `toss-miniapp-iap` | 인앱결제(IAP) 구현 |
| `toss-miniapp-ads` | 전면 광고 / 리워드 광고 |
| `toss-miniapp-server-integration` | 서버 연동 및 API 통신 |
| `toss-miniapp-testing-deploy` | 샌드박스 테스트, 빌드, 배포 |
| `toss-miniapp-code-patterns` | SDK 기능별 코드 예제 레퍼런스 (GitHub 예제 동적 조회) |
| `toss-miniapp-docs-live` | 공식 문서 실시간 검색 (Playwright, 항상 최신) |

## 설치 방법

### Claude Code

```bash
claude plugin add SleepTimeGRT/toss-miniapp-skills
```

설치 후 대화에서 바로 사용할 수 있습니다:

```
> 미니앱에서 카메라 기능을 어떻게 구현하나요?
> 인앱결제 연동 방법 알려줘
> 토스 로그인 구현 코드 보여줘
```

### Gemini CLI

`SKILL.md` 포맷이 호환되므로 스킬 디렉토리에 복사하면 바로 사용할 수 있습니다:

```bash
# 프로젝트 단위 설치
git clone https://github.com/SleepTimeGRT/toss-miniapp-skills.git /tmp/toss-skills
cp -r /tmp/toss-skills/skills/* .gemini/skills/
```

```bash
# 글로벌 설치 (모든 프로젝트에서 사용)
cp -r /tmp/toss-skills/skills/* ~/.gemini/skills/
```

> `.agents/skills/` 경로도 동일하게 지원됩니다.

설치 후 Gemini가 요청에 맞는 스킬을 자동으로 감지하고 `activate_skill`로 로딩합니다.

### Codex

[skill-installer](https://github.com/anthropics/skill-installer)를 통해 설치합니다:

```
$skill-installer
```

프롬프트에서 아래 명령을 입력하세요:

```
install GitHub repo SleepTimeGRT/toss-miniapp-skills
```

### Cursor

프로젝트 루트에 `.cursor/rules/` 디렉토리를 만들고 스킬 파일을 복사합니다:

```bash
mkdir -p .cursor/rules
# 원하는 스킬을 개별 다운로드
curl -o .cursor/rules/toss-miniapp-code-patterns.md \
  https://raw.githubusercontent.com/SleepTimeGRT/toss-miniapp-skills/main/skills/toss-miniapp-code-patterns/SKILL.md
curl -o .cursor/rules/toss-miniapp-dev-tutorial.md \
  https://raw.githubusercontent.com/SleepTimeGRT/toss-miniapp-skills/main/skills/toss-miniapp-dev-tutorial/SKILL.md
```

### 기타 LLM / AI 에이전트

스킬 파일을 직접 다운로드하여 컨텍스트로 제공할 수 있습니다.

```bash
# 원하는 스킬 파일을 다운로드
curl -O https://raw.githubusercontent.com/SleepTimeGRT/toss-miniapp-skills/main/skills/toss-miniapp-code-patterns/SKILL.md
```

다운로드한 `.md` 파일을 에이전트의 시스템 프롬프트나 컨텍스트 파일로 추가하세요.

프로젝트의 `CLAUDE.md`, `AGENTS.md`, `GEMINI.md` 등에 참조를 추가할 수도 있습니다:

```markdown
## 참고 자료
- 토스 미니앱 코드 예제: https://github.com/toss/apps-in-toss-examples
- 토스 미니앱 개발 문서: https://developers-apps-in-toss.toss.im
- 토스 미니앱 스킬: https://github.com/SleepTimeGRT/toss-miniapp-skills
```

## 업데이트

이 플러그인은 서드파티 마켓플레이스로 배포되므로, **auto-update가 기본 OFF**입니다.
스킬 내용이 업데이트되면 아래 방법으로 최신 버전을 받으세요.

### Claude Code

**방법 1: 수동 업데이트**

```bash
claude plugin update toss-miniapp
```

**방법 2: auto-update 활성화 (권장)**

```
/plugin → Marketplaces 탭 → 마켓플레이스 선택 → Enable auto-update
```

auto-update를 켜면 세션 시작 시 자동으로 최신 버전을 체크합니다.

**캐시 문제 발생 시**

```bash
rm -rf ~/.claude/plugins/cache
# 이후 재설치
claude plugin add SleepTimeGRT/toss-miniapp-skills
```

### Gemini CLI

```bash
# 최신 버전 다시 복사
git clone https://github.com/SleepTimeGRT/toss-miniapp-skills.git /tmp/toss-skills
cp -r /tmp/toss-skills/skills/* .gemini/skills/
```

### Cursor / 기타

스킬 파일을 다시 다운로드하세요. raw URL은 항상 최신 main 브랜치를 가리킵니다.

> **참고**: `toss-miniapp-docs-live` 스킬은 Playwright로 공식 문서를 실시간 조회하므로,
> 스킬 자체가 업데이트되지 않아도 항상 최신 문서 내용을 가져올 수 있습니다.

## 관련 리소스

- [앱인토스 개발자센터](https://developers-apps-in-toss.toss.im)
- [앱인토스 공식 예제 코드](https://github.com/toss/apps-in-toss-examples)
- [앱인토스 개발자 포럼](https://techchat-apps-in-toss.toss.im)
- [TDS WebView 문서](https://tossmini-docs.toss.im/tds-mobile/)
- [TDS React Native 문서](https://tossmini-docs.toss.im/tds-react-native/)

## 라이선스

MIT
