import 'package:flutter/material.dart';

// Helper class to structure data for the list items inside the chart card
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

// Helper class to structure a complete chart/details block (like 'Energy Chart' or 'Data & Cost Info')
class ChartDataBlock {
  final String? mainValue; // e.g., '5.53' or '20.05' kW / '8897455' ৳
  final String? title; // e.g., 'Energy Chart' or 'Data & Cost Info'
  final List<DetailData> detailList;
  final bool isExpanded; // NEW: To control the collapse/expand feature

  ChartDataBlock({
    this.mainValue,
    this.title,
    required this.detailList,
    this.isExpanded = true, // Default to expanded
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
  final String activeView; // 'Data View' or 'Revenue View'
  final String activeDateType; // 'Today Data' or 'Custom Date Data'

  // Overall Circular Chart values
  final String circularChartValue;
  final String circularChartUnit;

  // List of data blocks (Chart/Details Cards)
  final List<ChartDataBlock> chartBlocks;

  // For Custom Date Picker
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