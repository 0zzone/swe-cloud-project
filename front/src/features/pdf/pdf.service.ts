import { apiClient } from "@/lib/api-client";
import type { ProcessImageResponse } from "@/lib/types";

export const processPdfFile = async () => {
  return apiClient.post<ProcessImageResponse>("/pdf/process");
};
