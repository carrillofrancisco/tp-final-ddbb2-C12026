USE Rotten_DB;
GO

--ABM USUARIO

-- ALTA
EXEC dbo.Agregar_Usuario
    @nombre_usuario = 'demo_usuario_abm',
    @pass = 'clave123',
    @email = 'demo_usuario_abm@mail.com',
    @tipo_usuario = 'Espectador',
    @fecha_nac = '2000-05-15';
GO

-- LISTAR
EXEC dbo.Listar_Usuarios;
GO

-- MODIFICAR
EXEC dbo.Modificar_Usuario
    @id_usuario = REEMPLAZAR_ID_USUARIO,
    @nombre_usuario = 'demo_usuario_abm_mod',
    @pass = 'clave456',
    @email = 'demo_usuario_abm_mod@mail.com',
    @tipo_usuario = 'Critico',
    @fecha_nac = '2000-05-15';
GO

-- LISTAR
EXEC dbo.Listar_Usuarios;
GO

-- ELIMINAR
EXEC dbo.Eliminar_Usuario
    @id_usuario = REEMPLAZAR_ID_USUARIO;
GO

-- LISTAR
EXEC dbo.Listar_Usuarios;
GO
