USE Rotten_DB;
GO


-- Ver usuarios disponibles.
-- Usar un usuario Espectador o Critico.
EXEC dbo.Listar_Personas;
GO

-- Ver peliculas disponibles.
EXEC dbo.Listar_Peliculas;
GO

--ABM ELENCO
--Usar una pelicula y una persona existentes.

-- ALTA
EXEC dbo.Agregar_Elenco
    @id_pelicula = REEMPLAZAR_ID_PELICULA,
    @id_persona = REEMPLAZAR_ID_PERSONA,
    @rol = 'Actor';
GO

-- LISTAR
EXEC dbo.Listar_Elenco_Por_Pelicula
    @id_pelicula = REEMPLAZAR_ID_PELICULA;
GO

-- MODIFICAR
EXEC dbo.Modificar_Elenco
    @id_elenco = REEMPLAZAR_ID_ELENCO,
    @id_pelicula = REEMPLAZAR_ID_PELICULA,
    @id_persona = REEMPLAZAR_ID_PERSONA,
    @rol = 'Director';
GO

-- LISTAR
EXEC dbo.Listar_Elenco_Por_Pelicula
    @id_pelicula = REEMPLAZAR_ID_PELICULA;
GO

-- ELIMINAR
EXEC dbo.Eliminar_Elenco
    @id_elenco = REEMPLAZAR_ID_ELENCO;
GO

-- LISTAR
EXEC dbo.Listar_Elenco_Por_Pelicula
    @id_pelicula = REEMPLAZAR_ID_PELICULA;
GO
