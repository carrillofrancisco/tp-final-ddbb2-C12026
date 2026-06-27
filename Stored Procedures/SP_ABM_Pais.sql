USE Rotten_DB;
GO

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
    )
        THROW 50006, 'El pais indicado no existe.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Persona
        WHERE nacionalidad = @id_pais
    )
        THROW 50007, 'No se puede eliminar el pais porque esta asociado a una persona.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Peliculas
        WHERE pais_origen = @id_pais
    )
        THROW 50008, 'No se puede eliminar el pais porque esta asociado a una pelicula.', 1;

    DELETE FROM dbo.Pais
    WHERE id_pais = @id_pais;

    SELECT @id_pais AS id_pais_eliminado;
END;
GO

CREATE OR ALTER PROCEDURE dbo.Listar_Paises
AS
BEGIN
    SET NOCOUNT ON;

    SELECT id_pais, nombre
    FROM dbo.Pais
    ORDER BY nombre;
END;
GO

EXEC Listar_Paises


EXEC dbo.Eliminar_Pais
    @id_pais = 7;
GO