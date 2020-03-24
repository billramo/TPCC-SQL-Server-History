------------------------------------------------------------------
-- --
-- File: PAYMENT.SQL --
-- Microsoft TPC-C Benchmark Kit Ver. 4.68 --
-- Copyright Microsoft, 2006 --
-- --
-- Creates payment stored procedure --
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
IF EXISTS ( SELECT name FROM sysobjects WHERE name = 'tpcc_payment' )
DROP PROCEDURE tpcc_payment
GO
CREATE PROCEDURE tpcc_payment
@w_id int,
@c_w_id int,
@h_amount smallmoney,
@d_id tinyint,
@c_d_id tinyint,
@c_id int,
@c_last char(16) = ""
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
@c_credit_lim money,
@c_balance money,
@c_discount smallmoney,
@c_data char(42),
@datetime datetime,
@w_ytd money,
@d_ytd money,
@cnt smallint,
@val smallint,
@screen_data char(200),
@d_id_local tinyint,
@w_id_local int,
@c_id_local int
SELECT @screen_data = ""
BEGIN TRANSACTION p
-- get payment date
SELECT @datetime = GETDATE()
IF (@c_id = 0)
BEGIN
-- get customer id and info using last name
SELECT @cnt = COUNT(*)
FROM customer WITH (repeatableread)
WHERE c_last = @c_last AND
c_w_id = @c_w_id AND
c_d_id = @c_d_id
SELECT @val = (@cnt + 1) / 2
SET rowcount @val
SELECT @c_id = c_id
FROM customer WITH (repeatableread)
WHERE c_last = @c_last AND
c_w_id = @c_w_id AND
c_d_id = @c_d_id
ORDER BY c_last, c_first
SET rowcount 0
END
-- get customer info and update balances
UPDATE customer
SET @c_balance = c_balance = c_balance - @h_amount,
c_payment_cnt = c_payment_cnt + 1,
c_ytd_payment = c_ytd_payment + @h_amount,
@c_first = c_first,
@c_middle = c_middle,
@c_last = c_last,
@c_street_1 = c_street_1,
@c_street_2 = c_street_2,
@c_city = c_city,
@c_state = c_state,
@c_zip = c_zip,
@c_phone = c_phone,
@c_credit = c_credit,
@c_credit_lim = c_credit_lim,
@c_discount = c_discount,
@c_since = c_since,
@c_id_local = c_id
WHERE c_id = @c_id AND
c_w_id = @c_w_id AND
c_d_id = @c_d_id
-- if customer has bad credit get some more info
IF (@c_credit = "BC")
BEGIN
-- compute new info
SELECT @c_data = convert(char(5),@c_id) +
convert(char(4),@c_d_id) +
convert(char(5),@c_w_id) +
convert(char(4),@d_id) +
convert(char(5),@w_id) +
convert(char(19),@h_amount)
-- update customer info
UPDATE customer
SET c_data = @c_data + substring(c_data, 1, 458),
@screen_data = @c_data + substring(c_data, 1, 158)
WHERE c_id = @c_id AND
c_w_id = @c_w_id AND
c_d_id = @c_d_id
END
-- get district data and update year-to-date
UPDATE district
SET d_ytd = d_ytd + @h_amount,
@d_street_1 = d_street_1,
@d_street_2 = d_street_2,
@d_city = d_city,
@d_state = d_state,
@d_zip = d_zip,
@d_name = d_name,
@d_id_local = d_id
WHERE d_w_id = @w_id AND
d_id = @d_id
-- get warehouse data and update year-to-date
UPDATE warehouse
SET w_ytd = w_ytd + @h_amount,
@w_street_1 = w_street_1,
@w_street_2 = w_street_2,
@w_city = w_city,
@w_state = w_state,
@w_zip = w_zip,
@w_name = w_name,
@w_id_local = w_id
WHERE w_id = @w_id
-- create history record
INSERT INTO history VALUES (@c_id_local,
@c_d_id,
@c_w_id,
@d_id_local,
@w_id_local,
@datetime,
@h_amount,
@w_name + ' ' + @d_name)
COMMIT TRANSACTION p
-- return data to client
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
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
