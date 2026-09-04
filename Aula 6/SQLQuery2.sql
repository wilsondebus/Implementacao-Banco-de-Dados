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