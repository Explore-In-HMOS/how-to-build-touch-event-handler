export class PrecisionUtils {
  static calculateDistance(
    targetX: number,
    targetY: number,
    touchX: number,
    touchY: number
  ): number {
    const dx = targetX - touchX;
    const dy = targetY - touchY;

    return Math.sqrt(dx * dx + dy * dy);
  }

  static calculateAccuracy(distance: number): number {
    const maxDistance = 140;
    const accuracy =
      Math.max(0, 100 - (distance / maxDistance) * 100);
    return Number(accuracy.toFixed(2));
  }
}