import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/controller/api_service.dart';

import 'st_move_find_loc_pop.dart';

class IbPutwDetailPop extends StatefulWidget {
  final dynamic item; // You can change the type of item as needed

  const IbPutwDetailPop({super.key, required this.item});

  @override
  State<IbPutwDetailPop> createState() => _IbPutwDetailPopState();
}

class _IbPutwDetailPopState extends State<IbPutwDetailPop> {
  //재고이동상세 폼
  Widget _form() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const SizedBox(width: 100, child: Text('FR로케이션'),),
                  const SizedBox(width: 10,),
                  Expanded(child: Text('${widget.item['frLocCd']}')),
                ],
              ),
              const SizedBox(height: 10,),
                Row(
                children: [
                  const SizedBox(width: 100, child: Text('TO로케이션'),),
                  const SizedBox(width: 10,),

                  Expanded(
                  child: TextFormField(
                    controller: TextEditingController(text: '${widget.item['toLocCd']}'),
                    decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'TO로케이션',
                    ),
                    onChanged: (value) {
                    setState(() {
                      widget.item['toLocCd'] = value;
                    });
                    },
                  ),
                  ),
                  IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    //로케이션 찾기
                    Navigator.push(context, 
                    MaterialPageRoute(builder: (context) => StMoveFindLocPop(refVal1: 'IB_INST',))
                    ).then((result) {
                    if (result != null) {
                      setState(() {
                        widget.item['toLocCd'] = result['locCd'];
                      });
                    }
                    });
                  },
                  ),
                ],
              ),
              // const SizedBox(height: 10,),
              // Row(
              //   children: [
              //     const SizedBox(width: 100, child: Text('이동번호'),),
              //     const SizedBox(width: 10,),
              //     Expanded(child: Text('${widget.item['moveNo']}')),
              //   ],
              // ),
              // const SizedBox(height: 10,),
              // Row(
              //   children: [
              //     const SizedBox(width: 100, child: Text('순번'),),
              //     const SizedBox(width: 10,),
              //     Expanded(child: Text('${widget.item['moveDetailSeq']}')),
              //   ],
              // ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  const SizedBox(width: 100, child: Text('작업상태'),),
                  const SizedBox(width: 10,),
                  Expanded(child: Text('${widget.item['workStNm']}')),
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
                  const SizedBox(width: 100, child: Text('지시수량\n(Box/Ea)'),),
                  const SizedBox(width: 10,),
                  Expanded(child: Text('${widget.item['pdaInstQty']}')),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  const SizedBox(width: 100, child: Text('확정수량\n(Box/Ea)'),),
                  const SizedBox(width: 10,),
                  Expanded(
                    child: TextFormField(
                      initialValue: '${widget.item['pdaConfBoxQty']}',
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Box',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          widget.item['pdaConfBoxQty'] = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      initialValue: '${widget.item['pdaConfEaQty']}',
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'EA',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          widget.item['pdaConfEaQty'] = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  const SizedBox(width: 100, child: Text('LOT_ID'),),
                  const SizedBox(width: 10,),
                  Expanded(child: Text('${widget.item['lotId']}')),
                ],
              ),
            ],
          ),
        ),
      ],
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
              _examConfirm();
            },
            child: const Text('재고이동'),
          ),
        ],
      ),
    );
  }

  //검수완료
  Future<void> _examConfirm() async {
    String url = '/api/wmsapp/st/stockMove/saveStMoveDetailWorkProcOfPdaApp';
    widget.item['confBoxQty'] = widget.item['pdaConfBoxQty'];
    widget.item['confEaQty'] = widget.item['pdaConfEaQty'];
    widget.item['confTotQty'] = widget.item['pdaConfBoxQty'] * widget.item['pkqty'] + widget.item['pdaConfEaQty'];
    widget.item['confQty'] = widget.item['pdaConfBoxQty'] * widget.item['pkqty'] + widget.item['pdaConfEaQty'];
    var result = await ApiService.sendApi(context, url, {
      'data': [widget.item]
    });

    if (result == null) {
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
          '재고이동상세',
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
            _form(),
            _button(),
          ],
        ),
      ),
      // Use the item variable here
    );
  }
}