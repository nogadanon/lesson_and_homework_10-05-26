-- 1:1 

-- Create a citizens table with columns: citizen_id (PK AUTOINCREMENT), full_name TEXT NOT NULL, city TEXT.
CREATE TABLE citizens (
citizen_id INTEGER  PRIMARY KEY AUTOINCREMENT,
full_name TEXT NOT NULL,
city TEXT
);

-- Create an id_cards table with citizen_id as both PK and FK referencing citizens(citizen_id) with ON DELETE CASCADE. Also add card_number TEXT UNIQUE NOT NULL and expires TEXT.
CREATE TABLE id_cards (
citizen_id INTEGER PRIMARY KEY,
card_number TEXT UNIQUE NOT NULL,
expires TEXT,
FOREIGN KEY (citizen_id) REFERENCES citizens(citizen_id)
ON DELETE CASCADE
);

-- Insert 3 citizens: Sophia Martinez (Barcelona), James Chen (Toronto), Amira Hassan (Cairo).
INSERT INTO citizens (full_name, city)
VALUES ('Sophia Martinez', 'Barcelona'), 
('James Chen', 'Toronto'),
('Amira Hassan', 'Cairo');

-- Insert 2 cards: Sophia (ID-2024-5521, expires: 2032-12-15) and James (ID-2023-7744, expires: 2031-08-22). Leave Amira without a card.
INSERT INTO id_cards (citizen_id, card_number, expires)
VALUES (1, 'ID-2024-5521', '2032-12-15'),
(2, 'ID-2023-7744', '2031-08-22');

-- Write an INNER JOIN query to list citizens with their card number.
SELECT c.full_name, id.card_number
FROM citizens c INNER JOIN id_cards id ON c.citizen_id = id.citizen_id

-- Write a LEFT JOIN query to show ALL citizens — displaying 'No card' for those without one.
SELECT c.full_name, COALESCE(id.card_number, 'No card')
FROM citizens c LEFT JOIN id_cards id ON c.citizen_id = id.citizen_id;

-- Try inserting a second id card for citizen id 1. What error do you get and why?
INSERT INTO id_cards (citizen_id, card_number, expires)
VALUES (1, 'ID-2222-2222', '2032-12-15');
-- answr: 'UNIQUE constraint failed: id_cards.citizen_id'

-- Delete a citizen (who has an id card). Then query the id_cards table. What happened to their card? Why?
DELETE FROM citizens
WHERE citizen_id = 1 ;

SELECT *
FROM id_cards;
