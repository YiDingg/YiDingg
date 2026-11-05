// =====================================================================
// DEBUG: LUP related results
// by YiDingg on 2026.10.21
// dingyi233@mails.ucas.ac.cn
// DEBUG: PAD type inventory for RVE
//   PAD_1_ALL_OPENINGS = PAD_2 + PAD_3 + PAD_4 + PAD_5 + PAD_6
//   PAD_7_POWER_ALL    = PAD_3 + PAD_4 + PAD_5
//   PAD_8_REAL_ALL     = PAD_3 + PAD_4 + PAD_5 + PAD_6
// =====================================================================
PAD_VDD_HIT  = PADiu INTERACT VDD_PAD
PAD_VSS_HIT  = PADiu INTERACT VSS_PAD
PAD_VDM_HIT  = PADiu INTERACT VDD_PAD_BY_DUMMY
PAD_VSM_HIT  = PADiu INTERACT VSS_PAD_BY_DUMMY
PAD_NOT_VDD  = (PADiu NOT PAD_VDD_HIT) NOT PAD_VDM_HIT
PAD_NOT_VSS  = (PADiu NOT PAD_VSS_HIT) NOT PAD_VSM_HIT
PAD_IS_VDD   = PADiu NOT PAD_NOT_VDD
PAD_IS_VSS   = PADiu NOT PAD_NOT_VSS
PAD_VDD_ONLY = PAD_IS_VDD NOT PAD_IS_VSS
PAD_VSS_ONLY = PAD_IS_VSS NOT PAD_IS_VDD
PAD_MIXED    = PAD_IS_VDD NOT PAD_NOT_VSS
PAD_THICK    = PADiu WITH WIDTH > 5
PAD_NONPAD   = PADiu NOT PAD_THICK
PAD_IO_ALL   = (PADiu NOT PAD_IS_VDD) NOT PAD_IS_VSS
PAD_IO_REAL  = PAD_IO_ALL NOT PAD_NONPAD
PAD_POWER    = PAD_THICK NOT PAD_IO_REAL

DEBUG_1_PAD_All_OPENINGS { @ [Debug] 1. all PAD openings (baseline, polygon level)
  COPY PADiu
}
DEBUG_2_PAD_NONPAD { @ [Debug] 2. NOT a real PAD (ring frame / sliver) - exclude these
  COPY PAD_NONPAD
}
DEBUG_3_PAD_REAL_ALL { @ [Debug] 3. all real PAD polygons (PAD_8) = PAD_4 + PAD_5 + PAD_6 + PAD_7
  COPY PAD_THICK
}
DEBUG_4_PAD_POWER_ALL { @ [Debug] 4. all power PAD (PAD_7) = PAD_4 + PAD_5 + PAD_6
  COPY PAD_POWER
}
DEBUG_5_PAD_IO_REAL { @ [Debug] 5. real I/O PAD (injector source)
  COPY PAD_IO_REAL
}
DEBUG_6_PAD_VDD_ONLY { @ [Debug] 6. PAD judged VDD only
  COPY PAD_VDD_ONLY
}
DEBUG_7_PAD_VSS_ONLY { @ [Debug] 7. PAD judged VSS only
  COPY PAD_VSS_ONLY
}
DEBUG_8_PAD_VDD_VSS_MIXED { @ [Debug] 8. PAD judged VDD and VSS together (invisible to LUP)
  COPY PAD_MIXED
}

DEBUG_9_INJ_N { @ [Debug] 9. N+ OD injector
  COPY POST_DRIVER_NACT
}
DEBUG_10_INJ_P { @ [Debug] 10. P+ OD injector
  COPY POST_DRIVER_PACT
}

DEBUG_11_AUX_PSD_ON_IOPAD { @ [Debug] 11. P+ S/D tied to I/O PAD
  COPY PSD_IOPAD
}
DEBUG_12_AUX_NSD_ON_IOPAD { @ [Debug] 12. N+ S/D tied to I/O PAD
  COPY NSD_IOPAD
}
DEBUG_13_AUX_NWR_ON_IOPAD { @ [Debug] 13. N-well resistor tied to I/O PAD
  COPY NWR_IOPAD
}
// =====================================================================
// END
// =====================================================================