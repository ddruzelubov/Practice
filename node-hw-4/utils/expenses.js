let expenses = [];
let idCounter = 0;

function getAll(){
    return expenses;
}

function getById(id){
    return expenses.find(expense => expense.id === id);
}

function create(amount, category){
    const newExpense = {
        id: ++idCounter,
        amount,
        category,
        createdAt: new Date().toISOString()
    }
    expenses.push(newExpense);
    return newExpense;
}

function update(id, data){
    const index = expenses.findIndex(expense => expense.id === id);
    if(index === -1) return null;
    expenses[index] = {...expenses[index], ...data};
    return expenses[index];
}

function remove(id){
    const index = expenses.findIndex(expense => expense.id === id);
    if (index === -1) return null;
    return expenses.splice(index, 1)[0];
}

module.exports = {getAll, getById, create, update, remove};