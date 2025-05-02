import { Router } from "express";
import {
  addMessageToGroupChat,
  getAllGroupChats,
  getGroupChatsByGroupChatId,
  getGroupChatsByUserId,
} from "../controllers/group_chat.controllers.js";

const groupChatRouter = Router();

groupChatRouter.get("/", getAllGroupChats);
groupChatRouter.get("/members/:userId", getGroupChatsByUserId);
groupChatRouter.get("/:groupChatId", getGroupChatsByGroupChatId);
groupChatRouter.post("/chat/:groupChatId", addMessageToGroupChat);

export default groupChatRouter;
