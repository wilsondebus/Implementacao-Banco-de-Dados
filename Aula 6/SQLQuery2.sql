-- Exibir uma mensagem na tela do salário do funcionário criando duas variaveis 

DECLARE @nomeFuncionario VARCHAR(100),
		@salarioFuncionario DECIMAL(10,2); 
SET @nomeFuncionario = 'Jennifer';

SELECT @salarioFuncionario = F.Salario
FROM FUNCIONARIO AS F
WHERE F.Pnome = @nomeFuncionario;

PRINT	'O funcionario '
		+@nomeFuncionario	
		+ ' tem um salário de: R$ ' 
		+ CAST(@salarioFuncionario AS VARCHAR(10)); -- Converte para varchar 


-- CONVERT 
-- Normalmente utilizado para conversões de datas, "converter data padrão amarecicano para padrão brasileiro"
SET @nomeFuncionario = 'Jennifer';

SELECT @salarioFuncionario = F.Salario
FROM FUNCIONARIO AS F
WHERE F.Pnome = @nomeFuncionario;

PRINT	'O funcionario '
		+@nomeFuncionario	
		+ ' tem um salário de: R$ ' 
		+ CONVERT(VARCHAR(10), @salarioFuncionario*1.1);

-- Condicional IF/ELSE 
DECLARE @mediaSalarial DECIMAL(10,2),
		@nome VARCHAR(100),
		@salario DECIMAL(10,2);
SET @nome = 'Jennifer'; 

SELECT @mediaSalarial = AVG(F.Salario) FROM FUNCIONARIO AS F 
SELECT @salario = F.Salario FROM FUNCIONARIO AS F WHERE @nome = F.Pnome

IF(@salario < @mediaSalarial)
	PRINT	'O funcionario(a) '
			+@nome
			+' ganha abaixo da média'; 
ELSE 
	PRINT	'O funcionario(a) '
			+@nome
			+' ganha acima da média'; 


-- Verificar se um funcionario esta próxio de se aposentar (60 anos)
-- > 56 e > 60 esta próximo 
-- > 60 ja passou do tempo 
DECLARE @idade INT;
SET @nome = 'Jennifer';

SELECT @idade = DATEDIFF(YEAR, F.Datanasc, GETDATE())
    - CASE
        WHEN DATEADD(YEAR, DATEDIFF(YEAR, F.Datanasc, GETDATE()), F.Datanasc) > GETDATE()
        THEN 1
        ELSE 0
      END
FROM FUNCIONARIO AS F
IF(@idade > 56 AND @idade < 60)
	BEGIN 
		PRINT @idade; 
		PRINT 'Esta próximo de se aposentar';
	END 
ELSE IF(@idade = 60)
	BEGIN 
		PRINT @idade;
		PRINT 'Está na idade para se aposentar';
	END 
ELSE IF(@idade > 60)
	BEGIN 
		PRINT @idade;
		PRINT 'Já passou do tempo para se aposentar';
	END
ELSE 
	BEGIN 
		PRINT @idade;
		PRINT 'Está longe de se aposentar';
	END 


-- Calcular a idade correta de uma pessoa do banco
DECLARE @dataNascimento DATE; 
SET @nome = 'Maria'; 

SELECT @dataNascimento = F.Datanasc
FROM FUNCIONARIO AS F 
WHERE @nome = F.Pnome;

IF (MONTH(GETDATE()) < MONTH(@dataNascimento))
	BEGIN 
		SET @idade = DATEDIFF(YEAR, @dataNascimento, GETDATE()) - 1;
	END 
ELSE IF(MONTH(GETDATE()) = MONTH(@dataNascimento) AND DAY(GETDATE()) < DAY(@dataNascimento))
	BEGIN
		SET @idade = DATEDIFF(YEAR, @dataNascimento, GETDATE()) - 1;
	END
ELSE 
	BEGIN 
		SET @idade = DATEDIFF(YEAR, @dataNascimento, GETDATE());
	END

SELECT @idade AS Idade;

-- Pegar todos os funcionarios e declarar se ele ganha bem ou pouco
-- < 20.000 ganha pouco
-- > 20.000 ganha bem 
-- Utilizando IIF só consigo categorizar duas categorias 
SELECT
	F.Pnome,
	F.Unome,
	F.Salario,
	IIF(F.Salario < 20000, 'Salário baixo', 'Salário alto') AS 'Categoria Salarial'
FROM FUNCIONARIO AS F

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

-- Laço de repetição 
-- Loop While 
-- Contagem de 1 a 9
DECLARE @valor INT = 0
-- SET @valor = 0 
-- mesma coisa que declarar o valor da variávrl no início 

WHILE @valor < 10
	BEGIN 
		SET @valor = @valor +1
		IF(@valor % 2 = 0) 
			CONTINUE
		PRINT 'Número ' + CAST(@valor AS VARCHAR(2))
	END 

-- Cursores (não cobra na prova)
DECLARE @nomes VARCHAR(50);

DECLARE @cursorFuncionario CURSOR FOR 
SELECT PNome FROM FUNCIONARIO;

OPEN cursorFuncionario;

FETCH NEXT FROM cursorFuncionario INTO @nome;

WHILE @@FETCH_STATUS = 0
	BEGIN 
		PRINT @nome;
		FETCH NEXT FROM cursorFuncionario INTO @nome
	END

CLOSE cursorFuncionario;
DEALLOCATE cursorFuncionario;