
#####################################################
#####################################################
#####################################################
# Defult Libraries
#####################################################
SOFTINCLUDE /data/App/cadence/icadvm201/share/cdssetup/cds.lib
DEFINE TechLib /home/dy2025/Work/Cadence_Projects/00_Classification/TechLib
ASSIGN TechLib COMBINE US_8ths ahdlLib analogLib basic cdsDefTechLib functional rfExamples rfLib rfTlineLib



#####################################################
#####################################################
#####################################################
# Process Libraries
#####################################################
# DEFINE tsmcN28 /data/library/TSMC/tsmc28n/1p9m6x1z1u/tsmcN28	  # std. version
DEFINE tsmcN28 /data/library/TSMC/tsmc28n/1p9m6x1z1u_2v5/tsmcN28  # 2v5 version
ASSIGN tsmcN28 DISPLAY ProcessLib


#####################################################
#####################################################
#####################################################
# My Libraries for This Workspace
#####################################################
# 1. define
DEFINE MyLibraries /home/dy2025/Work/Cadence_Projects/00_Classification/MyLibraries
DEFINE MyLib_tsmcN28 /home/dy2025/Work/Cadence_Projects/MyLib_tsmcN28
DEFINE MyLib_verilog /home/dy2025/Work/Cadence_Projects/MyLib_verilog
DEFINE MyLib_onc18 /data/Work_dy2025/Cadence_Projects/MyLib_onc18
DEFINE MyLib_stdLib_tsmcN28 /data/Work_dy2025/Cadence_Projects/MyLib_stdLib_tsmcN28

# 2. assign
ASSIGN MyLibraries DISPLAY MyLibraries
ASSIGN MyLib_tsmcN28 DISPLAY MyLibraries
ASSIGN MyLib_verilog DISPLAY MyLibraries
ASSIGN MyLib_onc18 DISPLAY MyLibraries
ASSIGN MyLib_stdLib_tsmcN28 DISPLAY MyLibraries
# 3. combine
ASSIGN MyLibraries COMBINE  MyLib_tsmcN28 MyLib_verilog MyLib_onc18 MyLib_stdLib_tsmcN28


#####################################################
#####################################################
#####################################################
# My Projects
#####################################################
# 1. define
DEFINE MyProjects /home/dy2025/Work/Cadence_Projects/00_Classification/MyProjects
DEFINE MyLib_202507_BGR_tsmcN28 /data/Work_dy2025/Cadence_Projects/MyLib_202507_BGR_tsmcN28
DEFINE MyLib_202508_PLL_tsmcN28 /data/Work_dy2025/Cadence_Projects/MyLib_202508_PLL_tsmcN28
DEFINE MyLib_202510_PLL_onc18 /data/Work_dy2025/Cadence_Projects/MyLib_202510_PLL_onc18
DEFINE MyLib_202510_PLL_onc18__EX_20260110 /data/Work_dy2025/Cadence_Projects/MyLib_202510_PLL_onc18__EX_20260110
DEFINE MyLib_202510_PLL_onc18__EX_20260131 /data/Work_dy2025/Cadence_Projects/MyLib_202510_PLL_onc18__EX_20260131
DEFINE MyLib_202602_CDR_tsmcN28 /data/Work_dy2025/Cadence_Projects/MyLib_202602_CDR_tsmcN28
DEFINE MyLib_202609_TRX_tsmcN28 /data/Work_dy2025/Cadence_Projects/MyLib_202609_TRX_tsmcN28
DEFINE MyLib_202606_MUXforTX_tsmcN28 /data/Work_dy2025/Cadence_Projects/MyLib_202606_MUXforTX_tsmcN28

