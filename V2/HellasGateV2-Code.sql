USE [HellasGateV2]
GO

create or alter proc [bi].[GenerateCalendar]
	@startdate DATE = NULL
,	@numberofyears INT = NULL

as
set nocount on;

if @startdate is null 
	set @startdate = DATETIMEFROMPARTS( year(cast(DATEADD(year,-5,getdate()) as date)),1,1,0,0,0,0);
if @numberofyears is null set @numberofyears = 10;
-- SET PREFFERED SETTINGS
SET DATEFIRST 7 -- 1=MONDAY , 7 = SUNDAY;
SET LANGUAGE US_ENGLISH;
SET DATEFORMAT YMD;


-- SET PERIOD
DECLARE @ISOQuarterType INT             = 445;   -- 445 = 4-4-5 , 544 = 5-4-4, 454 = 4-5-4
DECLARE @FiscalYearStartMonth INT       = 7;
DECLARE @FiscalYearStartMonthDay INT    = 1;
DECLARE @FiscalYearEndMonth INT         = 6;
DECLARE @FiscalYearEndMonthDay INT      = 30;
DECLARE @FiscalYear INT                 = 2;  -- 1 = Starting Year , 2 = Ending Year
DECLARE @NationalCulture NVARCHAR(20)   ='en-US';
DECLARE @LocalCulture NVARCHAR(20)      ='el-GR';

DECLARE @enddate DATE                   = DATEADD(YEAR, @numberofyears, @startdate);
DECLARE @cstartdate DATE;
IF ( @FiscalYearStartMonth > 1 ) 
    SET @cstartdate = DATEADD(YEAR, -2, @startdate);
ELSE
     SET @cstartdate = @startdate;

