import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clone_instagram/src/components/common_data_table.dart';
import 'package:flutter_clone_instagram/src/controller/api_service.dart';
import 'package:flutter_clone_instagram/src/pages/wms/ib_exam_detail_pop.dart';

class IbExamPop extends StatefulWidget {
  final dynamic item; // You can change the type of item as needed

  const IbExamPop({Key? key, required this.item}) : super(key: key);

  @override
  State<IbExamPop> createState() => _IbExamPopState();
}

class _IbExamPopState extends State<IbExamPop> {

  List<Map<String, dynamic>> _dataDetail = []; //데이터

    // 검색
  Future<void> _searchIbExam(item) async {
    // API 호출 시뮬레이션
    await Future.delayed(Duration(seconds: 2));

    String url = '/wms/ib/inboundExam/selectInboundExamDetailList';

    var result = await ApiService.sendApi(context, url, {
      'ibNo': item['ibNo'],
      'ibPlanYmd': item['ibPlanYmd'],
    });
    setState(
      () {
        _dataDetail = List<Map<String, dynamic>>.from(result!['data']);
      }
    );
  }

  @override
  void initState() {
    super.initState();
    _searchIbExam(widget.item);
  }

  //입고마스터 폼
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
                  const SizedBox(width: 100, child: Text('입고번호'),),
                  const SizedBox(width: 10,),
                  Expanded(child: Text('${widget.item['ibNo']}')),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  const SizedBox(width: 100, child: Text('입고예정일'),),
                  const SizedBox(width: 10,),
                  Expanded(child: Text('${widget.item['ibPlanYmd']}')),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  const SizedBox(width: 100, child: Text('입고구분'),),
                  const SizedBox(width: 10,),
                  Expanded(child: Text('${widget.item['ibGbnNm']}')),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  const SizedBox(width: 100, child: Text('입고상태'),),
                  const SizedBox(width: 10,),
                  Expanded(child: Text('${widget.item['ibProgStNm']}')),
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
                  const SizedBox(width: 100, child: Text('고객사'),),
                  const SizedBox(width: 10,),
                  Expanded(child: Text('${widget.item['clientNm']}')),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  const SizedBox(width: 100, child: Text('공급처'),),
                  const SizedBox(width: 10,),
                  Expanded(child: Text('${widget.item['supplierNm']}')),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  //입고상세 데이터테이블
  Widget _dataTable(){
    return CommonDataTable(
      data: _dataDetail, 
      headerName: ['입고번호','순번', '진행상태', '상품', '상태', '예정수량', '검수수량'], 
      rowDataValue: ['ibNo','ibDetailSeq', 'ibProgStNm','pdaItemNm', 'itemStNm', 'pdaPlanQty', 'pdaExamQty'], 
      onLongPress: (item) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IbExamDetailPop(
              item: item,
            ),
          ),
        );
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
            child: const Text('검수완료'),
          ),
        ],
      ),
    );
  }

  //검수완료
  Future<void> _examConfirm() async {
    String url = '/wms/ib/inboundExam/saveInboundExam';
    var result = await ApiService.sendApi(context, url, widget.item);

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
          '입고검수',
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