USE Rotten_DB;
GO

CREATE OR ALTER PROCEDURE dbo.Agregar_Usuario
    @nombre_usuario VARCHAR(255),
    @pass VARCHAR(255),
    @email VARCHAR(255),
    @tipo_usuario VARCHAR(20),
    @fecha_nac DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SET @nombre_usuario = LTRIM(RTRIM(@nombre_usuario));
    SET @pass = LTRIM(RTRIM(@pass));
    SET @email = LTRIM(RTRIM(@email));
    SET @tipo_usuario = LTRIM(RTRIM(@tipo_usuario));

    IF @nombre_usuario IS NULL OR @nombre_usuario = ''
        THROW 50301, 'El nombre de usuario es obligatorio.', 1;

    IF @pass IS NULL OR @pass = ''
        THROW 50302, 'La contrasena es obligatoria.', 1;

    IF @email IS NULL OR @email = ''
        THROW 50303, 'El email es obligatorio.', 1;

    IF @tipo_usuario NOT IN ('Espectador', 'Critico', 'Administrador')
        THROW 50304, 'El tipo de usuario no es valido.', 1;

    IF @fecha_nac > CAST(GETDATE() AS DATE)
        THROW 50305, 'La fecha de nacimiento no puede ser futura.', 1;

    IF EXISTS
    (
        SELECT 1
    FROM dbo.Usuarios
    WHERE nombre_usuario = @nombre_usuario
    )
        THROW 50306, 'Ya existe un usuario con ese nombre.', 1;

    IF EXISTS
    (
        SELECT 1
    FROM dbo.Usuarios
    WHERE email = @email
    )
        THROW 50307, 'Ya existe un usuario con ese email.', 1;

    INSERT INTO dbo.Usuarios
        (
        nombre_usuario,
        pass,
        email,
        fecha_nac,
        tipo_usuario
        )
    VALUES
        (
            @nombre_usuario,
            @pass,
            @email,
            @fecha_nac,
            @tipo_usuario
    );

    SELECT
        CAST(SCOPE_IDENTITY() AS BIGINT) AS id_usuarios,
        @nombre_usuario AS nombre_usuario,
        @email AS email,
        @fecha_nac AS fecha_nac,
        @tipo_usuario AS tipo_usuario;
END;
GO

CREATE OR ALTER PROCEDURE dbo.Modificar_Usuario
    @id_usuario BIGINT,
    @nombre_usuario VARCHAR(255),
    @pass VARCHAR(255),
    @email VARCHAR(255),
    @tipo_usuario VARCHAR(20),
    @fecha_nac DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SET @nombre_usuario = LTRIM(RTRIM(@nombre_usuario));
    SET @pass = LTRIM(RTRIM(@pass));
    SET @email = LTRIM(RTRIM(@email));
    SET @tipo_usuario = LTRIM(RTRIM(@tipo_usuario));

    IF NOT EXISTS
    (
        SELECT 1
    FROM dbo.Usuarios
    WHERE id_usuarios = @id_usuario
    )
        THROW 50308, 'El usuario indicado no existe.', 1;

    IF @nombre_usuario IS NULL OR @nombre_usuario = ''
        THROW 50309, 'El nombre de usuario es obligatorio.', 1;

    IF @pass IS NULL OR @pass = ''
        THROW 50310, 'La contrasena es obligatoria.', 1;

    IF @email IS NULL OR @email = ''
        THROW 50311, 'El email es obligatorio.', 1;

    IF @tipo_usuario NOT IN ('Espectador', 'Critico', 'Administrador')
        THROW 50312, 'El tipo de usuario no es valido.', 1;

    IF @fecha_nac > CAST(GETDATE() AS DATE)
        THROW 50313, 'La fecha de nacimiento no puede ser futura.', 1;

    IF EXISTS
    (
        SELECT 1
    FROM dbo.Usuarios
    WHERE nombre_usuario = @nombre_usuario
        AND id_usuarios <> @id_usuario
    )
        THROW 50314, 'Ya existe otro usuario con ese nombre.', 1;

    IF EXISTS
    (
        SELECT 1
    FROM dbo.Usuarios
    WHERE email = @email
        AND id_usuarios <> @id_usuario
    )
        THROW 50315, 'Ya existe otro usuario con ese email.', 1;

    UPDATE dbo.Usuarios
    SET nombre_usuario = @nombre_usuario,
        pass = @pass,
        email = @email,
        fecha_nac = @fecha_nac,
        tipo_usuario = @tipo_usuario
    WHERE id_usuarios = @id_usuario;

    SELECT id_usuarios, nombre_usuario, email, fecha_nac, tipo_usuario
    FROM dbo.Usuarios
    WHERE id_usuarios = @id_usuario;
END;
GO

CREATE OR ALTER PROCEDURE dbo.Eliminar_Usuario
    @id_usuario BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS
    (
        SELECT 1
    FROM dbo.Usuarios
    WHERE id_usuarios = @id_usuario
    )
        THROW 50316, 'El usuario indicado no existe.', 1;

    IF EXISTS
    (
        SELECT 1
    FROM dbo.Calificaciones
    WHERE id_usuario = @id_usuario
    )
        THROW 50317, 'No se puede eliminar el usuario porque tiene calificaciones asociadas.', 1;

    DELETE FROM dbo.Usuarios
    WHERE id_usuarios = @id_usuario;

    SELECT @id_usuario AS id_usuario_eliminado;
END;
GO

CREATE OR ALTER PROCEDURE dbo.Listar_Usuarios
AS
BEGIN
    SET NOCOUNT ON;

    SELECT id_usuarios, nombre_usuario, email, fecha_nac, tipo_usuario
    FROM dbo.Usuarios
    ORDER BY nombre_usuario;
END;
GO

CREATE OR ALTER PROCEDURE dbo.Login_Usuario
    @nombre_usuario VARCHAR(255),
    @pass VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    SET @nombre_usuario = LTRIM(RTRIM(@nombre_usuario));
    SET @pass = LTRIM(RTRIM(@pass));

    IF @nombre_usuario IS NULL OR @nombre_usuario = ''
        THROW 50318, 'El nombre de usuario es obligatorio para iniciar sesion.', 1;

    IF @pass IS NULL OR @pass = ''
        THROW 50319, 'La contrasena es obligatoria para iniciar sesion.', 1;

    IF NOT EXISTS
    (
        SELECT 1
    FROM dbo.Usuarios
    WHERE nombre_usuario = @nombre_usuario AND pass = @pass
    )
        THROW 50320, 'Credenciales invalidas. Verifique el usuario y la contrasena.', 1;

    SELECT
        id_usuarios,
        nombre_usuario,
        email,
        tipo_usuario
    FROM dbo.Usuarios
    WHERE nombre_usuario = @nombre_usuario AND pass = @pass;
END;
GO


-- Usuario duplicado

/*
    EXEC dbo.Agregar_Usuario
        @nombre_usuario = 'usuario_prueba',
        @pass = 'clave123',
        @email = 'prueba@correo.com',
        @tipo_usuario = 'Espectador',
        @fecha_nac = '2000-05-15';


    EXEC dbo.Modificar_Usuario
        @id_usuario = 4,
        @nombre_usuario = 'usuario_modificado',
        @pass = 'clave456',
        @email = 'modificado@correo.com',
        @tipo_usuario = 'Critico',
        @fecha_nac = '2000-05-15';
        
exec Listar_Usuarios

    EXEC dbo.Eliminar_Usuario
        @id_usuario = 4;
*/
