CREATE DATABASE BibliotecaIUE
GO

USE BibliotecaIUE
GO

-- Tablas de geografia (sin dependencias externas / con dependencia en cadena)

CREATE TABLE Pais(
	Id INT IDENTITY(1, 1) NOT NULL,
	Nombre VARCHAR(100) NOT NULL,
	CodigoAlfa VARCHAR(5) NOT NULL,
	Indicativo INT NULL,
	CONSTRAINT pkPais PRIMARY KEY (Id)
)
GO

CREATE TABLE Region(
	Id INT IDENTITY(1, 1) NOT NULL,
	Nombre VARCHAR(100) NOT NULL,
	IdPais INT NOT NULL,
	CONSTRAINT pkRegion PRIMARY KEY (Id),
	CONSTRAINT fkRegion_Pais FOREIGN KEY (IdPais) REFERENCES Pais(Id)
)
GO

CREATE TABLE Ciudad(
	Id INT IDENTITY(1, 1) NOT NULL,
	Nombre VARCHAR(100) NOT NULL,
	IdRegion INT NOT NULL,
	CONSTRAINT pkCiudad PRIMARY KEY (Id),
	CONSTRAINT fkCiudad_Region FOREIGN KEY (IdRegion) REFERENCES Region(Id)
)
GO

-- Catalogos (sin dependencias externas)

CREATE TABLE TipoDocumento(
	Id INT IDENTITY(1, 1) NOT NULL,
	Sigla VARCHAR(10) NOT NULL,
	Nombre VARCHAR(100) NOT NULL,
	CONSTRAINT pkTipoDocumento PRIMARY KEY (Id)
)
GO

CREATE TABLE Categoria(
	Id INT IDENTITY(1, 1) NOT NULL,
	Nombre VARCHAR(100) NOT NULL,
	CONSTRAINT pkCategoria PRIMARY KEY (Id)
)
GO

CREATE TABLE Formato(
	Id INT IDENTITY(1, 1) NOT NULL,
	Nombre VARCHAR(100) NOT NULL,
	CONSTRAINT pkFormato PRIMARY KEY (Id)
)
GO

CREATE TABLE EstadoPrestamo(
	Id INT IDENTITY(1, 1) NOT NULL,
	Nombre VARCHAR(50) NOT NULL,
	Descripcion VARCHAR(200) NULL,
	CONSTRAINT pkEstadoPrestamo PRIMARY KEY (Id)
)
GO

CREATE TABLE Autor(
	Id INT IDENTITY(1, 1) NOT NULL,
	Nombre VARCHAR(150) NOT NULL,
	CONSTRAINT pkAutor PRIMARY KEY (Id)
)
GO

-- Editora (depende de Pais)

CREATE TABLE Editora(
	Id INT IDENTITY(1, 1) NOT NULL,
	Nombre VARCHAR(150) NOT NULL,
	IdPais INT NOT NULL,
	CONSTRAINT pkEditora PRIMARY KEY (Id),
	CONSTRAINT fkEditora_Pais FOREIGN KEY (IdPais) REFERENCES Pais(Id)
)
GO

-- Titulo (depende de Categoria, Formato y Editora)

CREATE TABLE Titulo(
	Id INT IDENTITY(1, 1) NOT NULL,
	Nombre VARCHAR(200) NOT NULL,
	Anio INT NULL,
	Version VARCHAR(20) NULL,
	Volumen VARCHAR(20) NULL,
	Descripcion VARCHAR(500) NULL,
	IdCategoria INT NOT NULL,
	IdFormato INT NOT NULL,
	IdEditora INT NOT NULL,
	CONSTRAINT pkTitulo PRIMARY KEY (Id),
	CONSTRAINT fkTitulo_Categoria FOREIGN KEY (IdCategoria) REFERENCES Categoria(Id),
	CONSTRAINT fkTitulo_Formato FOREIGN KEY (IdFormato) REFERENCES Formato(Id),
	CONSTRAINT fkTitulo_Editora FOREIGN KEY (IdEditora) REFERENCES Editora(Id)
)
GO

-- Tabla intermedia: relacion M:N entre Titulo y Autor
	
