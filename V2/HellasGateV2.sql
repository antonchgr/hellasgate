USE master;
GO

DECLARE @mdf NVARCHAR(1024) 
,		@ndf1 NVARCHAR(1024)
,		@ndf2 NVARCHAR(1024)
,		@ldf NVARCHAR(1024)
,		@createddl NVARCHAR(1024);

SELECT	@mdf  = CONCAT(CAST(SERVERPROPERTY('InstanceDefaultDataPath') AS NVARCHAR(512)),N'HellasGateV2_sdata.mdf')
,		@ndf1 = CONCAT(CAST(SERVERPROPERTY('InstanceDefaultDataPath') AS NVARCHAR(512)),N'HellasGateV2_data1.ndf')
,		@ndf2 = CONCAT(CAST(SERVERPROPERTY('InstanceDefaultDataPath') AS NVARCHAR(512)),N'HellasGateV2_data2.ndf')
,		@ldf  = CONCAT(CAST(SERVERPROPERTY('InstanceDefaultLogPath') AS NVARCHAR(512)),N'HellasGateV2_log.ldf');

-- Drop database
IF DB_ID(N'HellasGateV2') IS NOT NULL 
BEGIN
	EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'HellasGateV2';
	ALTER DATABASE [HellasGateV2] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [HellasGateV2]
END
-- If database could not be created due to open connections, abort
IF @@ERROR = 3702 
   RAISERROR(N'Database cannot be dropped because there are still open connections.', 127, 127) WITH NOWAIT, LOG;


-- create databases
SET @createddl = 'CREATE DATABASE HellasGateV2 CONTAINMENT = NONE ON  PRIMARY 
				  ( 
					NAME = N''HellasGateV2_sys'', 
					FILENAME = ' + quotename(@mdf,'''') +',' +  
				'	SIZE = 65536KB , 
					MAXSIZE = UNLIMITED, 
					FILEGROWTH = 65536KB 
				  ), 
				  FILEGROUP [SECONDARY]  DEFAULT
				  ( 
					NAME = N''HellasGateV2_data1'', 
					FILENAME = ' + quotename(@ndf1,'''') +',' +  
				'   SIZE = 65536KB , 
					MAXSIZE = UNLIMITED, 
					FILEGROWTH = 65536KB 
				  ),
				  ( 
					NAME = N''HellasGateV2_data2'', 
					FILENAME = ' + quotename(@ndf2,'''') +',' +   
				'   SIZE = 65536KB , 
					MAXSIZE = UNLIMITED, 
					FILEGROWTH = 65536KB 
				  )
				  LOG ON 
				  ( 
					NAME = N''HellasGateV2_log'', 
					FILENAME = ' + quotename(@ldf,'''') +',' +   
				'   SIZE = 65536KB , 
					MAXSIZE = 2048GB , 
					FILEGROWTH = 65536KB 
				  )
				  WITH CATALOG_COLLATION = DATABASE_DEFAULT;';

				  
EXEC (@createddl);
GO

