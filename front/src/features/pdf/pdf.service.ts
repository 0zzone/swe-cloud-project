import { pdfApiClient } from "@/lib/api-clients/pdf-api-client";

export const processPdfFile = async () => {
  return pdfApiClient.get<string>("/process");
};
