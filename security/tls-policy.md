# TLS Policy

Exposed QA and production services should use HTTPS.

Recommended:

- terminate TLS at Nginx
- redirect HTTP to HTTPS
- keep backend services bound to localhost
- renew certificates automatically

