GO
CREATE DATABASE BaseFilmes
GO
USE BaseFilmes

GO
CREATE TABLE filme(
id			INT									NOT NULL,
titulo		VARCHAR(40)							NOT NULL,
ano			INT				CHECK(ano < 2022)		NULL
PRIMARY KEY (id)
)

GO
CREATE TABLE estrela(
id			INT				NOT NULL,
nome		VARCHAR(50)		NOT NULL
PRIMARY KEY (id)
)

GO
CREATE TABLE cliente(
num_cadastro	INT											NOT NULL,
nome			VARCHAR(70)									NOT NULL,
logradouro		VARCHAR(150)								NOT NULL,
num				INT						CHECK(num > 0)		NOT NULL,
cep				CHAR(08)				CHECK(LEN(cep) = 8)		NULL
PRIMARY KEY (num_cadastro)
)

GO
CREATE TABLE dvd(
num					INT												NOT NULL,
data_fabricacao		DATE		CHECK(data_fabricacao < GETDATE())	NOT NULL,
id_filme			INT												NOT NULL
PRIMARY KEY (num)
FOREIGN KEY (id_filme)
	REFERENCES filme (id)
)

GO
CREATE TABLE filme_estrela(
id_filme			INT				NOT NULL,
id_estrela			INT				NOT NULL
FOREIGN KEY (id_filme)
	REFERENCES filme(id),
FOREIGN KEY (id_estrela)
	REFERENCES estrela(id)
)

GO
CREATE TABLE locacao(
data_locacao         DATE			    CHECK(data_locacao = GETDATE())			NOT NULL,
data_devolucao       DATE														NOT NULL,
valor				DECIMAL(7, 2)		CHECK(valor > 0)						NOT NULL,
num_dvd				INT															NOT NULL,
num_cliente			INT															NOT NULL
PRIMARY KEY (data_locacao)
FOREIGN KEY (num_cliente)
	REFERENCES cliente (num_cadastro),
FOREIGN KEY (num_dvd)
	REFERENCES dvd (num)
)

GO
ALTER TABLE estrela
add nome_real		VARCHAR(50)			NULL

GO
ALTER TABLE filme
ALTER COLUMN  titulo	VARCHAR(80) NOT NULL

GO
INSERT INTO filme(id, titulo, ano)
VALUES	(1001, 'Whiplash', 2015),
		(1002, 'Birdman', 2015),
		(1003, 'Interestelar', 2014),
		(1004, 'A culpa é das estrelas', 2014),
		(1005, 'Alexandre e o Dia Terrível, Horrível,
		 Espantoso e Horroroso', 2014),
		(1006, 'Sing', 2016)

GO
INSERT INTO estrela(id, nome, nome_real)
VALUES	(9901, 'Michael Keaton', 'Michael John Douglas'),
		(9902, 'Emma Stone', 'Emily JEan Stone'),
		(9903, 'Miles Teller', null),
		(9904, 'Steve Carell', 'Steven John Carell'),
		(9905, 'Jennifer Garner', 'Jennifer Anne Garner')

GO
INSERT INTO filme_estrela(id_filme, id_estrela)
VALUES	(1002, 9901),
		(1002, 9902),
		(1001, 9903),
		(1005, 9904),
		(1005, 9905)

GO
INSERT INTO dvd(num, data_fabricacao, id_filme)
VALUES	(10001, '2020-12-02', 1001),
		(10002, '2020-12-02', 1002),
		(10003, '2020-12-02', 1003),
		(10004, '2020-12-02', 1001),
		(10005, '2020-12-02', 1004),
		(10006, '2020-12-02', 1002),
		(10007, '2020-12-02', 1005),
		(10008, '2020-12-02', 1002),
		(10009, '2020-12-02', 1003)

GO
INSERT INTO cliente(num_cadastro, nome, logradouro, num, cep)
VALUES	(5501, 'Matilde Luz', 'Rua Síria', 150, '03086040'),
		(5502, 'Carlos Carreiro', 'Rua Bartolomeu Aires', 1250, '04419110'),
		(5503, 'Daniel Ramalho', 'Rua Itajutiba', 169, null),
		(5504, 'Roberta Bento', 'Rua Jayme Von Rosenburg', 36, null),
		(5505, 'Rosa Cerqueira', 'Rua Arnaldo Simões Pinto', 235, '02917110')

GO
INSERT INTO locacao(num_dvd, num_cliente, data_locacao, data_devolucao, valor)
VALUES	(10001, 5502, '2021-02-18', '2021-02-21', 3.50),
		(10009, 5502, '2021-02-18', '2021-02-21', 3.50),
		(10002, 5503, '2021-02-18', '2021-02-19', 3.50),
		(10002, 5505, '2021-02-20', '2021-02-23', 3.00),
		(10004, 5505, '2021-02-20', '2021-02-23', 3.00),
		(10005, 5505, '2021-02-20', '2021-02-23', 3.00),
		(10001, 5501, '2021-02-24', '2021-02-26', 3.50),
		(10008, 5501, '2021-02-24', '2021-02-26', 3.50)

UPDATE cliente
SET cep = '08411150'
WHERE num_cadastro = 5503

UPDATE cliente
SET cep = '02918190'
WHERE num_cadastro = 5504

UPDATE locacao
SET valor = 3.25
WHERE data_locacao = '2021-02-18'

UPDATE locacao
SET valor = 3.10
WHERE data_locacao = '2021-02-24'

UPDATE dvd
SET data_fabricacao = '2019-07-14'
WHERE num = 10005

UPDATE estrela
SET nome_real = 'Miles Alexander Teller'
WHERE nome = 'Miles Teller'

DELETE filme
WHERE titulo = 'Sing'

SELECT cl.num_cadastro As Num_cadastro_cliente, cl.nome As Nome_Cliente, lo.data_locacao, 
		DATEDIFF(DAY, data_devolucao, data_locacao) As Qtd_dias_Alugados, fi.titulo As Titulo_Filme,
		fi.ano As Ano_Filme
FROM cliente cl, filme fi, locacao lo, dvd dv
WHERE cl.num_cadastro = lo.num_cliente
	AND fi.id = dv.id_filme
	AND dv.num = lo.num_dvd
	AND nome = 'Matilde%'

SELECT es.nome As Nome_Estrela, es.nome_real As Nome_Real_Estrela, fi.titulo As Titulo_Filme
FROM estrela es, filme fi
WHERE fi.id = es.id
	AND fi.ano = 2015

SELECT fi.titulo As Titulo_Filme, dv.data_fabricacao, 
		CASE WHEN DATEDIFF(YEAR, GETDATE(), fi.ano) > 6
		THEN DATEDIFF(YEAR, GETDATE(), fi.ano) + ' anos'
		ELSE DATEDIFF(YEAR, GETDATE(), fi.ano)
		END As Diferença_ano
FROM filme fi, dvd dv
WHERE fi.id = dv.id_filme