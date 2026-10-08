--Elimina la base de datos si existe--
drop database if exists Tienda_ADSO;
--creación de la base de datos--
CREATE DATABASE tienda_adso
CHARACTER set utf8mb4
COLLATE utf8mb4_unicode_ci;
--utilización de la base de datos--
USE tienda_adso;
--crear tabla categorias--
CREATE TABLE categorias (
    id_categoria int NOT NULL AUTO_INCREMENT,
    nombre varchar(50) NOT NULL,
    descripcion varchar(255) NULL,
    CONSTRAINT pk_categorias PRIMARY KEY(id_categoria),
    CONSTRAINT uq_categorias_nombre UNIQUE(nombre)
)
ENGINE = INNODB;
--crear tabla clientes--
CREATE TABLE clientes (
    id_cliente int NOT NULL AUTO_INCREMENT,
    TIPO_DOCUMENTO varchar(3) NOT NULL default 'CC',
    NUMERO_DOCUMENTO varchar(20) NOT NULL,
    NOMBRE varchar(60) NOT NULL,
    APELLIDO varchar(60) NOT NULL,
    email varchar(100) NOT NULL,
    telefono varchar(20) NULL,
    ciudad varchar(20) NULL,
    FECHA_REGISTRO datetime NOT NULL default current_timestamp,
    CONSTRAINT pk_clientes PRIMARY KEY(id_cliente),
    CONSTRAINT uq_clientes_documento UNIQUE(NUMERO_DOCUMENTO),
    CONSTRAINT uq_clientes_email UNIQUE(email)
    --CAMPO TIPO_DOCUMENTO: CC, CE, TI
    CONSTRAINT ck_clientes_tipo_doc CHECK(TIPO_DOCUMENTO IN ('CC', 'CE', 'TI', 'PASS'))
) ENGINE = INNODB;

--crear tabla productos--
CREATE TABLE productos (
    id_producto int NOT NULL AUTO_INCREMENT,
    id_categoria int NOT NULL,
    nombre varchar(100) NOT NULL,
    precio decimal(12,2) NOT NULL,
    stock int NOT NULL default 0,
    activo boolean NOT NULL default true,
    fecha_registro datetime NOT NULL default current_timestamp,
    constraint pk_productos PRIMARY KEY(id_producto),
    constraint ck_productos_precio CHECK(precio > 0),
    constraint ck_productos_stock CHECK(stock >= 0),
    constraint fk_productos_categorias FOREIGN KEY(id_categoria) REFERENCES categorias(id_categoria)
    on delete restrict
    on update cascade
)
ENGINE = INNODB;

--crear tabla pedidos--
create table pedidos(
    id_pedido int NOT NULL AUTO_INCREMENT,
    id_cliente int NOT NULL,
    fecha_pedido datetime NOT NULL default current_timestamp,
    estado varchar(20) NOT NULL default 'pendiente',
    total varchar(60) NOT NULL default '0',
    CONSTRAINT pk_pedidos PRIMARY KEY(id_pedido),
    CONSTRAINT ck_pedidos_estado CHECK(estado IN ('pendiente', 'pagado', 'enviado', 'cancelado')),
    CONSTRAINT uq_pedidos_total CHECK(total > '0'),
    CONSTRAINT fk_pedidos_clientes FOREIGN KEY(id_cliente) REFERENCES clientes(id_cliente)
    on delete restrict
    on update cascade
)
ENGINE = INNODB;
--DETALLES DE PEDIDOS el detalle va estar relacioinado con id pedido id producto, cantidad inicia en 0 , precio unitario, 12digitos 2 decimales, precio inicia en 0, precio unico en un pedido, que no se pueda eliminar
create table detalle_pedidos(
    id_detalle int not null auto_increment,
    id_pedido int not null,
    id_producto int not null,
    cantidad int not null default 0,
    precio_unitario decimal(12,2) not null default 0,
    precio decimal(12,2) not null default 0,
    constraint pk_detalle_pedidos primary key(id_detalle),
    constraint ck_detalle_precio CHECK(precio > 0),
    constraint fk_pidos_DP foreign key(id_pedido) references pedidos(id_pedido),
    constraint fk_productos_DP foreign key(id_producto) references productos(id_producto)
    on delete restrict
    on update cascade
)
--profe respuesta
create table detalle_pedidos(
    id_detalle int not null auto_increment,
    id_pedido int not null,
    id_producto int not null,
    cantidad int not null default 0,
    precio_unitario decimal(12,2) not null default 0,
    constraint pk_detalle_pedidos primary key(id_detalle),
    constraint ck_detalle_Cantidad CHECK(cantidad > 0),
    constraint ck_detalle_precio CHECK(precio_unitario > 0),
    constraint uq_detalle_pedido_producto UNIQUE(id_pedido, id_producto),
    constraint fk_pidos_DP foreign key(id_pedido) references pedidos(id_pedido)
    on delete cascade,
    constraint fk_productos_DP foreign key(id_producto) references productos(id_producto)
    on delete restrict
)
engine = INNODB;
--crear tabla usuarios--
CREATE TABLE usuarios (
    id_usuario int NOT NULL AUTO_INCREMENT,
    id_cliente int NULL,
    nombre_usuario varchar(50),
    email varchar(100),
    password_hash char(64) NOT NULL,
    --hash encriptado de la contraseña
    salt char(32) NOT NULL,
    --salt si dos contraseñas son iguales, el hash será diferente
    rol varchar(20) NOT NULL default "cliente",
    activo boolean NOT NULL default true,
    intentos_fallidos int NOT NULL default 0,
    bloqueado boolean NOT NULL default false,
    ultimo_acceso datetime NULL,
    fecha_creacion datetime NOT NULL default current_timestamp,
    CONSTRAINT pk_usuarios PRIMARY KEY(id_usuario),
    CONSTRAINT uq_usuarios_nombre_usuario UNIQUE(nombre_usuario),
    CONSTRAINT uq_usuarios_email UNIQUE(email),
    CONSTRAINT ck_usuarios_rol CHECK(rol IN ('admin', 'vendedor', 'cliente')),
    CONSTRAINT fk_usuarios_clientes FOREIGN KEY(id_cliente) REFERENCES clientes(id_cliente)
    on delete set null
) engine = INNODB;