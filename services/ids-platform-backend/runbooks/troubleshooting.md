# IDS Platform Backend Troubleshooting

## Check Service Status

```bash
sudo systemctl status ids-platform-backend
```

## Follow Logs

```bash
sudo journalctl -u ids-platform-backend -f
```

## Check Active Release

```bash
readlink -f /opt/ids-platform/ids-platform-backend/current
```

## Check Reverse Proxy

```bash
sudo nginx -t
sudo systemctl status nginx
```

## Common Failure Areas

- missing or incorrect `/opt/ids-platform/ids-platform-backend/shared/ids-platform-backend.env`
- Java not installed on the QA server
- artifact missing from the active release directory
- service user does not have permission to read files
- reverse proxy points to the wrong local port
- health endpoint path changed in the backend

