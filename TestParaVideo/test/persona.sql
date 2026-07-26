USE Rotten_DB;
GO

--ABM PERSONA
--Usar un pais existente. Ejemplo: id_pais = 1.

-- ALTA
EXEC dbo.Agregar_Persona
    @nombre_persona = 'DEMO Nombre',
    @apellido_persona = 'ABM',
    @fecha_nacimiento = '1990-01-10',
    @nacionalidad = 1,
    @url_img = NULL;
GO

-- LISTAR
EXEC dbo.Listar_Personas;
GO

-- MODIFICAR
EXEC dbo.Modificar_Persona
    @id_persona = REEMPLAZAR_ID_PERSONA,
    @nombre_persona = 'DEMO Nombre Modificado',
    @apellido_persona = 'ABM',
    @fecha_nacimiento = '1990-01-10',
    @nacionalidad = 1,
    @url_img = 'https://ejemplo.com/persona-demo.jpg';
GO

-- LISTAR
EXEC dbo.Listar_Personas;
GO

-- ELIMINAR
EXEC dbo.Eliminar_Persona
    @id_persona = REEMPLAZAR_ID_PERSONA;
GO

-- LISTAR
EXEC dbo.Listar_Personas;
GO
