import { Router } from "express";
import {
  getAllPostGroups,
  getPostGroupByPostId,
} from "../controllers/post_group.controllers.js";

const postGroupRouter = Router();

postGroupRouter.get("/", getAllPostGroups);
postGroupRouter.get("/:postId", getPostGroupByPostId);

export default postGroupRouter;
