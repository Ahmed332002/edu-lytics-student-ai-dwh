CREATE TABLE Dim_Date (
    [Date_SK] INT IDENTITY(1,1) PRIMARY KEY,
    [FullDate] DATE NOT NULL,
    [Year] INT NOT NULL,
    [Quarter] INT NOT NULL,
    [MonthNumber] INT NOT NULL,
    [MonthName] NVARCHAR(15) NOT NULL,
    [DayOfWeek] NVARCHAR(15) NOT NULL,
    [IsWeekend] CHAR(1) NOT NULL -- 'Y' or 'N'
);



------------------------------
DECLARE @StartDate DATE = '2024-01-01';
DECLARE @EndDate DATE = '2030-12-31';

WITH DateCTE AS (
    SELECT @StartDate AS CurrentDate
    UNION ALL
    SELECT DATEADD(DAY, 1, CurrentDate)
    FROM DateCTE
    WHERE CurrentDate < @EndDate
)
INSERT INTO Dim_Date (FullDate, [Year], [Quarter], [MonthNumber], [MonthName], [DayOfWeek], [IsWeekend])
SELECT 
    CurrentDate AS FullDate,
    YEAR(CurrentDate) AS [Year],
    DATEPART(QUARTER, CurrentDate) AS [Quarter],
    MONTH(CurrentDate) AS [MonthNumber],
    DATENAME(MONTH, CurrentDate) AS [MonthName],
    DATENAME(WEEKDAY, CurrentDate) AS [DayOfWeek],
    CASE WHEN DATENAME(WEEKDAY, CurrentDate) IN ('Friday', 'Saturday') THEN 'Y' ELSE 'N' END AS IsWeekend
FROM DateCTE
OPTION (MAXRECURSION 0);


---------------------------------------------------------

CREATE TABLE Watermark_Log (
    TableName NVARCHAR(50) PRIMARY KEY,
    Last_Load_ID INT
);


INSERT INTO Watermark_Log (TableName, Last_Load_ID)
VALUES ('Fact_Sessions', 0);

---------------------
DROP TABLE Watermark_Log;