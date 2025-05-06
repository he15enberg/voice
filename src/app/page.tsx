"use client";

import { useEffect } from "react";
import { useRouter } from "next/navigation";
import dynamic from "next/dynamic";
import doccerLoaderLottie from "@/assets/doccer-loader.json";

const Lottie = dynamic(() => import("lottie-react"), { ssr: false });

export default function Home() {
  const router = useRouter();

  useEffect(() => {
    const isAuthenticated = localStorage.getItem("isAuthenticated");
    const userId = localStorage.getItem("userId");

    if (isAuthenticated === "true" && userId) {
      router.replace("/dashboard");
    } else {
      router.replace("/signin");
    }
  }, [router]);

  return (
    <div className="h-screen w-full flex flex-col items-center justify-center">
      <div className="h-[200px] w-[300px]">
        <Lottie animationData={doccerLoaderLottie} />
      </div>
      <div className="font-medium text-lg">Just a moment...</div>
      <div className="text-sm mt-2 text-muted-foreground text-center w-1/2">
        We’re setting things up for you.
      </div>
    </div>
  );
}
