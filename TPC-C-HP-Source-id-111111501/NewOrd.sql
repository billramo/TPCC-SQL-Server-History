------------------------------------------------------------------
-- --
-- File: NEWORD.SQL --
-- Microsoft TPC-C Benchmark Kit Ver. 4.68 --
-- Copyright Microsoft, 2006 --
-- --
-- Creates neworder stored procedure --
-- --
-- Interface Level: 4.20.000 --
-- --
------------------------------------------------------------------
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
USE tpcc
GO
IF EXISTS ( SELECT name FROM sysobjects WHERE name = 'tpcc_neworder' )
DROP PROCEDURE tpcc_neworder
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
DECLARE @w_tax smallmoney,
@d_tax smallmoney,
@c_last char(16),
@c_credit char(2),
@c_discount smallmoney,
@i_price smallmoney,
@i_name char(24),
@i_data char(50),
@o_entry_d datetime,
@remote_flag int,
@s_quantity smallint,
@s_data char(50),
@s_dist char(24),
@li_no int,
@o_id int,
@commit_flag tinyint,
@li_id int,
@li_s_w_id int,
@li_qty smallint,
@ol_number int,
@c_id_local int
BEGIN
BEGIN TRANSACTION n
-----------------------------------------------------------
-- get district tax and next availible order id and update
-- plus initialize local variables
-----------------------------------------------------------
UPDATE district
SET @d_tax = d_tax,
@o_id = d_next_o_id,
d_next_o_id = d_next_o_id + 1,
@o_entry_d = GETDATE(),
@li_no = 0,
@commit_flag = 1
WHERE d_w_id = @w_id AND
d_id = @d_id
----------------------
-- process orderlines
----------------------
WHILE (@li_no < @o_ol_cnt)
BEGIN
SELECT @li_no = @li_no + 1
-----------------------------------------------
-- set i_id, s_w_id, and qty for this lineitem
-----------------------------------------------
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
END,
@li_s_w_id = CASE @li_no
WHEN 1 THEN @s_w_id1
WHEN 2 THEN @s_w_id2
WHEN 3 THEN @s_w_id3
WHEN 4 THEN @s_w_id4
WHEN 5 THEN @s_w_id5
WHEN 6 THEN @s_w_id6
WHEN 7 THEN @s_w_id7
WHEN 8 THEN @s_w_id8
WHEN 9 THEN @s_w_id9
WHEN 10 THEN @s_w_id10
WHEN 11 THEN @s_w_id11
WHEN 12 THEN @s_w_id12
WHEN 13 THEN @s_w_id13
WHEN 14 THEN @s_w_id14
WHEN 15 THEN @s_w_id15
END,
@li_qty = CASE @li_no
WHEN 1 THEN @ol_qty1
WHEN 2 THEN @ol_qty2
WHEN 3 THEN @ol_qty3
WHEN 4 THEN @ol_qty4
WHEN 5 THEN @ol_qty5
WHEN 6 THEN @ol_qty6
WHEN 7 THEN @ol_qty7
WHEN 8 THEN @ol_qty8
WHEN 9 THEN @ol_qty9
WHEN 10 THEN @ol_qty10
WHEN 11 THEN @ol_qty11
WHEN 12 THEN @ol_qty12
WHEN 13 THEN @ol_qty13
WHEN 14 THEN @ol_qty14
WHEN 15 THEN @ol_qty15
END
---------------------------------------
-- get item data (no one updates item)
---------------------------------------
SELECT @i_price = i_price,
@i_name = i_name,
@i_data = i_data
FROM item WITH (repeatableread)
WHERE i_id = @li_id
-----------------------
-- update stock values
-----------------------
UPDATE stock
SET s_ytd = s_ytd + @li_qty,
@s_quantity = s_quantity = s_quantity - @li_qty +
CASE WHEN (s_quantity - @li_qty < 10) THEN 91 ELSE 0 END,
s_order_cnt = s_order_cnt + 1,
s_remote_cnt = s_remote_cnt +
CASE WHEN (@li_s_w_id = @w_id) THEN 0 ELSE 1 END,
@s_data = s_data,
@s_dist = CASE @d_id
WHEN 1 THEN s_dist_01
WHEN 2 THEN s_dist_02
WHEN 3 THEN s_dist_03
WHEN 4 THEN s_dist_04
WHEN 5 THEN s_dist_05
WHEN 6 THEN s_dist_06
WHEN 7 THEN s_dist_07
WHEN 8 THEN s_dist_08
WHEN 9 THEN s_dist_09
WHEN 10 THEN s_dist_10
END
WHERE s_i_id = @li_id AND
s_w_id = @li_s_w_id
----------------------------------------------------------------------
-- if there actually is a stock (and item) with these ids, go to work
----------------------------------------------------------------------
IF (@@rowcount > 0)
BEGIN
-----------------------------------------------------------
-- insert order_line data (using data from item and stock)
-----------------------------------------------------------
INSERT INTO order_line VALUES( @o_id,
@d_id,
@w_id,
@li_no,
@li_id,
'dec 31, 1899',
@i_price * @li_qty,
@li_s_w_id,
@li_qty,
@s_dist)
---------------------------------
-- send line-item data to client
---------------------------------
SELECT @i_name,
@s_quantity,
b_g = CASE WHEN ( (patindex('%ORIGINAL%',@i_data) > 0) AND
(patindex('%ORIGINAL%',@s_data) > 0) )
THEN 'B' ELSE 'G' END,
@i_price,
@i_price * @li_qty
END
ELSE
BEGIN
----------------------------------------------------------
-- no item (or stock) found - triggers rollback condition
----------------------------------------------------------
SELECT '',0,'',0,0
SELECT @commit_flag = 0
END
END
-------------------------------------------------------
-- get customer last name, discount, and credit rating
-------------------------------------------------------
SELECT @c_last = c_last,
@c_discount = c_discount,
@c_credit = c_credit,
@c_id_local = c_id
FROM customer WITH (repeatableread)
WHERE c_id = @c_id AND
c_w_id = @w_id AND
c_d_id = @d_id
--------------------------------------
-- insert fresh row into orders table
--------------------------------------
INSERT INTO orders VALUES ( @o_id,
@d_id,
@w_id,
@c_id_local,
0,
@o_ol_cnt,
@o_all_local,
@o_entry_d)
-------------------------------------------------
-- insert corresponding row into new-order table
-------------------------------------------------
INSERT INTO new_order VALUES ( @o_id,
@d_id,
@w_id)
------------------------
-- select warehouse tax
------------------------
SELECT @w_tax = w_tax
FROM warehouse WITH (repeatableread)
WHERE w_id = @w_id
IF (@commit_flag = 1)
COMMIT TRANSACTION n
ELSE
-------------------------------
-- all that work for nuthin!!!
-------------------------------
ROLLBACK TRANSACTION n
-------------------------------
-- return order data to client
-------------------------------
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
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
