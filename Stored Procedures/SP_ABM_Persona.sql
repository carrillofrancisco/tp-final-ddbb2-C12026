USE Rotten_DB;
GO

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
    )
        THROW 50410, 'La persona indicada no existe.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Elenco
        WHERE id_persona = @id_persona
    )
        THROW 50411, 'No se puede eliminar la persona porque pertenece a un elenco.', 1;

    DELETE FROM dbo.Persona
    WHERE id_persona = @id_persona;

    SELECT @id_persona AS id_persona_eliminada;
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
    ORDER BY pe.apellido_persona, pe.nombre_persona;
END;
GO


/*
 -- 1. Agregar persona
    EXEC dbo.Agregar_Persona
        @nombre_persona = 'Persona',
        @apellido_persona = 'De Prueba',
        @fecha_nacimiento = '1990-05-10',
        @nacionalidad = 4,
        @url_img = 'https://ejemplo.com/persona.jpg';

    -- 2. Listar personas
    EXEC dbo.Listar_Personas;

    -- 3. Modificar persona
    EXEC dbo.Modificar_Persona
        @id_persona = 1,
        @nombre_persona = 'Persona Modificada',
        @apellido_persona = 'De Prueba',
        @fecha_nacimiento = '1991-06-15',
        @nacionalidad = 3,
        @url_img = NULL;

    -- Verificar modificación
    SELECT *
    FROM dbo.Persona
    WHERE id_persona = 1;

    -- 5. Eliminar persona
    EXEC dbo.Eliminar_Persona
        @id_persona = 1;
*/
