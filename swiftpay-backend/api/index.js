const { app, connectDB } = require('../server');

module.exports = async (req, res) => {
  await connectDB();   // ensure DB is connected
  return app(req, res); // delegate request to Express
};
