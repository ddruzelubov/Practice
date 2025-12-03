--Вывести список всех клиентов из города Минск.
SELECT * FROM customers
WHERE city='Минск';

--Вывести названия и цены всех товаров, отсортированных по убыванию цены.
SELECT product_name, price
FROM products
ORDER BY price DESC;

--Посчитать общее количество клиентов в базе данных.
SELECT COUNT(*) AS number_of_clients FROM customers;

--Найти общую сумму всех заказов.
SELECT SUM(total_amount) AS total_amount_orders FROM orders;

--Вывести список всех заказов с указанием имени клиента и даты заказа.
SELECT o.order_id, c.customer_name, o.order_date
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

--Найти общую сумму потраченных средств для каждого клиента. Вывести имя клиента и общую сумму.
SELECT c.customer_name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name;

--Вывести имена клиентов, которые сделали заказ после '2023-10-01'.
SELECT DISTINCT c.customer_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_date > '2023-10-01';

--Найти клиентов, общая сумма заказов которых превышает 10000.
SELECT c.customer_name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
HAVING SUM(o.total_amount) > 10000;

--Вывести для каждого клиента его заказы, отсортированные по дате, и добавить столбец с номером заказа по порядку для каждого клиента (ранг).
SELECT c.customer_name, o.order_id, o.order_date,
ROW_NUMBER() OVER (PARTITION BY c.customer_id ORDER BY o.order_date) AS order_rank
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id;

--Для каждого заказа вывести его дату и дату предыдущего заказа этого же клиента.
SELECT o.order_id, o.order_date,
LAG(o.order_date) OVER (PARTITION BY o.customer_id ORDER BY o.order_date) AS previous_order_date
FROM orders o;

--Найти клиентов с одинаковыми именами в одном городе.
SELECT customer_name, city, COUNT(*)
FROM customers
GROUP BY customer_name, city
HAVING COUNT(*) > 1;

--Вывести заказы с нарастающим итогом суммы заказов по месяцам.
SELECT TO_CHAR(order_date, 'YYYY-MM') AS order_month,
SUM(total_amount) AS monthly_total,
SUM(SUM(total_amount)) OVER (ORDER BY TO_CHAR(order_date, 'YYYY-MM')) AS total_sum
FROM orders
GROUP BY order_month
ORDER BY order_month;

--Найти клиентов, которые купили *все* товары из категории 'Электроника'.
--*(Предположим, у нас есть таблица `order_items` с `order_id`, `product_id` и `quantity`)*.
SELECT c.customer_id, c.customer_name
FROM customers c
WHERE (
    SELECT COUNT(DISTINCT p.product_id)
    FROM products p
    WHERE p.category = 'Электроника'
) = (
    SELECT COUNT(DISTINCT oi.product_id)
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    WHERE o.customer_id = c.customer_id AND p.category = 'Электроника'
);

--Найти товар с наибольшим количеством продаж (по штукам) в каждой категории.
SELECT DISTINCT ON (category) product_id, product_name, category, total_quantity
FROM (
SELECT p.product_id, p.product_name, p.category,
  SUM(oi.quantity) AS total_quantity
  FROM products p
  LEFT JOIN order_items oi ON p.product_id = oi.product_id
  GROUP BY p.product_id, p.product_name, p.category
) AS total_sell
ORDER BY category, total_quantity DESC;
