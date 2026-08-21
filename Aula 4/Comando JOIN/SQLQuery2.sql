-- Posso fazer operações matematicas com: 
		-- INNER JOIN ( retorna registros de ambas as tabelas)
		-- LEFT JOIN (registro das tabelas da esquerda)
		-- RIGHT JOIN (resgitro das tabelas da direita)
		-- CROSS JOIN (registro de todas as tabelas) 
		-- SELF JOIN (quando uma tabela se relacina a ela mesma) 

-- Funcionarios que trtabalham no departamento pesquisa 
SELECT F.Pnome, F.Unome, F.Endereco, D.Dnome
FROM FUNCIONARIO AS F 
INNER JOIN DEPARTAMENTO AS D
ON F.Dnr = D.dnumero 
WHERE D.Dnome = 'Pesquisa'; 

-- Nome dos fincionarios que estão trabalando no ProdutoX
SELECT F.Pnome, F.Minicial, F.Unome
FROM TRABALHA_EM AS T
INNER JOIN PROJETO AS P
ON T.Pnr = P.Projnumero
INNER JOIN FUNCIONARIO AS F
ON T.Fcpf = F.Cpf
WHERE P.Projnome = 'ProdutoX';

-- Numero do departamento que controla os projetos localizados em Mauá 
SELECT D.Dnome,
	P.Projnome,
	P.Projlocal,
	D.Cpf_gerente,
	F.Unome,
	F.Endereco
FROM DEPARTAMENTO AS D
INNER JOIN PROJETO AS P  
ON P.Dnum = D.Dnumero
INNER JOIN FUNCIONARIO AS F
ON F.Cpf = D.Cpf_gerente
WHERE P.Projlocal = 'Mauá';

-- LEFT JOIN 
-- Liste todos os funcionarios e seus respectivos departamentos
SELECT *
FROM FUNCIONARIO AS F
LEFT JOIN DEPARTAMENTO AS D
ON F.Dnr = D.Dnumero; 

-- Encontre os departamento que não possuem funcionarios 
SELECT *
FROM DEPARTAMENTO AS D
LEFT JOIN FUNCIONARIO AS F
ON F.Dnr = D.Dnumero
WHERE F.Cpf IS NULL; 

-- RIGHT JOIN 
-- Encontre os departamentos que não pussem funcionarios 
SELECT *
FROM FUNCIONARIO AS F
RIGHT JOIN DEPARTAMENTO AS D
ON F.Dnr = D.Dnumero 
WHERE F.Cpf IS NULL; 

-- CROSS JOIN (FULL JOIN)
-- Teste as relações entre funcionarios e departamento 
SELECT *
FROM FUNCIONARIO AS F
FULL JOIN DEPARTAMENTO AS D
ON F.Dnr = D.Dnumero; 

-- Mostre os funcionarios que não possuem departamento e os departamento sem funcionarios 
SELECT *
FROM FUNCIONARIO AS F
FULL JOIN DEPARTAMENTO AS D
ON F.Dnr = D.Dnumero
WHERE D.Dnumero IS NULL
	OR F.Cpf IS NULL; 

-- SELF JOIN	
-- Mostre apenas os funcionarios que possuem supervisor 
SELECT *
FROM FUNCIONARIO AS F
JOIN FUNCIONARIO AS FA
ON F.Cpf = FA.Cpf
WHERE F.Cpf_supervisor IS NOT NULL;


-- UNION / INTERSECT / EXCEPT 
-- Só consigo fazer em tabelas que possuem os mesmos tipos de colunas 

-- Listar todos os nomes, sexo e data de nascimento de todas as pessoas do banco 
-- UNION (Executar tudo junto)
SELECT 
	F.Pnome AS 'Nome', 
	F.Sexo AS 'Sexo',
	F.Datanasc AS 'Data'
FROM FUNCIONARIO AS F 

UNION

SELECT 
	D.Nome_dependente AS 'Nome',
	D.Sexo AS 'Sexo',
	D.Datanasc AS 'Data'
FROM DEPENDENTE AS D
