------------------------------------------------------------------
-- --
-- File: NULL-TXNS.SQL --
-- Microsoft TPC-C Benchmark Kit Ver. 4.68 --
-- Copyright Microsoft, 2006 --
-- --
-- This script will create stored procs which --
-- accept the same parameters and return correctly --
-- formed results sets to match the standard TPC-C --
-- stored procs. Of course, the advantage is that --
-- these stored procs place almost no load on --
-- SQL Server and do not require a database. --
-- --
-- Interface Level: 4.10.000 --
-- --
------------------------------------------------------------------
USE tpcc
GO
IF EXISTS ( SELECT name FROM sysobjects WHERE name = 'tpcc_delivery' )
DROP PROCEDURE tpcc_delivery
GO
IF EXISTS ( SELECT name FROM sysobjects WHERE name = 'tpcc_neworder' )
DROP PROCEDURE tpcc_neworder
GO
IF EXISTS ( SELECT name FROM sysobjects WHERE name = 'tpcc_orderstatus' )
DROP PROCEDURE tpcc_orderstatus
GO
IF EXISTS ( SELECT name FROM sysobjects WHERE name = 'tpcc_payment' )
DROP PROCEDURE tpcc_payment
GO
IF EXISTS ( SELECT name FROM sysobjects WHERE name = 'tpcc_stocklevel' )
DROP PROCEDURE tpcc_stocklevel
GO
IF EXISTS ( SELECT name FROM sysobjects WHERE name = 'tpcc_version' )
DROP PROCEDURE tpcc_version
GO
IF EXISTS ( SELECT name FROM sysobjects WHERE name = 'order_line_null' )
DROP PROCEDURE order_line_null
GO
CREATE PROCEDURE tpcc_delivery
@w_id int,
@o_carrier_id smallint
AS
DECLARE @d_id tinyint,
@o_id int,
@c_id int,
@total numeric(12,2),
@oid1 int,
@oid2 int,
@oid3 int,
@oid4 int,
@oid5 int,
@oid6 int,
@oid7 int,
@oid8 int,
@oid9 int,
@oid10 int,
@delaytime varchar(30)
---------------------------------------------------
-- uniform random delay of 0 - 1 second; avg = 0.50
---------------------------------------------------
SELECT @delaytime = '00:00:0' + CAST(CAST((RAND()*1.00) AS decimal(4,3)) AS char(5))
WAITFOR delay @delaytime
SELECT 3001, 3001, 3001, 3001, 3001, 3001, 3001, 3001, 3001, 3001
GO
CREATE PROCEDURE tpcc_neworder
@w_id int,
@d_id tinyint,
@c_id int,
@o_ol_cnt tinyint,
@o_all_local tinyint,
@i_id1 int = 0, @s_w_id1 int = 0, @ol_qty1 smallint = 0,
@i_id2 int = 0, @s_w_id2 int = 0, @ol_qty2 smallint = 0,
@i_id3 int = 0, @s_w_id3 int = 0, @ol_qty3 smallint = 0,
@i_id4 int = 0, @s_w_id4 int = 0, @ol_qty4 smallint = 0,
@i_id5 int = 0, @s_w_id5 int = 0, @ol_qty5 smallint = 0,
@i_id6 int = 0, @s_w_id6 int = 0, @ol_qty6 smallint = 0,
@i_id7 int = 0, @s_w_id7 int = 0, @ol_qty7 smallint = 0,
@i_id8 int = 0, @s_w_id8 int = 0, @ol_qty8 smallint = 0,
@i_id9 int = 0, @s_w_id9 int = 0, @ol_qty9 smallint = 0,
@i_id10 int = 0, @s_w_id10 int = 0, @ol_qty10 smallint = 0,
@i_id11 int = 0, @s_w_id11 int = 0, @ol_qty11 smallint = 0,
@i_id12 int = 0, @s_w_id12 int = 0, @ol_qty12 smallint = 0,
@i_id13 int = 0, @s_w_id13 int = 0, @ol_qty13 smallint = 0,
@i_id14 int = 0, @s_w_id14 int = 0, @ol_qty14 smallint = 0,
@i_id15 int = 0, @s_w_id15 int = 0, @ol_qty15 smallint = 0
AS
DECLARE @w_tax numeric(4,4),
@d_tax numeric(4,4),
@c_last char(16),
@c_credit char(2),
@c_discount numeric(4,4),
@i_price numeric(5,2),
@i_name char(24),
@o_entry_d datetime,
@li_no int,
@o_id int,
@commit_flag tinyint,
@li_id int,
@li_qty smallint,
@delaytime varchar(30)
BEGIN
----------------------------------------------------
-- uniform random delay of 0 - 0.6 second; avg = 0.3
----------------------------------------------------
SELECT @delaytime = '00:00:0' + CAST(CAST((RAND()*0.60) AS decimal(4,3)) AS char(5))
WAITFOR delay @delaytime
----------------------
-- process orderlines
----------------------
SELECT @commit_flag = 1,
@li_no = 0
WHILE (@li_no < @o_ol_cnt)
BEGIN
SELECT @li_id = CASE @li_no
WHEN 1 THEN @i_id1
WHEN 2 THEN @i_id2
WHEN 3 THEN @i_id3
WHEN 4 THEN @i_id4
WHEN 5 THEN @i_id5
WHEN 6 THEN @i_id6
WHEN 7 THEN @i_id7
WHEN 8 THEN @i_id8
WHEN 9 THEN @i_id9
WHEN 10 THEN @i_id10
WHEN 11 THEN @i_id11
WHEN 12 THEN @i_id12
WHEN 13 THEN @i_id13
WHEN 14 THEN @i_id14
WHEN 15 THEN @i_id15
END
SELECT @li_no = @li_no + 1
SELECT @i_price = 23.45, @li_qty = @li_no
IF (@li_id = 999999)
BEGIN
SELECT '',0,'',0,0
SELECT @commit_flag = 0
END
ELSE
BEGIN
SELECT 'Item Name blah',
17,
'G',
@i_price,
@i_price * @li_qty
END
END
-------------------------------
-- return order data to client
-------------------------------
SELECT @w_tax = 0.1234,
@d_tax = 0.0987,
@o_id = 3001,
@c_last = 'BAROUGHTABLE',
@c_discount = 0.2198,
@c_credit = 'GC',
@o_entry_d = GETDATE()
SELECT @w_tax,
@d_tax,
@o_id,
@c_last,
@c_discount,
@c_credit,
@o_entry_d,
@commit_flag
END
GO
CREATE PROCEDURE tpcc_orderstatus
@w_id int,
@d_id tinyint,
@c_id int,
@c_last char(16) = ''
AS
DECLARE @c_balance numeric(12,2),
@c_first char(16),
@c_middle char(2),
@o_id int,
@o_entry_d datetime,
@o_carrier_id smallint,
@ol_cnt smallint,
@delaytime varchar(30)
----------------------------------------------------
-- uniform random delay of 0 - 0.2 second; avg = 0.1
----------------------------------------------------
SELECT @delaytime = '00:00:0' + CAST(CAST((RAND()*0.20) AS decimal(4,3)) AS char(5))
WAITFOR delay @delaytime
SELECT @c_id = 113,
@c_balance = -10.00,
@c_first = '8YCodgytqCj8',
@c_middle = 'OE',
@c_last = 'OUGHTOUGHTABLE',
@o_id = 3456,
@o_entry_d = GETDATE(),
@o_carrier_id = 1
SELECT @ol_cnt = (RAND() * 11) + 5
SET ROWCOUNT @ol_cnt
SELECT ol_supply_w_id,
ol_i_id,
ol_quantity,
ol_amount,
ol_delivery_d
FROM order_line_null
SELECT @c_id,
@c_last,
@c_first,
@c_middle,
@o_entry_d,
@o_carrier_id,
@c_balance,
@o_id
GO
CREATE PROCEDURE tpcc_payment
@w_id int,
@c_w_id int,
@h_amount numeric(6,2),
@d_id tinyint,
@c_d_id tinyint,
@c_id int,
@c_last char(16) = ''
AS
DECLARE @w_street_1 char(20),
@w_street_2 char(20),
@w_city char(20),
@w_state char(2),
@w_zip char(9),
@w_name char(10),
@d_street_1 char(20),
@d_street_2 char(20),
@d_city char(20),
@d_state char(2),
@d_zip char(9),
@d_name char(10),
@c_first char(16),
@c_middle char(2),
@c_street_1 char(20),
@c_street_2 char(20),
@c_city char(20),
@c_state char(2),
@c_zip char(9),
@c_phone char(16),
@c_since datetime,
@c_credit char(2),
@c_credit_lim numeric(12,2),
@c_balance numeric(12,2),
@c_discount numeric(4,4),
@data char(500),
@c_data char(500),
@datetime datetime,
@w_ytd numeric(12,2),
@d_ytd numeric(12,2),
@cnt smallint,
@val smallint,
@screen_data char(200),
@d_id_local tinyint,
@w_id_local int,
@c_id_local int,
@delaytime varchar(30)
-----------------------------------------------------
-- uniform random delay of 0 - 0.3 second; avg = 0.15
-----------------------------------------------------
SELECT @delaytime = '00:00:0' + CAST(CAST((RAND()*0.20) AS decimal(4,3)) AS char(5))
WAITFOR delay @delaytime
SELECT @screen_data = ''
-----------------------------------------
-- get customer info and update balances
-----------------------------------------
SELECT @d_street_1 = 'rqSHHakqyV',
@d_street_2 = 'zZ98nW3BR2s',
@d_city = 'ArNr4GNFV9',
@d_state = 'aV',
@d_zip = '453511111'
----------------------------------------------
-- get warehouse data and update year-to-date
----------------------------------------------
SELECT @w_street_1 = 'rqSHHakqyV',
@w_street_2 = 'zZ98nW3BR2s',
@w_city = 'ArNr4GNFV9',
@w_state = 'aV',
@w_zip = '453511111'
SELECT @c_id = 123,
@c_balance = -10000.00,
@c_first = 'KmR03Xureb',
@c_middle = 'OE',
@c_last = 'BAROUGHTBAR',
@c_street_1 = 'QpGdOHjv8mR9vNI8V',
@c_street_2 = 'dzKoCObBqbC3yu',
@c_city = 'zAKZXdC037FQxq',
@c_state = 'QA',
@c_zip = '700311111',
@c_phone = '2967264064528555',
@c_credit = 'GC',
@c_credit_lim = 50000.00,
@c_discount = 0.3069,
@c_since = GETDATE(),
@datetime = GETDATE()
-------------------------
-- return data to client
-------------------------
SELECT @c_id,
@c_last,
@datetime,
@w_street_1,
@w_street_2,
@w_city,
@w_state,
@w_zip,
@d_street_1,
@d_street_2,
@d_city,
@d_state,
@d_zip,
@c_first,
@c_middle,
@c_street_1,
@c_street_2,
@c_city,
@c_state,
@c_zip,
@c_phone,
@c_since,
@c_credit,
@c_credit_lim,
@c_discount,
@c_balance,
@screen_data
GO
CREATE PROCEDURE tpcc_stocklevel
@w_id int,
@d_id tinyint,
@threshhold smallint
AS
DECLARE @delaytime varchar(30)
----------------------------------------------------
-- uniform random delay of 0 - 3.6 second; avg = 1.8
----------------------------------------------------
SELECT @delaytime = '00:00:0' + CAST(CAST((RAND()*0.20) AS decimal(4,3)) AS char(5))
WAITFOR delay @delaytime
SELECT 49
GO
CREATE PROCEDURE tpcc_version
AS
DECLARE @version char(8)
BEGIN
SELECT @version = '4.10.000'
SELECT @version AS 'Version'
END
GO
CREATE TABLE order_line_null (
[ol_i_id] [int] NOT NULL ,
[ol_supply_w_id] [int] NOT NULL ,
[ol_delivery_d] [datetime] NOT NULL ,
[ol_quantity] [smallint] NOT NULL ,
[ol_amount] [numeric](6, 2) NOT NULL
) ON [PRIMARY]
GO
INSERT INTO order_line_null VALUES ( 101, 1, GETDATE(), 1, 123.45 )
INSERT INTO order_line_null VALUES ( 102, 1, GETDATE(), 2, 123.45 )
INSERT INTO order_line_null VALUES ( 103, 1, GETDATE(), 3, 123.45 )
INSERT INTO order_line_null VALUES ( 104, 1, GETDATE(), 4, 123.45 )
INSERT INTO order_line_null VALUES ( 105, 1, GETDATE(), 5, 123.45 )
INSERT INTO order_line_null VALUES ( 106, 1, GETDATE(), 1, 123.45 )
INSERT INTO order_line_null VALUES ( 107, 1, GETDATE(), 2, 123.45 )
INSERT INTO order_line_null VALUES ( 108, 1, GETDATE(), 3, 123.45 )
INSERT INTO order_line_null VALUES ( 109, 1, GETDATE(), 4, 123.45 )
INSERT INTO order_line_null VALUES ( 110, 1, GETDATE(), 5, 123.45 )
INSERT INTO order_line_null VALUES ( 111, 1, GETDATE(), 1, 123.45 )
INSERT INTO order_line_null VALUES ( 112, 1, GETDATE(), 2, 123.45 )
INSERT INTO order_line_null VALUES ( 113, 1, GETDATE(), 3, 123.45 )
INSERT INTO order_line_null VALUES ( 114, 1, GETDATE(), 4, 123.45 )
INSERT INTO order_line_null VALUES ( 115, 1, GETDATE(), 5, 123.45 )
GO
