# retornar o id do pedido e nome do cliente
# Inner Join

# Opção 1
SELECT P.id_pedido, C.nome_cliente
FROM cap04.TB_PEDIDOS as P
INNER JOIN cap04.TB_CLIENTES as C
	ON P.id_cliente = C.id_cliente;

# Opção 2
SELECT P.id_pedido, C.nome_cliente
FROM cap04.TB_PEDIDOS as P, cap04.TB_CLIENTES as C
WHERE P.id_cliente = C.id_cliente;

# Desafio Aula
# Retornar id do pedido, nome do cliente e nome do vendedor
#Inner Join com 3 tabelas

# Opção 1
SELECT P.id_pedido, C.nome_cliente, V.nome_vendedor
FROM ((cap04.TB_PEDIDOS as P
INNER JOIN cap04.TB_CLIENTES as C ON P.id_cliente = C.id_cliente)
INNER JOIN cap04.TB_VENDEDOR as V ON P.id_vendedor = V.id_vendedor);

# Opção 2
SELECT P.id_pedido, C.nome_cliente, V.nome_vendedor
FROM cap04.TB_PEDIDOS as P, cap04.TB_CLIENTES as C, cap04.TB_VENDEDOR as V
WHERE P.id_cliente = C.id_cliente
AND P.id_vendedor = P.id_vendedor;    

# LEFT JOIN
SELECT C.nome_cliente, P.id_pedido
FROM cap04.tb_clientes AS C
LEFT JOIN cap04.tb_pedidos AS P
ON C.id_cliente = P.id_cliente;

# RIGHT JOIN
SELECT C.nome_cliente, P.id_pedido
FROM cap04.tb_clientes AS C
RIGHT JOIN cap04.tb_pedidos AS P
ON C.id_cliente = P.id_cliente;

# Exercício - Retornar a data do pedido, o nome do cliente, todos os vendedores, com ou sem pedido associado, e ordernar o resultado pelo nome do cliente
SELECT 
	CASE
		WHEN P.data_pedido IS NULL THEN 'Sem Pedido'
		ELSE P.data_pedido
    END AS data_pedido,
	CASE
		WHEN C.nome_cliente IS NULL THEN 'Sem Pedido'
        ELSE C.nome_cliente
	END AS nome_cliente,
    V.nome_vendedor
FROM ((cap04.tb_pedidos AS P
INNER JOIN cap04.tb_clientes AS C on P.id_cliente = C.id_cliente)
RIGHT JOIN cap04.tb_vendedor AS V on P.id_vendedor = V.id_vendedor)
ORDER BY nome_cliente;