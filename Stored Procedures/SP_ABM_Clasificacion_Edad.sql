USE Rotten_DB;
GO

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
    )
        THROW 50208, 'La clasificacion indicada no existe.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Peliculas
        WHERE clasificacion_edad = @id_clasificacion
    )
        THROW 50209, 'No se puede eliminar la clasificacion porque esta asociada a una pelicula.', 1;

    DELETE FROM dbo.Clasificacion_edad
    WHERE id_clasificacion = @id_clasificacion;

    SELECT @id_clasificacion AS id_clasificacion_eliminada;
END;
GO

CREATE OR ALTER PROCEDURE dbo.Listar_Clasificaciones_Edad
AS
BEGIN
    SET NOCOUNT ON;

    SELECT id_clasificacion, nombre, descripcion
    FROM dbo.Clasificacion_edad
    ORDER BY nombre;
END;
GO

 -- 1. Agregar clasificación
 --   EXEC dbo.Agregar_Clasificacion_Edad
--        @id_clasificacion = 'TEST',
--        @nombre = 'Clasificacion de prueba',
--        @descripcion = 'Creada para probar los SP';

    -- 2. Listar clasificaciones
    EXEC dbo.Listar_Clasificaciones_Edad;

    -- 3. Modificar clasificación
 --   EXEC dbo.Modificar_Clasificacion_Edad
--        @id_clasificacion = 'TEST',
--        @nombre = 'Clasificacion modificada',
--        @descripcion = 'Descripcion modificada';

    -- Verificar modificación
 --   SELECT *
--    FROM dbo.Clasificacion_edad
 ---   WHERE id_clasificacion = 'TEST';

    -- 4. Verificar antes de eliminar
 --   SELECT *
--    FROM dbo.Clasificacion_edad
--    WHERE id_clasificacion = 'TEST';

    -- 5. Eliminar clasificación
--    EXEC dbo.Eliminar_Clasificacion_Edad
--      @id_clasificacion = 'TEST';
