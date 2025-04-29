import mongoose from "mongoose";
import { DATABASE_URL } from "../config/env.js";

if (!DATABASE_URL) {
  throw new Error("Database Url Not found.");
}

const connectToDatabase = async () => {
  try {
    await mongoose.connect(DATABASE_URL);
    console.log("Connected to Database.");
  } catch (error) {
    console.error("Error connecting to database: ", error);
    process.exit(1);
  }
};

export default connectToDatabase;
