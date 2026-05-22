@Component
export struct EventStatusPanel {
  @Prop eventText: string;
  @Prop accuracy: number;

  build() {
    Column({ space: 4 }) {
      Text(this.eventText)
        .fontSize(11)
        .fontColor(Color.White)
        .maxLines(1);
      Text($r('app.string.accuracy_label', `${this.accuracy}%`))
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.event_success_green'));
    }
    .width('100%')
    .padding(10);
  }
}