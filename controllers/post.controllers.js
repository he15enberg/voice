import Post from "../models/post.model.js";
import User from "../models/user.model.js";
import Alert from "../models/alerts.model.js";
import mongoose from "mongoose";
import {
  generateGroupChatName,
  generateSimilarIssueQueries,
  getDomainOfIssue,
  isSimilarToPostGroup,
  isValidIssue,
} from "../utils/gemini.utils.js";
import PostGroup from "../models/post_group.model.js";
import GroupChat from "../models/group_chat.model.js";

export const createPost = async (req, res) => {
  try {
    const { title, desc, location, imageurl, userId } = req.body;

    if (!title || !desc || !location || !userId) {
      return res.status(400).json({ message: "All fields are required" });
    }

    // Get the user's name from DB
    const user = await User.findById(userId).select("name");
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }
    const isValid = await isValidIssue(title, desc);
    if (!isValid) {
      return res.status(400).json({
        message:
          "The issue title or description appears to be invalid or inappropriate for reporting. Please provide a clear and relevant issue.",
      });
    }

    const domain = await getDomainOfIssue(title + desc);

    const newPost = new Post({
      title,
      desc,
      domain,
      location,
      imageurl,
      submittedBy: {
        userId,
        name: user.name,
      },
    });

    const savedPost = await newPost.save();
    const newAlert = new Alert({
      title: `Raised: ${title}`,
      message: "Your query has been submitted and is waiting to be picked up.",
      type: "info",
    });
    const savedAlert = await newAlert.save();

    // Find existing post groups with the same domain and location
    const candidateGroups = await PostGroup.find({ domain, location });

    let matchedGroup = null;
    for (const group of candidateGroups) {
      const isSimilar = await isSimilarToPostGroup(
        title + desc,
        group.similarQueries
      );
      if (isSimilar) {
        matchedGroup = group;
        break;
      }
    }

    if (matchedGroup) {
      matchedGroup.posts.push(savedPost._id);
      await matchedGroup.save();
    } else {
      const similarQueries = await generateSimilarIssueQueries(title + desc); // should return array of 5 strings
      const groupChatName = await generateGroupChatName(similarQueries); // should return array of 5 strings

      const newGroup = new PostGroup({
        similarQueries,
        domain,
        location,
        posts: [savedPost._id],
      });

      const savedGroup = await newGroup.save();

      await GroupChat.create({
        postGroup: savedGroup._id,
        name: groupChatName,
        members: [userId],
        messages: [
          {
            userId,
            message:
              "Your query has been submitted and is waiting to be picked up.",
            role: "Student",
            type: "post",
            post: savedPost._id,
          },
        ],
      });
    }

    res.status(200).json({
      success: true,
      message: "Post created successfully",
      data: savedPost,
    });
  } catch (error) {
    console.error("Error creating post:", error.message);
    res
      .status(500)
      .json({ success: false, message: "Error while creating post." });
  }
};

export const getAllPosts = async (req, res) => {
  try {
    const posts = await Post.find().sort({ createdAt: -1 });

    res.status(200).json({
      success: true,
      message: "Posts fetched successfully",
      data: posts,
    });
  } catch (error) {
    console.error("Error fetching posts:", error.message);
    res.status(500).json({ success: false, message: error.message });
  }
};

export const getUserPosts = async (req, res) => {
  try {
    const { userId } = req.params;
    console.log(userId);
    // Fetch only posts submitted by this user
    const posts = await Post.find({
      "submittedBy.userId": new mongoose.Types.ObjectId(userId),
    }).sort({ createdAt: -1 });

    res.status(200).json({
      success: true,
      message: "Posts fetched successfully",
      data: posts,
    });
  } catch (error) {
    console.error("Error fetching user posts:", error.message);
    res.status(500).json({ success: false, message: error.message });
  }
};