CREATE TABLE Titulo_Autor(
	IdTitulo INT NOT NULL,
	IdAutor INT NOT NULL,
	CONSTRAINT pkTitulo_Autor PRIMARY KEY (IdTitulo, IdAutor),
	CONSTRAINT fkTituloAutor_Titulo FOREIGN KEY (IdTitulo) REFERENCES Titulo(Id),
	CONSTRAINT fkTituloAutor_Autor FOREIGN KEY (IdAutor) REFERENCES Autor(Id)
)
GO

-- Ejemplar: copia fisica de un Titulo
	
CREATE TABLE Ejemplar(
	Id INT IDENTITY(1, 1) NOT NULL,
	Estado VARCHAR(50) NOT NULL,
	IdTitulo INT NOT NULL,
	CONSTRAINT pkEjemplar PRIMARY KEY (Id),
	CONSTRAINT fkEjemplar_Titulo FOREIGN KEY (IdTitulo) REFERENCES Titulo(Id)
)
GO

-- Personas (dependen de Ciudad y TipoDocumento)

CREATE TABLE Cliente(
	Id INT IDENTITY(1, 1) NOT NULL,
	Nombre VARCHAR(150) NOT NULL,
	Genero VARCHAR(20) NULL,
	Nacimiento DATE NULL,
	Correo VARCHAR(150) NULL,
	CodigoPostal VARCHAR(10) NULL,
	Direccion VARCHAR(200) NULL,
	Movil VARCHAR(20) NULL,
	NumeroDocumento VARCHAR(30) NOT NULL,
	IdCiudad INT NOT NULL,
	IdTipoDocumento INT NOT NULL,
	CONSTRAINT pkCliente PRIMARY KEY (Id),
	CONSTRAINT fkCliente_Ciudad FOREIGN KEY (IdCiudad) REFERENCES Ciudad(Id),
	CONSTRAINT fkCliente_TipoDocumento FOREIGN KEY (IdTipoDocumento) REFERENCES TipoDocumento(Id)
)
GO

CREATE TABLE Empleado(
	Id INT IDENTITY(1, 1) NOT NULL,
	Nombre VARCHAR(150) NOT NULL,
	Identificacion VARCHAR(30) NOT NULL,
	IdCiudad INT NOT NULL,
	IdTipoDocumento INT NOT NULL,
	CONSTRAINT pkEmpleado PRIMARY KEY (Id),
	CONSTRAINT fkEmpleado_Ciudad FOREIGN KEY (IdCiudad) REFERENCES Ciudad(Id),
	CONSTRAINT fkEmpleado_TipoDocumento FOREIGN KEY (IdTipoDocumento) REFERENCES TipoDocumento(Id)
)
GO

-- Prestamo (depende de Cliente, Empleado, EstadoPrestamo)

CREATE TABLE Prestamo(
	Id INT IDENTITY(1, 1) NOT NULL,
	Factura VARCHAR(30) NOT NULL,
	Fecha DATE NOT NULL,
	FechaEntrega DATE NULL,
	FechaDevolucion DATE NULL,
	IdCliente INT NOT NULL,
	IdEmpleado INT NOT NULL,
	IdEstadoPrestamo INT NOT NULL,
	CONSTRAINT pkPrestamo PRIMARY KEY (Id),
	CONSTRAINT fkPrestamo_Cliente FOREIGN KEY (IdCliente) REFERENCES Cliente(Id),
	CONSTRAINT fkPrestamo_Empleado FOREIGN KEY (IdEmpleado) REFERENCES Empleado(Id),
	CONSTRAINT fkPrestamo_EstadoPrestamo FOREIGN KEY (IdEstadoPrestamo) REFERENCES EstadoPrestamo(Id)
)
GO

-- DetallePrestamo: que ejemplares especificos incluye cada prestamo
	
CREATE TABLE DetallePrestamo(
	Id INT IDENTITY(1, 1) NOT NULL,
	IdPrestamo INT NOT NULL,
	IdEjemplar INT NOT NULL,
	CONSTRAINT pkDetallePrestamo PRIMARY KEY (Id),
	CONSTRAINT fkDetallePrestamo_Prestamo FOREIGN KEY (IdPrestamo) REFERENCES Prestamo(Id),
	CONSTRAINT fkDetallePrestamo_Ejemplar FOREIGN KEY (IdEjemplar) REFERENCES Ejemplar(Id)
)
GO
