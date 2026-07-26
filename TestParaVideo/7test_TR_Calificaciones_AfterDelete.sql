USE Rotten_DB;
GO




EXEC dbo.Eliminar_Calificacion 
    @id_usuario = 1, 
    @id_pelicula = 2;
GO


SELECT TOP 1 * FROM dbo.Auditoria_Calificaciones ORDER BY id_auditoria DESC;
GO


SELECT id_auditoria, id_usuario, id_pelicula, puntuacion, accion, fecha_registro 
FROM dbo.Auditoria_Calificaciones 
ORDER BY id_auditoria ASC;
GO