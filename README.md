# Database (SQL) for Sistema‑Triagem

> **Objetivo** – Esta pasta contém os scripts SQL que criam e inicializam o banco de dados relacional usado pelo backend do Sistema‑Triagem.

## 📂 Estrutura

```
/database
├─ schema.sql      # Script de criação de tabelas, índices, constraints
├─ seed_data.sql   # Dados de exemplo / dados de seed para ambiente de desenvolvimento
└─ README.md       # Este arquivo (documentação)
```

## 🛠️ Como criar/atualizar o banco

1. **Instale o SGBD** que você pretende usar (por exemplo, PostgreSQL 15 ou MySQL 8).  
2. Crie um banco vazio (ex.: `triagem`).
3. Aplique o **schema**:
   ```bash
   # Exemplo com psql (PostgreSQL)
   psql -U <usuario> -d triagem -f database/schema.sql
   ```
4. (Opcional) Carregue os **dados de seed** para ter dados de teste:
   ```bash
   psql -U <usuario> -d triagem -f database/seed_data.sql
   ```

> **Dica** – Para outros SGBDs, basta adaptar o cliente (`mysql`, `sqlite3`, etc.) e usar os mesmos arquivos; eles contêm SQL padrão‑ANSI.

## 📋 Descrição dos scripts

- **`schema.sql`**
  - Cria tabelas principais: `patients`, `triage_records`, `symptoms`, `users`, `roles`.
  - Define chaves primárias, estrangeiras e índices de busca frequente (ex.: `INDEX idx_patients_cpf ON patients(cpf)`).
  - Inclui triggers simples para auditoria (`created_at`, `updated_at`).
- **`seed_data.sql`**
  - Insere alguns usuários de teste, papéis (`admin`, `operator`), e sintomas comuns.
  - Fornece registros de triagem de exemplo para que a UI mostre resultados imediatamente.

## ⚙️ Integração com o backend

O backend (pasta `back`) usa a URL de conexão definida em `back/.env` (ou variável de ambiente `DATABASE_URL`). Exemplo para PostgreSQL:

```dotenv
DATABASE_URL=postgresql://usuario:senha@localhost:5432/triagem
```

O código Python usa **SQLAlchemy** (ou outro ORM) para mapear as tabelas definidas aqui.

## 🚀 Próximos passos

- **Migrações** – Quando precisar evoluir o schema, adicione scripts de migração em uma subpasta `migrations/` (por exemplo, usando Alembic).  
- **Testes** – Automatize a criação do banco numa fixture de testes (`pytest` + `pytest-postgresql`).
- **Documentação** – Atualize este README sempre que mudar o modelo de dados.

---

*Este README foi gerado para padronizar a configuração e o versionamento do banco de dados SQL do Sistema‑Triagem.*
