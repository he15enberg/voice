"use client";
import React, { useState, useEffect } from "react";
import { AlertsTable } from "./alerts-table";
import { addAlert, deleteAlert, getAllAlerts } from "@/services/alerts";
import { Alert } from "@/types/alerts";
import { AlertSkeleton } from "@/components/skeleton/alert-skeleton";
import { toast } from "sonner";
import { customToast } from "@/components/toast/custom-toast";
import { title } from "process";

export default function Page() {
  const [alerts, setAlerts] = useState<Alert[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  useEffect(() => {
    const fetchAlerts = async () => {
      try {
        const data = await getAllAlerts(); // calling the API
        setAlerts(data); // assuming data is an array of posts
      } catch (err: any) {
        console.log(err);
        setError(err.message || "Failed to load posts.");
      } finally {
        setLoading(false);
      }
    };

    fetchAlerts();
  }, []);
  const handleDeleteAlert = async (alertId: string) => {
    try {
      await deleteAlert(alertId);
      const updatedAlerts = alerts.filter((alert) => alert._id !== alertId);
      setAlerts(updatedAlerts);
      customToast({
        message: "Your alert has been successfully deleted.",
      });
    } catch (err: any) {
      console.log(err);
      customToast({
        message: "Failed to delete alert.",
        type: "error",
      });
    }
  };
  const handleAddAlert = async (alert: {
    title: string;
    message: string;
    type: string;
  }) => {
    try {
      const addedAlert = await addAlert(alert);
      const updatedAlerts = alerts.concat(addedAlert);
      setAlerts(updatedAlerts);
      customToast({
        message: "Your alert has been successfully created.",
      });
    } catch (err: any) {
      console.log(err);
      customToast({
        message: "Failed to delete alert.",
        type: "error",
      });
    }
  };
  return (
    <div className="p-4">
      {/* <AlertsTable data={alerts} onAddAlert={handleAddAlert} /> */}
      {loading ? (
        <AlertSkeleton />
      ) : (
        <AlertsTable
          data={alerts}
          onDeleteAlert={handleDeleteAlert}
          onAddAlert={handleAddAlert}
        />
      )}
    </div>
  );
}
