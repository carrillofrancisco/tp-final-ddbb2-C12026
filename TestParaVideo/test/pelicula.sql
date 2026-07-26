USE Rotten_DB;
GO

-- ALTA
EXEC dbo.Agregar_Pelicula
    @titulo = 'DEMO Pelicula ABM',
    @duracion_minutos = 120,
    @id_genero = 1,
    @pais_origen = 1,
    @clasificacion_edad = '+13',
    @sinopsis = 'Pelicula creada para probar ABM.',
    @fecha_estreno = '2025-06-15',
    @url_img = NULL,
    @estudio_cine = 'Estudio DEMO';
GO

-- LISTAR
EXEC dbo.Listar_Peliculas;
GO

-- MODIFICAR
EXEC dbo.Modificar_Pelicula
    @id_pelicula = REEMPLAZAR_ID_PELICULA,
    @titulo = 'DEMO Pelicula ABM Modificada',
    @duracion_minutos = 130,
    @id_genero = 1,
    @pais_origen = 1,
    @clasificacion_edad = '+13',
    @sinopsis = 'Sinopsis modificada para probar ABM.',
    @fecha_estreno = '2025-07-01',
    @url_img = NULL,
    @estudio_cine = 'Estudio DEMO Modificado';
GO

-- LISTAR
EXEC dbo.Listar_Peliculas;
GO

-- ELIMINAR
EXEC dbo.Eliminar_Pelicula
    @id_pelicula = REEMPLAZAR_ID_PELICULA;
GO

-- LISTAR
EXEC dbo.Listar_Peliculas;
GO
