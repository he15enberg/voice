"use client";

import React, { useState, useEffect } from "react";
import { PostCard } from "./post-card";
import { PostDialog } from "./post-dialog";
import { getAllPosts, logPostStatus } from "@/services/posts";
import { Post } from "@/types/post";
import { Sheet } from "@/components/ui/sheet";
import { PostCommentsSheet } from "./post-comments";
import { PostSkeleton } from "@/components/skeleton/post-skeleton";
import EmptyLoader from "@/components/empty-loader";
import { customToast } from "@/components/toast/custom-toast";

export default function Page() {
  const [dialogOpen, setDialogOpen] = useState(false);
  const [selectedPost, setSelectedPost] = useState<Post | null>(null);
  const [posts, setPosts] = useState<Post[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchPosts = async () => {
      try {
        const data = await getAllPosts(); // calling the API
        setPosts(data); // assuming data is an array of posts
      } catch (err: any) {
      } finally {
        setLoading(false);
      }
    };

    fetchPosts();
  }, []);

  const handleLogPostStatus = async (
    postId: string,
    data: { status: string; text: string }
  ) => {
    try {
      setLoading(true);

      const postData = await logPostStatus(postId, data); // calling the API
      const updatedPosts = posts.map((post) =>
        post._id === postData._id ? { ...post, status: postData.status } : post
      );
      setPosts(updatedPosts); // assuming data is an array of posts
      customToast({
        message: "Post Logged successfully.",
      });
    } catch (err: any) {
      customToast({
        message: "Error logging post.",
        type: "error",
      });
    } finally {
      setLoading(false);
    }
  };
  const handlePostClick = (post: Post) => {
    setSelectedPost(post);
    setDialogOpen(true);
  };
  const [commentsOpen, setCommentsOpen] = useState(false);

  return (
    <div className="relative">
      {loading ? (
        <div className="p-4 gap-4 grid grid-cols-1 sm:grid-cols-2 md:grid-cols-2 lg:grid-cols-3 w-full">
          {Array.from({ length: 6 }).map((_, i) => (
            <PostSkeleton key={i} />
          ))}
        </div>
      ) : posts.length === 0 ? (
        <EmptyLoader />
      ) : (
        <div className="p-4 gap-4 grid grid-cols-1 sm:grid-cols-2 md:grid-cols-2 lg:grid-cols-3 w-full">
          {posts.map((post) => (
            <Sheet
              key={post._id}
              open={commentsOpen}
              onOpenChange={setCommentsOpen}
            >
              <div key={post._id} className="cursor-pointer">
                <PostCard
                  post={post}
                  onClick={() => handlePostClick(post)}
                  onUpVote={() => {}}
                  onDownVote={() => {}}
                  onCommentsClicked={() => {}}
                />
              </div>{" "}
              <PostCommentsSheet post={selectedPost} />
            </Sheet>
          ))}
        </div>
      )}

      <PostDialog
        open={dialogOpen}
        setOpen={setDialogOpen}
        post={selectedPost}
        onLogPostStatus={handleLogPostStatus}
      />
    </div>
  );
}
