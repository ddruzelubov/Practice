## Задачи на event loop

### 1
```javascript

const promises = [
  Promise.resolve('Успех 1'),
  Promise.reject('Ошибка'),
  Promise.resolve('Успех 2')
];

Promise.all(promises)
  .then(results => console.log('all:', results))
  .catch(error => console.log('all ошибка:', error)); 
  // Promise.all завершится с ошибкой, если хотя бы один промис отклонён.
  // catch сработает с первым отклонённым значением — 'Ошибка'.
  // выводится позже, потому что .catch добавляется в очередь микротасок после .then от allSettled.

Promise.allSettled(promises)
  .then(results => console.log('allSettled:', results)); 
  // Promise.allSettled всегда завершается успешно, возвращая массив результатов всех промисов.
  // каждый элемент — объект с полем status ('fulfilled' или 'rejected') и соответствующим значением.
  // выводится раньше, потому что .then от allSettled не блокируется ошибками и выполняется сразу после завершения всех промисов.

```

### 2
```javascript

 Promise.resolve("resolve")
 .then(v => {
   console.log(1, v);   //1.  1 resolve
   return "Tnen1";      //
 })
 .then(v => {
   console.log(2, v);   //2. 2 Then1,  выводим сначала, т.к. синхронная задача
   return new Promise(res => {  // возвращаем новый промис
     console.log(3, "start");    //3.   3 Start,  выводим сначала, т.к. синхронная задача внутри промиса
     setTimeout(() => res("Next"), 0);    // ждём завершения setTimeout и передаём Next в res
   });
 })
 .then(v => {
   console.log(4, v);    //4.  4 Next
   throw new Error("Boom");  //возвращаем ошибку Boom
 })
 .catch(e => {
   console.log(5, e.message);    //5.  5 Boom
   return "R";
 })
 .finally(() => {
   console.log(6, "finally-1");   //6.   6 finnally-1
 })
 .then(v => {
   console.log(7, v);     //7.  7 R
   return Promise.reject("Fail");
 })
 .catch(e => {
   console.log(8, e);    //8.  8 Fail
 })
 .finally(() => console.log(9, "finally-2"));   //9.  9 finally-2

```


### 3 
```javascript

async function a1() {
  console.log('1');  // 2. синхронная операция внутри a1()

  try {
    const r = await a2();  // приостанавливает выполнение a1() до завершения a2()
    console.log('2', r);   // 7. выполняется после завершения await и всех предыдущих микротасок
  }
  catch (e) {
    console.log('3', e.message);  // не выполняется, так как ошибок нет
  }
}

async function a2() {
  console.log('4');  // 3. синхронная операция внутри a2()

  await Promise.resolve()
    .then(() => console.log('5'));  // 5. микротаска, выполняется после завершения текущего стека
  return 'ok';  // возвращается после выполнения микротаски
}

setTimeout(() => console.log('6'), 0);  // 9. макротаска, выполняется после всех микротасок

console.log('7');  // 1. первая синхронная операция

a1()  // 2. вызов a1(), начинается выполнение
  .then(() => console.log('8'));  // 8. микротаска, выполняется после завершения a1()

Promise.resolve()
  .then(() => console.log('9'));  // 6. микротаска, добавлена до завершения await в a1()

console.log('10');  // 4. последняя синхронная операция

```


## Практическое задание
```javascript

const fs = require('fs');
const path = require('path');

// Путь к файлу
const filePath = path.join(__dirname, 'users.json');

// --- 1. Чтение текущего списка пользователей ---
let users = [];
try {
  if (fs.existsSync(filePath)) {
    const data = fs.readFileSync(filePath, 'utf-8');
    try {
      users = JSON.parse(data);
      if (!Array.isArray(users)) {
        console.log('Файл повреждён: ожидается массив. Инициализация пустого списка.');
        users = [];
      }
    } catch (err) {
      console.log('Файл содержит невалидный JSON. Инициализация пустого списка.');
      users = [];
    }
  } else {
    console.log('Файл users.json отсутствует. Начинаем с пустого списка.');
    users = [];
  }
} catch (err) {
  console.error('Ошибка при чтении файла:', err.message);
  users = [];
}

console.log('--- BEFORE ---');
console.log(users);

// --- 2. Добавление нового пользователя ---
// Аргументы командной строки: node users.js --name=Иван --email=ivan@example.com
const args = process.argv.slice(2);
const newUser = {};

args.forEach(arg => {
  const [key, value] = arg.split('=');
  if (key.startsWith('--')) {
    newUser[key.slice(2)] = value;
  }
});

// Проверка обязательных полей
if (!newUser.name) {
  console.error('Ошибка: поле "name" обязательно.');
  process.exit(1);
}

// Генерация id, если не передан
if (!newUser.id) {
  newUser.id = Date.now().toString();
}

// Проверка уникальности email и id
if (users.some(u => u.email === newUser.email)) {
  console.error('Ошибка: email уже существует.');
  process.exit(1);
}
if (users.some(u => u.id === newUser.id)) {
  console.error('Ошибка: id уже существует.');
  process.exit(1);
}

// Добавляем дату создания
newUser.createdAt = new Date().toISOString();

// Добавляем пользователя в список
users.push(newUser);

// --- 3. Сохранение списка обратно в файл ---
try {
  fs.writeFileSync(filePath, JSON.stringify(users, null, 2), 'utf-8');
} catch (err) {
  console.error('Ошибка при записи файла:', err.message);
  process.exit(1);
}

// --- 4. Показать содержимое после добавления ---
console.log('--- AFTER ---');
console.log(users);


```
