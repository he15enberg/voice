import Image from "next/image";
import { Image as LucideImage } from "lucide-react";
import { useState } from "react";

export default function PostImage({ imageUrl }: { imageUrl: string }) {
  const [hasError, setHasError] = useState<boolean>(false);
  if (hasError) {
    return (
      <div className="flex flex-col justify-center items-center h-full w-full">
        <LucideImage />
        <span className="text-sm mt-1">Image not found</span>
        <span className="text-xs text-muted-foreground">
          Error while loading image data.
        </span>
      </div>
    );
  }

  return (
    <Image
      src={`data:image/jpeg;base64,${imageUrl}`}
      alt="Post Image"
      className="w-full h-full object-cover"
      width={0}
      height={0}
      sizes="100vw"
      unoptimized
      onError={() => setHasError(true)}
    />
  );
}
