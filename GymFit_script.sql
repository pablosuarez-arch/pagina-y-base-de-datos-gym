-- PROYECTO FINAL BASES DE DATOS I - SISTEMA GYMFIT (gestión de un gimnasio)
-- Motor: SQL Server

CREATE DATABASE GymFit;
GO
USE GymFit;
GO

CREATE TABLE Membresia (
    id_membresia  INT IDENTITY(1,1) PRIMARY KEY,
    nombre        VARCHAR(40)   NOT NULL UNIQUE,
    precio        DECIMAL(10,2) NOT NULL CHECK (precio > 0),
    duracion_dias INT           NOT NULL
);

CREATE TABLE Entrenador (
    id_entrenador INT IDENTITY(1,1) PRIMARY KEY,
    nombre        VARCHAR(80) NOT NULL,
    especialidad  VARCHAR(50) NOT NULL
);

CREATE TABLE Miembro (
    id_miembro    INT IDENTITY(1,1) PRIMARY KEY,
    nombre        VARCHAR(80)  NOT NULL,
    correo        VARCHAR(100) NOT NULL UNIQUE,
    ciudad        VARCHAR(50)  NOT NULL,
    fecha_ingreso DATE         NOT NULL,
    id_membresia  INT          NOT NULL,
    FOREIGN KEY (id_membresia) REFERENCES Membresia(id_membresia)
);

CREATE TABLE Clase (
    id_clase      INT IDENTITY(1,1) PRIMARY KEY,
    nombre        VARCHAR(60) NOT NULL,
    horario       VARCHAR(30) NOT NULL,
    cupo          INT         NOT NULL CHECK (cupo > 0),
    id_entrenador INT         NOT NULL,
    FOREIGN KEY (id_entrenador) REFERENCES Entrenador(id_entrenador)
);

CREATE TABLE Inscripcion (
    id_inscripcion INT IDENTITY(1,1) PRIMARY KEY,
    id_miembro     INT         NOT NULL,
    id_clase       INT         NOT NULL,
    fecha          DATE        NOT NULL,
    estado         VARCHAR(15) NOT NULL CHECK (estado IN ('Activa','Cancelada','Completada')),
    FOREIGN KEY (id_miembro) REFERENCES Miembro(id_miembro) ON DELETE CASCADE,
    FOREIGN KEY (id_clase)   REFERENCES Clase(id_clase)
);
GO

INSERT INTO Membresia (nombre, precio, duracion_dias) VALUES
('Basica', 60000, 30), ('Estandar', 90000, 30), ('Premium', 130000, 30), ('Anual', 900000, 365);

INSERT INTO Entrenador (nombre, especialidad) VALUES
('Carlos Mejia', 'Crossfit'), ('Laura Restrepo', 'Yoga'), ('Andres Zapata', 'Spinning'),
('Marcela Ruiz', 'Zumba'), ('Julian Osorio', 'Pesas'), ('Daniela Cano', 'Funcional');

INSERT INTO Miembro (nombre, correo, ciudad, fecha_ingreso, id_membresia) VALUES
('Juan Perez',      'juan.perez@mail.com',   'Medellin',  '2026-01-10', 1),
('Maria Lopez',     'maria.lopez@mail.com',  'Envigado',  '2026-01-15', 2),
('Pedro Gomez',     'pedro.gomez@mail.com',  'Medellin',  '2026-02-03', 3),
('Ana Torres',      'ana.torres@mail.com',   'Bello',     '2026-02-20', 2),
('Luis Ramirez',    'luis.ramirez@mail.com', 'Itagui',    '2026-03-05', 4),
('Sofia Castro',    'sofia.castro@mail.com', 'Medellin',  '2026-03-18', 3),
('Camilo Vargas',   'camilo.vargas@mail.com','Envigado',  '2026-04-02', 1),
('Valentina Rios',  'valen.rios@mail.com',   'Sabaneta',  '2026-04-25', 2),
('Diego Herrera',   'diego.herrera@mail.com','Bello',     '2026-05-11', 3),
('Laura Mora',      'laura.mora@mail.com',   'Medellin',  '2026-06-01', 4),
('Felipe Duque',    'felipe.duque@mail.com', 'Itagui',    '2026-07-07', 1),
('Natalia Salazar', 'natalia.s@mail.com',    'Sabaneta',  '2026-08-14', 2);

INSERT INTO Clase (nombre, horario, cupo, id_entrenador) VALUES
('Crossfit Mañana',  'Lun-Mie 06:00', 15, 1), ('Yoga Relax',      'Mar-Jue 07:00', 12, 2),
('Spinning Power',   'Lun-Vie 18:00', 20, 3), ('Zumba Fiesta',    'Mar-Jue 19:00', 25, 4),
('Pesas Avanzado',   'Lun-Vie 17:00', 10, 5), ('Funcional Total', 'Sab 09:00',     18, 6),
('Yoga Nocturno',    'Mie 20:00',     12, 2), ('Spinning Sabado', 'Sab 08:00',     15, 3);

INSERT INTO Inscripcion (id_miembro, id_clase, fecha, estado) VALUES
(1,1,'2026-09-01','Activa'),    (1,3,'2026-09-02','Completada'), (2,2,'2026-09-01','Activa'),
(2,4,'2026-09-03','Activa'),    (3,1,'2026-09-04','Completada'), (3,5,'2026-09-05','Activa'),
(4,4,'2026-09-06','Cancelada'), (4,2,'2026-09-06','Activa'),     (5,3,'2026-09-07','Activa'),
(5,6,'2026-09-08','Completada'),(6,2,'2026-09-09','Activa'),     (6,4,'2026-09-10','Activa'),
(7,1,'2026-09-11','Cancelada'), (8,4,'2026-09-12','Activa'),     (9,5,'2026-09-13','Completada'),
(9,3,'2026-09-14','Activa'),    (10,2,'2026-09-15','Activa'),    (10,6,'2026-09-16','Activa'),
(11,3,'2026-09-17','Cancelada'),(12,4,'2026-09-18','Activa');
GO