# 2. assign
ASSIGN MyProjects DISPLAY MyProjects
ASSIGN MyLib_202507_BGR_tsmcN28 DISPLAY MyProjects
ASSIGN MyLib_202508_PLL_tsmcN28 DISPLAY MyProjects
ASSIGN MyLib_202510_PLL_onc18 DISPLAY MyProjects
ASSIGN MyLib_202510_PLL_onc18__EX_20260110 DISPLAY MyProjects
ASSIGN MyLib_202510_PLL_onc18__EX_20260131 DISPLAY MyProjects
ASSIGN MyLib_202602_CDR_tsmcN28 DISPLAY MyProjects
ASSIGN MyLib_202609_TRX_tsmcN28 DISPLAY MyProjects
ASSIGN MyLib_202606_MUXforTX_tsmcN28 DISPLAY MyProjects
# 3. combine
ASSIGN MyProjects COMBINE MyLib_202507_BGR_tsmcN28 MyLib_202508_PLL_tsmcN28 MyLib_202509_LDO_tsmcN65 MyLib_202509_OTA_tsmcN65 MyLib_202509_DAC_tsmcN65 MyLib_202510_PLL_onc18 MyLib_202510_PLL_onc18__EX_20260110 MyLib_202510_PLL_onc18__EX_20260131 MyLib_202609_TRX_tsmcN28 MyLib_202606_MUXforTX_tsmcN28 MyLib_202602_CDR_tsmcN28


#####################################################
#####################################################
#####################################################
# Other Resources
#####################################################
# 1. define
DEFINE MyOtherResources /home/dy2025/Work/Cadence_Projects/Other_Resources
DEFINE LDO_3#2e3_to_1#2e3_Low_Noise /home/dy2025/Work/Cadence_Projects/Other_Resources/LDO_3#2e3_to_1#2e3_Low_Noise
DEFINE TX_DAC_R_2R_7bit_FOR /home/dy2025/Work/Cadence_Projects/Other_Resources/TX_DAC_R_2R_7bit_FOR__providedBy_YangWenjing_20250927/TX_DAC_R_2R_7bit_FOR
DEFINE CDR_TB /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/CDR_TB__providedBy_share_copy_on_20260202/CDR_TB
DEFINE gz_VerilogA_lib /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/gz_VerilogA_lib__providedBy_ZhangZhao_20260222/gz_VerilogA_lib 
DEFINE CDRDFE_V2 /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/CDRDFE_V2__providedBy_XiaoYaDong_20260304/20260311_CDR_FOR_DY_mergedWith20260304
DEFINE CDR_DFE_V4 /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/VCO_FOR_DY__providedBy_XiaoYadong_202560403/VCO_FOR_DY
DEFINE BGR_YHX /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/BGR_YHX__providedBy_YanHongxu_202560405/BGR_YHX
DEFINE MyResource_tsmcN28_VCO_fromXYD /data/Work_dy2025/Cadence_Projects/Other_Resources/MyResource_tsmcN28_VCO_fromXYD
DEFINE VCO_FOR_DY /data/Work_dy2025/Cadence_Projects/TemporaryLib/VCO_FOR_DY
DEFINE VCO_FOR_DY_V2 /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/VCO_FOR_DY__providedBy_XiaoYadong_202560403/VCO_FOR_DY_V2
DEFINE VCO_FOR_DY_V3 /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/VCO_FOR_DY__providedBy_XiaoYadong_202560403/VCO_FOR_DY_V3
DEFINE tcbn28hpcplusbwp12t30p140 /data/share/tcbn28hpcplusbwp12t30p140/tcbn28hpcplusbwp12t30p140
DEFINE CCO_FORDY /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/VCO_FOR_DY__providedBy_XiaoYadong_202560403/CCO_FORDY
DEFINE CP_FD_FOR_DY /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/CP_FOR_DY__providedBy_ZhangZhao_20260425/CP_FOR_DY/CP_FD_FOR_DY
DEFINE CP_PD_FOR_DY /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/CP_FOR_DY__providedBy_ZhangZhao_20260425/CP_FOR_DY/CP_PD_FOR_DY
DEFINE CAP_100fF_XYD /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/VCO_FOR_DY__providedBy_XiaoYadong_202560403/CAP_100fF_XYD
DEFINE CAP_4uM9_YHX /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/VCO_FOR_DY__providedBy_XiaoYadong_202560403/CAP_4uM9_YHX
DEFINE AFE_SE_TOP /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/AFE_SE_TOP
DEFINE GSGSG_PAD /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/GSGSG_PAD
DEFINE PAD_RING_YHX_PAM3_BGR_SR /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/PAD_RING_YHX_PAM3_BGR_SR
DEFINE PAD_SR_REF /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/PAD_SR_REF
DEFINE tphn28hpcpgv2od3 /home/dy2025/Desktop/Work/Cadence_Projects/Std_Libraries/tphn28hpcpgv2od3
# DEFINE CLK_BUF_IN_OUT /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/CLK_BUF_IN_OUT
DEFINE CLK_BUF_IN_OUT /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/new/CLK_BUF_IN_OUT
DEFINE DUMMY_FRAME /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/DUMMY_FRAME
DEFINE 64_32_16_8MXU_LZC /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202606_TX__otherResources/64_32_16_8MXU_LZC
DEFINE DIV2_TO_DY /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202606_TX__otherResources/DIV2_TO_DY
DEFINE TX_TOP_TB /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__TX_TOP_TB__providedBy_LiangZC_20260816/TX_TOP_TB
DEFINE AFE_SE_TOP_TB /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/AFE_SE_TOP_TB

