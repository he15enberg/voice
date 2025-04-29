import jwt from "jsonwebtoken";
import {
  JWT_ACCESS_SECRET,
  JWT_REFRESH_SECRET,
  JWT_ACCESS_EXPIRES_IN,
  JWT_REFRESH_EXPIRES_IN,
} from "../config/env.js";

// Generate JWT Tokens and Set Cookies
export const generateTokens = (user, isAdmin, res) => {
  const accessToken = jwt.sign(
    { userId: user._id, role: isAdmin ? "admin" : "student" },
    JWT_ACCESS_SECRET,
    {
      expiresIn: JWT_ACCESS_EXPIRES_IN,
    }
  );

  const refreshToken = jwt.sign(
    { userId: user._id, role: isAdmin ? "admin" : "student" },
    JWT_REFRESH_SECRET,
    {
      expiresIn: JWT_REFRESH_EXPIRES_IN,
    }
  );

  // res.cookie("accessToken", accessToken, {
  //   maxAge: convertToMilliseconds(JWT_ACCESS_EXPIRES_IN),
  //   httpOnly: true,
  //   secure: process.env.NODE_ENV === "production",
  //   sameSite: "Strict",
  // });

  // res.cookie("refreshToken", refreshToken, {
  //   maxAge: convertToMilliseconds(JWT_REFRESH_EXPIRES_IN),
  //   httpOnly: true,
  //   secure: process.env.NODE_ENV === "production",
  //   sameSite: "Strict",
  // });

  return { accessToken, refreshToken };
};

// Verify JWT Tokens
export const verifyJWT = (token, isAccess = true) => {
  try {
    const secret = isAccess ? JWT_ACCESS_SECRET : JWT_REFRESH_SECRET;
    const decoded = jwt.verify(token, secret);

    return { success: true, payload: decoded, expired: false };
  } catch (error) {
    return {
      success: false,
      payload: null,
      expired: error.message.includes("jwt expired"),
    };
  }
};

// Convert time strings like "10m" to milliseconds
export const convertToMilliseconds = (timeString) => {
  const unit = timeString.slice(-1);
  const value = parseInt(timeString, 10);

  const multipliers = {
    s: 1000,
    m: 60 * 1000,
    h: 60 * 60 * 1000,
    d: 24 * 60 * 60 * 1000,
  };

  return value * (multipliers[unit] || 0);
};
