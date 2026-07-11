import pyodbc


class RottenDB:
    def __init__(self):
        # Cadena de conexión adaptada a tu entorno Docker
        self.conn_str = (
            "DRIVER={ODBC Driver 18 for SQL Server};"
            "SERVER=localhost,1433;"
            "DATABASE=Rotten_DB;"
            "UID=sa;"
            "PWD=Utn_password2026!;"
            "TrustServerCertificate=yes;"
        )
        self.conn = None

    def connect(self):
        """Establece la conexión con la base de datos."""
        try:
            if not self.conn or self.conn.closed:
                self.conn = pyodbc.connect(self.conn_str)
            return self.conn
        except pyodbc.Error as e:
            print(f"\n[Error de Conexión] No se pudo conectar a SQL Server: {e}")
            return None

    def _execute_query(self, query, params=None, fetch_all=True):
        """Método interno helper para ejecutar consultas de forma segura."""
        conn = self.connect()
        if not conn:
            return None, None

        try:
            cursor = conn.cursor()
            if params:
                cursor.execute(query, params)
            else:
                cursor.execute(query)

            columns = (
                [column[0] for column in cursor.description]
                if cursor.description
                else []
            )

            if fetch_all:
                data = cursor.fetchall()
            else:
                data = cursor.fetchone()

            cursor.close()
            return columns, data
        except pyodbc.Error as e:
            print(f"\n[Error de Base de Datos] Falló la ejecución: {e}")
            return None, None

    # 1. Ver Catálogo Completo (Vista)
    def obtener_catalogo(self):
        query = "SELECT * FROM dbo.Vista_ListarPeliculasDetalle"
        return self._execute_query(query)

    # 2. Ver Ranking de Películas (Vista)
    def obtener_ranking(self):
        query = "SELECT * FROM dbo.Vista_ListarPeliculasMejorCalificadas"
        return self._execute_query(query)

    # 3. Buscar Películas (SP con filtros opcionales)
    def buscar_peliculas(self, texto=None, genero=None, anio=None):
        query = "{CALL dbo.SP_BuscarPeliculas (?, ?, ?)}"
        # Convertir strings vacíos o inputs nulos a None para que el SP los maneje
        params = (texto or None, genero or None, int(anio) if anio else None)
        return self._execute_query(query, params)

    # 4. Ver Detalle de una Película (SP)
    def obtener_detalle_pelicula(self, pelicula_id):
        query = "{CALL dbo.SP_ObtenerDetallePelicula (?)}"
        return self._execute_query(query, (pelicula_id,), fetch_all=False)

    # 5. Ver Elenco de una Película (SP)
    def obtener_elenco(self, pelicula_id):
        query = "{CALL dbo.SP_ListarElencoPelicula (?)}"
        return self._execute_query(query, (pelicula_id,))

    # 6. Promedios y Comentarios (Múltiples SPs)
    def obtener_metricas_y_comentarios(self, pelicula_id):
        # Ejecutamos los 3 SPs de forma secuencial
        q_promedio = "{CALL dbo.SP_ObtenerPromedioPelicula (?)}"
        q_tipos = "{CALL dbo.SP_ObtenerPromediosPorTipoUsuario (?)}"
        q_comentarios = "{CALL dbo.SP_ListarComentariosPelicula (?)}"

        col_p, res_p = self._execute_query(q_promedio, (pelicula_id,), fetch_all=False)
        col_t, res_t = self._execute_query(q_tipos, (pelicula_id,))
        col_c, res_c = self._execute_query(q_comentarios, (pelicula_id,))

        return (col_p, res_p), (col_t, res_t), (col_c, res_c)

    # 7. Historial de Calificaciones de un Usuario (SP)
    def obtener_historial_usuario(self, usuario_id):
        query = "{CALL dbo.SP_ListarCalificacionesUsuario (?)}"
        return self._execute_query(query, (usuario_id,))

    # 8. Buscar Películas por Persona/Actor (SP)
    def obtener_peliculas_por_persona(self, persona_id):
        query = "{CALL dbo.SP_ListarPeliculasPorPersona (?)}"
        return self._execute_query(query, (persona_id,))
