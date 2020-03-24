------------------------------------------------------------------
-- --
-- File: IDXWARCL.SQL --
-- Microsoft TPC-C Benchmark Kit Ver. 4.68 --
-- Copyright Microsoft, 2006 --
-- --
-- Creates clustered index on warehouse table --
-- --
------------------------------------------------------------------
USE tpcc
GO
DECLARE @startdate DATETIME,
@enddate DATETIME
SELECT @startdate = GETDATE()
SELECT 'Start date:',
CONVERT(VARCHAR(30),@startdate,21)
IF EXISTS ( SELECT name FROM sysindexes WHERE name = 'warehouse_c1' )
DROP INDEX warehouse.warehouse_c1
CREATE UNIQUE CLUSTERED INDEX warehouse_c1 ON warehouse(w_id)
WITH FILLFACTOR=100 ON MSSQL_fg
SELECT @enddate = GETDATE()
SELECT 'End date:',
CONVERT(VARCHAR(30),@enddate,21)
SELECT 'Elapsed time (in seconds): ',
DATEDIFF(second, @startdate, @enddate)
GO
