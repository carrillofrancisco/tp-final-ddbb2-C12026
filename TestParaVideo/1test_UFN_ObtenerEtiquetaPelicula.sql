USE Rotten_DB;
GO


SELECT 
    4.80 AS Promedio_Prueba, dbo.UFN_ObtenerEtiquetaPelicula(4.80) AS Resultado_Esperado_Aclamada
UNION ALL
SELECT 
    3.50 AS Promedio_Prueba, dbo.UFN_ObtenerEtiquetaPelicula(3.50) AS Resultado_Esperado_Buena
UNION ALL
SELECT 
    2.10 AS Promedio_Prueba, dbo.UFN_ObtenerEtiquetaPelicula(2.10) AS Resultado_Esperado_Mala
UNION ALL
SELECT 
    NULL AS Promedio_Prueba, dbo.UFN_ObtenerEtiquetaPelicula(NULL) AS Resultado_Esperado_SinCalificar;
GO