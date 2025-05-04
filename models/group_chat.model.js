import mongoose from "mongoose";

// Message schema
const messageSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    message: {
      type: String,
      trim: true,
    },
    role: {
      type: String,
      enum: ["Student", "Admin"],
      required: true,
    },
    type: {
      type: String,
      enum: ["post", "text"],
      default: "text",
    },
    post: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Post",
      default: null,
    },
    createdAt: {
      type: Date,
      default: Date.now,
    },
  },
  { _id: false }
);

const groupChatSchema = new mongoose.Schema(
  {
    postGroup: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "PostGroup",
      required: true,
    },
    name: {
      type: String,
      trim: true,
    },
    members: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
        required: true,
      },
    ],
    messages: [messageSchema],
  },
  { timestamps: true }
);

const GroupChat = mongoose.model("GroupChat", groupChatSchema);
export default GroupChat;
