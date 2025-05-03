import { Router } from "express";
import {
  commentOnPost,
  createPost,
  getAllPosts,
  getSimilarPosts,
  getUserPosts,
  logPostStatus,
  votePost,
} from "../controllers/post.controllers.js";

const postRouter = Router();

postRouter.get("/", getAllPosts);
postRouter.get("/:userId", getUserPosts);
postRouter.post("/create", createPost);
postRouter.post("/comment/:postId", commentOnPost);
postRouter.post("/vote/:postId", votePost);
postRouter.post("/log/:postId", logPostStatus);
postRouter.get("/similar-posts/:postId", getSimilarPosts);

export default postRouter;
