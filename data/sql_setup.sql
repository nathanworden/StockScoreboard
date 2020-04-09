CREATE TABLE stocks (
id serial UNIQUE NOT NULL,
ticker text NOT NULL,
shares integer NOT NULL,
purchase_date date NOT NULL,
purchase_price decimal(9, 2) NOT NULL,
commission decimal (6, 2) NOT NULL
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