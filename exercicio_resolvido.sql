# 1- Qual o número de hubs por cidade?

select count(hub_name) as hub_name, hub_city from cap_05_exercicio.hubs
group by hub_city;

# 2- Qual o número de pedidos (orders) por status?
select count(order_id) as contagem_order, order_status from cap_05_exercicio.orders
group by order_status;

# 3- Qual o número de lojas (stores) por cidade dos hubs?

select count(s.store_id), h.hub_city
FROM cap_05_exercicio.stores as s
INNER JOIN cap_05_exercicio.hubs as h
	ON s.hub_id = h.hub_id
group by h.hub_city;

# 4- Qual o maior e o menor valor de pagamento (payment_amount) registrado?
select max(payment_amount) as maximo, min(payment_amount) as minimo from cap_05_exercicio.payments;

# 5- Qual tipo de driver (driver_type) fez o maior número de entregas?
select dr.driver_type, count(de.delivery_id) as contagem_entrega
FROM cap_05_exercicio.drivers as dr
INNER JOIN cap_05_exercicio.deliveries as de
	ON dr.driver_id = de.driver_id
group by dr.driver_type
order by contagem_entrega desc;

# 6- Qual a distância média das entregas por tipo de driver (driver_modal)?
select dr.driver_modal, avg(de.delivery_distance_meters) as media_distancia
from cap_05_exercicio.drivers as dr
inner join cap_05_exercicio.deliveries as de
	on dr.driver_id = de.driver_id
group by dr.driver_modal
order by media_distancia desc;

# 7- Qual a média de valor de pedido (order_amount) por loja, em ordem decrescente?
select st.store_name, avg(ord.order_amount) as valor_medio_pedido
from cap_05_exercicio.stores as st
inner join cap_05_exercicio.orders as ord
	on st.store_id = ord.store_id
group by st.store_name
order by valor_medio_pedido desc;

# 8- Existem pedidos que não estão associados a lojas? Se caso positivo, quantos?
select coalesce(store_name, 'Sem Loja'), count(order_id) as contagem
from cap_05_exercicio.orders as orders left join cap_05_exercicio.stores
on stores.store_id = orders.store_id
group by store_name
order by contagem desc;

# 9- Qual o valor total de pedido (order_amount) no channel 'FOOD PLACE'?
select sum(order_amount) as valor_total
from cap_05_exercicio.orders as ord
inner join cap_05_exercicio.channels as ch
on ord.channel_id = ch.channel_id
where channel_name = 'FOOD PLACE';

# 10- Quantos pagamentos foram cancelados (chargeback)?
select count(order_status) from cap_05_exercicio.orders
where order_status = 'CANCELED';

# 11- Qual foi o valor médio dos pagamentos cancelados (chargeback)?
select AVG(order_amount) from cap_05_exercicio.orders
where order_status = 'CANCELED';

# 12- Qual a média do valor de pagamento por método de pagamento (payment_method) em ordem decrescente?
select py.payment_method , AVG(ord.order_amount) as pagamento_medio 
from cap_05_exercicio.payments as py
inner join cap_05_exercicio.orders as ord
on py.payment_order_id = ord.payment_order_id
group by py.payment_method
order by pagamento_medio desc;

# 13- Quais métodos de pagamento tiveram valor médio superior a 100?
select py.payment_method , AVG(ord.order_amount) as pagamento_medio 
from cap_05_exercicio.payments as py
inner join cap_05_exercicio.orders as ord
on py.payment_order_id = ord.payment_order_id
group by py.payment_method
having pagamento_medio > 100
order by pagamento_medio desc;

# 14- Qual a média de valor de pedido (order_amount) por estado do hub (hub_state), segmento da loja (store_segment) e tipo de canal (channel_type)?
select hub_state, store_segment, channel_type, round(avg(order_amount),2) as media_pedido
from cap_05_exercicio.orders orders , cap_05_exercicio.stores stores, cap_05_exercicio.channels channels, cap_05_exercicio.hubs hubs
where hubs.hub_id = stores.hub_id
and channels.channel_id = orders.channel_id
and stores.store_id = orders.store_id
group by hub_state, store_segment, channel_type
order by hub_state;


# 15- Qual estado do hub (hub_state), segmento da loja (store_segment) e tipo de canal (channel_type) teve média de valor de pedido (order_amount) maior que 450?
select hub_state, store_segment, channel_type, round(avg(order_amount),2) as media_pedido
from cap_05_exercicio.orders orders , cap_05_exercicio.stores stores, cap_05_exercicio.channels channels, cap_05_exercicio.hubs hubs
where hubs.hub_id = stores.hub_id
and channels.channel_id = orders.channel_id
and stores.store_id = orders.store_id
group by hub_state, store_segment, channel_type
having media_pedido > 450
order by hub_state;

# 16- Qual o valor total de pedido (order_amount) por estado do hub (hub_state), segmento da loja (store_segment) e tipo de canal (channel_type)? Demonstre os totais intermediários e formate o resultado.
select
	if(grouping(hub_state), 'Total Hub State', hub_state) as hub_state,
    if(grouping(store_segment), 'Total Store Segment', store_segment) as store_segment,
    if(grouping(channel_type), 'Total Channel Type', channel_type) as channel_type,
    round(sum(order_amount),2) total_pedido
from cap_05_exercicio.orders orders, cap_05_exercicio.stores stores, cap_05_exercicio.channels channels, cap_05_exercicio.hubs hubs
where hubs.hub_id = stores.hub_id
and channels.channel_id = orders.channel_id
and stores.store_id = orders.store_id
group by hub_state, store_segment, channel_type with rollup;  


# 17- Quando o pedido era do Hub do Rio de Janeiro (hub_state), segmento de loja 'FOOD', tipo de canal Marketplace e foi cancelado, qual foi a média de valor do pedido (order_amount)?
select hub_state, store_segment, channel_type, round(sum(order_amount),2) as soma_pedido
from cap_05_exercicio.orders orders, cap_05_exercicio.stores stores, cap_05_exercicio.channels channels, cap_05_exercicio.hubs hubs
where hubs.hub_id = stores.hub_id
and channels.channel_id = orders.channel_id
and stores.store_id = orders.store_id
and order_status = 'CANCELED'
and store_segment = 'FOOD'
and channel_type = 'MARKETPLACE'
and hub_state = 'RJ'
group by hub_state, store_segment, channel_type;  

# 18- Quando o pedido era do segmento de loja 'GOOD', tipo de canal Marketplace e foi cancelado, algum hub_state teve total de valor do pedido superior a 100.000?
select hub_state, store_segment, channel_type, round(sum(order_amount),2) as soma_pedido
from cap_05_exercicio.orders orders, cap_05_exercicio.stores stores, cap_05_exercicio.channels channels, cap_05_exercicio.hubs hubs
where hubs.hub_id = stores.hub_id
and channels.channel_id = orders.channel_id
and stores.store_id = orders.store_id
and order_status = 'CANCELED'
and store_segment = 'FOOD'
and channel_type = 'MARKETPLACE'
and hub_state = 'RJ'
group by hub_state, store_segment, channel_type
having soma_pedido > 100000;


# 19- Em que data houve a maior média de valor do pedido (order_amount)? Dica: Pesquise e use a função SUBSTRING().

# 20- Em quais datas o valor do pedido foi igual a zero (ou seja, não houve venda)? Dica: Use a função SUBSTRING().