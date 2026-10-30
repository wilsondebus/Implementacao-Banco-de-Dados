-- Gerenciamento de Acessos

USE [master]
GO
CREATE LOGIN [Juca] WITH PASSWORD=N'12345', 
	DEFAULT_DATABASE=[LOJA], 
	CHECK_EXPIRATION=OFF, 
	CHECK_POLICY=OFF
GO
USE [LOJA]
GO
CREATE USER [Juca] FOR LOGIN [Juca]
GO

-- Adicionar permissões 
GRANT SELECT, INSERT ON [DBO].[CATEGORIA] TO Juca; 
GRANT SELECT ON [DBO].[FORNECEDOR] TO Juca;
GRANT SELECT ON [DBO].[PRODUTO] TO Juca; 

-- Negar permissões 
DENY INSERT ON [dbo].[CATEGORIA] TO Juca; 
-- Se eu der um GRANT depois do DENY ele não vai deixar pois o DENY é superior 
-- Tem que remover a permissão com REVOKE e depois dar o GRANT 

-- Remove uma das permissões anteriores (independente de ser de negação ou não)
REVOKE SELECT ON [DBO].[PRODUTO] TO Juca;
REVOKE INSERT ON [DBO].[CATEGORIA] TO Juca;