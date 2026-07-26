USE Rotten_DB;
GO

--ABM PAIS

-- ALTA
EXEC dbo.Agregar_Pais
    @nombre = 'DEMO_Pais_ABM';
GO

-- LISTAR
EXEC dbo.Listar_Paises;
GO

-- MODIFICAR
EXEC dbo.Modificar_Pais
    @id_pais = REEMPLAZAR_ID_PAIS,
    @nombre = 'DEMO_Pais_ABM_Modificado';
GO

-- LISTAR
EXEC dbo.Listar_Paises;
GO

-- ELIMINAR
EXEC dbo.Eliminar_Pais
    @id_pais = REEMPLAZAR_ID_PAIS;
GO

-- LISTAR
EXEC dbo.Listar_Paises;
GO
