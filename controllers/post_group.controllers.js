import PostGroup from "../models/post_group.model.js";

export async function getAllPostGroups(req, res) {
  try {
    const postGroups = await PostGroup.find().populate("posts");
    res.status(200).json({
      success: true,
      message: "Post Group fetched successfully",
      data: postGroups,
    });
  } catch (err) {
    console.error("Error fetching all post groups:", err);
    res.status(500).json({ error: "Failed to fetch post groups" });
  }
}

export async function getPostGroupByPostId(req, res) {
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

    res.status(200).json({
      success: true,
      message: "Post Group fetched successfully",
      data: postGroup,
    });
  } catch (err) {
    console.error("Error fetching post group by post ID:", err);
    res.status(500).json({ error: "Failed to fetch post group" });
  }
}
