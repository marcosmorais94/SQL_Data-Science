SELECT * FROM cap_03.breast_cancer;

#Binarização da variável classe (0/1)
SELECT DISTINCT irradiando from cap_03.breast_cancer;

SELECT
	CASE
		WHEN classe = 'no-recurrence-events' THEN 0
        WHEN classe = 'recurrence-events' THEN 1
	END as classe #apelido para o nome da coluna
FROM cap_03.breast_cancer;

#Binarização da variável irradiando (0/1)
SELECT DISTINCT irradiando from cap_03.breast_cancer;

SELECT
	CASE
		WHEN irradiando = 'no' THEN 0
        WHEN irradiando = 'yes' THEN 1
	END as irradiando #apelido para o nome da coluna
FROM cap_03.breast_cancer;

#Binarização da variável node_caps (0/1)
SELECT DISTINCT node_caps from cap_03.breast_cancer;

SELECT
	CASE
		WHEN node_caps = 'no' THEN 0
        WHEN node_caps = 'yes' THEN 1
        ELSE 2
	END as node_caps #apelido para o nome da coluna
FROM cap_03.breast_cancer;

#Categorização da variável seio (E/D)
SELECT DISTINCT seio from cap_03.breast_cancer;

SELECT
	CASE
		WHEN seio = 'left' THEN 'E'
        WHEN seio = 'right' THEN 'D'
	END as seio
FROM cap_03.breast_cancer;

#Categorização da variável tamanho_tumor (6 categorias)
SELECT DISTINCT tamanho_tumor from cap_03.breast_cancer;

SELECT
	CASE
		WHEN tamanho_tumor = '0-4' OR tamanho_tumor = '5-9' THEN 'Muito Pequeno'
        WHEN tamanho_tumor = '10-14' OR tamanho_tumor = '15-19' THEN 'Pequeno'
		WHEN tamanho_tumor = '20-24' OR tamanho_tumor = '25-29' THEN 'Médio'
		WHEN tamanho_tumor = '30-34' OR tamanho_tumor = '35-39' THEN 'Grande'
		WHEN tamanho_tumor = '40-44' OR tamanho_tumor = '45-49' THEN 'Muito Grande'
		WHEN tamanho_tumor = '50-54' OR tamanho_tumor = '55-59' THEN 'Tratamento Urgente'
    END as tamanho_tumor
FROM cap_03.breast_cancer;

#Label Enconding da variável quadrante (1,2,3,4,5,6)
SELECT DISTINCT quadrante from cap_03.breast_cancer;

SELECT
	CASE
		WHEN quadrante = 'left_low' THEN 1
        WHEN quadrante = 'right_up' THEN 2
		WHEN quadrante = 'left_up' THEN 3
		WHEN quadrante = 'right_low' THEN 4
		WHEN quadrante = 'central' THEN 5
		ELSE 0
    END as quadrante
FROM cap_03.breast_cancer;