IF DB_ID(N'HellasGateV2') IS NOT NULL  
BEGIN
	ALTER DATABASE [HellasGateV2] MODIFY FILEGROUP [SECONDARY] AUTOGROW_ALL_FILES;
	IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
	begin
		EXEC [HellasGateV2].[dbo].[sp_fulltext_database] @action = 'enable'
	end
	ALTER DATABASE [HellasGateV2] SET ANSI_NULL_DEFAULT OFF ;
	ALTER DATABASE [HellasGateV2] SET ANSI_NULLS OFF ;
	ALTER DATABASE [HellasGateV2] SET ANSI_PADDING OFF ;
	ALTER DATABASE [HellasGateV2] SET ANSI_WARNINGS OFF ;
	ALTER DATABASE [HellasGateV2] SET ARITHABORT OFF ;
	ALTER DATABASE [HellasGateV2] SET AUTO_CLOSE OFF ;
	ALTER DATABASE [HellasGateV2] SET AUTO_SHRINK OFF ;
	ALTER DATABASE [HellasGateV2] SET AUTO_UPDATE_STATISTICS ON ;
	ALTER DATABASE [HellasGateV2] SET CURSOR_CLOSE_ON_COMMIT OFF ;
	ALTER DATABASE [HellasGateV2] SET CURSOR_DEFAULT  GLOBAL ;
	ALTER DATABASE [HellasGateV2] SET CONCAT_NULL_YIELDS_NULL OFF ;
	ALTER DATABASE [HellasGateV2] SET NUMERIC_ROUNDABORT OFF ;
	ALTER DATABASE [HellasGateV2] SET QUOTED_IDENTIFIER OFF ;
	ALTER DATABASE [HellasGateV2] SET RECURSIVE_TRIGGERS OFF ;
	ALTER DATABASE [HellasGateV2] SET  DISABLE_BROKER ;
	ALTER DATABASE [HellasGateV2] SET AUTO_UPDATE_STATISTICS_ASYNC OFF ;
	ALTER DATABASE [HellasGateV2] SET DATE_CORRELATION_OPTIMIZATION OFF ;
	ALTER DATABASE [HellasGateV2] SET TRUSTWORTHY OFF ;
	ALTER DATABASE [HellasGateV2] SET ALLOW_SNAPSHOT_ISOLATION OFF ;
	ALTER DATABASE [HellasGateV2] SET PARAMETERIZATION SIMPLE ;
	ALTER DATABASE [HellasGateV2] SET READ_COMMITTED_SNAPSHOT OFF ;
	ALTER DATABASE [HellasGateV2] SET HONOR_BROKER_PRIORITY OFF ;
	ALTER DATABASE [HellasGateV2] SET RECOVERY FULL ;
	ALTER DATABASE [HellasGateV2] SET  MULTI_USER ;
	ALTER DATABASE [HellasGateV2] SET PAGE_VERIFY CHECKSUM  ;
	ALTER DATABASE [HellasGateV2] SET DB_CHAINING OFF ;
	ALTER DATABASE [HellasGateV2] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) ;
	ALTER DATABASE [HellasGateV2] SET TARGET_RECOVERY_TIME = 60 SECONDS ;
	ALTER DATABASE [HellasGateV2] SET DELAYED_DURABILITY = DISABLED ;
	ALTER DATABASE [HellasGateV2] SET ACCELERATED_DATABASE_RECOVERY = OFF  ;
	ALTER DATABASE [HellasGateV2] SET QUERY_STORE = ON;
	ALTER DATABASE [HellasGateV2] SET QUERY_STORE 
	(
		OPERATION_MODE = READ_WRITE, 
		CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), 
		DATA_FLUSH_INTERVAL_SECONDS = 900, 
		INTERVAL_LENGTH_MINUTES = 60, 
		MAX_STORAGE_SIZE_MB = 1000, 
		QUERY_CAPTURE_MODE = AUTO, 
		SIZE_BASED_CLEANUP_MODE = AUTO, 
		MAX_PLANS_PER_QUERY = 200, 
		WAIT_STATS_CAPTURE_MODE = ON
	);
	ALTER DATABASE [HellasGateV2] SET  READ_WRITE ;
END

USE [HellasGateV2]
GO

CREATE SCHEMA [bi];
GO
CREATE SCHEMA [dfi];
GO
CREATE SCHEMA [hr];
GO
CREATE SCHEMA [info];
GO
CREATE SCHEMA [products];
GO
CREATE SCHEMA [sales];
GO

CREATE SEQUENCE [sales].[InvoiceLineID] 
 AS [int]
 START WITH 1
 INCREMENT BY 1
 MINVALUE -2147483648
 MAXVALUE 2147483647
 CACHE 
GO

CREATE SEQUENCE [sales].[InvoiceID] 
 AS [int]
 START WITH 10000
 INCREMENT BY 1
 MINVALUE -2147483648
 MAXVALUE 2147483647
 CACHE 
GO


