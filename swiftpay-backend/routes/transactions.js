const express = require('express');
const Transaction = require('../models/Transaction');
const authMiddleware = require('../middleware/authMiddleware');
const router = express.Router();

// Get user's transaction history
router.get('/my', authMiddleware, async (req, res) => {
  try {
    const transactions = await Transaction.find({ userId: req.user.id, status: 'paid' })
      .sort({ createdAt: -1 });
    res.json({ success: true, data: transactions });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;