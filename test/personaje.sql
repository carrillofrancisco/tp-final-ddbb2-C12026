USE Rotten_DB;
GO


-- ALTA
EXEC dbo.Agregar_Personaje
    @nombre_personaje = 'Personaje DEMO ABM',
    @id_elenco = REEMPLAZAR_ID_ELENCO;
GO

-- LISTAR
EXEC dbo.Listar_Personajes_Por_Elenco
    @id_elenco = REEMPLAZAR_ID_ELENCO;
GO

-- MODIFICAR
EXEC dbo.Modificar_Personaje
    @id_personaje = REEMPLAZAR_ID_PERSONAJE,
    @nombre_personaje = 'Personaje DEMO ABM Modificado',
    @id_elenco = REEMPLAZAR_ID_ELENCO;
GO

-- LISTAR
EXEC dbo.Listar_Personajes_Por_Elenco
    @id_elenco = REEMPLAZAR_ID_ELENCO;
GO

-- ELIMINAR
EXEC dbo.Eliminar_Personaje
    @id_personaje = REEMPLAZAR_ID_PERSONAJE;
GO

-- LISTAR
EXEC dbo.Listar_Personajes_Por_Elenco
    @id_elenco = REEMPLAZAR_ID_ELENCO;
GO
