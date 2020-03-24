------------------------------------------------------------------
-- --
-- File: CREATEDB.SQL --
-- Microsoft TPC-C Benchmark Kit Ver. 4.68 --
-- Copyright Microsoft, 2005 --
-- --
------------------------------------------------------------------
SET ANSI_NULL_DFLT_OFF ON
GO
USE master
GO
------------------------------------
-- Create temporary table for timing
------------------------------------
IF EXISTS( SELECT name FROM sysobjects WHERE name = 'tpcc_timer' )
DROP TABLE tpcc_timer
GO
CREATE TABLE tpcc_timer
(start_date CHAR(30),
end_date CHAR(30))
GO
INSERT INTO tpcc_timer VALUES(0,0)
GO
----------------------
-- Store starting time
----------------------
UPDATE tpcc_timer
SET start_date = (SELECT CONVERT(CHAR(30), GETDATE(), 21))
GO
-----------------------------
-- create main database files
-----------------------------
CREATE DATABASE tpcc
ON PRIMARY
( NAME = MSSQL_tpcc_root,
FILENAME = 'c:\MSSQL_tpcc_root.mdf',
SIZE = 8MB,
FILEGROWTH = 0),
FILEGROUP MSSQL_fg
( NAME = MSSQL_1,
FILENAME = 'c:\dev\tpcc_1\',
SIZE = 999999MB,
FILEGROWTH = 0),
( NAME = MSSQL_2,
FILENAME = 'c:\dev\tpcc_2\',
SIZE = 999999MB,
FILEGROWTH = 0),
( NAME = MSSQL_3,
FILENAME = 'c:\dev\tpcc_3\',
SIZE = 999999MB,
FILEGROWTH = 0),
( NAME = MSSQL_4,
FILENAME = 'c:\dev\tpcc_4\',
SIZE = 999999MB,
FILEGROWTH = 0),
( NAME = MSSQL_5,
FILENAME = 'c:\dev\tpcc_5\',
SIZE = 999999MB,
FILEGROWTH = 0),
( NAME = MSSQL_6,
FILENAME = 'c:\dev\tpcc_6\',
SIZE = 999999MB,
FILEGROWTH = 0),
( NAME = MSSQL_7,
FILENAME = 'c:\dev\tpcc_7\',
SIZE = 999999MB,
FILEGROWTH = 0),
( NAME = MSSQL_8,
FILENAME = 'c:\dev\tpcc_8\',
SIZE = 999999MB,
FILEGROWTH = 0),
( NAME = MSSQL_9,
FILENAME = 'c:\dev\tpcc_9\',
SIZE = 999999MB,
FILEGROWTH = 0),
( NAME = MSSQL_10,
FILENAME = 'c:\dev\tpcc_10\',
SIZE = 999999MB,
FILEGROWTH = 0),
( NAME = MSSQL_11,
FILENAME = 'c:\dev\tpcc_11\',
SIZE = 999999MB,
FILEGROWTH = 0),
( NAME = MSSQL_12,
FILENAME = 'c:\dev\tpcc_12\',
SIZE = 999999MB,
FILEGROWTH = 0),
( NAME = MSSQL_13,
FILENAME = 'c:\dev\tpcc_13\',
SIZE = 999999MB,
FILEGROWTH = 0),
( NAME = MSSQL_14,
FILENAME = 'c:\dev\tpcc_14\',
SIZE = 999999MB,
FILEGROWTH = 0),
( NAME = MSSQL_15,
FILENAME = 'c:\dev\tpcc_15\',
SIZE = 999999MB,
FILEGROWTH = 0),
( NAME = MSSQL_16,
FILENAME = 'c:\dev\tpcc_16\',
SIZE = 999999MB,
FILEGROWTH = 0),
( NAME = MSSQL_17,
FILENAME = 'c:\dev\tpcc_17\',
SIZE = 999999MB,
FILEGROWTH = 0),
( NAME = MSSQL_18,
FILENAME = 'c:\dev\tpcc_18\',
SIZE = 999999MB,
FILEGROWTH = 0),
( NAME = MSSQL_19,
FILENAME = 'c:\dev\tpcc_19\',
SIZE = 999999MB,
FILEGROWTH = 0),
( NAME = MSSQL_20,
FILENAME = 'c:\dev\tpcc_20\',
SIZE = 999999MB,
FILEGROWTH = 0)
LOG ON
( NAME = MSSQL_tpcc_log_1,
FILENAME = 'E:',
SIZE = 500000MB,
FILEGROWTH = 0)
COLLATE Latin1_General_BIN
GO
--------------------
-- Store ending time
--------------------
UPDATE tpcc_timer
SET end_date = (SELECT CONVERT(CHAR(30), GETDATE(), 21))
GO
SELECT DATEDIFF(second,(SELECT start_date FROM tpcc_timer),(SELECT end_date FROM tpcc_timer))
GO
-------------------------
-- remove temporary table
-------------------------
IF EXISTS ( SELECT name FROM sysobjects WHERE name = 'tpcc_timer' )
DROP TABLE tpcc_timer
GO
