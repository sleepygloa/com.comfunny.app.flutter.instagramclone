class IbExamMasterDto {
  final String bizCd;
  final String ibNo;
  final String dcCd;
  final String dcNm;
  final String clientCd;
  final String clientNm;
  final String ibGbnCd;
  final String ibGbnNm;
  final String ibProgStCd;
  final String ibProgStNm;
  final String ibPlanYmd;
  final String ibYmd;
  final String supplierCd;
  final String supplierNm;
  final String carNo;
  final String tcObNo;
  final String userCol1;
  final String userCol2;
  final String userCol3;
  final String userCol4;
  final String userCol5;
  final String remark;
  final String useYn;
  final String useYnNm;

  IbExamMasterDto({
    required this.bizCd,
    required this.ibNo,
    required this.dcCd,
    required this.dcNm,
    required this.clientCd,
    required this.clientNm,
    required this.ibGbnCd,
    required this.ibGbnNm,
    required this.ibProgStCd,
    required this.ibProgStNm,
    required this.ibPlanYmd,
    required this.ibYmd,
    required this.supplierCd,
    required this.supplierNm,
    required this.carNo,
    required this.tcObNo,
    required this.userCol1,
    required this.userCol2,
    required this.userCol3,
    required this.userCol4,
    required this.userCol5,
    required this.remark,
    required this.useYn,
    required this.useYnNm,
  });

  factory IbExamMasterDto.fromJson(Map<String, dynamic> json) {
    return IbExamMasterDto(
      bizCd: json['BIZ_CD'],
      ibNo: json['IB_NO'],
      dcCd: json['DC_CD'],
      dcNm: json['DC.DC_NM'],
      clientCd: json['CLIENT_CD'],
      clientNm: json['CLI.CLIENT_NM'],
      ibGbnCd: json['IB_GBN_CD'],
      ibGbnNm: json['IB_GBN_NM'],
      ibProgStCd: json['IB_PROG_ST_CD'],
      ibProgStNm: json['IB_PROG_ST_NM'],
      ibPlanYmd: json['IB_PLAN_YMD'],
      ibYmd: json['IB_YMD'],
      supplierCd: json['SUPPLIER_CD'],
      supplierNm: json['SUP.SUPPLIER_NM'],
      carNo: json['CAR_NO'],
      tcObNo: json['TC_OB_NO'],
      userCol1: json['USER_COL1'],
      userCol2: json['USER_COL2'],
      userCol3: json['USER_COL3'],
      userCol4: json['USER_COL4'],
      userCol5: json['USER_COL5'],
      remark: json['REMARK'],
      useYn: json['USE_YN'],
      useYnNm: json['USE_YN_NM'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'BIZ_CD': bizCd,
      'IB_NO': ibNo,
      'DC_CD': dcCd,
      'DC.DC_NM': dcNm,
      'CLIENT_CD': clientCd,
      'CLI.CLIENT_NM': clientNm,
      'IB_GBN_CD': ibGbnCd,
      'IB_GBN_NM': ibGbnNm,
      'IB_PROG_ST_CD': ibProgStCd,
      'IB_PROG_ST_NM': ibProgStNm,
      'IB_PLAN_YMD': ibPlanYmd,
      'IB_YMD': ibYmd,
      'SUPPLIER_CD': supplierCd,
      'SUP.SUPPLIER_NM': supplierNm,
      'CAR_NO': carNo,
      'TC_OB_NO': tcObNo,
      'USER_COL1': userCol1,
      'USER_COL2': userCol2,
      'USER_COL3': userCol3,
      'USER_COL4': userCol4,
      'USER_COL5': userCol5,
      'REMARK': remark,
      'USE_YN': useYn,
      'USE_YN_NM': useYnNm,
    };
  }
}