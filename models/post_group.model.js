import mongoose from "mongoose";

const postGroupSchema = new mongoose.Schema(
  {
    similarQueries: {
      type: [String],
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
        ref: "Post",
      },
    ],
  },
  { timestamps: true }
);

const PostGroup = mongoose.model("PostGroup", postGroupSchema);
export default PostGroup;
