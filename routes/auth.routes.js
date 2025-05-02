import { Router } from "express";
import { signUp, signIn, fetchUser } from "../controllers/auth.controllers.js";

const authRouter = Router();

authRouter.post("/signup", signUp);
authRouter.post("/signin", signIn);

authRouter.get("/:userId", fetchUser);

export default authRouter;
