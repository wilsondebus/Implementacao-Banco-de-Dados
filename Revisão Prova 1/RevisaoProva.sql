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

-- Listar todos os nomes, data de nascimento e sexo de todas as pessoas do banco
USE EMPRESA
SELECT F.Pnome AS 'Nome',  
	F.Datanasc AS 'Data Nascimento', 
	F.Sexo AS 'Sexo'
FROM FUNCIONARIO AS F

UNION 

SELECT D.Nome_dependente AS 'Nome', 
	D.Datanasc AS 'Data Nascimento', 
	D.Sexo AS 'Sexo'
FROM DEPENDENTE AS D

-- Criação de Variáveis 
-- Exibir uma mensagema na tela do sálario do funcionario criando duas variáveis 
DECLARE @nomeFuncionario VARCHAR(50),
		@salarioFuncionario DECIMAL(10,2)
SET @nomeFuncionario = 'Alice' 

SELECT @salarioFuncionario  = F.Salario
FROM FUNCIONARIO AS F
WHERE @nomeFuncionario = F.Pnome

PRINT	'O(a) Funcionario(a) ' +
		+@nomeFuncionario +
		' recebe R$: ' +
		CAST(@salarioFuncionario AS VARCHAR(10));

-- Verifique se o salario do funcionario esta acima, abaixo ou na média salarial dos funcionarios da empresa e exiba uma mensagem como resultado
DECLARE @salario DECIMAL(10,2),
		@mediaSalarial DECIMAL (10,2),
		@nome VARCHAR(50);

SET @nome = 'Alice';

SELECT @mediaSalarial = AVG(F.Salario)
FROM FUNCIONARIO AS F

SELECT @salario = F.Salario
FROM FUNCIONARIO AS F
WHERE @nome = F.Pnome

PRINT 'Média Salarial: R$ ' + CAST(@mediaSalarial AS VARCHAR(20));

IF (@salario > @mediaSalarial)
	BEGIN
		PRINT	'O(a) ' + @nome + ' recebe um salário acima da média';
	END
ELSE IF (@salario < @mediaSalarial)
	BEGIN
		PRINT	'O(a) ' + @nome + ' recebe um salário a baixo da média';
	END 
ELSE 
	BEGIN
		PRINT	'O(a) ' +@nome + ' recebe uum salário igual a média';
	END

-- Calcular a idade correta de uma pessoa do banco 

GO 

DECLARE @idade INT,
		@dataNascimento DATE,
		@nome VARCHAR(50);

SET @nome = 'Alice'

SELECT @dataNascimento = F.Datanasc
FROM FUNCIONARIO AS F
WHERE F.Pnome = @nome

IF(MONTH(GETDATE()) < MONTH(@dataNascimento))
	BEGIN 
		SET @idade = DATEDIFF(YEAR, @dataNascimento, GETDATE()) -1;
	END 
ELSE IF(MONTH(GETDATE()) = MONTH(@dataNascimento)) AND DAY(GETDATE()) < DAY(@dataNascimento)
	BEGIN 
		SET @idade = DATEDIFF(YEAR, @dataNascimento, GETDATE()) -1;
	END 
ELSE 
	BEGIN 
		SET @idade = DATEDIFF(YEAR, @dataNascimento, GETDATE())
	END

SELECT @idade AS 'Idade'

GO 

-- Pegar todos os funcionarios e declarar se ele ganha bem ou pouco com SWITCH CASE 
-- > 0 AND < 10000 baixo
-- < 30.000 medio
-- > 30.000 ganha bem 
SELECT
	F.Pnome,
	F.Unome,
	F.Salario,
	CASE 
		WHEN F.Salario <= 10000 AND F.Salario > 0 THEN 'Baixo'
		WHEN F.Salario > 10000 AND F.Salario <= 30000 THEN 'Médio'
		WHEN F.Salario > 30000 THEN 'Alto'
		ELSE 'Erro!'
	END AS 'Categoria Salarial'
FROM FUNCIONARIO AS F

-- Contagem de 1 a 9 
DECLARE @valor INT
SET @valor = 0;

WHILE @valor < 10
	BEGIN 
		SET @valor = @valor + 1
		PRINT 'Numero: ' + CAST(@valor AS VARCHAR (10))
	END 

	GO

-- Mostrar apenas numeros pares
-- Contagem de 1 a 9 
DECLARE @valor INT
SET @valor = 0;

