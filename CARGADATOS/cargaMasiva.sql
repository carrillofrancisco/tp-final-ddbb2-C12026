USE Rotten_DB;
GO

PRINT '======================================================================';
PRINT 'INICIANDO GENERACIÓN MASIVA DE DATOS PARA EVALUACIÓN Y PRUEBAS';
PRINT '======================================================================';


-- 1. CARGA DE PELÍCULAS BASE DEL CATÁLOGO

PRINT 'Cargando películas adicionales para el catálogo masivo...';

BEGIN TRY
    IF NOT EXISTS (SELECT 1 FROM dbo.Peliculas WHERE titulo = 'The Dark Knight')
        EXEC dbo.Agregar_Pelicula @titulo = 'The Dark Knight', @duracion_minutos = 152, @id_genero = 3, @pais_origen = 1, @clasificacion_edad = '+13', @sinopsis = 'Batman se enfrenta al Guason en una batalla por el alma de Gotica.', @fecha_estreno = '2008-07-18', @estudio_cine = 'Warner Bros';

    IF NOT EXISTS (SELECT 1 FROM dbo.Peliculas WHERE titulo = 'Pulp Fiction')
        EXEC dbo.Agregar_Pelicula @titulo = 'Pulp Fiction', @duracion_minutos = 154, @id_genero = 2, @pais_origen = 1, @clasificacion_edad = '+18', @sinopsis = 'Las historias de dos matones, un boxeadora y una pareja de atracadores se cruzan.', @fecha_estreno = '1994-10-14', @estudio_cine = 'Miramax';

    IF NOT EXISTS (SELECT 1 FROM dbo.Peliculas WHERE titulo = 'Avatar')
        EXEC dbo.Agregar_Pelicula @titulo = 'Avatar', @duracion_minutos = 162, @id_genero = 1, @pais_origen = 1, @clasificacion_edad = '+13', @sinopsis = 'Un ex-marine en una mision en el planeta Pandora se debate entre seguir ordenes y proteger su hogar.', @fecha_estreno = '2009-12-18', @estudio_cine = '20th Century Fox';

    IF NOT EXISTS (SELECT 1 FROM dbo.Peliculas WHERE titulo = 'Relatos Salvajes')
        EXEC dbo.Agregar_Pelicula @titulo = 'Relatos Salvajes', @duracion_minutos = 122, @id_genero = 2, @pais_origen = 2, @clasificacion_edad = '+16', @sinopsis = 'Seis relatos de amor, decepcion, pasado y la tragedia de las mezquindades cotidianas.', @fecha_estreno = '2014-08-21', @estudio_cine = 'Kramer & Sigman Films';

    PRINT '--> Películas base del catálogo verificadas/cargadas.';
END TRY
BEGIN CATCH
    PRINT 'Aviso en Películas Base: ' + ERROR_MESSAGE();
END CATCH;
GO


-- 2. CARGA DE PERSONAS DEL AMBIENTE CINEMATOGRÁFICO

PRINT 'Generando 100 usuarios automatizados (Espectadores y Críticos)...';

SET NOCOUNT ON;
DECLARE @i INT = 1;
DECLARE @nombreUsr VARCHAR(255);
DECLARE @mailUsr VARCHAR(255);
DECLARE @tipoUsr VARCHAR(20);
DECLARE @fechaNac DATE;

WHILE @i <= 100
BEGIN
    SET @nombreUsr = 'user_test_' + CAST(@i AS VARCHAR(10));
    SET @mailUsr = 'usuario' + CAST(@i AS VARCHAR(10)) + '@testing_rottendb.com';
    
    -- 25% Críticos profesionales, 75% Espectadores
    IF (@i % 4 = 0)
        SET @tipoUsr = 'Critico';
    ELSE
        SET @tipoUsr = 'Espectador';

    -- Generar fecha de nacimiento aleatoria (entre 1970 y 2005)
    SET @fechaNac = DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 12000, '2005-01-01');

    BEGIN TRY
        EXEC dbo.Agregar_Usuario 
            @nombre_usuario = @nombreUsr, 
            @pass = 'Pass1234!', 
            @email = @mailUsr, 
            @tipo_usuario = @tipoUsr, 
            @fecha_nac = @fechaNac;
    END TRY
    BEGIN CATCH
        
    END CATCH;

    SET @i = @i + 1;
