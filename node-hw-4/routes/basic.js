const express = require('express');
const router = express.Router();

router.get('/', (req, res) => {
    res.status(200).json({message: "OK"});
});

router.get('/status', (req, res) => {
    res.status(200).json({
        status: 'running',
        timestamp: new Date().toISOString()
    });
});

module.exports = router;

