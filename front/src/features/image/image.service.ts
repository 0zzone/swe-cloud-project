import { apiClient } from "@/lib/api-client";
import type { ProcessImageResponse } from "@/lib/types";

export const processImageFile = async () => {
  return apiClient.post<ProcessImageResponse>("/image/process");
};
