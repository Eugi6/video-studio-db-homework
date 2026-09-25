# HW1 — База данных видеостудии

## Как работает студия

Клиент оставляет заказ. Над ним могут работать несколько сотрудников, по заказу можно подготовить несколько видео и оформить не более одной оплаты.

## Таблицы

- **Client** — клиент: `client_id` (PK), `name`.
- **Order** — заказ: `order_id` (PK), `client_id` (FK), `description`, `created_at`.
- **Employee** — сотрудник: `employee_id` (PK), `name`, `email`.
- **Crew** — назначение сотрудника на заказ: `employee_id` и `order_id` (составной PK и FK), `role`.
- **Video** — видео по заказу: `video_id` (PK), `order_id` (FK), `description`.
- **Payment** — оплата: `payment_id` (PK), `order_id` (уникальный FK), `status`, `amount`, `source`, `payment_datetime`.

## Связи

- Клиент — заказ: 1:N.
- Заказ — видео: 1:N.
- Сотрудник — заказ: M:N через `Crew`.
- Заказ — оплата: 1:0..1.

В SQL таблица заказов называется `studio_order`, потому что `ORDER` — служебное слово.

## ER-диаграмма

![ER-диаграмма в нотации Crow's Foot](erd.png)

## Запросы реляционной алгебры

### 1. Источники успешных оплат

Получить источники успешных оплат.

`π_source (σ_status='success'(Payment))`

### 2. Сотрудники на заказах на свадьбу

Получить имена сотрудников, назначенных на заказы с описанием «свадьба».

`π_{Employee.name} ((Employee ⋈_{Employee.employee_id=Crew.employee_id} Crew) ⋈_{Crew.order_id=Order.order_id} π_{order_id}(σ_{description='свадьба'}(Order)))`
