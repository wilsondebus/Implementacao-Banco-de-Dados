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
