import { apiClient } from "@/lib/api-client";

export const processPdfFile = async () => {
  return apiClient.post<string>("/pdf/process");
};
