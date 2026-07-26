USE Rotten_DB;
GO

PRINT '======================================================================';
PRINT '  SCRIPT DE PRUEBAS DE INTEGRACIÓN - VIDEO DEMO ROTTEN_DB  ';
PRINT '======================================================================';
GO

-- ============================================================================
-- 1. PRUEBA DE FUNCIÓN DEFINIDA POR EL USUARIO (UDF)
-- ============================================================================
PRINT '--- [TEST 1] Función: UFN_ObtenerEtiquetaPelicula ---';

SELECT 
    4.80 AS Promedio, dbo.UFN_ObtenerEtiquetaPelicula(4.80) AS Etiqueta_Esperada_Aclamada
UNION ALL
SELECT 
    3.50 AS Promedio, dbo.UFN_ObtenerEtiquetaPelicula(3.50) AS Etiqueta_Esperada_Buena
UNION ALL
SELECT 
    2.10 AS Promedio, dbo.UFN_ObtenerEtiquetaPelicula(2.10) AS Etiqueta_Esperada_Mala
UNION ALL
SELECT 
    NULL AS Promedio, dbo.UFN_ObtenerEtiquetaPelicula(NULL) AS Etiqueta_Esperada_SinCalificar;
GO

-- ============================================================================
-- 2. PRUEBAS DE VISTAS
-- ============================================================================
PRINT '--- [TEST 2] Vista 1: Vista_DetallePeliculas ---';
SELECT TOP 3 
    id_peliculas, 
    titulo, 
    genero, 
    pais_origen, 
    clasificacion_edad, 
    total_calificaciones
FROM dbo.Vista_DetallePeliculas;
GO

PRINT '--- [TEST 3] Vista 2: Vista_ListarPeliculasMejorCalificadas (Usa la UDF) ---';
SELECT TOP 5 
    id_peliculas, 
    titulo, 
    promedio_general, 
    etiqueta_reputacion, 
    cantidad_votos
FROM dbo.Vista_ListarPeliculasMejorCalificadas;
GO

PRINT '--- [TEST 4] Vista 3: Vista_ResumenCalificacionesCriticosVSUsuarios ---';
SELECT TOP 3 
    id_peliculas, 
    titulo, 
    promedio_criticos, 
    votos_criticos, 
    promedio_espectadores, 
    votos_espectadores
FROM dbo.Vista_ResumenCalificacionesCriticosVSUsuarios;
GO

-- ============================================================================
-- 3. PRUEBAS DE STORED PROCEDURES Y TRIGGERS (FLUJO COMPLETO)
-- ============================================================================
PRINT '======================================================================';
PRINT '--- PRUEBA CONJUNTA: SPs + TRIGGERS DE INSERCIÓN, UPDATE Y DELETE ---';
PRINT '======================================================================';

-- A. Limpiamos auditoría de demostraciones previas para mostrar el efecto limpio
TRUNCATE TABLE dbo.Auditoria_Calificaciones;
GO

PRINT '1. Estado inicial de la tabla de Auditoría:';
SELECT * FROM dbo.Auditoria_Calificaciones;
GO

-- B. TEST SP: Agregar_Calificacion (Dispara TR_Calificaciones_AfterInsert)
PRINT '2. Ejecutando SP Agregar_Calificacion (Voto del Usuario 1 en Película 2)...';
EXEC dbo.Agregar_Calificacion 
    @id_usuario = 1, 
    @id_pelicula = 2, 
    @puntuacion = 3, 
    @comentario = 'Pelicula regular, probando Insert';
GO

PRINT '--> [VERIFICACIÓN TRIGGER AFTER INSERT]: Registro en Auditoria_Calificaciones:';
SELECT TOP 1 * FROM dbo.Auditoria_Calificaciones ORDER BY id_auditoria DESC;
GO

-- C. TEST UPDATE (Dispara TR_Calificaciones_AfterUpdate)
PRINT '3. Modificando la calificación recién agregada (Cambiando nota a 5)...';
UPDATE dbo.Calificaciones
SET puntuacion = 5, comentario = 'Cambio de opinión, la película es excelente'
WHERE id_usuario = 1 AND id_pelicula = 2;
GO

PRINT '--> [VERIFICACIÓN TRIGGER AFTER UPDATE]: Registro en Auditoria_Calificaciones:';
SELECT TOP 1 * FROM dbo.Auditoria_Calificaciones ORDER BY id_auditoria DESC;
GO

-- D. TEST SP: Eliminar_Calificacion (Dispara TR_Calificaciones_AfterDelete)
PRINT '4. Ejecutando SP Eliminar_Calificacion...';
EXEC dbo.Eliminar_Calificacion 
    @id_usuario = 1, 
    @id_pelicula = 2;
GO

PRINT '--> [VERIFICACIÓN TRIGGER AFTER DELETE]: Registro en Auditoria_Calificaciones:';
SELECT TOP 1 * FROM dbo.Auditoria_Calificaciones ORDER BY id_auditoria DESC;
GO

-- E. Resumen Final de Auditoría
PRINT '5. Historial completo capturado automáticamente por los 3 Triggers:';
SELECT id_auditoria, id_usuario, id_pelicula, puntuacion, accion, fecha_registro 
FROM dbo.Auditoria_Calificaciones 
ORDER BY id_auditoria ASC;
GO