WITH r1
AS
(
    -- GENERATE DATA SET ROWS
    SELECT  TOP (DATEDIFF(DAY, @cstartdate, @enddate))
            ROW_NUMBER() OVER (ORDER BY s1.[object_id]) AS rn
    FROM sys.all_objects AS s1
    CROSS JOIN    sys.all_objects AS s2
    ORDER BY s1.[object_id]
), r2
AS
(
        -- GENERATE DATES OF CALENDAR
        SELECT 
                DateKey     = CONVERT(CHAR(8),DATEADD(DAY,rn-1,@cstartdate),112),
                DateValue   = DATEADD(DAY,rn-1,@cstartdate)
        FROM r1
), r3
as 
(
    SELECT 
            *, 
            MonthNameNational     = UPPER(FORMAT( DateValue, 'MMM', @NationalCulture )),
            MonthNameLocal        = UPPER(FORMAT( DateValue, 'MMM', @LocalCulture )),
            DayNameNational       = UPPER(FORMAT( DateValue, 'ddd', @NationalCulture )),
            DayNameLocal          = UPPER(FORMAT( DateValue, 'ddd', @LocalCulture )),
            IsWeekend             = CASE  WHEN DATEPART(weekday, DateValue) IN (DATEPART(weekday, '19000106'), -- Saturday
                                                                            DATEPART(weekday, '19000107')) -- Sunday
                                            THEN CAST(1 AS bit)
                                        ELSE CAST(0 AS bit)
                                    END,
            IsLeapYear            = CASE     DAY(DATEADD(day, -1, DATEFROMPARTS(YEAR(DateValue),3,1)))
                                    WHEN 29 THEN CAST(1 AS bit)
                                    ELSE CAST(0 AS bit)
                                    END,
            CYYear                = DATEPART(YEAR,DateValue),
            CYDay                 = DATEPART(DAYOFYEAR,DateValue),
            CYSemester            = ((DATEPART(QUARTER,DateValue)-1)/2)+1,
            CYQuarter             = DATEPART(QUARTER,DateValue),
            CYMonth               = DATEPART(MONTH,DateValue),
            CYWeek                = DATEPART(WEEK,DateValue),
            CYMonthDay            = DATEPART(DAY,DateValue),

            ISOYear               = YEAR(DATEADD(DAY,26-DATEPART(ISO_WEEK,DateValue),DateValue)),
            ISOWeek               = DATEPART(ISO_WEEK,DateValue),
        
            
            ISOMonth              = CASE @ISOQuarterType
                                    WHEN 445 THEN
                                        CASE
                                            WHEN DATEPART(ISO_WEEK,DateValue) BETWEEN 1 AND 4 THEN 1 
                                            WHEN DATEPART(ISO_WEEK,DateValue) BETWEEN 5 AND 8 THEN 2
                                            WHEN DATEPART(ISO_WEEK,DateValue) BETWEEN 9 AND 13 THEN 3

                                            WHEN DATEPART(ISO_WEEK,DateValue) BETWEEN 14 AND 17 THEN 4
                                            WHEN DATEPART(ISO_WEEK,DateValue) BETWEEN 18 AND 21 THEN 5
                                            WHEN DATEPART(ISO_WEEK,DateValue) BETWEEN 22 AND 26 THEN 6
                                            
                                            WHEN DATEPART(ISO_WEEK,DateValue) BETWEEN 27 AND 30 THEN 7
                                            WHEN DATEPART(ISO_WEEK,DateValue) BETWEEN 31 AND 34 THEN 8
                                            WHEN DATEPART(ISO_WEEK,DateValue) BETWEEN 35 AND 39 THEN 9
                                            
                                            WHEN DATEPART(ISO_WEEK,DateValue) BETWEEN 40 AND 43 THEN 10
                                            WHEN DATEPART(ISO_WEEK,DateValue) BETWEEN 44 AND 47 THEN 11
                                            WHEN DATEPART(ISO_WEEK,DateValue) BETWEEN 48 AND 53 THEN 12
                                        END
                                    WHEN 544 THEN 
                                        CASE
                                            WHEN DATEPART(ISO_WEEK,DateValue) BETWEEN 1 AND 5 THEN 1 
                                            WHEN DATEPART(ISO_WEEK,DateValue) BETWEEN 6 AND 9 THEN 2
                                            WHEN DATEPART(ISO_WEEK,DateValue) BETWEEN 10 AND 13 THEN 3

                                            WHEN DATEPART(ISO_WEEK,DateValue) BETWEEN 14 AND 18 THEN 4
                                            WHEN DATEPART(ISO_WEEK,DateValue) BETWEEN 19 AND 22 THEN 5
                                            WHEN DATEPART(ISO_WEEK,DateValue) BETWEEN 23 AND 26 THEN 6
                                            
                                            WHEN DATEPART(ISO_WEEK,DateValue) BETWEEN 27 AND 31 THEN 7
                                            WHEN DATEPART(ISO_WEEK,DateValue) BETWEEN 32 AND 35 THEN 8
                                            WHEN DATEPART(ISO_WEEK,DateValue) BETWEEN 36 AND 39 THEN 9
                                            
                                            WHEN DATEPART(ISO_WEEK,DateValue) BETWEEN 40 AND 44 THEN 10
                                            WHEN DATEPART(ISO_WEEK,DateValue) BETWEEN 45 AND 48 THEN 11
                                            WHEN DATEPART(ISO_WEEK,DateValue) BETWEEN 49 AND 53 THEN 12
                                        END

                                    WHEN 454 THEN 
                                        CASE
                                            WHEN DATEPART(ISO_WEEK,DateValue) BETWEEN 1 AND 4 THEN 1 
                                            WHEN DATEPART(ISO_WEEK,DateValue) BETWEEN 5 AND 9 THEN 2
                                            WHEN DATEPART(ISO_WEEK,DateValue) BETWEEN 10 AND 13 THEN 3

                                            WHEN DATEPART(ISO_WEEK,DateValue) BETWEEN 14 AND 17 THEN 4
                                            WHEN DATEPART(ISO_WEEK,DateValue) BETWEEN 18 AND 22 THEN 5
                                            WHEN DATEPART(ISO_WEEK,DateValue) BETWEEN 23 AND 26 THEN 6
                                            
                                            WHEN DATEPART(ISO_WEEK,DateValue) BETWEEN 27 AND 30 THEN 7
                                            WHEN DATEPART(ISO_WEEK,DateValue) BETWEEN 31 AND 35 THEN 8
                                            WHEN DATEPART(ISO_WEEK,DateValue) BETWEEN 36 AND 39 THEN 9
                                            
                                            WHEN DATEPART(ISO_WEEK,DateValue) BETWEEN 40 AND 43 THEN 10
                                            WHEN DATEPART(ISO_WEEK,DateValue) BETWEEN 44 AND 48 THEN 11
                                            WHEN DATEPART(ISO_WEEK,DateValue) BETWEEN 49 AND 53 THEN 12
                                        END
                                  END  
    FROM r2
), r4
AS
(
    SELECT  * ,
            ISODay          = ROW_NUMBER() OVER ( PARTITION BY ISOYear ORDER BY ISOMonth ),
            ISOSemester     = IIF ( ISOMonth <=6 ,1,2),
            ISOQuarter      = CASE 
                                WHEN ISOMonth BETWEEN 1 AND 3 THEN 1
                                WHEN ISOMonth BETWEEN 4 AND 6 THEN 2
                                WHEN ISOMonth BETWEEN 7 AND 9 THEN 3
                                WHEN ISOMonth BETWEEN 10 AND 12 THEN 4
                              END,
            FYFirstDate     = CAST ('19000101' AS DATE),
            FYLastDate      = CAST ('19000101' AS DATE),
            FYYear          = CAST (1900 AS INT)
    FROM r3
)
SELECT *
INTO #T
FROM    r4;

WITH fy1
AS
(
        SELECT DISTINCT CYYear,
            FiscalYearStartDate = DATEADD(YEAR , IIF(@FiscalYearStartMonth>1,-1,0) ,DATEFROMPARTS(CYYear,@FiscalYearStartMonth,@FiscalYearStartMonthDay)),
            FiscalYearEndDate = DATEFROMPARTS(CYYear,@FiscalYearEndMonth,@FiscalYearEndMonthDay)
        FROM #T
    UNION
        SELECT MIN (CYYear) - 1,
            DATEADD(YEAR , IIF(@FiscalYearStartMonth>1,-1,0) ,DATEFROMPARTS(MIN (CYYear) - 1,@FiscalYearStartMonth,@FiscalYearStartMonthDay)),
            DATEFROMPARTS(MIN (CYYear) - 1,@FiscalYearEndMonth,@FiscalYearEndMonthDay)
        FROM #T
    UNION
        SELECT MAX (CYYear) + 1,
            DATEADD(YEAR ,IIF(@FiscalYearStartMonth>1,-1,0) ,DATEFROMPARTS(MAX (CYYear) + 1,@FiscalYearStartMonth,@FiscalYearStartMonthDay)),
            DATEFROMPARTS(MAX (CYYear) + 1,@FiscalYearEndMonth,@FiscalYearEndMonthDay)
        FROM #T
)
UPDATE T
SET FYFirstDate   =    (SELECT fy1.FiscalYearStartDate FROM fy1 WHERE    T.DateValue BETWEEN fy1.FiscalYearStartDate AND fy1.FiscalYearEndDate),
    FYLastDate    =    (SELECT fy1.FiscalYearEndDate FROM fy1 WHERE    T.DateValue BETWEEN fy1.FiscalYearStartDate AND fy1.FiscalYearEndDate)
