import { useMutation } from "@tanstack/react-query";
import { processImageFile } from "./image.service";
import { toast } from "sonner";
import type { ProcessImageResponse } from "@/lib/types";

export const useProcessImageFile = () => {
  return useMutation({
    mutationFn: processImageFile,
    onSuccess: (data: ProcessImageResponse) => {
      toast.success(data.message);
    },
    onError: (error: Error) => {
      toast.error(`Error processing Image: ${error.message}`);
    },
  });
};
