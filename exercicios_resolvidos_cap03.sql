SELECT * FROM cap_03.tb_dados2;

# Exercício 1 - Aplique label enconding à variável menopause
SELECT distinct menopausa FROM cap_03.tb_dados2; #verifica os valores

CREATE TABLE cap_03.tb_dados3 #Cria tabela nova para manipular os dados
AS
SELECT
classe,
idade, 
	CASE
		WHEN menopausa = 'premeno' THEN 1
        WHEN menopausa = 'ge40' THEN 2
        WHEN menopausa = 'It40' THEN 3
	END as menopausa,
tamanho_tumor,
inv_nodes,
node_caps,
deg_malig,
seio,
quadrante,
irradiando
FROM cap_03.tb_dados2;

# [Desafio] Exercício 2 - Crie uma nova coluna chamada posicao_tumor concatenando as colunas inv_nodes e quadrante

CREATE TABLE cap_03.tb_dados4 #Cria tabela nova para manipular os dados
AS
SELECT
classe,
idade, 
menopausa,
tamanho_tumor,
CONCAT(inv_nodes, '-', quadrante) AS posicao_tumor,
inv_nodes,
node_caps,
deg_malig,
seio,
quadrante,
irradiando
FROM cap_03.tb_dados3;

# [Desafio] Exercício 3 - Aplique One-Hot-Enconding à coluna deg_malig
SELECT distinct deg_malig FROM cap_03.tb_dados4;

CREATE TABLE cap_03.tb_dados5 #Cria tabela nova para manipular os dados
AS
SELECT
classe,
idade, 
menopausa,
tamanho_tumor,
posicao_tumor,
node_caps,
CASE WHEN deg_malig = 1 THEN 1 ELSE 0 END AS deg_malig_cat1,
CASE WHEN deg_malig = 2 THEN 1 ELSE 0 END AS deg_malig_cat2,
CASE WHEN deg_malig = 3 THEN 1 ELSE 0 END AS deg_malig_cat3,
seio,
irradiando
FROM cap_03.tb_dados4;

# Exercício 4 - Crie um dataset com as alterações dos exercícios anteriores
SELECT * FROM cap_03.tb_dados5;


 