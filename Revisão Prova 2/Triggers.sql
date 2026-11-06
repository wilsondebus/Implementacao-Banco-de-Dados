-- Exercícios Tiggers 

USE BIBLIOTECA;

GO

-- Exercício 1
-- Crie um trigger que impeça a inserção de livros com o mesmo Titulo na tabela Livro
CREATE OR ALTER TRIGGER trg_insteadof_insert_livro
ON LIVRO 
INSTEAD OF INSERT -- usar instead of pois primeiro tem que verificar se o titulo existe depois permitir a inserção
AS 
BEGIN 
	DECLARE @titulo VARCHAR(100);

	SELECT @titulo = I.titulo	
	FROM inserted AS I;

	IF EXISTS (SELECT * FROM Livro WHERE titulo = @titulo)
		RAISERROR('Já existe um livro com esse título', 16, 1);
		
	ELSE 
		INSERT INTO Livro (isbn, titulo, ano, fk_editora, fk_categoria)
		SELECT I.isbn, I.titulo, I.ano, I.fk_editora, I.fk_categoria -- serve para recuperar os dados
		FROM inserted AS I;
END;

GO

-- Tentando inserir um livro com título já existente
INSERT INTO Livro
VALUES ('123456789', 'Harry Potter e A Pedra Filosofal', 2000, 1, 1);

-- Inserindo um livro com título diferente
INSERT INTO Livro
VALUES ('987654321', 'Novo Livro', 2026, 1, 1);

GO



-- Exer 2
-- Crie um trigger que atualize automaticamente o ano de publicação na tabela Livro para o ano atual quando um novo livro é inserido
CREATE OR ALTER TRIGGER trg_after_ano_publicacao
ON Livro
AFTER INSERT 
AS 
BEGIN 
	UPDATE Livro 
	set ano = YEAR(GETDATE())
	WHERE isbn IN (SELECT I.isbn FROM inserted AS I);
END;

GO
-- Insere um livro com o ano de 2020
INSERT INTO Livro
VALUES ('123456789', 'Livro Teste', 2020, 1, 1);
-- Verifica se o ano foi atualizado
SELECT * FROM Livro
WHERE isbn = '123456789';


GO 

-- Exer 3
-- Crie um trigger que exclua automaticamente registros da tabela LivroAutor quando o livro correspondente é excluído da tabela Livro
CREATE OR ALTER TRIGGER trg_insteadof_excluir_registro
ON Livro
INSTEAD OF DELETE 
AS 
BEGIN 
	-- Exclui os registros dos autores
	DELETE FROM LivroAutor
	WHERE fk_livro IN (SELECT isbn FROM deleted); 

	DELETE FROM Livro
	WHERE isbn IN (SELECT isbn FROM deleted);

END;

GO
-- Exclui um livro
DELETE FROM Livro
WHERE isbn = '8532511015';

GO


-- Exer 5
-- Crie um trigger que restrinja a exclusão de categorias na tabela Categoria se houver livros associados a essa categoria.
CREATE OR ALTER TRIGGER trg_insteadof_restringir_exclusao
ON Categoria 
INSTEAD OF DELETE 
AS 
BEGIN 
	IF EXISTS (
		SELECT *
		FROM Livro, deleted
		WHERE Livro.fk_categoria = deleted.id
	)

		RAISERROR('Não é possível excluir uma categoria com livros associados', 16,1);

	ELSE 
		DELETE FROM Categoria
		WHERE id IN (SELECT id FROM deleted); -- Verifica se o id da categoria esta no id que foi tentado deletar 
END;
GO

-- Tenta excluir uma categoria que possui livros
DELETE FROM Categoria
WHERE id = 1;


-- Exer 6
-- Crie um trigger que registre em uma tabela de auditoria sempre que um livro for atualizado na tabela Livro.
CREATE TABLE LOG_LIVRO(
	log_id INT IDENTITY(1,1) PRIMARY KEY,
	isbn VARCHAR(50),
	operacao VARCHAR(100),
	data_hora DATETIME DEFAULT GETDATE()
);

GO

CREATE OR ALTER TRIGGER trg_after_resgistrar_mudanca
ON Livro 
AFTER UPDATE 
AS 
BEGIN
	INSERT INTO LOG_LIVRO(isbn, operacao)
	SELECT I.isbn, 'Update'
	FROM inserted AS I; 
END;

GO
-- Atualiza o título de um livro
UPDATE Livro
SET titulo = 'Harry Potter e a Pedra Filosofal'
WHERE isbn = '8532511015';
SELECT * FROM LOG_LIVRO

GO 

