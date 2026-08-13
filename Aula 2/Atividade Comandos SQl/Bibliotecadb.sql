CREATE DATABASE Biblioteca; 

SHOW DATABASES;

USE Biblioteca; 

CREATE TABLE Autor (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100),
    Nacionalidade VARCHAR(100)
);

CREATE TABLE Categoria (
	Codigo INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Descricao VARCHAR(100)
);

CREATE TABLE Livro (
	ISBN VARCHAR(20) NOT NULL PRIMARY KEY,
    Titulo VARCHAR(100),
    Ano INT,
    Editora VARCHAR(100),
    fk_Autor_ID INT,
    FOREIGN KEY (fk_autor_ID)
		REFERENCES Autor(ID)
);

CREATE TABLE LivroCategoria_Pertence (
	fk_Livro_ISBN VARCHAR(20) NOT NULL,
    fk_Categoria_Codigo INT NOT NULL,
    Descricao VARCHAR(100),
    
    PRIMARY KEY (fk_Livro_ISBN, fk_Categoria_Codigo),
    
    FOREIGN KEY (fk_Livro_ISBN)
		REFERENCES Livro(ISBN),
	
    FOREIGN KEY (fk_Categoria_Codigo)
		REFERENCES Categoria(Codigo)
);

SHOW TABLES; 

INSERT INTO Autor (Nome, Nacionalidade) VALUES
('J. K. Rowling', 'Inglaterra'),
('Clive Staples Lewis', 'Inglaterra'),
('Affonso Solano', 'Brasil'),
('Marcos Piangers', 'Brasil'),
('Ciro Botelho - Tiririca', 'Brasil'),
('Bianca Mól', 'Brasil');

INSERT INTO Categoria (Descricao) VALUES
('Literatura Juvenil'),
('Ficção Científica'),
('Humor');

INSERT INTO Livro (ISBN, Titulo, Ano, Editora, fk_Autor_ID) VALUES
('8532511015', 'Harry Potter e A Pedra Filosofal', 2000, 'Rocco', 1),
('9788578270698', 'As Crônicas de Nárnia', 2009, 'Wmf Martins Fontes', 2),
('9788577343348', 'O Espadachim de Carvão', 2013, 'Casa da Palavra', 3),
('9788581742458', 'O Papai É Pop', 2015, 'Belas Letras', 4),
('9788582302026', 'Pior Que Tá Não Fica', 2015, 'Matrix', 5),
('9788577345670', 'Garota Desdobrável', 2015, 'Casa da Palavra', 6),
('8532512062', 'Harry Potter e o Prisioneiro de Azkaban', 2000, 'Rocco', 1);

INSERT INTO LivroCategoria_Pertence
(fk_Livro_ISBN, fk_Categoria_Codigo, Descricao)
VALUES
('8532511015', 1, 'Literatura Juvenil'),
('9788578270698', 1, 'Literatura Juvenil'),
('9788577343348', 2, 'Ficção Científica'),
('9788581742458', 3, 'Humor'),
('9788582302026', 3, 'Humor'),
('9788577345670', 1, 'Literatura Juvenil'),
('8532512062', 1, 'Literatura Juvenil');

SELECT * FROM Autor;
SELECT * FROM Categoria;
SELECT * FROM Livro;
SELECT * FROM LivroCategoria_Pertence;

-- Exercício 7 
SELECT *
FROM Livro
ORDER BY Titulo;

-- Exercício 8 
SELECT Livro.*, Autor.Nome, Autor.Nacionalidade
FROM Livro, Autor
WHERE Livro.fk_Autor_ID = Autor.ID
ORDER BY Autor.Nome;

-- Exercício 9 
SELECT Livro.*, Categoria.Descricao
FROM Livro, LivroCategoria_Pertence, Categoria
WHERE Livro.ISBN = LivroCategoria_Pertence.fk_Livro_ISBN
AND LivroCategoria_Pertence.fk_Categoria_Codigo = Categoria.Codigo
AND Categoria.Descricao = 'Literatura Juvenil'
ORDER BY Livro.Ano;

-- Exercício 10 
SELECT Livro.*, Categoria.Descricao
FROM Livro, LivroCategoria_Pertence, Categoria
WHERE Livro.ISBN = LivroCategoria_Pertence.fk_Livro_ISBN
AND LivroCategoria_Pertence.fk_Categoria_Codigo = Categoria.Codigo
AND Categoria.Descricao IN ('Humor', 'Ficção Científica')
AND Livro.Ano BETWEEN 2000 AND 2010;