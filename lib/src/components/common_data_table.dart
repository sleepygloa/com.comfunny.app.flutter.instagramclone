import 'package:flutter/material.dart';

class CommonDataTable extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final List<String> headerName;
  final List<String> rowDataValue;
  final Function onLongPress;
  final Function? onSelectChanged;

  const CommonDataTable({
    super.key,
    required this.data,
    required this.headerName,
    required this.rowDataValue,
    required this.onLongPress,
    this.onSelectChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, //가로 스크롤
      child: DataTable(
        columns: 
          headerName.map((e) => DataColumn(label: Text(e))).toList(),
          rows: data.map((item) {
            return DataRow(
              cells: 
                rowDataValue.map((e) {
                  final value = item[e];
                  return DataCell(Text(value != null ? value.toString() : ''));
                }).toList(),
                onLongPress: () => onLongPress(item),
                onSelectChanged: onSelectChanged != null ? (selected) => onSelectChanged!(item, selected) : null, // 선택이 변경될 때 호출 (null 체크)
            );
          }).toList(),
      ),
    );
  }
}
