# HW4 — SELECT и JOIN

## Выборка всех данных из таблицы

### 1. Все данные клиентов

```sql
SELECT *
FROM client;
```

![Результат запроса 1](screenshots/query_01.png)

### 2. Все данные сотрудников

```sql
SELECT *
FROM employee;
```

![Результат запроса 2](screenshots/query_02.png)

## Выборка отдельных столбцов

### 3. Имена и email сотрудников

```sql
SELECT name, email
FROM employee;
```

![Результат запроса 3](screenshots/query_03.png)

### 4. Номера видео и их описания

```sql
SELECT video_id, description
FROM video;
```

![Результат запроса 4](screenshots/query_04.png)

## Присвоение новых имен столбцам при формировании выборки

### 5. Клиенты с понятными названиями столбцов

```sql
SELECT client_id AS "Код клиента", name AS "Клиент"
FROM client;
```

![Результат запроса 5](screenshots/query_05.png)

### 6. Оплаты с понятными названиями столбцов

```sql
SELECT payment_id AS "Оплата", amount AS "Сумма"
FROM payment;
```

![Результат запроса 6](screenshots/query_06.png)

## Выборка данных с созданием вычисляемого столбца

### 7. Расчёт аванса в размере 30% от суммы оплаты

```sql
SELECT payment_id, amount, amount * 0.3 AS advance_amount
FROM payment;
```

![Результат запроса 7](screenshots/query_07.png)

### 8. Дата через неделю после создания заказа

```sql
SELECT order_id, created_at, created_at + INTERVAL '7 days' AS date_in_week
FROM studio_order;
```

![Результат запроса 8](screenshots/query_08.png)

## Выборка данных, вычисляемые столбцы, математические функции

### 9. Сумма одной из трёх равных частей оплаты с округлением

```sql
SELECT payment_id, ROUND(amount / 3, 2) AS installment_amount
FROM payment;
```

![Результат запроса 9](screenshots/query_09.png)

### 10. Разница между суммой оплаты и бюджетом в 20000 рублей

```sql
SELECT payment_id, amount, ABS(amount - 20000) AS budget_difference
FROM payment;
```

![Результат запроса 10](screenshots/query_10.png)

## Выборка данных, вычисляемые столбцы, логические функции (CASE)

### 11. Категория оплаты по сумме

```sql
SELECT payment_id, amount,
       CASE
           WHEN amount < 15000 THEN 'Небольшая'
           WHEN amount < 30000 THEN 'Средняя'
           ELSE 'Крупная'
       END AS amount_category
FROM payment;
```

![Результат запроса 11](screenshots/query_11.png)

### 12. Указана ли дата создания заказа

```sql
SELECT order_id, description,
       CASE
           WHEN created_at IS NULL THEN 'Дата не указана'
           ELSE 'Дата указана'
       END AS date_status
FROM studio_order;
```

![Результат запроса 12](screenshots/query_12.png)

## Выборка данных по условию

### 13. Оплаты больше 20000 рублей

```sql
SELECT payment_id, order_id, amount
FROM payment
WHERE amount > 20000;
```

![Результат запроса 13](screenshots/query_13.png)

### 14. Назначения операторов

```sql
SELECT employee_id, order_id, role
FROM crew
WHERE role = 'оператор';
```

![Результат запроса 14](screenshots/query_14.png)

## Выборка данных, логические операции

### 15. Успешные оплаты от 20000 рублей

```sql
SELECT payment_id, amount, status
FROM payment
WHERE status = 'success' AND amount >= 20000;
```

![Результат запроса 15](screenshots/query_15.png)

### 16. Оплаты картой или наличными

```sql
SELECT payment_id, amount, source
FROM payment
WHERE source = 'card' OR source = 'cash';
```

![Результат запроса 16](screenshots/query_16.png)

## Выборка данных, операторы BETWEEN, IN

### 17. Оплаты от 10000 до 25000 рублей

```sql
SELECT payment_id, amount
FROM payment
WHERE amount BETWEEN 10000 AND 25000;
```

![Результат запроса 17](screenshots/query_17.png)

### 18. Заказы на свадьбу или интервью

```sql
SELECT order_id, description
FROM studio_order
WHERE description IN ('свадьба', 'интервью');
```

![Результат запроса 18](screenshots/query_18.png)

## Выборка данных с сортировкой

### 19. Клиенты по имени

```sql
SELECT client_id, name
FROM client
ORDER BY name;
```

![Результат запроса 19](screenshots/query_19.png)

### 20. Успешные оплаты от большей суммы к меньшей

```sql
SELECT payment_id, order_id, amount, source
FROM payment
WHERE status = 'success'
ORDER BY amount DESC;
```

![Результат запроса 20](screenshots/query_20.png)

## Выборка данных, оператор LIKE

### 21. Клиенты с именем на букву М

```sql
SELECT client_id, name
FROM client
WHERE name LIKE 'М%';
```

