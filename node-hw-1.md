## Механизм eventloop №0
```javascript

const fs = require('fs');

console.log('START'); // 1 cинхронные операции выполняются первыми 

setTimeout(() => {
  console.log('setTimeout 1'); // 4 первая стадия event loop (timers), timer был зарегистрирован раньше, поэтому сработает раньше setTimeout 2

  setImmediate(() => {
    console.log('setImmediate in setTimeout 1'); // 7 выполнится на фазе check первой итерации
  });
}, 0);

setImmediate(() => console.log('setImmidiate')); // 6 выполняется на фазе check первой итерации, после фазы timers 

process.nextTick(() => console.log('Next Tick')); // 3 микротаска nextTick выполняется сразу после текущего стека, раньше любых фаз event loop

setTimeout(() => console.log('setTimeout 2'), 0); // 5 тоже фаза timers первой итерации, pарегистрирован после setTimeout 1, поэтому идёт вторым среди таймеров 0ms

fs.readFile('info.txt', () => {
  // Колбэк приходит на фазе poll 
  setTimeout(() => console.log('readFile setTimeout'), 0); // 10 этот таймер сработает на ближайшей следующей фазе timers после check
  setImmediate(() => console.log('readFile setImmediate')); // 9 фаза check идёт сразу после чтения файла, поэтому setImmediate " выполнится раньше таймера
  process.nextTick(() => console.log('readFile Next Tick')); // 8 выполнится после возврата из колбэка readFile так как является микротаской, до перехода к фазе check
});

console.log('END'); // 2 синхронные операции выполняются первыми

```

## Механизм eventloop №1
```javascript

console.log('A: sync start'); // 1. синхронные операции выполняются первыми

setTimeout(() => {
  console.log('E: setTimeout 0');  // 6. первая стадия eventloop (timers)
}, 0);

Promise.resolve().then(() => {
  console.log('C: promise.then');  // 4. микротаска, выполняется до eventloop
});

queueMicrotask(() => {
  console.log('D: queueMicrotask');  // 5. микротаска, выполняется позже Promise, т.к. попала в очередь микротасок позже Promise
});

process.nextTick(() => {
  console.log('B: nextTick');  // 3. nextTick имеет больший преоритет чем Promise
});

console.log('F: sync end'); // 2. синхронные операции выполняются первыми

```

## Механизм eventloop №2
```javascript

let count = 0;

function tickStorm(limit = 5) {
  if (count >= limit) return;
  process.nextTick(() => {
    console.log(`A: nextTick #${++count}`);
    tickStorm(limit);
  });
}

setTimeout(() => {
  console.log('B: setTimeout 0 (should not be starved)');  // 5. первая стадия eventloop (timers)
}, 0);

Promise.resolve().then(() => {
  console.log('C: promise.then (microtask)');  // 4. микротаска выполняется до eventloop
});

console.log('D: sync start'); // 1. синхронные операции выполняются первыми
tickStorm(5);  // 3. 5 раз выведет nextTick, т.к. nextTick имеет больший преоритет чем Promise
console.log('E: sync end');  // 2. синхронные операции выполняются первыми

```

## Задание 1
```javascript

console.log("Hello, Node.js!");
console.log("Я работаю на сервере!");
console.log("Текущее время:", new Date);
console.log("Версия Node.js:", process.version);
console.log("Платформа:", process.platform);


```

## Задание 2

### файл math.js
```javascript

function add(a, b){
  return a + b
}

function subtract(a, b){
  return a - b
}

function multiply(a, b){
  return a * b
}

function divide(a, b){
  return a / b
}

module.exports = {
  add, subtract, multiply, divide
}

```

### файл calculator.js
```javascript

const math = require('./math.js');

console.log("2 + 3 =", math.add(2, 3));
console.log("10 - 4 =", math.subtract(10, 4));
console.log("5 * 6 =", math.multiply(5, 6));

```

## Задание 3
```javascript

const fs = require('fs');

// Создаем файл с информацией
const content = 
`	Привет из Node.js!
Время создания: ${new Date()}
Версия Node.js: ${process.version}
`;

// Записываем файл
fs.writeFileSync('info.txt', content);
console.log("Файл info.txt создан");

// Читаем файл
const data = fs.readFileSync('info.txt', 'utf8');
console.log("Содержимое файла:");
console.log(data);

// Добавляем информацию в файл
const additionalInfo = "\n\nДополнительная информация:";
fs.appendFileSync('info.txt', additionalInfo);
console.log("Информация добавлена в файл");

// Читаем обновленный файл
const updatedData = fs.readFileSync('info.txt', 'utf8');
console.log("Обновленное содержимое файла:");
console.log(updatedData);

// Читаем файл задом наперёд
const reversed = fs.readFileSync('info.txt', 'utf8')
.split('')  // преобразуем строку в массив символов
.reverse()  // переворачиваем массив
.join('');  // собираем обратно в строку
console.log("Содержимое файла задом наперёд: ");
console.log(reversed);

```


## Задание 4
```javascript

const fs = require('fs');

const fileContent = fs.readFileSync('info.txt', 'utf8');

const evenChars = fileContent
.split('')
.filter((_,index) => index % 2 === 0)  // фильтруем массив, оставляя только чётные символы
.join('');

console.log("Чётные символы из файла info.txt:");
console.log(evenChars);

```