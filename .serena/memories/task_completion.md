# task completion
- For documentation tasks, verify cross-links and section structure against `doc/rules/document-style.md`.
- For compose changes, run `docker compose ... config` on affected files if Docker is available.
- No repo-wide lint/test entrypoint was discovered from root manifests, so validation should be task-specific.