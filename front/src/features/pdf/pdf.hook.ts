import { useMutation } from "@tanstack/react-query";
import { processPdfFile } from "./pdf.service";
import { toast } from "sonner";

export const useProcessPdfFile = () => {
  return useMutation({
    mutationFn: processPdfFile,
    onSuccess: () => {
      toast.success("PDF processed successfully!");
    },
    onError: (error: Error) => {
      toast.error(`Error processing PDF: ${error.message}`);
    },
  });
};
