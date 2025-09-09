require("dotenv").config();
// require("express-async-errors");
const express = require("express");
const app = express();

// extra security packages
const helmet = require("helmet");
const cors = require("cors");
// const xss = require("xss-clean");
const rateLimiter = require("express-rate-limit");

// connect db
const connectDB = require("./database/connect");

// routers
const authRouter = require("./routes/auth");
const saleRouter = require("./routes/sale");
const autoSaleRouter = require("./routes/auto-sale");
const leadRouter = require("./routes/lead");
const saleHistoryRouter = require("./routes/sale-history");

// error handler
const notFoundMiddleware = require("./middleware/not-found");
const errorHandlerMiddleware = require("./middleware/error-handler");
const auth = require("./middleware/authentication");

app.use(express.json());
app.use(
  rateLimiter({
    windowMs: 15 * 60 * 1000, // 15 minutes
    limit: 100, // Limit each IP to 100 requests per `window` (here, per 15 minutes)
  })
);
app.use(helmet());
const allowedOrigins = [
  process.env.FRONTEND_APP_URL ||
    "https://sales-automation-frontend.vercel.app",
  "http://localhost:5173", // For local development
];
app.use(cors());
// app.use(
// cors()
// cors({
//   origin: (origin, callback) => {
//     // Allow requests with no origin (e.g., Postman, curl)
//     if (!origin) return callback(null, true);
//     if (allowedOrigins.includes(origin)) {
//       callback(null, true);
//     } else {
//       callback(new Error("Not allowed by CORS"));
//     }
//   },
//   methods: ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
//   allowedHeaders: ["Content-Type", "Authorization"],
//   credentials: false, // Set to true if using cookies
// })
// );
// app.use(xss());

// Health check endpoint
app.get("/api/v1/auth/health", (req, res) => {
  res.status(200).json({
    status: "OK",
    message: "Backend is running",
    timestamp: new Date().toISOString(),
  });
});

// routes
app.use("/api/v1/auth", authRouter);
app.use("/api/v1/sales", saleRouter);
app.use("/api/v1/leads", leadRouter);
app.use("/api/v1/auto-sales", autoSaleRouter);
app.use("/api/v1/sale-history", saleHistoryRouter);

app.use(notFoundMiddleware);
app.use(errorHandlerMiddleware);

const port = process.env.PORT;
console.log(process.env.MONGO_URI);
const start = async () => {
  try {
    await connectDB(process.env.MONGO_URI);
    app.listen(port, () => {
      console.log(`Server is up and listening on port ${port}`);
    });
  } catch (error) {
    console.log(error.message);
  }
};
start();