FROM #T AS T;

UPDATE #T
SET FYYear = DATEPART(YEAR,CHOOSE(@FiscalYear,FYFirstDate,FYLastDate));



WITH r1
AS
(
    SELECT  * ,
            FYDay       = ROW_NUMBER() OVER (PARTITION BY FYYear ORDER BY DateValue),
            FYMonth     = DATEPART(MONTH, DATEADD(MONTH, 13-@FiscalYearStartMonth, DateValue)),
            FYSemester  = ((DATEPART(QUARTER,DATEADD(MONTH, 13-@FiscalYearStartMonth, DateValue))-1)/2)+1,
            FYQuarter   = DATEPART(QUARTER, DATEADD(MONTH, 13-@FiscalYearStartMonth, DateValue)),
            FYWeek      = IIF ( DATEDIFF(WEEK,FYFirstDate,FYLastDate) - DATEDIFF(WEEK,DateValue,FYLastDate) = 0 , 1, DATEDIFF(WEEK,FYFirstDate,FYLastDate) - DATEDIFF(WEEK,DateValue,FYLastDate) )
    FROM #T
), r2
AS
(
    SELECT  ISOYear,
            ISOFirstDate  = MIN(DateValue),
            ISOLastDate   = MAX(DateValue)
    FROM r1
    GROUP by ISOYear
), r3
AS
(
    SELECT  
            -- Key Fields
            DateKey,
            DateValue,

            -- Common Fields

            MonthNameNational,
            DayNameNational,
            MonthNameLocal,
            DayNameLocal,
            IsWeekend,
            IsLeapYear,

            -- Calnedar Year Fields

            CYYear,
            CYYearName           = CONCAT('CY ', CYYear ),
            CYSemester,
            CYSemesterName       = CONCAT('CY ', CYYear, ' H0', CYSemester ),
            CYQuarter,
            CYQuarterName        = CONCAT('CY ', CYYear, ' Q0', CYSemester ),
            CYSemesterQuarter    = DENSE_RANK() OVER ( PARTITION BY CYYear,CYSemester ORDER BY CYYear,CYSemester,CYQuarter ),
            CYMonth,
            CYMonthName          = CONCAT('CY ', CYYear, ' M', RIGHT('00'+CAST ( CYMonth as varchar(2)),2) ),
            CYSemesterMonth      = DENSE_RANK() OVER ( PARTITION BY CYYear,CYSemester ORDER BY CYYear,CYSemester,CYMonth ),
            CYQuarterMonth       = DENSE_RANK() OVER ( PARTITION BY CYYear,CYQuarter ORDER BY CYYear,CYQuarter,CYMonth ),
            CYWeek,
            CYWeekName           = CONCAT('CY ', CYYear, ' W', RIGHT('00'+CAST ( CYWeek as varchar(2)),2) ),
            CYSemesterWeek       = DENSE_RANK() OVER ( PARTITION BY CYYear,CYSemester ORDER BY CYYear,CYSemester,CYWeek ),
            CYQuarterWeek        = DENSE_RANK() OVER ( PARTITION BY CYYear,CYQuarter ORDER BY CYYear,CYQuarter,CYWeek ),
            CYMonthWeek          = DATEPART(WEEK, DateValue) + 1- DATEPART(WEEK, DATEFROMPARTS(DATEPART(YEAR, DateValue),DATEPART(MONTH, DateValue),1)),
            CYDay,
            CYSemesterDay        = ROW_NUMBER() OVER ( PARTITION BY CYYear,CYSemester ORDER BY CYYear,CYSemester ),
            CYQuarterDay         = ROW_NUMBER() OVER ( PARTITION BY CYYear,CYQuarter  ORDER BY CYYear,CYQuarter ),
            CYMonthDay,
            CYWeekDay            = ROW_NUMBER() OVER ( PARTITION BY CYYear,CYWeek  ORDER BY CYYear,CYWeek ),
            CYFirstDate          = CONVERT(DATE,DATEADD(YEAR,DATEDIFF(YEAR,'19000101',DateValue),'19000101')),
            CYLastDate           = CONVERT(DATE,DATEADD(DAY,-1, DATEADD(YEAR,DATEDIFF(YEAR,'19000101',DateValue)+1,'19000101'))),

            -- Fiscal Year Fields

            FYYear,
            FYYearName           = CONCAT('FY ', FYYear ),
            FYSemester,
            FYSemesterName       = CONCAT('FY ', FYYear, ' H0', FYSemester ),
            FYQuarter,
            FYSemesterQuarter    = DENSE_RANK() OVER ( PARTITION BY FYYear,FYSemester ORDER BY FYYear,FYSemester,FYQuarter ),
            FYMonth,
            FYMonthName          = CONCAT('FY ', FYYear, ' M', RIGHT('00'+CAST ( FYMonth as varchar(2)),2) ),
            FYSemesterMonth      = DENSE_RANK() OVER ( PARTITION BY FYYear,FYSemester ORDER BY FYYear,FYSemester,FYMonth ),
            FYQuarterMonth       = DENSE_RANK() OVER ( PARTITION BY FYYear,FYQuarter ORDER BY FYYear,FYQuarter,FYMonth ),
            FYWeek,
            FYWeekName           = CONCAT('FY ', CYYear, ' W', RIGHT('00'+CAST ( FYWeek as varchar(2)),2) ),
            FYSemesterWeek       = DENSE_RANK() OVER ( PARTITION BY FYYear,FYSemester ORDER BY FYYear,FYSemester,FYWeek ),
            FYQuarterWeek        = DENSE_RANK() OVER ( PARTITION BY FYYear,FYQuarter ORDER BY FYYear,FYQuarter,FYWeek ),
            FYMonthWeek          = DENSE_RANK() OVER (PARTITION BY FYYear,FYMonth ORDER BY FYYear,FYMonth, FYWeek),
            FYDay,
            FYSemesterDay        = ROW_NUMBER() OVER ( PARTITION BY FYYear,FYSemester ORDER BY FYYear,FYSemester ),
            FYQuarterDay         = ROW_NUMBER() OVER ( PARTITION BY FYYear,FYQuarter  ORDER BY FYYear,FYQuarter ),
            FYMonthDay           = ROW_NUMBER() OVER ( PARTITION BY FYYear,FYMonth  ORDER BY FYYear,FYMonth ),
            FYWeekDay            = ROW_NUMBER() OVER ( PARTITION BY FYYear,FYWeek  ORDER BY FYYear,FYWeek ),
            FYFirstDate,
            FYLastDate,

            -- ISO Year Fields

            r1.ISOYear,
            ISOYearName          = CAST(r1.ISOYear as char(4) ),
            ISOSemester,
            ISOSemesterName      = CONCAT(r1.ISOYear,'-H0',ISOSemester ),
            ISOQuarter,
            ISOQuarterName       = CONCAT(r1.ISOYear,'-Q0',ISOQuarter ),
            ISOSemesterQuarter   = DENSE_RANK() OVER ( PARTITION BY r1.ISOYear,ISOSemester ORDER BY r1.ISOYear,ISOSemester,ISOQuarter ),
            ISOMonth,
            ISOMonthName         = CONCAT(r1.ISOYear,'-M',RIGHT('00'+CAST(ISOMonth as varchar(2)),2) ),
            ISOSemesterMonth     = DENSE_RANK() OVER ( PARTITION BY r1.ISOYear,ISOSemester ORDER BY r1.ISOYear,ISOSemester,ISOMonth ),
            ISOQuarterMonth      = DENSE_RANK() OVER ( PARTITION BY r1.ISOYear,ISOQuarter ORDER BY r1.ISOYear,ISOQuarter,ISOMonth ),
            ISOWeek,
            ISOWeekName          = CONCAT(r1.ISOYear,'-W',RIGHT('00'+CAST(ISOWeek as varchar(2)),2) ),
            ISOSemesterWeek      = DENSE_RANK() OVER ( PARTITION BY r1.ISOYear,ISOSemester ORDER BY r1.ISOYear,ISOSemester,ISOWeek ),
            ISOQuarterWeek       = DENSE_RANK() OVER ( PARTITION BY r1.ISOYear,ISOQuarter ORDER BY r1.ISOYear,ISOQuarter,ISOWeek ),
            ISOMonthWeek         = DENSE_RANK() OVER (PARTITION BY r1.ISOYear,ISOMonth ORDER BY r1.ISOYear,ISOMonth, ISOWeek),
            ISODay,
            ISOSemesterDay       = ROW_NUMBER() OVER ( PARTITION BY r1.ISOYear,ISOSemester ORDER BY r1.ISOYear,ISOSemester ),
            ISOQuarterDay        = ROW_NUMBER() OVER ( PARTITION BY r1.ISOYear,ISOQuarter  ORDER BY r1.ISOYear,ISOQuarter ),
            ISOMonthDay          = ROW_NUMBER() OVER ( PARTITION BY r1.ISOYear,ISOMonth  ORDER BY r1.ISOYear,ISOMonth ),
            ISOWeekDay           = ROW_NUMBER() OVER ( PARTITION BY r1.ISOYear,ISOWeek  ORDER BY r1.ISOYear,ISOWeek ),
            ISODayName           = CONCAT(r1.ISOYear,'-W',RIGHT('00'+CAST(ISOWeek as varchar(2)),2),'-', ROW_NUMBER() OVER ( PARTITION BY r1.ISOYear,ISOWeek  ORDER BY r1.ISOYear,ISOWeek )),
            ISOFirstDate,            
            ISOLastDate,

            -- HOILDAYS        

            IsNationalHoliday    = CAST (0 AS BIT ),
            IsLocalHoliday       = CAST (0 AS BIT ),
            HolidayName          = CAST (NULL AS NVARCHAR(100) )
    FROM    r1
    INNER JOIN r2 on r1.ISOYear = r2.ISOYear
)
SELECT * 
INTO #TT
FROM r3;



