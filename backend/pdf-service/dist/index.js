"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
const dotenv_1 = __importDefault(require("dotenv"));
const prisma_1 = require("@/lib/prisma");
const utils_1 = require("@/lib/utils");
dotenv_1.default.config();
const app = (0, express_1.default)();
const PORT = process.env.PORT || 3002;
app.use((0, cors_1.default)());
app.use(express_1.default.json());
app.get("/", (req, res) => {
    res.send("PDF service is running!");
});
app.post("/process", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const process = yield prisma_1.prisma.process.create({
        data: {},
    });
    const delay = (0, utils_1.generateRandomDelay)(2, 5);
    setTimeout(() => __awaiter(void 0, void 0, void 0, function* () {
        yield prisma_1.prisma.process.update({
            where: { id: process.id },
            data: { endDate: new Date() },
        });
        res.json({ message: `PDF processed in ${delay / 1000} seconds!` });
    }), delay);
}));
app.listen(PORT, () => {
    console.log(`PDF service running on port ${PORT}`);
});
