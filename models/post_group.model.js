import mongoose from "mongoose";

// Define the PostGroup schema
const postGroupSchema = new mongoose.Schema(
  {
    similarQueries: {
      type: [String], // List of strings for similar queries
      required: [true, "Similar queries are required"],
    },

    domain: {
      type: String,
      required: [true, "Domain is required"],
      trim: true,
    },

    location: {
      type: String,
      required: [true, "Location is required"],
      trim: true,
    },

    posts: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Post", // Reference to the Post model
      },
    ],
  },
  { timestamps: true } // Automatically adds createdAt and updatedAt fields
);

// Create and export the PostGroup model
const PostGroup = mongoose.model("PostGroup", postGroupSchema);
export default PostGroup;