# 2. assign
ASSIGN MyOtherResources DISPLAY MyOtherResources
ASSIGN LDO_3#2e3_to_1#2e3_Low_Noise DISPLAY MyOtherResources
ASSIGN TX_DAC_R_2R_7bit_FOR DISPLAY MyOtherResources
ASSIGN CDR_TB DISPLAY MyOtherResources
ASSIGN gz_VerilogA_lib DISPLAY MyOtherResources
ASSIGN CDRDFE_V2 DISPLAY MyOtherResources
ASSIGN VCO_FOR_DY DISPLAY MyOtherResources
ASSIGN MyResource_tsmcN28_VCO_fromXYD DISPLAY MyOtherResources
ASSIGN BGR_YHX DISPLAY MyOtherResources
ASSIGN VCO_FOR_DY_V2 DISPLAY MyOtherResources
ASSIGN VCO_FOR_DY_V3 DISPLAY MyOtherResources
ASSIGN CCO_FORDY DISPLAY MyOtherResources
ASSIGN CP_FD_FOR_DY DISPLAY MyOtherResources
ASSIGN CP_PD_FOR_DY DISPLAY MyOtherResources
ASSIGN CAP_100fF_XYD DISPLAY MyOtherResources
ASSIGN CAP_4uM9_YHX DISPLAY MyOtherResources
ASSIGN AFE_SE_TOP DISPLAY MyOtherResources
ASSIGN GSGSG_PAD DISPLAY MyOtherResources
ASSIGN PAD_RING_YHX_PAM3_BGR_SR DISPLAY MyOtherResources
ASSIGN PAD_SR_REF DISPLAY MyOtherResources
ASSIGN CLK_BUF_IN_OUT DISPLAY MyOtherResources
ASSIGN DUMMY_FRAME DISPLAY MyOtherResources
ASSIGN 64_32_16_8MXU_LZC DISPLAY MyOtherResources
ASSIGN DIV2_TO_DY DISPLAY MyOtherResources
ASSIGN TX_TOP_TB DISPLAY MyOtherResources
ASSIGN CDR_DFE_V4 DISPLAY MyOtherResources
ASSIGN AFE_SE_TOP_TB DISPLAY MyOtherResources
ASSIGN AFE_SE_TOP_TB DISPLAY MyOtherResources
ASSIGN AFE_SE_TOP_TB DISPLAY MyOtherResources
ASSIGN AFE_SE_TOP_TB DISPLAY MyOtherResources
ASSIGN AFE_SE_TOP_TB DISPLAY MyOtherResources
# 3. combine
ASSIGN MyOtherResources COMBINE LDO_3#2e3_to_1#2e3_Low_Noise TX_DAC_R_2R_7bit_FOR power Defib_rev4a CJ1_LJH_m5t08_layout CDR_TB gz_VerilogA_lib CDRDFE_V2 VCO_FOR_DY BGR_YHX VCO_FOR_DY_V2 VCO_FOR_DY_V3 CCO_FORDY CP_FD_FOR_DY CP_PD_FOR_DY CAP_100fF_XYD CAP_4uM9_YHX AFE_SE_TOP GSGSG_PAD PAD_RING_YHX_PAM3_BGR_SR PAD_SR_REF CLK_BUF_IN_OUT DUMMY_FRAME 64_32_16_8MXU_LZC DIV2_TO_DY TX_TOP_TB AFE_SE_TOP_TB CDR_DFE_V4 MyResource_tsmcN28_VCO_fromXYD



