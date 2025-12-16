abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final int todayTotal;
  final int monthTotal;
  final List<SourceItem> sources;

  DashboardLoaded({
    required this.todayTotal,
    required this.monthTotal,
    required this.sources,
  });
}

class DashboardEmpty extends DashboardState {}

class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
}

// Model
class SourceItem {
  final String name;
  final int value;

  SourceItem({required this.name, required this.value});
}
