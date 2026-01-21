import { BaseApiClient } from "./api-client";

export class PdfApiClient extends BaseApiClient {
  constructor() {
    super(import.meta.env.VITE_APP_PDF_SERVICE_URL);
  }
}

export const pdfApiClient = new PdfApiClient();
