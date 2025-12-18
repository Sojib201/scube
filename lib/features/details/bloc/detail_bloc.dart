import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import 'detail_event.dart';
import 'detail_state.dart';

class DetailViewBloc extends Bloc<DetailViewEvent, DetailViewState> {
  DetailViewBloc() : super(DetailViewInitial()) {
    on<LoadDetailData>(_onLoadDetailData);
    on<ToggleView>(_onToggleView);
    on<ToggleDateType>(_onToggleDateType);
    on<ToggleChartExpand>(_onToggleChartExpand);
  }

  List<DetailData> _getMockDataList() {
    return [
      DetailData(
        title: 'Data A',
        dataValue: '2798.50',
        costValue: '35689',
        percentage: '29.53%',
        color: AppColors.primary,
      ),
      DetailData(
        title: 'Data B',
        dataValue: '72598.50',
        costValue: '5259689',
        percentage: '35.39%',
        color: AppColors.orange,
      ),
      DetailData(
        title: 'Data C',
        dataValue: '6598.36',
        costValue: '5698756',
        percentage: '83.90%',
        color: AppColors.purple,
      ),
      DetailData(
        title: 'Data D',
        dataValue: '6598.26',
        costValue: '356987',
        percentage: '36.59%',
        color: AppColors.cyan,
      ),
    ];
  }

  List<DetailData> _getMockRevenueList() {
    return [
      DetailData(
        title: 'Data 1',
        dataValue: '2798.50',
        costValue: '35689',
        percentage: '20.53%',
        color: AppColors.red,
      ),
      DetailData(
        title: 'Data 2',
        dataValue: '2798.50',
        costValue: '35689',
        percentage: '20.53%',
        color: AppColors.grey,
      ),
      DetailData(
        title: 'Data 3',
        dataValue: '2798.50',
        costValue: '35689',
        percentage: '20.53%',
        color: AppColors.yellow,
      ),
      DetailData(
        title: 'Data 4',
        dataValue: '2798.50',
        costValue: '35689',
        percentage: '20.53%',
        color: AppColors.primary,
      ),
    ];
  }


  void _onLoadDetailData(LoadDetailData event, Emitter<DetailViewState> emit) async {
    emit(DetailViewLoading());
    await Future.delayed(const Duration(milliseconds: 500));

    final dataBlocks = [
      ChartDataBlock(
        mainValue: '5.53',
        title: 'Energy Chart',
        detailList: _getMockDataList(),
        isExpanded: true,
      ),
    ];

    emit(DetailViewLoaded(
      activeView: 'Data View',
      activeDateType: 'Today Data',
      circularChartValue: '55.00',
      circularChartUnit: 'kWh/Sqft',
      chartBlocks: dataBlocks,
    ));
  }

  void _onToggleView(ToggleView event, Emitter<DetailViewState> emit) {
    final currentState = state;
    if (currentState is DetailViewLoaded) {
      String newCircularValue;
      String newCircularUnit;
      List<ChartDataBlock> newChartBlocks;
      String newDateType = 'Today Data';

      if (event.view == 'Data View') {
        newCircularValue = '55.00';
        newCircularUnit = 'kWh/Sqft';
        newChartBlocks = [
          ChartDataBlock(mainValue: '5.53', title: 'Energy Chart', detailList: _getMockDataList()),
        ];

      } else {
        newCircularValue = '8897455';
        newCircularUnit = 'tk';
        newChartBlocks = [
          ChartDataBlock(mainValue: '8897455', title: 'Data & Cost Info', detailList: _getMockRevenueList(), isExpanded: true),
        ];
      }

      emit(currentState.copyWith(
        activeView: event.view,
        activeDateType: newDateType,
        circularChartValue: newCircularValue,
        circularChartUnit: newCircularUnit,
        chartBlocks: newChartBlocks,
      ));
    }
  }

  void _onToggleDateType(ToggleDateType event, Emitter<DetailViewState> emit) async {
    final currentState = state;
    if (currentState is DetailViewLoaded) {
      if (event.dateType == 'Custom Date Data' && currentState.activeView == 'Data View') {

        final customDataBlocks = [
          ChartDataBlock(mainValue: '20.05', title: 'Energy Chart', detailList: _getMockDataList(), isExpanded: true),
          ChartDataBlock(mainValue: '5.53', title: 'Energy Chart', detailList: _getMockDataList(), isExpanded: true),
        ];

        emit(currentState.copyWith(
          activeDateType: event.dateType,
          circularChartValue: '57.00',
          circularChartUnit: 'kWh/Sqft',
          chartBlocks: customDataBlocks,
        ));
      } else {
        final defaultDataBlocks = [
          ChartDataBlock(mainValue: '5.53', title: 'Energy Chart', detailList: _getMockDataList(), isExpanded: true),
        ];

        emit(currentState.copyWith(
          activeDateType: 'Today Data',
          circularChartValue: '55.00',
          chartBlocks: defaultDataBlocks,
        ));
      }
    }
  }

  void _onToggleChartExpand(ToggleChartExpand event, Emitter<DetailViewState> emit) {
    final currentState = state;
    if (currentState is DetailViewLoaded) {
      final List<ChartDataBlock> updatedBlocks = List.from(currentState.chartBlocks);

      if (event.blockIndex >= 0 && event.blockIndex < updatedBlocks.length) {
        final currentBlock = updatedBlocks[event.blockIndex];
        updatedBlocks[event.blockIndex] = currentBlock.copyWith(
          isExpanded: !currentBlock.isExpanded,
        );

        emit(currentState.copyWith(chartBlocks: updatedBlocks));
      }
    }
  }
}