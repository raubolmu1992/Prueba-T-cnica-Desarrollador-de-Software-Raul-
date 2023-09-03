go
use Logistica
go
--************************ VALIDAMOS SI EXISTE EL PROCEDIMIENTO ************************--

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_registrar')
DROP PROCEDURE usp_registrar

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_ListarUsuarios')
DROP PROCEDURE usp_ListarUsuarios

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_registrarUsuarios')
DROP PROCEDURE usp_registrarUsuarios

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_listar')
DROP PROCEDURE usp_listar

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_obtener')
DROP PROCEDURE usp_obtener

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_modificar')
DROP PROCEDURE usp_modificar

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_eliminar')
DROP PROCEDURE usp_eliminar

go
--************************ PROCEDIMIENTOS PARA CREAR ************************--

go
use Logistica
go

--Registrar Usuarios
create procedure usp_registrarUsuarios(
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

go
use Logistica
go

--Listar Usuarios
create procedure usp_ListarUsuarios(
@Usuario varchar(60),
@Contrasena varchar(60)
)
as
begin

Select * from Usuarios where Usuario = @Usuario and Contrasena = @Contrasena

end


go
use Logistica
go

create procedure usp_registrar(
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
go
create procedure usp_listar
as
begin
  select e.Id_Envío as Codigo_Transporte , c.Nombre, c.Direccion, c.Telefono, pt.Tipo_Producto, pt.Cantidad_Producto, pt.Fecha_registro, pt.Fecha_Entrega, pt.Medio_Entrega, pt.Bodega_Entrega,pt.Puerto_Entrega, pt.Precio_envio,pt.Medio_Transporte, pt.Placa_vehículo, pt.Numero_guía, pt.Numero_Flota, pt.Descuento,pt.Codigo_Cliente
   from[Logistica].[dbo].[Clientes] c 
   inner join  [Logistica].[dbo].[Productos] pt on pt.Codigo_Cliente = c.Id_Cliente
   inner join  [Logistica].[dbo].[Envios] e  on e.Id_Producto = pt.Id_Producto
end


go
create procedure usp_obtener
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
go

create procedure usp_modificar(
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
go

--Eliminar
create procedure usp_eliminar(
@IdProducto int
)
as
begin


delete from    [Logistica].[dbo].[Productos]  where Codigo_Cliente = @IdProducto
delete from    [Logistica].[dbo].[Clientes] where Id_Cliente = @IdProducto 
delete from    [Logistica].[dbo].[Envios] where Id_Producto = @IdProducto
  
end

go