-- FIXED GREEK HOLIDAYS

UPDATE #TT
SET IsLocalHoliday = 1, IsNationalHoliday = 1,
    HolidayName = N'Πρωτοχρονιά / New Year''s Day'
WHERE CYMonthDay = 1 AND CYMonth = 1;

UPDATE #TT
SET IsLocalHoliday = 1,
    HolidayName = N'Θεοφάνεια (Greece)'
WHERE CYMonthDay = 6 AND CYMonth = 1;

UPDATE #TT
SET IsLocalHoliday = 1,
    HolidayName = N'Ευαγγελισμός της Θεοτόκου (Greece)'
WHERE CYMonthDay = 25 AND CYMonth = 3;

UPDATE #TT
SET IsLocalHoliday = 1,
    HolidayName = N'Εργατική Πρωτομαγιά (Greece)'
WHERE CYMonthDay = 1 AND CYMonth = 5;


UPDATE #TT
SET IsLocalHoliday = 1,
    HolidayName = N'Κοίμηση της Θεοτόκου (Greece)'
WHERE CYMonthDay = 15 AND CYMonth = 8;

UPDATE #TT
SET IsLocalHoliday = 1,
    HolidayName = N'Ημέρα του Όχι (Greece)'
WHERE CYMonthDay = 28 AND CYMonth = 10;

