------------------------------------------------------------------
-- --
-- File: IDXCUSNC.SQL --
-- Microsoft TPC-C Benchmark Kit Ver. 4.68 --
-- Copyright Microsoft, 2006 --
-- --
-- Creates non-clustered index on customer table --
------------------------------------------------------------------
USE tpcc
GO
DECLARE @startdate DATETIME,
@enddate DATETIME
SELECT @startdate = GETDATE()
SELECT 'Start date:',
CONVERT(VARCHAR(30),@startdate,21)
IF EXISTS ( SELECT name FROM sysindexes WHERE name = 'customer_nc1' )
DROP INDEX customer.customer_nc1
CREATE UNIQUE NONCLUSTERED INDEX customer_nc1 ON customer(c_w_id, c_d_id, c_last, c_first, c_id)
ON MSSQL_fg
SELECT @enddate = GETDATE()
SELECT 'End date:',
CONVERT(VARCHAR(30),@enddate,21)
SELECT 'Elapsed time (in seconds): ',
DATEDIFF(second, @startdate, @enddate)
GO
