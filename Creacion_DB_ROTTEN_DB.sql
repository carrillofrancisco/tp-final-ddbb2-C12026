USE master;
GO

ALTER DATABASE Rotten_DB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

DROP DATABASE Rotten_DB;
GO




CREATE DATABASE Rotten_DB;
GO

USE Rotten_DB;
GO

CREATE TABLE dbo.Pais
(
    id_pais INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    activo BIT NOT NULL
        CONSTRAINT DF_Pais_Activo DEFAULT (1),
    CONSTRAINT PK_Pais PRIMARY KEY (id_pais),
    CONSTRAINT UQ_Pais_Nombre UNIQUE (nombre)
);
GO

CREATE TABLE dbo.Genero
(
    id_genero INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    activo BIT NOT NULL
        CONSTRAINT DF_Genero_Activo DEFAULT (1),
    CONSTRAINT PK_Genero PRIMARY KEY (id_genero),
    CONSTRAINT UQ_Genero_Nombre UNIQUE (nombre)
);
GO

CREATE TABLE dbo.Clasificacion_edad
(
    id_clasificacion VARCHAR(20) NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    descripcion VARCHAR(255) NULL,
    activo BIT NOT NULL
        CONSTRAINT DF_Clasificacion_edad_Activo DEFAULT (1),
    CONSTRAINT PK_Clasificacion_edad PRIMARY KEY (id_clasificacion),
    CONSTRAINT UQ_Clasificacion_edad_Nombre UNIQUE (nombre)
);
GO

CREATE TABLE dbo.Usuarios
(
    id_usuarios BIGINT IDENTITY(1,1) NOT NULL,
    nombre_usuario VARCHAR(255) NOT NULL,
    pass VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    fecha_nac DATE NULL,
    tipo_usuario VARCHAR(20) NOT NULL,
    activo BIT NOT NULL
        CONSTRAINT DF_Usuarios_Activo DEFAULT (1),
    CONSTRAINT PK_Usuarios PRIMARY KEY (id_usuarios),
    CONSTRAINT UQ_Usuarios_Email UNIQUE (email),
    CONSTRAINT UQ_Usuarios_NombreUsuario UNIQUE (nombre_usuario),
    CONSTRAINT CK_Usuarios_TipoUsuario CHECK (tipo_usuario IN ('Espectador', 'Critico', 'Administrador'))
);
GO

CREATE TABLE dbo.Persona
(
    id_persona INT IDENTITY(1,1) NOT NULL,
    nombre_persona VARCHAR(255) NOT NULL,
    apellido_persona VARCHAR(255) NOT NULL,
    fecha_nacimiento DATE NULL,
    nacionalidad INT NULL,
    url_img VARCHAR(255) NULL,
    activo BIT NOT NULL
        CONSTRAINT DF_Persona_Activo DEFAULT (1),
    CONSTRAINT PK_Persona PRIMARY KEY (id_persona),
    CONSTRAINT FK_Persona_Pais FOREIGN KEY (nacionalidad)
        REFERENCES dbo.Pais(id_pais)
);
GO

CREATE TABLE dbo.Peliculas
(
    id_peliculas INT IDENTITY(1,1) NOT NULL,
    titulo VARCHAR(255) NOT NULL,
    sinopsis VARCHAR(MAX) NULL,
    duracion_minutos INT NOT NULL,
    fecha_estreno DATE NULL,
    id_genero INT NOT NULL,
    pais_origen INT NOT NULL,
    url_img VARCHAR(255) NULL,
    clasificacion_edad VARCHAR(20) NOT NULL,
    estudio_cine VARCHAR(255) NULL,
    activo BIT NOT NULL
        CONSTRAINT DF_Peliculas_Activo DEFAULT (1),
    CONSTRAINT PK_Peliculas PRIMARY KEY (id_peliculas),
    CONSTRAINT FK_Peliculas_Genero FOREIGN KEY (id_genero)
        REFERENCES dbo.Genero(id_genero),
    CONSTRAINT FK_Peliculas_Pais FOREIGN KEY (pais_origen)
        REFERENCES dbo.Pais(id_pais),
    CONSTRAINT FK_Peliculas_ClasificacionEdad FOREIGN KEY (clasificacion_edad)
        REFERENCES dbo.Clasificacion_edad(id_clasificacion),
    CONSTRAINT CK_Peliculas_Duracion CHECK (duracion_minutos > 0)

);
GO

CREATE TABLE dbo.Elenco
(
    id_elenco INT IDENTITY(1,1) NOT NULL,
    id_pelicula INT NOT NULL,
    id_persona INT NOT NULL,
    rol VARCHAR(255) NOT NULL,
    activo BIT NOT NULL
        CONSTRAINT DF_Elenco_Activo DEFAULT (1),
    CONSTRAINT PK_Elenco PRIMARY KEY (id_elenco),
    CONSTRAINT FK_Elenco_Peliculas FOREIGN KEY (id_pelicula)
        REFERENCES dbo.Peliculas(id_peliculas),
    CONSTRAINT FK_Elenco_Persona FOREIGN KEY (id_persona)
        REFERENCES dbo.Persona(id_persona),
    CONSTRAINT UQ_Elenco_PeliculaPersonaRol UNIQUE (id_pelicula, id_persona, rol)
);
GO

CREATE TABLE dbo.Personaje
(
    id_personaje INT IDENTITY(1,1) NOT NULL,
    nombre_personaje VARCHAR(255) NOT NULL,
    id_elenco INT NOT NULL,
    activo BIT NOT NULL
        CONSTRAINT DF_Personaje_Activo DEFAULT (1),
    CONSTRAINT PK_Personaje PRIMARY KEY (id_personaje),
    CONSTRAINT FK_Personaje_Elenco FOREIGN KEY (id_elenco)
        REFERENCES dbo.Elenco(id_elenco)
);
GO

CREATE TABLE dbo.Calificaciones
(
    id_calificacion INT IDENTITY(1,1) NOT NULL,
    id_usuario BIGINT NOT NULL,
    id_pelicula INT NOT NULL,
    puntuacion INT NOT NULL,
    comentario VARCHAR(MAX) NULL,
    fecha DATETIME NOT NULL
        CONSTRAINT DF_Calificaciones_Fecha DEFAULT (GETDATE()),
    activo BIT NOT NULL
        CONSTRAINT DF_Calificaciones_Activo DEFAULT (1),
    CONSTRAINT PK_Calificaciones PRIMARY KEY (id_calificacion),
    CONSTRAINT FK_Calificaciones_Usuarios FOREIGN KEY (id_usuario)
        REFERENCES dbo.Usuarios(id_usuarios),
    CONSTRAINT FK_Calificaciones_Peliculas FOREIGN KEY (id_pelicula)
        REFERENCES dbo.Peliculas(id_peliculas),
    CONSTRAINT CK_Calificaciones_Puntuacion CHECK (puntuacion BETWEEN 1 AND 5),
    CONSTRAINT UQ_Calificaciones_UsuarioPelicula UNIQUE (id_usuario, id_pelicula)
);
GO