UPDATE #TT
SET IsLocalHoliday = 1, IsNationalHoliday = 1,
    HolidayName = N'Χριστούγεννα / Christmas '
WHERE CYMonthDay = 25 AND CYMonth = 12;

UPDATE #TT
SET IsLocalHoliday = 1,
    HolidayName = N'Σύναξη της Θεοτόκου (Greece)'
WHERE CYMonthDay = 26 AND CYMonth = 12;

-- ORTHDOX EASTER AND GREEK RELATED HOLIDAYS

WITH
    a
    AS
    (
        -- CALCULATE EASTER DATE FOR EACH YEAR IN DATA SET
        SELECT DISTINCT CYYear,
            DATEADD(DAY,13,DATEFROMPARTS(CYYear,
                            ((((19 * (CYYear%19) + 15)%30) + ((2 * (CYYear%4) + 4 * (CYYear%7) - ((19 * (CYYear%19) + 15)%30) +34)%7) + 114)/31),
                            (((((19 * (CYYear%19) + 15)%30) + ((2 * (CYYear%4) + 4 * (CYYear%7) - ((19 * (CYYear%19) + 15)%30) +34)%7) + 114)%31)+1))) AS GreekEasterDate
        FROM #TT
    ),
    b
    AS
    (
        -- CACLULATE RELATED TO EASTER HOLIDAYS
        SELECT CYYear ,
            DATEADD(DAY,-48,GreekEasterDate)    AS 'Καθαρά Δευτέρα',
            DATEADD(DAY,-2,GreekEasterDate)     AS 'Μ. Παρασκευή',
            DATEADD(DAY,-1,GreekEasterDate)     AS 'Μ. Σάββατο',
            GreekEasterDate                     AS 'Πάσχα',
            DATEADD(DAY,1,GreekEasterDate)      AS 'Δευτέρα του Πάσχα',
            DATEADD(DAY,49,GreekEasterDate)     AS 'Πεντηκοστή',
            DATEADD(DAY,50,GreekEasterDate)     AS 'Αγίου Πνεύματος'
        FROM a

    ),
    c
    AS
    (
        SELECT HolidayDate, HodidayName
        FROM b
    UNPIVOT ( HolidayDate FOR HodidayName IN ([Καθαρά Δευτέρα],[Μ. Παρασκευή],[Μ. Σάββατο],[Πάσχα],[Δευτέρα του Πάσχα],[Πεντηκοστή],[Αγίου Πνεύματος])) AS up
    )
-- UPDATE DATA SET
UPDATE T
SET IsLocalHoliday = 1,
    HolidayName = HodidayName + ' (Greece)'
FROM #TT AS T
    INNER JOIN c ON c.HolidayDate = t.DateValue;


-- CATHOLICS EASTER

WITH
    a
    AS
    (
        -- CALCULATE EASTER DATE FOR EACH YEAR IN DATA SET
        SELECT DISTINCT CYYear,
            DATEFROMPARTS(CYYear,    (3 + ((((24 + 19*(CYYear % 19)) % 30) - ((24 + 19*(CYYear % 19)) % 30)/ 28) - (CYYear + CYYear/4 + (((24 + 19*(CYYear % 19)) % 30) - ((24 + 19*(CYYear % 19)) % 30) / 28)- 13) % 7 + 40) / 44),
                            ((((24 + 19 * (CYYear % 19)) % 30) - ((24 + 19 * (CYYear % 19)) % 30) / 28) - ((CYYear + CYYear / 4 + (((24 + 19 * (CYYear % 19)) % 30) - ((24 + 19 * (CYYear % 19)) % 30) / 28) - 13) % 7)) + 
                            28 - 31 * ((3 + ((((24 + 19*(CYYear % 19)) % 30) - ((24 + 19*(CYYear % 19)) % 30)/ 28) - (CYYear + CYYear/4 + (((24 + 19*(CYYear % 19)) % 30) - ((24 + 19*(CYYear % 19)) % 30) / 28)- 13) % 7 + 40) / 44) / 4)) AS EasterDate
        FROM #TT
    ),
    b
    AS
    (
        -- CACLULATE RELATED TO EASTER HOLIDAYS
        SELECT CYYear ,
            DATEADD(DAY,-3,EasterDate)     AS 'G. Thursday',
            DATEADD(DAY,-2,EasterDate)     AS 'G. Friday',
            DATEADD(DAY,-1,EasterDate)     AS 'G. Saturday',
            EasterDate                     AS 'Catholics Easter',
            DATEADD(DAY,1,EasterDate)      AS 'Easter Monday'
        FROM a

    ),
    c
    AS
    (
        SELECT HolidayDate, HodidayName
        FROM b
        UNPIVOT ( HolidayDate FOR HodidayName IN ([G. Thursday], [G. Friday], [G. Saturday], [Catholics Easter], [Easter Monday]) ) AS up
    )
