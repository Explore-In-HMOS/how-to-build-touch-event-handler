@Component
export struct MetricsCard {
  @Prop title: Resource;
  @Prop value: string;

  build() {
    Column({ space: 4 }) {
      Text(this.title)
        .fontSize(10)
        .fontColor($r('app.color.title_color'));
      Text(this.value)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White);
    }
    .width(90)
    .padding(10)
    .backgroundColor($r('app.color.metrics_card_bg'))
    .borderRadius(16);
  }
}