![Результат запроса 21](screenshots/query_21.png)

### 22. Видео со словом «интервью» в описании

```sql
SELECT video_id, description
FROM video
WHERE description LIKE '%интервью%';
```

![Результат запроса 22](screenshots/query_22.png)

## Выбор уникальных элементов столбца

### 23. Роли сотрудников на заказах

```sql
SELECT DISTINCT role
FROM crew;
```

![Результат запроса 23](screenshots/query_23.png)

### 24. Способы оплаты

```sql
SELECT DISTINCT source
FROM payment;
```

![Результат запроса 24](screenshots/query_24.png)

## Выбор ограниченного количества возвращаемых строк

### 25. Две самые крупные оплаты

```sql
SELECT payment_id, amount
FROM payment
ORDER BY amount DESC
LIMIT 2;
```

![Результат запроса 25](screenshots/query_25.png)

### 26. Вторая страница списка видео по два видео на странице

```sql
SELECT video_id, description
FROM video
ORDER BY video_id
LIMIT 2 OFFSET 2;
```

![Результат запроса 26](screenshots/query_26.png)

## INNER JOIN

### 27. Заказы и имена клиентов

```sql
SELECT o.order_id, o.description, c.name
FROM studio_order AS o
INNER JOIN client AS c ON o.client_id = c.client_id;
```

![Результат запроса 27](screenshots/query_27.png)

### 28. Сотрудники и их роли на заказах

```sql
SELECT e.name, c.order_id, c.role
FROM employee AS e
INNER JOIN crew AS c ON e.employee_id = c.employee_id;
```

![Результат запроса 28](screenshots/query_28.png)

## LEFT JOIN

### 29. Все клиенты и их заказы, включая клиентов без заказов

```sql
SELECT c.client_id, c.name, o.order_id, o.description
FROM client AS c
LEFT JOIN studio_order AS o ON c.client_id = o.client_id;
```

![Результат запроса 29](screenshots/query_29.png)

### 30. Все заказы и их видео, включая заказы без видео

```sql
SELECT o.order_id, o.description AS order_description,
       v.video_id, v.description AS video_description
FROM studio_order AS o
LEFT JOIN video AS v ON o.order_id = v.order_id;
```

![Результат запроса 30](screenshots/query_30.png)

## RIGHT JOIN

### 31. Все сотрудники и их назначения, включая сотрудников без заказов

```sql
SELECT e.employee_id, e.name, c.order_id, c.role
FROM crew AS c
RIGHT JOIN employee AS e ON c.employee_id = e.employee_id;
```

![Результат запроса 31](screenshots/query_31.png)

### 32. Все заказы и суммы оплат, включая заказы без оплаты

```sql
SELECT o.order_id, o.description, p.amount
FROM payment AS p
RIGHT JOIN studio_order AS o ON p.order_id = o.order_id;
```

![Результат запроса 32](screenshots/query_32.png)

## CROSS JOIN

### 33. Возможные назначения сотрудников на заказы

```sql
SELECT e.employee_id, e.name, o.order_id, o.description
FROM employee AS e
CROSS JOIN studio_order AS o;
```

![Результат запроса 33](screenshots/query_33.png)

### 34. Возможные пары клиентов и сотрудников для консультации

```sql
SELECT c.name AS client_name, e.name AS employee_name
FROM client AS c
CROSS JOIN employee AS e;
```

![Результат запроса 34](screenshots/query_34.png)

## FULL OUTER JOIN

### 35. Все заказы и оплаты, включая заказы без оплаты

```sql
SELECT o.order_id, o.description, p.payment_id, p.amount, p.status
FROM studio_order AS o
FULL OUTER JOIN payment AS p ON o.order_id = p.order_id;
```

![Результат запроса 35](screenshots/query_35.png)

### 36. Видео и оплаты одного заказа, включая видео без оплаты и оплаты заказов без видео

```sql
SELECT v.video_id, v.order_id AS video_order_id, v.description,
       p.payment_id, p.order_id AS payment_order_id, p.amount
FROM video AS v
FULL OUTER JOIN payment AS p ON v.order_id = p.order_id;
```

![Результат запроса 36](screenshots/query_36.png)

## Запросы на выборку из нескольких таблиц

### 37. Сотрудники, их роли и описания заказов

```sql
SELECT e.name, c.role, o.order_id, o.description
FROM employee AS e
INNER JOIN crew AS c ON e.employee_id = c.employee_id
INNER JOIN studio_order AS o ON c.order_id = o.order_id;
```

![Результат запроса 37](screenshots/query_37.png)

### 38. Клиенты и суммы оплат за их заказы

```sql
SELECT c.name, o.order_id, o.description, p.amount
FROM client AS c
INNER JOIN studio_order AS o ON c.client_id = o.client_id
INNER JOIN payment AS p ON o.order_id = p.order_id;
```

![Результат запроса 38](screenshots/query_38.png)
