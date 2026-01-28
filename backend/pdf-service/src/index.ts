import express, { Request, Response } from "express";
import cors from "cors";
import dotenv from "dotenv";

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3002;

app.use(cors());
app.use(express.json());

app.post("/process", (req: Request, res: Response) => {
  setTimeout(() => {
    res.json({ message: "PDF processed!" });
  }, 3000);
});

app.listen(PORT, () => {
  console.log(`PDF service running on port ${PORT}`);
});
