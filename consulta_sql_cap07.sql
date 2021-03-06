# Análise Exploratória dos Dados - COVID-19

# Ordenando os dados por nome ou número da coluna
select * from cap07.covid_mortes order by location, date;
select * from cap07.covid_mortes order by 3,4; #mesma coisa que a linha 4

# Alterando o formato da coluna Date
set SQL_SAFE_UPDATES = 0; # Comando para desabilitar o safe update. Com ele ativo, não consigo usar UPDATE e DELETE
# ATENÇÃO - COMANDO PERIGOSO E SÓ USAR EM AMBIENTE DE ESTUDO

UPDATE cap07.covid_mortes
SET date = str_to_date(date, "%d/%m/%y");

update cap07.covid_vacinacao
set date = str_to_date(date, "%d/%m/%y");

set SQL_SAFE_UPDATES = 1; # Sempre voltar o Safe Update para evitar problemas futuros, mesmo em ambiente de estudo

# Retornando colunas relevantes para o estudo
select date,
	   location,
       total_cases,
       new_cases,
       total_deaths,
       population
from cap07.covid_mortes
order by 2,1;

# Análise Univariada - Analisar cada variável de forma independente, mesmo que a consulta retorne duas variáveis como na consulta da linha 38
# Qual a média de mortos por país?

select location,
	   avg(total_deaths) as media_mortos
from cap07.covid_mortes
group by location
order by media_mortos desc;

select location,
	   avg(total_deaths) as media_mortos,
       avg(new_cases) as media_novos_casos
from cap07.covid_mortes
group by location
order by media_mortos desc;

# Análise Multivariada (duas ou mais variáveis) - Analisar cada variável de forma dependente, considerando o relacionamento entre elas. 
select date,
	   location,
       total_cases,
       total_deaths,
       (total_deaths / total_cases) * 100 as percentual_mortes
from cap07.covid_mortes
where location = 'Brazil'
order by 2,1;

# Qual a proporção média entre o total de casos e a população de cada localidade?

select location,
	   avg((total_cases / population) * 100) as proporcao_media
from cap07.covid_mortes
group by location
order by proporcao_media desc;

# Considerando o maior valor do total de casos, quais os países com a maior taxa de infecção em relação a população?
select location,
	   max(total_cases) as Maior_Contagem_Infec,
       max((total_cases / population)) * 100 as percentual_populacao
from cap07.covid_mortes
where continent is not null
group by location, population
order by percentual_populacao desc;

# Quais os países com o maior número de mortes?

	# Opção 1
select location,
	   max(total_deaths * 1) as contagem_mortes # Multiplicação porque o atributo está como texto na tabela, mas *1 tranforma em número direto na consulta. Não usa Update.
from cap07.covid_mortes
where continent is not null
group by location
order by contagem_mortes desc;

	# Opção 2 
select location,
	   max(cast(total_deaths as unsigned)) as contagem_mortes #Mysql não converte em tipo inteiro, para isso usar unsigned.
from cap07.covid_mortes
where continent is not null
group by location
order by contagem_mortes desc;

# Quais os continentes com o maior número de mortes?
select continent,
	   max(cast(total_deaths as unsigned)) as contagem_mortes
from cap07.covid_mortes
where continent is not null
group by continent
order by contagem_mortes desc;

# Qual o percentual de mortes por dia?
select date,
	   sum(new_cases) as total_cases,
       sum(cast(new_deaths as unsigned)) as total_deaths,
       coalesce((sum(cast(new_deaths as unsigned)) / sum(new_cases)) * 100, 'NA') as percent_mortes
from cap07.covid_mortes
where continent is not null
group by date
order by 1,2;

# Funções Window
# Qual o número de novos vacinados e a média móvel de novos vacinados ao longo do tempo por localidade?
# Considere apenas os dados da América do Sul
select mortos.continent,
	   mortos.location,
       mortos.date,
       vacinados.new_vaccinations,
       avg(cast(vacinados.new_vaccinations as unsigned)) over (partition by mortos.location order by mortos.date) as media_movel
from cap07.covid_mortes as mortos
join cap07.covid_vacinacao as vacinados
on mortos.location = vacinados.location
and mortos.date = vacinados.date
where mortos.continent = 'South America'
order by 2,3;

# DESAFIO
# Qual o número de novos vacinados e o total de novos vacinados ao longo do tempo por continente?
	# Considere apenas os dados da América do Sul
select mortos.continent,
       mortos.date,
       vacinados.new_vaccinations,
       sum(cast(vacinados.new_vaccinations as unsigned)) over (partition by mortos.continent order by mortos.date) as total_vacinados
from cap07.covid_mortes as mortos
join cap07.covid_vacinacao as vacinados
on mortos.location = vacinados.location
and mortos.date = vacinados.date
where mortos.continent = 'South America'
order by 2,3;


# Qual o número de novos vacinados e o total de novos vacinados ao longo do tempo por continente?
	# Considere apenas os dados da América do Sul
    # Considere a data no formato January/2020
select mortos.continent,
       date_format(mortos.date,'%M/%Y') as mes,
       vacinados.new_vaccinations,
       sum(cast(vacinados.new_vaccinations as unsigned)) over (partition by mortos.continent order by date_format(mortos.date,'%M/%Y')) as total_vacinados
from cap07.covid_mortes as mortos
join cap07.covid_vacinacao as vacinados
on mortos.location = vacinados.location
and mortos.date = vacinados.date
where mortos.continent = 'South America'
order by 2,3;

# Command Table Expression (CTE) - Cria uma tabela temporária em tempo de execução na memória do computador

# Qual o percentual da população com pelo menos 1 dose da vacina ao longo do tempo?
	# Considere apenas os dados do Brasil
with PopvsVac (continent, location, date, population, new_vaccinations, total_vacinados) as
(
select mortos.continent,
	   mortos.location,
       mortos.date,
       mortos.population,
       vacinados.new_vaccinations,
       sum(cast(vacinados.new_vaccinations as unsigned)) over (partition by mortos.location order by mortos.date) as total_vacinados
from cap07.covid_mortes as mortos
join cap07.covid_vacinacao as vacinados
on mortos.location = vacinados.location
and mortos.date = vacinados.date
where mortos.location = 'Brazil'
)
select *, (total_vacinados / population) * 100 as percentual_1_dose from PopvsVac;

# Durante o mês de Maio/21, o percentual de vacinados com pelo menos uma dose aumentou ou diminuiu no Brasil:
with PopvsVac (continent, location, date, population, new_vaccinations, total_vacinados) as
(
select mortos.continent,
	   mortos.location,
       mortos.date,
       mortos.population,
       vacinados.new_vaccinations,
       sum(cast(vacinados.new_vaccinations as unsigned)) over (partition by mortos.location order by mortos.date) as total_vacinados
from cap07.covid_mortes as mortos
join cap07.covid_vacinacao as vacinados
on mortos.location = vacinados.location
and mortos.date = vacinados.date
where mortos.location = 'Brazil'
)
select *, (total_vacinados / population) * 100 as percentual_1_dose 
from PopvsVac
where date_format(date,'%M/%Y') = 'May/2021'
and location = 'Brazil';
