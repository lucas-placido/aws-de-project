-- Criar tabela de vendas
CREATE TABLE vendas (
    id SERIAL PRIMARY KEY,
    id_client INTEGER VARCHAR(255),
    produto VARCHAR(255),
    quantidade INTEGER,
    preco_unitario DECIMAL(10, 2),
    data_venda DATE
);