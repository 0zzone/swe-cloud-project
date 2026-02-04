import { apiClient } from "@/lib/api-client";
import type { ProcessImageResponse } from "./image.type";

export const processImageFile = async () => {
  return apiClient.post<ProcessImageResponse>("/image/process");
};
