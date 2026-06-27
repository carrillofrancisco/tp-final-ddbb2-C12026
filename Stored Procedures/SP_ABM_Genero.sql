USE Rotten_DB;
GO

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
    )
        THROW 50106, 'El genero indicado no existe.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Peliculas
        WHERE id_genero = @id_genero
    )
        THROW 50107, 'No se puede eliminar el genero porque esta asociado a una pelicula.', 1;

    DELETE FROM dbo.Genero
    WHERE id_genero = @id_genero;

    SELECT @id_genero AS id_genero_eliminado;
END;
GO

CREATE OR ALTER PROCEDURE dbo.Listar_Generos
AS
BEGIN
    SET NOCOUNT ON;

    SELECT id_genero, nombre
    FROM dbo.Genero
    ORDER BY nombre;
END;
GO

--EXEC dbo.Agregar_Genero
--  @nombre = 'Genero de prueba';

--exec Listar_Generos

--EXEC Modificar_Genero
--@id_genero = 7,
--@nombre = 'Genero modificado';

--EXEC Eliminar_Genero
--@id_genero = 7;