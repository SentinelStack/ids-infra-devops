# Sentinel Shared DevOps Config

Acest repository este locul central pentru setari reutilizabile folosite de repo-urile proiectului Sentinel IDS/IPS.

Nu este gandit ca un repo de documentatie operationala lunga. Rolul lui este sa ofere configuratii si workflows pe care celelalte repo-uri le pot importa.

## Ce Tine Aici

```text
.github/workflows/        # GitHub Actions reutilizabile
.github/actions/          # Composite actions reutilizabile
config/maven/             # Maven/Nexus settings templates
config/quality/           # Checkstyle, PMD, SpotBugs config
config/services/          # Templates pentru service-uri concrete
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

## Regula Simpla

Repo-ul aplicatiei contine codul si decide cand ruleaza pipeline-ul.

Acest repo contine setari comune, workflow-uri reutilizabile si templates pe care repo-ul aplicatiei le importa.
