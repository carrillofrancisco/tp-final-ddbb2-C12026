USE Rotten_DB;
GO

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
    )
        THROW 50601, 'La pelicula indicada no existe.', 1;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Persona
        WHERE id_persona = @id_persona
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
    INNER JOIN dbo.Persona pe
        ON pe.id_persona = e.id_persona
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
    )
        THROW 50605, 'La entrada de elenco indicada no existe.', 1;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Peliculas
        WHERE id_peliculas = @id_pelicula
    )
        THROW 50606, 'La pelicula indicada no existe.', 1;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Persona
        WHERE id_persona = @id_persona
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
    INNER JOIN dbo.Persona pe
        ON pe.id_persona = e.id_persona
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
    )
        THROW 50610, 'La entrada de elenco indicada no existe.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Personaje
        WHERE id_elenco = @id_elenco
    )
        THROW 50611, 'No se puede eliminar la entrada de elenco porque tiene personajes asociados.', 1;

    DELETE FROM dbo.Elenco
    WHERE id_elenco = @id_elenco;

    SELECT @id_elenco AS id_elenco_eliminado;
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
        ) AS cantidad_personajes
    FROM dbo.Elenco e
    INNER JOIN dbo.Peliculas p
        ON p.id_peliculas = e.id_pelicula
    INNER JOIN dbo.Persona pe
        ON pe.id_persona = e.id_persona
    WHERE e.id_pelicula = @id_pelicula
    ORDER BY e.rol, pe.apellido_persona, pe.nombre_persona;
END;
GO

/*
exec Listar_Personas
   -- 1. Agregar al elenco
    EXEC dbo.Agregar_Elenco
        @id_pelicula = 1,
        @id_persona = 2,
        @rol = 'Actor';

    -- 2. Listar elenco
    EXEC dbo.Listar_Elenco_Por_Pelicula
        @id_pelicula = 1;

    -- 3. Modificar rol
    EXEC dbo.Modificar_Elenco
        @id_elenco = @id_elenco,
        @id_pelicula = @id_pelicula,
        @id_persona = @id_persona,
        @rol = 'Cameo';


    -- 5. Eliminar del elenco
    EXEC dbo.Eliminar_Elenco
        @id_elenco = 1;

        */