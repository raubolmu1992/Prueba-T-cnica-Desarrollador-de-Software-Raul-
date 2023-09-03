use master
go
IF NOT EXISTS(SELECT name FROM master.dbo.sysdatabases WHERE NAME = 'Logistica')
CREATE DATABASE Logistica

GO 
USE Logistica
GO

--Crea tabla Usuarios 
if not exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Usuarios')
create table Usuarios(
Id_Usuario int primary key identity(1,1),
Usuario  varchar(60),
Contrasena  varchar(60)
)

go
--Crea tabla Clientes 
if not exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Clientes')
create table Clientes(
Id_Cliente int primary key identity(1,1),
Codigo_Cliente  varchar(60),
Nombre  varchar(60),
Direccion varchar(60),
Telefono varchar(11)
)
go


--Crea tabla Productos Terrestres 
if not exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Productos')
create table Productos(
Id_Producto int primary key identity(1,1),
Tipo_producto  varchar(60),
Cantidad_producto int,
Fecha_registro Date,
Fecha_entrega Date,
Medio_Entrega varchar(60),
Bodega_Entrega varchar(60),
Puerto_Entrega varchar(60),
Precio_envio int,
Medio_Transporte varchar(60),
Placa_vehículo varchar(8),
Numero_guía varchar(10),
Numero_Flota varchar(8),
Codigo_Cliente int,
Descuento int

)
go

--Crea tabla Envio 
if not exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Envios')
create table Envios(
Id_Envío  int primary key identity(1,1),
Id_Cliente  int,
Id_Producto int


)
go

--Añadir llaves Foraneas 
USE [Logistica]
GO
ALTER TABLE Envios ADD FOREIGN KEY (Id_Cliente) REFERENCES Clientes(Id_Cliente) ON DELETE CASCADE
ALTER TABLE Envios ADD FOREIGN KEY (Id_Producto) REFERENCES Productos(Id_Producto) ON DELETE CASCADE
ALTER TABLE Productos ADD         FOREIGN KEY (Codigo_Cliente) REFERENCES Clientes(Id_Cliente)

go


