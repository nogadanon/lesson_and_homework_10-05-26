-- One-to-Many 1:N

-- Create a categories table: id PK AUTOINCREMENT, title TEXT UNIQUE NOT NULL.
CREATE TABLE categories (
id INTEGER PRIMARY KEY AUTOINCREMENT,
title TEXT UNIQUE NOT NULL
);

-- Create a posts table: id PK AUTOINCREMENT, category_id FK (NOT NULL), title TEXT, views INTEGER DEFAULT 0. Use ON DELETE RESTRICT.
CREATE TABLE posts (
id INTEGER PRIMARY KEY AUTOINCREMENT,
category_id NOT NULL,
FOREIGN KEY (category_id) REFERENCES categories(id) 
);

-- Insert 3 categories and at least 5 posts spread across the categories.
INSERT INTO categories (title)
VALUES ('technology'), ('lifestyle'), ('travel');

INSERT INTO posts (category_id)
VALUES (1), (3), (2), (2), (3);

-- Query: list all posts with their category title using INNER JOIN.
SELECT p.id AS post_id, c.id AS category_id, c.title AS category_title
FROM categories c JOIN posts p ON c.id = p.category_id;

-- Query: count posts per category, show categories with 0 posts too (use LEFT JOIN + GROUP BY).
SELECT c.title AS category_title, COUNT(c.title) AS amount_posts_per_category
FROM categories c LEFT JOIN posts p ON c.id = p.category_id
GROUP BY category_title;

-- Query: find the category with the highest total views using GROUP BY + ORDER BY + LIMIT 1.
SELECT c.title AS category_title, COUNT(c.title) AS amount_posts_per_category
FROM categories c LEFT JOIN posts p ON c.id = p.category_id
GROUP BY category_title
ORDER BY amount_posts_per_category DESC
LIMIT 1;
