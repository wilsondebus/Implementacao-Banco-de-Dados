### Exercícios dados em aula 

1) Criar uma tabela para guardar todas as alterações
   - de salário sofridas por um funcionário
   - crie triggers para guardar nessa tabela informações sobre essas alterações (id, cpf, salario anterior, data e hora)

2) Crie uma nova coluna na tabela departamento chamada de status
   - Agora crie um trigger que impeça o usuário de deletar um departamento já existente, ou seja, ao invés de deletar o departamento altere o valor da coluna de status para '0'.

3) Crie um trigger que seja disparado depois que uma operação de inserção, update ou deleção ocorra na tabela FUNCIONARIO
   - Esse trigger deve:
       - Registrar CPF do novo funcionario inserido, alterado ou deletado e a operação realizada ("INSERT, DELETE, UPDATE") em uma tabela de log (Log Funcionario), juntamente com a data e hora da inserção. Esse trigger ajudará a manter um histórico das inserções realizadas na tabela de funcionários.  
