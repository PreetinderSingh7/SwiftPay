const mongoose = require("mongoose");
const app = require("../server"); // reuse your Express app

// Ensure MongoDB connection only once
let isConnected = false;

async function connectDB() {
  if (isConnected) return;
  try {
    await mongoose.connect(process.env.MONGO_URI);
    isConnected = true;
    console.log("MongoDB Connected (Vercel)");
  } catch (err) {
    console.error("MongoDB Error:", err);
  }
}

module.exports = async (req, res) => {
  await connectDB();
  return app(req, res); // delegate request to Express
};
