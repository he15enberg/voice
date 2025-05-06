import { Button } from "@/components/ui/button";
import {
  SheetClose,
  SheetContent,
  SheetDescription,
  SheetFooter,
  SheetHeader,
  SheetTitle,
} from "@/components/ui/sheet";
import { Post } from "@/types/post";
import { ShieldUser } from "lucide-react";

interface PostCommentsSheetProps {
  post: Post | null;
}

export function PostCommentsSheet({ post }: PostCommentsSheetProps) {
  if (!post) return null;

  return (
    <SheetContent className="gap-0">
      <SheetHeader className="px-4 m-0">
        <SheetTitle className="p-0">Voice Comments</SheetTitle>
      </SheetHeader>

      <div className="px-4 flex flex-col gap-2">
        {post.comments.map((comment, idx) => (
          <div key={idx} className="flex gap-2 w-full">
            <div className="flex items-center justify-center w-9 h-9 rounded-full bg-primary text-primary-foreground">
              <ShieldUser />
            </div>
            <div className="flex flex-col w-full">
              <div className="text-sm font-medium">{comment.username}</div>
              <div className="text-sm text-muted-foreground line-clamp-2 ">
                {comment.text}
              </div>
            </div>
          </div>
        ))}
      </div>

      <SheetFooter>
        <SheetClose asChild>
          <Button>Close</Button>
        </SheetClose>
      </SheetFooter>
    </SheetContent>
  );
}
