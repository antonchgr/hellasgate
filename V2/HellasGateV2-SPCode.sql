﻿USE [HellasGateV2]
GO

create or alter proc [dfi].[ClearData] 
as 
begin
	set nocount on;

	-- drop fkeys
	ALTER TABLE [sales].[InvoiceHeader] DROP CONSTRAINT [FK_InvoiceHeader_Customers];
	ALTER TABLE [sales].[InvoiceHeader] DROP CONSTRAINT [FK_InvoiceHeader_OrdersHeader];
	ALTER TABLE [sales].[InvoiceLines] DROP CONSTRAINT [FK_InvoiceLines_InvoiceHeader];
	ALTER TABLE [sales].[InvoiceLines] DROP CONSTRAINT [FK_InvoiceLines_Products];
	ALTER TABLE [sales].[OrderItems] DROP CONSTRAINT [FK_OrderItems_Orders];
	ALTER TABLE [sales].[OrderItems] DROP CONSTRAINT [FK_OrderItems_Products];
	ALTER TABLE [sales].[OrdersHeader] DROP CONSTRAINT [FK_OrdersHeader_Customers];
	ALTER TABLE [sales].[OrdersHeader] DROP CONSTRAINT [FK_OrdersHeader_Employees];
	ALTER TABLE [sales].[OrdersHeader] DROP CONSTRAINT [FK_OrdersHeader_Shippers];
	ALTER TABLE [products].[Products] DROP CONSTRAINT [FK_Products_SubCategories];
	ALTER TABLE [products].[Products] DROP CONSTRAINT [FK_Products_Suppliers];
	ALTER TABLE [products].[SubCategories] DROP CONSTRAINT [FK_SubCategories_Categories];
	ALTER TABLE [hr].[Employees] DROP CONSTRAINT [FK_Employees_Employees];

	-- TRUNCATE TABLES
	truncate table sales.InvoiceLines;
	truncate table sales.InvoiceHeader;
	truncate table sales.OrderItems;
	truncate table sales.OrdersHeader;
	truncate table products.Products;
	truncate table products.SubCategories;
	truncate table Products.Categories;
	truncate table products.Suppliers;
	truncate table hr.Employees;
	truncate table sales.Shippers;
	truncate table sales.Customers;
	truncate table bi.DimCalendar;

	-- shrink

	declare @stmdbcc nvarchar(100) = 'dbcc shrinkdatabase (' + quotename(db_name()) + ',0);';
	exec (@stmdbcc);

	-- add fkeys 

	ALTER TABLE [products].[Products]  
	WITH CHECK ADD  CONSTRAINT [FK_Products_SubCategories] 
	FOREIGN KEY([subcategoryid])
	REFERENCES [products].[SubCategories] ([subcategoryid]);
	ALTER TABLE [products].[Products] CHECK CONSTRAINT [FK_Products_SubCategories];

	ALTER TABLE [products].[Products]  
	WITH CHECK ADD  CONSTRAINT [FK_Products_Suppliers] 
	FOREIGN KEY([supplierid])
	REFERENCES [products].[Suppliers] ([supplierid]);
	ALTER TABLE [products].[Products] CHECK CONSTRAINT [FK_Products_Suppliers]

	ALTER TABLE [products].[SubCategories]  
	WITH CHECK ADD  CONSTRAINT [FK_SubCategories_Categories] 
	FOREIGN KEY([categoryid])
	REFERENCES [products].[Categories] ([categoryid]);
	ALTER TABLE [products].[SubCategories] CHECK CONSTRAINT [FK_SubCategories_Categories];

	ALTER TABLE [hr].[Employees]  
	WITH CHECK ADD  CONSTRAINT [FK_Employees_Employees] 
	FOREIGN KEY([mgrid])
	REFERENCES [hr].[Employees] ([empid]);
	ALTER TABLE [hr].[Employees] CHECK CONSTRAINT [FK_Employees_Employees];

	ALTER TABLE [sales].[OrdersHeader]  
	WITH CHECK ADD  CONSTRAINT [FK_OrdersHeader_Customers] 
	FOREIGN KEY([custid])
	REFERENCES [sales].[Customers] ([custid]);
	ALTER TABLE [sales].[OrdersHeader] CHECK CONSTRAINT [FK_OrdersHeader_Customers];

	ALTER TABLE [sales].[OrdersHeader]  
	WITH CHECK ADD  CONSTRAINT [FK_OrdersHeader_Employees] 
	FOREIGN KEY([empid])
	REFERENCES [hr].[Employees] ([empid]);
	ALTER TABLE [sales].[OrdersHeader] CHECK CONSTRAINT [FK_OrdersHeader_Employees];

	ALTER TABLE [sales].[OrdersHeader]  
	WITH CHECK ADD  CONSTRAINT [FK_OrdersHeader_Shippers] 
	FOREIGN KEY([shipperid])
	REFERENCES [sales].[Shippers] ([shipperid]);
	ALTER TABLE [sales].[OrdersHeader] CHECK CONSTRAINT [FK_OrdersHeader_Shippers];
	
	ALTER TABLE [sales].[OrderItems]  
	WITH CHECK ADD  CONSTRAINT [FK_OrderItems_Orders] 
	FOREIGN KEY([orderid])
	REFERENCES [sales].[OrdersHeader] ([orderid]);
	ALTER TABLE [sales].[OrderItems] CHECK CONSTRAINT [FK_OrderItems_Orders];

	ALTER TABLE [sales].[OrderItems]  
	WITH CHECK ADD  CONSTRAINT [FK_OrderItems_Products] 
	FOREIGN KEY([productid])
	REFERENCES [products].[Products] ([productid]);
	ALTER TABLE [sales].[OrderItems] CHECK CONSTRAINT [FK_OrderItems_Products];

	ALTER TABLE [sales].[InvoiceHeader]  
	WITH CHECK ADD  CONSTRAINT [FK_InvoiceHeader_Customers] 
	FOREIGN KEY([custid])
	REFERENCES [sales].[Customers] ([custid]);
	ALTER TABLE [sales].[InvoiceHeader] CHECK CONSTRAINT [FK_InvoiceHeader_Customers];

	ALTER TABLE [sales].[InvoiceHeader]  
	WITH CHECK ADD  CONSTRAINT [FK_InvoiceHeader_OrdersHeader] 
	FOREIGN KEY([orderid])
	REFERENCES [sales].[OrdersHeader] ([orderid]);
	ALTER TABLE [sales].[InvoiceHeader] CHECK CONSTRAINT [FK_InvoiceHeader_OrdersHeader];

	ALTER TABLE [sales].[InvoiceLines]  
	WITH CHECK ADD  CONSTRAINT [FK_InvoiceLines_InvoiceHeader] 
	FOREIGN KEY([invoiceid])
	REFERENCES [sales].[InvoiceHeader] ([invoiceid]);
	ALTER TABLE [sales].[InvoiceLines] CHECK CONSTRAINT [FK_InvoiceLines_InvoiceHeader];

	ALTER TABLE [sales].[InvoiceLines]  
	WITH CHECK ADD  CONSTRAINT [FK_InvoiceLines_Products] 
	FOREIGN KEY([productid])
	REFERENCES [products].[Products] ([productid]);
	ALTER TABLE [sales].[InvoiceLines] CHECK CONSTRAINT [FK_InvoiceLines_Products];
end
GO

