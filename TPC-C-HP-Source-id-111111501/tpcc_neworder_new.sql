------------------------------------------------------------------
-- --
-- File: TPCC_NEWORDER_NEW.SQL --
-- Microsoft TPC-C Benchmark Kit Ver. 4.68 --
-- Copyright Microsoft, 2006 --
-- --
-- This acid stored procedure implements the neworder --
-- transaction. It outputs timestamps at the --
-- beginning of the transaction, before the commit --
-- delay, and after the commit. --
-- --
------------------------------------------------------------------
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
USE tpcc
GO
IF EXISTS ( SELECT name FROM sysobjects WHERE name = 'tpcc_neworder_new' )
DROP PROCEDURE tpcc_neworder_new
GO
-- neworder_new v2.5 6/23/05 PeterCa
-- 1q stock/order_line/client. upd district & ins neworder.
-- cust/warehouse select together, ins order separate
-- uses rownumber to distinct w any transform
-- uses in-memory sort for distinct on iid,wid
-- uses charindex
-- will rollback if (@i_idX,@s_w_idX pairs not unique) OR (@i_idX not unique).
CREATE PROCEDURE tpcc_neworder_new
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
BEGIN
DECLARE @o_id int,
@d_tax smallmoney,
@o_entry_d datetime,
@commit_flag tinyint
BEGIN TRANSACTION n
-- get district tax and next availible order id and update
-- insert corresponding row into new-order table
-- plus initialize local variables
UPDATE district
SET @d_tax = d_tax,
@o_id = d_next_o_id,
d_next_o_id = d_next_o_id + 1,
@o_entry_d = GETDATE(),
@commit_flag = 1
OUTPUT deleted.d_next_o_id,
@d_id,
@w_id
INTO new_order
WHERE d_w_id = @w_id AND
d_id = @d_id
-- update stock from stock join (item join (params))
-- output to orderline, output to client
-- NOTE: @@rowcount != @ol_o_cnt
-- if (@i_idX,@s_w_idX pairs not unique) OR (@i_idX not unique).
UPDATE stock
SET s_ytd = s_ytd + info.ol_qty,
s_quantity = s_quantity - info.ol_qty +
CASE WHEN (s_quantity - info.ol_qty < 10) THEN 91 ELSE 0 END,
s_order_cnt = s_order_cnt + 1,
s_remote_cnt = s_remote_cnt +
CASE WHEN (info.w_id = @w_id) THEN 0 ELSE 1 END
OUTPUT @o_id,
@d_id,
@w_id,
info.lino,
info.i_id,
"dec 31, 1899",
info.i_price * info.ol_qty,
info.w_id,
info.ol_qty,
CASE @d_id WHEN 1 THEN inserted.s_dist_01
WHEN 2 THEN inserted.s_dist_02
WHEN 3 THEN inserted.s_dist_03
WHEN 4 THEN inserted.s_dist_04
WHEN 5 THEN inserted.s_dist_05
WHEN 6 THEN inserted.s_dist_06
WHEN 7 THEN inserted.s_dist_07
WHEN 8 THEN inserted.s_dist_08
WHEN 9 THEN inserted.s_dist_09
WHEN 10 THEN inserted.s_dist_10
END
INTO order_line
OUTPUT info.i_name,inserted.s_quantity,
CASE WHEN ((charindex("ORIGINAL",info.i_data) > 0) AND
(charindex("ORIGINAL",inserted.s_data) > 0) )
THEN "B" ELSE "G" END,
info.i_price,
info.i_price*info.ol_qty
FROM stock INNER JOIN
(SELECT iid,
wid,
lino,
ol_qty,
i_price,
i_name,
i_data
FROM (SELECT iid,
wid,
lino,
qty,
row_number() OVER (PARTITION BY iid,wid ORDER BY iid,wid)
FROM (SELECT @i_id1,@s_w_id1,1,@ol_qty1 UNION ALL
SELECT @i_id2,@s_w_id2,2,@ol_qty2 UNION ALL
SELECT @i_id3,@s_w_id3,3,@ol_qty3 UNION ALL
SELECT @i_id4,@s_w_id4,4,@ol_qty4 UNION ALL
SELECT @i_id5,@s_w_id5,5,@ol_qty5 UNION ALL
SELECT @i_id6,@s_w_id6,6,@ol_qty6 UNION ALL
SELECT @i_id7,@s_w_id7,7,@ol_qty7 UNION ALL
SELECT @i_id8,@s_w_id8,8,@ol_qty8 UNION ALL
SELECT @i_id9,@s_w_id9,9,@ol_qty9 UNION ALL
SELECT @i_id10,@s_w_id10,10,@ol_qty10 UNION ALL
SELECT @i_id11,@s_w_id11,11,@ol_qty11 UNION ALL
SELECT @i_id12,@s_w_id12,12,@ol_qty12 UNION ALL
SELECT @i_id13,@s_w_id13,13,@ol_qty13 UNION ALL
SELECT @i_id14,@s_w_id14,14,@ol_qty14 UNION ALL
SELECT @i_id15,@s_w_id15,15,@ol_qty15) AS uo1(iid,wid,lino,qty)
) AS o1(iid,wid,lino,ol_qty,rownum)
INNER JOIN
item (repeatableread) ON i_id = iid AND -- filters out invalid items
rownum = 1
) AS info(i_id,w_id,lino,ol_qty,i_price,i_name,i_data)
ON s_i_id = info.i_id AND
s_w_id = info.w_id
IF (@@rowcount <> @o_ol_cnt) -- must have an invalid item
SELECT @commit_flag = 0 -- 2.4.2.3 requires rest to proceed
-- insert fresh row into orders table
INSERT INTO orders VALUES ( @o_id,
@d_id,
@w_id,
@c_id,
0,
@o_ol_cnt,
@o_all_local,
@o_entry_d)
-- get customer last name, discount, and credit rating
-- get warehouse tax
-- return order_data to client
SELECT w_tax,
@d_tax,
@o_id,
c_last,
c_discount,
c_credit,
@o_entry_d,
@commit_flag
FROM warehouse(repeatableread),
customer(repeatableread)
WHERE w_id = @w_id AND
c_id = @c_id AND
c_w_id = @w_id AND
c_d_id = @d_id
-- @@rowcount checks that previous select found a valid customer
IF (@@rowcount = 0)
BEGIN
RAISERROR( 'Invalid Customer ID', 11, 1 )
ROLLBACK TRANSACTION n
END
ELSE IF (@commit_flag = 1)
COMMIT TRANSACTION n
ELSE -- all that work for nothing.
ROLLBACK TRANSACTION n
END
GO
