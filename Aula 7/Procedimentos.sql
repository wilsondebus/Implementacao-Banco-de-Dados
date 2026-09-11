-- Procedimentos Armazenados 
CREATE PROCEDURE sp_exibe_meu_nome
AS 
BEGIN
	PRINT 'Wilson Dias Debus'; 
END 
GO; 

-- Ele só roda quando mandar rodar
EXEC sp_exibe_meu_nome; 

GO

-- Criar um procedimento que de um aumento no salario de todos do banco
CREATE PROCEDURE sp_dissidio(@porcentagem_anual DECIMAL(3,1))
AS
BEGIN 
	UPDATE FUNCIONARIO 
	SET Salario = Salario * (1+(@porcentagem_anual/100))
END 

GO

EXEC dbo.sp_dissidio @porcentagem_anual = 5;

SELECT * FROM FUNCIONARIO;

-- Retorna os meta dados de qualquer dado do banco, função, procedimento...
EXEC sp_help sp_dissidio;

GO

-- Criptografar um procedimento 
CREATE PROCEDURE sp_funcionaros 
WITH ENCRYPTION 
AS
SELECT * FROM FUNCIONARIO; 

GO 

-- Não da pra ver o que tem dentro do procedimento pois ele é criptografado
EXEC sp_help sp_funcionaros;

GO

-- Alterando o precedimento para passar um cpf para dar um aumento
ALTER PROCEDURE sp_dissidio(@porcentagem_anual DECIMAL(3,1), @cpf CHAR(11))
AS
BEGIN 
	UPDATE FUNCIONARIO 
	SET Salario = Salario * (1+(@porcentagem_anual/100))
	WHERE Cpf = @cpf
END 
GO

EXEC dbo.sp_dissidio @porcentagem_anual = 5, @cpf = '98765432300';
SELECT * FROM FUNCIONARIO; 

GO

-- Crie um procedimento que insere um novo departamento no banco com a sua respectiva localidade
-- Verificar no banco se este departamento já não existe 
CREATE PROCEDURE sp_insere_departamento(
			@nome_departamento VARCHAR(50), 
			@localidade VARCHAR(50), 
			@numero INT)
AS 
BEGIN
	IF EXISTS (SELECT 1
			FROM DEPARTAMENTO 
			WHERE Dnome = @nome_departamento)
		BEGIN
			PRINT 'Esse departamento ' +nome_departamento+ ' ja existe';
			RETURN; 
		END

	ELSE 
		BEGIN
			INSERT INTO DEPARTAMENTO (Dnome, Dnumero)
			VALUES (@nome_departamento, @numero)

			INSERT INTO LOCALIZACAO_DEP(Dnumero, Dlocal)
			VALUES (@numero, @localidade)

			PRINT @nome_departamento + ' inserido com sucesso!';
			PRINT @localidade + ' inserido com sucesso!';
		END
END 
GO 

EXEC sp_insere_departamento 'Compras', 'Santa Maria', 130; 
GO 

SELECT * 
FROM DEPARTAMENTO AS D
JOIN LOCALIZACAO_DEP AS L
ON D.DNumero = L.Dnumero; 

GO 

-- Crie um procedimento que faz uma listagem dos funcionarios por departamento, mas se o departamento não for especificado, o procedimento lista todos os funcionarios
CREATE PROCEDURE 
AS
BEGIN 
	
END 

