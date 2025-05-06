import { Router } from "express";
import {
  commentOnPost,
  createPost,
  getAllPosts,
  getPostsStatusCount,
  getSimilarPosts,
  getUserPosts,
  logPostStatus,
  votePost,
} from "../controllers/post.controllers.js";

const postRouter = Router();

// Define specific routes first
postRouter.get("/", getAllPosts);
postRouter.post("/create", createPost);
postRouter.post("/comment/:postId", commentOnPost);
postRouter.post("/vote/:postId", votePost);
postRouter.post("/log/:postId", logPostStatus);
postRouter.get("/similar-posts/:postId", getSimilarPosts);
postRouter.get("/status-count", getPostsStatusCount); // No trailing slash needed

// Define parameter-based routes last
postRouter.get("/:userId", getUserPosts);

export default postRouter;
