export interface SubmittedBy {
  userId: string;
  name: string;
}

export interface Comment {
  userId: string;
  username: string;
  text: string;
  createdAt: string;
}

export interface Post {
  _id: string;
  title: string;
  desc: string;
  domain: string;
  location: string;
  imageurl: string;
  submittedBy: SubmittedBy;
  upvotes: string[];
  downvotes: string[];
  status: string;
  comments: Comment[];
  createdAt: string;
  updatedAt: string;
}
