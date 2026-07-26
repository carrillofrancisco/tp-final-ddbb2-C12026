CREATE OR ALTER TRIGGER TR_Calificaciones_AfterDelete
ON dbo.Calificaciones
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Auditoria_Calificaciones (id_usuario, id_pelicula, puntuacion, accion)
    SELECT 
        d.id_usuario,
        d.id_pelicula,
        d.puntuacion,
        'DELETE'
    FROM deleted d;
END;
GO