/* --------------------------------------------------------------- */
/* RTVFLDA    - SCRIPT MEMBER                                      */
/* Use commands  xmlgenINC (generate text for install pgm)         */
/*               xmlgenMBR (to define source members               */
/*               xmlgenCMD (execute qcmdexc at run time            */
/* Put &TOLIB where you want user selected lib at run time.        */
   DCL &TOLIB *CHAR 10
/* --------------------------------------------------------------- */
             XMLGENINC  XINCLUDE(*YES)

             XMLGENCND  XMSG('Create sample programs? (YES, NO)') +
                          XVALUES(YES NO) XVAR(&CRTTSTPGM)

             XMLGENSET  XVAR(&SRCFILE) XVALUE(QRTVFLDA)

/* ---------------------------------- */
/*  Deploy source member              */
/* ---------------------------------- */
             XMLGENMBR  XMBR(A_INSTALL ) XMBRATR(CLLE ) +
                          XFROMSRCF(QRTVFLDA  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QRTVFLDA  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(COPYRIGHT ) XMBRATR(CLLE  ) +
                          XFROMSRCF(QRTVFLDA  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QRTVFLDA  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDFLDA0100) XMBRATR(RPGLE) +
                          XFROMSRCF(QRTVFLDA  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QRTVFLDA  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDFLDA0200) XMBRATR(RPGLE) +
                          XFROMSRCF(QRTVFLDA  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QRTVFLDA  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDFLDA0300) XMBRATR(RPGLE) +
                          XFROMSRCF(QRTVFLDA  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QRTVFLDA  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDFLDA0310) XMBRATR(RPGLE) +
                          XFROMSRCF(QRTVFLDA  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QRTVFLDA  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDFLDA0320) XMBRATR(RPGLE) +
                          XFROMSRCF(QRTVFLDA  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QRTVFLDA  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDFLDA0330) XMBRATR(RPGLE) +
                          XFROMSRCF(QRTVFLDA  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QRTVFLDA  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDFLDA0340) XMBRATR(RPGLE) +
                          XFROMSRCF(QRTVFLDA  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QRTVFLDA  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PRTVFLDA  ) XMBRATR(RPGLE) +
                          XFROMSRCF(QRTVFLDA  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QRTVFLDA  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(QDBRTVFD  ) XMBRATR(RPGLE) +
                          XFROMSRCF(QRTVFLDA  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QRTVFLDA  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(RTVFLDA   ) XMBRATR(MAKSRV) +
                          XFROMSRCF(QRTVFLDA  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QRTVFLDA  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(RTVFLDA_T1) XMBRATR(RPGLE) +
                          XFROMSRCF(QRTVFLDA  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QRTVFLDA  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(RTVFLDA_T2) XMBRATR(RPGLE) +
                          XFROMSRCF(QRTVFLDA  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QRTVFLDA  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(RTVFLDA_T3) XMBRATR(RPGLE) +
                          XFROMSRCF(QRTVFLDA  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QRTVFLDA  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(RTVFLDA_T4) XMBRATR(RPGLE) +
                          XFROMSRCF(QRTVFLDA  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QRTVFLDA  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(RTVFLDA_T5) XMBRATR(RPGLE) +
                          XFROMSRCF(QRTVFLDA  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QRTVFLDA  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(RTVFLDA_T6) XMBRATR(RPGLE) +
                          XFROMSRCF(QRTVFLDA  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QRTVFLDA  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(RTVFLDAR1 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QRTVFLDA  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QRTVFLDA  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

/* ---------------------------------- */
/*  Create objects                    */
/* ---------------------------------- */
             XMLGENCMD  XCMD(CRTBNDCL PGM(&TOLIB/A_INSTALL) +
                          SRCFILE(&TOLIB/QRTVFLDA) SRCMBR(*PGM) +
                          DFTACTGRP(*NO) ACTGRP(*NEW) +
                          DBGVIEW(*LIST)) XDLTSPLF(A_INSTALL)

             XMLGENCMD  XCMD(CALL PGM(&TOLIB/A_INSTALL) +
                             PARM('&TGTRLS' '&SRCFILE' '&TOLIB' '&CRTTSTPGM'))
             XMLGENCMD  XCMD(DLTPGM PGM(&TOLIB/A_INSTALL))

