-- Revisão para prova 

SELECT name FROM sys.databases;

-- Listar todos os livros em ordem alfabética

USE BIBLIOTECA;

SELECT *
FROM LIVRO AS L 
ORDER BY L.titulo; 

-- Listar todos os dados disponíveis de todos os livros ordenando em ordem alfabética por autor 
SELECT * 
FROM LIVROAUTOR AS LA
INNER JOIN LIVRO AS L
	ON LA.fk_livro = L.isbn
INNER JOIN AUTOR AS A
	ON LA.id = A.id
ORDER BY A.nome ASC; 

-- Mostrar todos os dados da categoria Litaratura Juvenil em ordem de ano
SELECT *
FROM CATEGORIA AS C 
INNER JOIN LIVRO AS L
	ON C.id = L.fk_categoria
WHERE C.tipo_categoria = 'Literatura Juvenil'
ORDER BY L.ano;

-- Mostrar os dados dos livros da categoria de humor ou ficcção científica dos anos entre 2000 e 2010
SELECT * 
FROM CATEGORIA AS C 
INNER JOIN LIVRO AS L 
	ON C.id = L.fk_categoria
WHERE C.tipo_categoria =  'Humor' 
			OR C.tipo_categoria = 'Ficção Científica'
		AND L.ano >= 2000 
		AND L.ano <= 2010;

-- BANCO EMPRESA 
-- Listar Funcionarios que trabalham no departamento Pesquisa 
USE EMPRESA 
SELECT *
FROM FUNCIONARIO AS F 
INNER JOIN DEPARTAMENTO AS D
	ON F.Dnr = D.Dnumero
WHERE D.Dnome = 'Pesquisa'; 

-- Nome dos funcionarios que estão trabalhando no ProdutoX
SELECT F.Pnome AS 'NOME'
FROM TRABALHA_EM AS T
INNER JOIN PROJETO AS P
	ON T.Pnr = P.Projnumero
INNER JOIN FUNCIONARIO AS F
	ON T.Fcpf = F.Cpf
WHERE P.Projnome = 'ProdutoX';

-- Numero do departamento que controla os projetos localizados em Mauá 
SELECT D.Dnome AS 'Nome', D.Dnumero AS 'Numero'
FROM DEPARTAMENTO AS D
INNER JOIN PROJETO AS P
	ON D.Dnumero = P.Dnum
WHERE P.Projlocal = 'Mauá';

-- Liste todos os funcionários e seus repectivos departamentos 
SELECT F.Pnome AS 'Nome', F.Unome AS 'Sobrenome', D.Dnome AS 'Nome Departamento'
FROM FUNCIONARIO AS F
INNER JOIN DEPARTAMENTO AS D
	ON F.Dnr = D.Dnumero

-- Encontre departamento que não possuem funcionarios 
SELECT D.Dnome
FROM DEPARTAMENTO AS D
LEFT JOIN FUNCIONARIO AS F
	ON F.Dnr = D.Dnumero
WHERE F.Cpf IS NULL;

-- Mostre os funcionarios que não possuem departamento 
SELECT F.Pnome, F.Unome
FROM FUNCIONARIO AS F
LEFT JOIN DEPARTAMENTO AS D
	ON F.Dnr = D.Dnumero
WHERE D.Dnumero IS NULL;