WHILE @valor < 10
	BEGIN 
		SET @valor = @valor + 1
		IF(@valor % 2 = 0)
			PRINT 'Numero: ' + CAST(@valor AS VARCHAR (10))
	END 	

GO

-- Funções 
-- Função que recebe uma cpf e retorna os projetos que aquele cpf trabalha
GO

CREATE OR ALTER FUNCTION fn_ProjetosPorFuncionario(@cpf CHAR(11))
RETURNS TABLE
AS
RETURN(
SELECT	P.Projnome AS 'Nome Projeto', 
		P.Projnumero AS 'Numero Projeto'
FROM TRABALHA_EM AS T
JOIN PROJETO AS P
	ON T.Pnr = P.Projnumero
WHERE T.Fcpf = @cpf
)

GO

SELECT * FROM dbo.fn_ProjetosPorFuncionario('12345678966');

GO

-- Função que recebe um cpf e retorne uma tabela com o nome e parentescos de seus dependentes 
CREATE OR ALTER FUNCTION fn_ListarDependentes(@cpf CHAR(11))
RETURNS TABLE 
AS
RETURN(
SELECT D.Nome_dependente AS 'Nome', D.Parentesco AS 'Parentesco'
FROM DEPENDENTE AS D
WHERE @cpf = D.Fcpf
);

GO

SELECT * FROM dbo.fn_ListarDependentes('12345678966');

GO

-- Função que recebe um cpf e retorna se essa pessoa ganha mais que seu superior ou não, retornar 1 se sim e 0 se não
CREATE OR ALTER FUNCTION fn_ganhaMaisQueSuperior(@cpf CHAR(11))
RETURNS INT 
AS 
BEGIN
	DECLARE @resultado INT,
			@salarioFuncionario DECIMAL(10,2),
			@salarioSuperior DECIMAL(10,2);

	SELECT	@salarioFuncionario = F.Salario,
			@salarioSuperior = S.Salario
	FROM FUNCIONARIO AS F
	JOIN FUNCIONARIO AS S
		ON F.Cpf_supervisor = S.Cpf
	WHERE F.Cpf = @cpf

	IF(@salarioFuncionario > @salarioFuncionario)
		SET @resultado = 1;
	ELSE 
		SET @resultado = 0;
	
	RETURN @resultado;

END;

GO 

SELECT dbo.fn_ganhaMaisQueSuperior('12345678966');

GO 

-- Crie uma função que receba a data de nascimento de um funcionario e retorne em que ano ele podera se aposentar (65 anos se aposenta)
CREATE OR ALTER FUNCTION fn_anoAposentadoria(@dataNascimento DATE)
RETURNS INT
AS
BEGIN
	DECLARE @idade INT,
			@anosRestantes INT,
			@anoAposentadoria INT;

	SELECT @idade = DATEDIFF(YEAR, @dataNascimento, GETDATE())
	FROM FUNCIONARIO AS F
	IF(@idade < 65)
		SET @anosRestantes = 65 - @idade;
	ELSE IF(@idade > 65)
		SET @anosRestantes = 0;
	ELSE 
		SET @anosRestantes = 0;

	SET @anoAposentadoria = YEAR(GETDATE()) + @anosRestantes

	RETURN @anoAposentadoria;

END;
			
GO

SELECT dbo.fn_anoAposentadoria('2000-05-10');

GO

-- Função que recebe um numero de departamento e retorna uma tabela com os funcionarios desse departamento
-- nome, salario, posicao no ranking de salarios
CREATE OR ALTER FUNCTION fn_rankingSalarioDepartamento(@numeroDepartamento INT)
RETURNS TABLE
AS 
RETURN(
SELECT	F.Pnome AS 'Nome', 
		F.Unome AS 'Sobrenome',
		F.Salario AS 'Salario',
		ROW_NUMBER() OVER (ORDER BY F.Salario DESC) AS 'Posição Ranking'
FROM DEPARTAMENTO AS D
JOIN FUNCIONARIO AS F
	ON D.Dnumero = F.Dnr
WHERE @numeroDepartamento = D.Dnumero
);

GO

SELECT * FROM dbo.fn_rankingSalarioDepartamento(5);   

GO

