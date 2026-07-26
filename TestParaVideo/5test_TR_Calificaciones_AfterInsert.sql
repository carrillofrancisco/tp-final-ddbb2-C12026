USE Rotten_DB;
GO


-- 1. Aseguramos un estado previo limpio para la demostración
TRUNCATE TABLE dbo.Auditoria_Calificaciones;


SELECT * FROM dbo.Auditoria_Calificaciones;
GO

-- 2. Inserción mediante SP que activa el Trigger

EXEC dbo.Agregar_Calificacion 
    @id_usuario = 1, 
    @id_pelicula = 2, 
    @puntuacion = 3, 
    @comentario = 'Probando Trigger AFTER INSERT';
GO

-- 3. Verificación de la auditoría capturada por el Trigger

SELECT TOP 1 * FROM dbo.Auditoria_Calificaciones ORDER BY id_auditoria DESC;
GO