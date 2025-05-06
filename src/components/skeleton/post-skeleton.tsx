import React from "react";
import { Skeleton } from "../ui/skeleton";

export const PostSkeleton = () => {
  return (
    <div className="flex flex-col gap-2">
      <div className="flex items-center space-x-4">
        <Skeleton className="h-12 w-12 rounded-full" />
        <div className="space-y-2">
          <Skeleton className="h-4 w-[200px]" />
          <Skeleton className="h-4 w-[150px]" />
        </div>
      </div>
      <Skeleton className="h-[200px] w-full rounded-md" />
      <div className="space-y-2">
        <Skeleton className="h-4 w-[200px]" />
        <Skeleton className="h-4 w-full" />
      </div>
    </div>
  );
};
