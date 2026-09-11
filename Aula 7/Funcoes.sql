-- Funções 
CREATE OR ALTER FUNCTION fn_dobro(@Numero INT) -- OR ALTER serve para alterar a função se ela ja estiver criada e criar caso ainda não exista  
RETURNS DECIMAL(10,2) 
AS 
BEGIN 
	RETURN @Numero *2;
END; 
GO

-- Dobrando o salario de um Funcionario 
SELECT
	Pnome,
	Unome,
	F.Salario,
	dbo.fn_dobro(F.Salario) AS 'Novo salário'
FROM FUNCIONARIO AS F
WHERE F.Pnome = 'Carlos';

-- Listar os que ganham mais que o dobro do funcionario que menos ganha
DECLARE @menor_salario DECIMAL(10,2);

SELECT @menor_salario = MIN(Salario)
FROM FUNCIONARIO AS F;

PRINT @menor_salario

SELECT
	Pnome,
	Unome,
	F.Salario
FROM FUNCIONARIO AS F
WHERE F.Salario > dbo.fn_dobro(@menor_salario);

GO


-- Função para calcular a idade correta dos Funcionarios 
CREATE OR ALTER FUNCTION fn_calcularIdade(@data_nascimento DATE)
RETURNS INT 
AS 
BEGIN 
	DECLARE @idade INT; 

	IF(MONTH(GETDATE()) < MONTH(@data_nascimento))
		BEGIN 
			SET @idade = DATEDIFF(YEAR, @data_nascimento, GETDATE()) -1; 
		END

	ELSE IF(MONTH(GETDATE()) = MONTH(@data_nascimento) AND DAY(GETDATE()) < DAY(@data_nascimento))
		BEGIN 
			SET @idade = DATEDIFF(YEAR, @data_nascimento, GETDATE()) -1;
		END

	ELSE 
		BEGIN
			SET @idade = DATEDIFF(YEAR, @data_nascimento, GETDATE())
		END

	RETURN @idade 
END;
GO 

-- Função que retorna uma tabela existente 
-- Retornar todos os funcionários de um determinado departamento 
CREATE OR ALTER FUNCTION fn_funcionarios_departamento(@departamento VARCHAR(50))
RETURNS TABLE  
AS 
RETURN(
	SELECT 
		F.Pnome,
		f.Unome
	FROM FUNCIONARIO AS F
	JOIN DEPARTAMENTO AS D
	ON F.Dnr = D.Dnumero
	WHERE D.Dnome = @departamento

)
GO 

SELECT * FROM dbo.fn_funcionarios_departamento('Pesquisa');

GO

-- Função que retorna uma tabela nova (que a função cria) 
-- Retornar nome completo dos funcionarios e o valor do salrioa anual, com férias e decimo terceiro 
CREATE FUNCTION fn_salario_anual()
RETURNS @tabela_salario_anual TABLE 
(
	nome_completo VARCHAR(50),
	salario DECIMAL(10,2),
	salario_anual DECIMAL(10,2)
)

BEGIN 
	INSERT INTO @tabela_salario_anual
	SELECT 
		CONCAT(F.Pnome, ' ', F.Minicial, ' ', F.Unome),
		F.Salario,
		F.Salario * 13 + (F.Salario*0.3)
	FROM FUNCIONARIO AS F;

	RETURN;
END

GO

SELECT * FROM dbo.fn_salario_anual(); 