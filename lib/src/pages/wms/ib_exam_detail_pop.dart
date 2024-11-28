import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/controller/api_service.dart';

class IbExamDetailPop extends StatefulWidget{
  final dynamic item; // You can change the type of item as needed

  const IbExamDetailPop({super.key, required this.item});

  @override
  State<IbExamDetailPop> createState() => _IbExamDetailPopState();
}

class _IbExamDetailPopState extends State<IbExamDetailPop> {
  //입고상세 폼
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
                  const SizedBox(width: 100, child: Text('순번'),),
                  const SizedBox(width: 10,),
                  Expanded(child: Text('${widget.item['ibDetailSeq']}')),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  const SizedBox(width: 100, child: Text('진행상태'),),
                  const SizedBox(width: 10,),
                  Expanded(child: Text('${widget.item['ibProgStCd']}')),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  const SizedBox(width: 100, child: Text('상품'),),
                  const SizedBox(width: 10,),
                  Expanded(child: Text('${widget.item['pdaItemNm']}')),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  const SizedBox(width: 100, child: Text('입수'),),
                  const SizedBox(width: 10,),
                  Expanded(child: Text('${widget.item['pkqty']}')),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  const SizedBox(width: 100, child: Text('예정수량\n(Box/Ea)'),),
                  const SizedBox(width: 10,),
                  Expanded(child: Text('${widget.item['pdaPlanQty']}')),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  const SizedBox(width: 100, child: Text('검수수량\n(Box/Ea)'),),
                  const SizedBox(width: 10,),
                  Expanded(
                    child: TextFormField(
                      initialValue: '${widget.item['pdaExamBoxQty']}',
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Box',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                      setState(() {
                        widget.item['pdaExamBoxQty'] = int.tryParse(value) ?? 0;
                      });
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      initialValue: '${widget.item['pdaExamEaQty']}',
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'EA',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                      setState(() {
                        widget.item['pdaExamEaQty'] = int.tryParse(value) ?? 0;
                      });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
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
            child: const Text('입고검수'),
          ),
        ],
      ),
    );
  }

  //검수완료
  Future<void> _examConfirm() async {
    
    String url = '/api/wmsapp/ib/inboundExam/saveIbExamDetailCompl';
    widget.item['examBoxQty'] = widget.item['pdaExamBoxQty'];
    widget.item['examEaQty'] = widget.item['pdaExamEaQty'];
    widget.item['examTotQty'] = widget.item['pdaExamBoxQty'] * widget.item['pkqty'] + widget.item['pdaExamEaQty'];
    var result = await ApiService.sendApi(context, url, {
      'data' : [widget.item]
    });

    if(result == null){
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.item);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, //그림자 제거
        title: const Text(
          '입고검수상세',
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
            _form(),
            _button(),
          ],
        ),
      ),
      // Use the item variable here
    );
  }
}