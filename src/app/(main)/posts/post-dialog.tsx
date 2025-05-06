import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  MessageSquareText,
  Pencil,
  ShieldUser,
  SquaresExclude,
  ThumbsDown,
  ThumbsUp,
} from "lucide-react";
import Image from "next/image";
import { InteractionCard } from "@/components/interaction-card";
import { Post } from "@/types/post";
import { Badge } from "@/components/ui/badge";
import { getStatusIcon } from "@/lib/helper";
import { PostDialogLog } from "@/components/post-dialog-log";

interface PostDialogProps {
  open: boolean;
  setOpen: (value: boolean) => void;
  post: Post | null;
  onLogPostStatus: (
    postId: string,
    data: { status: string; text: string }
  ) => void;
}

export function PostDialog({
  open,
  setOpen,
  post,
  onLogPostStatus,
}: PostDialogProps) {
  if (!post) return null;

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogContent className="sm:max-w-[800px] p-0">
        <DialogHeader className="hidden">
          <DialogTitle className="hidden"></DialogTitle>
        </DialogHeader>
        <div className="flex items-center justify-between">
          {" "}
          <div className="p-0 w-[400px] ">
            <div className="p-3 m-0">
              <div className="flex items-center gap-2">
                <span className="inline-flex p-2 rounded-full bg-primary text-primary-foreground">
                  <ShieldUser />
                </span>
                <div className="min-w-0">
                  <div className="font-medium">{post.submittedBy.name}</div>
                  <div className="text-xs text-muted-foreground truncate">
                    {post.location}
                  </div>
                </div>
                <div className="flex-1" />
                <button className="h-10 w-10 rounded-full hover:bg-muted/75 transition-colors duration-200 ease-in-out">
                  <Pencil size={17.5} className="mx-3" />
                </button>
              </div>
            </div>

            <div className="relative ">
              <div className="h-[250px] overflow-hidden">
                <Image
                  src={`data:image/jpeg;base64,${post.imageurl}`}
                  alt="Post Image"
                  className="w-full h-full object-cover"
                  width={0}
                  height={0}
                  sizes="100vw"
                  unoptimized
                />
              </div>

              <div className="absolute shadow top-3 text-white flex gap-2 left-3 bg-blue-500 text-xs rounded-sm px-3 py-1">
                <SquaresExclude size={15} />
                <div>{post.domain}</div>
              </div>
            </div>

            <div className="flex flex-col gap-2 p-3">
              <div className="flex items-center justify-between">
                <div className="flex gap-2">
                  <InteractionCard
                    icon={ThumbsUp}
                    count={post.upvotes.length}
                  />
                  <InteractionCard
                    icon={ThumbsDown}
                    count={post.downvotes.length}
                  />
                  <InteractionCard
                    icon={MessageSquareText}
                    count={post.comments.length}
                  />
                </div>
                <Badge
                  variant="outline"
                  className="flex items-center gap-1 capitalize"
                >
                  {getStatusIcon(post.status)}
                  {post.status}
                </Badge>
              </div>
              <div className="min-w-0">
                <div className="my-1 font-medium truncate">{post.title}</div>
                <div className="text-sm text-muted-foreground line-clamp-2">
                  {post.desc}
                </div>
              </div>
            </div>
          </div>
          <div>
            <div className="">
              <PostDialogLog
                post={post}
                onLogPostStatus={onLogPostStatus}
                setOpen={setOpen}
              />
            </div>
          </div>
        </div>
        <DialogFooter className="hidden"></DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
