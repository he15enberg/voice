import GroupChat from "../models/group_chat.model.js";
import User from "../models/user.model.js";

export const getAllGroupChats = async (req, res) => {
  try {
    const groupChats = await GroupChat.find()
      .populate("postGroup")
      .populate("members", "name")
      .populate("messages.userId", "name")
      .populate("messages.post");

    res.status(200).json({
      success: true,
      data: groupChats,
    });
  } catch (error) {
    console.error("Error fetching group chats:", error.message);
    res.status(500).json({
      success: false,
      message: "Failed to fetch group chats.",
    });
  }
};

export const getGroupChatsByUserId = async (req, res) => {
  try {
    const { userId } = req.params;

    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({
        success: false,
        message: "User not found",
      });
    }

    const groupChats = await GroupChat.find({ members: userId })
      .populate({
        path: "postGroup",
        populate: {
          path: "posts",
          model: "Post", // this line is optional if the model name is already correct in schema
        },
      })
      .populate("members", "name") // populate members with only name
      .select("-messages"); // exclude messages from result

    res.status(200).json({
      success: true,
      data: groupChats,
    });
  } catch (error) {
    console.error("Error fetching group chats by userId:", error.message);
    res.status(500).json({
      success: false,
      message: "Failed to fetch group chats for the user.",
    });
  }
};

export const getGroupChatsByGroupChatId = async (req, res) => {
  try {
    const { groupChatId } = req.params; // make sure to pass userId in the route param

    const groupChat = await GroupChat.findById(groupChatId)
      .populate({
        path: "postGroup",
        populate: {
          path: "posts",
          model: "Post", // this line is optional if the model name is already correct in schema
        },
      })
      .populate("members", "name")
      .populate("messages.userId", "name")
      .populate("messages.post");
    if (groupChat == null) {
      return res.status(404).json({
        success: false,
        message: "Group Chat not found",
      });
    }
    res.status(200).json({
      success: true,
      data: groupChat,
    });
  } catch (error) {
    console.error("Error fetching group chats by userId:", error.message);
    res.status(500).json({
      success: false,
      message: "Failed to fetch group chats for the user.",
    });
  }
};

export const addMessageToGroupChat = async (req, res) => {
  try {
    const { groupChatId } = req.params;
    const { userId, message, role, type, post } = req.body;

    // Validation (optional but recommended)
    if (!userId || !role) {
      return res.status(400).json({
        success: false,
        message: "userId and role are required",
      });
    }

    // Create the message object
    const newMessage = {
      userId,
      message,
      role,
      type: type || "text",
      post: post || null,
      createdAt: new Date(),
    };

    // Update the group chat by pushing new message
    const updatedGroupChat = await GroupChat.findByIdAndUpdate(
      groupChatId,
      {
        $push: { messages: newMessage },
      },
      { new: true }
    ).populate({
      path: "messages.post",
      model: "Post", // Ensure this matches your Post model name
    });

    if (!updatedGroupChat) {
      return res.status(404).json({
        success: false,
        message: "Group Chat not found",
      });
    }

    res.status(200).json({
      success: true,
      data: updatedGroupChat,
      message: "Message added successfully",
    });
  } catch (error) {
    console.error("Error adding message to group chat:", error.message);
    res.status(500).json({
      success: false,
      message: "Failed to add message to group chat.",
    });
  }
};
