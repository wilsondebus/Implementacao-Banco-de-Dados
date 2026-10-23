-- TRIGGER 

-- AFTER -> faz a ação e depois executa o trigger mas é antes do commit 

-- INSTEAD OF -> ao invés de fazer a ação ele faz o que esta dentro do trigger 

 
-- AFTER 
CREATE OR ALTER TRIGGER trg_after_insert_dpt
ON DEPARTAMENTO	
AFTER INSERT 
AS 
BEGIN
	DECLARE @nome VARCHAR(40);
	SELECT @nome = I.Dnome
	FROM inserted AS I; 

	PRINT 'Foi inserido um novo departamento: '+ @nome;
END;

GO

INSERT INTO DEPARTAMENTO(Dnumero, Dnome)
VALUES (88, 'Expedição'); 

INSERT INTO DEPARTAMENTO(Dnumero, Dnome)
VALUES (90, 'Esportes');

SELECT * FROM DEPARTAMENTO;

GO

-- INSTEAD OF

CREATE TRIGGER trg_insteadof_delete_dpt
ON DEPARTAMENTO 
INSTEAD OF DELETE 
AS 
BEGIN
	PRINT 'Não deletei o registro'; 
END;

GO

DELETE FROM DEPARTAMENTO
WHERE Dnumero = 88; 

-- Desabilitar trigger 

ALTER TABLE DEPARTAMENTO 
DISABLE TRIGGER trg_insteadof_delete_dpt;

-- Exibir as informações dos triggers 

EXEC sp_helptrigger DEPARTAMENTO;

GO

-- Trigger que não permita inserir um departamento com o nome de um que ja exista
CREATE OR ALTER TRIGGER trg_insteadof_insert_dpt_nao_repetido
ON DEPARTAMENTO 
INSTEAD OF INSERT 
AS 
BEGIN 
	DECLARE @nome_departamento VARCHAR(40);
	SELECT @nome_departamento = I.Dnome
	FROM inserted AS I; 
	IF EXISTS (SELECT * FROM DEPARTAMENTO WHERE Dnome = @nome_departamento)
		RAISERROR('Já existe um departamento com este nome', 16, 1);  
	ELSE 
		INSERT INTO DEPARTAMENTO(Dnumero, Dnome, Cpf_gerente, Data_inicio_gerente)
		SELECT I.Dnumero, I.Dnome, I.Cpf_gerente, I.Data_inicio_gerente
		FROM inserted AS I
END; 

GO 

INSERT INTO DEPARTAMENTO(Dnumero, Dnome)
VALUES (90, 'Vendas'); 

INSERT INTO DEPARTAMENTO(Dnumero, Dnome)
VALUES (90, 'Estoque');

GO

-- FUNÇÂO UPDATE 
-- Verificar se um nome foi alterado
CREATE OR ALTER TRIGGER trg_for_update_nome 
ON DEPARTAMENTO 
FOR UPDATE -- FOR = AFTER 
AS 
BEGIN 
	DECLARE @nome_antigo VARCHAR(40),
			@nome_novo VARCHAR(40);

	SELECT @nome_antigo = D.Dnome FROM deleted AS D;
	SELECT @nome_novo = I.Dnome FROM inserted AS I;

	IF UPDATE(Dnome)
	BEGIN
		PRINT 'O nome era: '+@nome_antigo;
		PRINT 'Novo nome: '+@nome_novo;
	END
	ELSE 
		PRINT 'O nome não foi alterado';
END

UPDATE DEPARTAMENTO
SET DNome = 'Tecnologia'
WHERE Dnome = 'TI';

UPDATE DEPARTAMENTO
SET Dnumero = 9
WHERE Dnome = 'Estoque';

SELECT * FROM DEPARTAMENTO;

GO 

-- Triggers preenhendo uma tabela de LOG
CREATE TABLE LOG_FUNCIONARIO(
	log_id INT IDENTITY(100,1) PRIMARY KEY,
	cpf CHAR (11),
	operacao VARCHAR(10),
	data_hora DATETIME DEFAULT GETDATE()
)

GO

CREATE TRIGGER trg_for_insert_funcionario 
ON FUNCIONARIO 
FOR INSERT
AS 
BEGIN 
	INSERT INTO LOG_FUNCIONARIO (cpf, operacao)
	SELECT I.Cpf, 'INSERT'
	FROM inserted AS I
END

GO

CREATE OR ALTER TRIGGER trg_for_update_funcionario 
ON FUNCIONARIO 
FOR UPDATE
AS 
BEGIN 
	INSERT INTO LOG_FUNCIONARIO (cpf, operacao)
	SELECT I.Cpf, 'UPDATE'
	FROM inserted AS I
END

GO 

CREATE TRIGGER trg_for_deleted_funcionario 
ON FUNCIONARIO 
FOR DELETE
AS 
BEGIN 
	INSERT INTO LOG_FUNCIONARIO (cpf, operacao)
	SELECT D.Cpf, 'DELETE'
	FROM deleted AS D
END

INSERT INTO FUNCIONARIO(Pnome, Unome, Cpf, Datanasc, Endereco, Sexo, Salario, Bonus, Data_Admissao, Dnr)
VALUES ('Wilson', 'Debus', '04284945017', '2006-11-07', 'Vale Machado 1619', 'M', 2000, 1000, '2026-04-06', 9);

SELECT * FROM FUNCIONARIO;
SELECT * FROM LOG_FUNCIONARIO;

UPDATE FUNCIONARIO 
SET Salario = 500
WHERE Cpf = '04284945017';

DELETE FROM FUNCIONARIO
WHERE Cpf = '04284945017';

GO

-- Fazendo os 3 no mesmo trigger
CREATE OR ALTER TRIGGER trg_for_IDU_funcionario 
ON FUNCIONARIO 
FOR INSERT, DELETE, UPDATE
AS 
BEGIN 
	-- Se UPDATE 
	IF EXISTS (SELECT * FROM inserted)
	BEGIN
		IF EXISTS (SELECT * FROM deleted)
			INSERT INTO LOG_FUNCIONARIO (cpf, operacao)
			SELECT I.Cpf, 'UPDATE'
			FROM inserted AS I;
		ELSE 
			INSERT INTO LOG_FUNCIONARIO (cpf, operacao)
			SELECT I.Cpf, 'INSERT'
			FROM inserted AS I;
	END
	ELSE 
		INSERT INTO LOG_FUNCIONARIO (cpf, operacao)
		SELECT D.Cpf, 'DELETE'
		FROM deleted AS D; 
END;
