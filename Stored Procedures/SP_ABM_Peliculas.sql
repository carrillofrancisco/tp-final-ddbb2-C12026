USE Rotten_DB;
GO

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
    )
        THROW 50503, 'El genero indicado no existe.', 1;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Pais
        WHERE id_pais = @pais_origen
    )
        THROW 50504, 'El pais de origen indicado no existe.', 1;

    IF @clasificacion_edad IS NULL OR @clasificacion_edad = ''
        THROW 50505, 'La clasificacion de edad es obligatoria.', 1;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Clasificacion_edad
        WHERE id_clasificacion = @clasificacion_edad
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
    )
        THROW 50510, 'El genero indicado no existe.', 1;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Pais
        WHERE id_pais = @pais_origen
    )
        THROW 50511, 'El pais de origen indicado no existe.', 1;

    IF @clasificacion_edad IS NULL OR @clasificacion_edad = ''
        THROW 50512, 'La clasificacion de edad es obligatoria.', 1;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Clasificacion_edad
        WHERE id_clasificacion = @clasificacion_edad
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
    )
        THROW 50514, 'La pelicula indicada no existe.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Elenco
        WHERE id_pelicula = @id_pelicula
    )
        THROW 50515, 'No se puede eliminar la pelicula porque tiene integrantes de elenco asociados.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Calificaciones
        WHERE id_pelicula = @id_pelicula
    )
        THROW 50516, 'No se puede eliminar la pelicula porque tiene calificaciones asociadas.', 1;

    DELETE FROM dbo.Peliculas
    WHERE id_peliculas = @id_pelicula;

    SELECT @id_pelicula AS id_pelicula_eliminada;
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
    INNER JOIN dbo.Pais pa
        ON pa.id_pais = p.pais_origen
    INNER JOIN dbo.Clasificacion_edad ce
        ON ce.id_clasificacion = p.clasificacion_edad
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
    INNER JOIN dbo.Pais pa
        ON pa.id_pais = p.pais_origen
    INNER JOIN dbo.Clasificacion_edad ce
        ON ce.id_clasificacion = p.clasificacion_edad
    WHERE p.id_peliculas = @id_pelicula;
END;
GO


/*
use Rotten_DB
exec Listar_Generos

-- 1. Agregar película
    EXEC dbo.Agregar_Pelicula
        @titulo = 'Pelicula de prueba ABM',
        @duracion_minutos = 120,
        @id_genero = 1,
        @pais_origen = 1,
        @clasificacion_edad = '+13',
        @sinopsis = 'Pelicula creada para probar los SP.',
        @fecha_estreno = '2025-06-15',
        @url_img = 'https://ejemplo.com/pelicula.jpg',
        @estudio_cine = 'Estudio de prueba';

    -- 2. Listar películas
    EXEC dbo.Listar_Peliculas;

    -- 3. Obtener película por ID
    EXEC dbo.Obtener_Pelicula_Por_Id
        @id_pelicula = 3;

    -- 4. Modificar película
    EXEC dbo.Modificar_Pelicula
        @id_pelicula = 3,
        @titulo = 'Pelicula de prueba modificada',
        @duracion_minutos = 135,
        @id_genero = 2,
        @pais_origen = 2,
        @clasificacion_edad = '+16',
        @sinopsis = 'Sinopsis modificada.',
        @fecha_estreno = '2025-07-20',
        @url_img = NULL,
        @estudio_cine = 'Estudio modificado';

    -- 6. Eliminar película
    EXEC dbo.Eliminar_Pelicula
        @id_pelicula = 2;
*/
