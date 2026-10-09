## 09/10 

## Transações 
- Uma transação em banco de dados é um conjunto de operações que são tratadas como uma única unidade de trabalho
- Uma transação pode ser concluida ou completamente revertida (commit, rollback)

---

### ACID

#### A tomicidade
#### C onssitencia 
#### I solamento 
#### D urabilidade 

---

### Atomicidade:
    - garante que toda transação seja tratada como uma única unidade, ou seja, deve ser completamente concluida ou completamente desfeita 
### Consistencia: 
    - Garante que uma transação çeve o bamco de dados de um estado válido para outro estado válido respeitando todas as regras e restrições 
### Isolamento
    - Garante que as transações sejam executadas de forma isolada, sem que uma transação afete outra
### Durabilidade 
    - Garante que uma vez que uma transação foi confirmada (comiitted), ela permanecerá no banco de dados mesmo que ocorra alguma falha no sistema

---

## COMANDOS RELACIONADOS A TRANSAÇÕES 

### BEGIN TRANSACTION: 
- inicia uma nova transação 
### COMMIT TRANSACTION: 
- confirma a transação, aplicando permanentemente todas as operações feitas no banco de dados 
### ROLLBACK TRANSACTION: 
- desfaz todas as operações realizadas desde o inicio da transação 
### SAVEPOINT: 
- define um ponto dento de uma transaçã para permitir um rolllback parcial, até esse ponto 
