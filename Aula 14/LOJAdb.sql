CREATE DATABASE LOJA;
USE LOJA; 
GO

CREATE TABLE CATEGORIA(
	id INT PRIMARY KEY,
	nome VARCHAR(60) NOT NULL,
	CONSTRAINT uq_categoria_nome UNIQUE (nome)
);

CREATE TABLE FORNECEDOR(
	id INT PRIMARY KEY,
	nome VARCHAR(60) NOT NULL,
	telefone VARCHAR(20)
);

CREATE TABLE PRODUTO(
	id INT IDENTITY(100, 1) PRIMARY KEY, -- Mesma coisa que o auto increment
	nome VARCHAR(80) NOT NULL,
	preco DECIMAL(10, 2) NOT NULL,
	quantidade INT NOT NULL CONSTRAINT df_produto_qtd DEFAULT 0,
	situacao VARCHAR(10) NOT NULL DEFAULT 'Ativo',
	id_categoria INT NOT NULL,
	id_fornecedor INT NULL, -- pode ser nulo 

	CONSTRAINT ck_produto_preco CHECK(preco > 0), -- não pode cadastrar um produto com preço nagativo
	CONSTRAINT ck_produto_qts CHECK(quantidade >= 0),
	CONSTRAINT ck_produto_situacao CHECK(situacao IN ('Ativo', 'Inativo')), -- Verifica se o campo situacao tem um desses dois valores, unicos possíveis

	CONSTRAINT fk_produto_categoria 
		FOREIGN KEY (id_categoria) REFERENCES CATEGORIA(id)
		ON DELETE CASCADE 
		ON UPDATE CASCADE 
);

-- Adicionando restrição fora da criação da tebela
ALTER TABLE PRODUTO 
ADD CONSTRAINT fk_produto_fornecedor
	FOREIGN KEY (id_fornecedor) REFERENCES FORNECEDOR (id)
	ON DELETE SET NULL
	ON UPDATE CASCADE;

-- Populando o banco 
INSERT INTO CATEGORIA (id, nome)
VALUES	(10, 'Informática'),
		(20, 'Papelaria'),
		(30, 'Acessórios')

INSERT INTO FORNECEDOR (id, nome, telefone)
VALUES	(1, 'Distribuidora Alfa', '5555-666'),
		(2, 'Comercial Ltda', NULL);

INSERT INTO PRODUTO (nome, preco, quantidade, situacao, id_categoria, id_fornecedor)
VALUES	('Mouse sem fio', 79.99, 15, 'Ativo', 10, 1),
		('Teclado USB', 120, 8, 'Ativo', 10, 2),
		('Caderno', 29.90, 50, 'Ativo', 20, 1),
		('Caneta', 4.50, 100, 'Ativo', 20, 2);

INSERT INTO PRODUTO (nome, preco, id_categoria)
VALUES	('Fone de Ouvido', 99.99, 30);

SELECT * FROM PRODUTO

-- Testando o ON UPDATE CASCADE 
UPDATE CATEGORIA
SET id = 11
WHERE id = 10;

-- Testando ON DELETE SET NULL
DELETE FROM FORNECEDOR
WHERE id = 1;

-- ON DELETE CASCADE
DELETE FROM CATEGORIA
WHERE id = 20;

SELECT * FROM CATEGORIA
SELECT * FROM PRODUTO

GO 

SELECT 
	P.Nome as 'Produto',
	P.quantidade AS 'Quantidade',
	P.situacao AS 'Situacao',
	F.nome AS 'Fornecedor',
	C.nome AS 'Categoria'
FROM PRODUTO AS P
LEFT JOIN FORNECEDOR AS F
ON P.id_fornecedor = F.id
JOIN CATEGORIA AS C
ON P.id_categoria = C.id

GO



		