-- UPDATE DATA SET
UPDATE T
SET IsNationalHoliday = 1,
    HolidayName = CONCAT(HolidayName,HodidayName ,' (Catholics)')
FROM #TT AS T
    INNER JOIN c ON c.HolidayDate = t.DateValue

-- USA HOILDAYS

UPDATE #TT
SET IsNationalHoliday = 1,
    HolidayName = CONCAT(HolidayName,IIF(LEN(HolidayName)>0,' / ',''),'Martin Luther King, Jr. Day (USA)')
WHERE CYYear >= 1983 AND CYMonth = 1 AND CYMonthWeek = 3 AND DayNameNational='Mon';

UPDATE #TT
SET IsNationalHoliday = 1,
    HolidayName = CONCAT(HolidayName,IIF(LEN(HolidayName)>0,' / ',''),'President''s Day (USA)')
WHERE CYMonth = 2 AND CYMonthWeek = 3 AND DayNameNational='Mon';

UPDATE #TT
SET IsNationalHoliday = 1,
    HolidayName = CONCAT(HolidayName,IIF(LEN(HolidayName)>0,' / ',''),'Saint Patrick''s Day (USA)')
WHERE CYMonth = 3 AND CYMonthDay=17;

UPDATE #TT
SET IsNationalHoliday = 1,
    HolidayName = CONCAT(HolidayName,IIF(LEN(HolidayName)>0,' / ',''),'Memorial Day (USA)')
WHERE DateKey IN (SELECT MAX(DateKey) FROM #TT 
WHERE CYMonth = 5 AND DayNameNational='Mon'
GROUP BY CYYear, CYMonth
                );

UPDATE #TT
SET IsNationalHoliday = 1,
    HolidayName = CONCAT(HolidayName,IIF(LEN(HolidayName)>0,' / ',''),'Independance Day (USA)')
WHERE CYMonth = 7 AND CYMonthDay= 4;

UPDATE #TT
SET IsNationalHoliday = 1,
    HolidayName = CONCAT(HolidayName,IIF(LEN(HolidayName)>0,' / ',''),'Labor Day (USA)')
WHERE DateKey IN (
                    SELECT MIN(DateKey)
FROM #TT
WHERE CYMonth = 9 AND DayNameNational='Mon'
GROUP BY CYYear, CYMonth
                );

UPDATE #TT
SET IsNationalHoliday = 1,
    HolidayName = CONCAT(HolidayName,IIF(LEN(HolidayName)>0,' / ',''),'Columbus Day (USA)')
WHERE CYMonth = 10 AND CYMonthWeek = 2 AND DayNameNational='Mon';

UPDATE #TT
SET IsNationalHoliday = 1,
    HolidayName = CONCAT(HolidayName,IIF(LEN(HolidayName)>0,' / ',''),'Halloween (USA)')
WHERE CYMonth = 10 AND CYMonthDay = 31;

UPDATE #TT
SET IsNationalHoliday = 1,
    HolidayName = CONCAT(HolidayName,IIF(LEN(HolidayName)>0,' / ',''),'Veterans Day (USA)')
WHERE CYMonth = 11 AND CYMonthDay = 11;

UPDATE #TT
SET IsNationalHoliday = 1,
    HolidayName = CONCAT(HolidayName,IIF(LEN(HolidayName)>0,' / ',''),'Thanksgiving Day (USA)')
WHERE CYMonth = 11 AND CYMonthWeek = 4 AND DayNameNational='Thu';

-- EU INSTITUTIONS HOLIDAYS

UPDATE #TT
SET IsNationalHoliday = 1,
    HolidayName = CONCAT(HolidayName,IIF(LEN(HolidayName)>0,' / ',''),'2nd New Year''s Day (EU)')
WHERE CYMonth = 1 AND CYMonthDay = 2;

UPDATE #TT
SET IsNationalHoliday = 1,
    HolidayName = CONCAT(HolidayName,IIF(LEN(HolidayName)>0,' / ',''),'Labour Day (EU)')
WHERE CYMonth = 5 AND CYMonthDay = 1;

UPDATE #TT
SET IsNationalHoliday = 1,
    HolidayName = CONCAT(HolidayName,IIF(LEN(HolidayName)>0,' / ',''),'Europe Day (EU)')
WHERE CYMonth = 5 AND CYMonthDay = 9;

UPDATE #TT
SET IsNationalHoliday = 1,
    HolidayName = CONCAT(HolidayName,IIF(LEN(HolidayName)>0,' / ',''),'Ascension Thursday (EU)')
WHERE CYMonth = 5 AND CYMonthDay = 21;

UPDATE #TT
SET IsNationalHoliday = 1,
    HolidayName = CONCAT(HolidayName,IIF(LEN(HolidayName)>0,' / ',''),'the Friday following Ascension Day (EU)')
WHERE CYMonth = 5 AND CYMonthDay = 22;

UPDATE #TT
SET IsNationalHoliday = 1,
    HolidayName = CONCAT(HolidayName,IIF(LEN(HolidayName)>0,' / ',''),'Whit Monday (EU)')
