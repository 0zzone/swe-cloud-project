import { imageApiClient } from "@/lib/api-clients/image-api-client";

export const processImageFile = async () => {
  return imageApiClient.get<string>("/process");
};
