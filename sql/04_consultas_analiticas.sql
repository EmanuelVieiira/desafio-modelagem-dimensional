
-- ---------------------------------------------------------
-- 1. Carga horária por departamento e semestre
-- Esperado (7 linhas):
--   2025/1 | Computação | 60      2025/1 | Engenharia | 60
--   2026/1 | Computação | 180     2026/1 | Matemática | 180
--   2026/2 | Computação | 60      2026/2 | Engenharia | 60
--   2026/2 | Matemática | 180
-- ---------------------------------------------------------
SELECT
  d.semestre_letivo,
  dep.nome_departamento,
  COUNT(DISTINCT f.sk_professor) AS professores,
  SUM(f.qtd_disciplinas)         AS ofertas,
  SUM(f.carga_horaria)           AS carga_horaria_total
FROM fato_professor_oferta f
JOIN dim_data         d   ON d.sk_data = f.sk_data_oferta
JOIN dim_departamento dep ON dep.sk_departamento = f.sk_departamento
GROUP BY d.semestre_letivo, dep.nome_departamento
ORDER BY d.semestre_letivo, dep.nome_departamento;

-- ---------------------------------------------------------
-- 2. Quantas disciplinas distintas cada professor ministrou?
-- Esperado:
--   Ana Souza 1 disciplina / 3 ofertas
--   Bruno Lima 2 / 2
--   Carla Mendes 1 / 2
--   Daniel Rocha 1 / 2
--   Eduardo Alves 1 / 1
--   Fernanda Costa 1 / 1
-- ---------------------------------------------------------
SELECT
  p.nome_professor,
  COUNT(DISTINCT f.sk_disciplina) AS disciplinas_distintas,
  COUNT(*)                        AS ofertas
FROM fato_professor_oferta f
JOIN dim_professor p ON p.sk_professor = f.sk_professor
GROUP BY p.nome_professor
ORDER BY ofertas DESC, p.nome_professor;

-- ---------------------------------------------------------
-- 3. Carga horária REAL por professor (sem duplicar)
-- Quando a mesma disciplina é dada a dois cursos no mesmo
-- semestre, a carga aparece duas vezes na fato. Aqui cada
-- combinação professor + disciplina + período conta uma vez.
-- Esperado:
--   Ana Souza 120, Bruno Lima 120, Carla Mendes 90,
--   Daniel Rocha 90, Eduardo Alves 60, Fernanda Costa 60
-- ---------------------------------------------------------
SELECT
  p.nome_professor,
  SUM(t.carga_horaria) AS carga_horaria_real
FROM (
  SELECT DISTINCT
    f.sk_professor,
    f.sk_disciplina,
    f.sk_data_oferta,
    f.carga_horaria
  FROM fato_professor_oferta f
) t
JOIN dim_professor p ON p.sk_professor = t.sk_professor
GROUP BY p.nome_professor
ORDER BY carga_horaria_real DESC, p.nome_professor;

-- ---------------------------------------------------------
-- 4. Quantos cursos cada departamento atende?
-- Esperado: Computação 2, Matemática 2, Engenharia 1
-- ---------------------------------------------------------
SELECT
  dep.nome_departamento,
  dep.campus,
  COUNT(DISTINCT f.sk_curso) AS cursos_atendidos
FROM fato_professor_oferta f
JOIN dim_departamento dep ON dep.sk_departamento = f.sk_departamento
GROUP BY dep.nome_departamento, dep.campus
ORDER BY cursos_atendidos DESC, dep.nome_departamento;

-- ---------------------------------------------------------
-- 5. Professores coordenadores e o que ministram
-- Esperado: 6 linhas (3 de Ana, 2 de Carla, 1 de Fernanda)
-- ---------------------------------------------------------
SELECT
  p.nome_professor,
  dep.nome_departamento,
  c.nome_curso,
  di.nome_disciplina,
  d.semestre_letivo
FROM fato_professor_oferta f
JOIN dim_professor     p   ON p.sk_professor = f.sk_professor
JOIN dim_departamento  dep ON dep.sk_departamento = f.sk_departamento
JOIN dim_curso         c   ON c.sk_curso = f.sk_curso
JOIN dim_disciplina    di  ON di.sk_disciplina = f.sk_disciplina
JOIN dim_data          d   ON d.sk_data = f.sk_data_oferta
WHERE p.flag_coordenador = 'S'
ORDER BY d.semestre_letivo, p.nome_professor;

-- ---------------------------------------------------------
-- 6. Evolução por semestre (ofertas e carga horária)
-- Esperado:
--   2025/1 | 2 ofertas | 2 professores | 120
--   2026/1 | 5 ofertas | 3 professores | 360
--   2026/2 | 4 ofertas | 3 professores | 300
-- ---------------------------------------------------------
SELECT
  d.semestre_letivo,
  COUNT(*)                       AS ofertas,
  COUNT(DISTINCT f.sk_professor) AS professores_ativos,
  SUM(f.carga_horaria)           AS carga_horaria_total
FROM fato_professor_oferta f
JOIN dim_data d ON d.sk_data = f.sk_data_oferta
GROUP BY d.semestre_letivo
ORDER BY d.semestre_letivo;

-- ---------------------------------------------------------
-- 7. Role-playing: dim_data usada duas vezes (início e fim)
-- ---------------------------------------------------------
SELECT
  p.nome_professor,
  di.nome_disciplina,
  ini.data_completa AS inicio,
  fim.data_completa AS fim,
  DATEDIFF(fim.data_completa, ini.data_completa) AS duracao_dias
FROM fato_professor_oferta f
JOIN dim_professor  p   ON p.sk_professor = f.sk_professor
JOIN dim_disciplina di  ON di.sk_disciplina = f.sk_disciplina
JOIN dim_data       ini ON ini.sk_data = f.sk_data_oferta
JOIN dim_data       fim ON fim.sk_data = f.sk_data_fim_oferta
ORDER BY ini.data_completa, p.nome_professor;
