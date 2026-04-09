// const express = require('express');
// const Product = require('../models/Product');
// const authMiddleware = require('../middleware/authMiddleware');
// const router = express.Router();

// // Get product by barcode
// router.get('/barcode/:barcode', authMiddleware, async (req, res) => {
//   try {
//     const product = await Product.findOne({ barcode: req.params.barcode });
//     if (!product) return res.status(404).json({ error: 'Product not found.' });
//     res.json({ success: true, data: product });
//   } catch (err) {
//     res.status(500).json({ error: err.message });
//   }
// });

// // Get all products (admin)
// router.get('/', authMiddleware, async (req, res) => {
//   try {
//     const products = await Product.find();
//     res.json({ success: true, data: products });
//   } catch (err) {
//     res.status(500).json({ error: err.message });
//   }
// });

// // Add product (admin)
// router.post('/', authMiddleware, async (req, res) => {
//   try {
//     const product = new Product(req.body);
//     await product.save();
//     res.status(201).json({ success: true, data: product });
//   } catch (err) {
//     res.status(500).json({ error: err.message });
//   }
// });

// // Seed sample products (run once)
// router.post('/seed', async (req, res) => {
//   try {
//     const sampleProducts = [
//       { barcode: '8901234567890', name: 'Lay\'s Classic Chips', price: 20, category: 'Snacks', stockCount: 50, taxRate: 0.05 },
//       { barcode: '8901063150266', name: 'Amul Milk 500ml', price: 27, category: 'Dairy', stockCount: 100, taxRate: 0 },
//       { barcode: '8906004450043', name: 'Parle-G Biscuits', price: 5, category: 'Biscuits', stockCount: 200, taxRate: 0.05 },
//       { barcode: '4902430144612', name: 'Maggi Noodles 70g', price: 14, category: 'Food', stockCount: 150, taxRate: 0.05 },
//       { barcode: '8901030870193', name: 'Dettol Soap 75g', price: 44, category: 'Personal Care', stockCount: 80, taxRate: 0.18 },
//     ];
//     await Product.insertMany(sampleProducts, { ordered: false });
//     res.json({ success: true, message: 'Sample products seeded.' });
//   } catch (err) {
//     res.status(500).json({ error: err.message });
//   }
// });

// module.exports = router;


const express = require('express');
const Product = require('../models/Product');
const authMiddleware = require('../middleware/authMiddleware');
const router = express.Router();

// Get product by barcode
router.get('/barcode/:barcode', authMiddleware, async (req, res) => {
  try {
    console.log('Fetching product with barcode:', req.params.barcode);
    const product = await Product.findOne({ barcode: req.params.barcode });
    console.log('Product found:', product);
    if (!product) {
      return res.status(404).json({ success: false, error: 'Product not found' });
    }
    res.json({ success: true, data: product });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// Get all products (admin)
router.get('/', authMiddleware, async (req, res) => {
  try {
    const products = await Product.find();
    res.json({ success: true, data: products });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// Add product (admin)
router.post('/', authMiddleware, async (req, res) => {
  try {
    const product = new Product(req.body);
    await product.save();
    res.status(201).json({ success: true, data: product });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// Seed sample products (run once)
router.post('/seed', async (req, res) => {
  try {
    const sampleProducts = [
      { barcode: '8901234567890', name: 'Lay\'s Classic Chips', price: 20, category: 'Snacks', stockCount: 50, taxRate: 0.05 },
       { barcode: '8901063150266', name: 'Amul Milk 500ml', price: 27, category: 'Dairy', stockCount: 100, taxRate: 0 },
       { barcode: '8906004450043', name: 'Parle-G Biscuits', price: 5, category: 'Biscuits', stockCount: 200, taxRate: 0.05 },
       { barcode: '4902430144612', name: 'Maggi Noodles 70g', price: 14, category: 'Food', stockCount: 150, taxRate: 0.05 },
       { barcode: '8901030870193', name: 'Dettol Soap 75g', price: 44, category: 'Personal Care', stockCount: 80, taxRate: 0.18 },
      { barcode: '8904063215154', name: 'Takatak', price: 20, category: 'Snack', stockCount: 60, taxRate: 0.19 },
      { barcode: '8901719139208', name: 'Hide & Seek', price: 30, category: 'Biscuits', stockCount: 8, taxRate: 0.20 },
    ];
    await Product.insertMany(sampleProducts, { ordered: false });
    res.json({ success: true, message: 'Sample products seeded.' });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

module.exports = router;
