class IbExamDetailDto {
  final String bizCd;
  final String ibNo;
  final int ibDetailSeq;
  final String ibProgStCd;
  final String ibProgStNm;
  final String itemCd;
  final String itemNm;
  final String itemStCd;
  final String itemStNm;
  final int pkqty;
  final int planTotQty;
  final int planBoxQty;
  final int planEaQty;
  final int planQty;
  final int confQty;
  final int apprQty;
  final int eexamTotQty;
  final int examBoxQty;
  final int examEaQty;
  final int examQty;
  final int instQty;
  final int putwQty;
  final String noIbRsnCd;
  final String noIbRsnNm;
  final double ibCost;
  final double ibVat;
  final double ibAmt;
  final String makeLot;
  final String makeYmd;
  final String distExpiryYmd;
  final String lotId;
  final String lotAttr1;
  final String lotAttr2;
  final String lotAttr3;
  final String lotAttr4;
  final String lotAttr5;
  final String remark;
  final String useYn;
  final String useYnNm;

  IbExamDetailDto({
    required this.bizCd,
    required this.ibNo,
    required this.ibDetailSeq,
    required this.ibProgStCd,
    required this.ibProgStNm,
    required this.itemCd,
    required this.itemNm,
    required this.itemStCd,
    required this.itemStNm,
    required this.pkqty,
    required this.planTotQty,
    required this.planBoxQty,
    required this.planEaQty,
    required this.planQty,
    required this.confQty,
    required this.apprQty,
    required this.eexamTotQty,
    required this.examBoxQty,
    required this.examEaQty,
    required this.examQty,
    required this.instQty,
    required this.putwQty,
    required this.noIbRsnCd,
    required this.noIbRsnNm,
    required this.ibCost,
    required this.ibVat,
    required this.ibAmt,
    required this.makeLot,
    required this.makeYmd,
    required this.distExpiryYmd,
    required this.lotId,
    required this.lotAttr1,
    required this.lotAttr2,
    required this.lotAttr3,
    required this.lotAttr4,
    required this.lotAttr5,
    required this.remark,
    required this.useYn,
    required this.useYnNm,
  });

  factory IbExamDetailDto.fromJson(Map<String, dynamic> json) {
    return IbExamDetailDto(
      bizCd: json['BIZ_CD'],
      ibNo: json['IB_NO'],
      ibDetailSeq: json['IB_DETAIL_SEQ'],
      ibProgStCd: json['IB_PROG_ST_CD'],
      ibProgStNm: json['IB_PROG_ST_NM'],
      itemCd: json['ITEM_CD'],
      itemNm: json['ITEM_NM'],
      itemStCd: json['ITEM_ST_CD'],
      itemStNm: json['ITEM_ST_NM'],
      pkqty: json['PKQTY'],
      planTotQty: json['PLAN_TOT_QTY'],
      planBoxQty: json['PLAN_BOX_QTY'],
      planEaQty: json['PLAN_EA_QTY'],
      planQty: json['PLAN_QTY'],
      confQty: json['CONF_QTY'],
      apprQty: json['APPR_QTY'],
      eexamTotQty: json['EEXAM_TOT_QTY'],
      examBoxQty: json['EXAM_BOX_QTY'],
      examEaQty: json['EXAM_EA_QTY'],
      examQty: json['EXAM_QTY'],
      instQty: json['INST_QTY'],
      putwQty: json['PUTW_QTY'],
      noIbRsnCd: json['NO_IB_RSN_CD'],
      noIbRsnNm: json['NO_IB_RSN_NM'],
      ibCost: json['IB_COST'],
      ibVat: json['IB_VAT'],
      ibAmt: json['IB_AMT'],
      makeLot: json['MAKE_LOT'],
      makeYmd: json['MAKE_YMD'],
      distExpiryYmd: json['DIST_EXPIRY_YMD'],
      lotId: json['LOT_ID'],
      lotAttr1: json['LOT_ATTR1'],
      lotAttr2: json['LOT_ATTR2'],
      lotAttr3: json['LOT_ATTR3'],
      lotAttr4: json['LOT_ATTR4'],
      lotAttr5: json['LOT_ATTR5'],
      remark: json['REMARK'],
      useYn: json['USE_YN'],
      useYnNm: json['USE_YN_NM'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'BIZ_CD': bizCd,
      'IB_NO': ibNo,
      'IB_DETAIL_SEQ': ibDetailSeq,
      'IB_PROG_ST_CD': ibProgStCd,
      'IB_PROG_ST_NM': ibProgStNm,
      'ITEM_CD': itemCd,
      'ITEM_NM': itemNm,
      'ITEM_ST_CD': itemStCd,
      'ITEM_ST_NM': itemStNm,
      'PKQTY': pkqty,
      'PLAN_TOT_QTY': planTotQty,
      'PLAN_BOX_QTY': planBoxQty,
      'PLAN_EA_QTY': planEaQty,
      'PLAN_QTY': planQty,
      'CONF_QTY': confQty,
      'APPR_QTY': apprQty,
      'EEXAM_TOT_QTY': eexamTotQty,
      'EXAM_BOX_QTY': examBoxQty,
      'EXAM_EA_QTY': examEaQty,
      'EXAM_QTY': examQty,
      'INST_QTY': instQty,
      'PUTW_QTY': putwQty,
      'NO_IB_RSN_CD': noIbRsnCd,
      'NO_IB_RSN_NM': noIbRsnNm,
      'IB_COST': ibCost,
      'IB_VAT': ibVat,
      'IB_AMT': ibAmt,
      'MAKE_LOT': makeLot,
      'MAKE_YMD': makeYmd,
      'DIST_EXPIRY_YMD': distExpiryYmd,
      'LOT_ID': lotId,
      'LOT_ATTR1': lotAttr1,
      'LOT_ATTR2': lotAttr2,
      'LOT_ATTR3': lotAttr3,
      'LOT_ATTR4': lotAttr4,
      'LOT_ATTR5': lotAttr5,
      'REMARK': remark,
      'USE_YN': useYn,
      'USE_YN_NM': useYnNm,
    };
  }
}