import { Router } from "express";
import {
  signUp,
  signIn,
  fetchUser,
  getAllUsers,
  deleteUser,
} from "../controllers/auth.controllers.js";

const authRouter = Router();

authRouter.post("/signup", signUp);
authRouter.post("/signin", signIn);

authRouter.get("/:userId", fetchUser);
authRouter.get("/", getAllUsers);
authRouter.delete("/:userId", deleteUser);

export default authRouter;
