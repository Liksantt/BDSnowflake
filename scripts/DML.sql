COPY mock_data FROM '/data/MOCK_DATA.csv' DELIMITER ',' CSV HEADER;
COPY mock_data FROM '/data/MOCK_DATA (1).csv' DELIMITER ',' CSV HEADER;
COPY mock_data FROM '/data/MOCK_DATA (2).csv' DELIMITER ',' CSV HEADER;
COPY mock_data FROM '/data/MOCK_DATA (3).csv' DELIMITER ',' CSV HEADER;
COPY mock_data FROM '/data/MOCK_DATA (4).csv' DELIMITER ',' CSV HEADER;
COPY mock_data FROM '/data/MOCK_DATA (5).csv' DELIMITER ',' CSV HEADER;
COPY mock_data FROM '/data/MOCK_DATA (6).csv' DELIMITER ',' CSV HEADER;
COPY mock_data FROM '/data/MOCK_DATA (7).csv' DELIMITER ',' CSV HEADER;
COPY mock_data FROM '/data/MOCK_DATA (8).csv' DELIMITER ',' CSV HEADER;
COPY mock_data FROM '/data/MOCK_DATA (9).csv' DELIMITER ',' CSV HEADER;

INSERT INTO dim_locations (country, state, city, postal_code)
SELECT DISTINCT store_country, store_state, store_city, NULL FROM mock_data WHERE store_city IS NOT NULL
UNION SELECT DISTINCT supplier_country, NULL, supplier_city, NULL FROM mock_data WHERE supplier_city IS NOT NULL
UNION SELECT DISTINCT customer_country, NULL, NULL, customer_postal_code FROM mock_data WHERE customer_postal_code IS NOT NULL
UNION SELECT DISTINCT seller_country, NULL, NULL, seller_postal_code FROM mock_data WHERE seller_postal_code IS NOT NULL;

INSERT INTO dim_product_categories (category_name) SELECT DISTINCT product_category FROM mock_data WHERE product_category IS NOT NULL;
INSERT INTO dim_brands (brand_name) SELECT DISTINCT product_brand FROM mock_data WHERE product_brand IS NOT NULL;
INSERT INTO dim_pets (pet_type, pet_name, pet_breed, pet_category) SELECT DISTINCT customer_pet_type, customer_pet_name, customer_pet_breed, pet_category FROM mock_data;

INSERT INTO dim_customers (first_name, last_name, age, email, location_id)
SELECT DISTINCT customer_first_name, customer_last_name, customer_age, customer_email,
    (SELECT location_id FROM dim_locations WHERE country = customer_country AND postal_code = customer_postal_code LIMIT 1)
FROM mock_data WHERE customer_email IS NOT NULL;

INSERT INTO dim_sellers (first_name, last_name, email, location_id)
SELECT DISTINCT seller_first_name, seller_last_name, seller_email,
    (SELECT location_id FROM dim_locations WHERE country = seller_country AND postal_code = seller_postal_code LIMIT 1)
FROM mock_data WHERE seller_email IS NOT NULL;

INSERT INTO dim_products (product_name, product_price, category_id, brand_id)
SELECT DISTINCT product_name, product_price,
    (SELECT category_id FROM dim_product_categories WHERE category_name = product_category LIMIT 1),
    (SELECT brand_id FROM dim_brands WHERE brand_name = product_brand LIMIT 1)
FROM mock_data WHERE product_name IS NOT NULL;

INSERT INTO dim_stores (store_name, store_phone, store_email, location_id)
SELECT DISTINCT store_name, store_phone, store_email,
    (SELECT location_id FROM dim_locations WHERE country = store_country AND city = store_city AND state = store_state LIMIT 1)
FROM mock_data WHERE store_name IS NOT NULL;

INSERT INTO dim_suppliers (supplier_name, supplier_contact, supplier_email, supplier_phone, supplier_address, location_id)
SELECT DISTINCT supplier_name, supplier_contact, supplier_email, supplier_phone, supplier_address,
    (SELECT location_id FROM dim_locations WHERE country = supplier_country AND city = supplier_city LIMIT 1)
FROM mock_data WHERE supplier_name IS NOT NULL;

TRUNCATE fact_sales;

INSERT INTO fact_sales (sale_date, sale_quantity, sale_total_price, customer_id, seller_id, product_id, store_id)
SELECT sale_date, sale_quantity, sale_total_price, sale_customer_id, sale_seller_id, sale_product_id,
    (SELECT store_id FROM dim_stores WHERE store_name = md.store_name LIMIT 1)
FROM mock_data md WHERE sale_customer_id IS NOT NULL AND sale_seller_id IS NOT NULL AND sale_product_id IS NOT NULL;
