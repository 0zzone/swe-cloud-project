import { BaseApiClient } from "./api-client";

export class ImageApiClient extends BaseApiClient {
  constructor() {
    super(import.meta.env.VITE_APP_IMAGE_SERVICE_URL);
  }
}

export const imageApiClient = new ImageApiClient();
