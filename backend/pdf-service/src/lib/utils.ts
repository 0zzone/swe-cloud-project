export const generateRandomDelay = (
  minSeconds: number,
  maxSeconds: number,
): number => {
  const minMs = minSeconds * 1000;
  const maxMs = maxSeconds * 1000;
  const delay = Math.floor(Math.random() * (maxMs - minMs + 1)) + minMs;
  return delay;
};
