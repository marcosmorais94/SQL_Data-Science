# Em Abril de 2018 alguma embarcação teve índice de conformidade de 100% e pontuação de risco igual a 0?
SELECT nome_navio, classificacao_risco ,indice_conformidade ,temporada 
FROM cap02_aula.tb_navios 
WHERE indice_conformidade > 90 AND pontuacao_risco = 0 AND mes_ano = '04/2018'
ORDER BY indice_conformidade, nome_navio;