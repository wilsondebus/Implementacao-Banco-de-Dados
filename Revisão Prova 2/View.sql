USE EMPRESA;

GO

-- View 
-- Funcionários que não são supervisores
CREATE OR ALTER VIEW vw_funcionarios_nao_supervisores AS 
SELECT F.Pnome, F.Unome, F.Cpf, F.Salario
FROM FUNCIONARIO AS F
WHERE F.Cpf NOT IN ( -- Que não aparecem nessa lista 
	SELECT Cpf_supervisor
	FROM FUNCIONARIO 
	WHERE Cpf_supervisor IS NOT NULL
);
GO
SELECT * FROM vw_funcionarios_nao_supervisores;
GO

-- Quantidade de funcionários por projeto
CREATE OR ALTER VIEW vw_quantidade_funcionarios_projeto AS 
SELECT P.Projnome AS 'Projeto',
	(SELECT COUNT (*)
	 FROM TRABALHA_EM AS T
	 WHERE T.Pnr = P.Projnumero) AS 'Total Funcionarios'
FROM PROJETO AS P

GO

SELECT * FROM vw_quantidade_funcionarios_projeto;
GO

-- Departamentos e quantidade de funcionários
CREATE OR ALTER VIEW vw_quantidade_funcionario_departamento AS 
SELECT D.Dnome AS 'Nome Departamento',
	(SELECT COUNT(*)
	 FROM FUNCIONARIO AS F
	 WHERE F.Dnr = D.Dnumero) AS 'Quantidade de funcionarios'
FROM DEPARTAMENTO AS D
GO

SELECT * FROM vw_quantidade_funcionario_departamento;
GO

-- Funcionário com maior salário
CREATE VIEW vw_funcionario_maior_salario AS 
SELECT F.Pnome, (F.Salario)
FROM FUNCIONARIO AS F
WHERE F.Salario =	(SELECT MAX(Salario) 
					FROM FUNCIONARIO);
GO

SELECT * FROM vw_funcionario_maior_salario;
GO

-- Funcionários ordenados por salário
CREATE VIEW vw_ordenar_salario AS 
SELECT F.Pnome, F.Unome, F.Salario
FROM FUNCIONARIO AS F
GO

SELECT * FROM vw_ordenar_salario ORDER BY Salario DESC;
GO

-- Relatório completo de projetos
CREATE OR ALTER VIEW vw_listar_projetos_caracteristicas AS
SELECT
    P.Projnome AS 'Projeto',
    D.Dnome AS 'Departamento',
    P.Projlocal AS 'Localização',

    -- Soma as horas trabalhadas em cada projeto
    (SELECT SUM(T.Horas)
     FROM TRABALHA_EM AS T
     WHERE T.Pnr = P.Projnumero) AS 'Total Horas'

FROM PROJETO AS P
JOIN DEPARTAMENTO AS D
ON P.Dnum = D.Dnumero

-- Mostra apenas projetos que possuem funcionários
WHERE EXISTS (
    SELECT *
    FROM TRABALHA_EM AS T
    WHERE T.Pnr = P.Projnumero
);
GO

SELECT * FROM vw_listar_projetos_caracteristicas;
