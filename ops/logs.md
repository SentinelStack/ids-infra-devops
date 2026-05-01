# Logs

## Backend API

Systemd service logs:

```bash
sudo journalctl -u backend-api -f
```

Recent logs:

```bash
sudo journalctl -u backend-api -n 200 --no-pager
```

## Nginx

```bash
sudo tail -f /var/log/nginx/backend-api.qa.access.log
sudo tail -f /var/log/nginx/backend-api.qa.error.log
```