CREATE TABLE [dfi].[Cities](
	[aa] int identity not NULL PRIMARY KEY ,
	[City] [nvarchar](50) NOT NULL,
	[Perfecture] [nvarchar](50) NOT NULL,
	[Region] [nvarchar](50) NOT NULL,
	[PostCode] [nchar](5) NULL
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'microsoft_database_tools_support', @value=N'Hide' , @level0type=N'SCHEMA',@level0name=N'dfi', @level1type=N'TABLE',@level1name=N'Cities'
GO


CREATE TABLE [dfi].[GreekNames](
	[aa] INT identity NOT NULL PRIMARY KEY,
	[lastname] [nvarchar](50) NOT NULL,
	[firstname] [nvarchar](50) NOT NULL,
	[gender] nchar(1) not null
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'microsoft_database_tools_support', @value=N'Hide' , @level0type=N'SCHEMA',@level0name=N'dfi', @level1type=N'TABLE',@level1name=N'GreekNames'
GO


CREATE TABLE [dfi].[Streets](
	[aa] INT identity NOT NULL PRIMARY KEY,
	[street] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'microsoft_database_tools_support', @value=N'Hide' , @level0type=N'SCHEMA',@level0name=N'dfi', @level1type=N'TABLE',@level1name=N'Streets'
GO

CREATE TABLE [bi].[DimCalendar](
	[DateKey] [int] NOT NULL,
	[DateValue] [date] NOT NULL,
	[MonthNameNational] [nvarchar](15) NOT NULL,
	[DayNameNational] [nvarchar](15) NOT NULL,
	[MonthNameLocal] [nvarchar](15) NOT NULL,
	[DayNameLocal] [nvarchar](15) NOT NULL,
	[IsWeekend] [bit] NOT NULL,
	[IsLeapYear] [bit] NOT NULL,
	[CYYear] [int] NOT NULL,
	[CYYearName] [nvarchar](15) NOT NULL,
	[CYSemester] [int] NOT NULL,
	[CYSemesterName] [nvarchar](15) NOT NULL,
	[CYQuarter] [int] NOT NULL,
	[CYQuarterName] [nvarchar](15) NOT NULL,
	[CYSemesterQuarter] [int] NOT NULL,
	[CYMonth] [int] NOT NULL,
	[CYMonthName] [nvarchar](15) NOT NULL,
	[CYSemesterMonth] [int] NOT NULL,
	[CYQuarterMonth] [int] NOT NULL,
	[CYWeek] [int] NOT NULL,
	[CYWeekName] [nvarchar](15) NOT NULL,
	[CYSemesterWeek] [int] NOT NULL,
	[CYQuarterWeek] [int] NOT NULL,
	[CYMonthWeek] [int] NOT NULL,
	[CYDay] [int] NOT NULL,
	[CYSemesterDay] [int] NOT NULL,
	[CYQuarterDay] [int] NOT NULL,
	[CYMonthDay] [int] NOT NULL,
	[CYWeekDay] [int] NOT NULL,
	[CYFirstDate] [date] NOT NULL,
	[CYLastDate] [date] NOT NULL,
	[FYYear] [int] NOT NULL,
	[FYYearName] [nvarchar](15) NOT NULL,
	[FYSemester] [int] NOT NULL,
	[FYSemesterName] [nvarchar](15) NOT NULL,
	[FYQuarter] [int] NOT NULL,
	[FYSemesterQuarter] [int] NOT NULL,
	[FYMonth] [int] NOT NULL,
	[FYMonthName] [nvarchar](15) NOT NULL,
	[FYSemesterMonth] [int] NOT NULL,
	[FYQuarterMonth] [int] NOT NULL,
	[FYWeek] [int] NOT NULL,
	[FYWeekName] [nvarchar](15) NOT NULL,
	[FYSemesterWeek] [int] NOT NULL,
	[FYQuarterWeek] [int] NOT NULL,
	[FYMonthWeek] [int] NOT NULL,
	[FYDay] [int] NOT NULL,
	[FYSemesterDay] [int] NOT NULL,
	[FYQuarterDay] [int] NOT NULL,
	[FYMonthDay] [int] NOT NULL,
	[FYWeekDay] [int] NOT NULL,
	[FYFirstDate] [date] NOT NULL,
	[FYLastDate] [date] NOT NULL,
	[ISOYear] [int] NOT NULL,
	[ISOYearName] [nvarchar](15) NOT NULL,
	[ISOSemester] [int] NOT NULL,
	[ISOSemesterName] [nvarchar](15) NOT NULL,
	[ISOQuarter] [int] NOT NULL,
	[ISOQuarterName] [nvarchar](15) NOT NULL,
	[ISOSemesterQuarter] [int] NOT NULL,
	[ISOMonth] [int] NOT NULL,
	[ISOMonthName] [nvarchar](15) NOT NULL,
	[ISOSemesterMonth] [int] NOT NULL,
	[ISOQuarterMonth] [int] NOT NULL,
	[ISOWeek] [int] NOT NULL,
	[ISOWeekName] [nvarchar](15) NOT NULL,
	[ISOSemesterWeek] [int] NOT NULL,
	[ISOQuarterWeek] [int] NOT NULL,
	[ISOMonthWeek] [int] NOT NULL,
	[ISODay] [int] NOT NULL,
	[ISOSemesterDay] [int] NOT NULL,
	[ISOQuarterDay] [int] NOT NULL,
	[ISOMonthDay] [int] NOT NULL,
	[ISOWeekDay] [int] NOT NULL,
	[ISODayName] [nvarchar](15) NOT NULL,
	[ISOFirstDate] [date] NOT NULL,
	[ISOLastDate] [date] NOT NULL,
	[IsNationalHoliday] [bit] NOT NULL,
	[IsLocalHoliday] [bit] NOT NULL,
	[HolidayName] [nvarchar](100) NULL,
 CONSTRAINT [PK_DimCalendar] PRIMARY KEY CLUSTERED 
(
	[DateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [SECONDARY]
) ON [SECONDARY]
GO

CREATE   VIEW [bi].[DimCalendarView]
AS
SELECT [DateKey]
      ,[DateValue]
      ,[MonthNameNational]          AS  [English Month Name]
      ,[DayNameNational]            AS  [English Day Name]
      ,[MonthNameLocal]             AS  [Greek Month Name]
      ,[DayNameLocal]               AS  [Greek Day Name]
      ,[IsWeekend]                  AS  [Is Weekend Day]
      ,[IsLeapYear]                 AS  [Is Leap Year]
      ,[CYYear]                     AS  [Calendar Year]
      ,[CYYearName]                 AS  [Calendar Year Name]
      ,[CYSemester]                 AS  [Calendar Year Semester]
      ,[CYSemesterName]             AS  [Calendar Year Semester Name]
      ,[CYQuarter]                  AS  [Calendar Year Quarter]
      ,[CYQuarterName]              AS  [Calendar Year Quarter Name]
      ,[CYSemesterQuarter]          AS  [Calendar Year Semester Quarter]
      ,[CYMonth]                    AS  [Calendar Year Month]
      ,[CYMonthName]                AS  [Calendar Year Month Name]
      ,[CYSemesterMonth]            AS  [Calendar Year Semester Month]
      ,[CYQuarterMonth]             AS  [Calendar Year Quarter Month]
      ,[CYWeek]                     AS  [Calendar Year Week]
      ,[CYWeekName]                 AS  [Calendar Year Week Name]
      ,[CYSemesterWeek]             AS  [Calendar Year Semester Week]
      ,[CYQuarterWeek]              AS  [Calendar Year Quarter Week]
      ,[CYMonthWeek]                AS  [Calendar Year Month Week]
      ,[CYDay]                      AS  [Calendar Year Day Number]
      ,[CYSemesterDay]              AS  [Calendar Year Semester Day Number]
      ,[CYQuarterDay]               AS  [Calendar Year Quarter Day Number]
      ,[CYMonthDay]                 AS  [Calendar Year Month Day Number]
      ,[CYWeekDay]                  AS  [Calendar Year Week Day Number]
      ,[CYFirstDate]                AS  [Calendar Year First Date]
      ,[CYLastDate]                 AS  [Calendar Year Last Date]
      ,[FYYear]                     AS  [Fiscal Year]
      ,[FYYearName]                 AS  [Fiscal Year Name]
      ,[FYSemester]                 AS  [Fiscal Year Semester]
      ,[FYSemesterName]             AS  [Fiscal Year Semester Name]
      ,[FYQuarter]                  AS  [Fiscal Year Quarter]
      ,[FYSemesterQuarter]          AS  [Fiscal Year Quarter Name]
      ,[FYMonth]                    AS  [Fiscal Year Month]
      ,[FYMonthName]                AS  [Fiscal Year Month Name] 
      ,[FYSemesterMonth]            AS  [Fiscal Year Semester Month]
      ,[FYQuarterMonth]             AS  [Fiscal Year Quarter Month]
      ,[FYWeek]                     AS  [Fiscal Year Week]
      ,[FYWeekName]                 AS  [Fiscal Year Week Name]
      ,[FYSemesterWeek]             AS  [Fiscal Year Semester Week]
      ,[FYQuarterWeek]              AS  [Fiscal Year Quarter Week]
      ,[FYMonthWeek]                AS  [Fiscal Year Month Week]
      ,[FYDay]                      AS  [Fiscal Year Day Number]
      ,[FYSemesterDay]              AS  [Fiscal Year Semester Day Number]
      ,[FYQuarterDay]               AS  [Fiscal Year Quarter Day Number]
      ,[FYMonthDay]                 AS  [Fiscal Year Month Day Number]
      ,[FYWeekDay]                  AS  [Fiscal Year Week Day Number]
      ,[FYFirstDate]                AS  [Fiscal Year First Date]
      ,[FYLastDate]                 AS  [Fiscal Year Last Date]
      ,[ISOYear]                    AS  [ISO Year]
      ,[ISOYearName]                AS  [ISO Year Name]
      ,[ISOSemester]                AS  [ISO Year Semester]
      ,[ISOSemesterName]            AS  [ISO Year Semester Name]
      ,[ISOQuarter]                 AS  [ISO Year Quarter]
      ,[ISOQuarterName]             AS  [ISO Year Quarter Name]
      ,[ISOSemesterQuarter]         AS  [ISO Year Semester Quarter]
      ,[ISOMonth]                   AS  [ISO Year Month]
      ,[ISOMonthName]               AS  [ISO Year Month Name]
      ,[ISOSemesterMonth]           AS  [ISO Year Semester Month]
      ,[ISOQuarterMonth]            AS  [ISO Year Quarter Month]
      ,[ISOWeek]                    AS  [ISO Year Week]
      ,[ISOWeekName]                AS  [ISO Year Week Name]
      ,[ISOSemesterWeek]            AS  [ISO Year Semester Week]
      ,[ISOQuarterWeek]             AS  [ISO Year Quarter Week]
      ,[ISOMonthWeek]               AS  [ISO Year Month Week]
      ,[ISODay]                     AS  [ISO Year Day Number]
      ,[ISOSemesterDay]             AS  [ISO Year Semester Day Number]
      ,[ISOQuarterDay]              AS  [ISO Year Quarter Day Number]
      ,[ISOMonthDay]                AS  [ISO Year Month Day Number]
      ,[ISOWeekDay]                 AS  [ISO Year Week Day Number]
      ,[ISODayName]                 AS  [ISO Year Day Name]
      ,[ISOFirstDate]               AS  [ISO Year First Date]
      ,[ISOLastDate]                AS  [ISO Year Last Date]
      ,[IsNationalHoliday]          AS  [Is National Holiday]
      ,[IsLocalHoliday]             AS  [Is Greek Holiday]
      ,[HolidayName]                AS  [Holiday Name]
  FROM bi.[DimCalendar]
GO

CREATE TABLE [hr].[Employees](
	[empid] [int] IDENTITY(1,1) NOT NULL,
	[lastname] [nvarchar](50) NOT NULL,
	[firstname] [nvarchar](20) NOT NULL,
	[title] [nvarchar](30) NOT NULL,
	[isSalesperson] [bit] NOT NULL,
	[birthdate] [date] NOT NULL,
	[hiredate] [date] NOT NULL,
	[address] [nvarchar](80) NOT NULL,
	[city] [nvarchar](30) NOT NULL,
	[region] [nvarchar](50) NULL,
	[postalcode] [int] NULL,
	[country] [nvarchar](15) NOT NULL,
	[phone] [nvarchar](16) NOT NULL,
	[mgrid] [int] NULL,
	[salary] [money] NULL,
	[email] [nvarchar](256) NULL,
 CONSTRAINT [PK_Employees] PRIMARY KEY CLUSTERED 
(
	[empid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [SECONDARY]
) ON [SECONDARY]
GO

CREATE TABLE [products].[Categories](
	[categoryid] [int] IDENTITY(1,1) NOT NULL,
	[categoryname] [nvarchar](50) NOT NULL,
	[description] [nvarchar](200) NULL,
 CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED 
(
	[categoryid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [SECONDARY]
) ON [SECONDARY]
GO

CREATE TABLE [products].[Products](
	[productid] [int] IDENTITY(1,1) NOT NULL,
	[productname] [nvarchar](100) NOT NULL,
	[supplierid] [int] NOT NULL,
	[subcategoryid] [int] NOT NULL,
	[unitprice] [money] NOT NULL,
	[isOutOfOrder] [bit] NOT NULL,
 CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED 
(
	[productid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [SECONDARY]
) ON [SECONDARY]
GO

CREATE TABLE [products].[SubCategories](
	[subcategoryid] [int] IDENTITY(1,1) NOT NULL,
	[subcategoryname] [nvarchar](50) NOT NULL,
	[categoryid] [int] NOT NULL,
	[description] [nvarchar](200) NULL,
 CONSTRAINT [PK_SubCategories] PRIMARY KEY CLUSTERED 
(
	[subcategoryid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [SECONDARY]
) ON [SECONDARY]
GO

CREATE TABLE [products].[Suppliers](
	[supplierid] [int] IDENTITY(1,1) NOT NULL,
	[companyname] [nvarchar](40) NOT NULL,
	[contactname] [nvarchar](30) NOT NULL,
	[contacttitle] [nvarchar](30) NOT NULL,
	[vatnumber] [nvarchar](10) NOT NULL,
	[address] [nvarchar](80) NOT NULL,
	[city] [nvarchar](30) NOT NULL,
	[postalcode] [int] NULL,
	[region] [nvarchar](50) NULL,
	[perfecture] [nvarchar](50) NULL,
	[country] [nvarchar](15) NOT NULL,
	[phone] [nvarchar](16) NOT NULL,
	[email] [nvarchar](256) NULL,
 CONSTRAINT [PK_Suppliers] PRIMARY KEY CLUSTERED 
(
	[supplierid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [SECONDARY]
) ON [SECONDARY]
GO

CREATE TABLE [sales].[Customers](
	[custid] [int] IDENTITY(1,1) NOT NULL,
	[companyname] [nvarchar](40) NOT NULL,
	[contactname] [nvarchar](30) NOT NULL,
	[contacttitle] [nvarchar](30) NOT NULL,
	[vatnumber] [nvarchar](10) NOT NULL,
	[address] [nvarchar](80) NOT NULL,
	[city] [nvarchar](30) NOT NULL,
	[postalcode] [int] NULL,
	[region] [nvarchar](50) NULL,
	[perfecture] [nvarchar](50) NULL,
	[country] [nvarchar](15) NOT NULL,
	[phone] [nvarchar](16) NOT NULL,
	[email] [nvarchar](256) NULL,
 CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED 
(
	[custid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [SECONDARY]
) ON [SECONDARY]
GO

CREATE TABLE [sales].[InvoiceHeader](
	[invoiceid] [int] NOT NULL,
	[orderid] [int] NOT NULL,
	[custid] [int] NOT NULL,
	[invoicedate] [date] NOT NULL,
 CONSTRAINT [PK_InvoiceHeader] PRIMARY KEY CLUSTERED 
(
	[invoiceid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [SECONDARY]
) ON [SECONDARY]
GO

CREATE TABLE [sales].[InvoiceLines](
	[invoicelineid] [int] NOT NULL,
	[invoiceid] [int] NOT NULL,
	[productid] [int] NOT NULL,
	[quantity] [int] NOT NULL,
	[unitprice] [money] NOT NULL,
	[netamount] [decimal](10, 2) NOT NULL,
	[taxrate] [decimal](10, 2) NOT NULL,
	[taxamount] [decimal](10, 2) NOT NULL,
	[amount] [decimal](10, 2) NOT NULL,
 CONSTRAINT [PK_Sales_InvoiceLines] PRIMARY KEY CLUSTERED 
(
	[invoicelineid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [SECONDARY]
) ON [SECONDARY]
GO

CREATE TABLE [sales].[OrderItems](
	[orderid] [int] NOT NULL,
	[productid] [int] NOT NULL,
	[unitprice] [money] NOT NULL,
	[qty] [smallint] NOT NULL,
	[discount] [numeric](4, 3) NOT NULL,
 CONSTRAINT [PK_OrderItems] PRIMARY KEY CLUSTERED 
(
	[orderid] ASC,
	[productid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [SECONDARY]
) ON [SECONDARY]
GO

CREATE TABLE [sales].[OrdersHeader](
	[orderid] [int] IDENTITY(1,1) NOT NULL,
	[custid] [int] NULL,
	[empid] [int] NOT NULL,
	[orderdate] [date] NOT NULL,
	[requireddate] [date] NOT NULL,
	[shippeddate] [date] NULL,
	[shipperid] [int] NOT NULL,
	[freight] [money] NULL,
	[shipname] [nvarchar](40) NULL,
	[shipaddress] [nvarchar](80) NULL,
	[shipcity] [nvarchar](30) NULL,
	[shipregion] [nvarchar](50) NULL,
	[shippostalcode] [int] NULL,
	[shipcountry] [nvarchar](15) NULL,
 CONSTRAINT [PK_OrdersHeader] PRIMARY KEY CLUSTERED 
(
	[orderid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [SECONDARY]
) ON [SECONDARY]
GO
/****** Object:  Table [sales].[Shippers]    Script Date: 12/02/2023 8:13:43 μμ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sales].[Shippers](
	[shipperid] [int] IDENTITY(1,1) NOT NULL,
	[companyname] [nvarchar](40) NOT NULL,
	[contactname] [nvarchar](30) NOT NULL,
	[contacttitle] [nvarchar](30) NOT NULL,
	[vatnumber] [nvarchar](10) NOT NULL,
	[address] [nvarchar](80) NOT NULL,
	[city] [nvarchar](30) NOT NULL,
	[postalcode] [int] NULL,
	[region] [nvarchar](50) NULL,
	[perfecture] [nvarchar](50) NULL,
	[country] [nvarchar](15) NOT NULL,
	[phone] [nvarchar](16) NOT NULL,
	[email] [nvarchar](256) NULL,
 CONSTRAINT [PK_Shippers] PRIMARY KEY CLUSTERED 
(
	[shipperid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [SECONDARY]
) ON [SECONDARY]
GO
ALTER TABLE [sales].[InvoiceHeader] ADD  CONSTRAINT [DF_Sales_InvoiceHeader_InvoiceID]  DEFAULT (NEXT VALUE FOR [sales].[InvoiceID]) FOR [invoiceid]
GO
ALTER TABLE [sales].[InvoiceLines] ADD  CONSTRAINT [DF_Sales_InvoiceLines_InvoiceLineID]  DEFAULT (NEXT VALUE FOR [sales].[InvoiceLineID]) FOR [invoicelineid]
GO
ALTER TABLE [sales].[OrderItems] ADD  CONSTRAINT [DFT_OrderItems_unitprice]  DEFAULT ((0)) FOR [unitprice]
GO
ALTER TABLE [sales].[OrderItems] ADD  CONSTRAINT [DFT_OrderItems_qty]  DEFAULT ((1)) FOR [qty]
GO
ALTER TABLE [sales].[OrderItems] ADD  CONSTRAINT [DFT_OrderItems_discount]  DEFAULT ((0)) FOR [discount]
GO
ALTER TABLE [sales].[OrdersHeader] ADD  CONSTRAINT [DFT_OrdersHeader_freight]  DEFAULT ((0)) FOR [freight]
GO
ALTER TABLE [hr].[Employees]  WITH CHECK ADD  CONSTRAINT [FK_Employees_Employees] FOREIGN KEY([mgrid])
REFERENCES [hr].[Employees] ([empid])
GO
ALTER TABLE [hr].[Employees] CHECK CONSTRAINT [FK_Employees_Employees]
GO
ALTER TABLE [products].[Products]  WITH CHECK ADD  CONSTRAINT [FK_Products_SubCategories] FOREIGN KEY([subcategoryid])
REFERENCES [products].[SubCategories] ([subcategoryid])
GO
ALTER TABLE [products].[Products] CHECK CONSTRAINT [FK_Products_SubCategories]
GO
ALTER TABLE [products].[Products]  WITH CHECK ADD  CONSTRAINT [FK_Products_Suppliers] FOREIGN KEY([supplierid])
REFERENCES [products].[Suppliers] ([supplierid])
GO
ALTER TABLE [products].[Products] CHECK CONSTRAINT [FK_Products_Suppliers]
GO
ALTER TABLE [products].[SubCategories]  WITH CHECK ADD  CONSTRAINT [FK_SubCategories_Categories] FOREIGN KEY([categoryid])
REFERENCES [products].[Categories] ([categoryid])
GO
ALTER TABLE [products].[SubCategories] CHECK CONSTRAINT [FK_SubCategories_Categories]
GO
ALTER TABLE [sales].[InvoiceHeader]  WITH CHECK ADD  CONSTRAINT [FK_InvoiceHeader_Customers] FOREIGN KEY([custid])
REFERENCES [sales].[Customers] ([custid])
GO
ALTER TABLE [sales].[InvoiceHeader] CHECK CONSTRAINT [FK_InvoiceHeader_Customers]
GO
ALTER TABLE [sales].[InvoiceHeader]  WITH CHECK ADD  CONSTRAINT [FK_InvoiceHeader_OrdersHeader] FOREIGN KEY([orderid])
REFERENCES [sales].[OrdersHeader] ([orderid])
GO
ALTER TABLE [sales].[InvoiceHeader] CHECK CONSTRAINT [FK_InvoiceHeader_OrdersHeader]
GO
ALTER TABLE [sales].[InvoiceLines]  WITH CHECK ADD  CONSTRAINT [FK_InvoiceLines_InvoiceHeader] FOREIGN KEY([invoiceid])
REFERENCES [sales].[InvoiceHeader] ([invoiceid])
GO
ALTER TABLE [sales].[InvoiceLines] CHECK CONSTRAINT [FK_InvoiceLines_InvoiceHeader]
GO
ALTER TABLE [sales].[InvoiceLines]  WITH CHECK ADD  CONSTRAINT [FK_InvoiceLines_Products] FOREIGN KEY([productid])
REFERENCES [products].[Products] ([productid])
GO
ALTER TABLE [sales].[InvoiceLines] CHECK CONSTRAINT [FK_InvoiceLines_Products]
GO
ALTER TABLE [sales].[OrderItems]  WITH CHECK ADD  CONSTRAINT [FK_OrderItems_Orders] FOREIGN KEY([orderid])
REFERENCES [sales].[OrdersHeader] ([orderid])
GO
ALTER TABLE [sales].[OrderItems] CHECK CONSTRAINT [FK_OrderItems_Orders]
GO
ALTER TABLE [sales].[OrderItems]  WITH CHECK ADD  CONSTRAINT [FK_OrderItems_Products] FOREIGN KEY([productid])
REFERENCES [products].[Products] ([productid])
GO
ALTER TABLE [sales].[OrderItems] CHECK CONSTRAINT [FK_OrderItems_Products]
GO
ALTER TABLE [sales].[OrdersHeader]  WITH CHECK ADD  CONSTRAINT [FK_OrdersHeader_Customers] FOREIGN KEY([custid])
REFERENCES [sales].[Customers] ([custid])
GO
ALTER TABLE [sales].[OrdersHeader] CHECK CONSTRAINT [FK_OrdersHeader_Customers]
GO
ALTER TABLE [sales].[OrdersHeader]  WITH CHECK ADD  CONSTRAINT [FK_OrdersHeader_Employees] FOREIGN KEY([empid])
REFERENCES [hr].[Employees] ([empid])
GO
ALTER TABLE [sales].[OrdersHeader] CHECK CONSTRAINT [FK_OrdersHeader_Employees]
GO
ALTER TABLE [sales].[OrdersHeader]  WITH CHECK ADD  CONSTRAINT [FK_OrdersHeader_Shippers] FOREIGN KEY([shipperid])
REFERENCES [sales].[Shippers] ([shipperid])
GO
ALTER TABLE [sales].[OrdersHeader] CHECK CONSTRAINT [FK_OrdersHeader_Shippers]
GO
ALTER TABLE [sales].[OrderItems]  WITH CHECK ADD  CONSTRAINT [CHK_discount] CHECK  (([discount]>=(0) AND [discount]<=(1)))
GO
ALTER TABLE [sales].[OrderItems] CHECK CONSTRAINT [CHK_discount]
GO
ALTER TABLE [sales].[OrderItems]  WITH CHECK ADD  CONSTRAINT [CHK_qty] CHECK  (([qty]>(0)))
GO
ALTER TABLE [sales].[OrderItems] CHECK CONSTRAINT [CHK_qty]
GO
ALTER TABLE [sales].[OrderItems]  WITH CHECK ADD  CONSTRAINT [CHK_unitprice] CHECK  (([unitprice]>=(0)))
GO
ALTER TABLE [sales].[OrderItems] CHECK CONSTRAINT [CHK_unitprice]
GO

-- OBJECT CODE

CREATE FUNCTION dbo.[GetNums](@low AS BIGINT, @high AS BIGINT) RETURNS TABLE
AS
RETURN
  WITH
    L0   AS (SELECT c FROM (SELECT 1 UNION ALL SELECT 1) AS D(c)),
    L1   AS (SELECT 1 AS c FROM L0 AS A CROSS JOIN L0 AS B),
    L2   AS (SELECT 1 AS c FROM L1 AS A CROSS JOIN L1 AS B),
    L3   AS (SELECT 1 AS c FROM L2 AS A CROSS JOIN L2 AS B),
    L4   AS (SELECT 1 AS c FROM L3 AS A CROSS JOIN L3 AS B),
    L5   AS (SELECT 1 AS c FROM L4 AS A CROSS JOIN L4 AS B),
    Nums AS (SELECT ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS rownum
             FROM L5)
  SELECT TOP(@high - @low + 1) @low + rownum - 1 AS n
  FROM Nums
  ORDER BY rownum;
GO

SELECT * INTO dbo.Nums FROM dbo.[GetNums](1, 10000000);
GO


