USE Rotten_DB;
GO

-- Prueba 1: Buscar películas que tengan la palabra "Batman" o "Star" en el título
EXEC dbo.SP_BuscarPeliculas @texto_busqueda = 'Batman';

-- Prueba 2: Filtrar únicamente por el ID de género (ej. Género ID = 3) sin importar el título o año
EXEC dbo.SP_BuscarPeliculas @id_genero = 3;

-- Prueba 3: Filtrar únicamente por el año de estreno (ej. Año 2023)
EXEC dbo.SP_BuscarPeliculas @anio_estreno = 2023;

-- Prueba 4: Combinar filtros (Buscar texto "The" y que sea del año 2022)
EXEC dbo.SP_BuscarPeliculas @texto_busqueda = 'The', @anio_estreno = 2022;

-- Prueba 5: Ejecutar sin parámetros (Trae todas las películas ordenadas alfabéticamente)
EXEC dbo.SP_BuscarPeliculas;