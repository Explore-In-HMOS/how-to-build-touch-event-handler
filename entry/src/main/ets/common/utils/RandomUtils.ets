import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { BusinessError } from '@kit.BasicServicesKit';

export class RandomUtils {
  private static randomInstance: cryptoFramework.Random | null = null;

  /**
   * Initialize the random generator instance
   */
  private static async getRandomInstance(): Promise<cryptoFramework.Random> {
    if (RandomUtils.randomInstance === null) {
      RandomUtils.randomInstance = cryptoFramework.createRandom();
      // Set seed using current time for better entropy
      const time = Date.now();
      const seed = new Uint8Array([
        (time & 0xFF),
        (time >> 8) & 0xFF,
        (time >> 16) & 0xFF,
        (time >> 24) & 0xFF
      ]);
      try {
        RandomUtils.randomInstance.setSeed({ data: seed });
      } catch (error) {
        console.error('Failed to set seed:', error);
      }
    }
    return RandomUtils.randomInstance;
  }

  /**
   * Generate a cryptographically secure random integer between min and max (inclusive)
   * @param min Minimum value (inclusive)
   * @param max Maximum value (inclusive)
   * @returns Promise<number> Random integer between min and max
   */
  static async getRandomInt(min: number, max: number): Promise<number> {
    // Swap if min > max
    let minVal = min;
    let maxVal = max;
    if (minVal > maxVal) {
      const temp = minVal;
      minVal = maxVal;
      maxVal = temp;
    }

    const range = maxVal - minVal + 1;
    if (range <= 0) {
      return minVal;
    }

    // Calculate how many bytes are needed to cover the range
    let bytesNeeded = 1;
    let maxValue = 256;
    while (maxValue < range) {
      bytesNeeded++;
      maxValue *= 256;
    }

    // Generate random bytes
    const randomBytes = await RandomUtils.generateRandomBytes(bytesNeeded);

    // Convert bytes to a number
    let randomValue = 0;
    for (let i = 0; i < randomBytes.length; i++) {
      randomValue = (randomValue << 8) | randomBytes[i];
    }

    // Ensure positive number
    randomValue = Math.abs(randomValue);

    // Modulo operation to fit within range
    const result = minVal + (randomValue % range);

    return result;
  }

  /**
   * Synchronous version - generates random number using sync API
   * @param min Minimum value (inclusive)
   * @param max Maximum value (inclusive)
   * @returns Random integer between min and max
   * @throws Error if random generation fails
   */
  static getRandomIntSync(min: number, max: number): number {
    // Swap if min > max
    let minVal = min;
    let maxVal = max;
    if (minVal > maxVal) {
      const temp = minVal;
      minVal = maxVal;
      maxVal = temp;
    }

    const range = maxVal - minVal + 1;
    if (range <= 0) {
      return minVal;
    }

    // Calculate how many bytes are needed to cover the range
    let bytesNeeded = 1;
    let maxValue = 256;
    while (maxValue < range) {
      bytesNeeded++;
      maxValue *= 256;
    }

    // Generate random bytes synchronously
    const randomData = RandomUtils.generateRandomBytesSync(bytesNeeded);

    // Convert bytes to a number
    let randomValue = 0;
    for (let i = 0; i < randomData.length; i++) {
      randomValue = (randomValue << 8) | randomData[i];
    }

    // Ensure positive number
    randomValue = Math.abs(randomValue);

    // Modulo operation to fit within range
    const result = minVal + (randomValue % range);

    return result;
  }

  /**
   * Generate cryptographically secure random bytes
   * @param length Number of bytes to generate (1 to INT_MAX)
   * @returns Promise<Uint8Array> of random bytes
   */
  static async generateRandomBytes(length: number): Promise<Uint8Array> {
    if (length <= 0 || length > Number.MAX_SAFE_INTEGER) {
      throw new Error('Invalid length for random bytes generation');
    }

    const rand = await RandomUtils.getRandomInstance();
    const randOutput = await rand.generateRandom(length);
    return randOutput.data;
  }

  /**
   * Generate random bytes synchronously
   * @param length Number of bytes to generate (1 to INT_MAX)
   * @returns Uint8Array of random bytes
   * @throws Error if random generation fails
   */
  static generateRandomBytesSync(length: number): Uint8Array {
    if (length <= 0 || length > Number.MAX_SAFE_INTEGER) {
      throw new Error('Invalid length for random bytes generation');
    }

    const rand = cryptoFramework.createRandom();
    const randData = rand.generateRandomSync(length);
    if (randData.data.length === 0) {
      throw new Error('Failed to generate random bytes');
    }
    return randData.data;
  }

  /**
   * Generate a random number within range [0, max)
   * @param max Upper bound (exclusive)
   * @returns Promise<number> Random number between 0 and max-1
   */
  static async getRandom(max: number): Promise<number> {
    if (max <= 0) {
      throw new Error('Max must be greater than 0');
    }
    return await RandomUtils.getRandomInt(0, max - 1);
  }

  /**
   * Synchronous version of getRandom
   * @param max Upper bound (exclusive)
   * @returns Random number between 0 and max-1
   * @throws Error if random generation fails
   */
  static getRandomSync(max: number): number {
    if (max <= 0) {
      throw new Error('Max must be greater than 0');
    }
    return RandomUtils.getRandomIntSync(0, max - 1);
  }

  /**
   * Generate a random boolean value
   * @returns Promise<boolean> Random true/false
   */
  static async getRandomBoolean(): Promise<boolean> {
    const randomByte = await RandomUtils.generateRandomBytes(1);
    return (randomByte[0] & 1) === 1;
  }

  /**
   * Synchronous version of getRandomBoolean
   * @returns Random boolean value
   */
  static getRandomBooleanSync(): boolean {
    const randomByte = RandomUtils.generateRandomBytesSync(1);
    return (randomByte[0] & 1) === 1;
  }

  /**
   * Generate a random number between 0 and 1 (exclusive)
   * @returns Promise<number> Random float between 0 and 1
   */
  static async getRandomFloat(): Promise<number> {
    const randomBytes = await RandomUtils.generateRandomBytes(8);
    let value = 0;
    for (let i = 0; i < randomBytes.length; i++) {
      value = (value << 8) | randomBytes[i];
    }
    value = Math.abs(value);
    return (value % 1000000) / 1000000;
  }

  /**
   * Synchronous version of getRandomFloat
   * @returns Random float between 0 and 1
   */
  static getRandomFloatSync(): number {
    const randomBytes = RandomUtils.generateRandomBytesSync(8);
    let value = 0;
    for (let i = 0; i < randomBytes.length; i++) {
      value = (value << 8) | randomBytes[i];
    }
    value = Math.abs(value);
    return (value % 1000000) / 1000000;
  }
}