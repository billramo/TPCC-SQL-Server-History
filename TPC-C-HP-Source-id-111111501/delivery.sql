------------------------------------------------------------------
-- --
-- File: DELIVERY.SQL --
-- Microsoft TPC-C Benchmark Kit Ver. 4.68 --
-- Copyright Microsoft,2006 --
-- --
-- Creates delivery stored procedure --
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
IF EXISTS ( SELECT name FROM sysobjects WHERE name = 'tpcc_delivery' )
DROP PROCEDURE tpcc_delivery
GO
CREATE PROC tpcc_delivery
@w_id int,
@o_carrier_id smallint
AS
DECLARE @d_id tinyint,
@o_id int,
@c_id int,
@total money,
@oid1 int,
@oid2 int,
@oid3 int,
@oid4 int,
@oid5 int,
@oid6 int,
@oid7 int,
@oid8 int,
@oid9 int,
@oid10 int
SELECT @d_id = 0
BEGIN TRANSACTION d
WHILE (@d_id < 10)
BEGIN
SELECT @d_id = @d_id + 1,
@total = 0,
@o_id = 0
SELECT TOP 1
@o_id = no_o_id
FROM new_order WITH (serializable updlock)
WHERE no_w_id = @w_id AND
no_d_id = @d_id
ORDER BY no_o_id ASC
IF (@@rowcount <> 0)
BEGIN
-- claim the order for this district
DELETE new_order
WHERE no_w_id = @w_id AND
no_d_id = @d_id AND
no_o_id = @o_id
-- set carrier_id on this order (and get customer id)
UPDATE orders
SET o_carrier_id = @o_carrier_id,
@c_id = o_c_id
WHERE o_w_id = @w_id AND
o_d_id = @d_id AND
o_id = @o_id
-- set date in all lineitems for this order (and sum amounts)
UPDATE order_line
SET ol_delivery_d = GETDATE(),
@total = @total + ol_amount
WHERE ol_w_id = @w_id AND
ol_d_id = @d_id AND
ol_o_id = @o_id
-- accummulate lineitem amounts for this order into customer
UPDATE customer
SET c_balance = c_balance + @total,
c_delivery_cnt = c_delivery_cnt + 1
WHERE c_w_id = @w_id AND
c_d_id = @d_id AND
c_id = @c_id
END
SELECT @oid1 = CASE @d_id WHEN 1 THEN @o_id ELSE @oid1 END,
@oid2 = CASE @d_id WHEN 2 THEN @o_id ELSE @oid2 END,
@oid3 = CASE @d_id WHEN 3 THEN @o_id ELSE @oid3 END,
@oid4 = CASE @d_id WHEN 4 THEN @o_id ELSE @oid4 END,
@oid5 = CASE @d_id WHEN 5 THEN @o_id ELSE @oid5 END,
@oid6 = CASE @d_id WHEN 6 THEN @o_id ELSE @oid6 END,
@oid7 = CASE @d_id WHEN 7 THEN @o_id ELSE @oid7 END,
@oid8 = CASE @d_id WHEN 8 THEN @o_id ELSE @oid8 END,
@oid9 = CASE @d_id WHEN 9 THEN @o_id ELSE @oid9 END,
@oid10 = CASE @d_id WHEN 10 THEN @o_id ELSE @oid10 END
END
COMMIT TRANSACTION d
-- return delivery data to client
SELECT @oid1,
@oid2,
@oid3,
@oid4,
@oid5,
@oid6,
@oid7,
@oid8,
@oid9,
@oid10
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
