"use client";

import React, { useState, useEffect } from "react";
import { UsersTable } from "./users-table";
import { customToast } from "@/components/toast/custom-toast";
import { User } from "@/types/user";
import { deleteUser, getAllUsers } from "@/services/auth";
import { UserSkeleton } from "@/components/skeleton/user-skeleton";

export default function UsersPage() {
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    const fetchUsers = async () => {
      try {
        const data = await getAllUsers(); // calling the API
        setUsers(data); // assuming data is an array of users
      } catch (error) {
        console.log(error);
        setError("Failed to load users.");
      } finally {
        setLoading(false);
      }
    };

    fetchUsers();
  }, []);

  const handleDelete = async () => {
    try {
      const userId = localStorage.getItem("userId") ?? "";

      await deleteUser(userId);
      setUsers((prevUsers) => prevUsers.filter((user) => user._id !== userId));
      customToast({ message: "User deleted successfully" });
    } catch (error) {
      console.error(error);
      customToast({ message: "Failed to delete user.", type: "error" });
    }
  };

  if (loading)
    return (
      <div className="p-4">
        {" "}
        <UserSkeleton />
      </div>
    );

  if (error)
    return (
      <div className="text-center text-red-500 mt-4">
        <p>{error}</p>
      </div>
    );

  return (
    <div className="p-4">
      <UsersTable data={users} onDeleteUser={handleDelete} />
    </div>
  );
}