CREATE INDEX IX_Peliculas_Titulo ON dbo.Peliculas(titulo);
CREATE INDEX IX_Calificaciones_Pelicula ON dbo.Calificaciones(id_pelicula);
CREATE INDEX IX_Elenco_Pelicula ON dbo.Elenco(id_pelicula);
CREATE INDEX IX_Personaje_Elenco ON dbo.Personaje(id_elenco);
GO


INSERT INTO dbo.Pais (nombre)
VALUES
('Argentina'),
('Estados Unidos'),
('Reino Unido'),
('Francia'),
('Japon');
GO

INSERT INTO dbo.Genero (nombre)
VALUES
('Accion'),
('Comedia'),
('Drama'),
('Terror'),
('Ciencia ficcion'),
('Animacion');
GO

INSERT INTO dbo.Clasificacion_edad (id_clasificacion, nombre, descripcion)
VALUES
('ATP', 'Apta para todo publico', 'Pelicula apta para todas las edades'),
('+13', 'Mayores de 13', 'Requiere supervision para menores de 13 anios'),
('+16', 'Mayores de 16', 'Contenido recomendado para mayores de 16 anios'),
('+18', 'Mayores de 18', 'Contenido recomendado solo para adultos');
GO

INSERT INTO dbo.Usuarios (nombre_usuario, pass, email, fecha_nac, tipo_usuario)
VALUES
('lucia', '1234', 'lucia@mail.com', '2000-05-10', 'Espectador'),
('francisco', '1234', 'francisco@mail.com', '1998-03-21', 'Critico'),
('agustin', '1234', 'agustin@mail.com', '1999-11-02', 'Administrador');
GO

INSERT INTO dbo.Peliculas
(
    titulo,
    sinopsis,
    duracion_minutos,
    fecha_estreno,
    id_genero,
    pais_origen,
    url_img,
    clasificacion_edad,
    estudio_cine
)
VALUES
(
    'Inception',
    'Un ladron especializado en infiltrarse en los suenos recibe una mision imposible.',
    148,
    '2010-07-16',
    (SELECT id_genero FROM dbo.Genero WHERE nombre = 'Ciencia ficcion'),
    (SELECT id_pais FROM dbo.Pais WHERE nombre = 'Estados Unidos'),
    NULL,
    '+13',
    'Warner Bros.'
),
(
    'Relatos Salvajes',
    'Seis historias independientes atravesadas por la venganza y el descontrol.',
    122,
    '2014-08-21',
    (SELECT id_genero FROM dbo.Genero WHERE nombre = 'Drama'),
    (SELECT id_pais FROM dbo.Pais WHERE nombre = 'Argentina'),
    NULL,
    '+16',
    'Kramer & Sigman Films'
);
GO

INSERT INTO dbo.Calificaciones (id_usuario, id_pelicula, puntuacion, comentario)
VALUES
(
    (SELECT id_usuarios FROM dbo.Usuarios WHERE nombre_usuario = 'lucia'),
    (SELECT id_peliculas FROM dbo.Peliculas WHERE titulo = 'Inception'),
    5,
    'Muy buena pelicula.'
),
(
    (SELECT id_usuarios FROM dbo.Usuarios WHERE nombre_usuario = 'francisco'),
    (SELECT id_peliculas FROM dbo.Peliculas WHERE titulo = 'Inception'),
    4,
    'Buena construccion narrativa.'
);
GO

SELECT *
FROM dbo.Peliculas;
GO

-- =============================================
-- STORED PROCEDURES ABM
-- =============================================
GO

-- SP_ABM_Pais.sql
CREATE OR ALTER PROCEDURE dbo.Agregar_Pais
    @nombre VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    SET @nombre = LTRIM(RTRIM(@nombre));

    IF @nombre IS NULL OR @nombre = ''
        THROW 50001, 'El nombre del pais es obligatorio.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Pais
        WHERE nombre = @nombre
    )
        THROW 50002, 'Ya existe un pais con ese nombre.', 1;

    INSERT INTO dbo.Pais (nombre)
    VALUES (@nombre);

    SELECT
        CAST(SCOPE_IDENTITY() AS INT) AS id_pais,
        @nombre AS nombre;
END;
GO

CREATE OR ALTER PROCEDURE dbo.Modificar_Pais
    @id_pais INT,
    @nombre VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    SET @nombre = LTRIM(RTRIM(@nombre));

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Pais
        WHERE id_pais = @id_pais
          AND activo = 1
    )
        THROW 50003, 'El pais indicado no existe.', 1;

    IF @nombre IS NULL OR @nombre = ''
        THROW 50004, 'El nombre del pais es obligatorio.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Pais
        WHERE nombre = @nombre
          AND id_pais <> @id_pais
    )
        THROW 50005, 'Ya existe otro pais con ese nombre.', 1;

    UPDATE dbo.Pais
    SET nombre = @nombre
    WHERE id_pais = @id_pais;

    SELECT id_pais, nombre
    FROM dbo.Pais
    WHERE id_pais = @id_pais;
END;
GO

CREATE OR ALTER PROCEDURE dbo.Eliminar_Pais
    @id_pais INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Pais
        WHERE id_pais = @id_pais
          AND activo = 1
    )
        THROW 50006, 'El pais indicado no existe.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Persona
        WHERE nacionalidad = @id_pais
          AND activo = 1
    )
        THROW 50007, 'No se puede eliminar el pais porque esta asociado a una persona.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Peliculas
        WHERE pais_origen = @id_pais
          AND activo = 1
    )
        THROW 50008, 'No se puede eliminar el pais porque esta asociado a una pelicula.', 1;

    UPDATE dbo.Pais
    SET activo = 0
    WHERE id_pais = @id_pais;

    SELECT @id_pais AS id_pais_eliminado_logicamente;
END;
GO

CREATE OR ALTER PROCEDURE dbo.Listar_Paises
AS
BEGIN
    SET NOCOUNT ON;

    SELECT id_pais, nombre
    FROM dbo.Pais
    WHERE activo = 1
    ORDER BY nombre;
END;
GO

