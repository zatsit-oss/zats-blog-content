#!/usr/bin/env bash
# Tests for preview-comment.sh. Plain bash, no test framework needed:
#   .github/scripts/preview-comment.test.sh
set -uo pipefail

SCRIPT="$(cd "$(dirname "$0")" && pwd)/preview-comment.sh"
URL="https://x.web.app"
EXPIRES="Fri, 04 Dec 2026 20:43:36 GMT"
failures=0

# Creates a fresh fixture repo and cd into it.
fixture() {
  FIX="$(mktemp -d)"
  mkdir -p "$FIX/dist"
  cd "$FIX" || exit 1
}

# post <category/folder> <slug line> [published]
post() {
  mkdir -p "blog/$1"
  printf -- '---\n%s\ntitle: Titre\nauthors: [jdoe]\ntags: ["x"]\n---\n\nTexte.\n' "$2" > "blog/$1/index.md"
}

# publish <slug>: the shell built a page for this slug.
publish() {
  mkdir -p "dist/$1"
  touch "dist/$1/index.html"
}

run() {
  OUT="$(printf '%s\n' "$@" | "$SCRIPT" "$URL" dist "$EXPIRES")"
}

check() {
  local name="$1"; shift
  if "$@"; then
    echo "ok   $name"
  else
    echo "FAIL $name"
    while IFS= read -r line; do echo "     | $line"; done <<<"$OUT"
    failures=$((failures + 1))
  fi
}

has() { grep -qF -- "$1" <<<"$OUT"; }
lacks() { ! grep -qF -- "$1" <<<"$OUT"; }
bullets() { [ "$(grep -c '^- ' <<<"$OUT")" -eq "$1" ]; }

test_new_post() {
  fixture
  post architecture/2026-11-01-arazzo-maestro "slug: arazzo-maestro"
  publish arazzo-maestro
  run blog/architecture/2026-11-01-arazzo-maestro/index.md
  has "[/arazzo-maestro/](https://x.web.app/arazzo-maestro/)" && bullets 1
}

test_quoted_slug_and_crlf() {
  fixture
  post dev/2024-01-01-openrewrite $'slug: "openrewrite"\r'
  publish openrewrite
  run blog/dev/2024-01-01-openrewrite/index.md
  has "(https://x.web.app/openrewrite/)" && lacks $'\r' && lacks '"'
}

test_slug_inline_comment() {
  fixture
  post dev/2026-01-01-c "slug: c # SEO"
  publish c
  run blog/dev/2026-01-01-c/index.md
  has "[/c/](https://x.web.app/c/)" && lacks "brouillon"
}

test_trailing_slash_url() {
  fixture
  post dev/2024-01-01-a "slug: a"
  publish a
  OUT="$(echo blog/dev/2024-01-01-a/index.md | "$SCRIPT" "$URL/" dist "$EXPIRES")"
  has "(https://x.web.app/a/)" && lacks "app//"
}

test_draft() {
  fixture
  post dev/2026-11-10-mon-brouillon "slug: mon-brouillon"
  run blog/dev/2026-11-10-mon-brouillon/index.md
  has "\`/mon-brouillon/\` : brouillon, non publié" && lacks "(https://x.web.app/mon-brouillon/)"
}

test_dedup_and_images() {
  fixture
  post dev/2026-01-01-a "slug: a"
  post web/2026-01-02-b "slug: b"
  publish a
  publish b
  run blog/dev/2026-01-01-a/index.md blog/dev/2026-01-01-a/schema.webp blog/web/2026-01-02-b/index.md
  bullets 2
}

test_deleted_post() {
  fixture
  run blog/dev/2025-01-01-gone/index.md
  lacks "gone" && has "Aucun article modifié dans cette PR."
}

test_no_post() {
  fixture
  run authors/authors.yml config.json
  has "Aucun article modifié dans cette PR." && has "[Accueil de l'aperçu](https://x.web.app/)" && bullets 0
}

test_marker_and_expiry() {
  fixture
  run config.json
  [ "$(head -n1 <<<"$OUT")" = "<!-- zats-blog-preview -->" ] && has "<sub>Expire le $EXPIRES</sub>"
}

test_missing_args() {
  fixture
  OUT="$("$SCRIPT" </dev/null 2>&1)"
  [ $? -eq 2 ]
}

for t in test_new_post test_quoted_slug_and_crlf test_slug_inline_comment test_trailing_slash_url test_draft \
  test_dedup_and_images test_deleted_post test_no_post test_marker_and_expiry test_missing_args; do
  OUT=""
  check "$t" "$t"
done

[ "$failures" -eq 0 ]
