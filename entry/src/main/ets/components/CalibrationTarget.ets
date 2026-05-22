/**
 * CalibrationTarget Component
 *
 * A wearable interaction target used for demonstrating:
 * - Click Event
 * - Touch Event
 * - Hover Event
 * - Hover Effect
 * - Click Feedback Effect
 * - Hit Test Control
 *
 * This component is optimized for small circular wearable displays
 * and provides interaction feedback, coordinate tracking,
 * hover simulation, and press animations.
 */
@Component
export struct CalibrationTarget {
  /**
   * X coordinate inside calibration zone.
   */
  @Prop x: number;
  /**
   * Y coordinate inside calibration zone.
   */
  @Prop y: number;
  /**
   * Enables or disables visual feedback effects.
   */
  @Prop feedbackEnabled: boolean;
  /**
   * Callback triggered after touch release.
   */
  onTargetClick?: (
    x?: number,
    y?: number
  ) => void;
  /**
   * Callback for raw touch lifecycle updates.
   */
  onTouchState?: (
    state: string
  ) => void;
  /**
   * Callback for hover enter/exit state changes.
   */
  onHoverState?: (
    hovering: boolean
  ) => void;
  /**
   * Indicates whether target is currently pressed.
   */
  @State isPressed: boolean = false;
  /**
   * Indicates whether hover state is active.
   */
  @State isHovering: boolean = false;

  /**
   * Builds the calibration target UI.
   */
  build() {
    Stack() {
      /**
       * Interactive circular target.
       * Applies feedback effects and hover visuals.
       */
      Circle()
        .width(
          this.feedbackEnabled
            ? (this.isPressed ? 40 : 48)
            : 48
        )
        .height(
          this.feedbackEnabled
            ? (this.isPressed ? 40 : 48)
            : 48
        )
        .fill(this.isHovering ? $r('app.color.success_green') : $r('app.color.accent_blue'))
        .opacity(
          this.feedbackEnabled
            ? (this.isPressed ? 0.65 : 1.0)
            : 1.0
        )
        .shadow({
          radius: this.isHovering ? 18 : 6,
          color: this.isHovering ? $r('app.color.success_green') : $r('app.color.accent_blue')
        })/**
         * Smooth transition animation.
         */
        .animation({
          duration: 180,
          curve: Curve.EaseOut
        });
    }
    /**
     * Places target inside calibration area.
     */
    .position({
      x: this.x,
      y: this.y
    })
    /**
     * Handles wearable touch lifecycle.
     */
    .onTouch((event: TouchEvent) => {
      const touch =
        event.touches && event.touches.length > 0
          ? event.touches[0]
          : event.changedTouches && event.changedTouches.length > 0
          ? event.changedTouches[0]
          : undefined;
      if (!touch) {
        return;
      }
      const touchX =
        touch.windowX !== undefined
          ? touch.windowX
          : touch.x !== undefined
            ? touch.x
            : 0;
      const touchY =
        touch.windowY !== undefined
          ? touch.windowY
          : touch.y !== undefined
            ? touch.y
            : 0;
      switch (event.type) {
        /**
         * Touch start.
         * Activates press + hover simulation.
         */
        case TouchType.Down:
          this.isPressed = true;
          this.isHovering = true;
          this.onHoverState?.(true);
          this.onTouchState?.(
            `DOWN (${touchX.toFixed(0)}, ${touchY.toFixed(0)})`
          );
          break;
        /**
         * Finger movement tracking.
         */
        case TouchType.Move:
          this.onTouchState?.(
            `MOVE (${touchX.toFixed(0)}, ${touchY.toFixed(0)})`
          );
          break;

        /**
         * Touch release.
         * Ends hover simulation and triggers click callback.
         */
        case TouchType.Up:
          this.isPressed = false;
          this.isHovering = false;
          this.onHoverState?.(false);
          this.onTouchState?.(
            `UP (${touchX.toFixed(0)}, ${touchY.toFixed(0)})`
          );
          this.onTargetClick?.(
            touchX,
            touchY
          );
          break;
        /**
         * Touch interruption handling.
         */
        case TouchType.Cancel:
          this.isPressed = false;
          this.isHovering = false;
          this.onHoverState?.(false);
          this.onTouchState?.('CANCEL');
          break;
      }
    })
        /**
     * ArkUI hover effect.
     */
    .hoverEffect(HoverEffect.Scale)
    /**
     * Enables hit-test participation.
     */
    .hitTestBehavior(HitTestMode.Default);
  }
}