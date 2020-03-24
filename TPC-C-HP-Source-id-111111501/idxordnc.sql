------------------------------------------------------------------
-- --
-- File: IDXORDNC.SQL --
-- Microsoft TPC-C Benchmark Kit Ver. 4.68 --
-- Copyright Microsoft,2006 --
-- --
-- Creates non-clustered index on orders table --
------------------------------------------------------------------
USE tpcc
GO
DECLARE @startdate DATETIME,
@enddate DATETIME
SELECT @startdate = GETDATE()
SELECT 'Start date:',
CONVERT(VARCHAR(30),@startdate,21)
IF EXISTS ( SELECT name FROM sysindexes WHERE name = 'orders_nc1' )
DROP INDEX orders.orders_nc1
CREATE INDEX orders_nc1 ON orders(o_w_id, o_d_id, o_c_id, o_id)
ON MSSQL_fg
SELECT @enddate = GETDATE()
SELECT 'End date:',
CONVERT(VARCHAR(30),@enddate,21)
SELECT 'Elapsed time (in seconds): ',
DATEDIFF(second, @startdate, @enddate)
GO
