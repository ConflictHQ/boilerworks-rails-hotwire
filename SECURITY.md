# Security Policy

## Reporting a Vulnerability

If you discover a security vulnerability in Boilerworks, please report it responsibly.

**Do not open a public issue.**

Instead, email **security@weareconflict.com** with:

- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if any)

We will acknowledge your report within 48 hours and aim to release a fix within 7 days for critical issues.

## Supported Versions

| Version | Supported |
| ------- | --------- |
| latest  | Yes       |

## Security Best Practices

When deploying Boilerworks:

- Change all default credentials (database, MinIO, seeded `admin@boilerworks.dev` user)
- Use HTTPS in production and enable `config.force_ssl` in `config/environments/production.rb`
- Set `RAILS_ENV=production` and provide `RAILS_MASTER_KEY` (keep `config/master.key` out of version control)
- Keep dependencies current — CI runs Brakeman, bundler-audit, and `importmap audit` on every push
