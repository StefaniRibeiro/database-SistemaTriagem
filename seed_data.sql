-- Dados de exemplo para testar o painel administrativo (Tela 3 do TCC)
USE triagem_saude;

INSERT INTO usuario (nome, login, senha_hash, perfil) VALUES
('Enf. Beatriz Gomes', 'beatriz.gomes', '$2a$11$8kFhYQ2eYQx1p3mZ0m3vHu9sJZmXwZ7rC0z6zqzYQxk9k5t7Q1e6O', 'PROFISSIONAL_SAUDE'),
('Atendente João', 'joao.atendente', '$2a$11$8kFhYQ2eYQx1p3mZ0m3vHu9sJZmXwZ7rC0z6zqzYQxk9k5t7Q1e6O', 'ATENDENTE');

INSERT INTO paciente (cpf, nome, data_nascimento, sexo) VALUES
('45678912300', 'Maria Silva', '1964-03-12', 'F'),
('12345678900', 'João Pereira', '1981-07-01', 'M'),
('98765432100', 'Ana Costa', '1998-11-20', 'F'),
('11122233344', 'Carlos Souza', '1971-02-14', 'M');

INSERT INTO triagem (paciente_id, data_hora, status, prioridade, observacoes, finalizada_em) VALUES
(1, '2026-08-30 14:32:00', 'FINALIZADA', 'URGENTE', 'Dor de cabeça intensa iniciada ontem.', '2026-08-30 14:40:00'),
(2, '2026-08-30 14:18:00', 'EM_ANDAMENTO', 'MUITO_URGENTE', 'Febre há 2 dias, aguardando priorização.', NULL),
(3, '2026-08-30 14:05:00', 'FINALIZADA', 'POUCO_URGENTE', 'Dor abdominal leve.', '2026-08-30 14:12:00'),
(4, '2026-08-30 13:52:00', 'FINALIZADA', 'EMERGENTE', 'Falta de ar relatada.', '2026-08-30 13:58:00');

INSERT INTO sintoma (triagem_id, descricao, intensidade, duracao, discriminador_manchester) VALUES
(1, 'Dor de cabeça', 8, 'desde ontem', 'Dor súbita e intensa'),
(2, 'Febre', 6, '2 dias', 'Febre > 38.5C'),
(3, 'Dor abdominal', 3, 'algumas horas', 'Dor leve, sem sinais de alarme'),
(4, 'Falta de ar', 9, 'início súbito', 'Dificuldade respiratória grave');