-- Exer 7
-- Crie um trigger que calcule automaticamente o número total de livros escritos por um autor na tabela Autor sempre que um novo livro é associado a esse autor na tabela LivroAutor
ALTER TABLE AUTOR 
ADD total_livros INT DEFAULT 0 NOT NULL;

-- Conta os livros que cada autor já possui
UPDATE Autor
SET total_livros = (
    SELECT COUNT(*)
    FROM LivroAutor
    WHERE LivroAutor.fk_autor = Autor.id
);

GO

CREATE OR ALTER TRIGGER trg_after_calcular_livros
ON LivroAutor
AFTER INSERT 
AS 
BEGIN 
	UPDATE Autor
	SET total_Livros = (
		SELECT COUNT(*)
		FROM LivroAutor
		WHERE LivroAutor.fk_autor = Autor.id
	)
	WHERE id IN (SELECT fk_autor FROM inserted);
END;
GO

-- Verifica a quantidade de livros dos autores
SELECT * FROM Autor;
-- Associa outro livro ao autor de ID 1
INSERT INTO LivroAutor (fk_livro, fk_autor)
VALUES ('9788578270698', 1);

GO
-- Exer 15
-- Trigger que impede atualizar o título para um que contenha "proibido"
CREATE OR ALTER TRIGGER trg_update_titulo_livro
ON Livro
AFTER UPDATE
AS
BEGIN
    -- Verifica se o novo título contém a palavra "proibido"
    IF EXISTS (
        SELECT *
        FROM inserted
        WHERE titulo LIKE '%proibido%'
    )
    BEGIN
        -- Restaura o título anterior do livro
        UPDATE Livro
        SET titulo = D.titulo
        FROM Livro AS L
        JOIN deleted AS D
        ON L.isbn = D.isbn
        WHERE L.isbn IN (
            SELECT isbn
            FROM inserted
            WHERE titulo LIKE '%proibido%'
        );

        PRINT 'Título proibido! O título anterior foi restaurado.';
    END
END;
GO

DROP TRIGGER trg_insteadof_excluir_registro;
GO
-- Exer 11
-- Crie um trigger que, quando um livro for excluído da tabela Livro, verifique se há
-- outros livros escritos pelo mesmo autor e, se não, remova automaticamente o autor
-- da tabela Autor.
CREATE OR ALTER TRIGGER trg_verificar_quantidade
ON LIVRO
INSTEAD OF DELETE 
AS
BEGIN 
	DECLARE @id_autor INT;

	SELECT @id_autor = LA.fk_autor
	FROM LivroAutor AS LA
	JOIN deleted AS D
	ON LA.fk_livro = D.isbn;

	DELETE FROM LIVROAUTOR
	WHERE fk_livro IN (SELECT isbn FROM deleted);

	DELETE FROM LIVRO 
	WHERE isbn IN (SELECT isbn FROM deleted);

	IF NOT EXISTS (SELECT * FROM LivroAutor WHERE fk_autor = @id_autor)
	BEGIN
		DELETE FROM AUTOR 
		WHERE id = @id_autor;

		PRINT 'Autor excluido por não possuir mais livros';
	END 
END;

GO 

-- Exclui o livro e executa automaticamente o trigger
DELETE FROM Livro
WHERE isbn = '9788577343348';
GO

-- Exer 18
-- Crie um trigger que registre automaticamente todas as atualizações de livros na
-- tabela LogAtualizacaoLivros com detalhes sobre o livro atualizado, data e hora.
CREATE TABLE LogAtualizacaoLivros (
	log_id INT IDENTITY(1,1) PRIMARY KEY,
	isbn VARCHAR(50),
	titulo_antigo VARCHAR(50),
	titulo_novo VARCHAR(50),
	ano_antigo INT,
	ano_novo INT,
	data_hora DATETIME DEFAULT GETDATE()
);
GO
CREATE OR ALTER TRIGGER trg_log_atualizacao_livros
ON LIVRO
AFTER UPDATE
AS 
BEGIN
	INSERT INTO LogAtualizacaoLivros 
	(isbn, titulo_antigo, titulo_novo, ano_antigo, ano_novo)
	SELECT	I.isbn,
			D.titulo,
			I.titulo,
			D.ano,
			I.ano
	FROM inserted AS I
	JOIN deleted AS D
	ON I.isbn = D.isbn
END;
GO

-- Atualiza um livro
UPDATE Livro
SET titulo = 'Harry Potter - Nova Edição',
    ano = 2026
WHERE isbn = '8532512062';
-- Verifica se a atualização foi registrada
SELECT * FROM LogAtualizacaoLivros;