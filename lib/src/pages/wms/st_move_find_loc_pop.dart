import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/components/common_data_table.dart';
import 'package:flutter_clone_instagram/src/controller/api_service.dart';

class StMoveFindLocPop extends StatefulWidget {
  final String refVal1;

  const StMoveFindLocPop({super.key, required this.refVal1});

  @override
  State<StMoveFindLocPop> createState() => _StMoveFindLocPopState();
}

class _StMoveFindLocPopState extends State<StMoveFindLocPop> {
  List<Map<String, dynamic>> _data = []; // 데이터

  @override
  void initState() {
    super.initState();
    _searchStMoveFindLocPop();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 검색
  Future<void> _searchStMoveFindLocPop() async {
    String url = '/api/wmsapp/st/stockMove/selectStMoveLocPop';

    var result = await ApiService.sendApi(context, url, {'refVal1': widget.refVal1});
    setState(() {
      if (result != null) _data = List<Map<String, dynamic>>.from(result['data']);
    });
  }

  // 그리드
  Widget _dataTable() {
    return CommonDataTable(
      data: _data,
      headerName: ['존', '로케이션'],
      rowDataValue: ['zoneNm', 'locCd'],
      onLongPress: (item) {
        Navigator.pop(context, {'locCd': item['locCd']});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // 그림자 제거
        title: const Text(
          '로케이션 찾기',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _dataTable(),
          ],
        ),
      ),
    );
  }
}