-- SP_ABM_Genero.sql
CREATE OR ALTER PROCEDURE dbo.Agregar_Genero
    @nombre VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    SET @nombre = LTRIM(RTRIM(@nombre));

    IF @nombre IS NULL OR @nombre = ''
        THROW 50101, 'El nombre del genero es obligatorio.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Genero
        WHERE nombre = @nombre
    )
        THROW 50102, 'Ya existe un genero con ese nombre.', 1;

    INSERT INTO dbo.Genero (nombre)
    VALUES (@nombre);

    SELECT
        CAST(SCOPE_IDENTITY() AS INT) AS id_genero,
        @nombre AS nombre;
END;
GO

CREATE OR ALTER PROCEDURE dbo.Modificar_Genero
    @id_genero INT,
    @nombre VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    SET @nombre = LTRIM(RTRIM(@nombre));

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Genero
        WHERE id_genero = @id_genero
          AND activo = 1
    )
        THROW 50103, 'El genero indicado no existe.', 1;

    IF @nombre IS NULL OR @nombre = ''
        THROW 50104, 'El nombre del genero es obligatorio.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Genero
        WHERE nombre = @nombre
          AND id_genero <> @id_genero
    )
        THROW 50105, 'Ya existe otro genero con ese nombre.', 1;

    UPDATE dbo.Genero
    SET nombre = @nombre
    WHERE id_genero = @id_genero;

    SELECT id_genero, nombre
    FROM dbo.Genero
    WHERE id_genero = @id_genero;
END;
GO

CREATE OR ALTER PROCEDURE dbo.Eliminar_Genero
    @id_genero INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Genero
        WHERE id_genero = @id_genero
          AND activo = 1
    )
        THROW 50106, 'El genero indicado no existe.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Peliculas
        WHERE id_genero = @id_genero
          AND activo = 1
    )
        THROW 50107, 'No se puede eliminar el genero porque esta asociado a una pelicula.', 1;

    UPDATE dbo.Genero
    SET activo = 0
    WHERE id_genero = @id_genero;

    SELECT @id_genero AS id_genero_eliminado_logicamente;
END;
GO

CREATE OR ALTER PROCEDURE dbo.Listar_Generos
AS
BEGIN
    SET NOCOUNT ON;

    SELECT id_genero, nombre
    FROM dbo.Genero
    WHERE activo = 1
    ORDER BY nombre;
END;
GO

-- SP_ABM_Clasificacion_Edad.sql
CREATE OR ALTER PROCEDURE dbo.Agregar_Clasificacion_Edad
    @id_clasificacion VARCHAR(20),
    @nombre VARCHAR(255),
    @descripcion VARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SET @id_clasificacion = LTRIM(RTRIM(@id_clasificacion));
    SET @nombre = LTRIM(RTRIM(@nombre));
    SET @descripcion = NULLIF(LTRIM(RTRIM(@descripcion)), '');

    IF @id_clasificacion IS NULL OR @id_clasificacion = ''
        THROW 50201, 'El identificador de la clasificacion es obligatorio.', 1;

    IF @nombre IS NULL OR @nombre = ''
        THROW 50202, 'El nombre de la clasificacion es obligatorio.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Clasificacion_edad
        WHERE id_clasificacion = @id_clasificacion
    )
        THROW 50203, 'Ya existe una clasificacion con ese identificador.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Clasificacion_edad
        WHERE nombre = @nombre
    )
        THROW 50204, 'Ya existe una clasificacion con ese nombre.', 1;

    INSERT INTO dbo.Clasificacion_edad
    (
        id_clasificacion,
        nombre,
        descripcion
    )
    VALUES
    (
        @id_clasificacion,
        @nombre,
        @descripcion
    );

    SELECT id_clasificacion, nombre, descripcion
    FROM dbo.Clasificacion_edad
    WHERE id_clasificacion = @id_clasificacion;
END;
GO

CREATE OR ALTER PROCEDURE dbo.Modificar_Clasificacion_Edad
    @id_clasificacion VARCHAR(20),
    @nombre VARCHAR(255),
    @descripcion VARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SET @id_clasificacion = LTRIM(RTRIM(@id_clasificacion));
    SET @nombre = LTRIM(RTRIM(@nombre));
    SET @descripcion = NULLIF(LTRIM(RTRIM(@descripcion)), '');

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Clasificacion_edad
        WHERE id_clasificacion = @id_clasificacion
          AND activo = 1
    )
        THROW 50205, 'La clasificacion indicada no existe.', 1;

    IF @nombre IS NULL OR @nombre = ''
        THROW 50206, 'El nombre de la clasificacion es obligatorio.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Clasificacion_edad
        WHERE nombre = @nombre
          AND id_clasificacion <> @id_clasificacion
    )
        THROW 50207, 'Ya existe otra clasificacion con ese nombre.', 1;

    UPDATE dbo.Clasificacion_edad
    SET nombre = @nombre,
        descripcion = @descripcion
    WHERE id_clasificacion = @id_clasificacion;

    SELECT id_clasificacion, nombre, descripcion
    FROM dbo.Clasificacion_edad
    WHERE id_clasificacion = @id_clasificacion;
END;
GO

CREATE OR ALTER PROCEDURE dbo.Eliminar_Clasificacion_Edad
    @id_clasificacion VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    SET @id_clasificacion = LTRIM(RTRIM(@id_clasificacion));

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Clasificacion_edad
        WHERE id_clasificacion = @id_clasificacion
          AND activo = 1
    )
        THROW 50208, 'La clasificacion indicada no existe.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Peliculas
        WHERE clasificacion_edad = @id_clasificacion
          AND activo = 1
    )
        THROW 50209, 'No se puede eliminar la clasificacion porque esta asociada a una pelicula.', 1;

    UPDATE dbo.Clasificacion_edad
    SET activo = 0
    WHERE id_clasificacion = @id_clasificacion;

    SELECT @id_clasificacion AS id_clasificacion_eliminada_logicamente;
END;
GO

CREATE OR ALTER PROCEDURE dbo.Listar_Clasificaciones_Edad
AS
BEGIN
    SET NOCOUNT ON;

    SELECT id_clasificacion, nombre, descripcion
    FROM dbo.Clasificacion_edad
    WHERE activo = 1
    ORDER BY nombre;
END;
GO

