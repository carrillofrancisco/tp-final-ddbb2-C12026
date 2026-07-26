USE Rotten_DB;
GO


EXEC dbo.SP_Crear_Pelicula_Con_Datos_Validos
    @titulo = 'Interestelar',
    @sinopsis = 'Un grupo de astronautas viaja por un agujero de gusano para buscar un nuevo hogar para la humanidad.',
    @duracion_minutos = 169,
    @fecha_estreno = '2014-11-06',
    @id_genero = 5,              -- Ciencia ficcion
    @pais_origen = 2,            -- Estados Unidos
    @url_img = NULL,
    @clasificacion_edad = '+13',
    @estudio_cine = 'Paramount Pictures';
GO



DECLARE @id_pelicula_interestelar INT;

SELECT @id_pelicula_interestelar = id_peliculas
FROM dbo.Peliculas
WHERE titulo = 'Interestelar';

EXEC dbo.SP_Crear_Persona_Y_Agregar_Al_Elenco
    @id_pelicula = @id_pelicula_interestelar,
    @nombre_persona = 'Christopher',
    @apellido_persona = 'Nolan',
    @rol = 'Director',
    @fecha_nacimiento = '1970-07-30',
    @nacionalidad = 3,           -- Reino Unido
    @url_img = NULL;
GO



DECLARE @id_usuario_lucia BIGINT;
DECLARE @id_pelicula_interestelar INT;

SELECT @id_usuario_lucia = id_usuarios
FROM dbo.Usuarios
WHERE nombre_usuario = 'lucia';

SELECT @id_pelicula_interestelar = id_peliculas
FROM dbo.Peliculas
WHERE titulo = 'Interestelar';

EXEC dbo.SP_Crear_Calificacion_Pelicula
    @id_usuario = @id_usuario_lucia,
    @id_pelicula = @id_pelicula_interestelar,
    @puntuacion = 5,
    @comentario = 'Excelente pelicula, muy buena historia y direccion.';
GO


SELECT *
FROM dbo.Peliculas
WHERE titulo = 'Interestelar';

SELECT 
    P.titulo,
    PE.nombre_persona,
    PE.apellido_persona,
    E.rol
FROM dbo.Elenco E
INNER JOIN dbo.Peliculas P ON E.id_pelicula = P.id_peliculas
INNER JOIN dbo.Persona PE ON E.id_persona = PE.id_persona
WHERE P.titulo = 'Interestelar';

SELECT
    U.nombre_usuario,
    P.titulo,
    C.puntuacion,
    C.comentario,
    C.fecha
FROM dbo.Calificaciones C
INNER JOIN dbo.Usuarios U ON C.id_usuario = U.id_usuarios
INNER JOIN dbo.Peliculas P ON C.id_pelicula = P.id_peliculas
WHERE P.titulo = 'Interestelar';
GO
