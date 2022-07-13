# Total de Vendas por ano, por funcionário e total de vendas do ano
select
	ano_fiscal,
    nome_funcionario,
    valor_venda,
    sum(valor_venda) over (partition by ano_fiscal) as total_vendas_ano
from cap_06.tb_vendas
order by ano_fiscal;

# Total de Vendas por ano, por funcionário e total geral
select
	ano_fiscal,
    nome_funcionario,
    valor_venda,
    sum(valor_venda) over () as total_vendas_ano
from cap_06.tb_vendas
order by ano_fiscal;

# Número de vendas por ano, por funcionário e número total de vendas em todos os anos
select
	ano_fiscal,
    nome_funcionario,
    count(*) as num_vendas_ano,
    count(*) over() as num_vendas_geral
from cap_06.tb_vendas
group by ano_fiscal, nome_funcionario
order by ano_fiscal;

# Reescrevendo a última query com subquery
select
	ano_fiscal,
    nome_funcionario,
    count(*) as num_vendas_ano,
    (select count(*) from cap_06.tb_vendas) as num_vendas_geral
from cap_06.tb_vendas
group by ano_fiscal, nome_funcionario
order by ano_fiscal;