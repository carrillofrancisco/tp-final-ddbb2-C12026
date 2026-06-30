USE Rotten_DB;
GO

PRINT '======================================================================';
PRINT 'INICIANDO CARGA DE DATOS DE PRUEBA CORREGIDA';
PRINT '======================================================================';

BEGIN TRY
    -- Usamos nombres que NO existan en tu script de Creación Base
    EXEC dbo.Agregar_Usuario 
        @nombre_usuario = 'tester_juan', 
        @pass = 'juan123', 
        @email = 'tester_juan@mail.com', 
        @tipo_usuario = 'Espectador', 
        @fecha_nac = '1995-04-12';

    EXEC dbo.Agregar_Usuario 
        @nombre_usuario = 'tester_maria', 
        @pass = 'maria456', 
        @email = 'tester_maria@mail.com', 
        @tipo_usuario = 'Espectador', 
        @fecha_nac = '1998-08-23';

    EXEC dbo.Agregar_Usuario 
        @nombre_usuario = 'critico_marcelo', 
        @pass = 'marcelo789', 
        @email = 'marcelo.criticas@cinema.com', 
        @tipo_usuario = 'Critico', 
        @fecha_nac = '1982-11-30';

    PRINT '--> Usuarios de prueba cargados correctamente.';
END TRY
BEGIN CATCH
    PRINT 'Aviso en Usuarios: ' + ERROR_MESSAGE();
END CATCH;
GO

-- ============================================================================
-- 2. CARGA DE USUARIOS (Habilitando Espectadores, Críticos y Administradores)
-- ============================================================================
PRINT 'Cargando Usuarios...';
BEGIN TRY
    -- Espectador 1
    EXEC dbo.Agregar_Usuario 
        @nombre_usuario = 'juan_perez', 
        @pass = 'juan123', 
        @email = 'juan@mail.com', 
        @tipo_usuario = 'Espectador', 
        @fecha_nac = '1995-04-12';

    -- Espectador 2
    EXEC dbo.Agregar_Usuario 
        @nombre_usuario = 'maria_drama', 
        @pass = 'maria456', 
        @email = 'maria@mail.com', 
        @tipo_usuario = 'Espectador', 
        @fecha_nac = '1998-08-23';

    -- Crítico Profesional 1
    EXEC dbo.Agregar_Usuario 
        @nombre_usuario = 'critico_marcelo', 
        @pass = 'marcelo789', 
        @email = 'marcelo.criticas@cinema.com', 
        @tipo_usuario = 'Critico', 
        @fecha_nac = '1982-11-30';

    -- Crítico Profesional 2
    EXEC dbo.Agregar_Usuario 
        @nombre_usuario = 'ana_cinefila', 
        @pass = 'ana2026', 
        @email = 'ana@评审.com', 
        @tipo_usuario = 'Critico', 
        @fecha_nac = '1990-01-15';

    PRINT '--> Usuarios cargados correctamente.';
END TRY
BEGIN CATCH
    PRINT 'Error en Usuarios: ' + ERROR_MESSAGE();
END CATCH;
GO

-- ============================================================================
-- 3. CARGA DE PERSONAS (Actores / Directores)
-- ============================================================================
PRINT 'Cargando Personas...';
BEGIN TRY
    -- Leonardo DiCaprio (Nacionalidad: EE.UU. = id_pais 1)
    EXEC dbo.Agregar_Persona 
        @nombre_persona = 'Leonardo', 
        @apellido_persona = 'DiCaprio', 
        @fecha_nacimiento = '1974-11-11', 
        @nacionalidad = 1, 
        @url_img = 'https://ejemplo.com/dicaprio.jpg';

    -- Christopher Nolan (Nacionalidad: Reino Unido = id_pais 3)
    EXEC dbo.Agregar_Persona 
        @nombre_persona = 'Christopher', 
        @apellido_persona = 'Nolan', 
        @fecha_nacimiento = '1970-07-30', 
        @nacionalidad = 3, 
        @url_img = NULL;

    -- Ricardo Darín (Nacionalidad: Argentina = id_pais 2)
    EXEC dbo.Agregar_Persona 
        @nombre_persona = 'Ricardo', 
        @apellido_persona = 'Darin', 
        @fecha_nacimiento = '1957-01-16', 
        @nacionalidad = 2, 
        @url_img = 'https://ejemplo.com/darin.jpg';

    -- Elliot Page
    EXEC dbo.Agregar_Persona 
        @nombre_persona = 'Elliot', 
        @apellido_persona = 'Page', 
        @fecha_nacimiento = '1987-02-21', 
        @nacionalidad = 1, 
        @url_img = NULL;

    PRINT '--> Personas del ambiente cargadas.';
END TRY
BEGIN CATCH
    PRINT 'Error en Persona: ' + ERROR_MESSAGE();
END CATCH;
GO