-- SP_ABM_Usuarios.sql
CREATE OR ALTER PROCEDURE dbo.Agregar_Usuario
    @nombre_usuario VARCHAR(255),
    @pass VARCHAR(255),
    @email VARCHAR(255),
    @tipo_usuario VARCHAR(20),
    @fecha_nac DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SET @nombre_usuario = LTRIM(RTRIM(@nombre_usuario));
    SET @pass = LTRIM(RTRIM(@pass));
    SET @email = LTRIM(RTRIM(@email));
    SET @tipo_usuario = LTRIM(RTRIM(@tipo_usuario));

    IF @nombre_usuario IS NULL OR @nombre_usuario = ''
        THROW 50301, 'El nombre de usuario es obligatorio.', 1;

    IF @pass IS NULL OR @pass = ''
        THROW 50302, 'La contrasena es obligatoria.', 1;

    IF @email IS NULL OR @email = ''
        THROW 50303, 'El email es obligatorio.', 1;

    IF @tipo_usuario NOT IN ('Espectador', 'Critico', 'Administrador')
        THROW 50304, 'El tipo de usuario no es valido.', 1;

    IF @fecha_nac > CAST(GETDATE() AS DATE)
        THROW 50305, 'La fecha de nacimiento no puede ser futura.', 1;

    IF EXISTS
    (
        SELECT 1
    FROM dbo.Usuarios
    WHERE nombre_usuario = @nombre_usuario
    )
        THROW 50306, 'Ya existe un usuario con ese nombre.', 1;

    IF EXISTS
    (
        SELECT 1
    FROM dbo.Usuarios
    WHERE email = @email
    )
        THROW 50307, 'Ya existe un usuario con ese email.', 1;

    INSERT INTO dbo.Usuarios
        (
        nombre_usuario,
        pass,
        email,
        fecha_nac,
        tipo_usuario
        )
    VALUES
        (
            @nombre_usuario,
            @pass,
            @email,
            @fecha_nac,
            @tipo_usuario
    );

    SELECT
        CAST(SCOPE_IDENTITY() AS BIGINT) AS id_usuarios,
        @nombre_usuario AS nombre_usuario,
        @email AS email,
        @fecha_nac AS fecha_nac,
        @tipo_usuario AS tipo_usuario;
END;
GO

CREATE OR ALTER PROCEDURE dbo.Modificar_Usuario
    @id_usuario BIGINT,
    @nombre_usuario VARCHAR(255),
    @pass VARCHAR(255),
    @email VARCHAR(255),
    @tipo_usuario VARCHAR(20),
    @fecha_nac DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SET @nombre_usuario = LTRIM(RTRIM(@nombre_usuario));
    SET @pass = LTRIM(RTRIM(@pass));
    SET @email = LTRIM(RTRIM(@email));
    SET @tipo_usuario = LTRIM(RTRIM(@tipo_usuario));

    IF NOT EXISTS
    (
        SELECT 1
    FROM dbo.Usuarios
    WHERE id_usuarios = @id_usuario
        AND activo = 1
    )
        THROW 50308, 'El usuario indicado no existe.', 1;

    IF @nombre_usuario IS NULL OR @nombre_usuario = ''
        THROW 50309, 'El nombre de usuario es obligatorio.', 1;

    IF @pass IS NULL OR @pass = ''
        THROW 50310, 'La contrasena es obligatoria.', 1;

    IF @email IS NULL OR @email = ''
        THROW 50311, 'El email es obligatorio.', 1;

    IF @tipo_usuario NOT IN ('Espectador', 'Critico', 'Administrador')
        THROW 50312, 'El tipo de usuario no es valido.', 1;

    IF @fecha_nac > CAST(GETDATE() AS DATE)
        THROW 50313, 'La fecha de nacimiento no puede ser futura.', 1;

    IF EXISTS
    (
        SELECT 1
    FROM dbo.Usuarios
    WHERE nombre_usuario = @nombre_usuario
        AND id_usuarios <> @id_usuario
    )
        THROW 50314, 'Ya existe otro usuario con ese nombre.', 1;

    IF EXISTS
    (
        SELECT 1
    FROM dbo.Usuarios
    WHERE email = @email
        AND id_usuarios <> @id_usuario
    )
        THROW 50315, 'Ya existe otro usuario con ese email.', 1;

    UPDATE dbo.Usuarios
    SET nombre_usuario = @nombre_usuario,
        pass = @pass,
        email = @email,
        fecha_nac = @fecha_nac,
        tipo_usuario = @tipo_usuario
    WHERE id_usuarios = @id_usuario
        AND activo = 1;

    SELECT id_usuarios, nombre_usuario, email, fecha_nac, tipo_usuario
    FROM dbo.Usuarios
    WHERE id_usuarios = @id_usuario
        AND activo = 1;
END;
GO

CREATE OR ALTER PROCEDURE dbo.Eliminar_Usuario
    @id_usuario BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS
    (
        SELECT 1
    FROM dbo.Usuarios
    WHERE id_usuarios = @id_usuario
        AND activo = 1
    )
        THROW 50316, 'El usuario indicado no existe.', 1;

    IF EXISTS
    (
        SELECT 1
    FROM dbo.Calificaciones
    WHERE id_usuario = @id_usuario
        AND activo = 1
    )
        THROW 50317, 'No se puede eliminar el usuario porque tiene calificaciones asociadas.', 1;

    UPDATE dbo.Usuarios
    SET activo = 0
    WHERE id_usuarios = @id_usuario
        AND activo = 1;

    SELECT @id_usuario AS id_usuario_eliminado_logicamente;
END;
GO

CREATE OR ALTER PROCEDURE dbo.Listar_Usuarios
AS
BEGIN
    SET NOCOUNT ON;

    SELECT id_usuarios, nombre_usuario, email, fecha_nac, tipo_usuario
    FROM dbo.Usuarios
    WHERE activo = 1
    ORDER BY nombre_usuario;
END;
GO

CREATE OR ALTER PROCEDURE dbo.Login_Usuario
    @nombre_usuario VARCHAR(255),
    @pass VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    SET @nombre_usuario = LTRIM(RTRIM(@nombre_usuario));
    SET @pass = LTRIM(RTRIM(@pass));

    IF @nombre_usuario IS NULL OR @nombre_usuario = ''
        THROW 50318, 'El nombre de usuario es obligatorio para iniciar sesion.', 1;

    IF @pass IS NULL OR @pass = ''
        THROW 50319, 'La contrasena es obligatoria para iniciar sesion.', 1;

    IF NOT EXISTS
    (
        SELECT 1
    FROM dbo.Usuarios
    WHERE nombre_usuario = @nombre_usuario AND pass = @pass
        AND activo = 1
    )
        THROW 50320, 'Credenciales invalidas. Verifique el usuario y la contrasena.', 1;

    SELECT
        id_usuarios,
        nombre_usuario,
        email,
        tipo_usuario
    FROM dbo.Usuarios
    WHERE nombre_usuario = @nombre_usuario AND pass = @pass
        AND activo = 1;
END;
GO

