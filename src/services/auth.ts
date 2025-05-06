import api from "@/lib/axios";
import { User } from "@/types/user";
import Router from "next/router";

interface AuthApiResponse {
  success: boolean;
  token: string;
  refreshToken: string;
  message: string;
  data: User;
}
interface UsersApiResponse {
  success: boolean;
  message: string;
  data: User[];
}

export async function signIn(data: {
  email: string;
  password: string;
}): Promise<User> {
  try {
    const res = await api.post<AuthApiResponse>(`/auth/signin`, data);
    return res.data.data;
  } catch (error: unknown) {
    if (error instanceof Error) {
      throw new Error(error.message || "Failed to Signin user.");
    }
    throw new Error("Failed to Signin user.");
  }
}

export async function signUp(data: {
  name: string;
  email: string;
  password: string;
  phone: string;
  role: string;
}): Promise<User> {
  try {
    const res = await api.post<AuthApiResponse>(`/auth/signup`, data);
    return res.data.data;
  } catch (error: unknown) {
    if (error instanceof Error) {
      throw new Error(error.message || "Failed to SignUp user.");
    }
    throw new Error("Failed to SignUp user.");
  }
}

export async function getUser(): Promise<User> {
  try {
    const userId = localStorage.getItem("userId");

    const res = await api.get<AuthApiResponse>(`/auth/${userId}`);
    console.log(res.data.data);
    return res.data.data;
  } catch (error: unknown) {
    if (error instanceof Error) {
      throw new Error(error.message || "Failed to fetch user data.");
    }
    throw new Error("Failed to fetch user data.");
  }
}

export async function deleteUser(userId: string): Promise<User> {
  try {
    const res = await api.delete<AuthApiResponse>(`/auth/${userId}`);
    console.log(res.data.data);
    return res.data.data;
  } catch (error: unknown) {
    if (error instanceof Error) {
      throw new Error(error.message || "Failed to delete user data.");
    }
    throw new Error("Failed to delete user data.");
  }
}

export async function getAllUsers(): Promise<User[]> {
  try {
    const res = await api.get<UsersApiResponse>(`/auth/`);
    console.log(res.data.data);
    return res.data.data;
  } catch (error: unknown) {
    if (error instanceof Error) {
      throw new Error(error.message || "Failed to fetch user data.");
    }
    throw new Error("Failed to fetch user data.");
  }
}

export async function signOut() {
  try {
    localStorage.removeItem("isAuthenticated");
    localStorage.removeItem("userId");

    Router.push("/signin");
  } catch (error) {
    console.error("Failed to sign out:", error);
  }
}
