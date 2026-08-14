SELECT *
FROM FUNCIONARIO 

-- DISTINCT 
SELECT DISTINCT F.Sexo
FROM FUNCIONARIO AS F;

SELECT *
FROM FUNCIONARIO AS F 
WHERE F.Pnome = 'Carlos'; 

SELECT * 
FROM FUNCIONARIO AS F 
WHERE F.Pnome = 'Carlos' OR F.Pnome = 'João';

SELECT *
FROM FUNCIONARIO AS F
WHERE
	F.Sexo = 'M' 
	AND F.Salario >= 30000;

	-- LIKE serve para fazer uma pesquisa dentro de uma string e os % dizem que pode estar em qualquer lugar 
SELECT * 
FROM FUNCIONARIO AS F 
WHERE F.Endereco LIKE '%São Paulo%' 
	OR F.Endereco LIKE '%Curitiba%';

SELECT * 
FROM FUNCIONARIO AS F
WHERE NOT
	F.Endereco LIKE '%São Paulo%';

-- Ordenar de forma descrescente os funcionarios que dão mais custos para a empresa
SELECT F.Pnome AS 'Nome', F.Unome AS 'Sobrenome',
	F.Salario,
	F.Salario * 12 AS 'CustoAnual'
FROM FUNCIONARIO AS F 
ORDER BY CustoAnual DESC;

SELECT *
FROM FUNCIONARIO AS F
WHERE F.Cpf_supervisor IS NULL; 

SELECT *
FROM FUNCIONARIO AS F
WHERE F.Cpf_supervisor IS NOT NULL;

-- Ordenando os 3 maiores salarios 
SELECT TOP 3 * 
FROM FUNCIONARIO AS F
ORDER BY F.Salario DESC;

-- Recuperar as informações do menor salario 
SELECT *
FROM FUNCIONARIO AS F 
WHERE F.Salario = (SELECT MIN (Salario) FROM FUNCIONARIO); 

-- Outra maneira, declarando uma variavel 
DECLARE @salario_min DECIMAL(10,2);
SET @salario_min = (SELECT MIN (Salario) FROM FUNCIONARIO);
SELECT *
FROM FUNCIONARIO AS F 
WHERE F.Salario = @salario_min;

-- Media salarial dos funcionarios 
SELECT AVG(F.Salario)
FROM FUNCIONARIO AS F 

-- Achar os funcionarios que estão a baixo da média 
SELECT *
FROM FUNCIONARIO AS F 
WHERE F.Salario < (SELECT AVG(Salario) FROM FUNCIONARIO)
ORDER BY F.Salario ASC; 

-- Custo mensal com a folha de pagamentos
SELECT SUM(F.Salario)
FROM FUNCIONARIO AS F


-- Recupere os dados dos funcionarios nascidos em 72 
SELECT *
FROM FUNCIONARIO AS F 
WHERE F.Datanasc LIKE '__72%';


