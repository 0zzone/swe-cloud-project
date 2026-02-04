import express, { Request, Response } from "express";
import cors from "cors";
import dotenv from "dotenv";
import { prisma } from "@/lib/prisma";
import { generateRandomDelay } from "@/lib/utils";

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3001;

app.use(cors());
app.use(express.json());

app.get("/", (req: Request, res: Response) => {
  res.send("Image service is running!");
});

app.post("/process", async (req: Request, res: Response) => {
  const process = await prisma.process.create({
    data: {},
  });
  const delay = generateRandomDelay(2, 5);
  setTimeout(async () => {
    await prisma.process.update({
      where: { id: process.id },
      data: { endDate: new Date() },
    });
    res.json({ message: `Image processed in ${delay / 1000} seconds!` });
  }, delay);
});

app.listen(PORT, () => {
  console.log(`Image service running on port ${PORT}`);
});
