# Total NAs na coluna resolution
select resolution, count(*) as total
from cap08.tb_incidentes
group by resolution;

# Tratameno valores NAs
select
	case
		when Resolution = '' then 'OTHER'
        else Resolution
	end as Resolution
from cap08.tb_incidentes;

# Usar Case, mas isso carrega a consulta, ou corrigir o registro na fonte de dados, o que nem sempre é possível

set SQL_SAFE_UPDATES = 0;

update cap08.tb_incidentes
set Resolution = 'OTHER'
where Resolution = '';

set SQL_SAFE_UPDATES = 1;

# Detecção de Outliers

# Usando médio e desvio padrão
select avg(idade) as media_idade, stddev(idade) as devio_padrao_idade
from cap08.tb_criancas;

select avg(idade) as media_idade, stddev(idade) as devio_padrao_idade
from cap08.tb_criancas
where idade < 5;

# Solução seria remover o registro ou imputação de dados (substitui por outro valor válido, como a média sem o outlier)
# Outra alternativa seria usar a mediana. É mais seguro que usar a média, porque afeta menos o resultado final.alter

# Remoção de valor duplicados
# Check de valores duplicados

select PdId, Category, count(*)
from cap08.tb_incidentes_dup
group by PdId, category;

select PdId, Category, count(*) as numero
from cap08.tb_incidentes_dup
group by PdId, category
having numero > 1;


# Pivot Table com SQL, transforma linhas em colunas

	# Opção 1
select 
	id,
    group_concat( if(colID = 1, nome, null) ) as 'nome',
    group_concat( if(colID = 2, nome, null) ) as 'sobrenome',
    group_concat( if(colID = 3, nome, null) ) as 'título'
from cap08.tb_gestores
group by id;
	
    # Opção 2
select
	emp,
    sum( if(recurso = 'email', quantidade, 0) ) as 'emails',
    sum( if(recurso = 'print', quantidade, 0) ) as 'prints',
    sum( if(recurso = 'sms', quantidade, 0) ) as 'sms msgs'
from cap08.tb_recursos
group by emp;

# Desafio - Crie uma query

SELECT * FROM cap08.tb_vendas;

select
    coalesce(empID, 'Total') as empID,
    sum( if(ano = 2020, valor_venda, 0) ) as '2020',
	sum( if(ano = 2021, valor_venda, 0) ) as '2021',
    sum( if(ano = 2022, valor_venda, 0) ) as '2022'
from cap08.tb_vendas
group by empID with rollup;


# Opção 3
select
	id_fornecedor,
    count(if(id_funcionario = 250, id_pedido, null)) as Emp250,
    count(if(id_funcionario = 251, id_pedido, null)) as Emp251,
    count(if(id_funcionario = 252, id_pedido, null)) as Emp252,
    count(if(id_funcionario = 253, id_pedido, null)) as Emp253,
    count(if(id_funcionario = 254, id_pedido, null)) as Emp254
from 
	cap08.tb_pedidos p
where 
	p.id_funcionario between 250 and 254
group by
	id_fornecedor;


# Parsing
# Qual será o valor pago ao funcionário de empID 1 se a comissão for igual a 15%?
select
	empID, 
    greatest(15, comissao) as comissao #greatest retorna o maior valor ou 15, faz um teste... 
from
	cap08.tb_vendas
where 
	empID = 1;
    

select
	empID, 
    round((valor_venda * greatest(15, comissao)) / 100, 0) as valor_comissao #greatest retorna o maior valor ou 15, faz um teste... 
from
	cap08.tb_vendas
where 
	empID = 1;
    
# Qual será o valor pago ao funcionário de empID 1 se a comissão for igual a 2%?
select
	empID, 
    round((valor_venda * least(2, comissao)) / 100, 0) as valor_comissao #least retorna o menor valor ou 2, faz um teste... 
from
	cap08.tb_vendas
where 
	empID = 1;
    
# Vendendores devem ser separados em categorias
# De 3 a 5 de comissão = Categoria 1
# De 5.1 a 7.9 de comissão = Categoria 2
# Igual ou acima de 8 = Categoria 3

	# Opção 1