WHERE CYMonth = 6 AND CYMonthDay = 1;

UPDATE #TT
SET IsNationalHoliday = 1,
    HolidayName = CONCAT(HolidayName,IIF(LEN(HolidayName)>0,' / ',''),'Belgian National Day (EU)')
WHERE CYMonth = 7 AND CYMonthDay = 21;

UPDATE #TT
SET IsNationalHoliday = 1,
    HolidayName = CONCAT(HolidayName,IIF(LEN(HolidayName)>0,' / ',''),'Assumption (EU)')
WHERE CYMonth = 8 AND CYMonthDay = 15;

UPDATE #TT
SET IsNationalHoliday = 1,
    HolidayName = CONCAT(HolidayName,IIF(LEN(HolidayName)>0,' / ',''),'All Saints'' Day (EU)')
WHERE CYMonth = 11 AND CYMonthDay = 1;

UPDATE #TT
SET IsNationalHoliday = 1,
    HolidayName = CONCAT(HolidayName,IIF(LEN(HolidayName)>0,' / ',''),'All Souls'' Day (EU)')
WHERE CYMonth = 11 AND CYMonthDay = 2;

UPDATE #TT
SET IsNationalHoliday = 1,
    HolidayName = CONCAT(HolidayName,IIF(LEN(HolidayName)>0,' / ',''),'End-of-year days (EU)')
WHERE CYMonth = 12 AND CYMonthDay = 24;

UPDATE #TT
SET IsNationalHoliday = 1,
    HolidayName = CONCAT(HolidayName,IIF(LEN(HolidayName)>0,' / ',''),'End-of-year days (EU)')
WHERE CYMonth = 12 AND CYMonthDay = 26;

UPDATE #TT
SET IsNationalHoliday = 1,
    HolidayName = CONCAT(HolidayName,IIF(LEN(HolidayName)>0,' / ',''),'End-of-year days (EU)')
WHERE CYMonth = 12 AND CYMonthDay = 27;

UPDATE #TT
SET IsNationalHoliday = 1,
    HolidayName = CONCAT(HolidayName,IIF(LEN(HolidayName)>0,' / ',''),'End-of-year days (EU)')
WHERE CYMonth = 12 AND CYMonthDay = 28;

UPDATE #TT
SET IsNationalHoliday = 1,
    HolidayName = CONCAT(HolidayName,IIF(LEN(HolidayName)>0,' / ',''),'End-of-year days (EU)')
WHERE CYMonth = 12 AND CYMonthDay = 29;

UPDATE #TT
SET IsNationalHoliday = 1,
    HolidayName = CONCAT(HolidayName,IIF(LEN(HolidayName)>0,' / ',''),'End-of-year days (EU)')
WHERE CYMonth = 12 AND CYMonthDay = 30;

UPDATE #TT
SET IsNationalHoliday = 1,
    HolidayName = CONCAT(HolidayName,IIF(LEN(HolidayName)>0,' / ',''),'End-of-year days (EU)')
WHERE CYMonth = 12 AND CYMonthDay = 31;

INSERT INTO bi.DimCalendar
SELECT *
FROM    #TT
WHERE DateValue >= @startdate
ORDER by DateKey;
GO

create or alter  proc [sales].[AddNewOrder] @maxItemsInOrder int = 5
as
begin
	set nocount on;

	-- VARIABLES
	declare 
		@i int = 1,
		@ncustomers int = 0,
		@nshippers int = 0,
		@nemployees int = 0,
		@nproducts int = 0,
		@items int = 0;
		
	declare @employees table (empid int);
	declare @products table (productid int);

	declare -- OrdersHeader
		@orderid int,
		@custid int,
		@empid int,
		@orderdate date,
		@requireddate date,
		@shipperid int,
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
	select @nproducts = count(*) from products.Products where isOutOfOrder = 0;
	insert into @products select productid from products.Products where isOutOfOrder = 0;
	select top(0) * into #ordersheader from sales.OrdersHeader;

	-- add rows in header
	set @custid = ABS(CHECKSUM(NewId())) % @ncustomers;
	if (@custid < 1 ) set @custid = (select max(custid) from sales.Customers);
		
	set @shipperid = ABS(CHECKSUM(NewId())) % @nshippers;
	if (@shipperid < 1 ) set @shipperid = (select max(shipperid) from sales.Shippers);

	set @empid = ABS(CHECKSUM(NewId())) % @nemployees;
	if (@empid < 1 ) set @empid = (select max(empid) from @employees);
		
	set @orderdate = cast(getdate() as date);
	set @requireddate = DATEADD(day,31,@orderdate);

	set @items = cast ( log10(ABS(CHECKSUM(NewId()))) as tinyint) - @maxItemsInOrder ;
	--print @items;
	
	
	begin try

		begin tran	
	
		insert into sales.OrdersHeader ([custid], [empid], [orderdate], [requireddate], [shipperid])
		values (@custid, @empid, @orderdate, @requireddate, @shipperid);
		set @orderid = SCOPE_IDENTITY();

		-- set  item rows per order
		while (@i < = @items)
		begin
			set @qty = 1;
			set @discount =0.0;
			set @productid = ABS(CHECKSUM(NewId())) % @nproducts 
			--print @productid

			select @productid = productid, @unitprice = unitprice
			from products.Products 
			where productid = @productid;
			--print @unitprice

			insert into sales.OrderItems([orderid], [productid], [unitprice], [qty], [discount])
			values (@orderid,@productid,@unitprice,@qty,@discount);

			set @i+=1;
		end
		commit;
	end try
	begin catch
		if (@@TRANCOUNT > 0 ) rollback;
		throw;
	end catch
