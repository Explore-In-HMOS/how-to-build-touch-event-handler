export class TouchRecord {
  x: number;
  y: number;
  timestamp: number;
  type: string;

  constructor(
    x: number,
    y: number,
    timestamp: number,
    type: string
  ) {
    this.x = x;
    this.y = y;
    this.timestamp = timestamp;
    this.type = type;
  }
}