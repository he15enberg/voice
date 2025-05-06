import { useState, useEffect } from "react";
import { BellRing } from "lucide-react";

import { cn } from "@/lib/utils";
import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Switch } from "@/components/ui/switch";
import { Post } from "@/types/post";

const statusList = [
  {
    title: "Raised",
    description:
      "Your query has been submitted and is waiting to be picked up.",
    color: "bg-blue-500",
  },
  {
    title: "Processing",
    description: "Our team is actively reviewing your query and working on it.",
    color: "bg-amber-500",
  },
  {
    title: "Approved",
    description:
      "Your query has been successfully addressed and marked as resolved.",
    color: "bg-green-500",
  },
  {
    title: "Rejected",
    description:
      "Your query did not meet the required criteria and was declined.",
    color: "bg-red-500",
  },
];

export function PostDialogLog({
  post,
  setOpen,
  onLogPostStatus,
}: {
  post: Post;
  setOpen: (value: boolean) => void;

  onLogPostStatus: (
    postId: string,
    data: { status: string; text: string }
  ) => void;
}) {
  // Single state to track the selected status object
  const [selectedStatusIndex, setSelectedStatusIndex] = useState(0);
  const [loading, setLoading] = useState(false);

  // Initialize the selected status based on post.status if it exists
  useEffect(() => {
    if (post.status) {
      const matchIndex = statusList.findIndex(
        (status) => status.title.toLowerCase() === post.status.toLowerCase()
      );
      if (matchIndex !== -1) {
        setSelectedStatusIndex(matchIndex);
      }
    }
  }, [post.status]);

  const onLog = async () => {
    setLoading(true);
    try {
      await onLogPostStatus(post._id, {
        status: statusList[selectedStatusIndex].title,
        text: statusList[selectedStatusIndex].description,
      });
      setOpen(false);
    } finally {
      setLoading(false);
    }
  };

  return (
    <Card className={cn("w-[400px] gap-4")}>
      <CardHeader>
        <CardTitle>Log Status</CardTitle>
        <CardDescription>Log Voice issue status for tracking.</CardDescription>
      </CardHeader>
      <CardContent className="grid gap-4">
        <div className="flex items-center space-x-4 rounded-md border p-4">
          <BellRing />
          <div className="flex-1 space-y-1">
            <p className="text-sm font-medium leading-none">
              Push Notifications
            </p>
            <p className="text-sm text-muted-foreground">
              Send notifications to device.
            </p>
          </div>
          <Switch />
        </div>

        <div className="space-y-1">
          {statusList.map((status, index) => {
            const isSelected = index === selectedStatusIndex;
            return (
              <div
                key={index}
                onClick={() => setSelectedStatusIndex(index)}
                className={cn(
                  "cursor-pointer grid grid-cols-[25px_1fr] items-start rounded-md p-2 transition-colors",
                  isSelected ? "bg-muted" : "hover:bg-muted/50"
                )}
              >
                <span
                  className={`flex h-2 w-2 translate-y-1 rounded-full ${status.color}`}
                />
                <div className="space-y-1">
                  <p className="text-sm font-medium leading-none">
                    {status.title}
                  </p>
                  <p className="text-sm text-muted-foreground">
                    {status.description}
                  </p>
                </div>
              </div>
            );
          })}
        </div>
      </CardContent>
      <CardFooter>
        <Button className="w-full" onClick={onLog} disabled={loading}>
          {loading ? "Logging..." : "Log Status"}
        </Button>
      </CardFooter>
    </Card>
  );
}
