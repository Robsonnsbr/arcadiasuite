# Deploy no Coolify - ArcadiaSuite

## Arquivo de compose
Use `docker-compose.yml` (produção).

## Variáveis obrigatórias (Coolify Environment)
- `SESSION_SECRET`
- `DATABASE_URL`
- `PGHOST`, `PGPORT`, `PGUSER`, `PGPASSWORD`, `PGDATABASE`
- `POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_DB`
- `OPENAI_API_KEY` e/ou `AI_INTEGRATIONS_OPENAI_API_KEY` (se usar recursos de IA)
- `PLUS_BASE_URL`, `PLUS_HOST`, `PLUS_PORT` (se integrar com ControlPLUS em outro projeto)

Base sugerida: `.env.production.example`.

## Passos
1. Crie um recurso Docker Compose no Coolify apontando para este repositório/pasta.
2. Selecione `docker-compose.yml`.
3. Configure as variáveis no painel do Coolify.
4. Faça deploy.
5. Valide healthcheck em `GET /api/health`.

Se Arcadia e ControlPLUS estiverem em projetos isolados no Coolify, configure `PLUS_BASE_URL` com a URL pública do ControlPLUS (ex.: `https://controlplus.seudominio.com`).

## Desenvolvimento local
Para manter comportamento de desenvolvimento:
```bash
docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d --build
```
