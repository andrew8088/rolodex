export class ValidationError extends Error {
  constructor(message: string, public reasons: string[] = []) {
    super(message);
  }
}
