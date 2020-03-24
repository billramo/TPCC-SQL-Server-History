------------------------------------------------------------------
-- --
-- File: DBOPT2.SQL --
-- Microsoft TPC-C Benchmark Kit Ver. 4.68 --
-- Copyright Microsoft, 2006 --
-- --
-- Sets database options after load --
-- --
------------------------------------------------------------------
ALTER DATABASE tpcc SET RECOVERY FULL
GO
USE tpcc
GO
CHECKPOINT
GO
sp_configure 'allow updates',1
GO
RECONFIGURE WITH OVERRIDE
GO
DECLARE @msg varchar(50)
------------------------------------------------
-- OPTIONS FOR SQL SERVER 2000 --
-- Set option values for user-defined indexes --
------------------------------------------------
SET @msg = ' '
PRINT @msg
SET @msg = 'Setting SQL Server indexoptions'
PRINT @msg
SET @msg = ' '
PRINT @msg
EXEC sp_indexoption 'customer', 'DisAllowPageLocks', TRUE
EXEC sp_indexoption 'district', 'DisAllowPageLocks', TRUE
EXEC sp_indexoption 'warehouse', 'DisAllowPageLocks', TRUE
EXEC sp_indexoption 'stock', 'DisAllowPageLocks', TRUE
EXEC sp_indexoption 'order_line', 'DisAllowRowLocks', TRUE
EXEC sp_indexoption 'orders', 'DisAllowRowLocks', TRUE
EXEC sp_indexoption 'new_order', 'DisAllowRowLocks', TRUE
EXEC sp_indexoption 'item', 'DisAllowRowLocks', TRUE
EXEC sp_indexoption 'item', 'DisAllowPageLocks', False
GO
Print ' '
Print '******************'
Print 'Pre-specified Locking Hierarchy:'
Print ' Lockflag = 0 ==> No pre-specified hierarchy'
Print ' Lockflag = 1 ==> Lock at Page-level then Table-level'
Print ' Lockflag = 2 ==> Lock at Row-level then Table-level'
Print ' Lockflag = 3 ==> Lock at Table-level'
Print ' '
SELECT name,
lockflags
FROM sysindexes
WHERE object_id('warehouse') = id OR
object_id('district') = id OR
object_id('customer') = id OR
object_id('stock') = id OR
object_id('orders') = id OR
object_id('order_line') = id OR
object_id('history') = id OR
object_id('new_order') = id OR
object_id('item') = id
ORDER BY lockflags asc
GO
sp_configure 'allow updates',0
GO
RECONFIGURE WITH OVERRIDE
GO
EXEC sp_dboption tpcc, 'auto update statistics', FALSE
EXEC sp_dboption tpcc, 'auto create statistics', FALSE
GO
DECLARE @db_id int,
@tbl_id int
SET @db_id = DB_ID('tpcc')
SET @tbl_id = OBJECT_ID('tpcc..warehouse')
DBCC PINTABLE (@db_id, @tbl_id)
SET @tbl_id = OBJECT_ID('tpcc..district')
DBCC PINTABLE (@db_id, @tbl_id)
SET @tbl_id = OBJECT_ID('tpcc..new_order')
DBCC PINTABLE (@db_id, @tbl_id)
SET @tbl_id = OBJECT_ID('tpcc..item')
DBCC PINTABLE (@db_id, @tbl_id)
GO
