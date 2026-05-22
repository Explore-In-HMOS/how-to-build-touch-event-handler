import { CalibrationTarget } from '../components/CalibrationTarget';
import { MetricsCard } from '../components/MetricsCard';
import { PrecisionUtils } from '../common/utils/PrecisionUtils';
import { RandomUtils } from '../common/utils/RandomUtils';

@Entry
@Component
struct Index {
  private scroller: Scroller = new Scroller();
  private readonly PLAYGROUND_SIZE: number = 220;
  private readonly TARGET_SIZE: number = 48;
  private readonly SAFE_PADDING: number = 36;
  @State targetX: number = 100;
  @State targetY: number = 100;
  @State eventText: string = 'Waiting interaction';
  @State accuracy: number = 0;
  @State totalTouches: number = 0;
  @State successfulTouches: number = 0;
  // Interaction Module Toggles
  @State clickEnabled: boolean = true;
  @State touchEnabled: boolean = true;
  @State hoverEnabled: boolean = true;
  @State feedbackEnabled: boolean = true;

  build() {
    Scroll(this.scroller) {
      Column({ space: 12 }) {
        // Header
        Column({ space: 4 }) {
          Text($r('app.string.touch_lab_title'))
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White);
          Text($r('app.string.wearable_precision_subtitle'))
            .fontSize(11)
            .fontColor($r('app.color.title_color'));
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
        .margin({ top: 12 });

        // Metrics
        Row({ space: 10 }) {
          MetricsCard({
            title: $r('app.string.metric_touches'),
            value: `${this.totalTouches}`
          });
          MetricsCard({
            title: $r('app.string.metric_success'),
            value: `${this.successfulTouches}`
          });
        }
        .justifyContent(FlexAlign.Center)
        .width('100%');

        // Calibration Zone
        Column({ space: 10 }) {
          Text($r('app.string.calibration_zone'))
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White);
          Stack() {
            // Circular Playground
            Circle()
              .width(this.PLAYGROUND_SIZE)
              .height(this.PLAYGROUND_SIZE)
              .fill($r('app.color.playground_bg'))
              .stroke($r('app.color.accent_blue'));
            // Center Crosshair Vertical
            Column() {
            }
            .width(1)
            .height(70)
            .backgroundColor($r('app.color.crosshair'));

            // Center Crosshair Horizontal
            Row() {
            }
            .width(70)
            .height(1)
            .backgroundColor($r('app.color.crosshair'));

            // Target
            CalibrationTarget({
              x: this.targetX,
              y: this.targetY,
              feedbackEnabled: this.feedbackEnabled,
                onTargetClick: (
                x?: number,
                y?: number
              ) => {
                if (!this.clickEnabled) {
                  return;
                }
                this.handleTargetClick(x, y);
              },
              onTouchState: (
                state: string
              ) => {
                if (!this.touchEnabled) {
                  return;
                }
                this.eventText = state;
              },
              onHoverState: (
                hovering: boolean
              ) => {
                if (!this.hoverEnabled) {
                  return;
                }
                this.eventText =
                  hovering
                    ? 'Hover Enter'
                    : 'Hover Exit';
              }
            });
            // Floating Event HUD
            Column({ space: 2 }) {
              Text(this.eventText)
                .fontSize(10)
                .fontColor(Color.White)
                .maxLines(1);
                  Text(`${this.accuracy.toFixed(0)}%`)
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.success_green'));
            }
            .padding({
              left: 10,
              right: 10,
              top: 6,
              bottom: 6
            })
            .backgroundColor($r('app.color.hud_overlay'))
            .borderRadius(14)
            .position({
              x: 55,
              y: 8
            });
          }
          .width(this.PLAYGROUND_SIZE)
          .height(this.PLAYGROUND_SIZE);
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
        .padding(8)
        .backgroundColor($r('app.color.surface_dark'))
        .borderRadius(20);

        // Interaction Modules
        Column({ space: 8 }) {
          Text($r('app.string.interaction_modules'))
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White);
          this.buildFeatureToggle(
            $r('app.string.click_event'),
            this.clickEnabled,
            () => {
              this.clickEnabled =
                !this.clickEnabled;
            }
          );
          this.buildFeatureToggle(
            $r('app.string.touch_event'),
            this.touchEnabled,
            () => {
              this.touchEnabled =
                !this.touchEnabled;
            }
          );
          this.buildFeatureToggle(
            $r('app.string.hover_event'),
            this.hoverEnabled,
            () => {
              this.hoverEnabled =
                !this.hoverEnabled;
            }
          );
          this.buildFeatureToggle(
            $r('app.string.feedback_fx'),
            this.feedbackEnabled,
            () => {
              this.feedbackEnabled =
                !this.feedbackEnabled;
            }
          );
        }
        .width('100%')
        .padding(12)
        .backgroundColor($r('app.color.surface_dark'))
        .borderRadius(20);

        Blank()
          .height(24);
      }
      .width('100%')
      .padding({
        top: 15,
        left: 12,
        right: 12,
        bottom: 24
      })
      .alignItems(HorizontalAlign.Center);
    }
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.Off)
    .backgroundColor(Color.Black)
    .width('100%')
    .height('100%');
  }

  @Builder
  buildFeatureToggle(
    title: Resource,
    enabled: boolean,
    action: () => void
  ) {
    Row() {
      Text(title)
        .fontSize(11)
        .fontColor(Color.White);
      Blank();
      Toggle({
        type: ToggleType.Switch,
        isOn: enabled
      })
        .scale({
          x: 0.75,
          y: 0.75
        })
        .onChange(() => {
          action();
        });
    }
    .width('100%')
    .padding(10)
    .backgroundColor($r('app.color.card_dark'))
    .borderRadius(16);
  }

  handleTargetClick(
    touchX?: number,
    touchY?: number
  ): void {
    this.totalTouches++;
    if (touchX !== undefined && touchY !== undefined) {
      const distance =
        PrecisionUtils.calculateDistance(
          this.targetX,
          this.targetY,
          touchX,
          touchY
        );
      this.accuracy =
        PrecisionUtils.calculateAccuracy(distance);
      if (this.accuracy > 70) {
        this.successfulTouches++;
      }
      this.eventText =
        `Tap (${touchX.toFixed(0)}, ${touchY.toFixed(0)})`;
    } else {
      this.accuracy = 0;
      this.eventText = 'Tap';
    }
    this.generateNextTarget();
  }

  async generateNextTarget(): Promise<void> {
    const minPos = this.SAFE_PADDING;
    const maxPos = this.PLAYGROUND_SIZE - this.TARGET_SIZE - this.SAFE_PADDING;
    try {
      let nextX = await RandomUtils.getRandomInt(minPos, maxPos);
      let nextY = await RandomUtils.getRandomInt(minPos, maxPos);
      let attempt = 0;
      const maxAttempts = 10;

      while (
        attempt < maxAttempts &&
        nextX === this.targetX &&
        nextY === this.targetY
      ) {
        nextX = await RandomUtils.getRandomInt(minPos, maxPos);
        nextY = await RandomUtils.getRandomInt(minPos, maxPos);
        attempt++;
      }

      this.targetX = nextX;
      this.targetY = nextY;
    } catch (err) {
      let msg = 'Secure RNG unavailable';
      if (err && typeof err.message === 'string') {
        msg = err.message;
      }
      this.eventText = `RNG error: ${msg}`;
      this.clickEnabled = false;
    }
  }
}