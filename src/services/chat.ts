import { log } from "console";
import api from "../lib/axios";
import { GroupChatModel } from "@/types/group-chat";

interface ChatsApiResponse {
  success: boolean;
  message: string;
  data: GroupChatModel[];
}
interface ChatApiResponse {
  success: boolean;
  message: string;
  data: GroupChatModel;
}

export async function getAllGroupChats(): Promise<GroupChatModel[]> {
  try {
    const res = await api.get<ChatsApiResponse>("/group-chat");
    console.log(res.data.data);
    return res.data.data;
  } catch (err: any) {
    throw new Error(err.message || "Failed to fetch group chats");
  }
}

export async function addMessage(
  groupChatId: string,
  message: string
): Promise<GroupChatModel> {
  try {
    const userId = localStorage.getItem("userId");
    const messageData = {
      userId,
      message,
      role: "Admin",
      type: "text",
      post: null,
    };
    const res = await api.post<ChatApiResponse>(
      `/group-chat/chat/${groupChatId}`,
      messageData
    );
    console.log(res.data.data);
    return res.data.data;
  } catch (err: any) {
    throw new Error(err.message || "Failed to add message");
  }
}
