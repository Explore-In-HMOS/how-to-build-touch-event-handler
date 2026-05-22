export class CalibrationResult {
  accuracy: number;
  distance: number;
  success: boolean;

  constructor(
    accuracy: number,
    distance: number,
    success: boolean
  ) {
    this.accuracy = accuracy;
    this.distance = distance;
    this.success = success;
  }
}