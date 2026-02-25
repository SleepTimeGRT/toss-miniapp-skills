# 토스 미니앱 개발 가이드 Skills

토스 미니앱(Apps in Toss) 개발에 필요한 전체 라이프사이클을 지원하는 AI 에이전트 스킬 모음입니다.

온보딩부터 디자인, 개발, 결제, 광고, 배포까지 — 미니앱 개발 중 궁금한 것을 AI에게 물어보세요.

## 포함된 스킬

| 스킬 | 설명 |
|------|------|
| `toss-miniapp-onboarding` | 앱인토스 소개, 콘솔 설정, 앱 등록 |
| `toss-miniapp-design` | 디자인 가이드라인, TDS(Toss Design System) |
| `toss-miniapp-dev-tutorial` | React Native / WebView / Unity 개발 튜토리얼 |
| `toss-miniapp-code-patterns` | SDK 기능별 코드 예제 레퍼런스 (GitHub 예제 연동) |
| `toss-miniapp-toss-login` | 토스 로그인 연동 |
| `toss-miniapp-game-login` | 게임 로그인 (서버 없이 유저 식별) |
| `toss-miniapp-tosspay` | 토스페이 결제 연동 |
| `toss-miniapp-iap` | 인앱결제(IAP) 구현 |
| `toss-miniapp-ads` | 전면 광고 / 리워드 광고 |
| `toss-miniapp-server-integration` | 서버 연동 및 API 통신 |
| `toss-miniapp-testing-deploy` | 샌드박스 테스트, 빌드, 배포 |

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

### Codex

[skill-installer](https://github.com/anthropics/skill-installer)를 통해 설치합니다:

```
$skill-installer
```

프롬프트에서 아래 명령을 입력하세요:

```
install GitHub repo SleepTimeGRT/toss-miniapp-skills
```

### 기타 LLM / AI 에이전트

스킬 파일을 직접 다운로드하여 컨텍스트로 제공할 수 있습니다.

**방법 1: 전체 스킬을 시스템 프롬프트에 포함**

```bash
# 원하는 스킬 파일을 다운로드
curl -O https://raw.githubusercontent.com/SleepTimeGRT/toss-miniapp-skills/main/skills/toss-miniapp-code-patterns/SKILL.md
```

다운로드한 `.md` 파일을 에이전트의 시스템 프롬프트나 컨텍스트 파일로 추가하세요.

**방법 2: Cursor에서 사용**

프로젝트 루트에 `.cursor/rules/` 디렉토리를 만들고 스킬 파일을 복사합니다:

```bash
mkdir -p .cursor/rules
curl -o .cursor/rules/toss-miniapp.md \
  https://raw.githubusercontent.com/SleepTimeGRT/toss-miniapp-skills/main/skills/toss-miniapp-code-patterns/SKILL.md
```

**방법 3: CLAUDE.md / AGENTS.md에 참조 추가**

프로젝트의 `CLAUDE.md`나 에이전트 설정 파일에 아래 내용을 추가하세요:

```markdown
## 참고 자료
- 토스 미니앱 코드 예제: https://github.com/toss/apps-in-toss-examples
- 토스 미니앱 개발 문서: https://developers-apps-in-toss.toss.im
- 토스 미니앱 스킬: https://github.com/SleepTimeGRT/toss-miniapp-skills
```

## 관련 리소스

- [앱인토스 개발자센터](https://developers-apps-in-toss.toss.im)
- [앱인토스 공식 예제 코드](https://github.com/toss/apps-in-toss-examples)
- [앱인토스 개발자 포럼](https://techchat-apps-in-toss.toss.im)
- [TDS WebView 문서](https://tossmini-docs.toss.im/tds-mobile/)
- [TDS React Native 문서](https://tossmini-docs.toss.im/tds-react-native/)

## 라이선스

MIT
