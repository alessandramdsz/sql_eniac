-- Parte 1: DQL (Consultas Simples e Filtros) 

--1. Consulta Geral: Selecione todas as informações da tabela ALUNOS. 
SELECT * FROM ALUNOS a 

--2. Consulta Específica: Crie um relatório que mostre apenas o nome e o departamento de todos os cursos, com os títulos das colunas sendo 
--"Curso" e "Departamento Responsável". 
SELECT 
	NOME_CURSO as "Curso",
	DEPARTAMENTO as "Departamento Responsável"
FROM CURSOS c 

--3. Filtro Numérico: Liste o nome e os créditos de todos os cursos que valem mais de 4 créditos.
SELECT 
	NOME_CURSO as "Curso",
	c.CREDITOS as "Créditos"
FROM CURSOS c 
WHERE c.CREDITOS > 4

--4. Filtro de Data: Mostre o nome e o email dos alunos que ingressaram a partir do início de 2023
-- (ou seja, DATA_INGRESSO maior ou igual a '2023-01-01'). 
SELECT 
	NOME_ALUNO AS "Nome do Aluno",
	EMAIL as "Email"
FROM ALUNOS a 
WHERE DATA_INGRESSO >= '2023-01-01'

-- 5. Filtro com AND e Ordenação: 
--Liste o nome e a nota final de todas as matrículas do aluno de ID_ALUNO = 1 E cuja NOTA_FINAL foi maior ou igual a 7.0. 
-- Ordene o resultado pela nota, da maior para a menor. 



-----------------------------------------------------------------------------------------------------

--Parte 2: DQL (Transformação e Organização) 
--1. Valores Únicos: Qual é a lista de departamentos únicos que oferecem cursos na universidade? 
SELECT DISTINCT c.DEPARTAMENTO  AS "Departamento"
FROM CURSOS c 

--2. Lógica Condicional: Crie um relatório de matrículas que mostre o ID_MATRICULA e uma nova coluna chamada STATUS . 
--O status deve ser 'Aprovado' se a NOTA_FINAL for maior ou igual a 7.0, e 'Reprovado' caso contrário. 
SELECT
	m.ID_MATRICULA AS "Matrícula",
	CASE 
		When m.NOTA_FINAL >=7 then 'Aprovado'
		Else 'Reprovado'
	END AS "Status"
 FROM MATRICULAS m 

--3. Ordenação e Limite: Qual é o curso com o maior número de créditos? O resultado deve mostrar apenas o nome do curso e seus créditos. 
SELECT
	NOME_CURSO as "Nome",
	CREDITOS as "Crédito"
FROM CURSOS
ORDER BY CREDITOS DESC
LIMIT 1;
-------------------------------------------------------------------------------------------------
--Parte 3: DQL (Agregações e Agrupamentos) 
--1. Contagem e Média: Calcule o número total de matrículas e a média geral de todas as notas finais. 
SELECT
	COUNT(m.ID_MATRICULA) AS "Qtd. de Matrícula",
	AVG(m.NOTA_FINAL) AS "Média de Notas"
FROM MATRICULAS m 

--2. Agrupamento: Crie um relatório que mostre quantos cursos são oferecidos por departamento. 
SELECT 
	DEPARTAMENTO,
	COUNT(ID_CURSO) AS "Cursos Oferecidos"
FROM CURSOS
GROUP BY DEPARTAMENTO 

--3. Filtro de Grupo: Com base na consulta anterior, mostre apenas os departamentos que oferecem mais de um curso. 
SELECT 
	DEPARTAMENTO,
	COUNT(ID_CURSO) AS "Cursos Oferecidos"
FROM CURSOS
GROUP BY DEPARTAMENTO 
HAVING COUNT(ID_CURSO) > 1

------------------------------------------------------------------------------------------------------
--Parte 4: DQL (Junção de Tabelas - JOINs) 
--1. Relatório de Desempenho: Crie uma consulta que mostre o nome do aluno, o nome do curso em que ele está matriculado e a sua nota final. 
--(Dica: Você precisará de dois JOIN s). 
SELECT 
	a.NOME_ALUNO as "Nome",
	c.NOME_CURSO as "Curso",
	m.NOTA_FINAL as "Nota"
FROM MATRICULAS m 
INNER JOIN ALUNOS a 
	ON m.ID_ALUNO = a.ID_ALUNO
INNER JOIN CURSOS c
	ON m.ID_CURSO = c.ID_CURSO 
ORDER BY m.NOTA_FINAL DESC
	
--2. Busca por Alunos sem Matrícula: Qual aluno está cadastrado na universidade mas ainda não se matriculou em nenhum curso? 
--A consulta deve retornar apenas o nome deste aluno. (Dica: LEFT JOIN com um filtro WHERE ... IS NULL ).
	
SELECT a.NOME_ALUNO AS "Nome"
FROM ALUNOS a
LEFT JOIN MATRICULAS m 
    ON a.ID_ALUNO = m.ID_ALUNO
WHERE m.ID_MATRICULA IS NULL;

------------------------------------------------------------------------------------------------------
--Desafio Final: O Aluno Destaque 
'''Crie um único relatório para encontrar o "Aluno Destaque". Este aluno é aquele 
com a maior média de notas finais. A consulta deve mostrar o nome do aluno 
e a sua média de notas, arredondada para duas casas decimais. 
Dicas para o desafio: 
1. Una as tabelas ALUNOS e MATRICULAS . 
2. Use GROUP BY para agrupar as notas por aluno. 
3. Use AVG() para calcular a média das notas para cada aluno. 
4. Use ORDER BY para ordenar o resultado pela média de forma descendente. 
5. Use LIMIT 1 para pegar apenas o primeiro resultado da lista ordenada. 
6. Use ROUND() para arredondamento'''

SELECT 
	a.NOME_ALUNO AS "Aluno Destaque",
	ROUND (AVG(m.NOTA_FINAL),2) as "Média de Nota"
FROM ALUNOS a
INNER JOIN MATRICULAS m 
	ON a.ID_ALUNO = m.ID_ALUNO 
GROUP BY a.ID_ALUNO, a.NOME_ALUNO
ORDER BY AVG(m.NOTA_FINAL) DESC
LIMIT 1;
