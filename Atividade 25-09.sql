CREATE DATABASE Congresso_Universitario

use Congresso_Universitario

CREATE TABLE Participante(
Id_Participante INT PRIMARY KEY NOT NULL,
Nome VARCHAR(50) NOT NULL,
Tipo_Inscricao VARCHAR(50) NOT NULL,
Email VARCHAR(100) NOT NULL,
Curso VARCHAR(100) NOT NULL
);

CREATE TABLE Palestra(
Id_Palestra INT PRIMARY KEY NOT NULL,
Titulo VARCHAR(150) NOT NULL,
Descricao VARCHAR(150) NOT NULL,
Palestrante VARCHAR(100) NOT NULL,
Data_Hora DATETIME NOT NULL,
Duracao TIME NOT NULL
);


CREATE TABLE Workshop(
Id_Workshop INT PRIMARY KEY NOT NULL,
Titulo VARCHAR(150) NOT NULL,
Descricao VARCHAR(200) NOT NULL,
Instrutor VARCHAR(150) NOT NULL,
Data_Hora DATETIME NOT NULL,
Duracao TIME NOT NULL,
Vagas INT NOT NULL
);

CREATE TABLE InscricaoPalestra(
Id_Inscricao INT PRIMARY KEY NOT NULL,
Id_Participante INT NOT NULL,
Id_Palestra INT NOT NULL,
FOREIGN KEY(Id_Palestra) REFERENCES Palestra(Id_Palestra),
FOREIGN KEY(Id_Participante) REFERENCES Participante(Id_Participante)
);


CREATE TABLE InscricaoWorkShop(
Id_Inscricao INT PRIMARY KEY NOT NULL,
Id_Participante INT NOT NULL,
Id_Workshop INT NOT NULL,
FOREIGN KEY(Id_Workshop) REFERENCES Workshop(Id_Workshop),
FOREIGN KEY(Id_Participante) REFERENCES Participante(Id_Participante)
);

--  Inserir Participantes
GO

CREATE PROCEDURE Inserir_Participante
	@Id_Participante INT,
	@Nome VARCHAR(50),
	@Email VARCHAR(100),
	@Tipo_Inscricao VARCHAR(150),
	@Curso VARCHAR(100)
AS
BEGIN
 INSERT INTO Participante
 (Id_Participante,
 Nome,
 Tipo_Inscricao,
 Email,
 Curso)
 VALUES(
 @Id_Participante,
 @Nome,
 @Email,
 @Tipo_Inscricao,
 @Curso 
 );

 END


 EXEC Inserir_Participante @Id_Participante = 1, @Nome= 'Claudio Matheus', @Email = 'claudioMatheuszica@', @Tipo_Inscricao = 'Estudante', @Curso = 'Ciência da Computação';

 --  Inserir Participantes

 --  Inserir Palestra
 GO

 CREATE PROCEDURE Inserir_Palestra
	@Id_Palestra INT,
	@Titulo VARCHAR(150),
	@Descricao VARCHAR(150),
	@Palestrante VARCHAR(100),
	@Data_Hora DATETIME,
	@Duracao TIME 
AS
BEGIN
	INSERT INTO Palestra(
	Id_Palestra,
	Titulo,
	Descricao,
	Palestrante,
	Data_Hora,
	Duracao)
	VALUES(
	@Id_Palestra,
	@Titulo,
	@Descricao,
	@Palestrante,
	@Data_Hora,
	@Duracao
	);
END

EXEC Inserir_Palestra @Id_Palestra = 1, @Titulo = 'Aprenda a programar',
@Descricao = 'Aprenda programar em uma semana', @Palestrante = 'Claudio Matheus',
@Data_Hora = '2024-11-04 10:00:00', @Duracao = '05:00:00';

 --  Inserir Palestra

 --  Inserir WorkShop
GO

CREATE PROCEDURE Inserir_Workshop
    @Id_Workshop INT,
    @Titulo VARCHAR(150),
    @Descricao VARCHAR(200),
    @Instrutor VARCHAR(150),
    @Data_Hora DATETIME,
    @Duracao TIME,
    @Vagas INT
AS
BEGIN
    INSERT INTO Workshop (
        Id_Workshop,
        Titulo,
        Descricao,
        Instrutor,
        Data_Hora,
        Duracao,
        Vagas
    )
    VALUES (
        @Id_Workshop,
        @Titulo,
        @Descricao,
        @Instrutor,
        @Data_Hora,
        @Duracao,
        @Vagas
    );
