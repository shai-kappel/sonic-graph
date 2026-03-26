# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.x.x   | :white_check_mark: |

## Reporting a Vulnerability

If you discover a security vulnerability in SonicGraph, please report it responsibly.

### How to Report

1. **Do NOT open a public issue** for security vulnerabilities.
2. Email: [security contact — update before going public]
3. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

### Response Timeline

- **Acknowledgment:** Within 48 hours
- **Initial assessment:** Within 1 week
- **Fix timeline:** Depends on severity

### Scope

This policy applies to the SonicGraph application and its direct dependencies.

## Security Measures

This project uses the following automated security tools:

- **Gitleaks** — Secret scanning on every push/PR
- **Trivy** — Dependency vulnerability scanning
- **GitHub Dependabot** — Automated dependency updates
- **OpenSSF Scorecard** — Security best practices audit
- **GitHub Secret Scanning** — Native GitHub secret detection (enabled for public repos)
