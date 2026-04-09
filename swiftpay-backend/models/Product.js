const mongoose = require('mongoose');

const productSchema = new mongoose.Schema({
  barcode: { type: String, required: true, unique: true },
  name: { type: String, required: true },
  price: { type: Number, required: true },
  category: { type: String, required: true },
  stockCount: { type: Number, required: true, default: 100 },
  taxRate: { type: Number, default: 0.18 }, // 18% GST
  imageUrl: { type: String, default: '' },
  description: { type: String, default: '' }
});

module.exports = mongoose.model('Product', productSchema);