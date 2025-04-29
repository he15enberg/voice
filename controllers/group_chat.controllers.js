import GroupChat from "../models/group_chat.model.js";

export const getAllGroupChats = async (req, res) => {
  try {
    const groupChats = await GroupChat.find()
      .populate("postGroup") // optional: can customize with `.select()`
      .populate("members", "name") // populate member names only
      .populate("messages.userId", "name") // show name of the message sender
      .populate("messages.post"); // optional: show linked post if type is "post_message"

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