END;
PRINT '--> 100 Usuarios procesados exitosamente.';
GO


-- 3. CARGA DE CALIFICACIONES MASIVAS CRUZANDO USUARIOS Y PELÍCULAS

PRINT 'Inyectando calificaciones masivas cruzando Usuarios y Películas...';

SET NOCOUNT ON;


IF CURSOR_STATUS('global', 'usuario_cursor') >= -1
BEGIN
    CLOSE usuario_cursor;
    DEALLOCATE usuario_cursor;
END;

DECLARE @id_usuario BIGINT;
DECLARE @id_pelicula INT;
DECLARE @puntuacion INT;
DECLARE @comentario VARCHAR(255);
DECLARE @comentarios_muestra TABLE (id INT IDENTITY(1,1), texto VARCHAR(255));

INSERT INTO @comentarios_muestra (texto) VALUES 
('Excelente pelicula, totalmente recomendable.'),
('Efectos visuales increibles y gran ritmo.'),
('Regular, me esperaba un desarrollo de personajes mas profundo.'),
('Una obra maestra del cine moderno.'),
('Pésima, no la volveria a ver jamas.'),
('Buena actuacion principal pero el final fue apresurado.'),
('Sobresaliente direccion y banda sonora impecable.'),
('Mucha accion pero poco guion.'),
('Entretenida para pasar el rato en el cine.'),
('Un clasico instantaneo que merece todos los premios.');


DECLARE usuario_cursor CURSOR FOR 
SELECT id_usuarios FROM dbo.Usuarios;

OPEN usuario_cursor;
FETCH NEXT FROM usuario_cursor INTO @id_usuario;

WHILE @@FETCH_STATUS = 0
BEGIN
  
    DECLARE @pelis_a_calificar INT = (ABS(CHECKSUM(NEWID())) % 4) + 1;
    DECLARE @j INT = 1;

    WHILE @j <= @pelis_a_calificar
    BEGIN
       
        SELECT TOP 1 @id_pelicula = id_peliculas 
        FROM dbo.Peliculas 
        ORDER BY NEWID();

        
        SET @puntuacion = (ABS(CHECKSUM(NEWID())) % 5) + 1;

        
        SELECT TOP 1 @comentario = texto 
        FROM @comentarios_muestra 
        ORDER BY NEWID();

        BEGIN TRY
           
            EXEC dbo.Agregar_Calificacion 
                @id_usuario = @id_usuario, 
                @id_pelicula = @id_pelicula, 
                @puntuacion = @puntuacion, 
                @comentario = @comentario;
        END TRY
        BEGIN CATCH
            
        END CATCH;

        SET @j = @j + 1;
    END;

    FETCH NEXT FROM usuario_cursor INTO @id_usuario;
END;

CLOSE usuario_cursor;
DEALLOCATE usuario_cursor;

PRINT '--> Carga masiva de calificaciones completada.';
GO


-- 4. RESUMEN FINAL DE LA BASE DE DATOS

PRINT '======================================================================';
PRINT 'RESUMEN ACTUAL DE LA BASE DE DATOS Rotten_DB';
PRINT '======================================================================';

SELECT 'Usuarios Totales' AS Entidad, COUNT(*) AS Cantidad FROM dbo.Usuarios
UNION ALL
SELECT 'Usuarios Críticos', COUNT(*) FROM dbo.Usuarios WHERE tipo_usuario = 'Critico'
UNION ALL
SELECT 'Usuarios Espectadores', COUNT(*) FROM dbo.Usuarios WHERE tipo_usuario = 'Espectador'
UNION ALL
SELECT 'Películas Registradas', COUNT(*) FROM dbo.Peliculas
UNION ALL
SELECT 'Calificaciones Totales', COUNT(*) FROM dbo.Calificaciones;
GO