export const votePost = async (req, res) => {
  try {
    const { postId } = req.params;
    const { userId, action } = req.body;

    if (!postId || !userId || !["upvote", "downvote"].includes(action)) {
      return res.status(400).json({
        success: false,
        message:
          "Post ID, User ID, and a valid action ('upvote' or 'downvote') are required",
      });
    }

    const post = await Post.findById(postId);
    if (!post) {
      return res
        .status(404)
        .json({ success: false, message: "Post not found" });
    }

    const isUpvoted = post.upvotes.includes(userId);
    const isDownvoted = post.downvotes.includes(userId);

    if (action === "upvote") {
      if (isUpvoted) {
        post.upvotes.pull(userId); // Remove upvote (toggle off)
        await post.save();
        return res.status(200).json({
          success: true,
          message: "Upvote removed",
          data: post,
        });
      } else {
        post.upvotes.push(userId); // Add upvote
        if (isDownvoted) post.downvotes.pull(userId); // Remove downvote if exists
        await post.save();
        return res.status(200).json({
          success: true,
          message: "Post upvoted",
          data: post,
        });
      }
    }

    if (action === "downvote") {
      if (isDownvoted) {
        post.downvotes.pull(userId); // Remove downvote (toggle off)
        await post.save();
        return res.status(200).json({
          success: true,
          message: "Downvote removed",
          data: post,
        });
      } else {
        post.downvotes.push(userId); // Add downvote
        if (isUpvoted) post.upvotes.pull(userId); // Remove upvote if exists
        await post.save();
        return res.status(200).json({
          success: true,
          message: "Post downvoted",
          data: post,
        });
      }
    }
  } catch (error) {
    console.error("Error voting on post:", error.message);
    res.status(500).json({ success: false, message: error.message });
  }
};

export const commentOnPost = async (req, res) => {
  try {
    const { postId } = req.params;
    const { userId, text } = req.body;

    // Validate input
    if (!postId || !userId || !text) {
      return res.status(400).json({
        success: false,
        message: "Post ID, User ID, and Comment Text are required",
      });
    }

    // Fetch post
    const post = await Post.findById(postId);
    if (!post) {
      return res.status(404).json({
        success: false,
        message: "Post not found",
      });
    }

    // Fetch user to get username
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({
        success: false,
        message: "User not found",
      });
    }

    // Construct comment
    const newComment = {
      userId,
      text,
      username: user.name,
      createdAt: new Date(),
    };

    // Add comment to post
    post.comments.push(newComment);
    await post.save();

    res.status(200).json({
      success: true,
      message: "Comment added successfully",
      data: newComment,
    });
  } catch (error) {
    console.error("Error adding comment:", error.message);
    res.status(500).json({
      success: false,
      message: "Internal Server Error",
    });
  }
};

export async function getSimilarPosts(req, res) {
  const { postId } = req.params;

  try {
    const postGroup = await PostGroup.findOne({ posts: postId }).populate(
      "posts"
    );

    if (!postGroup) {
      return res
        .status(404)
        .json({ error: "PostGroup not found for the given Post ID" });
    }

    const posts = postGroup.posts;

    const filteredPosts = posts.filter(
      (post) => post._id.toString() !== postId
    );
    res.status(200).json({
      success: true,
      message: "Post Group fetched successfully",
      data: filteredPosts,
    });
  } catch (err) {
    console.error("Error fetching post group by post ID:", err);
    res.status(500).json({ error: "Failed to fetch post group" });
  }
}
export async function logPostStatus(req, res) {
  const { postId } = req.params;
  const { userId, status, text } = req.body;

  try {
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({
        success: false,
        message: "User not found",
      });
    }
    const dbPost = await Post.findById(postId);
    if (!dbPost) {
      return res
        .status(404)
        .json({ error: "Post not found for the given Post ID" });
    }

    dbPost.status = status;
    await dbPost.save();

    // Fix: Use let here
    let alertType = "";
    if (status === "Approved") {
      alertType = "success";
    } else if (status === "Rejected") {
      alertType = "error";
    } else if (status === "Processing") {
      alertType = "warning";
    } else {
      alertType = "info";
    }

    const newAlert = new Alert({
      title: `Raised: ${dbPost.title}`,
      message: text,
      type: alertType,
    });

    const savedAlert = await newAlert.save();

    const postGroup = await PostGroup.findOne({ posts: postId });
    if (!postGroup) {
      return res
        .status(404)
        .json({ error: "Post group not found for this post." });
    }

    const dbGroupChat = await GroupChat.findOne({ postGroup: postGroup._id });
    if (!dbGroupChat) {
      return res
        .status(404)
        .json({ error: "Group chat not found for this post group." });
    }

    const newMessage = {
      userId,
      message: text,
      role: "Student",
      type: "post",
      post: dbPost._id,
    };

    dbGroupChat.messages.push(newMessage);
    await dbGroupChat.save();

    res.status(200).json({
      success: true,
      message: "Post logged successfully",
      data: dbPost,
    });
  } catch (err) {
    console.error("Error :", err);
    res.status(500).json({ error: err.message });
  }
}
