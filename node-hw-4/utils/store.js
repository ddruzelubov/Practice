let items = [];
let idCounter = 0;

function getAll(){
    return items;
}

function getById(id){
    return items.find(item => item.id === id);
}

function create(title, desription){
    const newItem = {
        id: ++idCounter,
        title,
        desription,
        createdAt: new Date().toISOString()
    }
    items.push(newItem);
    return newItem;
}

function update(id, data){
    const index = items.findIndex(item => item.id === id);
    if(index === -1) return null;
    items[index] = {...items[index], ...data};
    return items[index];
}

function remove(id){
    const index = items.findIndex(item => item.id === id);
    if (index === -1) return null;
    return items.splice(index, 1)[0];
}

module.exports = {getAll, getById, create, update, remove};