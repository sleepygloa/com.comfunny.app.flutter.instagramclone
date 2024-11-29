import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/components/common_data_table.dart';
import 'package:flutter_clone_instagram/src/controller/api_service.dart';

class StStockInq extends StatefulWidget {

  const StStockInq({super.key});

  @override
  State<StStockInq> createState() => _StStockInqState();
}

class _StStockInqState extends State<StStockInq> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _itemController = TextEditingController();

  List<Map<String, dynamic>> _data = []; //데이터

  @override
  void initState() {
    super.initState();
    _searchStStockInq();
  }

  @override
  void dispose() {
    _locationController.dispose();
    _itemController.dispose();
    super.dispose();
  }

  // 검색
  Future<void> _searchStStockInq() async {
    String url = '/api/wmsapp/st/stockInq/selectStStockInqList';
    Map<String, dynamic> params = {
      'locCd': _locationController.text,
      'itemCd': _itemController.text,
    };
    print(params);

    var result = await ApiService.sendApi(context, url, params);
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
              Row(
                children: [
                  const SizedBox(width: 100, child: Text('로케이션'),),
                  const SizedBox(width: 10,),
                  Expanded(
                    child: TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '로케이션',
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  const SizedBox(width: 100, child: Text('상품'),),
                  const SizedBox(width: 10,),
                  Expanded(
                    child: TextFormField(
                      controller: _itemController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '상품',
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ],
              ),
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
              _searchStStockInq();
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
      headerName: ['창고','존','LOC','상품','재고수량','입고수량','출고수량','보류수량', '가용수량'], 
      rowDataValue: ['dcNm','zoneNm','locCd','itemNm','stockQty','ibPlanQty','obPlanQty','holdQty', 'canStockQty'], 
      onLongPress: (item) {
        // //재고이동상세로 이동, 팝업이 닫히면 재조회
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => StStockInqPop(
        //       item: item, refVal1: widget.refVal1,
        //     ),
        //   ),
        // ).then((_) {
        //   _searchStStockInq();
        // });
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, //그림자 제거
        title: Text(
          '재고조회',
          style: const TextStyle(
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
