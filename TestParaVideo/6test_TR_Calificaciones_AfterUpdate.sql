USE Rotten_DB;
GO




UPDATE dbo.Calificaciones
SET puntuacion = 5, comentario = 'Reseña modificada: Cambié de opinión a 5 estrellas'
WHERE id_usuario = 1 AND id_pelicula = 2;
GO


SELECT TOP 1 * FROM dbo.Auditoria_Calificaciones ORDER BY id_auditoria DESC;
GO