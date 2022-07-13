# Agrupamento com Group By
SELECT COUNT(id_cliente) AS Contagem, cidade_cliente 
FROM cap05.tb_clientes
GROUP BY cidade_cliente
ORDER BY COUNT(id_cliente) DESC;

# Média do valor dos pedidos
SELECT AVG(valor_pedido) AS media
FROM cap05.tb_pedidos;

# Média do valor dos pedidos por cidade (C/ RIGHT JOIN)
SELECT 
	CASE 
		WHEN ROUND(AVG(valor_pedido),2) IS NULL THEN 0
        ELSE ROUND(AVG(valor_pedido),2)
                END AS media, 
        C.cidade_cliente
FROM cap05.tb_pedidos P RIGHT JOIN cap05.tb_clientes C
ON P.id_cliente = C.id_cliente
GROUP BY C.cidade_cliente
ORDER BY media DESC;

# SOMA (total) do valor dos pedidos por cidade com Inner Join
SELECT SUM(valor_pedido) AS total, C.cidade_cliente
FROM cap05.tb_pedidos AS P, cap05.tb_clientes AS C
WHERE P.id_cliente = C.id_cliente
GROUP BY cidade_cliente;

# SOMA (total) do valor dos pedidos por cidade/estado
INSERT INTO `cap05`.`TB_CLIENTES` (`id_cliente`, `nome_cliente`, `endereco_cliente`, `cidade_cliente`, `estado_cliente`)
VALUES (12, "Bill Gates", "Rua 14", "Santos", "SP");

INSERT INTO `cap05`.`TB_CLIENTES` (`id_cliente`, `nome_cliente`, `endereco_cliente`, `cidade_cliente`, `estado_cliente`)
VALUES (13, "Jeff Bezos", "Rua 29", "Osasco", "SP");

INSERT INTO `cap05`.`TB_PEDIDOS` (`id_pedido`, `id_cliente`, `id_vendedor`, `data_pedido`, `id_entrega`, `valor_pedido`)
VALUES (1016, 11, 5, now(), 27, 234.09);

INSERT INTO `cap05`.`TB_PEDIDOS` (`id_pedido`, `id_cliente`, `id_vendedor`, `data_pedido`, `id_entrega`, `valor_pedido`)
VALUES (1017, 12, 4, now(), 22, 678.30);

INSERT INTO `cap05`.`TB_PEDIDOS` (`id_pedido`, `id_cliente`, `id_vendedor`, `data_pedido`, `id_entrega`, `valor_pedido`)
VALUES (1018, 13, 4, now(), 22, 978.30);

SELECT SUM(valor_pedido) AS total, C.cidade_cliente, C.estado_cliente
FROM cap05.tb_pedidos AS P, cap05.tb_clientes AS C
WHERE P.id_cliente = C.id_cliente
GROUP BY C.cidade_cliente, C.estado_cliente
ORDER BY C.estado_cliente;

INSERT INTO `cap05`.`TB_CLIENTES` (`id_cliente`, `nome_cliente`, `endereco_cliente`, `cidade_cliente`, `estado_cliente`)
VALUES (14, "Melinda Gates", "Rua 14", "Barueri", "SP");

INSERT INTO `cap05`.`TB_CLIENTES` (`id_cliente`, `nome_cliente`, `endereco_cliente`, `cidade_cliente`, `estado_cliente`)
VALUES (15, "Barack Obama", "Rua 29", "Barueri", "SP");

# SOMA (total) do valor dos pedidos por cidade e estado com RIGHT JOIN e CASE
SELECT 
	CASE 
		WHEN FLOOR(SUM(valor_pedido)) IS NULL THEN 0 #floor remove as casas decimais
        ELSE FLOOR(SUM(valor_pedido))
                END AS total, 
        C.cidade_cliente,
        C.estado_cliente
FROM cap05.tb_pedidos P RIGHT JOIN cap05.tb_clientes C
ON P.id_cliente = C.id_cliente
GROUP BY C.cidade_cliente, C.estado_cliente
ORDER BY total DESC;

# Desafio - Supondo que a comissão de cada vendedor seja de 10%, quanto cada vendedor ganhou de comissão nas vendas no estado do CE?
# Retorne 0 se não houve ganho de comissão

SELECT
	CASE 
		WHEN ROUND(SUM(valor_pedido * 0.10),2) IS NULL THEN 0
        ELSE ROUND(SUM(valor_pedido * 0.10),2)
	END AS comissao,
    nome_vendedor,
	CASE
		WHEN estado_cliente IS NULL THEN 'Não Atua no CE'
        ELSE estado_cliente
	END AS estado_cliente
FROM cap05.tb_pedidos P INNER JOIN cap05.tb_clientes C RIGHT JOIN cap05.tb_vendedor V
ON P.id_cliente = C.id_cliente 
AND P.id_vendedor = V.id_vendedor 
AND estado_cliente = 'CE'
GROUP BY nome_vendedor, estado_cliente
ORDER BY comissao DESC;

# Número de clientes que fizeram pedidos
SELECT COUNT(DISTINCT id_cliente) FROM cap05.tb_pedidos;

# Nome e cidade do cliente e número de pedidos no CE
SELECT nome_cliente, cidade_cliente, COUNT(id_pedido) AS num_pedidos
FROM cap05.tb_pedidos P, cap05.tb_clientes C
WHERE P.id_cliente = C.id_cliente
AND estado_cliente = 'CE'
GROUP BY nome_cliente, cidade_cliente;

# Desafio - Algum vendedor participou de vendas cujo valor do pedido tenha sido superior a 600 no estado de SP?
SELECT nome_cliente, cidade_cliente, valor_pedido, nome_vendedor
FROM cap05.tb_pedidos P INNER JOIN cap05.tb_clientes C INNER JOIN cap05.tb_vendedor V
ON P.id_cliente = C.id_cliente
AND P.id_vendedor = V.id_vendedor
AND estado_cliente = 'SP'
AND valor_pedido > 600;

# Algum vendedor participou de vendas em que a média do valor_pedido por estado do cliente foi superior a 800?
SELECT estado_cliente, nome_vendedor, CEILING(AVG(valor_pedido)) AS media
FROM cap05.tb_pedidos P INNER JOIN cap05.tb_clientes C INNER JOIN cap05.tb_vendedor V
ON P.id_cliente = C.id_cliente
AND P.id_vendedor = V.id_vendedor
GROUP BY estado_cliente, nome_vendedor
HAVING media > 600 #filtros dos group by para funções de agregação
ORDER BY nome_vendedor;

# Desafio - Qual estado teve mais de 5 pedidos?
SELECT 
	IF(GROUPING(estado_cliente), 'Total Geral', estado_cliente) AS estado_cliente, 
(COUNT(id_pedido)) AS Contagem
FROM cap05.tb_pedidos P INNER JOIN cap05.tb_clientes C
ON P.id_cliente = C.id_cliente
GROUP BY estado_cliente WITH rollup #FUNÇÃO PARA TOTAL NO GROUP BY
HAVING Contagem > 5
ORDER BY Contagem Desc;