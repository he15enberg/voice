import { CircleAlert, CircleCheckBig, CircleX, Info } from "lucide-react";
import { toast } from "sonner";

type ToastType = "success" | "error" | "info" | "warning";
interface ToastProps {
  type?: ToastType;
  message: string;
  title?: string;
}
// Create a separate React hook to get the theme
import { useTheme } from "next-themes";
import { useEffect, useState } from "react";
import { Button } from "../ui/button";
import { DateTime } from "luxon";

// Custom hook to safely get theme
export function useThemeSafe() {
  const { theme, resolvedTheme } = useTheme();
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  return {
    theme: mounted ? theme : undefined,
    resolvedTheme: mounted ? resolvedTheme : undefined,
    mounted,
  };
}

// Toast utility component that can access the theme
export function ToastWithTheme({
  type,
  message,
  onClose,
}: {
  message: string;
  type: ToastType;
  onClose: () => void;
}) {
  const { resolvedTheme } = useThemeSafe();

  const toastTypeInfo = {
    success: {
      title: "Action Successful",
      icon: <CircleCheckBig size={20} className="text-green-500" />,
    },
    error: {
      title: "Action Error",
      icon: <CircleX size={20} className="text-red-500" />,
    },
    warning: {
      title: "Action Warning",
      icon: <CircleAlert size={20} className="text-amber-500" />,
    },
    info: {
      title: "Action Info",
      icon: <Info size={20} className="text-blue-500" />,
    },
  };

  return (
    <div className="flex w-full  items-center justify-between">
      <div className="flex items-center gap-4">
        {toastTypeInfo[type].icon}
        <div className="flex flex-col">
          <div className="text-xs text-muted-foreground">
            {DateTime.now().toFormat("d MMMM yyyy, hh:mm a")}
          </div>
          {/* <span className="font-semibold">
            {title || toastTypeInfo[type].title}
          </span> */}
          <span className="text-sm mt-1">{message}</span>
        </div>{" "}
      </div>
      <div className="flex-1"></div>
      <Button
        variant="outline"
        size="sm"
        onClick={onClose}
        className={`${
          resolvedTheme === "dark" ? "hover:bg-slate-700" : "hover:bg-slate-200"
        }`}
      >
        Close
      </Button>
    </div>
  );
}

// Main toast function that can be called from anywhere
export function customToast({ type = "success", message }: ToastProps) {
  return toast.custom(
    (id) => (
      <div
        className={`w-full max-w-md rounded-md p-4 border bg-white dark:bg-black`}
      >
        <ToastWithTheme
          type={type}
          message={message}
          onClose={() => toast.dismiss(id)}
        />
      </div>
    ),
    {
      duration: 4000,
      className: "w-full ",
    }
  );
}
