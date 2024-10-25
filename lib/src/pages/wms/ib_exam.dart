import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/components/common_data_table.dart';
import 'package:flutter_clone_instagram/src/controller/api_service.dart';
import 'package:flutter_clone_instagram/src/pages/wms/ib_exam_pop.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class IbExam extends StatefulWidget{
  const IbExam({Key? key}) : super(key: key);

  @override
  State<IbExam> createState() => _IbExamState();
}

class _IbExamState extends State<IbExam> {
  final TextEditingController _ibPlanYmdController = TextEditingController();

  List<Map<String, dynamic>> _data = []; //데이터

  @override
  void initState() {
    super.initState();
    _ibPlanYmdController.text = '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
  }

  @override
  void dispose() {
    _ibPlanYmdController.dispose();
    super.dispose();
  }

  // 검색
  Future<void> _searchIbExam() async {
    String ibPlanYmd = _ibPlanYmdController.text.replaceAll('-', '');
    String url = '/wms/ib/inboundExam/selectInboundExamList';

    var result = await ApiService.sendApi(context, url, {'ibPlanYmd': ibPlanYmd});
    setState(
      () {
        _data = List<Map<String, dynamic>>.from(result!['data']);
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
              hintText: '입고예정일',
              suffixIcon: Icon(Icons.calendar_today),
            ),
            readOnly: true,
            controller: _ibPlanYmdController,
            onTap: () async {
                DateTime initialDate = DateTime.now();
                if (_ibPlanYmdController.text.isNotEmpty) {
                initialDate = DateTime.parse(_ibPlanYmdController.text);
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
                _ibPlanYmdController.text = dateStr;
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
              _searchIbExam();
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
      headerName: ['입고번호','창고','고객사','공급처','입고예정일'], 
      rowDataValue: ['ibNo','dcNm','clientNm','supplierNm','ibPlanYmd'], 
      onLongPress: (item) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IbExamPop(
              item: item,
            ),
          ),
        );
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
          '입고검수',
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