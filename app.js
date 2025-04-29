import express from "express";
import connectToDatabase from "./database/mongodb.js";
import cookieParser from "cookie-parser";
import errorMiddleware from "./middlewares/error.middleware.js";

// Import Routes
import authRouter from "./routes/auth.routes.js";
import postRouter from "./routes/post.routes.js";
import alertRouter from "./routes/alert.routes.js";
import groupChatRouter from "./routes/group_chat.routes.js";
import postGroupRouter from "./routes/post_group.routes.js";

const app = express();

// Middlewares
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());

// API Routes
app.use("/api/auth", authRouter);
app.use("/api/post", postRouter);
app.use("/api/alert", alertRouter);
app.use("/api/group-chat", groupChatRouter);
app.use("/api/post-group", postGroupRouter);

// Global Error Handler
app.use(errorMiddleware);

// Default Route
app.get("/", (req, res) => {
  res.send("Welcome to Voice API");
});

const startServer = async () => {
  await connectToDatabase();
  app.listen(3000, () => {
    console.log("🚀 Voice API is running at http://localhost:3000");
  });
};

startServer(); // call async

export default app;
