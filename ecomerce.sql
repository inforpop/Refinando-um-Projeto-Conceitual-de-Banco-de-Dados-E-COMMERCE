# Descrição do Desafio

Este desafio de projeto consiste em criar um esquema de banco de dados para um sistema de gerenciamento de pedidos, com um foco especial em diferenciar entre clientes Pessoa Jurídica (PJ) e Pessoa Física (PF), e melhorar as funcionalidades relacionadas a pagamento e entrega.

## Objetivo

Refinar o modelo de banco de dados apresentado anteriormente, incorporando os seguintes requisitos:

1. **Cliente PJ e PF**: Uma conta de cliente deve ser classificada como PJ ou PF, mas não pode conter ambas as informações.
2. **Pagamento**: Permitir o cadastro de múltiplas formas de pagamento para um pedido.
3. **Entrega**: Incluir informações de status e código de rastreio para cada entrega.

## Modelo Conceitual

### Tabelas e Relacionamentos

#### Clientes
- **Clientes**: Tabela que armazena informações comuns a todos os clientes.
- **Clientes_PJ**: Tabela específica para informações de clientes Pessoa Jurídica.
- **Clientes_PF**: Tabela específica para informações de clientes Pessoa Física.

#### Pagamentos
- **Pagamentos**: Tabela que armazena as diferentes formas de pagamento associadas a um pedido.

#### Entregas
- **Entregas**: Tabela que armazena o status e o código de rastreio das entregas.

### Esquema de Banco de Dados

#### Tabela Clientes
```sql
CREATE TABLE Clientes (
    id_cliente INT PRIMARY KEY,
    nome VARCHAR(100),
    endereco VARCHAR(255),
    tipo_cliente CHAR(2) CHECK (tipo_cliente IN ('PJ', 'PF'))
);
```

#### Tabela Clientes_PJ
```sql
CREATE TABLE Clientes_PJ (
    id_cliente INT PRIMARY KEY,
    cnpj VARCHAR(14),
    razao_social VARCHAR(100),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);
```

#### Tabela Clientes_PF
```sql
CREATE TABLE Clientes_PF (
    id_cliente INT PRIMARY KEY,
    cpf VARCHAR(11),
    data_nascimento DATE,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);
```

#### Tabela Pagamentos
```sql
CREATE TABLE Pagamentos (
    id_pagamento INT PRIMARY KEY,
    id_pedido INT,
    forma_pagamento VARCHAR(50),
    valor DECIMAL(10, 2),
    FOREIGN KEY (id_pedido) REFERENCES Pedidos(id_pedido)
);
```

#### Tabela Entregas
```sql
CREATE TABLE Entregas (
    id_entrega INT PRIMARY KEY,
    id_pedido INT,
    status VARCHAR(50),
    codigo_rastreio VARCHAR(100),
    FOREIGN KEY (id_pedido) REFERENCES Pedidos(id_pedido)
);
```

### Relacionamento entre as tabelas

1. **Clientes**: Esta tabela será relacionada tanto com **Clientes_PJ** quanto com **Clientes_PF** para armazenar informações específicas dependendo do tipo de cliente.
2. **Pagamentos**: Cada pedido poderá ter múltiplas formas de pagamento, portanto, a tabela **Pagamentos** estará relacionada à tabela **Pedidos**.
3. **Entregas**: Cada pedido terá uma entrega associada, com status e código de rastreio armazenados na tabela **Entregas**.

### Exemplo de Consulta

Para ilustrar como o esquema pode ser utilizado, aqui está um exemplo de consulta que lista todos os pedidos, formas de pagamento e status de entrega:

```sql
SELECT 
    p.id_pedido,
    c.nome,
    pg.forma_pagamento,
    pg.valor,
    e.status,
    e.codigo_rastreio
FROM 
    Pedidos p
JOIN 
    Clientes c ON p.id_cliente = c.id_cliente
LEFT JOIN 
    Pagamentos pg ON p.id_pedido = pg.id_pedido
LEFT JOIN 
    Entregas e ON p.id_pedido = e.id_pedido;
```

Este modelo conceitual fornece uma estrutura sólida para o gerenciamento de clientes, pagamentos e entregas, atendendo aos requisitos do desafio proposto.
