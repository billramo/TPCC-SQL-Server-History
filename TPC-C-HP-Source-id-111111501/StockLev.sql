------------------------------------------------------------------
-- --
-- File: STOCKLEV.SQL --
-- Microsoft TPC-C Benchmark Kit Ver. 4.68 --
-- Copyright Microsoft, 2006 --
-- --
-- Creates stock level stored procedure --
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
IF EXISTS ( SELECT name FROM sysobjects WHERE name = 'tpcc_stocklevel' )
DROP PROCEDURE tpcc_stocklevel
GO
CREATE PROCEDURE tpcc_stocklevel
@w_id int,
@d_id tinyint,
@threshhold smallint
AS
DECLARE @o_id_low int,
@o_id_high int
SELECT @o_id_low = (d_next_o_id - 20),
@o_id_high = (d_next_o_id - 1)
FROM district
WHERE d_w_id = @w_id AND
d_id = @d_id
SELECT COUNT(DISTINCT(s_i_id))
FROM stock,
order_line
WHERE ol_w_id = @w_id AND
ol_d_id = @d_id and
ol_o_id BETWEEN @o_id_low AND
@o_id_high AND
s_w_id = ol_w_id AND
s_i_id = ol_i_id AND
s_quantity < @threshhold
OPTION(ORDER GROUP)
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
