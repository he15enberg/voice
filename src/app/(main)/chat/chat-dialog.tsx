"use client";

import React, { useState, useEffect, useRef } from "react";
import {
  SendIcon,
  AudioLines,
  Users,
  SquaresExclude,
  ShieldUser,
  Loader2,
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { cn } from "@/lib/utils";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { MessageModel, GroupChatModel, User } from "@/types/group-chat";
import PostCard from "../posts/post-card";
import { addMessage } from "@/services/chat";

interface ChatDialogProps {
  isOpen: boolean;
  onClose: () => void;
  groupChat: GroupChatModel | null;
}

export function ChatDialog({ isOpen, onClose, groupChat }: ChatDialogProps) {
  const [messages, setMessages] = useState<MessageModel[]>([]);
  const [newMessage, setNewMessage] = useState("");
  const messagesEndRef = useRef<HTMLDivElement>(null);
  const chatContainerRef = useRef<HTMLDivElement>(null);
  const [currentUser, setCurrentUser] = useState<{
    id: string;
    name: string;
  } | null>(null);
  const [isSending, setIsSending] = useState(false);

  useEffect(() => {
    // Get and store current user ID and name when component mounts
    const userId = localStorage.getItem("userId");
    const userName = localStorage.getItem("userName") || "You";

    if (userId) {
      setCurrentUser({
        id: userId,
        name: userName,
      });
    }

    if (groupChat && groupChat.messages) {
      // Process messages to ensure they have valid post data if needed
      const processedMessages = groupChat.messages.map((message) => {
        if (message.type === "post" && message.post) {
          // Ensure post has the required structure
          return {
            ...message,
            post: ensureValidPostStructure(message.post),
          };
        }
        return message;
      });

      setMessages(processedMessages);

      // Ensure scroll to bottom happens after messages are set
      setTimeout(() => scrollToBottom(), 100);
    } else {
      setMessages([]);
    }
  }, [groupChat]);

  // Helper function to ensure post has required structure
  const ensureValidPostStructure = (post: any) => {
    // Ensure post has expected properties or provide defaults
    return {
      ...post,
      submittedBy: post.submittedBy || { name: "Unknown User" },
      location: post.location || "Unknown location",
      domain: post.domain || "General",
      imageurl: post.imageurl || "",
      title: post.title || "Untitled",
      desc: post.desc || "No description available",
      status: post.status || "pending",
      upvotes: post.upvotes || [],
      downvotes: post.downvotes || [],
      comments: post.comments || [],
    };
  };

  // Improved scroll to bottom function
  const scrollToBottom = () => {
    if (messagesEndRef.current) {
      messagesEndRef.current.scrollIntoView({ behavior: "smooth" });
    }
  };

  // Updated useEffect to watch for messages changes and scroll to bottom
  useEffect(() => {
    if (messages.length > 0) {
      scrollToBottom();
    }
  }, [messages]);

  // Adjust height when dialog opens
  useEffect(() => {
    if (isOpen && chatContainerRef.current) {
      setTimeout(() => scrollToBottom(), 100);
    }
  }, [isOpen]);

  const handleSendMessage = async (e: React.FormEvent) => {
    e.preventDefault();

    if (!newMessage.trim() || !groupChat || !currentUser) return;

    try {
      setIsSending(true);

      // Clear input field immediately
      const messageToSend = newMessage.trim();
      setNewMessage("");

      // Optimistically add message to UI before API call completes
      const tempMessage: MessageModel = {
        userId: {
          _id: currentUser.id,
          name: currentUser.name,
        },
        message: messageToSend,
        role: "Admin",
        type: "text",
        post: null,
        createdAt: new Date().toISOString(),
      };

      setMessages((prev) => [...prev, tempMessage]);

      // Force scroll to bottom after adding temp message
      setTimeout(() => scrollToBottom(), 10);

      const updatedGroup = await addMessage(groupChat._id, messageToSend);
      console.log("Updated group:", updatedGroup);

      if (updatedGroup.messages) {
        // Process messages to ensure they have valid post data if needed
        const processedMessages = updatedGroup.messages.map((message) => {
          if (message.type === "post" && message.post) {
            // Ensure post has the required structure
            return {
              ...message,
              post: ensureValidPostStructure(message.post),
            };
          }
          return message;
        });

        setMessages(processedMessages);

        // Make sure to scroll to bottom after updating messages
        setTimeout(() => scrollToBottom(), 10);
      }
    } catch (error) {
      console.error("Failed to send message:", error);
      // Optional: Show a toast or error notification
    } finally {
      setIsSending(false);
    }
  };

  if (!groupChat) return null;

  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent className="sm:max-w-2xl p-0 max-h-[90vh] h-[90vh]">
        {/* Header */}
        <DialogHeader className="hidden">
          <DialogTitle className="hidden"></DialogTitle>
        </DialogHeader>
        <div className="flex items-center gap-2 border p-2 rounded-md">
          <div className="h-10 w-10 aspect-square rounded-full bg-primary text-primary-foreground flex items-center justify-center shrink-0">
            <AudioLines />
          </div>
          <div className="flex flex-col w-full">
            <div className="truncate font-medium">
              {groupChat.name || "No Name Available"}
            </div>

            <div className="flex items-center gap-2">
              <div className="flex items-center gap-1 text-sm text-muted-foreground">
                <Users size={15} />
                <div>{`${groupChat.members.length} members`}</div>
              </div>
              <div className="flex items-center gap-1 text-sm text-muted-foreground">
                <SquaresExclude size={15} />
                <div>{`${groupChat.postGroup?.posts?.length || 0} posts`}</div>
              </div>
            </div>
          </div>
        </div>
        {/* Chat Messages */}
        <div
          ref={chatContainerRef}
          className="flex-1 p-4 overflow-y-auto bg-muted/30 flex flex-col gap-2 h-[calc(90vh-140px)]"
        >
          {messages.length === 0 ? (
            <div className="flex items-center justify-center h-full">
              <p className="text-muted-foreground">No messages yet</p>
            </div>
          ) : (
            messages.map((message, index) => (
              <ChatMessage
                key={index}
                message={message}
                currentUserId={currentUser?.id!}
              />
            ))
          )}
          <div ref={messagesEndRef} style={{ height: "1px" }} />
        </div>

        {/* Message Input */}
        <form
          onSubmit={handleSendMessage}
          className="p-3 bg-background border-t"
        >
          <div className="flex gap-2">
            <Input
              value={newMessage}
              onChange={(e) => setNewMessage(e.target.value)}
              placeholder="Type your message..."
              className="flex-1"
              disabled={isSending}
            />
            <Button
              type="submit"
              size="icon"
              className="rounded-full text-foreground"
              variant="outline"
              disabled={isSending || !newMessage.trim()}
            >
              {isSending ? (
                <Loader2 className="h-5 w-5 animate-spin" />
              ) : (
                <SendIcon className="h-5 w-5" />
              )}
            </Button>
          </div>
        </form>
      </DialogContent>
    </Dialog>
  );
}

