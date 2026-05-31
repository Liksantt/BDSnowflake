CREATE TABLE IF NOT EXISTS mock_data (
    id INT,
    customer_first_name TEXT, customer_last_name TEXT, customer_age INT,
    customer_email TEXT, customer_country TEXT, customer_postal_code TEXT,
    customer_pet_type TEXT, customer_pet_name TEXT, customer_pet_breed TEXT,
    seller_first_name TEXT, seller_last_name TEXT, seller_email TEXT,
    seller_country TEXT, seller_postal_code TEXT,
    product_name TEXT, product_category TEXT, product_price NUMERIC, product_quantity INT,
    sale_date DATE, sale_customer_id INT, sale_seller_id INT, sale_product_id INT,
    sale_quantity INT, sale_total_price NUMERIC,
    store_name TEXT, store_location TEXT, store_city TEXT, store_state TEXT, 
    store_country TEXT, store_phone TEXT, store_email TEXT,
    pet_category TEXT,
    product_weight TEXT, product_color TEXT, product_size TEXT, product_brand TEXT,
    product_material TEXT, product_description TEXT, product_rating NUMERIC,
    product_reviews INT, product_release_date DATE, product_expiry_date DATE,
    supplier_name TEXT, supplier_contact TEXT, supplier_email TEXT,
    supplier_phone TEXT, supplier_address TEXT, supplier_city TEXT, supplier_country TEXT
);

CREATE TABLE dim_locations (
    location_id SERIAL PRIMARY KEY,
    country TEXT, state TEXT, city TEXT, postal_code TEXT,
    CONSTRAINT uniq_location UNIQUE (country, state, city, postal_code)
);

CREATE TABLE dim_product_categories (
    category_id SERIAL PRIMARY KEY,
    category_name TEXT UNIQUE
);

CREATE TABLE dim_brands (
    brand_id SERIAL PRIMARY KEY,
    brand_name TEXT UNIQUE
);

CREATE TABLE dim_pets (
    pet_id SERIAL PRIMARY KEY,
    pet_type TEXT, pet_name TEXT, pet_breed TEXT, pet_category TEXT
);

CREATE TABLE dim_customers (
    customer_id SERIAL PRIMARY KEY,
    first_name TEXT, last_name TEXT, age INT, email TEXT,
    pet_id INT REFERENCES dim_pets(pet_id),
    location_id INT REFERENCES dim_locations(location_id)
);

CREATE TABLE dim_sellers (
    seller_id SERIAL PRIMARY KEY,
    first_name TEXT, last_name TEXT, email TEXT,
    location_id INT REFERENCES dim_locations(location_id)
);

CREATE TABLE dim_products (
    product_id SERIAL PRIMARY KEY,
    product_name TEXT, product_price NUMERIC,
    product_color TEXT, product_size TEXT, product_material TEXT, 
    product_weight TEXT, product_description TEXT, product_rating NUMERIC, 
    product_reviews INT, product_release_date DATE, product_expiry_date DATE,
    category_id INT REFERENCES dim_product_categories(category_id),
    brand_id INT REFERENCES dim_brands(brand_id)
);

CREATE TABLE dim_stores (
    store_id SERIAL PRIMARY KEY,
    store_name TEXT, store_phone TEXT, store_email TEXT,
    location_id INT REFERENCES dim_locations(location_id)
);

CREATE TABLE dim_suppliers (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name TEXT, supplier_contact TEXT, supplier_email TEXT,
    supplier_phone TEXT, supplier_address TEXT,
    location_id INT REFERENCES dim_locations(location_id)
);

CREATE TABLE fact_sales (
    sale_id SERIAL PRIMARY KEY,
    sale_date DATE, sale_quantity INT, sale_total_price NUMERIC,
    customer_id INT REFERENCES dim_customers(customer_id),
    seller_id INT REFERENCES dim_sellers(seller_id),
    product_id INT REFERENCES dim_products(product_id),
    store_id INT REFERENCES dim_stores(store_id)
);
