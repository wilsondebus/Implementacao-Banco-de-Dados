USE EMPRESA

SELECT *
FROM FUNCIONARIO

GO

-- Exercício funções 

-- Exer 1
-- Crie uma função que receba o cpf de um funcionario e retorne os nomes dos projetos nos quais ele trabalha
CREATE OR ALTER FUNCTION fn_ProjetosPorFuncionario(@cpf CHAR(11))
RETURNS TABLE 
AS 
RETURN(
	SELECT 
		T.Fcpf,
		P.Projnome
	FROM TRABALHA_EM AS T	
	JOIN PROJETO AS P
		ON T.Pnr = P.Projnumero
	WHERE T.Fcpf =  @cpf
) 

GO 

SELECT * FROM dbo.fn_ProjetosPorFuncionario('12345678966'); 

GO

-- Exer 2
CREATE OR ALTER FUNCTION fn_ListarDependentes(@cpf CHAR(11))
RETURNS TABLE
AS 
RETURN 
(
	SELECT 
		Nome_dependente, 
		Parentesco
	FROM DEPENDENTE
	WHERE Fcpf = @cpf
); 

GO

SELECT * FROM fn_ListarDependentes('3334455587');

GO

-- Exer 3
CREATE OR ALTER FUNCTION fn_NomeSupervisor(@cpf CHAR(11))
RETURNS VARCHAR(50)
AS
BEGIN
    DECLARE @NomeSupervisor VARCHAR(50);

    SELECT @NomeSupervisor = S.Pnome + ' ' + S.Unome
    FROM FUNCIONARIO AS F
    JOIN FUNCIONARIO AS S
        ON F.Cpf_supervisor = S.Cpf
    WHERE F.Cpf = @cpf;

    RETURN @NomeSupervisor;
END;

GO 

SELECT dbo.fn_NomeSupervisor('12345678966') AS Supervisor;

GO 

-- Exer 4
CREATE OR ALTER FUNCTION fn_GanhaMaisQueSupervisor(@cpf CHAR(11))
RETURNS INT
AS
BEGIN
    DECLARE @Resultado INT;

    SELECT @Resultado =
        CASE
            WHEN F.Salario > S.Salario THEN 1
            ELSE 0
        END
    FROM FUNCIONARIO AS F
    JOIN FUNCIONARIO AS S
        ON F.Cpf_supervisor = S.Cpf
    WHERE F.Cpf = @cpf;

    RETURN ISNULL(@Resultado, 0);
END;

GO 

SELECT dbo.fn_GanhaMaisQueSupervisor('12345678966') AS GanhaMais;

GO

-- Exer 5 
CREATE OR ALTER FUNCTION fn_AnoAposentadoria(@DataNascimento DATE)
RETURNS INT
AS
BEGIN
    DECLARE @Ano INT;

    SET @Ano = YEAR(DATEADD(YEAR, 65, @DataNascimento));

    RETURN @Ano;
END;

GO

SELECT dbo.fn_AnoAposentadoria('1965-01-09') AS AnoAposentadoria;

GO

-- Exercicios Procedimentos 
-- Exer 1

USE BIBBLIOTECA

GO

CREATE OR ALTER PROCEDURE sp_InserirCategoria
    @tipo_categoria VARCHAR(50)
AS
BEGIN
    INSERT INTO Categoria (tipo_categoria)
    VALUES (@tipo_categoria);
END;
GO

GO

EXEC sp_InserirCategoria 'Terror';

GO

-- Exer 2
CREATE OR ALTER PROCEDURE sp_AtualizarLivro
    @isbn VARCHAR(50),
    @titulo VARCHAR(100),
    @ano INT
AS
BEGIN
    UPDATE Livro
    SET titulo = @titulo,
        ano = @ano
    WHERE isbn = @isbn;
END;

GO

EXEC sp_AtualizarLivro
    '8532511015',
    'Harry Potter e a Pedra Filosofal',
    2001;

GO 

-- Exer 3
CREATE OR ALTER PROCEDURE sp_InserirAutor
    @nome VARCHAR(100),
    @nacionalidade VARCHAR(50)
AS
BEGIN
    INSERT INTO Autor (nome, nacionalidade)
    VALUES (@nome, @nacionalidade);
END;
GO

EXEC sp_InserirAutor 'George Orwell', 'Inglaterra';

GO 

-- Exer 4
CREATE OR ALTER PROCEDURE sp_ExcluirAutor
    @idAutor INT
AS
BEGIN
    DELETE FROM LivroAutor
    WHERE fk_autor = @idAutor;

    DELETE FROM Autor
    WHERE id = @idAutor;
END;
GO

EXEC sp_ExcluirAutor 6;

GO

-- Exer 5 
CREATE OR ALTER PROCEDURE sp_LivrosPorCategoria
    @nomeCategoria VARCHAR(50)
AS
BEGIN
    SELECT
        L.isbn,
        L.titulo,
        L.ano,
        C.tipo_categoria
    FROM Livro AS L
    JOIN Categoria AS C
        ON L.fk_categoria = C.id
    WHERE C.tipo_categoria = @nomeCategoria;
END;
GO

EXEC sp_LivrosPorCategoria 'Literatura Juvenil';

