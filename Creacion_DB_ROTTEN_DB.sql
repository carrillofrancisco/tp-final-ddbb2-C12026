
CREATE DATABASE Rotten_DB;
GO

USE Rotten_DB;
GO

CREATE TABLE dbo.Pais
(
    id_pais INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    CONSTRAINT PK_Pais PRIMARY KEY (id_pais),
    CONSTRAINT UQ_Pais_Nombre UNIQUE (nombre)
);
GO

CREATE TABLE dbo.Genero
(
    id_genero INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    CONSTRAINT PK_Genero PRIMARY KEY (id_genero),
    CONSTRAINT UQ_Genero_Nombre UNIQUE (nombre)
);
GO

CREATE TABLE dbo.Clasificacion_edad
(
    id_clasificacion VARCHAR(20) NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    descripcion VARCHAR(255) NULL,
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
