CREATE TABLE dbo.Auditoria_Calificaciones (
    id_auditoria BIGINT IDENTITY(1,1) PRIMARY KEY,
    id_usuario BIGINT NOT NULL,
    id_pelicula INT NOT NULL,
    puntuacion INT NOT NULL,
    accion VARCHAR(20) NOT NULL, -- 'INSERT', 'DELETE', 'UPDATE'
    fecha_registro DATETIME DEFAULT GETDATE()
);
GO