# HW6 — CTE, операции над множествами и оконные функции

## 1. CTE

### 1.1 Оплаты выше средней суммы по всем оплатам

```sql
WITH payment_average AS (
    SELECT AVG(amount) AS avg_amount
    FROM payment
)
SELECT payment_id, amount
FROM payment
WHERE amount > (SELECT avg_amount FROM payment_average);
```

![Результат запроса 1.1](screenshots/cte_query_1_1.png)

### 1.2 Заказы, для которых подготовлено больше одного видео

```sql
WITH order_counts AS (
    SELECT order_id, COUNT(*) AS video_count
    FROM video
    GROUP BY order_id
)
SELECT order_id, video_count
FROM order_counts
WHERE video_count > 1;
```

![Результат запроса 1.2](screenshots/cte_query_1_2.png)

### 1.3 Способы оплаты с общей суммой оплат больше 20000 рублей

```sql
WITH total_amounts AS (
    SELECT source, SUM(amount) AS total_amount
    FROM payment
    GROUP BY source
)
SELECT source, total_amount
FROM total_amounts
WHERE total_amount > 20000;
```

![Результат запроса 1.3](screenshots/cte_query_1_3.png)

## 2. UNION, INTERSECT, EXCEPT

### 2.1 Уникальные имена клиентов и сотрудников

```sql
SELECT name FROM client
UNION
SELECT name FROM employee;
```

![Результат запроса 2.1](screenshots/cte_query_2_1.png)

### 2.2 Сотрудники, назначенные и на заказ 1, и на заказ 2

```sql
SELECT employee_id FROM crew WHERE order_id = 1
INTERSECT
SELECT employee_id FROM crew WHERE order_id = 2;
```

![Результат запроса 2.2](screenshots/cte_query_2_2.png)

### 2.3 Сотрудники, назначенные на заказ 1, но не на заказ 2

```sql
SELECT employee_id FROM crew WHERE order_id = 1
EXCEPT
SELECT employee_id FROM crew WHERE order_id = 2;
```

![Результат запроса 2.3](screenshots/cte_query_2_3.png)

## 3. Оконные функции с PARTITION BY

### 3.1 Назначения сотрудников и количество сотрудников на каждом заказе

```sql
SELECT order_id, employee_id,
       COUNT(*) OVER (PARTITION BY order_id) AS crew_count
FROM crew;
```

![Результат запроса 3.1](screenshots/cte_query_3_1.png)

### 3.2 Видео и количество видео у соответствующего заказа

```sql
SELECT video_id, order_id,
       COUNT(*) OVER (PARTITION BY order_id) AS video_count
FROM video;
```

![Результат запроса 3.2](screenshots/cte_query_3_2.png)

## 4. PARTITION BY и ORDER BY

### 4.1 Накопленное количество видео внутри заказа

```sql
SELECT order_id, video_id,
       COUNT(*) OVER (
           PARTITION BY order_id ORDER BY video_id
       ) AS running_video_count
FROM video
ORDER BY order_id, video_id;
```

![Результат запроса 4.1](screenshots/cte_query_4_1.png)

### 4.2 Накопленное количество назначений сотрудника

```sql
SELECT employee_id, order_id,
       COUNT(*) OVER (
           PARTITION BY employee_id ORDER BY order_id
       ) AS running_order_count
FROM crew
ORDER BY employee_id, order_id;
```

![Результат запроса 4.2](screenshots/cte_query_4_2.png)

## 5. Границы окна ROWS

### 5.1 Сумма текущей и предыдущей оплаты одного способа

```sql
SELECT payment_id, source, payment_datetime, amount,
       SUM(amount) OVER (
           PARTITION BY source ORDER BY payment_datetime, payment_id
           ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
       ) AS last_two_total
FROM payment
ORDER BY source, payment_datetime, payment_id;
```

![Результат запроса 5.1](screenshots/cte_query_5_1.png)

### 5.2 Средняя сумма по текущей и двум предыдущим оплатам

