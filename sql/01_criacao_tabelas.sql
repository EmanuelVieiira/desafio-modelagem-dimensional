
CREATE TABLE dim_data (
  sk_data             INT          NOT NULL,          -- formato AAAAMMDD
  data_completa       DATE         NOT NULL,
  dia                 TINYINT      NOT NULL,
  dia_semana          VARCHAR(20)  NOT NULL,
  mes                 TINYINT      NOT NULL,
  nome_mes            VARCHAR(20)  NOT NULL,
  bimestre            TINYINT      NOT NULL,
  trimestre           TINYINT      NOT NULL,
  semestre            TINYINT      NOT NULL,
  ano                 SMALLINT     NOT NULL,
  semestre_letivo     VARCHAR(10)  NOT NULL,          -- ex.: 2026/1
  flag_periodo_letivo CHAR(1)      NOT NULL DEFAULT 'S',
  PRIMARY KEY (sk_data),
  UNIQUE KEY uk_data_completa (data_completa)
) ENGINE=InnoDB;

CREATE TABLE dim_professor (
  sk_professor     INT          NOT NULL AUTO_INCREMENT,
  idProfessor      INT          NOT NULL,             -- chave natural
  nome_professor   VARCHAR(100),
  titulacao        VARCHAR(45),
  regime_trabalho  VARCHAR(45),
  data_admissao    DATE,
  flag_coordenador CHAR(1)      NOT NULL DEFAULT 'N',
  PRIMARY KEY (sk_professor),
  UNIQUE KEY uk_professor_nk (idProfessor)
) ENGINE=InnoDB;

CREATE TABLE dim_departamento (
  sk_departamento   INT          NOT NULL AUTO_INCREMENT,
  idDepartamento    INT          NOT NULL,            -- chave natural
  nome_departamento VARCHAR(45),
  campus            VARCHAR(45),
  nome_coordenador  VARCHAR(100),
  PRIMARY KEY (sk_departamento),
  UNIQUE KEY uk_departamento_nk (idDepartamento)
) ENGINE=InnoDB;

CREATE TABLE dim_disciplina (
  sk_disciplina        INT          NOT NULL AUTO_INCREMENT,
  idDisciplina         INT          NOT NULL,         -- chave natural
  nome_disciplina      VARCHAR(100),
  carga_horaria_padrao INT,
  tem_prerequisito     CHAR(1)      NOT NULL DEFAULT 'N',
  nome_prerequisito    VARCHAR(100),
  PRIMARY KEY (sk_disciplina),
  UNIQUE KEY uk_disciplina_nk (idDisciplina)
) ENGINE=InnoDB;

CREATE TABLE dim_curso (
  sk_curso           INT          NOT NULL AUTO_INCREMENT,
  idCurso            INT          NOT NULL,            -- chave natural
  nome_curso         VARCHAR(100),
  nivel              VARCHAR(45),
  modalidade         VARCHAR(45),
  duracao_semestres  TINYINT,
  PRIMARY KEY (sk_curso),
  UNIQUE KEY uk_curso_nk (idCurso)
) ENGINE=InnoDB;

-- ---------------------------------------------------------
-- FATO
-- Granularidade: 1 linha por professor, disciplina, curso
-- e período de oferta.
-- ---------------------------------------------------------
CREATE TABLE fato_professor_oferta (
  sk_professor        INT NOT NULL,
  sk_departamento     INT NOT NULL,
  sk_disciplina       INT NOT NULL,
  sk_curso            INT NOT NULL,
  sk_data_oferta      INT NOT NULL,                   -- início da oferta
  sk_data_fim_oferta  INT NOT NULL,                   -- fim da oferta (role-playing)
  qtd_disciplinas     INT NOT NULL DEFAULT 1,
  carga_horaria       INT,
  qtd_prerequisitos   INT NOT NULL DEFAULT 0,
  PRIMARY KEY (sk_professor, sk_disciplina, sk_curso, sk_data_oferta),
  CONSTRAINT fk_fato_professor    FOREIGN KEY (sk_professor)       REFERENCES dim_professor (sk_professor),
  CONSTRAINT fk_fato_departamento FOREIGN KEY (sk_departamento)    REFERENCES dim_departamento (sk_departamento),
  CONSTRAINT fk_fato_disciplina   FOREIGN KEY (sk_disciplina)      REFERENCES dim_disciplina (sk_disciplina),
  CONSTRAINT fk_fato_curso        FOREIGN KEY (sk_curso)           REFERENCES dim_curso (sk_curso),
  CONSTRAINT fk_fato_data_ini     FOREIGN KEY (sk_data_oferta)     REFERENCES dim_data (sk_data),
  CONSTRAINT fk_fato_data_fim     FOREIGN KEY (sk_data_fim_oferta) REFERENCES dim_data (sk_data)
) ENGINE=InnoDB;

-- Conferência: devem aparecer 6 tabelas
SHOW TABLES;
