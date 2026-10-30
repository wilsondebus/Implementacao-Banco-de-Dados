-- Trigger 
-- Exercício 7 
SELECT COUNT(fk_livro) AS 'Numero de Livros'
FROM LivroAutor
WHERE fk_autor = 1;

GO

CREATE TRIGGER trg_for_insert_la
ON LivroAutor 
AFTER INSERT 
AS 
BEGIN 
	DECLARE @id_autor INT, @quantidade_livros INT, @nome_autor VARCHAR(100);
	SELECT @id_autor = I.fk_autor
	FROM inserted AS I;

	SELECT @quantidade_livros = COUNT(fk_livro)
	FROM LivroAutor
	WHERE fk_autor = @id_autor;

	SELECT @nome_autor = nome
	FROM AUTOR AS A
	WHERE A.id = @id_autor

	PRINT 'O Autor'+@nome_autor +' escreveu: '
			+CAST(@quantidade_livros AS VARCHAR(10))
			+' livros'; 
END;

GO 

INSERT INTO Livro
VALUES	('4864644', 'Harry Potter e a Camara Secreta', 2000, 1, 1),
		('15698741', 'Harry Potter e a Relíquias da Morte', 2000, 1, 1);

INSERT INTO LivroAutor
VALUES (1, '15698741');