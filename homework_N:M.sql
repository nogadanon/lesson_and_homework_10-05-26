-- Many-to-Many N:M

-- 1. Create orders: id PK AUTOINCREMENT, order_no TEXT UNIQUE, address TEXT NOT NULL, phone TEXT NOT NULL, ordered_at TEXT DEFAULT (date('now'))
CREATE TABLE orders (
id INTEGER PRIMARY KEY AUTOINCREMENT,
order_no TEXT UNIQUE,
address TEXT NOT NULL,
phone TEXT NOT NULL,
ordered_at TEXT DEFAULT(DATE('NOW'))
);

-- 2. Create products: id PK AUTOINCREMENT, name TEXT NOT NULL, unit_price REAL NOT NULL CHECK (unit_price >= 0)
CREATE TABLE products (
id INTEGER PRIMARY KEY AUTOINCREMENT,
name TEXT NOT NULL,
unit_price REAL NOT NULL CHECK(unit_price >= 0)
);

-- 3. Create sales (junction): order_id FK, product_id FK, qty INTEGER NOT NULL DEFAULT 1 CHECK (qty > 0), with composite PK (order_id, product_id) (Each row means one product sold in one order)
CREATE TABLE sales (
order_id INTEGER,
product_id INTEGER,
qty INTEGER NOT NULL DEFAULT (1) CHECK (qty > 0),
PRIMARY KEY (order_id, product_id),
FOREIGN KEY (order_id) REFERENCES orders(id)
FOREIGN KEY (product_id) REFERENCES products(id)
);

-- 4. Insert sample data:
INSERT INTO orders (id, order_no, address, phone, ordered_at)
VALUES
          (1, 'ORD-1001', '12 Lake St, Boston',  '+1-555-0101', '2026-01-05'),
          (2, 'ORD-1002', '12 Lake St, Boston',  '+1-555-0101', '2026-01-07'),
          (3, 'ORD-1003', '88 Pine Ave, Seattle', '+1-555-0202', '2026-01-09'),
          (4, 'ORD-1004', '44 Nile Rd, Cairo',    '+1-555-0303', '2026-01-10'),
          (5, 'ORD-1005', '77 Hill Rd, Austin',   '+1-555-0404', '2026-01-11'); -- no sales rows

INSERT INTO products (id, name, unit_price)
VALUES
  (1, 'Laptop', 1200),
  (2, 'Mouse', 25),
  (3, 'Keyboard', 80),
  (4, 'Webcam', 95),
  (5, 'Monitor', 280),
  (6, 'Desk Lamp', 35),
  (7, 'USB Hub', 40);

INSERT INTO sales (order_id, product_id, qty)
VALUES
  (1, 1, 1),
  (1, 2, 2),
  (1, 3, 1),
  (2, 4, 1),
  (2, 7, 2),
  (3, 5, 1),
  (3, 6, 3),
  (4, 2, 1),
  (4, 7, 1);
  
-- 5. Write a query to show each sold product with order_no, address, phone, product_name, qty, unit_price, and line total (qty * unit_price)
SELECT o.order_no, o.address, o.phone, p.name AS product_name, s.qty, p.unit_price, (s.qty * p.unit_price) AS total_amount
FROM orders o LEFT JOIN sales s ON s.order_id = o.id
JOIN products p ON p.id = s.product_id;

-- 6. Write a query to list each order with total item count (SUM(qty)) and total price (SUM(qty * unit_price))
SELECT o.order_no, SUM(s.qty) AS total_item_count, SUM(s.qty * p.unit_price) AS total_price
FROM orders o LEFT JOIN sales s ON s.order_id = o.id
JOIN products p ON p.id = s.product_id
GROUP BY o.order_no;

-- 7. Write a query to list each order with all product names. Make sure to print all products of the same order before going to the next order
SELECT o.order_no, p.name, s.qty
FROM orders o JOIN sales s ON s.order_id = o.id
JOIN products p ON p.id = s.product_id
GROUP BY o.order_no, p.name;

-- 8. Write a query to calculate each phone (or address) and the sum of all orders
SELECT o.phone, SUM(p.unit_price) AS total_price_for_all_orders_per_phone_no
FROM orders o JOIN sales s ON s.order_id = o.id
JOIN products p ON p.id = s.product_id
GROUP BY o.phone;

-- 9. Write a query to show orders that have no products in sales
SELECT o.order_no
FROM orders o FULL OUTER JOIN sales s ON s.order_id = o.id
FULL OUTER JOIN products p ON p.id = s.product_id
WHERE p.id IS NULL; -- one way
GROUP BY o.order_no -- another way in case there is a sale without products
HAVING SUM(p.id) IS NULL;