-- SP_ABM_Persona.sql
CREATE OR ALTER PROCEDURE dbo.Agregar_Persona
    @nombre_persona VARCHAR(255),
    @apellido_persona VARCHAR(255),
    @fecha_nacimiento DATE = NULL,
    @nacionalidad INT = NULL,
    @url_img VARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SET @nombre_persona = LTRIM(RTRIM(@nombre_persona));
    SET @apellido_persona = LTRIM(RTRIM(@apellido_persona));
    SET @url_img = NULLIF(LTRIM(RTRIM(@url_img)), '');

    IF @nombre_persona IS NULL OR @nombre_persona = ''
        THROW 50401, 'El nombre de la persona es obligatorio.', 1;

    IF @apellido_persona IS NULL OR @apellido_persona = ''
        THROW 50402, 'El apellido de la persona es obligatorio.', 1;

    IF @fecha_nacimiento > CAST(GETDATE() AS DATE)
        THROW 50403, 'La fecha de nacimiento no puede ser futura.', 1;

    IF @nacionalidad IS NOT NULL
       AND NOT EXISTS
       (
           SELECT 1
           FROM dbo.Pais
           WHERE id_pais = @nacionalidad
             AND activo = 1
       )
        THROW 50404, 'El pais indicado como nacionalidad no existe.', 1;

    INSERT INTO dbo.Persona
    (
        nombre_persona,
        apellido_persona,
        fecha_nacimiento,
        nacionalidad,
        url_img
    )
    VALUES
    (
        @nombre_persona,
        @apellido_persona,
        @fecha_nacimiento,
        @nacionalidad,
        @url_img
    );

    SELECT
        CAST(SCOPE_IDENTITY() AS INT) AS id_persona,
        @nombre_persona AS nombre_persona,
        @apellido_persona AS apellido_persona,
        @fecha_nacimiento AS fecha_nacimiento,
        @nacionalidad AS nacionalidad,
        @url_img AS url_img;
END;
GO

CREATE OR ALTER PROCEDURE dbo.Modificar_Persona
    @id_persona INT,
    @nombre_persona VARCHAR(255),
    @apellido_persona VARCHAR(255),
    @fecha_nacimiento DATE = NULL,
    @nacionalidad INT = NULL,
    @url_img VARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SET @nombre_persona = LTRIM(RTRIM(@nombre_persona));
    SET @apellido_persona = LTRIM(RTRIM(@apellido_persona));
    SET @url_img = NULLIF(LTRIM(RTRIM(@url_img)), '');

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Persona
        WHERE id_persona = @id_persona
          AND activo = 1
    )
        THROW 50405, 'La persona indicada no existe.', 1;

    IF @nombre_persona IS NULL OR @nombre_persona = ''
        THROW 50406, 'El nombre de la persona es obligatorio.', 1;

    IF @apellido_persona IS NULL OR @apellido_persona = ''
        THROW 50407, 'El apellido de la persona es obligatorio.', 1;

    IF @fecha_nacimiento > CAST(GETDATE() AS DATE)
        THROW 50408, 'La fecha de nacimiento no puede ser futura.', 1;

    IF @nacionalidad IS NOT NULL
       AND NOT EXISTS
       (
           SELECT 1
           FROM dbo.Pais
           WHERE id_pais = @nacionalidad
             AND activo = 1
       )
        THROW 50409, 'El pais indicado como nacionalidad no existe.', 1;

    UPDATE dbo.Persona
    SET nombre_persona = @nombre_persona,
        apellido_persona = @apellido_persona,
        fecha_nacimiento = @fecha_nacimiento,
        nacionalidad = @nacionalidad,
        url_img = @url_img
    WHERE id_persona = @id_persona;

    SELECT id_persona, nombre_persona, apellido_persona,
           fecha_nacimiento, nacionalidad, url_img
    FROM dbo.Persona
    WHERE id_persona = @id_persona;
END;
GO

CREATE OR ALTER PROCEDURE dbo.Eliminar_Persona
    @id_persona INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Persona
        WHERE id_persona = @id_persona
          AND activo = 1
    )
        THROW 50410, 'La persona indicada no existe.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Elenco
        WHERE id_persona = @id_persona
          AND activo = 1
    )
        THROW 50411, 'No se puede eliminar la persona porque pertenece a un elenco.', 1;

    UPDATE dbo.Persona
    SET activo = 0
    WHERE id_persona = @id_persona;

    SELECT @id_persona AS id_persona_eliminada_logicamente;
END;
GO

CREATE OR ALTER PROCEDURE dbo.Listar_Personas
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        pe.id_persona,
        pe.nombre_persona,
        pe.apellido_persona,
        pe.fecha_nacimiento,
        pe.nacionalidad AS id_pais,
        pa.nombre AS pais,
        pe.url_img
    FROM dbo.Persona pe
    LEFT JOIN dbo.Pais pa
        ON pa.id_pais = pe.nacionalidad
       AND pa.activo = 1
    WHERE pe.activo = 1
    ORDER BY pe.apellido_persona, pe.nombre_persona;
END;
GO

-- SP_ABM_Peliculas.sql
CREATE OR ALTER PROCEDURE dbo.Agregar_Pelicula
    @titulo VARCHAR(255),
    @duracion_minutos INT,
    @id_genero INT,
    @pais_origen INT,
    @clasificacion_edad VARCHAR(20),
    @sinopsis VARCHAR(MAX) = NULL,
    @fecha_estreno DATE = NULL,
    @url_img VARCHAR(255) = NULL,
    @estudio_cine VARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SET @titulo = LTRIM(RTRIM(@titulo));
    SET @clasificacion_edad = LTRIM(RTRIM(@clasificacion_edad));
    SET @sinopsis = NULLIF(LTRIM(RTRIM(@sinopsis)), '');
    SET @url_img = NULLIF(LTRIM(RTRIM(@url_img)), '');
    SET @estudio_cine = NULLIF(LTRIM(RTRIM(@estudio_cine)), '');

    IF @titulo IS NULL OR @titulo = ''
        THROW 50501, 'El titulo de la pelicula es obligatorio.', 1;

    IF @duracion_minutos IS NULL OR @duracion_minutos <= 0
        THROW 50502, 'La duracion debe ser mayor a cero.', 1;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Genero
        WHERE id_genero = @id_genero
          AND activo = 1
    )
        THROW 50503, 'El genero indicado no existe.', 1;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Pais
        WHERE id_pais = @pais_origen
          AND activo = 1
    )
        THROW 50504, 'El pais de origen indicado no existe.', 1;

    IF @clasificacion_edad IS NULL OR @clasificacion_edad = ''
        THROW 50505, 'La clasificacion de edad es obligatoria.', 1;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Clasificacion_edad
        WHERE id_clasificacion = @clasificacion_edad
          AND activo = 1
    )
        THROW 50506, 'La clasificacion de edad indicada no existe.', 1;

    INSERT INTO dbo.Peliculas
    (
        titulo,
        sinopsis,
        duracion_minutos,
        fecha_estreno,
        id_genero,
        pais_origen,
        url_img,
        clasificacion_edad,
        estudio_cine
    )
    VALUES
    (
        @titulo,
        @sinopsis,
        @duracion_minutos,
        @fecha_estreno,
        @id_genero,
        @pais_origen,
        @url_img,
        @clasificacion_edad,
        @estudio_cine
    );

    DECLARE @id_pelicula INT = CAST(SCOPE_IDENTITY() AS INT);

    EXEC dbo.Obtener_Pelicula_Por_Id
        @id_pelicula = @id_pelicula;
