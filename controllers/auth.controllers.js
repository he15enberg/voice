import bcrypt from "bcryptjs";
import { generateTokens } from "../utils/jwt.utils.js";
import User from "../models/user.model.js";
// User Registration
export const signUp = async (req, res, next) => {
  try {
    const { name, email, password, phone, role } = req.body;
    if (!password) {
      return res
        .status(400)
        .json({ success: false, message: "Password is required" });
    }
    // Check if admin already exists
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res
        .status(400)
        .json({ success: false, message: "User Email already registered" });
    }
    // Hash the password
    const hashedPassword = await bcrypt.hash(password, 10);
    // Create new admin
    const newUser = new User({
      name,
      email,
      phone,
      password: hashedPassword,
      role,
    });
    await newUser.save();
    console.log(newUser);
    res.status(201).json({
      success: true,
      message: "User registered successfully",
      data: newUser,
    });
  } catch (error) {
    next(error);
  }
};

// User Login
export const signIn = async (req, res, next) => {
  try {
    const { email, password } = req.body;
    const dbUser = await User.findOne({ email });
    if (!dbUser)
      return res
        .status(404)
        .json({ success: false, message: "User not found" });

    const isPasswordValid = await bcrypt.compare(password, dbUser.password);
    if (!isPasswordValid)
      return res
        .status(400)
        .json({ success: false, message: "Invalid credentials" });

    const { accessToken, refreshToken } = generateTokens(dbUser, true, res);
    res.status(200).json({
      token: accessToken,
      refreshToken: refreshToken,
      success: true,
      message: "User logged in successfully",
      data: dbUser,
    });
  } catch (error) {
    next(error);
  }
};

// User Login
export const fetchUser = async (req, res, next) => {
  try {
    const { userId } = req.params;
    const dbUser = await User.findById(userId);
    if (!dbUser)
      return res
        .status(404)
        .json({ success: false, message: "User not found" });

    res.status(200).json({
      success: true,
      message: "User fetched successfully",
      data: dbUser,
    });
  } catch (error) {
    next(error);
  }
};
export const getAllUsers = async (req, res, next) => {
  try {
    const users = await User.find();

    res.status(200).json({
      success: true,
      message: "User fetched successfully",
      data: users,
    });
  } catch (error) {
    next(error);
  }
};
