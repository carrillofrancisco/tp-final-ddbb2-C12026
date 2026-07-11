import os

from database import RottenDB
from tabulate import tabulate

db = RottenDB()


def limpiar_pantalla():
    os.system("cls" if os.name == "nt" else "clear")


def mostrar_tabla(columns, data, titulo=None):
    """Helper para renderizar tablas estilizadas."""
    if titulo:
        print(f"\n=== {titulo} ===")

    if not data:
        print("No se encontraron registros.")
        return

    # Si data es un solo registro (fetchone devuelve un objeto Row, no una lista)
    if not isinstance(data, list):
        data = [data]

    # Convertir filas de pyodbc a listas tradicionales para tabulate
    filas = [list(fila) for fila in data]
    print(tabulate(filas, headers=columns, tablefmt="fancy_grid", stralign="left"))


def pausar():
    input("\nPresioná Enter para continuar...")


def menu_principal():
    while True:
        limpiar_pantalla()
        print("=============================================")
        print("       ROTTEN DB - PANEL DE CONTROL CLI      ")
        print("=============================================")
        print("1. Ver Catálogo Completo")
        print("2. Ver Ranking de Películas")
        print("3. Buscar Películas (Filtros Avanzados)")
        print("4. Ver Detalle de una Película")
        print("5. Ver Elenco de una Película")
        print("6. Ver Promedios y Comentarios de Película")
        print("7. Historial de Calificaciones de un Usuario")
        print("8. Buscar Películas por Persona/Actor")
        print("9. Salir")
        print("=============================================")

        opcion = input("Seleccioná una opción (1-9): ").strip()

        if opcion == "1":
            cols, data = db.obtener_catalogo()
            if cols is not None:
                mostrar_tabla(cols, data, "CATÁLOGO COMPLETO DE PELÍCULAS")
            pausar()

        elif opcion == "2":
            cols, data = db.obtener_ranking()
            if cols is not None:
                mostrar_tabla(cols, data, "RANKING DE PELÍCULAS MEJOR CALIFICADAS")
            pausar()

        elif opcion == "3":
            print("\n--- Filtros de Búsqueda (Dejar en blanco para omitir) ---")
            texto = input("Texto/Título a buscar: ").strip()
            genero = input("Género: ").strip()
            anio = input("Año de estreno: ").strip()

            cols, data = db.buscar_peliculas(texto, genero, anio)
            if cols is not None:
                mostrar_tabla(cols, data, "RESULTADOS DE LA BÚSQUEDA")
            pausar()

        elif opcion == "4":
            p_id = input("\nIngresá el ID de la película: ").strip()
            if p_id.isdigit():
                cols, data = db.obtener_detalle_pelicula(int(p_id))
                if cols is not None:
                    mostrar_tabla(cols, data, f"DETALLE DE LA PELÍCULA ID: {p_id}")
            else:
                print("ID inválido. Debe ser numérico.")
            pausar()

        elif opcion == "5":
            p_id = input("\nIngresá el ID de la película para ver su elenco: ").strip()
            if p_id.isdigit():
                cols, data = db.obtener_elenco(int(p_id))
                if cols is not None:
                    mostrar_tabla(cols, data, f"ELENCO DE LA PELÍCULA ID: {p_id}")
            else:
                print("ID inválido. Debe ser numérico.")
            pausar()

        elif opcion == "6":
            p_id = input("\nIngresá el ID de la película: ").strip()
            if p_id.isdigit():
                p_id_int = int(p_id)
                # Obtenemos las 3 consultas empaquetadas
                prom, tipos, coments = db.obtener_metricas_y_comentarios(p_id_int)

                if prom[0] is not None:
                    mostrar_tabla(prom[0], prom[1], "PROMEDIO GENERAL")
                    mostrar_tabla(tipos[0], tipos[1], "PROMEDIOS POR TIPO DE USUARIO")
                    mostrar_tabla(coments[0], coments[1], "COMENTARIOS DE USUARIOS")
            else:
                print("ID inválido. Debe ser numérico.")
            pausar()

        elif opcion == "7":
            u_id = input("\nIngresá el ID del usuario: ").strip()
            if u_id.isdigit():
                cols, data = db.obtener_historial_usuario(int(u_id))
                if cols is not None:
                    mostrar_tabla(
                        cols, data, f"HISTORIAL DE CALIFICACIONES - USUARIO {u_id}"
                    )
            else:
                print("ID inválido. Debe ser numérico.")
            pausar()

        elif opcion == "8":
            per_id = input("\nIngresá el ID de la Persona/Actor: ").strip()
            if per_id.isdigit():
                cols, data = db.obtener_peliculas_por_persona(int(per_id))
                if cols is not None:
                    mostrar_tabla(
                        cols,
                        data,
                        f"PELÍCULAS EN LAS QUE PARTICIPÓ LA PERSONA ID {per_id}",
                    )
            else:
                print("ID inválido. Debe ser numérico.")
            pausar()

        elif opcion == "9":
            print("\nSaliendo del sistema de gestión 'Rotten_DB'. ¡Hasta luego!")
            break
        else:
            print("\nOpción no válida. Por favor, seleccioná del 1 al 9.")
            pausar()


if __name__ == "__main__":
    # Test inicial de conexión antes de lanzar el loop
    test_db = RottenDB()
    if test_db.connect():
        menu_principal()