END;
GO

CREATE OR ALTER PROCEDURE dbo.Modificar_Pelicula
    @id_pelicula INT,
    @titulo VARCHAR(255),
    @duracion_minutos INT,
    @id_genero INT,
    @pais_origen INT,
    @clasificacion_edad VARCHAR(20),
    @sinopsis VARCHAR(MAX) = NULL,
    @fecha_estreno DATE = NULL,
    @url_img VARCHAR(255) = NULL,
    @estudio_cine VARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SET @titulo = LTRIM(RTRIM(@titulo));
    SET @clasificacion_edad = LTRIM(RTRIM(@clasificacion_edad));
    SET @sinopsis = NULLIF(LTRIM(RTRIM(@sinopsis)), '');
    SET @url_img = NULLIF(LTRIM(RTRIM(@url_img)), '');
    SET @estudio_cine = NULLIF(LTRIM(RTRIM(@estudio_cine)), '');

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Peliculas
        WHERE id_peliculas = @id_pelicula
          AND activo = 1
    )
        THROW 50507, 'La pelicula indicada no existe.', 1;

    IF @titulo IS NULL OR @titulo = ''
        THROW 50508, 'El titulo de la pelicula es obligatorio.', 1;

    IF @duracion_minutos IS NULL OR @duracion_minutos <= 0
        THROW 50509, 'La duracion debe ser mayor a cero.', 1;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Genero
        WHERE id_genero = @id_genero
          AND activo = 1
    )
        THROW 50510, 'El genero indicado no existe.', 1;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Pais
        WHERE id_pais = @pais_origen
          AND activo = 1
    )
        THROW 50511, 'El pais de origen indicado no existe.', 1;

    IF @clasificacion_edad IS NULL OR @clasificacion_edad = ''
        THROW 50512, 'La clasificacion de edad es obligatoria.', 1;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Clasificacion_edad
        WHERE id_clasificacion = @clasificacion_edad
          AND activo = 1
    )
        THROW 50513, 'La clasificacion de edad indicada no existe.', 1;

    UPDATE dbo.Peliculas
    SET titulo = @titulo,
        sinopsis = @sinopsis,
        duracion_minutos = @duracion_minutos,
        fecha_estreno = @fecha_estreno,
        id_genero = @id_genero,
        pais_origen = @pais_origen,
        url_img = @url_img,
        clasificacion_edad = @clasificacion_edad,
        estudio_cine = @estudio_cine
    WHERE id_peliculas = @id_pelicula;

    EXEC dbo.Obtener_Pelicula_Por_Id
        @id_pelicula = @id_pelicula;
END;
GO

CREATE OR ALTER PROCEDURE dbo.Eliminar_Pelicula
    @id_pelicula INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Peliculas
        WHERE id_peliculas = @id_pelicula
          AND activo = 1
    )
        THROW 50514, 'La pelicula indicada no existe.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Elenco
        WHERE id_pelicula = @id_pelicula
          AND activo = 1
    )
        THROW 50515, 'No se puede eliminar la pelicula porque tiene integrantes de elenco asociados.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Calificaciones
        WHERE id_pelicula = @id_pelicula
          AND activo = 1
    )
        THROW 50516, 'No se puede eliminar la pelicula porque tiene calificaciones asociadas.', 1;

    UPDATE dbo.Peliculas
    SET activo = 0
    WHERE id_peliculas = @id_pelicula;

    SELECT @id_pelicula AS id_pelicula_eliminada_logicamente;
END;
GO

CREATE OR ALTER PROCEDURE dbo.Listar_Peliculas
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        p.id_peliculas,
        p.titulo,
        p.sinopsis,
        p.duracion_minutos,
        p.fecha_estreno,
        p.id_genero,
        g.nombre AS genero,
        p.pais_origen AS id_pais,
        pa.nombre AS pais_origen,
        p.url_img,
        p.clasificacion_edad AS id_clasificacion,
        ce.nombre AS clasificacion,
        p.estudio_cine
    FROM dbo.Peliculas p
    INNER JOIN dbo.Genero g
        ON g.id_genero = p.id_genero
       AND g.activo = 1
    INNER JOIN dbo.Pais pa
        ON pa.id_pais = p.pais_origen
       AND pa.activo = 1
    INNER JOIN dbo.Clasificacion_edad ce
        ON ce.id_clasificacion = p.clasificacion_edad
       AND ce.activo = 1
    WHERE p.activo = 1
    ORDER BY p.titulo;
END;
GO

CREATE OR ALTER PROCEDURE dbo.Obtener_Pelicula_Por_Id
    @id_pelicula INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Peliculas
        WHERE id_peliculas = @id_pelicula
          AND activo = 1
    )
        THROW 50517, 'La pelicula indicada no existe.', 1;

    SELECT
        p.id_peliculas,
        p.titulo,
        p.sinopsis,
        p.duracion_minutos,
        p.fecha_estreno,
        p.id_genero,
        g.nombre AS genero,
        p.pais_origen AS id_pais,
        pa.nombre AS pais_origen,
        p.url_img,
        p.clasificacion_edad AS id_clasificacion,
        ce.nombre AS clasificacion,
        ce.descripcion AS descripcion_clasificacion,
        p.estudio_cine
    FROM dbo.Peliculas p
    INNER JOIN dbo.Genero g
        ON g.id_genero = p.id_genero
       AND g.activo = 1
    INNER JOIN dbo.Pais pa
        ON pa.id_pais = p.pais_origen
       AND pa.activo = 1
    INNER JOIN dbo.Clasificacion_edad ce
        ON ce.id_clasificacion = p.clasificacion_edad
       AND ce.activo = 1
    WHERE p.id_peliculas = @id_pelicula
      AND p.activo = 1;
END;
GO

