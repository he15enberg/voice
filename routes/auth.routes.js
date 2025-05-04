import { Router } from "express";
import {
  signUp,
  signIn,
  fetchUser,
  getAllUsers,
} from "../controllers/auth.controllers.js";

const authRouter = Router();

authRouter.post("/signup", signUp);
authRouter.post("/signin", signIn);

authRouter.get("/:userId", fetchUser);
authRouter.get("/", getAllUsers);

export default authRouter;
