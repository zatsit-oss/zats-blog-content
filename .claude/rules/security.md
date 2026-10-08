# Security

## Secrets & Configuration
- Never commit secrets (API keys, passwords, tokens, .env files), including inside code samples in a post: use obvious placeholders.
- CI secrets (`GH_PAT`, Firebase and GCS service accounts) live in the GitHub settings only.
- Add sensitive files to `.gitignore`.

## Content
- No raw HTML that loads third-party resources (`<script>`, `<iframe>`, remote `<img>`).
- Check external links before publishing; prefer HTTPS.
- Screenshots must not expose personal data, internal URLs, tokens or customer names.

## Repository
- Signed commits only; never force-push or rewrite shared history.
- Workflow changes (`.github/`) are reviewed like code: they hold deploy credentials.
