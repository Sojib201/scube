import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<LoadDashboardData>(_onLoadDashboard);
  }

  Future<void> _onLoadDashboard(
      LoadDashboardData event,
      Emitter<DashboardState> emit,
      ) async {
    emit(DashboardLoading());

    await Future.delayed(const Duration(seconds: 1));

    final sources = List.generate(
      6, (index) => SourceItem(
        name: 'Source ${index + 1}',
        value: (index + 1) * 250,
      ),
    );

    if (sources.isEmpty) {
      emit(DashboardEmpty());
    } else {
      emit(
        DashboardLoaded(
          todayTotal: 1250,
          monthTotal: 32450,
          sources: sources,
        ),
      );
    }
  }
}