-- SP_ABM_Elenco.sql
CREATE OR ALTER PROCEDURE dbo.Agregar_Elenco
    @id_pelicula INT,
    @id_persona INT,
    @rol VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    SET @rol = LTRIM(RTRIM(@rol));

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Peliculas
        WHERE id_peliculas = @id_pelicula
          AND activo = 1
    )
        THROW 50601, 'La pelicula indicada no existe.', 1;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Persona
        WHERE id_persona = @id_persona
          AND activo = 1
    )
        THROW 50602, 'La persona indicada no existe.', 1;

    IF @rol IS NULL OR @rol = ''
        THROW 50603, 'El rol es obligatorio.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Elenco
        WHERE id_pelicula = @id_pelicula
          AND id_persona = @id_persona
          AND rol = @rol
    )
        THROW 50604, 'La persona ya tiene ese rol en la pelicula.', 1;

    INSERT INTO dbo.Elenco (id_pelicula, id_persona, rol)
    VALUES (@id_pelicula, @id_persona, @rol);

    DECLARE @id_elenco INT = CAST(SCOPE_IDENTITY() AS INT);

    SELECT
        e.id_elenco,
        e.id_pelicula,
        p.titulo AS pelicula,
        e.id_persona,
        pe.nombre_persona,
        pe.apellido_persona,
        e.rol
    FROM dbo.Elenco e
    INNER JOIN dbo.Peliculas p
        ON p.id_peliculas = e.id_pelicula
       AND p.activo = 1
    INNER JOIN dbo.Persona pe
        ON pe.id_persona = e.id_persona
       AND pe.activo = 1
    WHERE e.id_elenco = @id_elenco;
END;
GO

CREATE OR ALTER PROCEDURE dbo.Modificar_Elenco
    @id_elenco INT,
    @id_pelicula INT,
    @id_persona INT,
    @rol VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    SET @rol = LTRIM(RTRIM(@rol));

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Elenco
        WHERE id_elenco = @id_elenco
          AND activo = 1
    )
        THROW 50605, 'La entrada de elenco indicada no existe.', 1;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Peliculas
        WHERE id_peliculas = @id_pelicula
          AND activo = 1
    )
        THROW 50606, 'La pelicula indicada no existe.', 1;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Persona
        WHERE id_persona = @id_persona
          AND activo = 1
    )
        THROW 50607, 'La persona indicada no existe.', 1;

    IF @rol IS NULL OR @rol = ''
        THROW 50608, 'El rol es obligatorio.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Elenco
        WHERE id_pelicula = @id_pelicula
          AND id_persona = @id_persona
          AND rol = @rol
          AND id_elenco <> @id_elenco
    )
        THROW 50609, 'La persona ya tiene ese rol en la pelicula.', 1;

    UPDATE dbo.Elenco
    SET id_pelicula = @id_pelicula,
        id_persona = @id_persona,
        rol = @rol
    WHERE id_elenco = @id_elenco;

    SELECT
        e.id_elenco,
        e.id_pelicula,
        p.titulo AS pelicula,
        e.id_persona,
        pe.nombre_persona,
        pe.apellido_persona,
        e.rol
    FROM dbo.Elenco e
    INNER JOIN dbo.Peliculas p
        ON p.id_peliculas = e.id_pelicula
       AND p.activo = 1
    INNER JOIN dbo.Persona pe
        ON pe.id_persona = e.id_persona
       AND pe.activo = 1
    WHERE e.id_elenco = @id_elenco;
END;
GO

CREATE OR ALTER PROCEDURE dbo.Eliminar_Elenco
    @id_elenco INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Elenco
        WHERE id_elenco = @id_elenco
          AND activo = 1
    )
        THROW 50610, 'La entrada de elenco indicada no existe.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Personaje
        WHERE id_elenco = @id_elenco
          AND activo = 1
    )
        THROW 50611, 'No se puede eliminar la entrada de elenco porque tiene personajes asociados.', 1;

    UPDATE dbo.Elenco
    SET activo = 0
    WHERE id_elenco = @id_elenco;

    SELECT @id_elenco AS id_elenco_eliminado_logicamente;
END;
GO

CREATE OR ALTER PROCEDURE dbo.Listar_Elenco_Por_Pelicula
    @id_pelicula INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Peliculas
        WHERE id_peliculas = @id_pelicula
          AND activo = 1
    )
        THROW 50612, 'La pelicula indicada no existe.', 1;

    SELECT
        e.id_elenco,
        e.id_pelicula,
        p.titulo AS pelicula,
        e.id_persona,
        pe.nombre_persona,
        pe.apellido_persona,
        e.rol,
        (
            SELECT COUNT(*)
            FROM dbo.Personaje pj
            WHERE pj.id_elenco = e.id_elenco
              AND pj.activo = 1
        ) AS cantidad_personajes
    FROM dbo.Elenco e
    INNER JOIN dbo.Peliculas p
        ON p.id_peliculas = e.id_pelicula
       AND p.activo = 1
    INNER JOIN dbo.Persona pe
        ON pe.id_persona = e.id_persona
       AND pe.activo = 1
    WHERE e.id_pelicula = @id_pelicula
      AND e.activo = 1
    ORDER BY e.rol, pe.apellido_persona, pe.nombre_persona;
END;
GO

-- SP_ABM_Personaje.sql
CREATE OR ALTER PROCEDURE dbo.Agregar_Personaje
    @nombre_personaje VARCHAR(255),
    @id_elenco INT
AS
BEGIN
    SET NOCOUNT ON;

    SET @nombre_personaje = LTRIM(RTRIM(@nombre_personaje));

    
    IF @nombre_personaje IS NULL OR @nombre_personaje = ''
        THROW 50701, 'El nombre del personaje es obligatorio.', 1;

  
    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Elenco
        WHERE id_elenco = @id_elenco
          AND activo = 1
    )
        THROW 50702, 'El registro de elenco especificado no existe.', 1;

    
    INSERT INTO dbo.Personaje (nombre_personaje, id_elenco)
    VALUES (@nombre_personaje, @id_elenco);

    SELECT 
        CAST(SCOPE_IDENTITY() AS INT) AS id_personaje,
        @nombre_personaje AS nombre_personaje,
        @id_elenco AS id_elenco;
END;
GO

CREATE OR ALTER PROCEDURE dbo.Modificar_Personaje
    @id_personaje INT,
    @nombre_personaje VARCHAR(255),
    @id_elenco INT
AS
BEGIN
    SET NOCOUNT ON;

    SET @nombre_personaje = LTRIM(RTRIM(@nombre_personaje));

    
    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Personaje
        WHERE id_personaje = @id_personaje
          AND activo = 1
    )
        THROW 50703, 'El personaje indicado no existe.', 1;

    IF @nombre_personaje IS NULL OR @nombre_personaje = ''
        THROW 50704, 'El nombre del personaje es obligatorio.', 1;

   
    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Elenco
        WHERE id_elenco = @id_elenco
          AND activo = 1
    )
        THROW 50705, 'El registro de elenco especificado no existe.', 1;

    
    UPDATE dbo.Personaje
    SET nombre_personaje = @nombre_personaje,
        id_elenco = @id_elenco
    WHERE id_personaje = @id_personaje;

    SELECT id_personaje, nombre_personaje, id_elenco
    FROM dbo.Personaje
    WHERE id_personaje = @id_personaje;
