"use client";

import React, { useState, useEffect } from "react";
import EmptyLoader from "@/components/empty-loader";
import { customToast } from "@/components/toast/custom-toast";
import { getAllGroupChats } from "@/services/chat";
import { GroupChatModel } from "@/types/group-chat";
import { AudioLines, Users, SquaresExclude } from "lucide-react";
import { ChatDialog } from "./chat-dialog";
import { GroupChatSkeleton } from "@/components/skeleton/group-chat-skeleton";

export default function Page() {
  const [dialogOpen, setDialogOpen] = useState(false);
  const [groupChats, setGroupChats] = useState<GroupChatModel[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedChat, setSelectedChat] = useState<GroupChatModel | null>(null);

  useEffect(() => {
    const fetchGroupChats = async () => {
      try {
        const data = await getAllGroupChats(); // calling the API
        setGroupChats(data); // assuming data is an array of posts
      } catch (error: unknown) {
        if (error instanceof Error) {
          customToast({
            message: error.message || "Failed to load group chats",
            type: "error",
          });
        } else {
          customToast({
            message: "Failed to load group chats",
            type: "error",
          });
        }
      } finally {
        setLoading(false);
      }
    };

    fetchGroupChats();
  }, []);

  const handleChatClick = (groupChat: GroupChatModel) => {
    setSelectedChat(groupChat);
    setDialogOpen(true);
  };

  return (
    <div className="relative">
      {loading ? (
        <div className="p-4 gap-4 grid grid-cols-1 sm:grid-cols-2 md:grid-cols-2 lg:grid-cols-3 w-full">
          {Array.from({ length: 5 }).map((_, i) => (
            <div key={i}>
              <GroupChatSkeleton />
            </div>
          ))}
        </div>
      ) : groupChats.length === 0 ? (
        <EmptyLoader />
      ) : (
        <div className="p-4 gap-4 grid grid-cols-1 sm:grid-cols-2 md:grid-cols-2 lg:grid-cols-3 w-full">
          {groupChats.map((groupChat) => (
            <div
              key={groupChat._id}
              className="cursor-pointer hover:shadow-md transition-shadow"
              onClick={() => handleChatClick(groupChat)}
            >
              <div className="flex items-center gap-2 border p-2 rounded-md overflow-hidden">
                <div className="h-10 w-10 aspect-square rounded-full bg-primary text-primary-foreground flex items-center justify-center shrink-0">
                  <AudioLines />
                </div>
                <div className="flex flex-col w-full min-w-0">
                  <div className="flex items-center gap-1 border rounded-sm px-2 py-1 text-xs text-muted-foreground min-w-[100px] max-w-full overflow-hidden">
                    <div className="h-3 w-3 bg-blue-500 rounded-full shrink-0"></div>
                    <div className="truncate w-full">
                      {groupChat.postGroup?.domain || "No domain"}
                    </div>
                  </div>
                  <div className="truncate w-full font-medium">
                    {groupChat.name}
                  </div>
                  <div className="truncate w-full font-medium text-sm text-muted-foreground">
                    {groupChat.postGroup?.location || "No location"}
                  </div>
                  <div className="flex items-center gap-2 mt-1 w-full">
                    <div className="flex items-center gap-1 text-sm text-muted-foreground">
                      <Users size={15} className="shrink-0" />
                      <div className="truncate">{`${groupChat.members.length} members`}</div>
                    </div>
                    <div className="flex items-center gap-1 text-sm text-muted-foreground">
                      <SquaresExclude size={15} className="shrink-0" />
                      <div className="truncate">{`${
                        groupChat.postGroup?.posts?.length || 0
                      } posts`}</div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Chat Dialog */}
      <ChatDialog
        isOpen={dialogOpen}
        onClose={() => setDialogOpen(false)}
        groupChat={selectedChat}
      />
    </div>
  );
}