select
	empID,
    valor_venda,
    case
		when comissao between 2 and 5 then 'Categoria 1'
        when comissao between 5.1 and 7.9 then 'Categoria 2'
        when comissao >= 8 then 'Categoria 3'
	end as 'Categoria'
from cap08.tb_vendas;

	# Opção 2
# Vamos separar os dados em 3 categorias
# Queremos os registros por dia
# Se o valor_acao for entre 0 e 10 queremos o maior num_vendas desse range e chamaremos de Grupo 1
# Se o valor_acao for entre 10 e 100 queremos o maior num_vendas desse range e chamaremos de Grupo 2
# Se o valor_acao for maior que 100 queremos o maior num_vendas desse range e chamaremos de Grupo 3

select
	dia,
    max(case when valor_acao between 0 and 9 then num_vendas else 0 end) as 'Grupo 1',
    max(case when valor_acao between 10 and 99 then num_vendas else 0 end) as 'Grupo 2',
    max(case when valor_acao > 100 then num_vendas else 0 end) as 'Grupo 3'
from cap08.tb_acoes
group by dia;

# Exercícios - Cap08

# Responda os itens abaixo com Linguagem SQL

# 1- Total de vendas
select count(Opportunity_id) as total_vendas from cap08.tb_pipeline_vendas;

# 2- Valor total vendido
select sum(cast(Close_Value as unsigned)) as total_vendido from cap08.tb_pipeline_vendas;

# 3- Número de vendas concluídas com sucesso
select count(Opportunity_id) as total_vendas from cap08.tb_pipeline_vendas
where Deal_Stage = 'Won';

# 4- Média do valor das vendas concluídas com sucesso
select round(avg(Close_Value * 1)) as media_vendas from cap08.tb_pipeline_vendas
where Deal_Stage = 'Won';

# 5- Valor máximo vendido
select max(Close_Value * 1) as maximo_vendas from cap08.tb_pipeline_vendas;

# 6- Valor mínimo vendido entre as vendas concluídas com sucesso
select min(Close_Value * 1) as maximo_vendas from cap08.tb_pipeline_vendas
where Deal_Stage = 'Won';

# 7- Valor médio das vendas concluídas com sucesso por agente de vendas
select Sales_Agent, round(avg(Close_Value * 1)) as media_vendas from cap08.tb_pipeline_vendas
where Deal_Stage = 'Won'
group by Sales_Agent
order by media_vendas desc;

# 8- Valor médio das vendas concluídas com sucesso por gerente do agente de vendas
select 
	V.Manager, 
	round(avg(Close_Value*1)) as media_vendas 
from 
	cap08.tb_pipeline_vendas as P
inner join
	cap08.tb_vendedores as V
on P.Sales_Agent = V.Sales_Agent
where Deal_Stage = 'Won'
group by Manager
order by media_vendas desc;

# 9- Total do valor de fechamento da venda por agente de venda e por conta das vendas concluídas com sucesso
select
	sales_agent,
    account,
    sum(Close_Value * 1) as total
from
	cap08.tb_pipeline_vendas as tbl
where tbl.Deal_Stage = 'Won'
group by Sales_Agent, account
order by Sales_Agent, account;

# 10- Número de vendas por agente de venda para as vendas concluídas com sucesso e valor de venda superior a 1000
select 
	Sales_Agent,
    count(tbl.Close_Value) as total
from
	cap08.tb_pipeline_vendas as tbl
where tbl.Deal_Stage = 'Won' and tbl.Close_Value > 1000
group by tbl.Sales_Agent;


# 11- Número de vendas e a média do valor de venda por agente de vendas
select 
	V.Manager,
    count(Opportunity_ID) as contagem_vendas,
	round(avg(Close_Value)) as media_vendas 
from 
	cap08.tb_pipeline_vendas as P
inner join
	cap08.tb_vendedores as V
on P.Sales_Agent = V.Sales_Agent
where Deal_Stage = 'Won'
group by Manager
order by media_vendas desc;

# 12- Quais agentes de vendas tiveram mais de 30 vendas?
select Sales_Agent, count(Opportunity_ID) as contagem from cap08.tb_pipeline_vendas
group by Sales_Agent
having contagem > 30
order by contagem desc;