#####################################################
#####################################################
#####################################################
# Library Backups
#####################################################
# 1. define
DEFINE MyLib_verilog_BK_20260224 /data/Work_dy2025/Cadence_Projects/MyLib_verilog_BK_20260224
DEFINE MyLib_tsmcN28_BK_20260224 /data/Work_dy2025/Cadence_Projects/MyLib_tsmcN28_BK_20260224
DEFINE MyLib_tsmcN28_BK_20260322 /data/Work_dy2025/Cadence_Projects/MyLib_tsmcN28_BK_20260322
DEFINE MyLib_tsmcN28_BK_20260329 /data/Work_dy2025/Cadence_Projects/MyLib_tsmcN28_BK_20260329
DEFINE MyLib_202602_CDR_tsmcN28_BK_20260329 /data/Work_dy2025/Cadence_Projects/MyLib_202602_CDR_tsmcN28_BK_20260329
DEFINE MyLib_tsmcN28_test_Summer /data/Work_dy2025/Cadence_Projects/MyLib_tsmcN28_test_Summer
DEFINE MyLib_tsmcN28_BK_20260329_postSimTest /data/Work_dy2025/Cadence_Projects/MyLib_tsmcN28_BK_20260329_postSimTest
DEFINE MyLib_tsmcN28_BK_20260401 /data/Work_dy2025/Cadence_Projects/MyLib_tsmcN28_BK_20260401
DEFINE MyLib_tsmcN28_BK_20260403 /data/Work_dy2025/Cadence_Projects/MyLib_tsmcN28_BK_20260403
DEFINE MyLib_tsmcN28_BK_20260410 /data/Work_dy2025/Cadence_Projects/MyLib_tsmcN28_BK_20260410
DEFINE MyLib_tsmcN28_BK_20260414 /data/Work_dy2025/Cadence_Projects/MyLib_tsmcN28_BK_20260414
DEFINE MyLib_tsmcN28_BK_20260416 /data/Work_dy2025/Cadence_Projects/MyLib_tsmcN28_BK_20260416
DEFINE MyLib_tsmcN28_BK_20260420 /data/Work_dy2025/Cadence_Projects/MyLib_tsmcN28_BK_20260420
DEFINE MyLib_tsmcN28_BK_20260422 /data/Work_dy2025/Cadence_Projects/MyLib_tsmcN28_BK_20260422
DEFINE MyLib_verilog_BK_20260424 /data/Work_dy2025/Cadence_Projects/MyLib_verilog_BK_20260424
DEFINE MyLib_tsmcN28_BK_20260424 /data/Work_dy2025/Cadence_Projects/MyLib_tsmcN28_BK_20260424
DEFINE MyLib_tsmcN28_cellBK_LockDetection_20260425 /data/Work_dy2025/Cadence_Projects/MyLib_tsmcN28_cellBK_LockDetection_20260425
DEFINE MyLib_tsmcN28_BK_20260427 /data/Work_dy2025/Cadence_Projects/MyLib_tsmcN28_BK_20260427
DEFINE MyLib_202602_CDR_tsmcN28_gdsTest /data/Work_dy2025/Cadence_Projects/MyLib_202602_CDR_tsmcN28_gdsTest
DEFINE MyLib_tsmcN28_BK_20260502 /data/Work_dy2025/Cadence_Projects/MyLib_tsmcN28_BK_20260502
DEFINE MyLib_tsmcN28_BK_20260504 /data/Work_dy2025/Cadence_Projects/MyLib_tsmcN28_BK_20260504
DEFINE MyLib_stdLib_tsmcN28_20260513 /data/Work_dy2025/Cadence_Projects/MyLib_stdLib_tsmcN28_20260513
DEFINE MyLib_tsmcN28_R2RDAC_EX_20260517_BK /data/Work_dy2025/Cadence_Projects/MyLib_tsmcN28_R2RDAC_EX_20260517_BK
DEFINE MyLib_stdLib_tsmcN28_BK_20260520 /data/Work_dy2025/Cadence_Projects/MyLib_stdLib_tsmcN28_BK_20260520
DEFINE MyLib_202606_MUXforTX_tsmcN28_BK_20260526_1504 /data/Work_dy2025/Cadence_Projects/MyLib_202606_MUXforTX_tsmcN28_BK_20260526_1504
DEFINE MyLib_stdLib_tsmcN28_BK_20260526 /data/Work_dy2025/Cadence_Projects/MyLib_stdLib_tsmcN28_BK_20260526
DEFINE MyLib_202606_MUXforTX_tsmcN28_BK_20260527_0254 /data/Work_dy2025/Cadence_Projects/MyLib_202606_MUXforTX_tsmcN28_BK_20260527_0254
DEFINE MyLib_202606_MUXforTX_tsmcN28_BK_20260528_0306 /data/Work_dy2025/Cadence_Projects/MyLib_202606_MUXforTX_tsmcN28_BK_20260528_0306
DEFINE MyLib_202602_CDR_tsmcN28_BK_20260627 /data/Work_dy2025/Cadence_Projects/MyLib_202602_CDR_tsmcN28_BK_20260627
DEFINE MyLib_tsmcN28_BK_20260823 /data/Work_dy2025/Cadence_Projects/MyLib_tsmcN28_BK_20260823

