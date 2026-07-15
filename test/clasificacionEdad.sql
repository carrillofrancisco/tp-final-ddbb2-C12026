USE Rotten_DB;
GO

--ABM CLASIFICACION EDAD

-- ALTA
EXEC dbo.Agregar_Clasificacion_Edad
    @id_clasificacion = 'DEMO',
    @nombre = 'DEMO Clasificacion ABM',
    @descripcion = 'Clasificacion creada para probar ABM';
GO

-- LISTAR
EXEC dbo.Listar_Clasificaciones_Edad;
GO

-- MODIFICAR
EXEC dbo.Modificar_Clasificacion_Edad
    @id_clasificacion = 'DEMO',
    @nombre = 'DEMO Clasificacion ABM Modificada',
    @descripcion = 'Descripcion modificada para prueba ABM';
GO

-- LISTAR
EXEC dbo.Listar_Clasificaciones_Edad;
GO

-- ELIMINAR
EXEC dbo.Eliminar_Clasificacion_Edad
    @id_clasificacion = 'DEMO';
GO

-- LISTAR
EXEC dbo.Listar_Clasificaciones_Edad;
GO
