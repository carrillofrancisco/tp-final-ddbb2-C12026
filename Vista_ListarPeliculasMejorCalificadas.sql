USE Rotten_DB;
GO

/* ==========================================================================
   1. Vista_ListarPeliculasMejorCalificadas
   Explicación: Calcula el promedio de puntuación de cada película y las ordena 
   de mayor a menor. Incluye datos útiles como el género y la clasificación.
   ========================================================================== */
CREATE OR ALTER VIEW dbo.Vista_ListarPeliculasMejorCalificadas
AS
SELECT TOP 100 PERCENT
    P.id_peliculas,
    P.titulo,
    G.nombre AS genero,
    P.duracion_minutos,
    P.fecha_estreno,
    P.clasificacion_edad,
    CAST(AVG(C.puntuacion * 1.0) AS DECIMAL(3,2)) AS promedio_puntuacion,
    COUNT(C.id_calificacion) AS total_votos
FROM dbo.Peliculas P
INNER JOIN dbo.Genero G ON P.id_genero = G.id_genero
LEFT JOIN dbo.Calificaciones C ON P.id_peliculas = C.id_pelicula
GROUP BY 
    P.id_peliculas, P.titulo, G.nombre, P.duracion_minutos, 
    P.fecha_estreno, P.clasificacion_edad
ORDER BY promedio_puntuacion DESC, total_votos DESC;
GO


/* ==========================================================================
   2. SP_ListarPeliculasPorPersona (Antes Vista_ListarPeliculasPorPersona)
   Explicación: Trae todas las películas donde participó una persona (actor/director),
   especificando qué rol cumplió y qué personaje interpretó si aplica.
   ========================================================================== */
CREATE OR ALTER PROCEDURE dbo.SP_ListarPeliculasPorPersona
    @id_persona INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        P.id_peliculas,
        P.titulo,
        P.fecha_estreno,
        E.rol AS rol_en_elenco,
        ISNULL(PER.nombre_personaje, 'N/A') AS personaje
    FROM dbo.Peliculas P
    INNER JOIN dbo.Elenco E ON P.id_peliculas = E.id_pelicula
    INNER JOIN dbo.Persona PERS ON E.id_persona = PERS.id_persona
    LEFT JOIN dbo.Personaje PER ON E.id_elenco = PER.id_elenco
    WHERE PERS.id_persona = @id_persona
    ORDER BY P.fecha_estreno DESC;
END;
GO


/* ==========================================================================
   3. SP_BuscarPeliculas (Antes Vista_BuscarPeliculas)
   Explicación: Un buscador flexible. Podés pasarle parte del título, 
   filtrar por género o filtrar por año de estreno. Si mandás NULL, no filtra por ahí.
   ========================================================================== */
CREATE OR ALTER PROCEDURE dbo.SP_BuscarPeliculas
    @texto_busqueda VARCHAR(255) = NULL,
    @id_genero INT = NULL,
    @anio_estreno INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        P.id_peliculas,
        P.titulo,
        P.sinopsis,
        G.nombre AS genero,
        PA.nombre AS pais,
        P.duracion_minutos,
        P.fecha_estreno,
        P.clasificacion_edad
    FROM dbo.Peliculas P
    INNER JOIN dbo.Genero G ON P.id_genero = G.id_genero
    INNER JOIN dbo.Pais PA ON P.pais_origen = PA.id_pais
    WHERE 
        (@texto_busqueda IS NULL OR P.titulo LIKE '%' + @texto_busqueda + '%')
        AND (@id_genero IS NULL OR P.id_genero = @id_genero)
        AND (@anio_estreno IS NULL OR YEAR(P.fecha_estreno) = @anio_estreno)
    ORDER BY P.titulo ASC;
END;
GO