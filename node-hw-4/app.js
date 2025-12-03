const express = require('express');
const basicRoutes = require('./routes/basic');
const itemRoutes = require('./routes/items');
const expenseRoutes = require('./routes/expenses');
const app = express();

const PORT = process.env.PORT || 3000;

app.use(express.json());

app.use((req, res, next) => {
    console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);
    next();
});

app.use('/', basicRoutes);
app.use('/items', itemRoutes);
app.use('/expense', expenseRoutes);

app.listen(PORT, () => {
    console.log(`Server is running on PORT ${PORT}`);
})