-- ============================================
-- CREAR BASE DE DATOS
-- =============================================
CREATE DATABASE IF NOT EXISTS HotelMasCarga;
USE HotelMasCarga;

-- ============================================
-- TABLA: Roles
-- =============================================
CREATE TABLE Rol (
    RolID INT AUTO_INCREMENT PRIMARY KEY,
    NombreRol VARCHAR(50) NOT NULL UNIQUE
);

-- ============================================
-- TABLA: Usuarios del sistema
-- =============================================
CREATE TABLE Usuario (
    UsuarioID INT AUTO_INCREMENT PRIMARY KEY,
    NombreUsuario VARCHAR(50) NOT NULL UNIQUE,
    ContrasenaHash VARCHAR(255) NOT NULL,
    Activo BOOLEAN NOT NULL DEFAULT 1
);

-- ============================================
-- TABLA INTERMEDIA: UsuarioRol (N a N)
-- =============================================
CREATE TABLE UsuarioRol (
    UsuarioID INT NOT NULL,
    RolID INT NOT NULL,
    PRIMARY KEY (UsuarioID, RolID),
    FOREIGN KEY (UsuarioID) REFERENCES Usuario(UsuarioID),
    FOREIGN KEY (RolID) REFERENCES Rol(RolID)
);

-- ============================================
-- TABLA: Tipos de Habitación
-- =============================================
CREATE TABLE TipoHabitacion (
    TipoHabitacionID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL UNIQUE,
    Descripcion VARCHAR(255) NULL
);

-- ============================================
-- TABLA: Habitaciones
-- =============================================
CREATE TABLE Habitacion (
    HabitacionID INT AUTO_INCREMENT PRIMARY KEY,
    TipoHabitacionID INT NOT NULL,
    Codigo VARCHAR(50) NOT NULL UNIQUE,
    Activa BOOLEAN NOT NULL DEFAULT 1,
    FOREIGN KEY (TipoHabitacionID) REFERENCES TipoHabitacion(TipoHabitacionID)
);

-- ============================================
-- TABLA: Clientes
-- =============================================
CREATE TABLE Cliente (
    ClienteID INT AUTO_INCREMENT PRIMARY KEY,
    NombreCompleto VARCHAR(150) NOT NULL,
    Identificacion VARCHAR(20) NOT NULL UNIQUE,
    Telefono VARCHAR(20) NULL,
    Correo VARCHAR(100) NULL
);

-- ============================================
-- TABLA: Disponibilidad de Habitaciones
-- =============================================
CREATE TABLE Disponibilidad (
    DisponibilidadID INT AUTO_INCREMENT PRIMARY KEY,
    HabitacionID INT NOT NULL,
    Fecha DATE NOT NULL,
    Disponible BOOLEAN NOT NULL DEFAULT 1,
    CONSTRAINT UQ_Disponibilidad UNIQUE (HabitacionID, Fecha),
    FOREIGN KEY (HabitacionID) REFERENCES Habitacion(HabitacionID)
);

-- ============================================
-- TABLA: Reservas
-- =============================================
CREATE TABLE Reserva (
    ReservaID INT AUTO_INCREMENT PRIMARY KEY,
    ClienteID INT NOT NULL,
    HabitacionID INT NOT NULL,
    Fecha DATE NOT NULL,
    Estado VARCHAR(20) NOT NULL DEFAULT 'Activa',
    CONSTRAINT UQ_Reserva UNIQUE (ClienteID, HabitacionID, Fecha),
    FOREIGN KEY (ClienteID) REFERENCES Cliente(ClienteID),
    FOREIGN KEY (HabitacionID) REFERENCES Habitacion(HabitacionID)
);

-- ============================================
-- TABLA: Historial de Reservas
-- =============================================
CREATE TABLE HistorialReserva (
    HistorialID INT AUTO_INCREMENT PRIMARY KEY,
    ReservaID INT NOT NULL,
    FechaOperacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Accion VARCHAR(50) NOT NULL,
    Detalle VARCHAR(255) NULL,
    FOREIGN KEY (ReservaID) REFERENCES Reserva(ReservaID)
);

-- ============================================
-- TABLA: Cola de Espera
-- =============================================
CREATE TABLE ColaEspera (
    ColaID INT AUTO_INCREMENT PRIMARY KEY,
    ClienteID INT NOT NULL,
    TipoHabitacionID INT NOT NULL,
    Fecha DATE NOT NULL,
    Estado VARCHAR(20) NOT NULL DEFAULT 'Activo',
    FechaRegistro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ClienteID) REFERENCES Cliente(ClienteID),
    FOREIGN KEY (TipoHabitacionID) REFERENCES TipoHabitacion(TipoHabitacionID)
);

-- ============================================
-- ÍNDICES PARA RENDIMIENTO
-- =============================================
CREATE INDEX IX_Reserva_Cliente ON Reserva(ClienteID);
CREATE INDEX IX_Reserva_Fecha ON Reserva(Fecha);
CREATE INDEX IX_Disponibilidad_Fecha ON Disponibilidad(Fecha);
CREATE INDEX IX_ColaEspera_FechaEstado ON ColaEspera(Fecha, Estado);
