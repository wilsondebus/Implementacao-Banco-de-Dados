## Aula 14 
## 30/10

### Restrições de Integridade 
    - Consistencia e precisão dos dados
    - A integridade é atingida por meio da aplicação de restrições de Integridade

1) Declarativa 
    - As restrições são parametrizadas durante a criação da estrutura e das tebelas, fazendo uso de chaves primárias, impedindo valores nulos, utilziando tipo e domínio de dados e aplicando regras de Integridade referencial

2) Procedural 
    - É possível fazer o uso de gatilhos (triggers), procedimentos armazanados
    - Geralmente é implemetada por programadores ou analistas especilizados na linguagem e no SGBD

### As cinco principais restrições de Integridade são: 
1) Integridade de Domínio 
    - Tem que garantir que os valores inseridos em uma coluna (ou atributo) pertençam e um conjunto válido e sigam o formato, tipo e intervalos corretos 
        - Tipo de dado no campo 
        - Representação interna do tipo de dado 
        - Presença ou não do dado
        - Intervalores de valores de domínio 
        - Conjunto de valores discretos 

2) Integridade Referencial 
    - Assegura que valores de uma coluna em uma tabela são válidos baseados nos valores de outra tabela relacionada 
    - Por exemplo, não posso adicionar um funconario novo que esta relacionado a um departamento que não existe 
    - DELETE CASCADE: Se um registro for deletado em uma tebela, então, os registros que estão relacionados serão excluidos também 
        - Se tenho uma caneta no meu sistema de vendas, e tenho 500 vendas em 1 anos daquela caneta
        - Se eu excluir a caneta do sistema, vou excluir todas as vendas relacionadas a ela 
    - UPDATE CASCADE: Mesmma coisa do delete porém atualiza os dados 

3) Integridade de Vazio 
    - Informa se a coluna é obrigatória ou opcional, ou seja, se é possível não inserir um valor a uma coluna

4) Integridade de Chave 
    - Os valores inseridos na chave primária devem ser sempre únicos, não admitindo repetições

5) Integridade Definida pelo Usuário 
    - 

