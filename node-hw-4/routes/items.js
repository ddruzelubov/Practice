const express = require('express');
const contoller = require('../controllers/itemController');
const router = express.Router();

router.get('/', contoller.getAll);
router.get('/:id', contoller.getById);
router.post('/', contoller.create);
router.put('/:id', contoller.update);
router.patch('/:id', contoller.patch);
router.delete('/:id', contoller.remove);

module.exports = router;