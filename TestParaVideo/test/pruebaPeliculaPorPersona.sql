USE Rotten_DB;
GO

-- Prueba 1: Buscar las películas del director o actor con ID = 1
EXEC dbo.SP_ListarPeliculasPorPersona @id_persona = 1;

-- Prueba 2: Buscar con otro ID (ej. ID = 2) para verificar que cambien los resultados
EXEC dbo.SP_ListarPeliculasPorPersona @id_persona = 2;