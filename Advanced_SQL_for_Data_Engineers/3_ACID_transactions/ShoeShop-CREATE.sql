CREATE schema shoe_shops
DROP TABLE IF EXISTS shoe_shops.shoe_shop

CREATE TABLE shoe_shops.shoe_shop (
    product VARCHAR(25) NOT NULL,
    stock INTEGER NOT NULL,
    price DECIMAL(8, 2) NOT NULL CHECK(price > 0),
    PRIMARY KEY (product)
);

INSERT INTO shoe_shops.shoe_shop VALUES
('Boots',11,200),
('High heels',8,600),
('Brogues',10,150),
('Trainers',14,300);



SELECT * FROM shoe_shops.shoe_shop;