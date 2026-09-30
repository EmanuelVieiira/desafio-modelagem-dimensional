
-- ---------------------------------------------------------
-- DIM_DEPARTAMENTO (3)
-- ---------------------------------------------------------
INSERT INTO dim_departamento
  (sk_departamento, idDepartamento, nome_departamento, campus, nome_coordenador)
VALUES
  (1, 101, 'Computação',  'Campus Central', 'Ana Souza'),
  (2, 102, 'Matemática',  'Campus Central', 'Carla Mendes'),
  (3, 103, 'Engenharia',  'Campus Norte',   'Fernanda Costa');

-- ---------------------------------------------------------
-- DIM_PROFESSOR (6)
-- ---------------------------------------------------------
INSERT INTO dim_professor
  (sk_professor, idProfessor, nome_professor, titulacao, regime_trabalho, data_admissao, flag_coordenador)
VALUES
  (1, 1001, 'Ana Souza',      'Doutora', 'DE',  '2012-03-01', 'S'),
  (2, 1002, 'Bruno Lima',     'Mestre',  '40h', '2016-08-15', 'N'),
  (3, 1003, 'Carla Mendes',   'Doutora', 'DE',  '2010-02-10', 'S'),
  (4, 1004, 'Daniel Rocha',   'Doutor',  '40h', '2018-02-05', 'N'),
  (5, 1005, 'Eduardo Alves',  'Mestre',  '20h', '2021-08-02', 'N'),
  (6, 1006, 'Fernanda Costa', 'Doutora', 'DE',  '2014-03-03', 'S');

-- ---------------------------------------------------------
-- DIM_DISCIPLINA (6)
-- ---------------------------------------------------------
INSERT INTO dim_disciplina
  (sk_disciplina, idDisciplina, nome_disciplina, carga_horaria_padrao, tem_prerequisito, nome_prerequisito)
VALUES
  (1, 201, 'Algoritmos',           60, 'N', NULL),
  (2, 202, 'Estruturas de Dados',  60, 'S', 'Algoritmos'),
  (3, 203, 'Banco de Dados',       60, 'S', 'Estruturas de Dados'),
  (4, 204, 'Cálculo I',            90, 'N', NULL),
  (5, 205, 'Cálculo II',           90, 'S', 'Cálculo I'),
  (6, 206, 'Física I',             60, 'S', 'Cálculo I');

-- ---------------------------------------------------------
-- DIM_CURSO (4)
-- ---------------------------------------------------------
INSERT INTO dim_curso
  (sk_curso, idCurso, nome_curso, nivel, modalidade, duracao_semestres)
VALUES
  (1, 301, 'Ciência da Computação',     'Graduação', 'Presencial', 8),
  (2, 302, 'Sistemas de Informação',    'Graduação', 'Presencial', 8),
  (3, 303, 'Matemática (Licenciatura)', 'Graduação', 'Presencial', 8),
  (4, 304, 'Engenharia Civil',          'Graduação', 'Presencial', 10);

-- ---------------------------------------------------------
-- FATO_PROFESSOR_OFERTA (11 linhas)
-- colunas: prof, depto, disc, curso, data_ini, data_fim, qtd, carga, qtd_prereq
-- ---------------------------------------------------------
INSERT INTO fato_professor_oferta
  (sk_professor, sk_departamento, sk_disciplina, sk_curso,
   sk_data_oferta, sk_data_fim_oferta,
   qtd_disciplinas, carga_horaria, qtd_prerequisitos)
VALUES
  -- 2025/1
  (1, 1, 1, 1, 20250203, 20250628, 1, 60, 0),
  (6, 3, 6, 4, 20250203, 20250628, 1, 60, 1),
  -- 2026/1
  (1, 1, 1, 1, 20260202, 20260627, 1, 60, 0),
  (1, 1, 1, 2, 20260202, 20260627, 1, 60, 0),
  (2, 1, 2, 1, 20260202, 20260627, 1, 60, 1),
  (3, 2, 4, 3, 20260202, 20260627, 1, 90, 0),
  (3, 2, 4, 4, 20260202, 20260627, 1, 90, 0),
  -- 2026/2
  (2, 1, 3, 2, 20260803, 20261127, 1, 60, 1),
  (4, 2, 5, 3, 20260803, 20261127, 1, 90, 1),
  (4, 2, 5, 4, 20260803, 20261127, 1, 90, 1),
  (5, 3, 6, 4, 20260803, 20261127, 1, 60, 1);

-- ---------------------------------------------------------
-- Conferência
-- Esperado: 3, 6, 6, 4, 4018 e 11
-- ---------------------------------------------------------
SELECT 'dim_departamento' AS tabela, COUNT(*) AS linhas FROM dim_departamento
UNION ALL SELECT 'dim_professor',  COUNT(*) FROM dim_professor
UNION ALL SELECT 'dim_disciplina', COUNT(*) FROM dim_disciplina
UNION ALL SELECT 'dim_curso',      COUNT(*) FROM dim_curso
UNION ALL SELECT 'dim_data',       COUNT(*) FROM dim_data
UNION ALL SELECT 'fato',           COUNT(*) FROM fato_professor_oferta;
