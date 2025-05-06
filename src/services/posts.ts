// services/posts.ts
import api from "../lib/axios";
import { Post } from "../types/post";

interface PostsApiResponse {
  success: boolean;
  message: string;
  data: Post[];
}
interface StatusCount {
  total: number;
  raised: number;
  processing: number;
  approved: number;
  rejected: number;
}
interface DasboardApiResponse {
  success: boolean;
  message: string;
  data: StatusCount;
}

interface PostApiResponse {
  success: boolean;
  message: string;
  data: Post;
}
export async function getAllPosts(): Promise<Post[]> {
  try {
    const res = await api.get<PostsApiResponse>("/post");
    return res.data.data;
  } catch (err: any) {
    throw new Error(err.message || "Failed to fetch posts");
  }
}

export async function getStatusCount(): Promise<StatusCount> {
  try {
    const res = await api.get<DasboardApiResponse>("/post/status-count");
    return res.data.data;
  } catch (err: any) {
    throw new Error(err.message || "Failed to fetch posts");
  }
}

export async function logPostStatus(
  postId: string,
  data: { status: string; text: string }
): Promise<Post> {
  try {
    const userId = localStorage.getItem("userId");
    const logData = {
      status: data.status,
      text: data.text,
      userId,
    };

    const res = await api.post<PostApiResponse>(`/post/log/${postId}`, logData);

    return res.data.data;
  } catch (err: any) {
    throw new Error(err.message || "Failed to log post");
  }
}
