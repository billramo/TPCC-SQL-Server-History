------------------------------------------------------------------
-- --
-- File: IDXITMCL.SQL --
-- Microsoft TPC-C Benchmark Kit Ver. 4.68 --
-- Copyright Microsoft, 2006 --
-- --
-- Creates clustered index on item table --
-- --
------------------------------------------------------------------
USE tpcc
GO
DECLARE @startdate DATETIME,
@enddate DATETIME
SELECT @startdate = GETDATE()
SELECT 'Start date:',
CONVERT(VARCHAR(30),@startdate,21)
IF EXISTS ( SELECT name FROM sysindexes WHERE name = 'item_c1' )
DROP INDEX item.item_c1
CREATE UNIQUE CLUSTERED INDEX item_c1 ON item(i_id)
ON MSSQL_fg
SELECT @enddate = GETDATE()
SELECT 'End date:',
CONVERT(VARCHAR(30),@enddate,21)
SELECT 'Elapsed time (in seconds): ',
DATEDIFF(second, @startdate, @enddate)
GO
