import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/components/common_data_table.dart';
import 'package:flutter_clone_instagram/src/controller/api_service.dart';

import 'ib_putw_pop.dart';

class IbPutw extends StatefulWidget{
  const IbPutw({super.key});

  @override
  State<IbPutw> createState() => _IbPutwState();
}

class _IbPutwState extends State<IbPutw> {
  final TextEditingController _workYmdController = TextEditingController();

  List<Map<String, dynamic>> _data = []; //데이터

  @override
  void initState() {
    super.initState();
    _workYmdController.text = '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
  }

  @override
  void dispose() {
    _workYmdController.dispose();
    super.dispose();
  }

  // 검색
  Future<void> _searchIbPutw() async {
    String workYmd = _workYmdController.text.replaceAll('-', '');
    String url = '/api/wmsapp/st/stockMove/selectStMoveList';

    var result = await ApiService.sendApi(context, url, {'refVal1': 'IB', 'workYmd': workYmd});
    setState(
      () {
        if (result != null) _data = List<Map<String, dynamic>>.from(result['data']);
      }
    );
  }

  
  //프로필 정보
  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: '작업일자',
              suffixIcon: Icon(Icons.calendar_today),
            ),
            readOnly: true,
            controller: _workYmdController,
            onTap: () async {
                DateTime initialDate = DateTime.now();
                if (_workYmdController.text.isNotEmpty) {
                initialDate = DateTime.parse(_workYmdController.text);
                }

                DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: initialDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
                // locale: const Locale('ko', 'KR'),
                );
                if (pickedDate != null) {
                var dateStr = '${pickedDate.year}-${pickedDate.month}-${pickedDate.day}';
                _workYmdController.text = dateStr;
                }
            },
          )
        ],
      ),
    );
  }


  //버튼
  Widget _button() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              // Handle the search action
              _searchIbPutw();
            },
            child: const Text('조회'),
          ),
        ],
      ),
    );
  }


  //그리드
  Widget _dataTable() {
    return CommonDataTable(
      data: _data, 
      headerName: ['이동번호','창고','작업일','이동구분','이동상태'], 
      rowDataValue: ['moveNo','dcNm','workYmd','moveGbnNm','workStNm'], 
      onLongPress: (item) {
        //재고이동상세로 이동, 팝업이 닫히면 재조회
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IbPutwPop(
              item: item,
            ),
          ),
        ).then((_) {
          _searchIbPutw();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, //그림자 제거
        title: const Text(
          '입고적치',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          )
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _searchBar(),
            _button(),
            _dataTable(),
          ],
        ),
      ),
    );
  }


}