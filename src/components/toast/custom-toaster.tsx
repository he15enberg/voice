"use client";

import { Toaster as SonnerToaster } from "sonner";
import { useTheme } from "next-themes";

// Custom Toaster component that adapts to the current theme
export function CustomToaster() {
  const { resolvedTheme } = useTheme();

  return (
    <SonnerToaster
      theme={resolvedTheme as "light" | "dark" | undefined}
      //   className="toaster-wrapper"
      //   toastOptions={{
      //     classNames: {
      //       toast: "group toast-base",
      //       title: "toast-title",
      //       description: "toast-description",
      //       actionButton: "toast-action-button",
      //       cancelButton: "toast-cancel-button",
      //       success: "toast-success",
      //       error: "toast-error",
      //       info: "toast-info",
      //       warning: "toast-warning",
      //     },
      //   }}
    />
  );
}
