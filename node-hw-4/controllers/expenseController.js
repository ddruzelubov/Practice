const expenses = require('../utils/expenses');

function validate(data){
    if(!data.amount || typeof data.amount !== 'number' || data.amount < 0){
        return 'Amount is required';
    }

    if(!data.category || typeof data.category !== 'string' || data.description.length < 1 || data.description.length > 100){
        return 'Category is required (1-100 chars)';
    }

    return null;
}

exports.getAll = (req, res) => {
    res.json(expenses.getAll());
};

exports.getById = (req, res) => {
    const expense = expenses.getById(req.params.id);
    if(!item) return res.status(404).json({error: 'Item not found'});
    res.json(item);
};

exports.create = (req, res) => {
    const error = validate(req.body);
    if(error) return res.status(400).json({error});
    const expense = expenses.create(req.body.amount, req.body.category);
    res.status(201).josn(expense)
};

exports.update = (req, res) => {
    const error = validate(req.body);
    if (error) return res.status(400).json({ error });
    const expense = expenses.update(Number(req.params.id), req.body);
    if (!expense) return res.status(404).json({ error: "Item not found" });
    res.json(expense);
};

exports.patch = (req, res) => {
    const expense = expenses.getById(Number(req.params.id));
    if (!expense) return res.status(404).json({ error: "Item not found" });
    const error = validate({ ...expense, ...req.body });
    if (error) return res.status(400).json({ error });
    const updated = expenses.update(Number(req.params.id), req.body);
    res.json(updated);
};
  
exports.remove = (req, res) => {
    const expense = expenses.remove(Number(req.params.id));
    if (!expense) return res.status(404).json({ error: "Item not found" });
    res.json({ message: "Deleted", expense });
};

