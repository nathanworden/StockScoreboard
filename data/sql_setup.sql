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
holding_period_return decimal(5, 5) NOT NULL,
time_weighted_return decimal(5, 5) NOT NULL
);


INSERT INTO time_weighted_return (

);