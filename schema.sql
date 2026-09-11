-- ============================================================
-- Sistema de Triagem Inteligente - Schema MySQL
-- Baseado no Diagrama de Classes (item 4.5.2 do TCC)
-- ============================================================

CREATE DATABASE IF NOT EXISTS triagem_saude
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE triagem_saude;

-- ------------------------------------------------------------
-- Tabela: Usuario (Atendentes e Profissionais de Saúde)
-- ------------------------------------------------------------
CREATE TABLE usuario (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    nome            VARCHAR(150)    NOT NULL,
    login           VARCHAR(100)    NOT NULL UNIQUE,
    senha_hash      VARCHAR(255)    NOT NULL,
    perfil          ENUM('ATENDENTE', 'PROFISSIONAL_SAUDE', 'ADMIN') NOT NULL,
    ativo           BOOLEAN         NOT NULL DEFAULT TRUE,
    criado_em       DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Tabela: Paciente (dados recuperados do CADSUS/RNDS)
-- ------------------------------------------------------------
CREATE TABLE paciente (
    id                  INT AUTO_INCREMENT PRIMARY KEY,
    cpf                 VARCHAR(11)     NULL,
    cns                 VARCHAR(15)     NULL,
    nome                VARCHAR(150)    NOT NULL,
    data_nascimento     DATE            NULL,
    sexo                ENUM('M','F','OUTRO') NULL,
    telefone            VARCHAR(20)     NULL,
    criado_em           DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em       DATETIME        NULL ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_paciente_cpf (cpf),
    UNIQUE KEY uq_paciente_cns (cns)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Tabela: Triagem (entidade central do modelo)
-- ------------------------------------------------------------
CREATE TABLE triagem (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id     INT             NOT NULL,
    atendente_id    INT             NULL,          -- preenchido se um atendente operou em nome do paciente
    data_hora       DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status          ENUM('EM_ANDAMENTO', 'FINALIZADA', 'CANCELADA') NOT NULL DEFAULT 'EM_ANDAMENTO',
    prioridade      ENUM('EMERGENTE', 'MUITO_URGENTE', 'URGENTE', 'POUCO_URGENTE', 'NAO_URGENTE') NULL,
    observacoes     TEXT            NULL,
    finalizada_em   DATETIME        NULL,
    CONSTRAINT fk_triagem_paciente FOREIGN KEY (paciente_id) REFERENCES paciente(id),
    CONSTRAINT fk_triagem_atendente FOREIGN KEY (atendente_id) REFERENCES usuario(id)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Tabela: Sintoma (composição de Triagem)
-- ------------------------------------------------------------
CREATE TABLE sintoma (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    triagem_id      INT             NOT NULL,
    descricao       VARCHAR(255)    NOT NULL,
    intensidade     TINYINT         NULL,      -- escala 0-10
    duracao         VARCHAR(100)    NULL,      -- ex: "2 dias", "algumas horas"
    discriminador_manchester VARCHAR(150) NULL, -- discriminador clínico associado (ex: dor torácica, febre alta)
    CONSTRAINT fk_sintoma_triagem FOREIGN KEY (triagem_id) REFERENCES triagem(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Tabela: Mensagem (histórico de conversa do chatbot)
-- ------------------------------------------------------------
CREATE TABLE mensagem (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    triagem_id      INT             NOT NULL,
    origem          ENUM('PACIENTE', 'CHATBOT', 'ATENDENTE') NOT NULL,
    conteudo        TEXT            NOT NULL,
    timestamp       DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_mensagem_triagem FOREIGN KEY (triagem_id) REFERENCES triagem(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Tabela: FluxoAutomacao (rastreabilidade dos disparos n8n)
-- ------------------------------------------------------------
CREATE TABLE fluxo_automacao (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    triagem_id      INT             NOT NULL,
    tipo            ENUM('NOTIFICACAO_FINALIZACAO', 'NOTIFICACAO_PRIORIDADE_ALTA', 'OUTRO') NOT NULL,
    status          ENUM('PENDENTE', 'DISPARADO', 'ERRO') NOT NULL DEFAULT 'PENDENTE',
    payload         JSON            NULL,
    disparado_em    DATETIME        NULL,
    CONSTRAINT fk_fluxo_triagem FOREIGN KEY (triagem_id) REFERENCES triagem(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Índices de apoio às consultas do painel administrativo (RF09/RF10)
CREATE INDEX idx_triagem_status ON triagem(status);
CREATE INDEX idx_triagem_prioridade ON triagem(prioridade);
CREATE INDEX idx_triagem_data ON triagem(data_hora);
CREATE INDEX idx_mensagem_triagem ON mensagem(triagem_id);

-- Usuário administrador inicial (senha: "admin123" — troque em produção)
-- Hash gerado com BCrypt
INSERT INTO usuario (nome, login, senha_hash, perfil)
VALUES ('Administrador', 'admin', '$2a$11$8kFhYQ2eYQx1p3mZ0m3vHu9sJZmXwZ7rC0z6zqzYQxk9k5t7Q1e6O', 'ADMIN');
