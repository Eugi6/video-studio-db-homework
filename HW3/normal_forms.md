# HW3 — Нормальные формы

## Проверка схемы

Функциональные зависимости:

- client: client_id → name, phone, email
- employee: employee_id → name, email, phone
- studio_order: order_id → client_id, description, created_at, status, deadline
- crew: (employee_id, order_id) → role
- video: video_id → order_id, description, duration_seconds, file_path
- payment: payment_id → order_id, status, amount, source, payment_datetime

1НФ выполняется, потому что все значения атомарные.

2НФ выполняется, потому что поля зависят от всего ключа. В crew ключ составной, но роль зависит от обоих полей.

3НФ выполняется, потому что нет транзитивных зависимостей.

НФБК выполняется, потому что все определители являются суперключами.

Получается, что схема уже нормализована, менять ничего не нужно.

## 1. Имя сотрудника в crew

Допустим, добавим имя сотрудника в crew:

```text
crew(employee_id, order_id, role, employee_name)
PRIMARY KEY (employee_id, order_id)
```

Тогда появляется зависимость employee_id → employee_name.

Это плохо, потому что имя сотрудника зависит только от employee_id, а ключ у нас состоит из двух полей. Из-за этого нарушается 2НФ, 3НФ и НФБК.

Также если сотрудник поменяет имя, придется менять его во всех назначениях. Если удалить последнее назначение, имя сотрудника тоже удалится из crew.

Исправляем тем, что убираем employee_name из crew. Имя уже хранится в таблице employee.

```text
crew(employee_id, order_id, role)
employee(employee_id, name, email, phone)
```

## 2. Имя клиента в studio_order

Допустим, добавим имя клиента в таблицу заказов:

```text
studio_order(order_id, client_id, description, created_at, status, deadline, client_name)
PRIMARY KEY (order_id)
```

Получается зависимость order_id → client_id → client_name.

Это плохо, потому что имя клиента зависит от client_id, а не от самого заказа. Из-за этого нарушается 3НФ и НФБК. 2НФ при этом выполняется.

Также если клиент поменяет имя, придется менять его во всех заказах.

Исправляем тем, что убираем client_name из studio_order и оставляем только client_id.

```text
client(client_id, name, phone, email)
studio_order(order_id, client_id, description, created_at, status, deadline)
```

## ER-диаграмма

Схема осталась такой же, как в HW2.

![ER-диаграмма](erd.png)