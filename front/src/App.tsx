import { Button } from "@/components/ui/button";

export const App = () => {
  return (
    <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 space-y-5">
      <h1 className="text-3xl text-center">Files Processor App</h1>
      <div className="flex justify-center gap-3">
        <Button className="cursor-pointer" variant="outline">
          Process PDF
        </Button>
        <Button className="cursor-pointer" variant="outline">
          Process Image
        </Button>
      </div>
    </div>
  );
};

export default App;
