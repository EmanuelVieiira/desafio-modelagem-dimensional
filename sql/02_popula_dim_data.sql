
INSERT INTO dim_data
  (sk_data, data_completa, dia, dia_semana, mes, nome_mes,
   bimestre, trimestre, semestre, ano, semestre_letivo, flag_periodo_letivo)
WITH RECURSIVE calendario AS (
  SELECT DATE('2020-01-01') AS dt
  UNION ALL
  SELECT DATE_ADD(dt, INTERVAL 1 DAY)
  FROM calendario
  WHERE dt < '2030-12-31'
)
SELECT
  CAST(DATE_FORMAT(dt, '%Y%m%d') AS UNSIGNED)              AS sk_data,
  dt                                                        AS data_completa,
  DAY(dt)                                                   AS dia,
  ELT(DAYOFWEEK(dt), 'Domingo', 'Segunda-feira', 'Terça-feira',
      'Quarta-feira', 'Quinta-feira', 'Sexta-feira', 'Sábado') AS dia_semana,
  MONTH(dt)                                                 AS mes,
  ELT(MONTH(dt), 'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro') AS nome_mes,
  CEIL(MONTH(dt) / 2)                                       AS bimestre,
  QUARTER(dt)                                               AS trimestre,
  IF(MONTH(dt) <= 6, 1, 2)                                  AS semestre,
  YEAR(dt)                                                  AS ano,
  CONCAT(YEAR(dt), '/', IF(MONTH(dt) <= 6, 1, 2))           AS semestre_letivo,
  -- Suposição: janeiro, julho e dezembro são meses de férias
  IF(MONTH(dt) IN (1, 7, 12), 'N', 'S')                     AS flag_periodo_letivo
FROM calendario;

-- ---------------------------------------------------------
-- Conferência
-- ---------------------------------------------------------
-- Deve retornar 4018
SELECT COUNT(*) AS total_datas FROM dim_data;

-- Primeiras e últimas datas
SELECT * FROM dim_data ORDER BY sk_data LIMIT 3;
SELECT * FROM dim_data ORDER BY sk_data DESC LIMIT 3;

-- Esperado para 20260301: Domingo, Março, bimestre 2,
-- trimestre 1, semestre 1, semestre letivo 2026/1, período letivo S
SELECT * FROM dim_data WHERE sk_data = 20260301;
