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