END;
GO

CREATE OR ALTER PROCEDURE dbo.Eliminar_Personaje
    @id_personaje INT
AS
BEGIN
    SET NOCOUNT ON;

   
    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Personaje
        WHERE id_personaje = @id_personaje
          AND activo = 1
    )
        THROW 50706, 'El personaje indicado no existe.', 1;

    -- Eliminar
    UPDATE dbo.Personaje
    SET activo = 0
    WHERE id_personaje = @id_personaje;

    SELECT @id_personaje AS id_personaje_eliminado_logicamente;
END;
GO

CREATE OR ALTER PROCEDURE dbo.Listar_Personajes_Por_Elenco
    @id_elenco INT
AS
BEGIN
    SET NOCOUNT ON;

   
    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Elenco
        WHERE id_elenco = @id_elenco
          AND activo = 1
    )
        THROW 50707, 'El registro de elenco especificado no existe.', 1;

    SELECT 
        pj.id_personaje,
        pj.nombre_personaje,
        e.rol,
        p.nombre_persona + ' ' + p.apellido_persona AS actor_persona
    FROM dbo.Personaje pj
    INNER JOIN dbo.Elenco e ON e.id_elenco = pj.id_elenco AND e.activo = 1
    INNER JOIN dbo.Persona p ON p.id_persona = e.id_persona AND p.activo = 1
    WHERE pj.id_elenco = @id_elenco
      AND pj.activo = 1
    ORDER BY pj.nombre_personaje;
END;
GO

-- SP_ABM_Calificaciones.sql
CREATE OR ALTER PROCEDURE dbo.Agregar_Calificacion
    @id_usuario BIGINT,
    @id_pelicula INT,
    @puntuacion INT,
    @comentario VARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SET @comentario = NULLIF(LTRIM(RTRIM(@comentario)), '');

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Usuarios
        WHERE id_usuarios = @id_usuario
          AND activo = 1
    )
        THROW 50801, 'El usuario especificado no existe.', 1;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Peliculas
        WHERE id_peliculas = @id_pelicula
          AND activo = 1
    )
        THROW 50802, 'La pelicula especificada no existe.', 1;

    IF @puntuacion IS NULL OR @puntuacion < 1 OR @puntuacion > 5
        THROW 50803, 'La puntuacion debe estar entre 1 y 5.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Calificaciones
        WHERE id_usuario = @id_usuario
          AND id_pelicula = @id_pelicula
          AND activo = 1
    )
        THROW 50804, 'El usuario ya ha calificado esta pelicula previamente.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Calificaciones
        WHERE id_usuario = @id_usuario
          AND id_pelicula = @id_pelicula
          AND activo = 0
    )
    BEGIN
        UPDATE dbo.Calificaciones
        SET puntuacion = @puntuacion,
            comentario = @comentario,
            fecha = GETDATE(),
            activo = 1
        WHERE id_usuario = @id_usuario
          AND id_pelicula = @id_pelicula
          AND activo = 0;

        SELECT id_usuario, id_pelicula, puntuacion, comentario, fecha
        FROM dbo.Calificaciones
        WHERE id_usuario = @id_usuario
          AND id_pelicula = @id_pelicula
          AND activo = 1;

        RETURN;
    END;

    INSERT INTO dbo.Calificaciones
        (id_usuario, id_pelicula, puntuacion, comentario, fecha)
    VALUES
        (@id_usuario, @id_pelicula, @puntuacion, @comentario, GETDATE());

    SELECT id_usuario, id_pelicula, puntuacion, comentario, fecha
    FROM dbo.Calificaciones
    WHERE id_usuario = @id_usuario
      AND id_pelicula = @id_pelicula
      AND activo = 1;
END;
GO

CREATE OR ALTER PROCEDURE dbo.Modificar_Calificacion
    @id_usuario BIGINT,
    @id_pelicula INT,
    @puntuacion INT,
    @comentario VARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SET @comentario = NULLIF(LTRIM(RTRIM(@comentario)), '');

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Calificaciones
        WHERE id_usuario = @id_usuario
          AND id_pelicula = @id_pelicula
          AND activo = 1
    )
        THROW 50805, 'No se encontro ninguna calificacion activa registrada por este usuario para esta pelicula.', 1;

    IF @puntuacion IS NULL OR @puntuacion < 1 OR @puntuacion > 5
        THROW 50806, 'La puntuacion debe estar entre 1 y 5.', 1;

    UPDATE dbo.Calificaciones
    SET puntuacion = @puntuacion,
        comentario = @comentario,
        fecha = GETDATE()
    WHERE id_usuario = @id_usuario
      AND id_pelicula = @id_pelicula
      AND activo = 1;

    SELECT id_usuario, id_pelicula, puntuacion, comentario, fecha
    FROM dbo.Calificaciones
    WHERE id_usuario = @id_usuario
      AND id_pelicula = @id_pelicula
      AND activo = 1;
END;
GO

CREATE OR ALTER PROCEDURE dbo.Eliminar_Calificacion
    @id_usuario BIGINT,
    @id_pelicula INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Calificaciones
        WHERE id_usuario = @id_usuario
          AND id_pelicula = @id_pelicula
          AND activo = 1
    )
        THROW 50807, 'No existe la calificacion activa que intenta eliminar.', 1;

    UPDATE dbo.Calificaciones
    SET activo = 0
    WHERE id_usuario = @id_usuario
      AND id_pelicula = @id_pelicula
      AND activo = 1;

    SELECT @id_usuario AS id_usuario_eliminado_logicamente,
           @id_pelicula AS id_pelicula_eliminada_logicamente;
END;
GO

CREATE OR ALTER PROCEDURE dbo.Listar_Calificaciones_Por_Pelicula
    @id_pelicula INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Peliculas
        WHERE id_peliculas = @id_pelicula
          AND activo = 1
    )
        THROW 50808, 'La pelicula especificada no existe.', 1;

    SELECT
        c.id_usuario,
        u.nombre_usuario,
        u.tipo_usuario,
        c.puntuacion,
        c.comentario,
        c.fecha
    FROM dbo.Calificaciones c
    INNER JOIN dbo.Usuarios u
        ON u.id_usuarios = c.id_usuario
       AND u.activo = 1
    WHERE c.id_pelicula = @id_pelicula
      AND c.activo = 1
    ORDER BY c.fecha DESC;
END;
GO
