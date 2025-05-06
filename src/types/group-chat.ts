// PostModel should be imported or defined if not present
// import { PostModel } from './post.model';

import { Post } from "./post";

export interface GroupChatModel {
  _id: string;
  name: string;
  postGroup: PostGroupModel | null;
  members: MemberModel[];
  messages?: MessageModel[] | null;
  createdAt: string; // ISO string format
}

export interface PostGroupModel {
  _id: string;
  similarQueries: string[];
  domain: string;
  location: string;
  posts?: Post[];
  createdAt: string;
  updatedAt: string;
}

export interface MemberModel {
  _id: string;
  name: string;
}

export interface MessageModel {
  userId: User | null;
  message: string;
  role: string;
  type: string;
  post?: Post | null;
  createdAt: string;
}

export interface User {
  _id: string;
  name: string;
}
