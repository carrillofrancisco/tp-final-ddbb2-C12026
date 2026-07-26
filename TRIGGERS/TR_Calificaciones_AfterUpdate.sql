USE Rotten_DB;
GO

CREATE OR ALTER TRIGGER TR_Calificaciones_AfterUpdate
ON dbo.Calificaciones
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Auditoria_Calificaciones (id_usuario, id_pelicula, puntuacion, accion)
    SELECT 
        i.id_usuario,
        i.id_pelicula,
        i.puntuacion,
        'UPDATE'
    FROM inserted i;
END;
GO