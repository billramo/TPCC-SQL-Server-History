------------------------------------------------------------------
-- --
-- File: ORDSTAT.SQL --
-- Microsoft TPC-C Benchmark Kit Ver. 4.68 --
-- Copyright Microsoft, 2006 --
-- --
-- Creates order status stored procedure --
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
IF EXISTS ( SELECT name FROM sysobjects WHERE name = 'tpcc_orderstatus' )
DROP PROCEDURE tpcc_orderstatus
GO
CREATE PROCEDURE tpcc_orderstatus
@w_id int,
@d_id tinyint,
@c_id int,
@c_last char(16) = ''
AS
DECLARE @c_balance money,
@c_first char(16),
@c_middle char(2),
@o_id int,
@o_entry_d datetime,
@o_carrier_id smallint,
@cnt smallint
BEGIN TRANSACTION o
IF (@c_id = 0)
BEGIN
--------------------------------------------
-- get customer id and info using last name
--------------------------------------------
SELECT @cnt = (count(*)+1)/2
FROM customer WITH (repeatableread)
WHERE c_last = @c_last AND
c_w_id = @w_id AND
c_d_id = @d_id
SET rowcount @cnt
SELECT @c_id = c_id,
@c_balance = c_balance,
@c_first = c_first,
@c_last = c_last,
@c_middle = c_middle
FROM customer WITH (repeatableread)
WHERE c_last = @c_last AND
c_w_id = @w_id AND
c_d_id = @d_id
ORDER BY c_w_id, c_d_id, c_last, c_first
SET rowcount 0
END
ELSE
BEGIN
------------------------------
-- get customer info if by id
------------------------------
SELECT @c_balance = c_balance,
@c_first = c_first,
@c_middle = c_middle,
@c_last = c_last
FROM customer WITH (repeatableread)
WHERE c_id = @c_id AND
c_d_id = @d_id AND
c_w_id = @w_id
SELECT @cnt = @@rowcount
END
-----------------------
-- if no such customer
-----------------------
IF (@cnt = 0)
BEGIN
RAISERROR('Customer not found',18,1)
GOTO custnotfound
END
------------------
-- get order info
------------------
SELECT @o_id = o_id,
@o_entry_d = o_entry_d,
@o_carrier_id = o_carrier_id
FROM orders WITH (serializable)
WHERE o_c_id = @c_id AND
o_d_id = @d_id AND
o_w_id = @w_id
ORDER BY o_id ASC
--------------------------------------------
-- select order lines for the current order
--------------------------------------------
SELECT ol_supply_w_id,
ol_i_id,
ol_quantity,
ol_amount,
ol_delivery_d
FROM order_line WITH (repeatableread)
WHERE ol_o_id = @o_id AND
ol_d_id = @d_id AND
ol_w_id = @w_id
custnotfound:
COMMIT TRANSACTION o
-------------------------
-- return data to client
-------------------------
SELECT @c_id,
@c_last,
@c_first,
@c_middle,
@o_entry_d,
@o_carrier_id,
@c_balance,
@o_id
GO
