# DNS and HTTPS

## QA Domains

Recommended pattern:

```text
api.qa.example.com
frontend.qa.example.com
reports.qa.example.com
agent-updates.qa.example.com
```

## Production Domains

Recommended pattern:

```text
api.example.com
app.example.com
reports.example.com
agent-updates.example.com
```

## HTTPS

For QA, use HTTPS as soon as the domain is available. This makes testing closer to production and avoids surprises with browser security behavior, cookies, CORS, and API clients.

Recommended setup:

- Nginx as reverse proxy
- Let's Encrypt certificates
- HTTP redirected to HTTPS
- service processes bound to localhost ports

