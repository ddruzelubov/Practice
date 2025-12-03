const store = require('../utils/store');

function validate(data){
    if(!data.title || typeof data.title !== 'string' || data.title.length < 1 || data.title.length > 100){
        return 'Title is required (1-100 chars)';
    }

    if(data.description && (typeof data.description !== 'string' || data.description.length < 1 || data.description.length > 500)){
        return 'Description must have 1-500 chars';
    }

    return null;
}

exports.getAll = (req, res) => {
    res.json(store.getAll());
};

exports.getById = (req, res) => {
    const item = store.getById(req.params.id);
    if(!item) return res.status(404).json({error: 'Item not found'});
    res.json(item);
};

exports.create = (req, res) => {
    const error = validate(req.body);
    if(error) return res.status(400).json({error});
    const item = store.create(req.body.title, req.body.description);
    res.status(201).json(item)
};

exports.update = (req, res) => {
    const error = validate(req.body);
    if (error) return res.status(400).json({ error });
    const item = store.update(Number(req.params.id), req.body);
    if (!item) return res.status(404).json({ error: "Item not found" });
    res.json(item);
};

exports.patch = (req, res) => {
    const item = store.getById(Number(req.params.id));
    if (!item) return res.status(404).json({ error: "Item not found" });
    const error = validate({ ...item, ...req.body });
    if (error) return res.status(400).json({ error });
    const updated = store.update(Number(req.params.id), req.body);
    res.json(updated);
};
  
exports.remove = (req, res) => {
    const item = store.remove(Number(req.params.id));
    if (!item) return res.status(404).json({ error: "Item not found" });
    res.json({ message: "Deleted", item });
};

