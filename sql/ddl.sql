CREATE SCHEMA covid_pb ;
GO

CREATE TABLE covid_pb.cidade(
	codigo BIGINT,
	nome VARCHAR(100) NOT NULL,
	CONSTRAINT cidade_pk PRIMARY KEY(codigo)
);
GO

CREATE TABLE covid_pb.situacao(
	codigo BIGINT,
	cor VARCHAR(20) NOT NULL,
	CONSTRAINT situacao_pk PRIMARY KEY(codigo)
);
GO

CREATE TABLE covid_pb.cidade_situacao(
	codigo_cidade BIGINT,
	codigo_situacao BIGINT,
	data_inicio DATE NOT NULL,
	CONSTRAINT situacao_cidade_pk PRIMARY KEY(codigo_cidade, codigo_situacao),
	CONSTRAINT cidade_fk FOREIGN KEY(codigo_cidade) REFERENCES covid_pb.cidade(codigo),
	CONSTRAINT situacao_fk FOREIGN KEY(codigo_situacao) REFERENCES covid_pb.situacao(codigo)
);
GO

CREATE TABLE covid_pb.leitos(
	codigo BIGINT,
	tipo VARCHAR(20) NOT NULL,
	vagas INTEGER NOT NULL DEFAULT 0,
	codigo_cidade BIGINT NOT NULL,
	CONSTRAINT leitos_pk PRIMARY KEY(codigo),
	CONSTRAINT leitos_cidade_fk FOREIGN KEY(codigo_cidade) REFERENCES covid_pb.cidade(codigo)
);
GO

CREATE TABLE covid_pb.caso(
	codigo BIGINT,
	data_nascimento DATE,
	profissional_saude BIT,
	sexo VARCHAR(10),
	codigo_cidade BIGINT NOT NULL,
	CONSTRAINT caso_pk PRIMARY KEY(codigo),
	CONSTRAINT caso_cidade_fk FOREIGN KEY(codigo_cidade) REFERENCES covid_pb.cidade(codigo)
);
GO

CREATE TABLE covid_pb.sintoma(
	codigo BIGINT,
	nome VARCHAR(50),
	codigo_caso BIGINT NOT NULL,
	CONSTRAINT sintoma_fk PRIMARY KEY(codigo),
	CONSTRAINT sintoma_caso_fk FOREIGN KEY(codigo_caso) REFERENCES covid_pb.caso(codigo)
);
GO

CREATE TABLE covid_pb.teste(
	codigo BIGINT,
	data_teste DATE NOT NULL,
	tipo VARCHAR(50) NOT NULL,
	resultado VARCHAR(100),
	status VARCHAR(50),
	codigo_caso BIGINT NOT NULL,
	CONSTRAINT teste_pk PRIMARY KEY(codigo),
	CONSTRAINT teste_caso_fk FOREIGN KEY(codigo_caso) REFERENCES covid_pb.caso(codigo)
);
GO

CREATE TABLE covid_pb.obito(
	codigo BIGINT,
	data_obto DATE NOT NULL,
	sexo VARCHAR(10),
	inicio_sintomas DATE,
	idade INTEGER,
	codigo_cidade BIGINT NOT NULL,
	CONSTRAINT obito_pk PRIMARY KEY(codigo),
	CONSTRAINT obto_cidade_fk FOREIGN KEY(codigo_cidade) REFERENCES covid_pb.cidade(codigo)
);
GO

CREATE TABLE covid_pb.doenca_pessoal(
	codigo BIGINT,
	nome VARCHAR(20) NOT NULL,
	codigo_obito BIGINT NOT NULL,
	CONSTRAINT doenca_pessoal_pk PRIMARY KEY(codigo),
	CONSTRAINT doenca_obto_fk FOREIGN KEY(codigo_obito) REFERENCES covid_pb.obito(codigo)
);
GO