end
GO

CREATE or alter   proc [sales].[OrdersShipping]
as
begin
	set nocount on;

	begin try
		begin tran
		update sales.OrdersHeader
		set 
			shippeddate = cast (GETDATE() as date),
			freight = (select round(sum(i.qty*i.unitprice) * 0.01,2) from sales.OrderItems as  i where i.orderid = sales.OrdersHeader.orderid),
			shipname = (select contactname from sales.Customers as c where c.custid = sales.OrdersHeader.custid),
			shipaddress = (select address from sales.Customers as c where c.custid = sales.OrdersHeader.custid),
			shipcity = (select city from sales.Customers as c where c.custid = sales.OrdersHeader.custid),
			shipregion = (select region from sales.Customers as c where c.custid = sales.OrdersHeader.custid),
			shippostalcode = (select postalcode from sales.Customers as c where c.custid = sales.OrdersHeader.custid),
			shipcountry = (select country from sales.Customers as c where c.custid = sales.OrdersHeader.custid)
		where 
			shippeddate is null;
		
		-- invoicing shipped orders

		insert into sales.InvoiceHeader([orderid], [custid], [invoicedate])
		select orderid, custid,shippeddate from sales.OrdersHeader
		where shippeddate =  cast (GETDATE() as date);
	
		insert into sales.InvoiceLines([invoiceid], [productid], [quantity], [unitprice], [netamount], [taxrate], [taxamount], [amount])
		select invoiceid, productid, qty, unitprice, round((qty*unitprice),2), 24.00, round((qty*unitprice) * 0.24,2), round(((qty*unitprice) * 1.24),2)
		from sales.InvoiceHeader as ih
		inner join sales.OrderItems as oi on ih.orderid = oi.orderid
		inner join sales.OrdersHeader as oh on oi.orderid = oh.orderid
		where shippeddate =  cast (GETDATE() as date);

		commit;
	end try
	begin catch
		rollback;
		throw;
	end catch

end
GO


create or alter function [dbo].[ConvertGreekToELOT743] (@gstring nvarchar(4000)) returns nvarchar(4000)
as
begin
	declare @rv nvarchar(4000)=''; -- return value
	
	-- elot mapping
	declare @elot table (c1 nvarchar(5), c2 nvarchar(5));
	insert into @elot values
	('α','a'),('αι','ai'),('άι','áï'),('αϊ','aï'),('αυ','av'),('β','v'),('γ','g'),
	('γγ','ng'),('γκ','gk'),('γξ','nx'),('γχ','nch'),('δ','d'),('ε','e'),('ει','ei'),
	('έι','éï'),('εϊ','eï'),('ευ','ev'),('ζ','z'),('η','i'),('ηυ','iv'),('θ','th'),
	('ι','i'),('κ','k'),('λ','l'),('μ','m'),('μπ','b'),('ν','n'),('ντ','nt'),('ξ','x'),
	('ο','o'),('οι','oi'),('όι','óï'),('οϊ','oï'),('ου','ou'),('π','p'),('ρ','r'),('σ','s'),
	('τ','t'),('υ','y'),('υι','yi'),('φ','f'),('χ','ch'),('ψ','ps'),('ω','o'),
	(' ',' '),('1','1'),('2','2'),('3','3'),('4','4'),('5','5'),('6','6'),('7','7'),('8','8'),
	('9','9'),('0','0'),('-','-'),('=','='),('~','~'),('!','!'),('@','@'),('#','#'),('$','$'),
	('%','%'),('^','^'),('&','&'),('*','*'),('(','('),(')',')'),('_','_'),('+','+'),('[','['),
	('{','{'),(']',']'),('}','}'),(';',';'),(':',':'),('''',''''),('"','"'),('\','\'),('|','|'),
	(',',','),('<','<'),('.','.'),('>','>'),('/','/'),('?','?'),('΄','΄');

	-- parse input text
	with ca as 
	(
		select stuff(@gstring,1,1,'') as txt, left(@gstring,1) as chr

		union all

		select stuff(txt,1,1,'') as txt, left(txt,1) as chr from ca
		where len(txt) > 0
	), a as 
	(
		select chr, chr+lead(chr,1) over (order by (select null)) as nchr
		from ca
	), b as
	(
		-- find mappings
		select * 
		, (select top(1) c2 from @elot where c1 = nchr) as dc
		, (select top(1) c2 from @elot where c1 = chr) as dcc
		from a
	), c as 
	(
		-- handle 2 chars in mapping
		select * , iif(chr=' ',2,iif(lag(dc,1) over (order by (select null)) is not null,1,2)) as h
		from b
	), d as 
	(
		select *,isnull(nullif(dc,dcc),dcc) as e
		from c
		where h=2
	)
	-- check capital chars and return value
	select @rv+=iif ((UNICODE(chr))!= UNICODE(lower(chr)),upper(left(e,1))+right(e,len(e)-1),e) from d
	if (UNICODE(left(@gstring,1))!= UNICODE(lower(left(@gstring,1))))
	begin
		set @rv = stuff(@rv,1,1,upper(left(@rv,1)))
	end
	return @rv;
end