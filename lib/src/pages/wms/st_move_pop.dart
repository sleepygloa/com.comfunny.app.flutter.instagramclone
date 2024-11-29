import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/components/common_data_table.dart';
import 'package:flutter_clone_instagram/src/controller/api_service.dart';
import 'package:flutter_clone_instagram/src/pages/wms/st_move_detail_pop.dart';

import 'ib_putw_detail_pop.dart';

class StMovePop extends StatefulWidget {
  final dynamic item; // You can change the type of item as needed
  final String refVal1; // Add refVal1 parameter

  const StMovePop({super.key, required this.item, required this.refVal1});

  @override
  State<StMovePop> createState() => _StMovePopState();
}

class _StMovePopState extends State<StMovePop> {

  List<Map<String, dynamic>> _dataDetail = []; //데이터

  // 검색
  Future<void> _searchIbExam(item) async {
    // API 호출 시뮬레이션
    await Future.delayed(Duration(seconds: 2));

    String url = '/api/wmsapp/st/stockMove/selectStMoveDetailList';

    var result = await ApiService.sendApi(context, url, {
      'moveNo': item['moveNo'],
      'workYmd': item['workYmd'],
      'refVal1': widget.refVal1, // Use refVal1 in the API call
    });
    setState(
      () {
        if (result != null) _dataDetail = List<Map<String, dynamic>>.from(result['data']);
      }
    );
  }

  @override
  void initState() {
    super.initState();
    _searchIbExam(widget.item);
  }

  //재고이동마스터 폼
  Widget _form(){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const SizedBox(width: 100, child: Text('이동번호'),),
                  const SizedBox(width: 10,),
                  Expanded(child: Text('${widget.item['moveNo']}')),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  const SizedBox(width: 100, child: Text('작업일'),),
                  const SizedBox(width: 10,),
                  Expanded(child: Text('${widget.item['workYmd']}')),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  const SizedBox(width: 100, child: Text('물류창고'),),
                  const SizedBox(width: 10,),
                  Expanded(child: Text('${widget.item['dcNm']}')),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  const SizedBox(width: 100, child: Text('이동구분'),),
                  const SizedBox(width: 10,),
                  Expanded(child: Text('${widget.item['moveGbnNm']}')),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  const SizedBox(width: 100, child: Text('이동상태'),),
                  const SizedBox(width: 10,),
                  Expanded(child: Text('${widget.item['workStNm']}')),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  //재고이동상세 데이터테이블
  Widget _dataTable(){
    return CommonDataTable(
      data: _dataDetail, 
      headerName: ['이동번호','순번', '작업상태', '상품', '상태', '지시수량', '확정수량'], 
      rowDataValue: ['moveNo','moveDetailSeq', 'workStNm','pdaItemNm', 'itemStNm', 'pdaInstQty', 'pdaConfQty'], 
      onLongPress: (item) {
        //작업완료가 아닌경우
        if(item['workStCd'] != '10') {
          return;
        }

        //재고이동상세 팝업
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StMoveDetailPop(
              item: item, refVal1: widget.refVal1,
            ),
          ),
        ).then((_) {
          _searchIbExam(widget.item);
        });
      },
    );
  }

  //버튼
  Widget _button(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              _examConfirm();
            },
            child: const Text('작업완료'),
          ),
        ],
      ),
    );
  }

  //이동상세
  Future<void> _examConfirm() async {
    String url = '/api/wmsapp/st/stockMove/saveStMoveConfirm';
    var result = await ApiService.sendApi(context, url, {
      ...widget.item,
      'refVal1': widget.refVal1, // Include refVal1 in the API call
    });

    if(result == null){
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, //그림자 제거
        title: const Text(
          '재고이동상세',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          )
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _searchIbExam(widget.item);
        },
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _form(),
              _dataTable(),
              _button(),
            ],
          ),
        ),
      ),
      // Use the item variable here
    );
  }
}