interface ChatMessageProps {
  message: MessageModel;
  currentUserId: string | null;
}

function ChatMessage({ message, currentUserId }: ChatMessageProps) {
  // Check if current user
  const isCurrentUser =
    currentUserId &&
    (message.userId?._id === currentUserId ||
      (typeof message.userId === "string" && message.userId === currentUserId));

  // Get user name with fallback
  const userName =
    typeof message.userId === "object" && message.userId?.name
      ? message.userId.name
      : "Unknown User";

  // Handle different message types
  if (message.type === "post" && message.post) {
    return <PostMessage message={message} currentUserId={currentUserId} />;
  }

  return (
    <div
      className={cn(
        "flex items-start gap-2",
        isCurrentUser ? "justify-end" : "justify-start"
      )}
    >
      {!isCurrentUser && (
        <span className="inline-flex p-2 rounded-full bg-primary text-primary-foreground">
          <ShieldUser />
        </span>
      )}
      <div
        className={cn(
          "max-w-xs px-4 py-2 rounded-lg",
          isCurrentUser
            ? "bg-primary text-primary-foreground rounded-br-none"
            : "bg-card text-card-foreground dark:bg-muted rounded-bl-none shadow-sm"
        )}
      >
        {/* Display user name for non-current users */}
        {!isCurrentUser && (
          <div className="text-xs font-medium mb-1 text-muted-foreground">
            {userName}
          </div>
        )}
        {message.message}
      </div>
    </div>
  );
}

function PostMessage({ message, currentUserId }: ChatMessageProps) {
  // Check if current user
  const isCurrentUser =
    currentUserId &&
    (message.userId?._id === currentUserId ||
      (typeof message.userId === "string" && message.userId === currentUserId));

  // Get user name with fallback
  const userName =
    typeof message.userId === "object" && message.userId?.name
      ? message.userId.name
      : "Unknown User";

  if (!message.post) {
    // Handle case where post is null or undefined
    return (
      <div
        className={cn(
          "flex items-start gap-2",
          isCurrentUser ? "justify-end" : "justify-start"
        )}
      >
        {!isCurrentUser && (
          <span className="inline-flex p-2 rounded-full bg-primary text-primary-foreground">
            <ShieldUser />
          </span>
        )}
        <div
          className={cn(
            "max-w-xs p-3 rounded-lg",
            isCurrentUser
              ? "bg-primary text-primary-foreground rounded-br-none"
              : "bg-card text-card-foreground dark:bg-muted rounded-bl-none shadow-sm"
          )}
        >
          {/* Display user name for non-current users */}
          {!isCurrentUser && (
            <div className="text-xs font-medium mb-1 text-muted-foreground">
              {userName}
            </div>
          )}
          <div className="text-muted-foreground">Invalid post data</div>
          <div className="text-sm mt-1">{message.message}</div>
        </div>
      </div>
    );
  }

  return (
    <div
      className={cn(
        "flex items-start gap-2",
        isCurrentUser ? "justify-end" : "justify-start"
      )}
    >
      {!isCurrentUser && (
        <span className="inline-flex p-2 rounded-full bg-primary text-primary-foreground">
          <ShieldUser />
        </span>
      )}
      <div
        className={cn(
          "max-w-xs p-3 rounded-lg",
          isCurrentUser
            ? "bg-primary text-primary-foreground rounded-br-none"
            : "bg-card text-card-foreground dark:bg-muted rounded-bl-none shadow-sm"
        )}
      >
        {/* Display user name for non-current users */}
        {!isCurrentUser && (
          <div className="text-xs font-medium mb-1 text-muted-foreground">
            {userName}
          </div>
        )}
        {/* Add null checks before passing the post to PostCard */}
        {message.post && (
          <div className="">
            <PostCard
              post={message.post}
              onClick={() => {}}
              onCommentsClicked={() => {}}
              onDownVote={() => {}}
              onUpVote={() => {}}
            />
          </div>
        )}
        <div className="text-sm mt-1">{message.message}</div>
      </div>
    </div>
  );
}