create or alter proc [dfi].[GenerateCustomers]
					@numofCustomers int = 10000
as
begin
	set nocount on;

	-- VARIABLES
	declare @i int = 1;
	declare @cities int, @streets int, @gnames int
	declare @rname int = 0;
	declare @rcity int = 0;
	declare @rstreet int = 0;

	declare -- Customers
		@custid int,
		@companyname nvarchar(40),
		@contactname nvarchar(30),
		@contacttitle nvarchar(30),
		@vatnumber nvarchar(10),
		@address nvarchar(80),
		@city nvarchar(30),
		@postalcode int,
		@region nvarchar(50),
		@perfecture nvarchar(50),
		@country nvarchar(15),
		@phone nvarchar(16),
		@email nvarchar(256),
		@emaildomain nvarchar(256);


	select @cities = count(*) from dfi.cities;
	select @streets = count(*) from dfi.streets;
	select @gnames = count(*) from dfi.GreekNames;

	-- TRUNCATE TABLES
	--truncate table sales.Customers;

	-- CUSTOMERS TABLE

	while ( @i<=@numofCustomers )
	begin

		set @rname = ABS(CHECKSUM(NewId())) % @gnames;
		set @rcity = ABS(CHECKSUM(NewId())) % @cities;
		set @rstreet = ABS(CHECKSUM(NewId())) % @streets;
		if @rstreet <= 0  set @rstreet = 1; 
		if @rcity <= 0 set @rcity = 1;
		set @custid = null;
		set @companyname = null;
		set @contactname = null;
		set @contacttitle = null;
		set @vatnumber = null;
		set @address = null;
		set @city = null;
		set @postalcode = null;
		set @region = null;
		set @perfecture = null;
		set @country = null;
		set @phone = null;
		set @email = null;
		set @emaildomain = null;
		
		--print @rcity;
		--print @rstreet;

		select	top(1) 
				@companyname = lastname + ' ' + left(firstname,1) + '. ' +
							   CHOOSE( iif (@i%6=0,1,@i%6),'Ο.Ε','Ε.Π.Ε','Α.Ε','Ε.Ε','Ι.Κ.Ε','ΚΟΙΝΣΕΠ'),
				@emaildomain = lastname + left(firstname,1) +
							   CHOOSE( iif (@i%6=0,1,@i%6),'ΟΕ','ΕΠΕ','ΑΕ','ΕΕ','ΙΚΕ','ΚΟΙΝΣΕΠ') + '.gr'
		from dfi.GreekNames where aa = @rname;
		--print @companyname

		select top(1) 
				@contactname =  lastname + ' ' + firstname
		from dfi.GreekNames where aa = iif(@rname-@i<=0,@rname+10,@rname-@i) 
		--print @contactname

		set @contacttitle = CHOOSE( iif (@i%9=0,1,@i%9),'CEO','CIO','COO','CFO','CTO','CCO','CHRM','CMO','CDO')
		--print @contacttitle

		set @vatnumber = left(cast(@rname as varchar)+cast(@rcity as varchar)+cast(@rstreet as varchar)+'0000000000',10)
		--print @vatnumber

		select	top(1) 
				@address = street + ' ' + cast(iif(@i%125=0,1,@i%125) as varchar)
		from dfi.streets where aa = @rstreet
		--print @address

		select	top(1) 
				@city = city,
				@postalcode = PostCode,
				@region = region,
				@perfecture = perfecture
		from dfi.cities where aa = @rcity --iif(@rcity-@i<=0,@rcity+10,@rcity-@i)
		set @country = N'Ελλάδα';
		--print @city + ' ' + cast(@postalcode as varchar) + ' ' + @region + ' ' + @perfecture+ ' ' + @country

		set @phone = left('2'+ CAST(@postalcode as char(5)) + cast(@rname as varchar) + '0000000000',10)
		--print @phone;

		
		select @email = replace(lower(dbo.ConvertGreekToELOT743(@contactname)),' ','.')
				   + '@'
				   + lower(dbo.ConvertGreekToELOT743(@emaildomain))
		
		--print @address + ' ' + @city
		if ( @i%10 >= 7 ) -- english name
		begin
			select @companyname=dbo.ConvertGreekToELOT743(@companyname);
			select @contactname=dbo.ConvertGreekToELOT743(@contactname);
			select @address=dbo.ConvertGreekToELOT743(@address);
			select @city=dbo.ConvertGreekToELOT743(@city);
			select @region=dbo.ConvertGreekToELOT743(@region);
			select @perfecture=dbo.ConvertGreekToELOT743(@perfecture);
			select @country=dbo.ConvertGreekToELOT743(@country);
		end 
		--print @address + ' ' + @city
		insert into sales.Customers([companyname], [contactname], [contacttitle], [vatnumber], [address], [city], [postalcode], [region], [perfecture], [country], [phone], [email])
		values (@companyname, @contactname, @contacttitle, @vatnumber, @address, @city, @postalcode, @region, @perfecture, @country, @phone, @email)

		if (@i%1000=0) waitfor delay '00:00:10';
		set @i+=1;
		--print cast(@i%1000 as varchar)
	end
	--select * from sales.Customers
end
GO

create or alter proc [dfi].[GenerateEmployees]
						@numofEmployees int = 250
