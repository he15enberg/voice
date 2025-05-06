import React from "react";
import { Skeleton } from "../ui/skeleton";

export const GroupChatSkeleton = () => {
  return (
    <div className="w-full flex items-center gap-2 border p-2 rounded-md">
      <Skeleton className="h-10 w-10 rounded-full shrink-0" />
      <div className="flex flex-col w-full gap-1">
        <div className="flex items-center gap-1">
          <Skeleton className="h-3 w-3 rounded-full" />
          <Skeleton className="h-4 w-20" />
        </div>
        <Skeleton className="h-4 w-56" />
        <Skeleton className="h-3 w-32" />
        <div className="flex items-center gap-2 mt-1">
          <Skeleton className="h-4 w-20" />
          <Skeleton className="h-4 w-20" />
        </div>
      </div>
    </div>
  );
};
