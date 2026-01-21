import { Button } from "@/components/ui/button";
import { useProcessPdfFile } from "./features/pdf/pdf.hook";
import { useProcessImageFile } from "./features/image/image.hook";
import { Spinner } from "@/components/ui/spinner";

export const App = () => {
  const { mutate: processPdf, isPending: isPdfPending } = useProcessPdfFile();
  const { mutate: processImage, isPending: isImagePending } =
    useProcessImageFile();

  const handleProcessPdf = () => {
    processPdf();
  };

  const handleProcessImage = () => {
    processImage();
  };

  return (
    <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 space-y-5">
      <h1 className="text-3xl text-center">Files Processor App</h1>
      <div className="flex justify-center gap-3">
        <Button
          className="cursor-pointer"
          variant="outline"
          onClick={handleProcessPdf}
          disabled={isPdfPending}
        >
          {isPdfPending ? (
            <div className="flex items-center gap-2">
              <Spinner />
              Loading...
            </div>
          ) : (
            "Process PDF File"
          )}
        </Button>
        <Button
          className="cursor-pointer"
          variant="outline"
          onClick={handleProcessImage}
          disabled={isImagePending}
        >
          {isImagePending ? (
            <div className="flex items-center gap-2">
              <Spinner />
              Loading...
            </div>
          ) : (
            "Process Image"
          )}
        </Button>
      </div>
    </div>
  );
};

export default App;