# 2. assign
DEFINE MyLibraryBackups /home/dy2025/Work/Cadence_Projects/Library_Backups
ASSIGN MyLib_verilog_BK_20260224 DISPLAY MyLibraryBackups
ASSIGN MyLib_tsmcN28_BK_20260224 DISPLAY MyLibraryBackups
ASSIGN MyLib_tsmcN28_BK_20260322 DISPLAY MyLibraryBackups
ASSIGN MyLib_tsmcN28_BK_20260329 DISPLAY MyLibraryBackups
ASSIGN MyLib_202602_CDR_tsmcN28_BK_20260329 DISPLAY MyLibraryBackups
ASSIGN MyLib_tsmcN28_test_Summer DISPLAY MyLibraryBackups
ASSIGN MyLib_tsmcN28_BK_20260329_postSimTest DISPLAY MyLibraryBackups
ASSIGN MyLib_tsmcN28_BK_20260401 DISPLAY MyLibraryBackups
ASSIGN MyLib_tsmcN28_BK_20260403 DISPLAY MyLibraryBackups
ASSIGN MyLib_tsmcN28_BK_20260410 DISPLAY MyLibraryBackups
ASSIGN MyLib_tsmcN28_BK_20260414 DISPLAY MyLibraryBackups
ASSIGN MyLib_tsmcN28_BK_20260416 DISPLAY MyLibraryBackups
ASSIGN MyLib_tsmcN28_BK_20260420 DISPLAY MyLibraryBackups
ASSIGN MyLib_tsmcN28_BK_20260422 DISPLAY MyLibraryBackups
ASSIGN MyLib_verilog_BK_20260424 DISPLAY MyLibraryBackups
ASSIGN MyLib_tsmcN28_BK_20260424 DISPLAY MyLibraryBackups
ASSIGN MyLib_tsmcN28_cellBK_LockDetection_20260425 DISPLAY MyLibraryBackups
ASSIGN MyLib_tsmcN28_BK_20260427 DISPLAY MyLibraryBackups
ASSIGN MyLib_202602_CDR_tsmcN28_gdsTest DISPLAY MyLibraryBackups
ASSIGN MyLib_tsmcN28_BK_20260502 DISPLAY MyLibraryBackups
ASSIGN MyLib_tsmcN28_BK_20260504 DISPLAY MyLibraryBackups
ASSIGN MyLib_stdLib_tsmcN28_20260513 DISPLAY MyLibraryBackups
ASSIGN MyLib_tsmcN28_R2RDAC_EX_20260517_BK DISPLAY MyLibraryBackups
ASSIGN MyLib_tsmcN28_R2RDAC_EX_20260517 DISPLAY MyLibraryBackups
ASSIGN MyLib_stdLib_tsmcN28_BK_20260520 DISPLAY MyLibraryBackups
ASSIGN MyLib_202606_MUXforTX_tsmcN28_BK_20260526_1504 DISPLAY MyLibraryBackups
ASSIGN MyLib_stdLib_tsmcN28_BK_20260526 DISPLAY MyLibraryBackups
ASSIGN MyLib_202606_MUXforTX_tsmcN28_BK_20260527_0254 DISPLAY MyLibraryBackups
ASSIGN MyLib_202606_MUXforTX_tsmcN28_BK_20260528_0306 DISPLAY MyLibraryBackups
ASSIGN MyLib_202602_CDR_tsmcN28_BK_20260627 DISPLAY MyLibraryBackups
ASSIGN MyLib_tsmcN28_BK_20260823 DISPLAY MyLibraryBackups
ASSIGN xxx_xxx DISPLAY MyLibraryBackups
ASSIGN xxx_xxx DISPLAY MyLibraryBackups
ASSIGN xxx_xxx DISPLAY MyLibraryBackups
ASSIGN xxx_xxx DISPLAY MyLibraryBackups
ASSIGN xxx_xxx DISPLAY MyLibraryBackups
ASSIGN xxx_xxx DISPLAY MyLibraryBackups
ASSIGN xxx_xxx DISPLAY MyLibraryBackups
ASSIGN xxx_xxx DISPLAY MyLibraryBackups
ASSIGN xxx_xxx DISPLAY MyLibraryBackups
ASSIGN xxx_xxx DISPLAY MyLibraryBackups
ASSIGN xxx_xxx DISPLAY MyLibraryBackups
ASSIGN xxx_xxx DISPLAY MyLibraryBackups
ASSIGN xxx_xxx DISPLAY MyLibraryBackups
ASSIGN xxx_xxx DISPLAY MyLibraryBackups
# 3. combine
ASSIGN MyLibraryBackups COMBINE MyLib_verilog_BK_20260224 MyLib_tsmcN28_BK_20260224 MyLib_tsmcN28_BK_20260322 MyLib_tsmcN28_BK_20260329 MyLib_202602_CDR_tsmcN28_BK_20260329 MyLib_tsmcN28_test_Summer MyLib_tsmcN28_BK_20260329_postSimTest MyLib_tsmcN28_BK_20260401 MyLib_tsmcN28_BK_20260403 MyLib_tsmcN28_BK_20260410 MyLib_tsmcN28_BK_20260414 MyLib_tsmcN28_BK_20260416 MyLib_tsmcN28_BK_20260420 MyLib_tsmcN28_BK_20260422 MyLib_verilog_BK_20260424 MyLib_tsmcN28_BK_20260424 MyLib_tsmcN28_cellBK_LockDetection_20260425 MyLib_tsmcN28_BK_20260427 MyLib_202602_CDR_tsmcN28_gdsTest MyLib_tsmcN28_BK_20260502 MyLib_tsmcN28_BK_20260504 MyLib_stdLib_tsmcN28_20260513 MyLib_tsmcN28_R2RDAC_EX_20260517_BK MyLib_stdLib_tsmcN28_BK_20260520 MyLib_202606_MUXforTX_tsmcN28_BK_20260526_1504 MyLib_stdLib_tsmcN28_BK_20260526 MyLib_202606_MUXforTX_tsmcN28_BK_20260527_0254 MyLib_202606_MUXforTX_tsmcN28_BK_20260528_0306 MyLib_202602_CDR_tsmcN28_BK_20260627 MyLib_tsmcN28_BK_20260823


