USE Rotten_DB;
GO


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
    )
        THROW 50801, 'El usuario especificado no existe.', 1;

    IF NOT EXISTS
    (
        SELECT 1
    FROM dbo.Peliculas
    WHERE id_peliculas = @id_pelicula
    )
        THROW 50802, 'La pelicula especificada no existe.', 1;


    IF @puntuacion IS NULL OR @puntuacion < 1 OR @puntuacion > 5
        THROW 50803, 'La puntuacion debe estar estrictamente entre 1 y 5.', 1;


    IF EXISTS
    (
        SELECT 1
    FROM dbo.Calificaciones
    WHERE id_usuario = @id_usuario AND id_pelicula = @id_pelicula
    )
        THROW 50804, 'El usuario ya ha calificado esta pelicula previamente.', 1;

    -- Insertar calificación (La fecha toma GETDATE() por defecto según el diseño del DER refactorizado)
    INSERT INTO dbo.Calificaciones
        (id_usuario, id_pelicula, puntuacion, comentario, fecha)
    VALUES
        (@id_usuario, @id_pelicula, @puntuacion, @comentario, GETDATE());

    SELECT id_usuario, id_pelicula, puntuacion, comentario, fecha
    FROM dbo.Calificaciones
    WHERE id_usuario = @id_usuario AND id_pelicula = @id_pelicula;
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
    WHERE id_usuario = @id_usuario AND id_pelicula = @id_pelicula
    )
        THROW 50805, 'No se encontro ninguna calificacion registrada por este usuario para esta pelicula.', 1;


    IF @puntuacion IS NULL OR @puntuacion < 1 OR @puntuacion > 5
        THROW 50806, 'La puntuacion debe estar estrictamente entre 1 y 5.', 1;


    UPDATE dbo.Calificaciones
    SET puntuacion = @puntuacion,
        comentario = @comentario,
        fecha = GETDATE() -- Actualiza la fecha a la última edición
    WHERE id_usuario = @id_usuario AND id_pelicula = @id_pelicula;

    SELECT id_usuario, id_pelicula, puntuacion, comentario, fecha
    FROM dbo.Calificaciones
    WHERE id_usuario = @id_usuario AND id_pelicula = @id_pelicula;
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
    WHERE id_usuario = @id_usuario AND id_pelicula = @id_pelicula
    )
        THROW 50807, 'No existe la calificacion que intenta eliminar.', 1;

    DELETE FROM dbo.Calificaciones
    WHERE id_usuario = @id_usuario AND id_pelicula = @id_pelicula;

    SELECT @id_usuario AS id_usuario_eliminado, @id_pelicula AS id_pelicula_eliminada;
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
    )
        THROW 50808, 'La pelicula especificada no existe.', 1;

    -- Retorna las calificaciones
    SELECT
        c.id_usuario,
        u.nombre_usuario,
        u.tipo_usuario, -- 'Espectador' o 'Critico' directo de la tabla Usuarios
        c.puntuacion,
        c.comentario,
        c.fecha
    FROM dbo.Calificaciones c
        INNER JOIN dbo.Usuarios u ON u.id_usuarios = c.id_usuario
    WHERE c.id_pelicula = @id_pelicula
    ORDER BY c.fecha DESC;
END;
GO