# CATS Testing

CATS validates the deployed QA API after deployment.

## Recommended Position In Pipeline

Run CATS after:

1. artifact is deployed
2. systemd service restart succeeds
3. health check succeeds

## Reports

Generated CATS reports may be published to GitHub Pages if they are useful for thesis presentation and debugging.

Do not publish sensitive payloads or secrets in public reports.

