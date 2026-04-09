const express = require('express');
const Razorpay = require('razorpay');
const crypto = require('crypto');
const authMiddleware = require('../middleware/authMiddleware');
const Transaction = require('../models/Transaction');
const Product = require('../models/Product');
const router = express.Router();

const razorpay = new Razorpay({
  key_id: process.env.RAZORPAY_KEY_ID,
  key_secret: process.env.RAZORPAY_KEY_SECRET
});

// Create Razorpay order
router.post('/create-order', authMiddleware, async (req, res) => {
  try {
    const { items } = req.body; // items: [{productId, quantity}]

    // Calculate totals
    let subtotal = 0;
    let tax = 0;
    const itemDetails = [];

    for (const item of items) {
      const product = await Product.findById(item.productId);
      if (!product) return res.status(404).json({ error: `Product ${item.productId} not found.` });
      if (product.stockCount < item.quantity) return res.status(400).json({ error: `Insufficient stock for ${product.name}` });

      const itemTotal = product.price * item.quantity;
      const itemTax = itemTotal * product.taxRate;
      subtotal += itemTotal;
      tax += itemTax;

      itemDetails.push({
        productId: product._id,
        name: product.name,
        price: product.price,
        quantity: item.quantity,
        taxRate: product.taxRate
      });
    }

    const total = Math.round(subtotal + tax);

    // Create Razorpay order
    const order = await razorpay.orders.create({
      amount: total * 100, // paise
      currency: 'INR',
      receipt: `receipt_${Date.now()}`
    });

    // Save pending transaction
    const transaction = new Transaction({
      userId: req.user.id,
      items: itemDetails,
      subtotal: subtotal.toFixed(2),
      tax: tax.toFixed(2),
      total,
      razorpayOrderId: order.id,
      status: 'pending'
    });
    await transaction.save();

    res.json({
      success: true,
      orderId: order.id,
      amount: total,
      currency: 'INR',
      transactionId: transaction._id,
      keyId: process.env.RAZORPAY_KEY_ID
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Verify payment
router.post('/verify', authMiddleware, async (req, res) => {
  try {
    const { razorpayOrderId, razorpayPaymentId, razorpaySignature, transactionId } = req.body;

    // Verify signature
    const hmac = crypto.createHmac('sha256', process.env.RAZORPAY_KEY_SECRET);
    hmac.update(`${razorpayOrderId}|${razorpayPaymentId}`);
    const generatedSig = hmac.digest('hex');

    if (generatedSig !== razorpaySignature) {
      return res.status(400).json({ error: 'Payment verification failed.' });
    }

    // Update transaction
    const transaction = await Transaction.findById(transactionId);
    if (!transaction) return res.status(404).json({ error: 'Transaction not found.' });

    transaction.razorpayPaymentId = razorpayPaymentId;
    transaction.status = 'paid';
    await transaction.save();

    // Decrement inventory
    for (const item of transaction.items) {
      await Product.findByIdAndUpdate(item.productId, {
        $inc: { stockCount: -item.quantity }
      });
    }

    res.json({ success: true, message: 'Payment verified.', transaction });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;