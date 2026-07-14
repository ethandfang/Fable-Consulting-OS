#!/usr/bin/env bash
# After agent sessions, commit and push site changes so GitHub Pages updates.
set -euo pipefail

root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
[[ -n "$root" ]] || exit 0
cd "$root"

site_paths=(index.html assets)
changed=false

for path in "${site_paths[@]}"; do
  if git status --porcelain -- "$path" | grep -q .; then
    changed=true
    break
  fi
done

if $changed; then
  git add "${site_paths[@]}"
  git commit -m "Update site for GitHub Pages"
fi

if git rev-parse --verify origin/main >/dev/null 2>&1; then
  ahead="$(git rev-list --count origin/main..HEAD 2>/dev/null || echo 0)"
  if [[ "$ahead" -gt 0 ]]; then
    git push origin main
  fi
fi

exit 0
