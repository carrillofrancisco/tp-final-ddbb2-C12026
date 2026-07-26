USE Rotten_DB;
GO

-- Prueba 1: Ver el listado completo de películas ordenadas por puntuación
SELECT * FROM dbo.Vista_ListarPeliculasMejorCalificadas;

-- Prueba 2: Filtrar la vista para ver solo las películas de un género en particular (ej. Acción)
SELECT * FROM dbo.Vista_ListarPeliculasMejorCalificadas 
WHERE genero = 'Acción';


