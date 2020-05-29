CREATE TABLE stocks (
id serial UNIQUE NOT NULL,
ticker text NOT NULL,
shares numeric(9,3) NOT NULL,
purchase_date date NOT NULL,
purchase_price decimal(9, 2) NOT NULL,
commission decimal (6, 2) NOT NULL,
s_and_p_at_stock_purchase_date numeric(9, 2)
);

-- INSERT INTO stocks (ticker, shares, purchase_date, purchase_price, comission)
-- VALUES('amzn', 1, TO_DATE('2020/03/12', 'YYYY/MM/DD'), 1723, 7);

CREATE TABLE s_and_p (
id serial UNIQUE NOT NULL,
hist_date date NOT NULL,
close_price decimal(9,2) NOT NULL
);

CREATE TABLE table_sort_rule (
sort_rule text
);

INSERT INTO table_sort_rule (sort_rule)
VALUES ('percent_portfolio');

CREATE TABLE time_weighted_return (
id serial UNIQUE NOT NULL,
purchase_date date NOT NULL,
ending_portfolio_value decimal(12, 2) NOT NULL,
cash_flow decimal(12, 2) NOT NULL,
portfolio_value_after_cash_flow decimal(12, 2) NOT NULL,
holding_period_return decimal(12, 5) NOT NULL,
time_weighted_return decimal(12, 5) NOT NULL
);


# Example of adding data to the time_weighted_return table:
-- INSERT INTO time_weighted_return (id, purchase_date, ending_portfolio_value, cash_flow, portfolio_value_after_cash_flow, holding_period_return, time_weighted_return) VALUES 
-- (1, '2020-03-20', 1068.00, 0, 1068.00, 0, 0);
-- (2, '2020-04-20', 1227.12, 1023.66, 2250.78, 14.89888, 14.89888), 
-- (3, '2020-04-21', 2208.05, 2050.14, 4258.19, -1.89845, 12.71758),
-- (4, '2020-04-28', 4469.37, 1047.37, 5516.74, 4.95938, 18.30767),
-- (5, '2020-05-01', 5735.89, 3443.79, 9179.59, 3.97082, 23.00546),
-- (6, '2020-05-21', 11544.57, 1032.58, 12577.15, 25.76346, 54.69592),
-- (7, '2020-05-26', 12608.65, 959.90, 13568.55, 0.25045, 55.08337),
-- (8, '2020-05-27', 13452.01, 714.30, 14166.31, -0.85890, 53.75136);
