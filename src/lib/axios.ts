import axios from "axios";

const api = axios.create({
  baseURL: process.env.NEXT_PUBLIC_API_URL,
  timeout: 10000,
});

api.interceptors.response.use(
  (response) => response,
  (error) => {
    console.error("API Error:", error?.response || error?.message);
    return Promise.reject(
      error?.response?.data || { message: "Something went wrong" }
    );
  }
);

export default api;
