import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

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

  // Helper to create mock Data View list
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

  // Helper to create mock Revenue View list (Screen 2/3 data)
  List<DetailData> _getMockRevenueList() {
    // Note: Data in Screen 2/3 shows the same Cost and Data values for all 4 items
    return [
      DetailData(
        title: 'Data 1',
        dataValue: '2798.50',
        costValue: '35689',
        percentage: '20.53%',
        color: AppColors.red, // Mock color
      ),
      DetailData(
        title: 'Data 2',
        dataValue: '2798.50',
        costValue: '35689',
        percentage: '20.53%',
        color: AppColors.grey, // Mock color
      ),
      DetailData(
        title: 'Data 3',
        dataValue: '2798.50',
        costValue: '35689',
        percentage: '20.53%',
        color: AppColors.yellow, // Mock color
      ),
      DetailData(
        title: 'Data 4',
        dataValue: '2798.50',
        costValue: '35689',
        percentage: '20.53%',
        color: AppColors.primary, // Mock color
      ),
    ];
  }


  void _onLoadDetailData(LoadDetailData event, Emitter<DetailViewState> emit) async {
    emit(DetailViewLoading());
    await Future.delayed(const Duration(milliseconds: 500));

    // Default Data View blocks (Screen 1)
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
      String newDateType = 'Today Data'; // Revenue View always resets to Today Data

      if (event.view == 'Data View') {
        newCircularValue = '55.00';
        newCircularUnit = 'kWh/Sqft';
        newChartBlocks = [
          ChartDataBlock(mainValue: '5.53', title: 'Energy Chart', detailList: _getMockDataList()),
        ];

      } else { // Revenue View (Screen 2/3)
        newCircularValue = '8897455';
        newCircularUnit = 'tk';
        newChartBlocks = [
          // Revenue View starts expanded (Screen 2)
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

        // Mock data for Screen 4 (Two data blocks)
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
        // Reset to Today Data / Data View (Screen 1 default)
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
      // Create a mutable copy of the list
      final List<ChartDataBlock> updatedBlocks = List.from(currentState.chartBlocks);

      if (event.blockIndex >= 0 && event.blockIndex < updatedBlocks.length) {
        final currentBlock = updatedBlocks[event.blockIndex];
        // Toggle the isExpanded state for the specific block
        updatedBlocks[event.blockIndex] = currentBlock.copyWith(
          isExpanded: !currentBlock.isExpanded,
        );

        emit(currentState.copyWith(chartBlocks: updatedBlocks));
      }
    }
  }
}