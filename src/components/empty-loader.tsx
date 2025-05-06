"use client";

import dynamic from "next/dynamic";

// Dynamically import Lottie to disable SSR
const Lottie = dynamic(() => import("lottie-react"), { ssr: false });

import pencilDrawingLottie from "@/assets/pencil-drawing.json";

const EmptyLoader = () => {
  return (
    <div className="w-full flex flex-col items-center justify-center">
      <div className="h-[300px] w-[300px]">
        <Lottie animationData={pencilDrawingLottie} height={0} />
      </div>
      <div className="font-medium text-lg">
        Oops! No posts to show right now.
      </div>
      <div className="text-sm mt-2 text-muted-foreground text-center w-1/2">
        Looks like no one has spoken up yet. Be the first to raise your voice,
        share your concern, and help bring attention to the issues that matter
        in your community.
      </div>
    </div>
  );
};

export default EmptyLoader;