-- ============================================================================
-- 4. CARGA DE PELÍCULAS ADICIONALES PARA COMPLEMENTAR
-- ============================================================================
PRINT 'Cargando Películas Adicionales...';
BEGIN TRY
    -- Origen (Inception ya está en Creacion_DB, cargamos una nueva)
    EXEC dbo.Agregar_Pelicula
        @titulo = 'Interstellar',
        @duracion_minutos = 169,
        @id_genero = 1, -- Ciencia ficción
        @pais_origen = 1, -- EE.UU.
        @clasificacion_edad = '+13',
        @sinopsis = 'Un grupo de cientificos viaja a traves de un agujero de gusano para salvar a la humanidad.',
        @fecha_estreno = '2014-11-07',
        @url_img = 'https://ejemplo.com/interstellar.jpg',
        @estudio_cine = 'Paramount Pictures';

    -- El Secreto de sus Ojos
    EXEC dbo.Agregar_Pelicula
        @titulo = 'El Secreto de sus Ojos',
        @duracion_minutos = 129,
        @id_genero = 2, -- Drama
        @pais_origen = 2, -- Argentina
        @clasificacion_edad = '+16',
        @sinopsis = 'Un oficial de justicia retirado intenta resolver un crimen del pasado que lo obsesiona.',
        @fecha_estreno = '2009-08-13',
        @url_img = NULL,
        @estudio_cine = 'Haddock Films';

    PRINT '--> Películas del catálogo listas.';
END TRY
BEGIN CATCH
    PRINT 'Error en Películas: ' + ERROR_MESSAGE();
END CATCH;
GO

-- ============================================================================
-- 5. RELACIÓN DE ELENCO Y PAPELES DOBLES (PERSONAJES)
-- ============================================================================
PRINT 'Viculando Elencos y Personajes...';
BEGIN TRY
    -- Vinculamos a DiCaprio (id_persona 1) a la película Inception (id_pelicula 1)
    EXEC dbo.Agregar_Elenco @id_pelicula = 1, @id_persona = 1, @rol = 'Actor';
    -- Vinculamos a Elliot Page (id_persona 4) a Inception (id_pelicula 1)
    EXEC dbo.Agregar_Elenco @id_pelicula = 1, @id_persona = 4, @rol = 'Actor';
    -- Vinculamos a Christopher Nolan (id_persona 2) como Director de Interstellar (id_pelicula 3)
    EXEC dbo.Agregar_Elenco @id_pelicula = 3, @id_persona = 2, @rol = 'Director';
    -- Vinculamos a Ricardo Darín (id_persona 3) a El Secreto de sus Ojos (id_pelicula 4)
    EXEC dbo.Agregar_Elenco @id_pelicula = 4, @id_persona = 3, @rol = 'Actor';

    -- CARGA DE PERSONAJES (Cumpliendo la flexibilización de múltiples personajes)
    -- Asumiendo que DiCaprio en Inception obtuvo id_elenco = 1
    EXEC dbo.Agregar_Personaje @nombre_personaje = 'Cobb', @id_elenco = 1;
    
    -- CASO REGLA DE NEGOCIO DOCENTE: Doble papel para el mismo actor en la misma película.
    -- (DiCaprio hace un cameo mental o proyección ficticia como un personaje secundario en el sueño)
    EXEC dbo.Agregar_Personaje @nombre_personaje = 'Proyeccion Ficticia de Cobb', @id_elenco = 1;

    -- Elliot Page obtuvo id_elenco = 2
    EXEC dbo.Agregar_Personaje @nombre_personaje = 'Ariadne', @id_elenco = 2;

    -- Ricardo Darín obtuvo id_elenco = 4
    EXEC dbo.Agregar_Personaje @nombre_personaje = 'Benjamin Esposito', @id_elenco = 4;

    PRINT '--> Elenco y personajes mapeados (incluyendo papeles dobles).';
END TRY
BEGIN CATCH
    PRINT 'Error en Elenco/Personajes: ' + ERROR_MESSAGE();
END CATCH;
GO

-- ============================================================================
-- 6. SISTEMA DE CALIFICACIONES (Métrica Espectadores vs Críticos)
-- ============================================================================
PRINT 'Insertando Calificaciones para cálculos de promedios...';
BEGIN TRY
    -- Película: Inception (id_pelicula = 1)
    -- Votos de Espectadores (juan_perez = id 1, maria_drama = id 2)
    EXEC dbo.Agregar_Calificacion @id_usuario = 1, @id_pelicula = 1, @puntuacion = 5, @comentario = 'Una obra maestra absoluta de la ciencia ficcion.';
    EXEC dbo.Agregar_Calificacion @id_usuario = 2, @id_pelicula = 1, @puntuacion = 4, @comentario = 'Excelente, pero el final me dejo muy confundida.';

    -- Votos de Críticos Profesionales (critico_marcelo = id 3, ana_cinefila = id 4)
    EXEC dbo.Agregar_Calificacion @id_usuario = 3, @id_pelicula = 1, @puntuacion = 5, @comentario = 'Nolan maneja los tiempos narrativos de manera impecable.';
    EXEC dbo.Agregar_Calificacion @id_usuario = 4, @id_pelicula = 1, @puntuacion = 4, @comentario = 'Visualmente deslumbrante, gran actuacion de DiCaprio.';

    -- Película: El Secreto de sus Ojos (id_pelicula = 4)
    EXEC dbo.Agregar_Calificacion @id_usuario = 1, @id_pelicula = 4, @puntuacion = 5, @comentario = 'Merecido el Oscar. El plano secuencia de la cancha es historico.';
    EXEC dbo.Agregar_Calificacion @id_usuario = 3, @id_pelicula = 4, @puntuacion = 5, @comentario = 'Un guion solido apoyado en actuaciones soberbias de Darin y Francella.';

    PRINT '--> Calificaciones registradas de forma consistente.';
END TRY
BEGIN CATCH
    PRINT 'Error en Calificaciones: ' + ERROR_MESSAGE();
END CATCH;
GO

PRINT '======================================================================';
PRINT 'PROCESO DE CARGA FINALIZADO CON ÉXITO';
PRINT '======================================================================';
GO