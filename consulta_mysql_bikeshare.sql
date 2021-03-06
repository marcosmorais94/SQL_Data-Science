# Duração total do aluguel das bikes (em horas)
select sum(duracao_segundos/60/60) as duracao_total_horas
from cap_06.tb_bikes;

# Duração total do aluguel das bikes (em horas), ao longo do tempo (soma acumulada)
select duracao_segundos,
	sum(duracao_segundos/60/60) over (order by data_inicio) as duracao_total_horas
from cap_06.tb_bikes;

# Duração total do aluguel das bikes (em horas), ao longo do tempo, por estação de início do aluguel da bike
# quando a data de início foi anterior a '2012-01-08'
select 	estacao_inicio,
		duracao_segundos,
		sum(duracao_segundos/60/60) over (partition by estacao_inicio order by data_inicio) as duracao_total_horas
from cap_06.tb_bikes
where data_inicio < '2012-01-08';

# Qual a média de tempo (em horas) de aluguel da estação de início 31017, ao longo do tempo (média móvel)?
select estacao_inicio,
	avg(duracao_segundos/60/60) over (partition by estacao_inicio order by data_inicio) as media_tempo_aluguel
from cap_06.tb_bikes
where numero_estacao_inicio = 31017;

# DESAFIO - Retornar:
# Estação de início, data de início e duração de cada aluguel de bike em segundos
select estacao_inicio, data_inicio, duracao_segundos
from cap_06.tb_bikes;

# Duração total de aluguel das bikes ao longo do tempo por estação de início
select 
	estacao_inicio, 
	data_inicio, 
	duracao_segundos,
	sum(duracao_segundos) over (partition by estacao_inicio order by data_inicio) as duracao_total
from cap_06.tb_bikes;

# Duração média do aluguel de bikes ao longo do tempo por estaçao de início
select 
	estacao_inicio, 
	data_inicio, 
	duracao_segundos,
	sum(duracao_segundos) over (partition by estacao_inicio order by data_inicio) as duracao_total,
	avg(duracao_segundos) over (partition by estacao_inicio order by data_inicio) as duracao_media
from cap_06.tb_bikes;

# Número de aluguéis de bikes por estação ao longo do tempo
select 
	estacao_inicio, 
	data_inicio, 
	duracao_segundos,
	sum(duracao_segundos) over (partition by estacao_inicio order by data_inicio) as duracao_total,
	avg(duracao_segundos) over (partition by estacao_inicio order by data_inicio) as duracao_media,
    count(data_inicio) over (partition by estacao_inicio order by data_inicio) as quantidade_aluguel
from cap_06.tb_bikes;

# Somente os registros quando a data de início for inferior a '2012-01-08'
select 
	estacao_inicio, 
	data_inicio, 
	duracao_segundos,
	sum(duracao_segundos/60/60) over (partition by estacao_inicio order by data_inicio) as duracao_total,
	avg(duracao_segundos/60/60) over (partition by estacao_inicio order by data_inicio) as duracao_media,
    count(duracao_segundos/60/60) over (partition by estacao_inicio order by data_inicio) as quantidade_aluguel
from cap_06.tb_bikes
where data_inicio < '2012-01-08';

# DESAFIO - Retornar
# Extração de início, data de início de cada aluguel de bike e duração de cada aluguel em segundos
# Número de aluguéis de bikes (independente da estação) ao longo do tempo
# Somente os registros quando a data de início for inferior a '2012-01-08'

	#Solução 1
select estacao_inicio,
	   data_inicio,
       duracao_segundos,
       count(duracao_segundos/60/60) over (order by data_inicio) as numero_alugueis
from cap_06.tb_bikes
where data_inicio < '2012-01-08';

	#Solução 2
select estacao_inicio,
	   data_inicio,
       duracao_segundos,
       row_number() over (order by data_inicio) as numero_alugueis #contagem ao longo do tempo, mas não está em todos os sgbds
from cap_06.tb_bikes
where data_inicio < '2012-01-08';

select estacao_inicio,
	   data_inicio,
       duracao_segundos,
       row_number() over (partition by estacao_inicio order by data_inicio) as numero_alugueis #contagem ao longo do tempo, mas não está em todos os sgbds
from cap_06.tb_bikes
where data_inicio < '2012-01-08';

# Estação, data de início, duração em segundos do aluguel e número de aluguéis ao longo do tempo para a estação id 3100
select estacao_inicio,
	   data_inicio,
       duracao_segundos,
       row_number() over (partition by estacao_inicio order by data_inicio) as numero_alugueis #contagem ao longo do tempo, mas não está em todos os sgbds
