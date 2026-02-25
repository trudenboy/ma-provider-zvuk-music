---
title: Contributing
description: How to contribute to the Zvuk Music provider for Music Assistant
---

Thank you for your interest in contributing to **Zvuk Music**!

## Code of Conduct

Be respectful, inclusive, and professional. We follow the standard open source code of conduct.

## Reporting Bugs

Open a GitHub Issue with:
- Detailed description of the problem
- Steps to reproduce
- Expected vs actual behavior
- Environment details (MA version, provider version)
- Logs from the MA server

## Suggesting Features

Open a GitHub Issue explaining:
- The use case and problem it solves
- Your proposed solution
- Alternative approaches you considered
- Whether you are willing to implement it

## Pull Requests

1. Fork and clone the repository
2. Create a feature branch: `git checkout -b feature/your-feature-name`
3. Make your changes following the [coding standards](/ma-provider-zvuk-music/en/development/#code-quality)
4. Write or update tests (see [Development → Running Tests](/ma-provider-zvuk-music/en/development/#running-tests))
5. Ensure CI passes: `pre-commit run --all-files`
6. Update documentation if your change affects behavior or configuration
7. Push to your fork and open a PR against `dev`

PR description should include:
- What changed and why
- How to test it (manual steps or test names)
- Any gotchas or follow-up work

## License

By contributing, you agree that your contributions will be licensed under the Apache 2.0 License.

## Further Reading

- [Testing Guide](/ma-provider-zvuk-music/en/testing/) — running tests locally, CI pipeline, coverage
- [Incident Management](/ma-provider-zvuk-music/en/incident-management/) — labels, issue automation, Copilot triage
- [Docker Dev Environment](/ma-provider-zvuk-music/en/dev-docker/) — run MA + provider locally
- [Development Guide](/ma-provider-zvuk-music/en/development/) — dev setup, tooling, code quality standards
