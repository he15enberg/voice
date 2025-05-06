// services/posts.ts
import { Alert } from "@/types/alerts";
import api from "../lib/axios";

interface AlertsApiResponse {
  success: boolean;
  message: string;
  data: Alert[];
}
interface AlertApiResponse {
  success: boolean;
  message: string;
  data: Alert;
}

export async function getAllAlerts(): Promise<Alert[]> {
  try {
    const res = await api.get<AlertsApiResponse>("/alert");
    return res.data.data;
  } catch (error) {
    throw new Error("Failed to fetch alerts");
  }
}
export async function deleteAlert(alertId: string): Promise<Alert[]> {
  try {
    const res = await api.delete<AlertsApiResponse>(`/alert/${alertId}`);
    return res.data.data;
  } catch (error) {
    throw new Error("Failed to delete alerts");
  }
}
export async function addAlert(alert: {
  title: string;
  message: string;
  type: string;
}): Promise<Alert> {
  try {
    const res = await api.post<AlertApiResponse>(`/alert/`, alert);
    return res.data.data;
  } catch (error) {
    throw new Error("Failed to add alerts");
  }
}
