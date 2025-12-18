abstract class DetailViewEvent {
  const DetailViewEvent();
}

class LoadDetailData extends DetailViewEvent {}

class ToggleView extends DetailViewEvent {
  final String view;
  ToggleView(this.view);
}

class ToggleDateType extends DetailViewEvent {
  final String dateType;
  ToggleDateType(this.dateType);
}

class LoadCustomDateData extends DetailViewEvent {
  final DateTime startDate;
  final DateTime endDate;
  LoadCustomDateData(this.startDate, this.endDate);
}

class ToggleChartExpand extends DetailViewEvent {
  final int blockIndex;
  ToggleChartExpand(this.blockIndex);
}