as
begin
	set nocount on;

	-- VARIABLES
	declare @i int = 1;
	declare @cities int, @streets int, @gnames int;
	declare @rname int = 0;
	declare @rcity int = 0;
	declare @rstreet int = 0;

	declare -- Employees
		@lastname nvarchar(20),
		@firstname nvarchar(10),
		@title nvarchar(30),
		@isSalesperson bit,
		@birthdate date,
		@hiredate date,
		@address nvarchar(80),
		@city nvarchar(30),
		@postalcode int,
		@region nvarchar(50),
		@perfecture nvarchar(50),
		@country nvarchar(15),
		@phone nvarchar(16),
		@email nvarchar(256),
		@mgrid int,
		@salary money,
		@emaildomain nvarchar(256);

	select @cities = count(*) from dfi.cities;
	select @streets = count(*) from dfi.streets;
	select @gnames = count(*) from dfi.GreekNames;


	-- TRUNCATE TABLES
	--truncate table hr.Employees;

	-- EMPLOYEES TABLE
	set @i=1
	while ( @i<=@numofEmployees )
	begin

		set @rname  = ABS(CHECKSUM(NewId())) % @gnames;
		set @rcity  = ABS(CHECKSUM(NewId())) % @cities;
		set @rstreet= ABS(CHECKSUM(NewId())) % @streets;
		if @rstreet <= 0  set @rstreet = 1; 
		if @rcity <= 0 set @rcity = 1;
		    
		select	top(1) 
				@lastname = lastname,
				@firstname = firstname,
				@emaildomain = 'HellasGate.gr'
		from dfi.GreekNames where aa = @rname;
		--print @lastname+ ' '+@firstname+' '+@emaildomain

		set @birthdate =  DATEADD(DAY, RAND(CHECKSUM(NEWID()))*
								 (1+DATEDIFF(DAY, '19820101', '20021231')),'19820101');
		if (@i = 1 ) set @birthdate =  '19670829'
		--print @birthdate

		set @hiredate =  DATEADD(DAY, RAND(CHECKSUM(NEWID()))*
								 (1+DATEDIFF(DAY, '20101001', '20221001')),'20101001');
		if (@i = 1 ) set @hiredate =  '20101001'
		--print @hiredate
	
		select	top(1) 
				@address = street + ' ' + cast(iif(@i%125=0,1,@i%125) as varchar)
		from dfi.streets where aa = @rstreet
		--print @address

		select	top(1) 
				@city = city,
				@postalcode = PostCode,
				@region = region,
				@perfecture = perfecture
		from dfi.cities where aa = iif(@rcity-@i<=0,@rcity+10,@rcity-@i)
		set @country = N'Ελλάδα';
		--print @city + ' ' + cast(@postalcode as varchar) + ' ' + @region + ' ' + @perfecture+ ' ' + @country
	
		set @phone = '21050' + right('12345'+ CAST(@i as varchar) ,5)
		--print @phone;

		select @email = lower(dbo.ConvertGreekToELOT743(@firstname + '.' + @lastname))
				   + '@'
				   + lower(@emaildomain)

		--print @firstname + ' ' + @lastname+ ' ' + @email

		set @title = ''
		if (@i = 1 ) set @title= 'CEO'
		if (@i = 2 ) set @title= 'CIO'
		if (@i = 3 ) set @title= 'COO'
		if (@i = 4 ) set @title= 'CFO'
		if (@i = 5 ) set @title= 'CTO'
		if (@i = 6 ) set @title= 'CCO'
		if (@i = 7 ) set @title= 'CHRM'
		if (@i = 8 ) set @title= 'CMO'
		if (@i = 9 ) set @title= 'CDO'
		--print @title

		set @mgrid = CHOOSE( iif (@i%7=0,1,@i%7),2,3,4,5,6,7,9)
		if (@i = 1 ) set @mgrid = null
		if (@i between 2 and 10 ) set @mgrid = 1
		if @mgrid = 2 set @title = CHOOSE( iif (@i%3=0,1,@i%3),'Business Analyst','Strategy','R&D')
		if @mgrid = 3 set @title = CHOOSE( iif (@i%5=0,1,@i%5),'Γραμματέας','Account Manager','Strategy Manager','Operations Staff','Οδηγός')
		if @mgrid = 4 set @title = CHOOSE( iif (@i%3=0,1,@i%3),'Βοηθός Λογιστή','Λογιστής','Αρχιλογιστής')
		if @mgrid = 5 set @title = CHOOSE( iif (@i%8=0,1,@i%8),'Data Engineer','DBA','System Engineer','Developer','Data Analyst','DevOps Engineer','Network Enginner','Support Engineer')
		if @mgrid = 6 set @title = CHOOSE( iif (@i%3=0,1,@i%3),'ISO Staff','Security Engineer','Security Staff')
		if @mgrid = 7 set @title = CHOOSE( iif (@i%3=0,1,@i%3),'Marketing Designer','Socials Engineer','Marketing Staff')
		if @mgrid = 9 set @title = CHOOSE( iif (@i%3=0,1,@i%3),'Data Engineer','DBA','Data Analyst','Data Scientist')
		--print @mgrid

		set @salary = null
		if @mgrid = 2 set @salary = FLOOR(RAND(CHECKSUM(NEWID()))*(55000-21000+1)+21000)
		if @mgrid = 3 set @salary = FLOOR(RAND(CHECKSUM(NEWID()))*(35000-21000+1)+21000)
		if @mgrid = 4 set @salary = FLOOR(RAND(CHECKSUM(NEWID()))*(30000-21000+1)+21000)
		if @mgrid = 5 set @salary = FLOOR(RAND(CHECKSUM(NEWID()))*(65000-21000+1)+21000)
		if @mgrid = 6 set @salary = FLOOR(RAND(CHECKSUM(NEWID()))*(45000-21000+1)+21000)
		if @mgrid = 7 set @salary = FLOOR(RAND(CHECKSUM(NEWID()))*(40000-21000+1)+21000)
		if @mgrid = 8 set @salary = FLOOR(RAND(CHECKSUM(NEWID()))*(35000-21000+1)+21000)
		if @mgrid = 9 set @salary = FLOOR(RAND(CHECKSUM(NEWID()))*(75000-31000+1)+31000)
		--print @salary

		set @isSalesperson = iif (@i%3 = 0 , 0, 1)
		if @i<10 set @isSalesperson = 0
		if @isSalesperson = 1 set @title='Πωλητής'
		if @isSalesperson = 1 set @mgrid=8
		--print @isSalesperson


		if ( @i%10 >= 7 ) -- english name
		begin
			select @lastname=dbo.ConvertGreekToELOT743(@lastname);
			select @firstname=dbo.ConvertGreekToELOT743(@firstname);
			select @address=dbo.ConvertGreekToELOT743(@address);
			select @city=dbo.ConvertGreekToELOT743(@city);
			select @region=dbo.ConvertGreekToELOT743(@region);
			select @country=dbo.ConvertGreekToELOT743(@country);
		end 

		insert into hr.Employees([lastname], [firstname], [title], [isSalesperson], [birthdate], [hiredate], [address], [city], [region], [postalcode], [country], [phone], [mgrid], [salary], [email])
		values (@lastname, @firstname, @title, @isSalesperson, @birthdate, @hiredate, @address, @city, @region, @postalcode, @country, @phone, @mgrid, @salary, @email)

		if (@i%1000=0) waitfor delay '00:00:10';
		set @i+=1;
		--print cast(@i%1000 as varchar)
	end
	--select * from hr.employees
end
GO

create or alter proc [dfi].[GenerateOrders]
							@numofOrders int = 1000,
							@maxItemsInOrder int = 5
