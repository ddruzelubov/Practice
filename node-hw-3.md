## I уровень
```javascript

const http = require('http');

const PORT = 3000;
const users = ['Alice', 'Bob'];

const server = http.createServer((req, res) => {
  if (req.url === '/') {
    res.writeHead(200, { 'Content-Type': 'text/plain; charset=utf-8' });
    res.end('Server is running');
    return;
  }

  if (req.url === '/users') {
    res.writeHead(200, { 'Content-Type': 'application/json; charset=utf-8' });
    res.end(JSON.stringify(users));
    return;
  }

  res.writeHead(404, { 'Content-Type': 'text/plain; charset=utf-8' });
  res.end('Not Found');
});

server.listen(PORT, () => {
  console.log('HTTP server listening on http://localhost:3000');
});

```

## II уровень
```javascript

const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = 3000;
const DATA_FILE = path.join(__dirname, 'data', 'users.json');

const dataDir = path.dirname(DATA_FILE);
if (!fs.existsSync(dataDir)) {
    fs.mkdirSync(dataDir, { recursive: true });
}

if (!fs.existsSync(DATA_FILE)) {
    fs.writeFileSync(DATA_FILE, JSON.stringify([], null, 2), 'utf-8');
}

const server = http.createServer((req, res) => { 

    if (req.method === 'GET' && req.url === '/') {
        res.writeHead(200, {'Content-Type': 'text/plain; charset=utf-8'});
        res.end('API is running');
        return;
      }
    
    if (req.method === 'GET' && req.url === '/users') {
        try{
            const users = fs.readFileSync(DATA_FILE, 'utf-8');
            res.writeHead(200, {'Content-Type': 'application/json; charset=utf-8'});
            res.end(users);
        } catch(err){
            res.writeHead(500, {'Content-Type': 'application/json; charset=utf-8'});
            res.end(JSON.stringify({error: 'Failed to read users data'}));
        }
        return;
    }

    if(req.method === 'POST' && req.url === '/users'){
        let body = '';

        req.on('data', chunk => {
            body += chunk.toString();
        })

        req.on('end', () => {
            let user;

            try{
                user = JSON.parse(body);
            } catch(err){
                res.writeHead(400, {'Content-Type': 'application/json; charset=utf-8'});
                res.end(JSON.stringify({ error: 'Invalid JSON' }));
                return;
            }

            if(!user.name || typeof user.name !== 'string' || user.name.trim() === ''){
                res.writeHead(400, {'Content-Type': 'application/json; charset=utf-8'});
                res.end(JSON.stringify({ error: 'Field "name" is required and must be a non-empty string' }));
                return;
            }

            try{
                const data = fs.readFileSync(DATA_FILE, 'utf-8');
                const users = JSON.parse(data);

                const newUser = {
                    id: Date.now().toString(),
                    name: user.name.trim(),
                    ...user
                };

                
                users.push(newUser);

                fs.writeFileSync(DATA_FILE, JSON.stringify(users, null, 2), 'utf-8');

                res.writeHead(201, {'Content-Type': 'application/json; charset=utf-8'});
                res.end(JSON.stringify(newUser));
            } catch(err){
                res.writeHead(500, {'Content-Type': 'application/json; charset=utf-8'});
                res.end(JSON.stringify({ error: 'Failed to save user'}))
            }
        });

        return;
    }
    
    
    res.writeHead(404, { 'Content-Type': 'text/plain; charset=utf-8' });
    res.end('Not Found');
})

server.listen(PORT, () => {
    console.log('HTTP server listening on http://localhost:3000')
});

```

## Для проверки

### Главная страница
curl http://localhost:3000/

### Список пользователей 
curl http://localhost:3000/users

### Добавление пользователя
curl -X POST http://localhost:3000/users \
  -H "Content-Type: application/json" \
  -d '{"name": "Катя"}'

### Неверный url
curl http://localhost:3000/user

### Добавление пользователя(отсутствие name)
curl -X POST http://localhost:3000/users \
  -H "Content-Type: application/json" \
  -d "{\"name\": \"   \"}"


