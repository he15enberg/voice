import * as React from "react";
import {
  MessageSquareText,
  Pencil,
  ShieldUser,
  SquaresExclude,
  ThumbsUp,
  ThumbsDown,
  LucideIcon,
  InfoIcon,
  AlertTriangleIcon,
  AlertCircleIcon,
  CheckCircleIcon,
} from "lucide-react";
import Image from "next/image";
import { InteractionCard } from "@/components/interaction-card";
import { Post } from "@/types/post";
import { Sheet, SheetTrigger } from "@/components/ui/sheet";
import { SelectItem } from "@/components/ui/select";
import { Badge } from "@/components/ui/badge";
import { getStatusIcon } from "@/lib/helper";
import PostImage from "@/components/post-image";

interface PostCardProps {
  post: Post;
  onClick: () => void;
  onCommentsClicked: () => void;
  onUpVote: () => void;
  onDownVote: () => void;
  inverseTheme?: boolean;
}

export function PostCard({
  post,
  onClick,
  onCommentsClicked,
  onDownVote,
  onUpVote,
  inverseTheme = true,
}: PostCardProps) {
  // Add null/undefined checks for the post and its properties
  if (!post) {
    return (
      <div className="p-3 border rounded-md">
        <div className="text-muted-foreground">Post data not available</div>
      </div>
    );
  }

  // Safely access properties with fallbacks
  const submittedBy = post.submittedBy || {};
  const submitterName = submittedBy.name || "Unknown User";
  const location = post.location || "Unknown location";
  const domain = post.domain || "General";
  const imageUrl = post.imageurl || "";
  const title = post.title || "Untitled";
  const desc = post.desc || "No description available";
  const status = post.status || "pending";
  const upvotes = post.upvotes || [];
  const downvotes = post.downvotes || [];
  const comments = post.comments || [];

  // Set theme-related classes based on inverseTheme prop
  const themeClasses = inverseTheme
    ? "bg-white text-black dark:bg-black dark:text-white"
    : "bg-black text-white dark:bg-white dark:text-black";

  return (
    <div className={`p-0 border rounded-md ${themeClasses}`}>
      <div className="p-3 m-0">
        <div className="flex items-center gap-2">
          <span className="inline-flex p-2 rounded-full bg-primary text-primary-foreground">
            <ShieldUser />
          </span>
          <div className="min-w-0">
            <div className="font-medium">{submitterName}</div>
            <div className="text-xs text-muted-foreground truncate">
              {location}
            </div>
          </div>
          <div className="flex-1" />
          <button className="h-10 w-10 rounded-full hover:bg-muted/75 transition-colors duration-200 ease-in-out">
            <Pencil size={17.5} className="mx-3" />
          </button>
        </div>
      </div>

      <div className="relative " onClick={onClick}>
        <div className="h-[200px] overflow-hidden">
          <PostImage imageUrl={imageUrl} />
        </div>

        <div className="absolute shadow top-3 text-white flex gap-2 left-3 bg-blue-500 text-xs rounded-sm px-3 py-1">
          <SquaresExclude size={15} />
          <div>{domain}</div>
        </div>
      </div>

      <div className="flex flex-col gap-2 p-3">
        <div className="flex items-center justify-between">
          <div className="flex gap-2">
            <InteractionCard
              icon={ThumbsUp}
              count={upvotes.length}
              onClick={onUpVote}
            />
            <InteractionCard
              icon={ThumbsDown}
              count={downvotes.length}
              onClick={onDownVote}
            />
            <SheetTrigger asChild>
              <InteractionCard
                icon={MessageSquareText}
                count={comments.length}
                onClick={onCommentsClicked}
              />
            </SheetTrigger>
          </div>
          <Badge
            variant="outline"
            className="flex items-center gap-1 capitalize"
          >
            {getStatusIcon(status)}
            {status}
          </Badge>
        </div>
        <div className="min-w-0">
          <div className="my-1 font-medium truncate">{title}</div>
          <div className="text-sm text-muted-foreground line-clamp-2">
            {desc}
          </div>
        </div>
      </div>
    </div>
  );
}
export default PostCard;
