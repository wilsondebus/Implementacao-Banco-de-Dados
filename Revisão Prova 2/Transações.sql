-- Revisão 
-- Transaction 

USE EMPRESA
GO
-- Crie uma transação para realizar duas inserções dentro de uma transação: uma na tabela FUNCIONARIO e outra na tabela DEPARTAMENTO. Se a segunda inserção falhar, a primeira será revertida.
BEGIN TRAN
BEGIN TRY 
	INSERT INTO FUNCIONARIO(Pnome, Unome, Cpf, Salario)
	VALUES ('Wilson', 'Debus', '04284945017', 2600);

	INSERT INTO DEPARTAMENTO(Dnome, Dnumero)
	VALUES('Comercial', 5);

	COMMIT TRAN;
	PRINT 'Transação realizada com sucesso';
END TRY 
BEGIN CATCH 
	ROLLBACK TRAN;

	PRINT 'Transação revertida';
	PRINT ERROR_MESSAGE();
END CATCH;

GO


-- Escreva uma transação que tente inserir um funcionário com um Cpf_supervisor que não existe. O banco de dados deve rejeitar a operação, e a transação deve ser revertida.
BEGIN TRAN
BEGIN TRY 
	INSERT FUNCIONARIO(Pnome, Unome, Cpf, Cpf_supervisor)
	VALUES ('Wilson', 'Debus', '11111111111','01010101011');

	COMMIT TRAN;
	PRINT 'Funcionário adicionado com sucesso';
END TRY 
BEGIN CATCH 
	ROLLBACK TRAN;
	PRINT 'Transação Revertida'
	PRINT ERROR_MESSAGE();
END CATCH

GO

-- Implemente uma transação que insira dados em três tabelas diferentes. Use um SAVEPOINT 
-- para marcar um ponto dentro da transação. Se uma parte falhar, reverta apenas até o ponto de salvamento (savepoint) sem desfazer toda a transação.
BEGIN TRAN 
	INSERT INTO DEPARTAMENTO(Dnome, Dnumero)
	VALUES('Comerical', 1619); 

	INSERT INTO DEPENDENTE(Fcpf, Nome_dependente)
	VALUES('04284945017', 'Denise');

	SAVE TRAN ponto_salvo;

	INSERT INTO FUNCIONARIO(Pnome, Unome, Cpf)
	VALUES('Wilson', 'Dias', '04284945017');

	-- Verifica se hiuve erro
	IF @@ERROR <> 0
	BEGIN 
		ROLLBACK ponto_salvo;
		PRINT 'Terceiro insert com erro';

		COMMIT TRAN
	END
	ELSE 
	BEGIN
		COMMIT TRAN 
		PRINT 'Todos inserts foram realizados';
	END;

GO

