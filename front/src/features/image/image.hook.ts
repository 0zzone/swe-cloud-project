import { useMutation } from "@tanstack/react-query";
import { processImageFile } from "./image.service";
import { toast } from "sonner";

export const useProcessImageFile = () => {
  return useMutation({
    mutationFn: processImageFile,
    onSuccess: () => {
      toast.success("Image processed successfully!");
    },
    onError: (error: Error) => {
      toast.error(`Error processing Image: ${error.message}`);
    },
  });
};
