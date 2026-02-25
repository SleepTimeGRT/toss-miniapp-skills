#!/bin/bash

missing=()

# GitHub CLI - toss-miniapp-code-patterns 스킬에 필요
if ! command -v gh &> /dev/null; then
  missing+=("gh (GitHub CLI) - 코드 패턴 예제 조회에 필요 → https://cli.github.com")
fi

# GitHub CLI 인증 확인
if command -v gh &> /dev/null; then
  if ! gh auth status &> /dev/null; then
    missing+=("gh auth login - GitHub CLI 인증 필요 → gh auth login 실행")
  fi
fi

if [ ${#missing[@]} -gt 0 ]; then
  echo "[toss-miniapp] 일부 스킬에 필요한 도구가 설치되지 않았습니다:"
  for dep in "${missing[@]}"; do
    echo "  - $dep"
  done
  echo ""
  echo "해당 도구 없이도 다른 스킬은 정상 동작합니다."
fi
