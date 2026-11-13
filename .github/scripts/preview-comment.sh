#!/usr/bin/env bash
# Builds the Markdown comment posted on a pull request once its preview is
# deployed, linking to the articles the PR touches rather than to the home page.
#
# Usage: preview-comment.sh PREVIEW_URL DIST_DIR EXPIRES < changed-paths
#   PREVIEW_URL  root URL of the Firebase preview channel
#   DIST_DIR     the shell's build output, used to tell published posts from drafts
#   EXPIRES      expiry date of the channel, printed as is
#   stdin        paths changed by the PR, one per line, relative to this repo
#
# Run from the root of the content repository. Articles are served at
# /<slug>/, the slug being read from the frontmatter (see the shell's
# src/pages/[...slug].astro). Drafts are not built, so they get no link.
set -euo pipefail

if [ "$#" -ne 3 ]; then
  echo "usage: $0 PREVIEW_URL DIST_DIR EXPIRES < changed-paths" >&2
  exit 2
fi

url="${1%/}"
dist="$2"
expires="$3"

# First `slug:` line of the frontmatter, without CR, a trailing `# comment`,
# spaces or one pair of quotes.
read_slug() {
  awk 'NR == 1 && /^---/ { inside = 1; next }
       inside && /^---/ { exit }
       inside && /^slug:/ { sub(/^slug:/, ""); print; exit }' "$1" |
    tr -d '\r' |
    sed -E "s/[[:space:]]+#.*\$//; s/^[[:space:]]+//; s/[[:space:]]+\$//; s/^\"(.*)\"\$/\\1/; s/^'(.*)'\$/\\1/"
}

lines=()
while IFS= read -r folder; do
  [ -f "$folder/index.md" ] || continue
  slug="$(read_slug "$folder/index.md")"
  [ -n "$slug" ] || continue
  if [ -f "$dist/$slug/index.html" ]; then
    lines+=("- [/$slug/]($url/$slug/) (\`$folder\`)")
  else
    lines+=("- \`/$slug/\` : brouillon, non publié (\`$folder\`)")
  fi
done < <(tr -d '\r' | grep -E '^blog/[^/]+/[^/]+/' | cut -d/ -f1-3 | sort -u || true)

echo "<!-- zats-blog-preview -->"
echo "### Aperçu de la PR"
echo
if [ "${#lines[@]}" -eq 0 ]; then
  echo "Aucun article modifié dans cette PR."
else
  printf '%s\n' "${lines[@]}"
fi
echo
echo "[Accueil de l'aperçu]($url/)"
echo
echo "<sub>Expire le $expires</sub>"
