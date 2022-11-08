CREATE DATABASE projetos
GO 
USE projetos

GO 
CREATE TABLE users(
id			INT				NOT NULL	IDENTITY(1, 1),
name		VARCHAR(45)		NOT NULL,
username	VARCHAR(45)		NOT NULL UNIQUE,
password	VARCHAR(45)		NOT NULL DEFAULT('123mudar'),
email		VARCHAR(45)		NOT NULL
PRIMARY KEY (id)
)

GO
CREATE TABLE projects(
id				INT				NOT NULL	IDENTITY(10001,1),
name			VARCHAR(45)		NOT NULL,
description		VARCHAR(45)		NOT NULL,
date			DATE		CHECK(date > '2014-09-01')	NOT NULL
PRIMARY KEY (id)
)

GO
CREATE TABLE users_has_projects(
id_user			INT				NOT NULL,
id_project		INT				NOT NULL
FOREIGN KEY (id_user)
	REFERENCES users (id),
FOREIGN KEY (id_project)
	REFERENCES projects (id)
)

GO
ALTER TABLE users
ALTER COLUMN username	VARCHAR(10)		NOT NULL

GO
ALTER TABLE users
ALTER COLUMN password	VARCHAR(08)		NOT NULL

GO
INSERT INTO users(id, name, username, password, email)
VALUES	(1, 'Mario', 'Rh_maria', '123mudar', 'maria@empresa.com'),
		(1, 'Paulo', 'Ti_paulo', '123@456', 'paulo@empresa.com'),
		(1, 'Ana', 'Rh_ana', '123mudar', 'ana@empresa.com'),
		(1, 'Clara', 'Ti_clara', '123mudar', 'clara@empresa.com'),
		(1, 'Aparecido', 'Rh_apareci', '55@!cido', 'aparecido@empresa.com')

GO
INSERT INTO projects(id, name, description, date)
VALUES	(1, 'Re-folha', 'Refatoração das folhas', '2014-09-05'),
		(2, 'Manutenção PCs', 'Manutenção PCs', '2014-09-06'),
		(3, 'Auditoria', '', '2014-09-07')

GO
INSERT INTO users_has_projects(id_user, id_project)
VALUES	(1, 10001),
		(5, 10001),
		(3, 10003),
		(4, 10002),
		(2, 10002)

UPDATE projects
SET date = '2014-09-12'
WHERE id = 10002

UPDATE users
SET  username = 'Rh_cido'
WHERE name = 'Aparecido'

UPDATE users
SET  password = '888@'
WHERE name = 'Aparecido'

DELETE users_has_projects
WHERE id_user = 2

SELECT us.id As ID_User, us.name As Nome_User, us.email As Email_User, pr.id As ID_Projeto, pr.name As Nome_Projeto,
		pr.description As Descrição_Projeto, pr.date As Data_Projeto
FROM users us, users_has_projects up, projects pr
WHERE us.id = up.id_user
	AND pr.id = up.id_project
	AND pr.name = 'R-Folha'

SELECT us.name As Nome_Usuario
FROM users us, users_has_projects up
WHERE us.id != up.id_user

SELECT pr.name As Nome_Projeto
FROM projects pr, users_has_projects up
WHERE pr.id != up.id_project