as
begin
	set nocount on;

	-- VARIABLES
	declare 
		@i int = 1,
		@ncustomers int = 0,
		@nshippers int = 0,
		@nemployees int = 0,
		@nproducts int = 0;
		
	declare @employees table (empid int);
	
	declare -- OrdersHeader
		@orderid int,
		@custid int,
		@empid int,
		@orderdate date,
		@requireddate date,
		@shippeddate date,
		@shipperid int,
		@freight money,
		@shipname nvarchar(40),
		@shipaddress nvarchar(80),
		@shipcity nvarchar(30),
		@shipregion nvarchar(50),
		@shippostalcode int,
		@shipcountry nvarchar(15),
		----------- OrdersItems
		@productid int,
		@unitprice money,
		@qty smallint,
		@discount numeric(4, 3);
		
	-- init values
	select @ncustomers = count(*) from sales.Customers;
	select @nemployees = count(*) from hr.Employees where isSalesperson = 1;
	insert into @employees select empid from hr.Employees where isSalesperson = 1;
	select @nshippers = count(*) from sales.Shippers;
	select @nproducts = count(*) from products.Products;
	select top(0) * into #ordersheader from sales.OrdersHeader;

	-- add rows in header
	set @i=1
	while ( @i<=@numofOrders )
	begin
		
		set @custid = ABS(CHECKSUM(NewId())) % @ncustomers;
		if (@custid < 1 )
			set @custid = iif ((@i%2 = 0),  
		    				   (select max(custid) from sales.Customers),
							   (select min(custid) from sales.Customers));
		
		set @shipperid = ABS(CHECKSUM(NewId())) % @nshippers;
		if (@shipperid < 1 )
			set @shipperid = iif ((@i%2 = 0),  
								 (select max(shipperid) from sales.Shippers),
								 (select min(shipperid) from sales.Shippers));

		set @empid = ABS(CHECKSUM(NewId())) % @nemployees;
		if (@empid <= 1 )
			set @empid = iif ((@i%2 = 0),  
						      (select max(empid) from @employees),
							  (select min(empid) from @employees));
		
		set @orderdate =  DATEADD(DAY, RAND(CHECKSUM(NEWID()))*
								 (1+DATEDIFF(DAY, cast(DATEADD(year,-5,getdate()) as date), cast(DATEADD(MONTH,-1,getdate()) as date)))
								 ,cast(DATEADD(year,-5,getdate()) as date));

		set @requireddate = DATEADD(day,31,@orderdate);
	
		insert into #ordersheader ([custid], [empid], [orderdate], [requireddate], [shipperid])
		values ( @custid,@empid,@orderdate,@requireddate,@shipperid);

		set @i+=1;

	end

	insert into sales.OrdersHeader ([custid], [empid], [orderdate], [requireddate], [shipperid])
	select [custid], [empid], [orderdate], [requireddate], [shipperid] from #ordersheader order by orderdate

	-- add rows in items
		
	-- set  item rows per order
	select cast ( log10(ABS(CHECKSUM(NewId()))) as tinyint) - @maxItemsInOrder as items , orderid 
	into #oi1
	from sales.OrdersHeader

	-- generate items rows 
	select i.orderid,ABS(CHECKSUM(NewId())) % @nproducts as productid
	into #oi2
	from #oi1 as i
	inner join dbo.Nums as n on i.items >= n.n
	order by i.orderid;
	
	-- set product
	while ( select count(*) from #oi2 where productid = 0 ) > 0 
	begin
		update #oi2
		set productid = ABS(CHECKSUM(NewId())) % @nproducts
		where productid = 0
	end;

	-- delete duplicate rows
	with dr as (
	select	i.orderid,i.productid, 
			ROW_NUMBER() over (partition by i.orderid,i.productid order by (select null)) as ddr
	from #oi2 as i)
	delete from dr where ddr > 1;

	-- final insert
	insert into sales.OrderItems([orderid], [productid], [unitprice], [qty], [discount])
	select	i.orderid,i.productid, 
			(select unitprice from products.Products as p where p.productid = i.productid) as up,
			1,0.0
	from #oi2 as i

	-- order shipping 
	
	update sales.OrdersHeader
	set 
		shippeddate = dateadd (day, -2, requireddate),
		freight = (select round(sum(i.qty*i.unitprice) * 0.01,2) from sales.OrderItems as  i where i.orderid = sales.OrdersHeader.orderid),
		shipname = (select contactname from sales.Customers as c where c.custid = sales.OrdersHeader.custid),
		shipaddress = (select address from sales.Customers as c where c.custid = sales.OrdersHeader.custid),
		shipcity = (select city from sales.Customers as c where c.custid = sales.OrdersHeader.custid),
		shipregion = (select region from sales.Customers as c where c.custid = sales.OrdersHeader.custid),
		shippostalcode = (select postalcode from sales.Customers as c where c.custid = sales.OrdersHeader.custid),
		shipcountry = (select country from sales.Customers as c where c.custid = sales.OrdersHeader.custid)
	where 
		shippeddate is null
		and 
		requireddate <  getdate()

	-- invoicing shipped orders

	insert into sales.InvoiceHeader([orderid], [custid], [invoicedate])
	select orderid, custid,shippeddate from sales.OrdersHeader
	where shippeddate is not null;
	
	insert into sales.InvoiceLines([invoiceid], [productid], [quantity], [unitprice], [netamount], [taxrate], [taxamount], [amount])
	select invoiceid, productid, qty, unitprice, round((qty*unitprice),2), 24.00, round((qty*unitprice) * 0.24,2), round(((qty*unitprice) * 1.24),2)
	from sales.InvoiceHeader as ih
	inner join sales.OrderItems as oi on ih.orderid = oi.orderid;
end
GO

create or alter proc [dfi].[GenerateProducts]
						@numofProducts	int = 2000
as
begin
	set nocount on;

	-- VARIABLES
	declare @i int = 1;
	declare @subcategories int, @suppliers int;
	
	declare --Products
		@productid int,
		@productname nvarchar(100),
		@supplierid int,
		@subcategoryid int,
		@unitprice money,
		@isOutofOrder bit;

	-- TRUNCATE TABLES
	--truncate table products.Products;
	--truncate table products.SubCategories;
	--truncate table Products.Categories;

	-- PRODUCT CATEGORIES
	insert into [Products].[Categories](categoryname,[description]) values ('Υπολογιστές','Desktop PC,Laptop,Monitor,Keyboard,Mouse')
	insert into [Products].[Categories](categoryname,[description]) values ('Έξυπνα Τηλέφωνα','5G,4G,3G')
	insert into [Products].[Categories](categoryname,[description]) values ('Τηλεοράσεις','TV,Smart TV')
	insert into [Products].[Categories](categoryname,[description]) values ('Παιχνίδια','Τηλεκατευθυνόμενα,Κλασσικά,Δημιουργικά,Επιτραπέζια,Υπολογιστών,Consoles')
	insert into [Products].[Categories](categoryname,[description]) values ('Λευκές Συσκευές','Ψυγεία,Πλυντήρια,Κουζίνες')
	insert into [Products].[Categories](categoryname,[description]) values ('Επιπλά','Τραπέζια,Καρέκλες,Καναπέδες,Σαλόνια')
	insert into [Products].[Categories](categoryname,[description]) values ('Χαρτοπολείο','Χαρτί,Σημειωματάρια,Γόμες,Κλασέρ,Ντοσιέ')
	insert into [Products].[Categories](categoryname,[description]) values ('Είδη Γραφής','Στυλο,Πένες,Μαρκαδόροι,Μολύβια')
	insert into [Products].[Categories](categoryname,[description]) values ('Κλιματισμός','Επιτοίχια,Επιτραπέζια,Επιδαπέδια')
	insert into [Products].[Categories](categoryname,[description]) values ('Εκτυπωτές','Laser,InkJet,Tank,Πολυμηχανήματα')
	--select * from  [Products].[Categories];

	-- PRODUCT SUBCATEGORIES
	insert into products.SubCategories(categoryid,subcategoryname,[description]) 
	select categoryid, s.value , N'Κατηγορία ' + c.categoryname
	from products.categories as c
	cross apply string_split(description,',') as s
	--select * from products.subcategories;

	-- PRODUCTS TABLE
	set @i=1
	select @subcategories = count(*) from products.SubCategories;
	select @suppliers = count(*) from products.Suppliers;
	while ( @i<=@numofProducts )
	begin
		set @unitprice = 0.0;
		set @isOutofOrder = iif (@i%28 = 0 ,1, 0);
		set @supplierid = ABS(CHECKSUM(NewId())) % @suppliers;
		if (@supplierid = 0 ) set @supplierid=1;
		set @subcategoryid = ABS(CHECKSUM(NewId())) % @subcategories;
		if (@subcategoryid = 0) set @subcategoryid=1;
	
		select @productname = subcategoryname 
		from products.SubCategories 
		where subcategoryid = @subcategoryid

		insert into [products].[Products] (productname, supplierid, subcategoryid, unitprice, isOutofOrder)
		values (@productname, @supplierid, @subcategoryid, @unitprice, @isOutofOrder)

		set @i+=1;

	end

	update p
	set 
	p.productname =	case s.subcategoryname 
	when 'Desktop PC' then CHOOSE( iif (p.productid%5=0,1,p.productid%5),'DELL','HP','LENOVO','ASUS','MICROSOFT') + ' Pc-' + right(N'00' + reverse(CAST(p.productid as varchar)) + '00',16)
	when 'Laptop' then CHOOSE( iif (p.productid%5=0,1,p.productid%5),'DELL','HP','LENOVO','ASUS','MICROSOFT') + ' Laptop-' + right(N'00' + reverse(CAST(p.productid as varchar)) + '00',16)
	when 'Monitor' then CHOOSE( iif (p.productid%6=0,1,p.productid%6),'DELL','HP','LENOVO','ASUS','LG','SAMSUNG') + ' Monitor-' + right(N'00' + reverse(CAST(p.productid as varchar)) + '00',16)
	when 'Keyboard' then CHOOSE( iif (p.productid%6=0,1,p.productid%6),'DELL','HP','LENOVO','ASUS','MICROSOFT','LOGITECH') + ' Keyboard-' + right(N'00' + reverse(CAST(p.productid as varchar)) + '00',16)
	when 'Mouse' then CHOOSE( iif (p.productid%6=0,1,p.productid%6),'DELL','HP','LENOVO','ASUS','MICROSOFT','LOGITECH') + ' Mouse-' + right(N'00' + reverse(CAST(p.productid as varchar)) + '00',16)
	when '5G' then CHOOSE( iif (p.productid%5=0,1,p.productid%5),'APPLE','NOKIA','ASUS','XIAOMI','SAMSUNG') + ' Smartphone(5G)-' + right(N'00' + reverse(CAST(p.productid as varchar)) + '00',16)
	when '4G' then CHOOSE( iif (p.productid%5=0,1,p.productid%5),'APPLE','NOKIA','ASUS','XIAOMI','SAMSUNG') + ' Smartphone(4G)-' + right(N'00' + reverse(CAST(p.productid as varchar)) + '00',16)
	when '3G' then CHOOSE( iif (p.productid%5=0,1,p.productid%5),'APPLE','NOKIA','ASUS','XIAOMI','SAMSUNG') + ' Smartphone(3G)-' + right(N'00' + reverse(CAST(p.productid as varchar)) + '00',16)
	when 'TV' then CHOOSE( iif (p.productid%3=0,1,p.productid%3),'LG','SONY','SAMSUNG') + ' TV-' + right(N'00' + reverse(CAST(p.productid as varchar)) + '00',16)
	when 'Smart TV' then CHOOSE( iif (p.productid%3=0,1,p.productid%3),'LG','SONY','SAMSUNG') + ' Smart TV-' + right(N'00' + reverse(CAST(p.productid as varchar)) + '00',16)
	when 'Τηλεκατευθυνόμενα' then CHOOSE( iif (p.productid%3=0,1,p.productid%3),'AS','HOT WHEELS','CARRERA') + ' Τ/Κ παιχνίδι-' + right(N'00' + reverse(CAST(p.productid as varchar)) + '00',16)
	when 'Κλασσικά' then CHOOSE( iif (p.productid%5=0,1,p.productid%5),'LEGO','PLAYMOBILL','BARBIE','ΛΟΥΤΡΙΝΟ','ΞΥΛΙΝΟ') + ' Κλασσικό παιχνίδι-' + right(N'00' + reverse(CAST(p.productid as varchar)) + '00',16)
	when 'Δημιουργικά' then CHOOSE( iif (p.productid%5=0,1,p.productid%5),'GOOMBY','HASBRO','AS','CUBICFUN','PLAY-DOH') + ' Δημιουργικό παιχνίδι-' + right(N'00' + reverse(CAST(p.productid as varchar)) + '00',16)
	when 'Επιτραπέζια' then CHOOSE( iif (p.productid%5=0,1,p.productid%5),'BRAINBOX','HASBRO','AS','KAISSA','PREZIOSI') + ' Επιτραπέζιο παιχνίδι-' + right(N'00' + reverse(CAST(p.productid as varchar)) + '00',16)
	when 'Υπολογιστών' then CHOOSE( iif (p.productid%3=0,1,p.productid%3),'MICROSOFT','EA','SEGA') + ' Παιχνίδι Η/Υ-' + right(N'00' + reverse(CAST(p.productid as varchar)) + '00',16)
	when 'Consoles' then CHOOSE( iif (p.productid%5=0,1,p.productid%5),'PSP','XBOX','NINTENDO','PC','SWITCH') + ' Console game-' + right(N'00' + reverse(CAST(p.productid as varchar)) + '00',16)
	when 'Ψυγεία' then CHOOSE( iif (p.productid%5=0,1,p.productid%5),'AEG','BOSCH','LG','PITSOS','WHIRLPOOL') + ' Ψυγείο-' + right(N'00' + reverse(CAST(p.productid as varchar)) + '00',16)
	when 'Πλυντήρια' then CHOOSE( iif (p.productid%5=0,1,p.productid%5),'AEG','BOSCH','LG','PITSOS','WHIRLPOOL') + ' Πλυντήριο-' + right(N'00' + reverse(CAST(p.productid as varchar)) + '00',16)
	when 'Κουζίνες' then CHOOSE( iif (p.productid%5=0,1,p.productid%5),'AEG','BOSCH','LG','PITSOS','WHIRLPOOL') + ' Κουζίνα-' + right(N'00' + reverse(CAST(p.productid as varchar)) + '00',16)
	when 'Τραπέζια' then CHOOSE( iif (p.productid%5=0,1,p.productid%5),'DROMEAS','SATO','ΣΚΟΥΡΟΠΟΥΛΟΣ','ΕΝΤΟΣ','FOCUS') + ' Τραπέζι-' + right(N'00' + reverse(CAST(p.productid as varchar)) + '00',16)
	when 'Καρέκλες' then CHOOSE( iif (p.productid%5=0,1,p.productid%5),'DROMEAS','SATO','ΣΚΟΥΡΟΠΟΥΛΟΣ','ΕΝΤΟΣ','FOCUS') + ' Καρέκλα-' + right(N'00' + reverse(CAST(p.productid as varchar)) + '00',16)
	when 'Καναπέδες' then CHOOSE( iif (p.productid%5=0,1,p.productid%5),'DROMEAS','SATO','ΣΚΟΥΡΟΠΟΥΛΟΣ','ΕΝΤΟΣ','FOCUS') + ' Καναπές-' + right(N'00' + reverse(CAST(p.productid as varchar)) + '00',16)
	when 'Σαλόνια' then CHOOSE( iif (p.productid%5=0,1,p.productid%5),'DROMEAS','SATO','ΣΚΟΥΡΟΠΟΥΛΟΣ','ΕΝΤΟΣ','FOCUS') + ' Σαλόνι-' + right(N'00' + reverse(CAST(p.productid as varchar)) + '00',16)
	when 'Χαρτί' then CHOOSE( iif (p.productid%5=0,1,p.productid%5),'XEROX','CANON','HP','KODAK','EPSON') + ' Χαρτί-' + right(N'00' + reverse(CAST(p.productid as varchar)) + '00',16)
	when 'Σημειωματάρια' then CHOOSE( iif (p.productid%5=0,1,p.productid%5),'PAPERBANKS','LEUCHTTURM1917','LEGAMI','ENDLESS','YAMAMOTO') + ' Notebook-' + right(N'00' + reverse(CAST(p.productid as varchar)) + '00',16)
	when 'Γόμες' then CHOOSE( iif (p.productid%5=0,1,p.productid%5),'FABER CASTELL','MILAN','MAPED','LEGAMI','PELIKAN') + ' Γόμα-' + right(N'00' + reverse(CAST(p.productid as varchar)) + '00',16)
	when 'Κλασέρ' then CHOOSE( iif (p.productid%5=0,1,p.productid%5),'SKAG','GRAFFITI','MAPED','SANTORO','HELLO KITTY') + ' Κλασέρ-' + right(N'00' + reverse(CAST(p.productid as varchar)) + '00',16)
	when 'Ντοσιέ' then CHOOSE( iif (p.productid%5=0,1,p.productid%5),'SKAG','GRAFFITI','MAPED','SANTORO','HELLO KITTY') + ' Ντοσιέ-' + right(N'00' + reverse(CAST(p.productid as varchar)) + '00',16)
	when 'Στυλο' then CHOOSE( iif (p.productid%5=0,1,p.productid%5),'BIC','STABILO','FABER CASTELL','PENTEL','PILOT') + ' Στυλό-' + right(N'00' + reverse(CAST(p.productid as varchar)) + '00',16)
	when 'Πένες' then CHOOSE( iif (p.productid%5=0,1,p.productid%5),'MONDBLANC','PELIKAN','PARKER','FABER CASTELL','WATERMAN') + ' Πένα-' + right(N'00' + reverse(CAST(p.productid as varchar)) + '00',16)
	when 'Μαρκαδόροι' then CHOOSE( iif (p.productid%5=0,1,p.productid%5),'BIC','STABILO','FABER CASTELL','PENTEL','PILOT') + ' Μαρκαδόρος-' + right(N'00' + reverse(CAST(p.productid as varchar)) + '00',16)
	when 'Μολύβια' then CHOOSE( iif (p.productid%5=0,1,p.productid%5),'BIC','STABILO','FABER CASTELL','PENTEL','PILOT') + ' Μολύβι-' + right(N'00' + reverse(CAST(p.productid as varchar)) + '00',16)
	when 'Επιτοίχια' then CHOOSE( iif (p.productid%5=0,1,p.productid%5),'NUVELLE','BOSCH','DAIKIN','INVENTOR','PITSOS') + ' AC τοίχου-' + right(N'00' + reverse(CAST(p.productid as varchar)) + '00',16)
	when 'Επιτραπέζια' then CHOOSE( iif (p.productid%5=0,1,p.productid%5),'NUVELLE','BOSCH','DAIKIN','INVENTOR','PITSOS') + ' AC τραπεζιού-' + right(N'00' + reverse(CAST(p.productid as varchar)) + '00',16)
	when 'Επιδαπέδια' then CHOOSE( iif (p.productid%5=0,1,p.productid%5),'NUVELLE','BOSCH','DAIKIN','INVENTOR','PITSOS') + ' AC δαπέδου-' + right(N'00' + reverse(CAST(p.productid as varchar)) + '00',16)
	when 'Laser' then CHOOSE( iif (p.productid%5=0,1,p.productid%5),'EPSON','CANON','LEXMARK','XEROX','RICOH') + ' Laser Printer-' + right(N'00' + reverse(CAST(p.productid as varchar)) + '00',16)
	when 'InkJet' then CHOOSE( iif (p.productid%5=0,1,p.productid%5),'EPSON','CANON','LEXMARK','XEROX','RICOH') + ' InkJet Printer-' + right(N'00' + reverse(CAST(p.productid as varchar)) + '00',16)
	when 'Tank' then CHOOSE( iif (p.productid%5=0,1,p.productid%5),'EPSON','CANON','LEXMARK','XEROX','RICOH') + ' Tank Printer-' + right(N'00' + reverse(CAST(p.productid as varchar)) + '00',16)
	when 'Πολυμηχανήματα' then CHOOSE( iif (p.productid%5=0,1,p.productid%5),'EPSON','CANON','LEXMARK','XEROX','RICOH') + ' Πολυμηχάνημα-' + right(N'00' + reverse(CAST(p.productid as varchar)) + '00',16)
	end,
	unitprice = ROUND(
				case s.subcategoryname 
				when 'Desktop PC' then (RAND(CHECKSUM(NEWID()))*(5400-800+1)+800) 
				when 'Laptop' then (RAND(CHECKSUM(NEWID()))*(5400-800+1)+800)
				when 'Monitor' then (RAND(CHECKSUM(NEWID()))*(2400-150+1)+150)
				when 'Keyboard' then (RAND(CHECKSUM(NEWID()))*(200-80+1)+80)
				when 'Mouse' then (RAND(CHECKSUM(NEWID()))*(200-40+1)+40)
				when '5G' then (RAND(CHECKSUM(NEWID()))*(2400-1200+1)+1200)
				when '4G' then (RAND(CHECKSUM(NEWID()))*(800-300+1)+300)
				when '3G' then (RAND(CHECKSUM(NEWID()))*(500-200+1)+200)
				when 'TV' then (RAND(CHECKSUM(NEWID()))*(1500-400+1)+400)
				when 'Smart TV' then (RAND(CHECKSUM(NEWID()))*(2400-800+1)+800)
				when 'Τηλεκατευθυνόμενα' then (RAND(CHECKSUM(NEWID()))*(700-250+1)+250)
				when 'Κλασσικά' then (RAND(CHECKSUM(NEWID()))*(100-10+1)+10)
				when 'Δημιουργικά' then (RAND(CHECKSUM(NEWID()))*(80-8+1)+8)
				when 'Επιτραπέζια' then (RAND(CHECKSUM(NEWID()))*(70-10+1)+10)
				when 'Υπολογιστών' then (RAND(CHECKSUM(NEWID()))*(150-80+1)+80)
				when 'Consoles' then (RAND(CHECKSUM(NEWID()))*(200-80+1)+80)
				when 'Ψυγεία' then (RAND(CHECKSUM(NEWID()))*(1200-200+1)+200)
				when 'Πλυντήρια' then (RAND(CHECKSUM(NEWID()))*(860-280+1)+280)
				when 'Κουζίνες' then (RAND(CHECKSUM(NEWID()))*(1100-380+1)+380)
				when 'Τραπέζια' then (RAND(CHECKSUM(NEWID()))*(400-50+1)+50)
				when 'Καρέκλες' then (RAND(CHECKSUM(NEWID()))*(400-80+1)+80)
				when 'Καναπέδες' then (RAND(CHECKSUM(NEWID()))*(1400-380+1)+380)
				when 'Σαλόνια' then (RAND(CHECKSUM(NEWID()))*(2400-600+1)+600)
				when 'Χαρτί' then (RAND(CHECKSUM(NEWID()))*(40-8+1)+8)
				when 'Σημειωματάρια' then (RAND(CHECKSUM(NEWID()))*(50-25+1)+25)
				when 'Γόμες' then (RAND(CHECKSUM(NEWID()))*(2-0.4+0.1)+0.4)
				when 'Κλασέρ' then (RAND(CHECKSUM(NEWID()))*(4-2+1)+2)
				when 'Ντοσιέ' then (RAND(CHECKSUM(NEWID()))*(3.5-1.5+0.1)+1.5)
				when 'Στυλο' then (RAND(CHECKSUM(NEWID()))*(3.5-0.10+0.1)+0.10)
				when 'Πένες' then (RAND(CHECKSUM(NEWID()))*(4000-120+1)+120)
				when 'Μαρκαδόροι' then (RAND(CHECKSUM(NEWID()))*(5-1+0.1)+1)
				when 'Μολύβια' then (RAND(CHECKSUM(NEWID()))*(1.5-0.5+0.5)+0.5)
				when 'Επιτοίχια' then (RAND(CHECKSUM(NEWID()))*(1400-800+1)+800)
				when 'Επιτραπέζια' then (RAND(CHECKSUM(NEWID()))*(200-80+1)+80)
				when 'Επιδαπέδια' then (RAND(CHECKSUM(NEWID()))*(400-100+1)+100)
				when 'Laser' then (RAND(CHECKSUM(NEWID()))*(800-100+1)+100)
				when 'InkJet' then (RAND(CHECKSUM(NEWID()))*(700-100+1)+100)
				when 'Tank' then (RAND(CHECKSUM(NEWID()))*(600-200+1)+200)
				when 'Πολυμηχανήματα' then (RAND(CHECKSUM(NEWID()))*(1400-400+1)+400)
				end,2)
	from products.Products as p
	inner join products.SubCategories as s on p.subcategoryid = s.subcategoryid;

	--select * from products.Products;
end
GO

create or alter proc [dfi].[GenerateShippers]
						@numofShippers int = 50
as
begin
	set nocount on;

	-- VARIABLES
	declare @i int = 1;
	declare @cities int, @streets int, @gnames int
	declare @rname int = 0;
	declare @rcity int = 0;
	declare @rstreet int = 0;


	declare -- Shippers
		@custid int,
		@companyname nvarchar(40),
		@contactname nvarchar(30),
		@contacttitle nvarchar(30),
		@vatnumber nvarchar(10),
		@address nvarchar(80),
		@city nvarchar(30),
		@postalcode int,
		@region nvarchar(50),
		@perfecture nvarchar(50),
		@country nvarchar(15),
		@phone nvarchar(16),
		@email nvarchar(256),
		@emaildomain nvarchar(256);

	select @cities = count(*) from dfi.cities;
	select @streets = count(*) from dfi.streets;
	select @gnames = count(*) from dfi.GreekNames;

	-- TRUNCATE TABLES
	--truncate table products.Suppliers;

	-- SUPPLIERS TABLE
	set @i=1
	while ( @i<=@numofShippers )
	begin

		set @rname  = ABS(CHECKSUM(NewId())) % @gnames;
		set @rcity  = ABS(CHECKSUM(NewId())) % @cities;
		set @rstreet= ABS(CHECKSUM(NewId())) % @streets;
		if @rstreet <= 0  set @rstreet = 1; 
		if @rcity <= 0 set @rcity = 1;

		select	top(1) 
				@companyname = lastname + ' ' + left(firstname,1) + '. ' +
							   CHOOSE( iif (@i%6=0,1,@i%6),'Ο.Ε','Ε.Π.Ε','Α.Ε','Ε.Ε','Ι.Κ.Ε','ΚΟΙΝΣΕΠ'),
				@emaildomain = lastname + left(firstname,1) +
							   CHOOSE( iif (@i%6=0,1,@i%6),'ΟΕ','ΕΠΕ','ΑΕ','ΕΕ','ΙΚΕ','ΚΟΙΝΣΕΠ') + '.gr'
		from dfi.GreekNames where aa = @rname;
		--print @companyname

		select top(1) 
				@contactname =  lastname + ' ' + firstname
		from dfi.GreekNames where aa = iif(@rname-@i<=0,@rname+10,@rname-@i) 
		--print @contactname

		set @contacttitle = CHOOSE( iif (@i%9=0,1,@i%9),'CEO','CIO','COO','CFO','CTO','CCO','CHRM','CMO','CDO')
		--print @contacttitle

		set @vatnumber = left(cast(@rname as varchar)+cast(@rcity as varchar)+cast(@rstreet as varchar)+'0000000000',10)
		--print @vatnumber

		select	top(1) 
				@address = street + ' ' + cast(iif(@i%125=0,1,@i%125) as varchar)
		from dfi.streets where aa = @rstreet
		--print @address

		select	top(1) 
				@city = city,
				@postalcode = PostCode,
				@region = region,
				@perfecture = perfecture
		from dfi.cities where aa = iif(@rcity-@i<=0,@rcity+10,@rcity-@i)
		set @country = N'Ελλάδα';
		--print @city + ' ' + cast(@postalcode as varchar) + ' ' + @region + ' ' + @perfecture+ ' ' + @country

		set @phone = left('2'+ CAST(@postalcode as char(5)) + cast(@rname as varchar) + '0000000000',10)
		--print @phone;

		select @email = replace(lower(dbo.ConvertGreekToELOT743(@contactname)),' ','.')
				+ '@'
				+ lower(dbo.ConvertGreekToELOT743(@emaildomain))
		--print @contactname + ' ' + @email

		if ( @i%10 >= 7 ) -- english name
		begin
			select @companyname=dbo.ConvertGreekToELOT743(@companyname);
			select @contactname=dbo.ConvertGreekToELOT743(@contactname);
			select @address=dbo.ConvertGreekToELOT743(@address);
			select @city=dbo.ConvertGreekToELOT743(@city);
			select @region=dbo.ConvertGreekToELOT743(@region);
			select @perfecture=dbo.ConvertGreekToELOT743(@perfecture);
			select @country=dbo.ConvertGreekToELOT743(@country);
		end 

		insert into sales.Shippers([companyname], [contactname], [contacttitle], [vatnumber], [address], [city], [postalcode], [region], [perfecture], [country], [phone], [email])
		values (@companyname, @contactname, @contacttitle, @vatnumber, @address, @city, @postalcode, @region, @perfecture, @country, @phone, @email)

		if (@i%1000=0) waitfor delay '00:00:10';
		set @i+=1;
		--print cast(@i%1000 as varchar)
	end
	--select * from sales.Shippers
end
GO

create or alter proc [dfi].[GenerateSuppliers]
						@numofSuppliers int = 50
as
begin
	set nocount on;

	-- VARIABLES
	declare @i int = 1;
	declare @cities int, @streets int, @gnames int
	declare @rname int = 0;
	declare @rcity int = 0;
	declare @rstreet int = 0;


	declare -- Suppliers
		@custid int,
		@companyname nvarchar(40),
		@contactname nvarchar(30),
		@contacttitle nvarchar(30),
		@vatnumber nvarchar(10),
		@address nvarchar(80),
		@city nvarchar(30),
		@postalcode int,
		@region nvarchar(50),
		@perfecture nvarchar(50),
		@country nvarchar(15),
		@phone nvarchar(16),
		@email nvarchar(256),
		@emaildomain nvarchar(256);

	select @cities = count(*) from dfi.cities;
	select @streets = count(*) from dfi.streets;
	select @gnames = count(*) from dfi.GreekNames;

	-- TRUNCATE TABLES
	--truncate table products.Suppliers;

	-- SUPPLIERS TABLE
	set @i=1
	while ( @i<=@numofSuppliers )
	begin

		set @rname  = ABS(CHECKSUM(NewId())) % @gnames;
		set @rcity  = ABS(CHECKSUM(NewId())) % @cities;
		set @rstreet= ABS(CHECKSUM(NewId())) % @streets;
		if @rstreet <= 0  set @rstreet = 1; 
		if @rcity <= 0 set @rcity = 1;
		    
		select	top(1) 
				@companyname = lastname + ' ' + left(firstname,1) + '. ' +
							   CHOOSE( iif (@i%6=0,1,@i%6),'Ο.Ε','Ε.Π.Ε','Α.Ε','Ε.Ε','Ι.Κ.Ε','ΚΟΙΝΣΕΠ'),
				@emaildomain = lastname + left(firstname,1) +
							   CHOOSE( iif (@i%6=0,1,@i%6),'ΟΕ','ΕΠΕ','ΑΕ','ΕΕ','ΙΚΕ','ΚΟΙΝΣΕΠ') + '.gr'
		from dfi.GreekNames where aa = @rname;
		--print @companyname

		select top(1) 
				@contactname =  lastname + ' ' + firstname
		from dfi.GreekNames where aa = iif(@rname-@i<=0,@rname+10,@rname-@i) 
		--print @contactname

		set @contacttitle = CHOOSE( iif (@i%9=0,1,@i%9),'CEO','CIO','COO','CFO','CTO','CCO','CHRM','CMO','CDO')
		--print @contacttitle

		set @vatnumber = left(cast(@rname as varchar)+cast(@rcity as varchar)+cast(@rstreet as varchar)+'0000000000',10)
		--print @vatnumber

		select	top(1) 
				@address = street + ' ' + cast(iif(@i%125=0,1,@i%125) as varchar)
		from dfi.streets where aa = @rstreet
		--print @address

		select	top(1) 
				@city = city,
				@postalcode = PostCode,
				@region = region,
				@perfecture = perfecture
		from dfi.cities where aa = iif(@rcity-@i<=0,@rcity+10,@rcity-@i)
		set @country = N'Ελλάδα';
		--print @city + ' ' + cast(@postalcode as varchar) + ' ' + @region + ' ' + @perfecture+ ' ' + @country

		set @phone = left('2'+ CAST(@postalcode as char(5)) + cast(@rname as varchar) + '0000000000',10)
		--print @phone;

		select @email = replace(lower(dbo.ConvertGreekToELOT743(@contactname)),' ','.')
				+ '@'
				+ lower(dbo.ConvertGreekToELOT743(@emaildomain))
		
		--print @contactname + ' ' + @email

		if ( @i%10 >= 7 ) -- english name
		begin
			select @companyname=dbo.ConvertGreekToELOT743(@companyname);
			select @contactname=dbo.ConvertGreekToELOT743(@contactname);
			select @address=dbo.ConvertGreekToELOT743(@address);
			select @city=dbo.ConvertGreekToELOT743(@city);
			select @region=dbo.ConvertGreekToELOT743(@region);
			select @perfecture=dbo.ConvertGreekToELOT743(@perfecture);
			select @country=dbo.ConvertGreekToELOT743(@country);
		end 
		insert into products.Suppliers([companyname], [contactname], [contacttitle], [vatnumber], [address], [city], [postalcode], [region], [perfecture], [country], [phone], [email])
		values (@companyname, @contactname, @contacttitle, @vatnumber, @address, @city, @postalcode, @region, @perfecture, @country, @phone, @email)

		if (@i%1000=0) waitfor delay '00:00:10';
		set @i+=1;
		--print cast(@i%1000 as varchar)
	end
	--select * from products.suppliers
end
GO

create  or alter proc [dfi].[ReGenerateData] 
					@numofCustomers			int = 5000,
					@numofSuppliers			int = 500,
					@numofEmployees			int = 500,
					@numofProducts			int = 2000,
					@numofShippers			int = 200,
					@numofOrders			int = 100000,
					@maxItemsInOrder		int = 5,
					@calendarstartdate		date = null,
					@calendarnumberofyears	int = null
as 
begin
	set nocount on;

	-- clear data
	exec [dfi].[ClearData] 
	
	-- do job
	raiserror ('generate %d row(s) for customers table',0,1,@numofCustomers) with nowait;
	exec dfi.GenerateCustomers @numofCustomers;

	raiserror ('generate %d row(s) for shippers table',0,1,@numofShippers) with nowait;
	exec dfi.GenerateShippers @numofShippers;
	
	raiserror ('generate %d row(s) for employees table',0,1,@numofEmployees) with nowait;
	exec dfi.GenerateEmployees @numofEmployees;

	raiserror ('generate %d row(s) for suppliers table',0,1,@numofSuppliers) with nowait;
	exec dfi.GenerateSuppliers @numofSuppliers;
	
	raiserror ('generate %d row(s) for products table',0,1,@numofProducts) with nowait;
	exec dfi.GenerateProducts  @numofProducts;

	raiserror ('generate %d row(s) for orders header table with max %d rows in order items table',0,1,@numofOrders,@maxItemsInOrder) with nowait;
	exec dfi.GenerateOrders @numofOrders,@maxItemsInOrder;

	raiserror ('generate %d years for bi calendar table',0,1,10) with nowait;
	exec bi.GenerateCalendar @calendarstartdate, @calendarnumberofyears;

end
GO

EXEC sys.sp_addextendedproperty @name=N'microsoft_database_tools_support', @value=N'Hide' , @level0type=N'SCHEMA',@level0name=N'dfi', @level1type=N'PROCEDURE',@level1name=N'ClearData'
GO
EXEC sys.sp_addextendedproperty @name=N'microsoft_database_tools_support', @value=N'Hide' , @level0type=N'SCHEMA',@level0name=N'dfi', @level1type=N'PROCEDURE',@level1name=N'GenerateCustomers'
GO
EXEC sys.sp_addextendedproperty @name=N'microsoft_database_tools_support', @value=N'Hide' , @level0type=N'SCHEMA',@level0name=N'dfi', @level1type=N'PROCEDURE',@level1name=N'GenerateEmployees'
GO
EXEC sys.sp_addextendedproperty @name=N'microsoft_database_tools_support', @value=N'Hide' , @level0type=N'SCHEMA',@level0name=N'dfi', @level1type=N'PROCEDURE',@level1name=N'GenerateOrders'
GO
EXEC sys.sp_addextendedproperty @name=N'microsoft_database_tools_support', @value=N'Hide' , @level0type=N'SCHEMA',@level0name=N'dfi', @level1type=N'PROCEDURE',@level1name=N'GenerateProducts'
GO
EXEC sys.sp_addextendedproperty @name=N'microsoft_database_tools_support', @value=N'Hide' , @level0type=N'SCHEMA',@level0name=N'dfi', @level1type=N'PROCEDURE',@level1name=N'GenerateShippers'
GO
EXEC sys.sp_addextendedproperty @name=N'microsoft_database_tools_support', @value=N'Hide' , @level0type=N'SCHEMA',@level0name=N'dfi', @level1type=N'PROCEDURE',@level1name=N'GenerateSuppliers'
GO
EXEC sys.sp_addextendedproperty @name=N'microsoft_database_tools_support', @value=N'Hide' , @level0type=N'SCHEMA',@level0name=N'dfi', @level1type=N'PROCEDURE',@level1name=N'ReGenerateData'
GO