#####################################################
#####################################################
#####################################################
# Exported Libraries
#####################################################
# 1. define
DEFINE MyLib_Example_CDRLoop_PAM3_inputCML_quarterRate__EX_20260304 /data/Work_dy2025/Cadence_Projects/MyLib_Example_CDRLoop_PAM3_inputCML_quarterRate__EX_20260304
DEFINE MyLib_tsmcN28_share_toXYD /data/Work_dy2025/Cadence_Projects/MyLib_tsmcN28_share_toXYD
DEFINE MyLib_tsmcN28_share_toWJY /data/Work_dy2025/Cadence_Projects/MyLib_tsmcN28_share_toWJY
DEFINE MyLib_tsmcN28_stdLib_std2d0200n30n /data/Work_dy2025/Cadence_Projects/MyLib_tsmcN28_stdLib_std2d0200n30n
DEFINE MyLib_202602_CDR_tsmcN28_DummyLib /data/Work_dy2025/Cadence_Projects/MyLib_202602_CDR_tsmcN28_DummyLib
DEFINE MyLib_tsmcN28_dummyLib /data/Work_dy2025/Cadence_Projects/MyLib_tsmcN28_dummyLib
DEFINE MyLib_202602_CDR_tsmcN28_EX_20260501_1924 /data/Work_dy2025/Cadence_Projects/MyLib_202602_CDR_tsmcN28_EX_20260501_1924
DEFINE MyLib_202602_CDR_tsmcN28_EX_20260506_1552 /data/Work_dy2025/Cadence_Projects/MyLib_202602_CDR_tsmcN28_EX_20260506_1552
DEFINE MyLib_tsmcN28_R2RDAC_EX_20260517 /data/Work_dy2025/Cadence_Projects/MyLib_tsmcN28_R2RDAC_EX_20260517
DEFINE MyLib_tsmcN28_R2RDAC_EX_20260518 /data/Work_dy2025/Cadence_Projects/MyLib_tsmcN28_R2RDAC_EX_20260518
DEFINE MyLib_tsmcN28_R2RDAC_EX_20260521 /data/Work_dy2025/Cadence_Projects/MyLib_tsmcN28_R2RDAC_EX_20260521
DEFINE MyLib_tsmcN28_R2RDAC_EX_20260526 /data/Work_dy2025/Cadence_Projects/MyLib_tsmcN28_R2RDAC_EX_20260526
DEFINE MyLib_202606_MUXforTX_tsmcN28_EX_20260527 /data/Work_dy2025/Cadence_Projects/MyLib_202606_MUXforTX_tsmcN28_EX_20260527
DEFINE MyLib_stdLib_tsmcN28_dummyBlock_forXYD /data/Work_dy2025/Cadence_Projects/MyLib_stdLib_tsmcN28_dummyBlock_forXYD
DEFINE MyLib_tsmcN28_CAPCELLM9_20260601 /data/Work_dy2025/Cadence_Projects/MyLib_tsmcN28_CAPCELLM9_20260601
DEFINE MyLib_202602_CDR_tsmcN28_DFEforYHX_EX_20260624 /data/Work_dy2025/Cadence_Projects/MyLib_202602_CDR_tsmcN28_DFEforYHX_EX_20260624
DEFINE MyLib_202602_CDR_tsmcN28_forHYW_EX_20260718 /data/Work_dy2025/Cadence_Projects/MyLib_202602_CDR_tsmcN28_forHYW_EX_20260718
DEFINE MyLib_stdLib_tsmcN28_dummyLib_forCKY /data/Work_dy2025/Cadence_Projects/MyLib_stdLib_tsmcN28_dummyLib_forCKY
DEFINE MyLib_stdLib_tsmcN28_EX_20260801_dummyLib_forCKY /data/Work_dy2025/Cadence_Projects/MyLib_stdLib_tsmcN28_EX_20260801_dummyLib_forCKY

