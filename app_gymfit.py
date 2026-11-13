# Aplicacion GymFit - CRUD de Miembros conectado a SQL Server
# Requisitos: pip install pyodbc
import pyodbc

# Cambia SERVER por el nombre de tu instancia (ej: localhost\SQLEXPRESS)
conn = pyodbc.connect(
    "DRIVER={ODBC Driver 17 for SQL Server};"
    "SERVER=localhost\SQLEXPRESS;DATABASE=GymFit;Trusted_Connection=yes;"
)
cur = conn.cursor()


def crear():
    nombre = input("Nombre: ")
    correo = input("Correo: ")
    ciudad = input("Ciudad: ")
    fecha = input("Fecha ingreso (AAAA-MM-DD): ")
    membresia = int(input("ID membresia (1-4): "))
    cur.execute(
        "INSERT INTO Miembro (nombre, correo, ciudad, fecha_ingreso, id_membresia) VALUES (?,?,?,?,?)",
        nombre, correo, ciudad, fecha, membresia)
    conn.commit()
    print("Miembro creado.")


def consultar():
    cur.execute("""SELECT m.id_miembro, m.nombre, m.correo, m.ciudad, ms.nombre
                   FROM Miembro m INNER JOIN Membresia ms ON m.id_membresia = ms.id_membresia""")
    for f in cur.fetchall():
        print(f"{f[0]:>3} | {f[1]:<18} | {f[2]:<25} | {f[3]:<10} | {f[4]}")


def actualizar():
    id_m = int(input("ID del miembro a actualizar: "))
    ciudad = input("Nueva ciudad: ")
    membresia = int(input("Nuevo ID membresia: "))
    cur.execute("UPDATE Miembro SET ciudad = ?, id_membresia = ? WHERE id_miembro = ?",
                ciudad, membresia, id_m)
    conn.commit()
    print("Filas actualizadas:", cur.rowcount)


def eliminar():
    id_m = int(input("ID del miembro a eliminar: "))
    cur.execute("DELETE FROM Miembro WHERE id_miembro = ?", id_m)
    conn.commit()
    print("Filas eliminadas:", cur.rowcount)


def reporte():
    cur.execute("""SELECT c.nombre, COUNT(i.id_inscripcion)
                   FROM Clase c LEFT JOIN Inscripcion i ON c.id_clase = i.id_clase
                   GROUP BY c.nombre ORDER BY 2 DESC""")
    for f in cur.fetchall():
        print(f"{f[0]:<20} {f[1]} inscripciones")


opciones = {"1": crear, "2": consultar, "3": actualizar, "4": eliminar, "5": reporte}

while True:
    print("\n--- GYMFIT ---\n1. Crear miembro\n2. Consultar miembros\n3. Actualizar miembro\n"
          "4. Eliminar miembro\n5. Reporte inscripciones por clase\n0. Salir")
    op = input("Opcion: ")
    if op == "0":
        break
    try:
        opciones.get(op, lambda: print("Opcion invalida"))()
    except Exception as e:
        print("Error:", e)

conn.close()
