import 'package:flutter/material.dart';

class DetailData {
  final String title;
  final String dataValue;
  final String costValue;
  final String percentage;
  final Color color;

  DetailData({
    required this.title,
    required this.dataValue,
    required this.costValue,
    required this.percentage,
    required this.color,
  });
}

class ChartDataBlock {
  final String? mainValue;
  final String? title;
  final List<DetailData> detailList;
  final bool isExpanded;

  ChartDataBlock({
    this.mainValue,
    this.title,
    required this.detailList,
    this.isExpanded = true,
  });

  ChartDataBlock copyWith({bool? isExpanded}) {
    return ChartDataBlock(
      mainValue: mainValue,
      title: title,
      detailList: detailList,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}


abstract class DetailViewState {
  const DetailViewState();
}

class DetailViewInitial extends DetailViewState {}

class DetailViewLoading extends DetailViewState {}

class DetailViewLoaded extends DetailViewState {
  final String activeView;
  final String activeDateType;

  final String circularChartValue;
  final String circularChartUnit;

  final List<ChartDataBlock> chartBlocks;

  final DateTime? startDate;
  final DateTime? endDate;

  DetailViewLoaded({
    required this.activeView,
    required this.activeDateType,
    required this.circularChartValue,
    required this.circularChartUnit,
    required this.chartBlocks,
    this.startDate,
    this.endDate,
  });

  DetailViewLoaded copyWith({
    String? activeView,
    String? activeDateType,
    List<ChartDataBlock>? chartBlocks,
    String? circularChartValue,
    String? circularChartUnit,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return DetailViewLoaded(
      activeView: activeView ?? this.activeView,
      activeDateType: activeDateType ?? this.activeDateType,
      circularChartValue: circularChartValue ?? this.circularChartValue,
      circularChartUnit: circularChartUnit ?? this.circularChartUnit,
      chartBlocks: chartBlocks ?? this.chartBlocks,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}