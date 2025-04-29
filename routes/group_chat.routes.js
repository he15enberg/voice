import { Router } from "express";
import { getAllGroupChats } from "../controllers/group_chat.controllers.js";

const groupChatRouter = Router();

groupChatRouter.get("/", getAllGroupChats);

export default groupChatRouter;
