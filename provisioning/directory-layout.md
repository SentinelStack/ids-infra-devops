# Directory Layout

Recommended server layout:

```text
/opt/ids-platform/
├── backend-api/
│   ├── releases/
│   ├── current
│   ├── shared/
│   └── logs/
└── future-service/
    ├── releases/
    ├── current
    ├── shared/
    └── logs/
```

This layout supports simple release switching and rollback.

