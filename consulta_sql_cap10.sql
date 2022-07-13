# Carregando dados via Procedure SQL

# Ver script procedure_carrega_tempo
call cap10.carrega_tb_tempo('2010-01-01','2030-01-01')

# Criação de View

create view cap10.vw_vendas_maior_500 as #create or replace é para modificar a view por uma nova, isso apaga a anterior...
	select * from cap10.tb_venda
    where valor_venda > 500;
    
select * from cap10.vw_vendas_maior_500;

call cap10.sp_extrai_clientes(500);

call cap10.sp_extrai_clientes2(@contagem);
# Procedure com @ indica que é output, ela fica armazenada na memória do PC. Para ver, use:
select @contagem as clientes;
# Técnica usada em encadear Stored Procedures.

 

