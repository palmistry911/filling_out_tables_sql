-- Создание таблицы customers
CREATE TABLE IF NOT EXISTS customers
(
    customer_id SERIAL PRIMARY KEY,
    first_name  VARCHAR(50),
    last_name   VARCHAR(50),
    email       VARCHAR(100),
    phone       VARCHAR(20) NOT NULL,
    address     VARCHAR(255)
);

-- Создание таблицы orders
CREATE TABLE IF NOT EXISTS orders
(
    order_id         SERIAL PRIMARY KEY,
    customer_id      INT,
    order_date       DATE,
    shipping_address VARCHAR(255),
    order_status     VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES customers (customer_id) ON DELETE CASCADE
);

-- Вставка данных в таблицу customers
INSERT INTO customers (first_name, last_name, email, phone, address)
VALUES ('John', 'Doe', 'john.doe@example.com', '123-456-7890', '123 Elm St'),
       ('Jane', 'Doe', 'jane.doe@example.com', '987-654-3210', '456 Oak St'),
       ('Alice', 'Johnson', 'alice.johnson@example.com', '555-678-1234', '789 Pine St'),
       ('Bob', 'Smith', 'bob.smith@example.com', '555-123-4567', '789 Maple St'),
       ('Charlie', 'Brown', 'charlie.brown@example.com', '555-987-6543', '321 Chestnut St');

-- Вставка данных в таблицу orders
INSERT INTO orders (customer_id, order_date, shipping_address, order_status)
VALUES (1, '2023-01-01', '123 Elm St', 'Shipped'),
       (2, '2023-01-02', '456 Oak St', 'Pending'),
       (3, '2023-01-03', '789 Pine St', 'Delivered'),
       (4, '2023-01-04', '789 Maple St', 'Cancelled'),
       (5, '2023-01-05', '321 Chestnut St', 'Shipped');

-- Проверка вставки данных в таблицу customers
SELECT *
FROM customers;

-- Проверка вставки данных в таблицу orders
SELECT *
FROM orders;

-- Проверка связей FOREIGN KEY
SELECT orders.order_id,
       orders.order_date,
       orders.shipping_address,
       orders.order_status,
       customers.first_name,
       customers.last_name
FROM orders
         JOIN customers ON orders.customer_id = customers.customer_id;
--Функция для получения общей суммы продаж
CREATE FUNCTION get_order_total(start_date DATE, end_date DATE)
    RETURNS TABLE
            (
                category_name VARCHAR(255),
                total_sales   DECIMAL
            )
AS
$$
BEGIN
    RETURN (SELECT SUM(quantity * unit_price)
            FROM order_details
            WHERE order_details.order_id = get_order_total.order_id);
END;
$$ LANGUAGE plpgsql

--Проверка вызова функции
SELECT *
FROM get_order_total('2022-01-01', '2022-12-31');

--Процедура обновления количества товаров на складе по id заказа:
CREATE PROCEDURE update_order_status(
    order_id INT,
    new_status VARCHAR(50)
)
AS
$$
BEGIN
    UPDATE orders
    SET order_status = update_order_status.new_status
    WHERE orders.order_id = update_order_status.order_id;
END;
$$ LANGUAGE plpgsql;

--Вызов процедуры
CALL update_order_status(1, 'Shipped');