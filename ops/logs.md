# Logs

## IDS Platform Backend

Systemd service logs:

```bash
sudo journalctl -u ids-platform-backend -f
```

Recent logs:

```bash
sudo journalctl -u ids-platform-backend -n 200 --no-pager
```

## Nginx

```bash
sudo tail -f /var/log/nginx/ids-platform-backend.qa.access.log
sudo tail -f /var/log/nginx/ids-platform-backend.qa.error.log
```

