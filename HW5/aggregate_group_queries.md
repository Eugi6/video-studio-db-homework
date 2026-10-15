# HW5 — Агрегатные функции и группировка

## COUNT()

### 1. Количество заказов

```sql
SELECT COUNT(*) AS order_count
FROM studio_order;
```

![Результат запроса 1](screenshots/query_01.png)

### 2. Количество сотрудников, назначенных на заказы

```sql
SELECT COUNT(DISTINCT employee_id) AS employee_count
FROM crew;
```

![Результат запроса 2](screenshots/query_02.png)

## SUM()

### 3. Общая сумма успешных оплат

```sql
SELECT SUM(amount) AS total_amount
FROM payment
WHERE status = 'success';
```

![Результат запроса 3](screenshots/query_03.png)

### 4. Общая сумма авансов по 30% от каждой оплаты

```sql
SELECT SUM(amount * 0.3) AS total_advance
FROM payment;
```

![Результат запроса 4](screenshots/query_04.png)

## AVG()

### 5. Средняя сумма оплаты

```sql
SELECT ROUND(AVG(amount), 2) AS average_amount
FROM payment;
```

![Результат запроса 5](screenshots/query_05.png)

### 6. Средняя сумма безналичной оплаты

```sql
SELECT ROUND(AVG(amount), 2) AS average_amount
FROM payment
WHERE source IN ('card', 'transfer');
```

![Результат запроса 6](screenshots/query_06.png)

## MIN()

### 7. Минимальная сумма оплаты

```sql
SELECT MIN(amount) AS min_amount
FROM payment;
```

![Результат запроса 7](screenshots/query_07.png)

### 8. Самая ранняя дата создания заказа

```sql
SELECT MIN(created_at) AS first_order_date
FROM studio_order;
```

![Результат запроса 8](screenshots/query_08.png)

## MAX()

### 9. Максимальная сумма оплаты

```sql
SELECT MAX(amount) AS max_amount
FROM payment;
```

![Результат запроса 9](screenshots/query_09.png)

### 10. Дата последней оплаты

```sql
SELECT MAX(payment_datetime) AS last_payment_date
FROM payment;
```

![Результат запроса 10](screenshots/query_10.png)

## STRING_AGG()

### 11. Имена клиентов одной строкой

```sql
SELECT STRING_AGG(name, ', ' ORDER BY name) AS client_names
FROM client;
```

![Результат запроса 11](screenshots/query_11.png)

### 12. Список разных ролей съёмочной команды

```sql
SELECT STRING_AGG(DISTINCT role, ', ' ORDER BY role) AS roles
FROM crew;
```

![Результат запроса 12](screenshots/query_12.png)

## GROUP BY

### 13. Количество видео по каждому заказу

```sql
SELECT order_id, COUNT(*) AS video_count
FROM video
GROUP BY order_id;
```

![Результат запроса 13](screenshots/query_13.png)

### 14. Сумма оплат по каждому способу оплаты

```sql
SELECT source, SUM(amount) AS total_amount
FROM payment
GROUP BY source;
```

![Результат запроса 14](screenshots/query_14.png)

## HAVING

### 15. Сотрудники, назначенные больше чем на один заказ

```sql
SELECT employee_id, COUNT(*) AS order_count
FROM crew
GROUP BY employee_id
HAVING COUNT(*) > 1;
```

![Результат запроса 15](screenshots/query_15.png)

### 16. Заказы, для которых подготовлено больше одного видео

```sql
SELECT order_id, COUNT(*) AS video_count
FROM video
GROUP BY order_id
HAVING COUNT(*) > 1;
```

![Результат запроса 16](screenshots/query_16.png)

## GROUPING SETS

### 17. Суммы оплат по способам, по статусам и общий итог

```sql
SELECT source, status, SUM(amount) AS total_amount
FROM payment
GROUP BY GROUPING SETS ((source), (status), ());
```

![Результат запроса 17](screenshots/query_17.png)

### 18. Количество назначений по сотрудникам, по заказам и общий итог

```sql
SELECT employee_id, order_id, COUNT(*) AS assignment_count
FROM crew
GROUP BY GROUPING SETS ((employee_id), (order_id), ());
```

![Результат запроса 18](screenshots/query_18.png)

## ROLLUP

### 19. Суммы оплат по способу и статусу с итогами по способу и общим итогом

```sql
SELECT source, status, SUM(amount) AS total_amount
FROM payment
GROUP BY ROLLUP (source, status);
```

![Результат запроса 19](screenshots/query_19.png)

### 20. Количество назначений по заказу и роли с итогами по заказу и общим итогом

```sql
SELECT order_id, role, COUNT(*) AS assignment_count
FROM crew
GROUP BY ROLLUP (order_id, role);
```

![Результат запроса 20](screenshots/query_20.png)

## CUBE

### 21. Суммы оплат по всем сочетаниям способа и статуса

```sql
SELECT source, status, SUM(amount) AS total_amount
FROM payment
GROUP BY CUBE (source, status);
```

![Результат запроса 21](screenshots/query_21.png)

### 22. Количество назначений по всем сочетаниям сотрудника и заказа

```sql
SELECT employee_id, order_id, COUNT(*) AS assignment_count
FROM crew
GROUP BY CUBE (employee_id, order_id);
```

![Результат запроса 22](screenshots/query_22.png)

## SELECT, FROM, WHERE, GROUP BY, HAVING, ORDER BY

### 23. Способы безналичной оплаты с общей суммой от 15000 рублей

```sql
SELECT source, COUNT(*) AS payment_count, SUM(amount) AS total_amount
FROM payment
WHERE source IN ('card', 'transfer')
GROUP BY source
HAVING SUM(amount) >= 15000
ORDER BY total_amount DESC;
```

![Результат запроса 23](screenshots/query_23.png)

### 24. Сотрудники с несколькими назначениями оператором или монтажёром

```sql
SELECT employee_id, COUNT(*) AS order_count,
       STRING_AGG(order_id::TEXT, ', ' ORDER BY order_id) AS orders
FROM crew
WHERE role IN ('оператор', 'монтажёр')
GROUP BY employee_id
HAVING COUNT(*) > 1
ORDER BY order_count DESC, employee_id;
```

![Результат запроса 24](screenshots/query_24.png)
