------------------------------------------------------------------
-- --
-- File: VERSION.SQL --
-- Microsoft TPC-C Benchmark Kit Ver. 4.68 --
-- Copyright Microsoft, 2006 --
-- --
-- Returns version level of TPC-C stored procs --
-- --
-- Always update the return value of this proc for --
-- any interface changes or 'must have' bug fixes. --
-- --
-- The value returned by this SP defines the --
-- 'interface level', which must match between the --
-- stored procs and the client code. The --
-- interface level may be down rev from the --
-- current kit. This indicates that the interface --
-- hasn't changed since that version. --
-- --
-- Interface Level: 4.20.000 --
-- --
------------------------------------------------------------------
USE tpcc
GO
IF EXISTS ( SELECT name FROM sysobjects WHERE name = 'tpcc_version' )
DROP PROCEDURE tpcc_version
GO
CREATE PROCEDURE tpcc_version
AS
DECLARE @version char(8)
BEGIN
SELECT @version = '4.20.000'
SELECT @version AS 'Version'
END
