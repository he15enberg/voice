"use client";

import { AppSidebar } from "@/components/app-sidebar";
import { SiteHeader } from "@/components/site-header";
import { SidebarInset, SidebarProvider } from "@/components/ui/sidebar";
import {
  AudioLines,
  BellRing,
  LayoutDashboardIcon,
  MessageSquareText,
  UsersIcon,
} from "lucide-react";
import { usePathname } from "next/navigation";
const navMain = [
  {
    title: "Dashboard",
    url: "/dashboard",
    icon: LayoutDashboardIcon,
  },
  {
    title: "Posts",
    url: "/posts",
    icon: AudioLines,
  },
  {
    title: "Chat",
    url: "/chat",
    icon: MessageSquareText,
  },
  {
    title: "Alerts",
    url: "/alerts",
    icon: BellRing,
  },
  {
    title: "Users",
    url: "/users",
    icon: UsersIcon,
  },
];
export default function SideBarLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  const pathname = usePathname();
  const current = navMain.find((item) => pathname?.startsWith(item.url));
  const currentTitle = current?.title ?? "Voice";

  return (
    <SidebarProvider>
      <AppSidebar variant="inset" navMainItems={navMain} />
      <SidebarInset>
        <SiteHeader title={currentTitle} />
        <div className="flex flex-1 flex-col">
          <div className="@container/main flex flex-1 flex-col gap-2">
            {children}
          </div>
        </div>
      </SidebarInset>
    </SidebarProvider>
  );
}
