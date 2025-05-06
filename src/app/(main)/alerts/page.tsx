"use client";
import React, { useState, useEffect } from "react";
import { AlertsTable } from "./alerts-table";
import { addAlert, deleteAlert, getAllAlerts } from "@/services/alerts";
import { Alert } from "@/types/alerts";
import { AlertSkeleton } from "@/components/skeleton/alert-skeleton";
import { customToast } from "@/components/toast/custom-toast";

export default function Page() {
  const [alerts, setAlerts] = useState<Alert[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchAlerts = async () => {
      try {
        const data = await getAllAlerts(); // calling the API
        setAlerts(data); // assuming data is an array of posts
      } catch (error: unknown) {
        // eslint-disable-next-line no-console
        console.log(
          error instanceof Error ? error.message : "Unknown error occurred"
        );
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
    } catch (error: unknown) {
      // Better type than 'any'
      console.log(
        error instanceof Error ? error.message : "Unknown error occurred"
      );
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
    } catch (error: unknown) {
      // Better type than 'any'
      console.log(
        error instanceof Error ? error.message : "Unknown error occurred"
      );
      customToast({
        message: "Failed to create alert.", // Fixed text here
        type: "error",
      });
    }
  };

  return (
    <div className="p-4">
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
