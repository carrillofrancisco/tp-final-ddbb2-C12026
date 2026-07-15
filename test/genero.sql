USE Rotten_DB;
GO

--GENERO

-- ALTA
EXEC dbo.Agregar_Genero
    @nombre = 'DEMO_Genero_ABM';
GO

-- LISTAR
EXEC dbo.Listar_Generos;
GO

-- MODIFICAR
EXEC dbo.Modificar_Genero
    @id_genero = REEMPLAZAR_ID_GENERO,
    @nombre = 'DEMO_Genero_ABM_Modificado';
GO

-- LISTAR
EXEC dbo.Listar_Generos;
GO

-- ELIMINAR
EXEC dbo.Eliminar_Genero
    @id_genero = 3; 
GO

-- LISTAR
EXEC dbo.Listar_Generos;
GO
