// const mongoose = require("mongoose");
// const connectDB = (url) => {
//   return mongoose.connect(url);
// };
// module.exports = connectDB;
const mongoose = require("mongoose");

const connectWithRetry = async (url, options = {}) => {
  const {
    maxAttempts = 20,
    initialDelayMs = 1000,
    backoffFactor = 1.5,
  } = options;

  let attempt = 0;
  let delay = initialDelayMs;

  while (attempt < maxAttempts) {
    try {
      await mongoose.connect(url);
      console.log("✅ MongoDB connected successfully.");
      return;
    } catch (error) {
      attempt += 1;
      console.error(
        `❌ MongoDB connection attempt ${attempt}/${maxAttempts} failed:`,
        error.message
      );
      if (attempt >= maxAttempts) {
        console.error("❌ Exhausted all MongoDB connection attempts. Exiting.");
        process.exit(1);
      }
      await new Promise((r) => setTimeout(r, delay));
      delay = Math.min(Math.floor(delay * backoffFactor), 15000);
    }
  }
};

const connectDB = async (url) => connectWithRetry(url);

module.exports = connectDB;