```sql
SELECT payment_id, source, payment_datetime, amount,
       ROUND(AVG(amount) OVER (
           PARTITION BY source ORDER BY payment_datetime, payment_id
           ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ), 2) AS last_three_average
FROM payment
ORDER BY source, payment_datetime, payment_id;
```

![Результат запроса 5.2](screenshots/cte_query_5_2.png)

## 6. Границы окна RANGE

### 6.1 Общая сумма оплат не дороже текущей внутри способа оплаты

```sql
SELECT payment_id, source, amount,
       SUM(amount) OVER (
           PARTITION BY source ORDER BY amount
           RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS cumulative_amount
FROM payment
ORDER BY source, amount, payment_id;
```

![Результат запроса 6.1](screenshots/cte_query_6_1.png)

### 6.2 Количество оплат в диапазоне от текущей суммы минус 5000 до текущей

```sql
SELECT payment_id, source, amount,
       COUNT(*) OVER (
           PARTITION BY source ORDER BY amount
           RANGE BETWEEN 5000 PRECEDING AND CURRENT ROW
       ) AS nearby_payment_count
FROM payment
ORDER BY source, amount, payment_id;
```

![Результат запроса 6.2](screenshots/cte_query_6_2.png)

## 7. Ранжирование

### 7.1 Порядковый номер оплаты по убыванию суммы внутри способа

```sql
SELECT payment_id, source, amount,
       ROW_NUMBER() OVER (
           PARTITION BY source ORDER BY amount DESC, payment_id
       ) AS payment_number
FROM payment
ORDER BY source, payment_number;
```

![Результат запроса 7.1](screenshots/cte_query_7_1.png)

### 7.2 Место оплаты по сумме с пропусками после одинаковых сумм

```sql
SELECT payment_id, source, amount,
       RANK() OVER (
           PARTITION BY source ORDER BY amount DESC
       ) AS payment_rank
FROM payment
ORDER BY source, payment_rank, payment_id;
```

![Результат запроса 7.2](screenshots/cte_query_7_2.png)

### 7.3 Место оплаты по сумме без пропусков

```sql
SELECT payment_id, source, amount,
       DENSE_RANK() OVER (
           PARTITION BY source ORDER BY amount DESC
       ) AS payment_rank
FROM payment
ORDER BY source, payment_rank, payment_id;
```

![Результат запроса 7.3](screenshots/cte_query_7_3.png)

## 8. Функции смещения

### 8.1 Сумма предыдущей по времени оплаты того же способа

```sql
SELECT payment_id, source, payment_datetime, amount,
       LAG(amount) OVER (
           PARTITION BY source ORDER BY payment_datetime, payment_id
       ) AS previous_amount
FROM payment
ORDER BY source, payment_datetime, payment_id;
```

![Результат запроса 8.1](screenshots/cte_query_8_1.png)

### 8.2 Сумма следующей по времени оплаты того же способа

```sql
SELECT payment_id, source, payment_datetime, amount,
       LEAD(amount) OVER (
           PARTITION BY source ORDER BY payment_datetime, payment_id
       ) AS next_amount
FROM payment
ORDER BY source, payment_datetime, payment_id;
```

![Результат запроса 8.2](screenshots/cte_query_8_2.png)

### 8.3 Сумма первой по времени оплаты каждого способа

```sql
SELECT payment_id, source, payment_datetime, amount,
       FIRST_VALUE(amount) OVER (
           PARTITION BY source ORDER BY payment_datetime, payment_id
           ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
       ) AS first_amount
FROM payment
ORDER BY source, payment_datetime, payment_id;
```

![Результат запроса 8.3](screenshots/cte_query_8_3.png)

### 8.4 Сумма последней по времени оплаты каждого способа

```sql
SELECT payment_id, source, payment_datetime, amount,
       LAST_VALUE(amount) OVER (
           PARTITION BY source ORDER BY payment_datetime, payment_id
           ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
       ) AS last_amount
FROM payment
ORDER BY source, payment_datetime, payment_id;
```

![Результат запроса 8.4](screenshots/cte_query_8_4.png)
