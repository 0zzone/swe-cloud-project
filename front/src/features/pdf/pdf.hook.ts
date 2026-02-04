import { useMutation } from "@tanstack/react-query";
import { processPdfFile } from "./pdf.service";
import { toast } from "sonner";
import type { ProcessImageResponse } from "@/lib/types";

export const useProcessPdfFile = () => {
  return useMutation({
    mutationFn: processPdfFile,
    onSuccess: (data: ProcessImageResponse) => {
      toast.success(data.message);
    },
    onError: (error: Error) => {
      toast.error(`Error processing PDF: ${error.message}`);
    },
  });
};
