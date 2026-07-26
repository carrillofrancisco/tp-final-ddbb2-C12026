CREATE OR ALTER TRIGGER TR_Calificaciones_AfterInsert
ON dbo.Calificaciones
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Auditoria_Calificaciones (id_usuario, id_pelicula, puntuacion, accion)
    SELECT 
        i.id_usuario,
        i.id_pelicula,
        i.puntuacion,
        'INSERT'
    FROM inserted i;
END;
GO