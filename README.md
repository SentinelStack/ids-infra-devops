# Sentinel Shared DevOps Config

Acest repository este locul central pentru setari reutilizabile folosite de repo-urile proiectului Sentinel IDS/IPS.

Nu este gandit ca un repo de documentatie operationala lunga. Rolul lui este sa ofere configuratii si workflows pe care celelalte repo-uri le pot importa.

## Ce Tine Aici

```text
.github/workflows/        # GitHub Actions reutilizabile
.github/actions/          # Composite actions reutilizabile (inclusiv Vault)
config/maven/             # Maven/Nexus settings templates
config/quality/           # Checkstyle, PMD, SpotBugs config
config/services/          # Config per-serviciu (application.yml, env, systemd, nginx, vault.manifest)
config/vault/             # Politici, layout path-uri si seed-uri Vault (fara secrete reale)
config/openwrt-agent/     # Template-uri shared pentru edge agent OpenWrt
scripts/                  # render-env-from-vault.sh si utilitare
examples/github-actions/  # Exemple scurte de import
```

## Ce Nu Tine Aici

```text
cod sursa aplicatie
teste de business
pom.xml principal al aplicatiei
secrete reale
artefacte build-uite
documentatie lunga de flow
```

## Logica

Repo-urile aplicatiei importa setari de aici.

Exemplu:

```yaml
jobs:
  quality:
    uses: SentinelStack/ids-infra-devops/.github/workflows/reusable-maven-quality.yml@main
    with:
      java_version: "21"
```

Pentru deploy generic de JAR peste SSH:

```yaml
jobs:
  deploy-qa:
    uses: SentinelStack/ids-infra-devops/.github/workflows/reusable-ssh-jar-deploy.yml@main
    with:
      service_name: ids-platform-backend
      deploy_path: /opt/ids-platform-backend
      artifact_name: backend-jar
    secrets:
      ssh_host: ${{ secrets.QA_SSH_HOST }}
      ssh_user: ${{ secrets.QA_SSH_USER }}
      ssh_private_key: ${{ secrets.QA_SSH_PRIVATE_KEY }}
```

## Repo-uri Care Pot Consuma Aceste Setari

```text
ids-platform-backend
ids-api-contract
viitor frontend
viitor edge-agent
viitoare servicii AI / workers
```

## Configuratii Servicii + Vault

Configuratiile per-serviciu stau centralizat aici. Secretele NU stau aici — vin
din HashiCorp Vault si sunt randate la deploy intr-un EnvironmentFile.

Structura per serviciu:

```text
config/services/<service>/
  application.yml          # config non-secret (placeholders ${ENV})
  vault.manifest.yml       # ce chei sunt secrete + path-ul lor in Vault
  env/<service>.env.example  # default-uri non-secret
  systemd/  nginx/         # unit + reverse proxy
config/vault/
  policies/<service>.hcl   # politica read per serviciu
  paths.md                 # layout secrete: secret/sentinel/<service>/<env>
  seed/<service>.*.example.json  # forma secretului (fara valori reale)
scripts/render-env-from-vault.sh # vault kv get -> EnvironmentFile (0600)
.github/actions/load-secrets-from-vault/  # composite action pentru CI/deploy
```

Flow deploy (deploy-time env render):

1. `application.yml` (non-secret) este copiat pe host si stratificat peste jar
   prin `--spring.config.additional-location`.
2. `render-env-from-vault.sh <service> <env> <out>` citeste `vault.manifest.yml`,
   trage secretele din `secret/sentinel/<service>/<env>` si scrie EnvironmentFile-ul.
3. systemd incarca EnvironmentFile-ul (`MONGODB_URI` etc.) si porneste serviciul.

Aplicatia ramane neschimbata: citeste totul din variabile de mediu / config extern.

## Regula Simpla

Repo-ul aplicatiei contine codul si decide cand ruleaza pipeline-ul.

Acest repo contine setari comune, workflow-uri reutilizabile si templates pe care repo-ul aplicatiei le importa.
