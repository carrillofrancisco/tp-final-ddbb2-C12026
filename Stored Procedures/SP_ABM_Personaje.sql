USE Rotten_DB;
GO


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
    )
        THROW 50703, 'El personaje indicado no existe.', 1;

    IF @nombre_personaje IS NULL OR @nombre_personaje = ''
        THROW 50704, 'El nombre del personaje es obligatorio.', 1;

   
    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Elenco
        WHERE id_elenco = @id_elenco
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
    )
        THROW 50706, 'El personaje indicado no existe.', 1;

    -- Eliminar
    DELETE FROM dbo.Personaje
    WHERE id_personaje = @id_personaje;

    SELECT @id_personaje AS id_personaje_eliminado;
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
    )
        THROW 50707, 'El registro de elenco especificado no existe.', 1;

    SELECT 
        pj.id_personaje,
        pj.nombre_personaje,
        e.rol,
        p.nombre_persona + ' ' + p.apellido_persona AS actor_persona
    FROM dbo.Personaje pj
    INNER JOIN dbo.Elenco e ON e.id_elenco = pj.id_elenco
    INNER JOIN dbo.Persona p ON p.id_persona = e.id_persona
    WHERE pj.id_elenco = @id_elenco
    ORDER BY pj.nombre_personaje;
END;
GO