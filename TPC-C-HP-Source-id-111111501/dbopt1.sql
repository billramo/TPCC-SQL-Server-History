------------------------------------------------------------------
-- --
-- File: DBOPT1.SQL --
-- Microsoft TPC-C Benchmark Kit Ver. 4.68 --
-- Copyright Microsoft, 2006 --
-- --
-- Sets database options for load --
-- --
------------------------------------------------------------------
USE master
GO
ALTER DATABASE tpcc SET RECOVERY BULK_LOGGED
GO
EXEC sp_dboption tpcc,'trunc. log on chkpt.',TRUE
GO
ALTER DATABASE tpcc SET TORN_PAGE_DETECTION OFF
GO
ALTER DATABASE tpcc SET PAGE_VERIFY NONE
GO
USE tpcc
GO
CHECKPOINT
GO
