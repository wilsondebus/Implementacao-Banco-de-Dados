CREATE DATABASE CAIXA;

USE CAIXA;

-- Criação da tabela 
CREATE TABLE conta(
	id INT PRIMARY KEY,
	Nome VARCHAR(50),
	Saldo MONEY
);

INSERT INTO CONTA 
VALUES	(10, 'Maria', 500),
		(20, 'João', 1500),
		(30, 'Paulo', 30000),
		(40, 'Maria', 50000);

GO 
-- Primeira transação 
BEGIN TRAN;
	DECLARE @erro INT = 0;
	INSERT INTO CONTA 
	VALUES	(50, 'Pedro', 50);
	SET @erro = @erro + @@ERROR
	INSERT INTO CONTA 
	VALUES (10, 'Judas', 666);
	SET @erro = @erro + @@ERROR
	SELECT * FROM CONTA;
	IF @erro <> 0
	BEGIN 
		PRINT 'Transação revertida'
		ROLLBACK TRAN;
	END 
	ELSE 
	BEGIN 
		PRINT 'Transação realizada com sucesso!'
		COMMIT TRAN;
	END 
SELECT * FROM CONTA;

GO 

BEGIN TRAN;
UPDATE conta 
SET Saldo = Saldo + 10000
WHERE Nome = 'Maria'; 
IF @@ROWCOUNT <> 1
BEGIN
	SELECT * FROM CONTA; 
	ROLLBACK TRAN
	SELECT * FROM CONTA;
END
ELSE 
	COMMIT TRAN;

GO 

-- Transeferir dinheiro de uma pessoa para outra 
CREATE OR ALTER PROCEDURE usp_transferencia 
	@id_origem INT,
	@id_destino INT,
	@valor MONEY 

AS 
BEGIN
	BEGIN TRAN 
	-- Tirando dinheiro da conta de origem
	UPDATE conta 
	SET Saldo = Saldo - @valor 
	WHERE id = @id_origem;
	-- Depositar dinheiro na conta de destino
	UPDATE conta 
	SET Saldo = Saldo + @valor 
	WHERE id = @id_destino;
	-- Ver possivel estado do da tabela conta
	SELECT * FROM CONTA; 
	-- Condição para ROLLBACK
	IF (SELECT Saldo FROM CONTA WHERE id = @id_origem) < 0
	BEGIN
		ROLLBACK TRAN
		PRINT 'Saldo insuficiente'; 
	END
	-- Condição para COMMIT
	ELSE 
	BEGIN 
		COMMIT TRAN 
		PRINT 'Transferencia enviada com sucesso'; 
	END 
END

GO

SELECT * FROM CONTA; 

EXEC usp_transferencia 40, 10, 500;

EXEC usp_transferencia 10, 20, 2000;
SELECT * FROM CONTA;	

GO

-- Save Point 
BEGIN TRAN;
INSERT INTO CONTA
VALUES (50, 'Pedro', 50);
-- save point
SAVE TRAN pedroOk
INSERT INTO CONTA
VALUES (10, 'Juca', -200); 
IF @@ERROR <> 0 
BEGIN 
	ROLLBACK TRAN pedroOk
	COMMIT TRAN; 
	PRINT 'Voltamos para o save point'
END
ELSE 
	COMMIT TRAN;

SELECT * FROM CONTA;

GO 

-- TRY CATCH 
BEGIN TRY 
	PRINT 'Olá try catch';
	SELECT 1/0; -- ERRO
	PRINT 'Não cheguei aqui'
END TRY 
BEGIN CATCH 
	PRINT 'Deu erro!'
	PRINT 'Numero do erro: ' + CAST (ERROR_NUMBER()AS VARCHAR(10));
	PRINT 'Mensagem do erro: '+ ERROR_MESSAGE(); 
END CATCH 

-- TRANSACTION + TRY CATCH 
BEGIN TRAN;
BEGIN TRY
	INSERT INTO CONTA
	VALUES (60, 'Mateus', 15);
	SELECT * FROM CONTA;
	INSERT INTO CONTA
	VALUES (10, 'Juca', -200); 
	COMMIT TRAN;
	SELECT * FROM CONTA;
END TRY 
BEGIN CATCH
	ROLLBACK TRAN;
	PRINT 'ERRO!'
	PRINT 'Numero do erro: ' + CAST (ERROR_NUMBER()AS VARCHAR(10));
	PRINT 'Mensagem do erro: '+ ERROR_MESSAGE(); 
END CATCH

select * from conta;

GO

-- CRIAR UM PROCEDURE QUE INSIRA UM NOVO USUARIO NA CONTA 
-- NÃO PERMITA DUPLICIDADE DE NOMES 

DELETE FROM CONTA
WHERE id = 40;

SELECT * FROM CONTA;

GO

CREATE OR ALTER PROCEDURE usp_inserirUsuario(@id INT, @nome VARCHAR(50), @saldo MONEY)
AS 
BEGIN 
	BEGIN TRY 
		BEGIN TRAN
			IF EXISTS(SELECT 1 FROM CONTA WHERE Nome = @nome)
			BEGIN 
				PRINT 'Já existe uma conta com esse nome';
				ROLLBACK TRAN;
			END

			INSERT INTO CONTA (id, Nome, Saldo)
			VALUES(@id, @nome, @saldo);

			COMMIT TRAN;
			PRINT 'Conta inserida com sucesso';
		END TRY
		BEGIN CATCH 
			ROLLBACK TRAN;
			PRINT 'Erro ao inserir conta: '
			PRINT 'Numero do erro: ' + CAST (ERROR_NUMBER()AS VARCHAR(10));
			PRINT 'Mensagem do erro: '+ ERROR_MESSAGE(); 
		END CATCH 
	END;

GO

EXEC usp_inserirUsuario 60, 'Wilson', 1900;

SELECT * FROM CONTA;


		
