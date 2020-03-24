------------------------------------------------------------------
-- --
-- File: BACKUP.SQL --
-- Microsoft TPC-C Benchmark Kit Ver. 4.61 --
-- Copyright Microsoft, 2005 --
------------------------------------------------------------------
DECLARE @startdate DATETIME,
@enddate DATETIME
SELECT @startdate = GETDATE()
SELECT 'Start date:',
CONVERT(VARCHAR(30),@startdate, 21)
BACKUP DATABASE tpcc TO tpccback1031681, tpccback1031682, tpccback1031683, tpccback1031684, tpccback1031685, tpccback1031686, tpccback1031687, tpccback1031688, tpccback1031689, tpccback10316810, tpccback10316811 WITH init, stats = 1
SELECT @enddate = GETDATE()
SELECT 'End date: ',
CONVERT(VARCHAR(30),@enddate, 21)
SELECT 'Elapsed time (in seconds): ',
DATEDIFF(second, @startdate, @enddate)
GO
