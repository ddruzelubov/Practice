# Express Homework — Druzelubov
 
Реализованы базовые эндпоинты и CRUD‑операции для сущностей `items` и `expenses`.

---

## Запуск проекта

```bash
# Установка зависимостей
npm install

# Запуск сервера
npm run start

# Запуск в режиме разработки (с nodemon)
npm run dev
```


## Примеры запросов (Windows cmd)

# Получить список items

curl -X GET http://localhost:3000/items

# Получить item по id

curl -X GET http://localhost:3000/items/1

# Создание item
curl -X POST http://localhost:3000/items ^
  -H "Content-Type: application/json" ^
  -d "{\"title\":\"test\"}"

# Полностью обновить item

curl -X PUT http://localhost:3000/items/1 ^
  -H "Content-Type: application/json" ^
  -d "{\"title\":\"Updated item\",\"description\":\"Полное обновление\"}"

# Частично обновить item

curl -X PATCH http://localhost:3000/items/1 ^
  -H "Content-Type: application/json" ^
  -d "{\"description\":\"Частичное обновление\"}"

# Удалить item

curl -X DELETE http://localhost:3000/items/1

# Получить список расходов

curl -X GET http://localhost:3000/expense

# Получить один расход по id

curl -X GET http://localhost:3000/expense/1

# Создать новый расход

curl -X POST http://localhost:3000/expense ^
  -H "Content-Type: application/json" ^
  -d "{\"amount\":250,\"category\":\"Transport\"}"

# Полностью обновить расход 

curl -X PUT http://localhost:3000/expense/1 ^
  -H "Content-Type: application/json" ^
  -d "{\"amount\":300,\"category\":\"Food\",\"date\":\"2025-12-01\"}"

# Частично обновить расход

curl -X PATCH http://localhost:3000/expense/1 ^
  -H "Content-Type: application/json" ^
  -d "{\"category\":\"Entertainment\"}"

# Удалить расход

curl -X DELETE http://localhost:3000/expense/1






