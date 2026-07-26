USE Rotten_DB;
GO

CREATE OR ALTER FUNCTION dbo.UFN_ObtenerEtiquetaPelicula (@promedio DECIMAL(3,2))
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @etiqueta VARCHAR(20);

    IF @promedio IS NULL
        SET @etiqueta = 'Sin Calificar';
    ELSE IF @promedio >= 4.5
        SET @etiqueta = 'Aclamada';
    ELSE IF @promedio >= 3.0
        SET @etiqueta = 'Buena';
    ELSE
        SET @etiqueta = 'Mala';

    RETURN @etiqueta;
END;
GO