END


EXEC Inserir_Workshop 
    @Id_Workshop = 1, 
    @Titulo = 'Workshop de Desenvolvimento Web',
    @Descricao = 'Aprenda as melhores práticas de desenvolvimento web em um dia.',
    @Instrutor = 'Ana Paula',
    @Data_Hora = '2024-11-10 09:00:00', 
    @Duracao = '04:00:00', 
    @Vagas = 30;


GO

--  Inserir WorkShop

--  Inserir Participantes na palestra

CREATE PROCEDURE Inscrever_Participante_Palestra
    @Id_Participante INT,
    @Id_Palestra INT
AS
BEGIN
    INSERT INTO InscricaoPalestra (
        Id_Participante,
        Id_Palestra
    )
    VALUES (
        @Id_Participante,
        @Id_Palestra
    );
END

EXEC Inscrever_Participante_Palestra 
    @Id_Participante = 1, 
    @Id_Palestra = 2;
--  Inserir Participantes na palestra

--  Inserir Participantes no workshop
	GO

CREATE PROCEDURE Inscrever_Participante_Workshop
    @Id_Participante INT,
    @Id_Workshop INT
AS
BEGIN
    DECLARE @VagasDisponiveis INT;
    SELECT @VagasDisponiveis = Vagas
    FROM Workshop
    WHERE Id_Workshop = @Id_Workshop;


    IF @VagasDisponiveis IS NULL
    BEGIN
        PRINT 'O workshop não foi encontrado.';
        RETURN;
    END

    IF @VagasDisponiveis <= 0
    BEGIN
        PRINT 'As vagas estão esgotadas para este workshop.';
        RETURN;
    END

    INSERT INTO InscricaoWorkshop (
        Id_Participante,
        Id_Workshop
    )
    VALUES (
        @Id_Participante,
        @Id_Workshop
    );
    UPDATE Workshop
    SET Vagas = Vagas - 1
    WHERE Id_Workshop = @Id_Workshop;

    PRINT 'Inscrição realizada com sucesso!';
END

EXEC Inscrever_Participante_Workshop 
    @Id_Participante = 1,  
    @Id_Workshop = 2;
--  Inserir Participantes no workshop


--  Remover Participantes 
	GO

CREATE PROCEDURE Remover_Participante
    @Id_Participante INT
AS
BEGIN
    DELETE FROM InscricaoPalestra
    WHERE Id_Participante = @Id_Participante;

    DELETE FROM InscricaoWorkshop
    WHERE Id_Participante = @Id_Participante;

    DELETE FROM Participante
    WHERE Id_Participante = @Id_Participante;

    PRINT 'Participante removido com sucesso, incluindo todas as inscrições.';
END

EXEC Remover_Participante 
    @Id_Participante = 1; 

--  Remover Participantes 

--  Relatório de Participação de um Participante

GO

CREATE PROCEDURE Relatorio_Participacao_Participante
    @Id_Participante INT
AS
BEGIN

    SELECT 
        'Palestra' AS Tipo,
        P.Titulo,
        P.Data_Hora,
        P.Duracao
    FROM 
        InscricaoPalestra IP
    JOIN 
        Palestra P ON IP.Id_Palestra = P.Id_Palestra
    WHERE 
        IP.Id_Participante = @Id_Participante

    UNION ALL

    SELECT 
        'Workshop' AS Tipo,
        W.Titulo,
        W.Data_Hora,
        W.Duracao
    FROM 
        InscricaoWorkshop IW
    JOIN 
        Workshop W ON IW.Id_Workshop = W.Id_Workshop
    WHERE 
        IW.Id_Participante = @Id_Participante;

    SELECT 
        SUM(DATEDIFF(MINUTE, 0, 
            CASE 
                WHEN IP.Id_Palestra IS NOT NULL THEN P.Duracao 
                ELSE W.Duracao 
            END)) / 60.0 AS Total_Horas
    FROM 
        InscricaoPalestra IP
    LEFT JOIN 
        Palestra P ON IP.Id_Palestra = P.Id_Palestra
    LEFT JOIN 
        InscricaoWorkshop IW ON IW.Id_Participante = @Id_Participante
    LEFT JOIN 
        Workshop W ON IW.Id_Workshop = W.Id_Workshop
    WHERE 
        IP.Id_Participante = @Id_Participante OR IW.Id_Participante = @Id_Participante;
