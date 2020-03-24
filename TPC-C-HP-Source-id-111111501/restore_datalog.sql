------------------------------------------------------------------
-- --
-- File: RESTORE.SQL --
-- Microsoft TPC-C Benchmark Kit Ver. 4.61 --
-- Copyright Microsoft, 2005 --
-- --
------------------------------------------------------------------
DECLARE @startdate DATETIME,
@enddate DATETIME
SELECT @startdate = GETDATE()
SELECT 'Start date:',
CONVERT(VARCHAR(30),@startdate, 21)
LOAD DATABASE tpcc FROM tpccback1, tpccback2, tpccback3, tpccback4, tpccback5, tpccback6, tpccback7, tpccback8, tpccback9, tpccback10, tpccback11, tpccback12, tpccback13, tpccback14, tpccback15, tpccback16 WITH stats = 1, replace, norecovery
SELECT @enddate = GETDATE()
SELECT 'End date: ',
CONVERT(VARCHAR(30),@enddate, 21)
SELECT 'Elapsed time (in seconds): ',
DATEDIFF(second, @startdate, @enddate)
GO
