-- HW2: база данных видеостудии (PostgreSQL)

-- Создание таблиц
CREATE TABLE client (
    client_id INTEGER PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE employee (
    employee_id INTEGER PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE studio_order (
    order_id INTEGER PRIMARY KEY,
    client_id INTEGER NOT NULL REFERENCES client(client_id),
    description TEXT NOT NULL
);

CREATE TABLE crew (
    employee_id INTEGER NOT NULL REFERENCES employee(employee_id),
    order_id INTEGER NOT NULL REFERENCES studio_order(order_id),
    PRIMARY KEY (employee_id, order_id)
);

CREATE TABLE video (
    video_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES studio_order(order_id),
    description TEXT NOT NULL
);

CREATE TABLE payment (
    payment_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL UNIQUE REFERENCES studio_order(order_id),
    status VARCHAR(30) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    source VARCHAR(100) NOT NULL,
    payment_datetime TIMESTAMP NOT NULL
);

-- Изменение структуры таблиц
ALTER TABLE employee ADD COLUMN email VARCHAR(100);
ALTER TABLE studio_order ADD COLUMN created_at TIMESTAMP;
ALTER TABLE crew ADD COLUMN role VARCHAR(30);

-- Тестовые данные
INSERT INTO client (client_id, name) VALUES (1, 'Валера');
INSERT INTO client (client_id, name) VALUES (2, 'Мария');
INSERT INTO client (client_id, name) VALUES (3, 'Антон');

INSERT INTO employee (employee_id, name) VALUES (1, 'Егор');
INSERT INTO employee (employee_id, name) VALUES (2, 'Лена');
INSERT INTO employee (employee_id, name) VALUES (3, 'Тимур');

INSERT INTO studio_order (order_id, description, client_id)
VALUES (1, 'свадьба', 1);
INSERT INTO studio_order (order_id, description, client_id, created_at)
VALUES (2, 'интервью', 2, '2026-09-20 14:30:00');
INSERT INTO studio_order (order_id, description, client_id, created_at)
VALUES (3, 'рекламный ролик', 3, '2026-09-22 10:00:00');

INSERT INTO crew (employee_id, order_id, role) VALUES (1, 1, 'оператор');
INSERT INTO crew (employee_id, order_id, role) VALUES (2, 1, 'монтажёр');
INSERT INTO crew (employee_id, order_id, role) VALUES (1, 2, 'оператор');
INSERT INTO crew (employee_id, order_id, role) VALUES (3, 2, 'звукорежиссёр');
INSERT INTO crew (employee_id, order_id, role) VALUES (2, 3, 'монтажёр');

INSERT INTO video (video_id, order_id, description) VALUES (1, 1, 'ролик с церемонии');
INSERT INTO video (video_id, order_id, description) VALUES (2, 1, 'полная версия');
INSERT INTO video (video_id, order_id, description) VALUES (3, 2, 'интервью');
INSERT INTO video (video_id, order_id, description) VALUES (4, 3, 'рекламный ролик');

INSERT INTO payment (payment_id, order_id, status, amount, source, payment_datetime)
VALUES (1, 1, 'success', 25000.00, 'card', '2026-09-21 12:15:00');
INSERT INTO payment (payment_id, order_id, status, amount, source, payment_datetime)
VALUES (2, 2, 'success', 12000.00, 'transfer', '2026-09-22 16:00:00');
INSERT INTO payment (payment_id, order_id, status, amount, source, payment_datetime)
VALUES (3, 3, 'pending', 30000.00, 'cash', '2026-09-23 09:00:00');

-- Изменение данных
UPDATE payment
SET status = 'success'
WHERE payment_id = 3;

UPDATE video
SET description = 'финальная версия интервью'
WHERE video_id = 3;

UPDATE crew
SET role = 'старший монтажёр'
WHERE employee_id = 2 AND order_id = 3;