END
--  Relatório de Participação de um Participante



--  Relatório por Palestra e/ou Workshop
GO

CREATE PROCEDURE Relatorio_Palestra_Workshop
AS
BEGIN
    SELECT 
        'Palestra' AS Tipo,
        P.Titulo,
        COUNT(IP.Id_Participante) AS Total_Participantes
    FROM 
        Palestra P
    LEFT JOIN 
        InscricaoPalestra IP ON P.Id_Palestra = IP.Id_Palestra
    GROUP BY 
        P.Titulo;

    UNION ALL

    SELECT 
        'Workshop' AS Tipo,
        W.Titulo,
        COUNT(IW.Id_Participante) AS Total_Participantes,
        (COUNT(IW.Id_Participante) * 1.0 / W.Vagas) AS Taxa_Interesse
    FROM 
        Workshop W
    LEFT JOIN 
        InscricaoWorkshop IW ON W.Id_Workshop = IW.Id_Workshop
    GROUP BY 
        W.Titulo, W.Vagas;
END

--  Relatório por Palestra e/ou Workshop



-- Inserir Participantes
EXEC Inserir_Participante 
    @Id_Participante = 1, 
    @Nome = 'Claudio Matheus', 
    @Email = 'claudioMatheus@example.com', 
    @Tipo_Inscricao = 'Estudante', 
    @Curso = 'Ciência da Computação';

EXEC Inserir_Participante 
    @Id_Participante = 2, 
    @Nome = 'Maria Silva', 
    @Email = 'mariaSilva@example.com', 
    @Tipo_Inscricao = 'Estudante', 
    @Curso = 'Engenharia de Software';

EXEC Inserir_Participante 
    @Id_Participante = 3, 
    @Nome = 'João Pereira', 
    @Email = 'joaoPereira@example.com', 
    @Tipo_Inscricao = 'Profissional', 
    @Curso = 'Administração';

-- Inserir Palestras
EXEC Inserir_Palestra 
    @Id_Palestra = 1, 
    @Titulo = 'Aprenda a programar', 
    @Descricao = 'Aprenda programar em uma semana', 
    @Palestrante = 'Claudio Matheus', 
    @Data_Hora = '2024-11-04 10:00:00', 
    @Duracao = '05:00:00';

EXEC Inserir_Palestra 
    @Id_Palestra = 2, 
    @Titulo = 'Inteligência Artificial na Prática', 
    @Descricao = 'Aplicações de IA em diversas áreas', 
    @Palestrante = 'Ana Paula', 
    @Data_Hora = '2024-11-05 14:00:00', 
    @Duracao = '03:00:00';

-- Inserir Workshops
EXEC Inserir_Workshop 
    @Id_Workshop = 1, 
    @Titulo = 'Workshop de Desenvolvimento Web', 
    @Descricao = 'Aprenda as melhores práticas de desenvolvimento web em um dia.', 
    @Instrutor = 'Ana Paula', 
    @Data_Hora = '2024-11-10 09:00:00', 
    @Duracao = '04:00:00', 
    @Vagas = 30;

EXEC Inserir_Workshop 
    @Id_Workshop = 2, 
    @Titulo = 'Workshop de Análise de Dados', 
    @Descricao = 'Domine a análise de dados com Python', 
    @Instrutor = 'Carlos Santos', 
    @Data_Hora = '2024-11-11 09:00:00', 
    @Duracao = '04:00:00', 
    @Vagas = 25;

-- Inscrever Participantes nas Palestras
EXEC Inscrever_Participante_Palestra 
    @Id_Participante = 1, 
    @Id_Palestra = 1;

EXEC Inscrever_Participante_Palestra 
    @Id_Participante = 2, 
    @Id_Palestra = 2;

EXEC Inscrever_Participante_Palestra 
    @Id_Participante = 3, 
    @Id_Palestra = 1;

-- Inscrever Participantes nos Workshops
EXEC Inscrever_Participante_Workshop 
    @Id_Participante = 1, 
    @Id_Workshop = 1;

EXEC Inscrever_Participante_Workshop 
    @Id_Participante = 2, 
    @Id_Workshop = 1;

EXEC Inscrever_Participante_Workshop 
    @Id_Participante = 3, 
    @Id_Workshop = 2;