# 2. assign
DEFINE MyExportedLibraries /home/dy2025/Work/Cadence_Projects/Exported_Libraries
ASSIGN MyExportedLibraries DISPLAY MyExportedLibraries
ASSIGN MyLib_Example_CDRLoop_PAM3_inputCML_quarterRate__EX_20260304 DISPLAY MyExportedLibraries
ASSIGN MyLib_tsmcN28_share_toXYD DISPLAY MyExportedLibraries
ASSIGN MyLib_tsmcN28_share_toWJY DISPLAY MyExportedLibraries
ASSIGN MyLib_tsmcN28_stdLib_std2d0200n30n DISPLAY MyExportedLibraries
ASSIGN MyLib_202602_CDR_tsmcN28_DummyLib DISPLAY MyExportedLibraries
ASSIGN MyLib_tsmcN28_dummyLib DISPLAY MyExportedLibraries
ASSIGN MyLib_202602_CDR_tsmcN28_EX_20260501_1924 DISPLAY MyExportedLibraries
ASSIGN MyLib_202602_CDR_tsmcN28_EX_20260506_1552 DISPLAY MyExportedLibraries
ASSIGN MyLib_tsmcN28_R2RDAC_EX_20260517 DISPLAY MyExportedLibraries
ASSIGN MyLib_tsmcN28_R2RDAC_EX_20260518 DISPLAY MyExportedLibraries
ASSIGN MyLib_tsmcN28_R2RDAC_EX_20260521 DISPLAY MyExportedLibraries
ASSIGN MyLib_tsmcN28_R2RDAC_EX_20260526 DISPLAY MyExportedLibraries
ASSIGN MyLib_202606_MUXforTX_tsmcN28_EX_20260527 DISPLAY MyExportedLibraries
ASSIGN MyLib_stdLib_tsmcN28_dummyBlock_forXYD DISPLAY MyExportedLibraries
ASSIGN MyLib_tsmcN28_CAPCELLM9_20260601 DISPLAY MyExportedLibraries
ASSIGN MyLib_202602_CDR_tsmcN28_DFEforYHX_EX_20260624 DISPLAY MyExportedLibraries
ASSIGN MyLib_202602_CDR_tsmcN28_forHYW_EX_20260718 DISPLAY MyExportedLibraries
ASSIGN MyLib_stdLib_tsmcN28_dummyLib_forCKY DISPLAY MyExportedLibraries
ASSIGN MyLib_stdLib_tsmcN28_EX_20260801_dummyLib_forCKY DISPLAY MyExportedLibraries
ASSIGN xxx_xxx DISPLAY MyExportedLibraries
# 3. combine
ASSIGN MyExportedLibraries COMBINE MyLib_tsmcN28_share_toXYD MyLib_tsmcN28_share_toWJY MyLib_tsmcN28_stdLib_std2d0200n30n MyLib_202602_CDR_tsmcN28_DummyLib MyLib_tsmcN28_dummyLib MyLib_202602_CDR_tsmcN28_EX_20260501_1924 MyLib_202602_CDR_tsmcN28_EX_20260506_1552 MyLib_tsmcN28_R2RDAC_EX_20260517 MyLib_tsmcN28_R2RDAC_EX_20260518 MyLib_tsmcN28_R2RDAC_EX_20260521 MyLib_tsmcN28_R2RDAC_EX_20260526 MyLib_202606_MUXforTX_tsmcN28_EX_20260527 MyLib_stdLib_tsmcN28_dummyBlock_forXYD MyLib_stdLib_tsmcN28_dummyBlock_forXYD MyLib_202602_CDR_tsmcN28_DFEforYHX_EX_20260624 MyLib_202602_CDR_tsmcN28_forHYW_EX_20260718 MyLib_stdLib_tsmcN28_dummyLib_forCKY MyLib_stdLib_tsmcN28_EX_20260801_dummyLib_forCKY MyLib_Example_CDRLoop_PAM3_inputCML_quarterRate__EX_20260304 MyLib_tsmcN28_CAPCELLM9_20260601


#####################################################
#####################################################
#####################################################
# Misc Libraries
#####################################################
#INCLUDE /home/dy2025/Desktop/Work/Cadence_Projects/Other_Resources/202602_CDR__otherResources/TX_cds_newPath.lib
DEFINE Test_Cadence /data/Work_dy2025/Cadence_Projects/Test_Cadence


