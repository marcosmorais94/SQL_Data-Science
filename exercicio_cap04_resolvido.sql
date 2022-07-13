# 1 - Quem são os técnicos e atletas das equipes de handball?
SELECT c.name as coach_name, a.name as athletes_name
from exercicio_cap04.coaches as c
inner join exercicio_cap04.athletes as a
on c.NOC =  a.NOC
where c.Discipline = 'Handball';

# 2 - Quem são os técnicos dos atletas da Austrália que receberam medalhas de ouro?
# Faltam dados porque não temos integridade referencial

# 3 - Quais países tiveram mulheres conquistando medalhas de ouro?
# Faltam dados porque não temos integridade referencial


# 4 - Quais atletas da Noruega receberam medalhas de ouro ou prata?
# Faltam dados porque não temos integridade referencial


# 5 - Quais Atletas brasileiros não receberam medalhas?
# Faltam dados porque não temos integridade referencial
