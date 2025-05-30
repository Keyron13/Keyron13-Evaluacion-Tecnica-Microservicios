USE [InventoryServiceDB]
GO
ALTER TABLE [dbo].[Transactions] DROP CONSTRAINT [CK__Transacti__UnitP__534D60F1]
GO
ALTER TABLE [dbo].[Transactions] DROP CONSTRAINT [CK__Transacti__Trans__5165187F]
GO
ALTER TABLE [dbo].[Transactions] DROP CONSTRAINT [CK__Transacti__Quant__52593CB8]
GO
ALTER TABLE [dbo].[Products] DROP CONSTRAINT [CK__Products__Stock__4BAC3F29]
GO
ALTER TABLE [dbo].[Products] DROP CONSTRAINT [CK__Products__Price__49C3F6B7]
GO
ALTER TABLE [dbo].[Transactions] DROP CONSTRAINT [FK__Transacti__Produ__5441852A]
GO
ALTER TABLE [dbo].[Transactions] DROP CONSTRAINT [DF__Transactio__Date__5070F446]
GO
ALTER TABLE [dbo].[Products] DROP CONSTRAINT [DF__Products__Update__4D94879B]
GO
ALTER TABLE [dbo].[Products] DROP CONSTRAINT [DF__Products__Create__4CA06362]
GO
ALTER TABLE [dbo].[Products] DROP CONSTRAINT [DF__Products__Stock__4AB81AF0]
GO
/****** Object:  Table [dbo].[Transactions]    Script Date: 20/5/2025 23:02:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Transactions]') AND type in (N'U'))
DROP TABLE [dbo].[Transactions]
GO
/****** Object:  Table [dbo].[Products]    Script Date: 20/5/2025 23:02:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Products]') AND type in (N'U'))
DROP TABLE [dbo].[Products]
GO
USE [master]
GO
/****** Object:  Database [InventoryServiceDB]    Script Date: 20/5/2025 23:02:25 ******/
DROP DATABASE [InventoryServiceDB]
GO
/****** Object:  Database [InventoryServiceDB]    Script Date: 20/5/2025 23:02:25 ******/
CREATE DATABASE [InventoryServiceDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'InventoryServiceDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\InventoryServiceDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'InventoryServiceDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\InventoryServiceDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [InventoryServiceDB] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [InventoryServiceDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [InventoryServiceDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [InventoryServiceDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [InventoryServiceDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [InventoryServiceDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [InventoryServiceDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [InventoryServiceDB] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [InventoryServiceDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [InventoryServiceDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [InventoryServiceDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [InventoryServiceDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [InventoryServiceDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [InventoryServiceDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [InventoryServiceDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [InventoryServiceDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [InventoryServiceDB] SET  ENABLE_BROKER 
GO
ALTER DATABASE [InventoryServiceDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [InventoryServiceDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [InventoryServiceDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [InventoryServiceDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [InventoryServiceDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [InventoryServiceDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [InventoryServiceDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [InventoryServiceDB] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [InventoryServiceDB] SET  MULTI_USER 
GO
ALTER DATABASE [InventoryServiceDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [InventoryServiceDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [InventoryServiceDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [InventoryServiceDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [InventoryServiceDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [InventoryServiceDB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [InventoryServiceDB] SET QUERY_STORE = ON
GO
ALTER DATABASE [InventoryServiceDB] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [InventoryServiceDB]
GO
/****** Object:  Table [dbo].[Products]    Script Date: 20/5/2025 23:02:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](500) NULL,
	[Category] [nvarchar](50) NOT NULL,
	[ImageUrl] [nvarchar](255) NULL,
	[Price] [decimal](18, 2) NOT NULL,
	[Stock] [int] NOT NULL,
	[CreatedAt] [datetime2](7) NULL,
	[UpdatedAt] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Transactions]    Script Date: 20/5/2025 23:02:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Transactions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime2](7) NOT NULL,
	[TransactionType] [nvarchar](10) NOT NULL,
	[ProductId] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[UnitPrice] [decimal](18, 2) NOT NULL,
	[TotalPrice]  AS ([UnitPrice]*[Quantity]),
	[Detail] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Products] ON 

INSERT [dbo].[Products] ([Id], [Name], [Description], [Category], [ImageUrl], [Price], [Stock], [CreatedAt], [UpdatedAt]) VALUES (14, N'Auriculares Bluetooth', N'Auriculares inalámbricos con cancelación de ruido y sonido envolvente', N'Electrónica', N'https://images.pexels.com/photos/3394663/pexels-photo-3394663.jpeg', CAST(59.99 AS Decimal(18, 2)), 120, CAST(N'2025-05-20T22:38:45.8766667' AS DateTime2), CAST(N'2025-05-20T22:38:45.8766667' AS DateTime2))
INSERT [dbo].[Products] ([Id], [Name], [Description], [Category], [ImageUrl], [Price], [Stock], [CreatedAt], [UpdatedAt]) VALUES (15, N'Smartphone Galaxy S21', N'Pantalla AMOLED de 6.2 pulgadas y triple cámara', N'Electrónica', N'https://images.pexels.com/photos/6078124/pexels-photo-6078124.jpeg', CAST(799.00 AS Decimal(18, 2)), 35, CAST(N'2025-05-20T22:38:45.8766667' AS DateTime2), CAST(N'2025-05-20T22:38:45.8766667' AS DateTime2))
INSERT [dbo].[Products] ([Id], [Name], [Description], [Category], [ImageUrl], [Price], [Stock], [CreatedAt], [UpdatedAt]) VALUES (16, N'Zapatillas Nike Air', N'Zapatillas deportivas ultraligeras para running', N'Deportes', N'https://images.pexels.com/photos/2529148/pexels-photo-2529148.jpeg', CAST(129.99 AS Decimal(18, 2)), 56, CAST(N'2025-05-20T22:38:45.8766667' AS DateTime2), CAST(N'2025-05-20T22:38:45.8766667' AS DateTime2))
INSERT [dbo].[Products] ([Id], [Name], [Description], [Category], [ImageUrl], [Price], [Stock], [CreatedAt], [UpdatedAt]) VALUES (17, N'Mochila Escolar', N'Mochila resistente con diseño ergonómico', N'Accesorios', N'https://ih1.redbubble.net/image.2656105211.3374/ur,backpack_front,square,600x600.jpg', CAST(34.50 AS Decimal(18, 2)), 80, CAST(N'2025-05-20T22:38:45.8766667' AS DateTime2), CAST(N'2025-05-20T22:38:45.8766667' AS DateTime2))
INSERT [dbo].[Products] ([Id], [Name], [Description], [Category], [ImageUrl], [Price], [Stock], [CreatedAt], [UpdatedAt]) VALUES (18, N'Reloj Inteligente', N'Monitoreo de salud, oxígeno y GPS integrado', N'Tecnología', N'https://images.pexels.com/photos/5081928/pexels-photo-5081928.jpeg', CAST(199.99 AS Decimal(18, 2)), 59, CAST(N'2025-05-20T22:38:45.8766667' AS DateTime2), CAST(N'2025-05-20T22:38:45.8766667' AS DateTime2))
INSERT [dbo].[Products] ([Id], [Name], [Description], [Category], [ImageUrl], [Price], [Stock], [CreatedAt], [UpdatedAt]) VALUES (19, N'Teclado Mecánico', N'Teclado gamer retroiluminado RGB', N'Computación', N'https://images.pexels.com/photos/4792730/pexels-photo-4792730.jpeg', CAST(89.99 AS Decimal(18, 2)), 40, CAST(N'2025-05-20T22:38:45.8766667' AS DateTime2), CAST(N'2025-05-20T22:38:45.8766667' AS DateTime2))
INSERT [dbo].[Products] ([Id], [Name], [Description], [Category], [ImageUrl], [Price], [Stock], [CreatedAt], [UpdatedAt]) VALUES (20, N'Silla Gamer', N'Silla ergonómica reclinable con soporte lumbar', N'Muebles', N'https://lavictoria.ec/wp-content/uploads/2023/03/SILLA-GAMER-GC932-HAVIT-2.jpg', CAST(249.99 AS Decimal(18, 2)), 13, CAST(N'2025-05-20T22:38:45.8766667' AS DateTime2), CAST(N'2025-05-20T22:38:45.8766667' AS DateTime2))
INSERT [dbo].[Products] ([Id], [Name], [Description], [Category], [ImageUrl], [Price], [Stock], [CreatedAt], [UpdatedAt]) VALUES (21, N'Cámara Canon EOS', N'Cámara réflex con lente intercambiable 18-55mm', N'Fotografía', N'https://tiendafotograficaecuador.com.ec/wp-content/uploads/2024/11/Canon-EOS-T7-con-lente-18-55mm-1.jpg', CAST(499.00 AS Decimal(18, 2)), 28, CAST(N'2025-05-20T22:38:45.8766667' AS DateTime2), CAST(N'2025-05-20T22:38:45.8766667' AS DateTime2))
INSERT [dbo].[Products] ([Id], [Name], [Description], [Category], [ImageUrl], [Price], [Stock], [CreatedAt], [UpdatedAt]) VALUES (22, N'Bicicleta de Montaña', N'Marco de aluminio, suspensión doble', N'Deportes', N'https://images.pexels.com/photos/276517/pexels-photo-276517.jpeg', CAST(699.90 AS Decimal(18, 2)), 10, CAST(N'2025-05-20T22:38:45.8766667' AS DateTime2), CAST(N'2025-05-20T22:38:45.8766667' AS DateTime2))
INSERT [dbo].[Products] ([Id], [Name], [Description], [Category], [ImageUrl], [Price], [Stock], [CreatedAt], [UpdatedAt]) VALUES (23, N'Guitarra Acústica', N'Guitarra con cuerpo de abeto y cuerdas de nylon', N'Música', N'https://images.pexels.com/photos/164743/pexels-photo-164743.jpeg', CAST(149.99 AS Decimal(18, 2)), 21, CAST(N'2025-05-20T22:38:45.8766667' AS DateTime2), CAST(N'2025-05-20T22:38:45.8766667' AS DateTime2))
INSERT [dbo].[Products] ([Id], [Name], [Description], [Category], [ImageUrl], [Price], [Stock], [CreatedAt], [UpdatedAt]) VALUES (24, N'Impresora HP', N'Multifunción inalámbrica con impresión a color', N'Computación', N'https://images.pexels.com/photos/4114786/pexels-photo-4114786.jpeg', CAST(129.00 AS Decimal(18, 2)), 37, CAST(N'2025-05-20T22:38:45.8766667' AS DateTime2), CAST(N'2025-05-20T22:38:45.8766667' AS DateTime2))
INSERT [dbo].[Products] ([Id], [Name], [Description], [Category], [ImageUrl], [Price], [Stock], [CreatedAt], [UpdatedAt]) VALUES (25, N'Mouse Gamer', N'Mouse óptico 6400 DPI con luces LED', N'Computación', N'https://images.pexels.com/photos/4792721/pexels-photo-4792721.jpeg', CAST(39.99 AS Decimal(18, 2)), 90, CAST(N'2025-05-20T22:38:45.8766667' AS DateTime2), CAST(N'2025-05-20T22:38:45.8766667' AS DateTime2))
INSERT [dbo].[Products] ([Id], [Name], [Description], [Category], [ImageUrl], [Price], [Stock], [CreatedAt], [UpdatedAt]) VALUES (26, N'Libro: El Principito', N'Edición especial con ilustraciones a color', N'Libros', N'https://images.cdn3.buscalibre.com/fit-in/360x360/dd/80/dd80e5c9a9ca4f49f887cde556408253.jpg', CAST(19.99 AS Decimal(18, 2)), 170, CAST(N'2025-05-20T22:38:45.8766667' AS DateTime2), CAST(N'2025-05-20T22:38:45.8766667' AS DateTime2))
INSERT [dbo].[Products] ([Id], [Name], [Description], [Category], [ImageUrl], [Price], [Stock], [CreatedAt], [UpdatedAt]) VALUES (27, N'Monitor 24" Full HD', N'Resolución 1920x1080 con entradas HDMI y VGA', N'Electrónica', N'https://images.pexels.com/photos/374074/pexels-photo-374074.jpeg', CAST(149.50 AS Decimal(18, 2)), 29, CAST(N'2025-05-20T22:38:45.8766667' AS DateTime2), CAST(N'2025-05-20T22:38:45.8766667' AS DateTime2))
INSERT [dbo].[Products] ([Id], [Name], [Description], [Category], [ImageUrl], [Price], [Stock], [CreatedAt], [UpdatedAt]) VALUES (28, N'Cafetera de Goteo', N'Cafetera automática con temporizador digital', N'Electrodomésticos', N'https://images.pexels.com/photos/302902/pexels-photo-302902.jpeg', CAST(89.00 AS Decimal(18, 2)), 18, CAST(N'2025-05-20T22:38:45.8766667' AS DateTime2), CAST(N'2025-05-20T22:38:45.8766667' AS DateTime2))
INSERT [dbo].[Products] ([Id], [Name], [Description], [Category], [ImageUrl], [Price], [Stock], [CreatedAt], [UpdatedAt]) VALUES (29, N'Lámpara de Escritorio', N'Lámpara LED con brazo ajustable y USB', N'Iluminación', N'https://images.pexels.com/photos/5591667/pexels-photo-5591667.jpeg', CAST(24.75 AS Decimal(18, 2)), 75, CAST(N'2025-05-20T22:38:45.8766667' AS DateTime2), CAST(N'2025-05-20T22:38:45.8766667' AS DateTime2))
INSERT [dbo].[Products] ([Id], [Name], [Description], [Category], [ImageUrl], [Price], [Stock], [CreatedAt], [UpdatedAt]) VALUES (30, N'Sudadera Adidas', N'Sudadera con capucha y ajuste entallado', N'Ropa', N'https://images.pexels.com/photos/7679725/pexels-photo-7679725.jpeg', CAST(49.99 AS Decimal(18, 2)), 70, CAST(N'2025-05-20T22:38:45.8766667' AS DateTime2), CAST(N'2025-05-20T22:38:45.8766667' AS DateTime2))
INSERT [dbo].[Products] ([Id], [Name], [Description], [Category], [ImageUrl], [Price], [Stock], [CreatedAt], [UpdatedAt]) VALUES (31, N'Plancha de Vapor', N'Vaporizador vertical con autoapagado', N'Electrodomésticos', N'https://images.pexels.com/photos/4042806/pexels-photo-4042806.jpeg', CAST(59.99 AS Decimal(18, 2)), 27, CAST(N'2025-05-20T22:38:45.8766667' AS DateTime2), CAST(N'2025-05-20T22:38:45.8766667' AS DateTime2))
INSERT [dbo].[Products] ([Id], [Name], [Description], [Category], [ImageUrl], [Price], [Stock], [CreatedAt], [UpdatedAt]) VALUES (32, N'Parlante JBL Go 3', N'Altavoz resistente al agua y portátil', N'Audio', N'https://ec.tiendasishop.com/wp-content/uploads/2022/03/JBL_GO_3_HERO_BLUE_0077_1605x1605px.png', CAST(79.90 AS Decimal(18, 2)), 45, CAST(N'2025-05-20T22:38:45.8766667' AS DateTime2), CAST(N'2025-05-20T22:38:45.8766667' AS DateTime2))
INSERT [dbo].[Products] ([Id], [Name], [Description], [Category], [ImageUrl], [Price], [Stock], [CreatedAt], [UpdatedAt]) VALUES (33, N'Tablet Android 10"', N'Pantalla HD, batería de larga duración', N'Tecnología', N'https://images.pexels.com/photos/5082567/pexels-photo-5082567.jpeg', CAST(199.00 AS Decimal(18, 2)), 32, CAST(N'2025-05-20T22:38:45.8766667' AS DateTime2), CAST(N'2025-05-20T22:38:45.8766667' AS DateTime2))
SET IDENTITY_INSERT [dbo].[Products] OFF
GO
SET IDENTITY_INSERT [dbo].[Transactions] ON 

INSERT [dbo].[Transactions] ([Id], [Date], [TransactionType], [ProductId], [Quantity], [UnitPrice], [Detail]) VALUES (19, CAST(N'2025-05-21T03:48:08.5086833' AS DateTime2), N'venta', 20, 2, CAST(249.99 AS Decimal(18, 2)), N'Venta de silla gamers')
INSERT [dbo].[Transactions] ([Id], [Date], [TransactionType], [ProductId], [Quantity], [UnitPrice], [Detail]) VALUES (20, CAST(N'2025-05-21T03:49:35.7907581' AS DateTime2), N'compra', 24, 2, CAST(129.00 AS Decimal(18, 2)), N'Se compro Impresora')
INSERT [dbo].[Transactions] ([Id], [Date], [TransactionType], [ProductId], [Quantity], [UnitPrice], [Detail]) VALUES (21, CAST(N'2025-05-21T03:50:15.3775598' AS DateTime2), N'compra', 21, 3, CAST(499.00 AS Decimal(18, 2)), N'Se compro camaras')
INSERT [dbo].[Transactions] ([Id], [Date], [TransactionType], [ProductId], [Quantity], [UnitPrice], [Detail]) VALUES (22, CAST(N'2025-05-21T03:51:09.9289357' AS DateTime2), N'venta', 23, 1, CAST(149.99 AS Decimal(18, 2)), N'Se vendió una guitarra')
INSERT [dbo].[Transactions] ([Id], [Date], [TransactionType], [ProductId], [Quantity], [UnitPrice], [Detail]) VALUES (23, CAST(N'2025-05-21T03:52:10.7006462' AS DateTime2), N'venta', 18, 4, CAST(199.99 AS Decimal(18, 2)), N'Se vendió relojes')
INSERT [dbo].[Transactions] ([Id], [Date], [TransactionType], [ProductId], [Quantity], [UnitPrice], [Detail]) VALUES (24, CAST(N'2025-05-21T03:52:43.6797504' AS DateTime2), N'compra', 16, 6, CAST(129.99 AS Decimal(18, 2)), N'Se compraron zapatillas')
INSERT [dbo].[Transactions] ([Id], [Date], [TransactionType], [ProductId], [Quantity], [UnitPrice], [Detail]) VALUES (25, CAST(N'2025-05-21T03:53:32.8486157' AS DateTime2), N'venta', 26, 30, CAST(19.99 AS Decimal(18, 2)), N'S vendió a una biblioteca')
INSERT [dbo].[Transactions] ([Id], [Date], [TransactionType], [ProductId], [Quantity], [UnitPrice], [Detail]) VALUES (26, CAST(N'2025-05-21T03:54:16.2059545' AS DateTime2), N'venta', 27, 1, CAST(149.50 AS Decimal(18, 2)), N'Se vendió un televisor')
INSERT [dbo].[Transactions] ([Id], [Date], [TransactionType], [ProductId], [Quantity], [UnitPrice], [Detail]) VALUES (27, CAST(N'2025-05-21T03:54:57.0846064' AS DateTime2), N'compra', 30, 5, CAST(49.99 AS Decimal(18, 2)), N'Se compro sudadera')
INSERT [dbo].[Transactions] ([Id], [Date], [TransactionType], [ProductId], [Quantity], [UnitPrice], [Detail]) VALUES (28, CAST(N'2025-05-21T03:55:52.4190997' AS DateTime2), N'compra', 18, 3, CAST(199.99 AS Decimal(18, 2)), N'Se compro relojes')
SET IDENTITY_INSERT [dbo].[Transactions] OFF
GO
ALTER TABLE [dbo].[Products] ADD  DEFAULT ((0)) FOR [Stock]
GO
ALTER TABLE [dbo].[Products] ADD  DEFAULT (getutcdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Products] ADD  DEFAULT (getutcdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[Transactions] ADD  DEFAULT (getutcdate()) FOR [Date]
GO
ALTER TABLE [dbo].[Transactions]  WITH CHECK ADD FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([Id])
GO
ALTER TABLE [dbo].[Products]  WITH CHECK ADD CHECK  (([Price]>(0)))
GO
ALTER TABLE [dbo].[Products]  WITH CHECK ADD CHECK  (([Stock]>=(0)))
GO
ALTER TABLE [dbo].[Transactions]  WITH CHECK ADD CHECK  (([Quantity]>(0)))
GO
ALTER TABLE [dbo].[Transactions]  WITH CHECK ADD CHECK  (([TransactionType]='venta' OR [TransactionType]='compra'))
GO
ALTER TABLE [dbo].[Transactions]  WITH CHECK ADD CHECK  (([UnitPrice]>(0)))
GO
USE [master]
GO
ALTER DATABASE [InventoryServiceDB] SET  READ_WRITE 
GO
