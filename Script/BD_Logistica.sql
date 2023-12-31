USE [Logistica]
GO
/****** Object:  Table [dbo].[Clientes]    Script Date: 2/9/2023 19:42:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Clientes](
	[Id_Cliente] [int] IDENTITY(1,1) NOT NULL,
	[Codigo_Cliente] [varchar](60) NULL,
	[Nombre] [varchar](60) NULL,
	[Direccion] [varchar](60) NULL,
	[Telefono] [varchar](11) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Cliente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Envios]    Script Date: 2/9/2023 19:42:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Envios](
	[Id_Envío] [int] IDENTITY(1,1) NOT NULL,
	[Id_Cliente] [int] NULL,
	[Id_Producto] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Envío] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Productos]    Script Date: 2/9/2023 19:42:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Productos](
	[Id_Producto] [int] IDENTITY(1,1) NOT NULL,
	[Tipo_producto] [varchar](60) NULL,
	[Cantidad_producto] [int] NULL,
	[Fecha_registro] [date] NULL,
	[Fecha_entrega] [date] NULL,
	[Medio_Entrega] [varchar](60) NULL,
	[Bodega_Entrega] [varchar](60) NULL,
	[Puerto_Entrega] [varchar](60) NULL,
	[Precio_envio] [int] NULL,
	[Medio_Transporte] [varchar](60) NULL,
	[Placa_vehículo] [varchar](8) NULL,
	[Numero_guía] [varchar](10) NULL,
	[Numero_Flota] [varchar](8) NULL,
	[Codigo_Cliente] [int] NULL,
	[Descuento] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Producto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Usuarios]    Script Date: 2/9/2023 19:42:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Usuarios](
	[Id_Usuario] [int] IDENTITY(1,1) NOT NULL,
	[Usuario] [varchar](60) NULL,
	[Contrasena] [varchar](60) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Usuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Envios]  WITH CHECK ADD FOREIGN KEY([Id_Cliente])
REFERENCES [dbo].[Clientes] ([Id_Cliente])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Envios]  WITH CHECK ADD FOREIGN KEY([Id_Producto])
REFERENCES [dbo].[Productos] ([Id_Producto])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Productos]  WITH CHECK ADD FOREIGN KEY([Codigo_Cliente])
REFERENCES [dbo].[Clientes] ([Id_Cliente])
GO
/****** Object:  StoredProcedure [dbo].[usp_eliminar]    Script Date: 2/9/2023 19:42:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Eliminar
create procedure [dbo].[usp_eliminar](
@IdProducto int
)
as
begin


delete from    [Logistica].[dbo].[Productos]  where Codigo_Cliente = @IdProducto
delete from    [Logistica].[dbo].[Clientes] where Id_Cliente = @IdProducto 
delete from    [Logistica].[dbo].[Envios] where Id_Producto = @IdProducto
  
end

GO
/****** Object:  StoredProcedure [dbo].[usp_listar]    Script Date: 2/9/2023 19:42:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[usp_listar]
as
begin
  select e.Id_Envío as Codigo_Transporte , c.Nombre, c.Direccion, c.Telefono, pt.Tipo_Producto, pt.Cantidad_Producto, pt.Fecha_registro, pt.Fecha_Entrega, pt.Medio_Entrega, pt.Bodega_Entrega,pt.Puerto_Entrega, pt.Precio_envio,pt.Medio_Transporte, pt.Placa_vehículo, pt.Numero_guía, pt.Numero_Flota, pt.Descuento,pt.Codigo_Cliente
   from[Logistica].[dbo].[Clientes] c 
   inner join  [Logistica].[dbo].[Productos] pt on pt.Codigo_Cliente = c.Id_Cliente
   inner join  [Logistica].[dbo].[Envios] e  on e.Id_Producto = pt.Id_Producto
end


GO
/****** Object:  StoredProcedure [dbo].[usp_ListarUsuarios]    Script Date: 2/9/2023 19:42:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Listar Usuarios
create procedure [dbo].[usp_ListarUsuarios](
@Usuario varchar(60),
@Contrasena varchar(60)
)
as
begin

Select * from Usuarios where Usuario = @Usuario and Contrasena = @Contrasena

end


GO
/****** Object:  StoredProcedure [dbo].[usp_modificar]    Script Date: 2/9/2023 19:42:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[usp_modificar](
@Codigo_Cliente int,
@Nombre varchar(60),
@Direccion varchar(60),
@Telefono varchar(60),
@Tipo_producto varchar(60),
@Cantidad_producto int,
@Fecha_registro Date,
@Fecha_entrega Date,
@Bodega_Entrega varchar(60) NULL,
@Puerto_Entrega varchar(60) NULL,
@Medio_Entrega varchar(60),
@Precio_envio int,
@Medio_Transporte varchar(60) NULL,
@Placa_vehículo varchar(60) NULL,
@Numero_Flota varchar(60)   NULL,
@Numero_guía varchar(60),
@Descuento int
)
as
begin

UPDATE c  SET
c.Nombre                =  @Nombre         ,  
c.Direccion             =  @Direccion       , 
c.Telefono              =  @Telefono         
FROM [Logistica].[dbo].[Clientes] c ,  [Logistica].[dbo].[Productos] p
where p.Codigo_Cliente =C.Id_Cliente
and c.Id_Cliente =  @Codigo_Cliente 

UPDATE p  SET  
p.	Tipo_producto         =  @Tipo_producto    ,
p.Cantidad_producto     =  @Cantidad_producto,
p.Fecha_registro        =  @Fecha_registro   ,
p.Fecha_entrega         =  @Fecha_entrega    ,
p.Bodega_Entrega        =  @Bodega_Entrega   ,
p.Puerto_Entrega        =    @Puerto_Entrega ,
p.Medio_Entrega         =  @Medio_Entrega    ,
p.Precio_envio          =  @Precio_envio     ,
p.Medio_Transporte      =  @Medio_Transporte ,
p.Placa_vehículo        =  @Placa_vehículo   ,
p.Numero_Flota          =       @Numero_Flota   ,
p.Numero_guía           =  @Numero_guía ,     
p.Descuento             =  @Descuento 
FROM  [Logistica].[dbo].[Productos] p, [Logistica].[dbo].[Clientes] c  
where p.Codigo_Cliente =C.Id_Cliente
and p.Codigo_Cliente =  @Codigo_Cliente 
end
GO
/****** Object:  StoredProcedure [dbo].[usp_obtener]    Script Date: 2/9/2023 19:42:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[usp_obtener]
@Id_Envio varchar(60)
as
begin

  select e.Id_Envío as Codigo_Transporte , c.Nombre, c.Direccion, c.Telefono, pt.Tipo_Producto, pt.Cantidad_Producto, pt.Fecha_registro, pt.Fecha_Entrega, pt.Medio_Entrega, pt.Bodega_Entrega,pt.Puerto_Entrega, pt.Precio_envio,pt.Medio_Transporte, pt.Placa_vehículo, pt.Numero_guía, pt.Numero_Flota, pt.Descuento,pt.Codigo_Cliente
   from[Logistica].[dbo].[Clientes] c 
   inner join  [Logistica].[dbo].[Productos] pt on pt.Codigo_Cliente = c.Id_Cliente
   inner join  [Logistica].[dbo].[Envios] e  on e.Id_Producto = pt.Id_Producto
   where e.Id_Envío = @Id_Envio
end


--Modificar
GO
/****** Object:  StoredProcedure [dbo].[usp_registrar]    Script Date: 2/9/2023 19:42:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[usp_registrar](
@Codigo_Cliente int,
@Nombre varchar(60),
@Direccion varchar(60),
@Telefono varchar(60),
@Tipo_producto varchar(60),
@Cantidad_producto int,
@Fecha_registro varchar(60),
@Fecha_entrega varchar(60),
@Bodega_Entrega varchar(60) NULL,
@Medio_Entrega varchar(60),
@Precio_envio int,
@Medio_Transporte varchar(60) NULL,
@Placa_vehículo varchar(60) NULL,
@Numero_guía varchar(60),
@Descuento int
)
as
begin

Declare @ValId_Cliente varchar(60) 
Declare @Id_Producto varchar(60)
Declare @Puerto_Entrega varchar(60) = @Bodega_Entrega
Declare @Numero_Flota varchar(60) = @Placa_vehículo
Declare @ValTipo_producto varchar(60)

insert into Clientes(Codigo_Cliente,Nombre,Direccion,Telefono)
values
(
@Codigo_Cliente,
@Nombre,
@Direccion,
@Telefono
)

set @ValId_Cliente = (SELECT SCOPE_IDENTITY());
Set @ValTipo_producto = @Tipo_producto

insert into Productos(Tipo_producto,Cantidad_producto,Fecha_registro,Fecha_entrega,Medio_Entrega,Bodega_Entrega,Puerto_Entrega,Precio_envio,Medio_Transporte,Placa_vehículo,Numero_guía,Numero_Flota,Codigo_Cliente,Descuento)
values
(
@Tipo_producto,
@Cantidad_producto,
@Fecha_registro,
@Fecha_entrega,
@Medio_Entrega,
@Bodega_Entrega,
@Puerto_Entrega,
@Precio_envio,
@Medio_Transporte,
@Placa_vehículo,
@Numero_guía,
@Numero_Flota,
@ValId_Cliente,
@Descuento
)
set @Id_Producto = (SELECT SCOPE_IDENTITY());

insert into Envios(Id_Cliente,Id_Producto)
values
(
@ValId_Cliente,
@Id_Producto
)

end

--Listas Registros 
GO
/****** Object:  StoredProcedure [dbo].[usp_registrarUsuarios]    Script Date: 2/9/2023 19:42:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Registrar Usuarios
create procedure [dbo].[usp_registrarUsuarios](
@Usuario varchar(60),
@Contrasena varchar(60)
)
as
begin
insert into Usuarios(Usuario,Contrasena)
values
(
@Usuario,
@Contrasena
)
end

GO
