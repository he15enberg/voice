import jwt from "jsonwebtoken";
import { JWT_ACCESS_SECRET, JWT_REFRESH_SECRET } from "../config/env.js";
import { generateTokens, verifyJWT } from "../utils/jwt.utils.js";
import Admin from "../models/admin.model.js";
import Student from "../models/sudent.model.js";

const authMiddleware = async (req, res, next) => {
  try {
    let accessToken = req.headers.authorization?.split(" ")[1];

    if (!accessToken) {
      return res
        .status(401)
        .json({ success: false, message: "Unauthorized - No Token" });
    }

    const { success, payload, expired } = verifyJWT(accessToken, true);

    if (success) {
      let dbUser = null;
      if (payload.role === "admin") {
        dbUser = await Admin.findById(payload.userId).select("-password");
      } else {
        dbUser = await Student.findById(payload.userId).select("-password");
      }
      if (!dbUser) {
        return res
          .status(404)
          .json({ success: false, message: "User not found" });
      }
      req.user = dbUser;
      return next();
    }

    if (expired) {
      // Check Refresh Token
      const refreshToken = req.cookies.refreshToken;
      if (!refreshToken) {
        return res
          .status(401)
          .json({ success: false, message: "Session Expired - Please Login" });
      }

      const {
        success: refreshSuccess,
        payload: refreshPayload,
        expired: refreshExpired,
      } = verifyJWT(refreshToken, false);

      if (!refreshSuccess) {
        return res
          .status(401)
          .json({ success: false, message: "Session Expired - Please Login" });
      }

      // Generate New Tokens
      let user = null;
      if (payload.role === "admin") {
        user = await Admin.findById(refreshPayload.userId);
      } else {
        user = await Student.findById(refreshPayload.userId);
      }
      if (!user) {
        return res
          .status(401)
          .json({ success: false, message: "User Not Found" });
      }

      const { accessToken: newAccessToken } = generateTokens(
        user,
        payload.role === "admin",
        res
      );

      req.user = user;
      req.newAccessToken = newAccessToken; // Attach new token for client-side update
      return next();
    }
  } catch (error) {
    console.log(error);
    return res
      .status(500)
      .json({ success: false, message: "Authentication Error" });
  }
};

export default authMiddleware;
