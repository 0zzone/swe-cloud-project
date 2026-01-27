import { apiClient } from "@/lib/api-client";

export const processImageFile = async () => {
  return apiClient.post<string>("/image/process");
};