from cap_06.tb_bikes
where data_inicio < '2012-01-08'
and numero_estacao_inicio = 31000;

select estacao_inicio,
	   cast(data_inicio as date) as data_inicio, #transforma o campo em tipo date
       duracao_segundos,
       row_number() over (partition by estacao_inicio order by cast(data_inicio as date)) as numero_alugueis #contagem ao longo do tempo, mas não está em todos os sgbds
from cap_06.tb_bikes
where data_inicio < '2012-01-08'
and numero_estacao_inicio = 31000;

select estacao_inicio,
	   cast(data_inicio as date) as data_inicio, #transforma o campo em tipo date
       duracao_segundos,
       dense_rank() over (partition by estacao_inicio order by cast(data_inicio as date)) as numero_alugueis #contagem ao longo do tempo, mas não está em todos os sgbds
from cap_06.tb_bikes
where data_inicio < '2012-01-08'
and numero_estacao_inicio = 31000;

select estacao_inicio,
	   cast(data_inicio as date) as data_inicio, #transforma o campo em tipo date
       duracao_segundos,
       rank() over (partition by estacao_inicio order by cast(data_inicio as date)) as numero_alugueis #contagem ao longo do tempo, mas não está em todos os sgbds
from cap_06.tb_bikes
where data_inicio < '2012-01-08'
and numero_estacao_inicio = 31000;

select estacao_inicio,
	   cast(data_inicio as date) as data_inicio, #transforma o campo em tipo date
       duracao_segundos,
		row_number() over (partition by estacao_inicio order by cast(data_inicio as date)) as numero_row, #contagem ao longo do tempo, mas não está em todos os sgbds
       dense_rank() over (partition by estacao_inicio order by cast(data_inicio as date)) as numero_dense, #contagem ao longo do tempo, mas não está em todos os sgbds
       rank() over (partition by estacao_inicio order by cast(data_inicio as date)) as numero_rank #contagem ao longo do tempo, mas não está em todos os sgbds
from cap_06.tb_bikes
where data_inicio < '2012-01-08'
and numero_estacao_inicio = 31000;

# Função NTILE - Agrupa por categoria (Window type)
select estacao_inicio,
	   duracao_segundos,
	   row_number() over (partition by estacao_inicio order by duracao_segundos) as numero_alugueis,
       ntile(2) over (partition by estacao_inicio order by duracao_segundos) as numero_grupo_dois,
       ntile(4) over (partition by estacao_inicio order by duracao_segundos) as numero_grupo_quatro,
       ntile(5) over (partition by estacao_inicio order by duracao_segundos) as numero_grupo_cinco
from cap_06.tb_bikes
where data_inicio < '2012-01-08'
and numero_estacao_inicio = 31000;

# Função LAG e LED
# Função LAG move para frente e Função LEAD move para trás

select estacao_inicio,
	cast(data_inicio as date) as data_inicio,
    duracao_segundos,
    lag(duracao_segundos, 1) over (partition by estacao_inicio order by cast(data_inicio as date)) as registro_lag, #move um registro pra frente
    lead(duracao_segundos, 1) over (partition by estacao_inicio order by cast(data_inicio as date)) as registro_lead #move um registro pra trás
from cap_06.tb_bikes
where data_inicio < '2012-01-08'
and numero_estacao_inicio = 31000;

# Qual a diferença da duração do aluguel de bikes ao longo do tempo, de um registro para outro?
select estacao_inicio,
	cast(data_inicio as date) as data_inicio,
    duracao_segundos,
    duracao_segundos - lag(duracao_segundos, 1) over (partition by estacao_inicio order by cast(data_inicio as date)) as registro_lag #move um registro pra frente
from cap_06.tb_bikes
where data_inicio < '2012-01-08'
and numero_estacao_inicio = 31000;

# remoção do valor nulo
# where só funciona com colunas, por isso fazemos uma subquery. Ai o SQl entende o WHERE.
select *
from(
select estacao_inicio,
	cast(data_inicio as date) as data_inicio,
    duracao_segundos,
    duracao_segundos - lag(duracao_segundos, 1) over (partition by estacao_inicio order by cast(data_inicio as date)) as diferenca #move um registro pra frente
from cap_06.tb_bikes
where data_inicio < '2012-01-08'
and numero_estacao_inicio = 31000) as resultado
where resultado.diferenca is not null;