-- Recebe o numero do departamento e retorna a soma de todos os salarios 
CREATE OR ALTER FUNCTION fn_custoDepartamento(@numero INT)
RETURNS INT
AS 
BEGIN 
	DECLARE @somaSalarios INT;

	SELECT @somaSalarios = SUM(F.Salario)
	FROM DEPARTAMENTO AS D
	JOIN FUNCIONARIO AS F
		ON D.Dnumero = F.Dnr
	WHERE D.Dnumero = @numero

	RETURN @somaSalarios;
END;

GO

SELECT dbo.fn_custoDepartamento(5);

GO

-- Função recebe um CPF e retorna uma String concatenada com os nomes de seus dependentes 
CREATE OR ALTER FUNCTION fn_nomeDependentesFuncionario(@cpf CHAR(11))
RETURNS VARCHAR(MAX)
AS 
BEGIN 
	DECLARE @nomesDependentes VARCHAR(MAX);

	SELECT @nomesDependentes = STRING_AGG(D.Nome_dependente, ',')
	FROM DEPENDENTE AS D
	WHERE D.Fcpf = @cpf;

	RETURN @nomesDependentes;
END;

GO

SELECT dbo.fn_NomeDependentesFuncionario('12345678966');

GO 

-- Stored Procedure 
-- Crie um procedure que permita inserir uma nova categoria na tabela 'Categoria'
USE BIBLIOTECA

GO

CREATE OR ALTER PROCEDURE sp_inserirCategoria (@tipoCategoria VARCHAR(50))
AS 
BEGIN 
	INSERT INTO CATEGORIA (tipo_categoria)
	VALUES (@tipoCategoria)
END;

GO

EXEC sp_inserirCategoria 'Terror';

GO

-- Mudar dados do livro pelo isbn
CREATE OR ALTER PROCEDURE sp_atualizarDadosLivro(@isbn VARCHAR(50), @titulo VARCHAR(100), @ano INT)
AS 
BEGIN 
	UPDATE LIVRO
	SET titulo = @titulo,
		ano = @ano
	WHERE @isbn = isbn;
END;

GO

EXEC sp_atualizarDadosLivro '8532511015',
							'Harry Potter e a Pedra Filosofal',
							 2001;

GO 

-- Adicionar um novo autor a tabela autor
CREATE OR ALTER PROCEDURE sp_adicionarAutor(@nomeAutor VARCHAR(100), @nacionalidade VARCHAR(50))
AS 
BEGIN
	INSERT INTO AUTOR (nome, nacionalidade)
	VALUES (@nomeAutor, @nacionalidade); 
END;

GO

EXEC sp_adicionarAutor 'Wilson', 'Brasileiro'; 

GO 

CREATE OR ALTER PROCEDURE sp_removerAutor(@id INT)
AS 
BEGIN
	DELETE FROM AUTOR
	WHERE id = @id;

	DELETE FROM LivroAutor
	WHERE fk_autor = @id;
END;

GO

EXEC sp_removerAutor 6;

GO

-- Recebe o nome de uma categoria e retorna os livros que tem dela 
CREATE OR ALTER PROCEDURE sp_retornaLivrosCategoria(@nomeCategoria VARCHAR(100))
AS 
BEGIN
	SELECT L.isbn AS 'ISBN', L.titulo AS 'Titulo'
	FROM CATEGORIA AS C
	JOIN LIVRO AS L
		ON C.id = L.fk_categoria
	WHERE C.tipo_categoria = @nomeCategoria;
END 

GO

EXEC sp_retornaLivrosCategoria 'Literatura Juvenil';

GO

-- Procedure para listar livros que não possuem editora	especificada 
CREATE OR ALTER PROCEDURE sp_listarLivrosSemEditora 
AS 
BEGIN
	SELECT L.titulo AS 'Titulo Livro', L.isbn AS 'ISBN'
	FROM LIVRO AS L
	WHERE L.fk_editora IS NULL;
END;

GO

EXEC sp_listarLivrosSemEditora;

GO

-- Procedure para remover um autor da lista de autores de um livro 
CREATE OR ALTER PROCEDURE sp_removerAutorLivro(@isbn VARCHAR(50), @idAutor	INT)
AS 
BEGIN 
	DELETE FROM LivroAutor
	WHERE	fk_livro = @isbn 
			AND fk_autor = @idAutor;
END;

GO

EXEC sp_removerAutorLivro
    @isbn = '9781234567890',
    @idAutor = 3;   

		









	





