#!/usr/bin/env bash
# Sincroniza playbooks y componentes del repo con los skills instalados globalmente.
# Convención: carpetas que empiezan con _ son drafts y se saltean.
# Uso: bash tools/sync-skills.sh

set -e

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
INSTALLED=0
SKIPPED=0

sync_dir() {
  local base_dir="$1"
  if [ ! -d "$base_dir" ]; then return; fi

  for skill_dir in "$base_dir"/*/; do
    local name
    name="$(basename "$skill_dir")"

    if [[ "$name" == _* ]]; then
      echo "  skip  $name  (draft)"
      SKIPPED=$((SKIPPED + 1))
      continue
    fi

    if [ ! -f "$skill_dir/SKILL.md" ]; then
      echo "  skip  $name  (sin SKILL.md)"
      SKIPPED=$((SKIPPED + 1))
      continue
    fi

    npx skills add "$skill_dir" -g -y > /dev/null 2>&1
    echo "  sync  $name"
    INSTALLED=$((INSTALLED + 1))
  done
}

echo "Sincronizando skills..."
sync_dir "$REPO_ROOT/skills/playbooks"
sync_dir "$REPO_ROOT/skills/components"

echo ""
echo "Listo: $INSTALLED sincronizados, $SKIPPED salteados."
