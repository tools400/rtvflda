      *=====================================================================*
      *  Author  :  Thomas Raddatz                                          *
      *  Date    :  25.09.2002                                              *
      *  E-mail  :  thomas.raddatz@tools400.de                              *
      *  Homepage:  www.tools400.de                                         *
      *=====================================================================*
      *
      /COPY QRTVFLDA,FDFLDA0100
      /COPY QRTVFLDA,FDFLDA0200
      /COPY QRTVFLDA,FDFLDA0300
      /COPY QRTVFLDA,FDFLDA0310
      /COPY QRTVFLDA,FDFLDA0320
      /COPY QRTVFLDA,FDFLDA0330
      /COPY QRTVFLDA,FDFLDA0340
      *
     D fldDct_handle_t...
     D                 S               *   based(pDummy)
      *
      /COPY QBASICS1,PBASICS1
      *
      *===============================================================*
      *  Open Field Attributes Dictionary
      *===============================================================*
      *
     D f_FldDct_new...
     D                 PR              N
     D                                     extproc('RTVFLDA+
     D                                     _f_FldDct_new+
     D                                     ')
     D  i_fileName                   10A   const
     D  i_fileLib                    10A   const
     D  i_rcdFormat                  10A   const
     D  o_handle                                 like(fldDct_handle_t)
     D  o_msg                                    likeds(msg_t        )
     D                                           options(*nopass)
      *
      *===============================================================*
      *  Close Field Attributes Dictionary
      *===============================================================*
      *
     D f_FldDct_delete...
     D                 PR              N
     D                                     extproc('RTVFLDA+
     D                                     _f_FldDct_delete+
     D                                     ')
     D  io_handle                                like(fldDct_handle_t)
      *
      *===============================================================*
      *  Retrieve Field Attributes from Dictionary
      *===============================================================*
      *
     D f_FldDct_rtvFldAtr...
     D                 PR              N   opdesc
     D                                     extproc('RTVFLDA+
     D                                     _f_FldDct_rtvFldAtr+
     D                                     ')
     D  i_handle                           const  like(fldDct_handle_t)
     D  i_fldName                   258A   const  options(*varsize)
     D  o_data                     2048A          options(*varsize)
     D  i_format                      8A   const  options(*nopass)
      *
      *===============================================================*
      *  Get Number of Entries available
      *===============================================================*
     D f_FldDct_getNumE...
     D                 PR            10I 0
     D                                     extproc('RTVFLDA+
     D                                     _f_FldDct_getNumE+
     D                                     ')
     D i_handle                            const  like(fldDct_handle_t)
      *
      *===============================================================*
      *  Returns cTrue if a given handle is NULL, else cFalse.
      *===============================================================*
      *
     D f_FldDct_isNull...
     D                 PR              N
     D                                     extproc('RTVFLDA+
     D                                     _f_FldDct_isNull+
     D                                     ')
     D  i_handle                           const like(fldDct_handle_t)
      *
      *===============================================================*
      *  Returns a NULL handle.
      *===============================================================*
      *
     D f_FldDct_null...
     D                 PR                        like(fldDct_handle_t)
     D                                     extproc('RTVFLDA+
     D                                     _f_FldDct_null+
     D                                     ')
      *
      *===============================================================*
      *  Constants
      *===============================================================*
     D cFLDDCT_RCDFMT_FIRST...
     D                 C                   const('*FIRST')
      *
     D cFLDDCT_TYPE_ERROR...
     D                 C                   const('?')
     D cFLDDCT_TYPE_BINARY...
     D                 C                   const('B')
     D cFLDDCT_TYPE_FLOAT...
     D                 C                   const('F')
     D cFLDDCT_TYPE_ZONED...
     D                 C                   const('S')
     D cFLDDCT_TYPE_PACKED...
     D                 C                   const('P')
     D cFLDDCT_TYPE_CHAR...
     D                 C                   const('A')
     D cFLDDCT_TYPE_GRAPHIC...
     D                 C                   const('G')
     D cFLDDCT_TYPE_DATE...
     D                 C                   const('L')
     D cFLDDCT_TYPE_TIME...
     D                 C                   const('T')
     D cFLDDCT_TYPE_TMSTMP...
     D                 C                   const('Z')
     D cFLDDCT_TYPE_LOB...
     D                 C                   const('1')
      *
     D cFLDDCT_USE_ERROR...
     D                 C                   const('?')
     D cFLDDCT_USE_INPUT...
     D                 C                   const('I')
     D cFLDDCT_USE_OUTPUT...
     D                 C                   const('O')
     D cFLDDCT_USE_BOTH...
     D                 C                   const('B')
     D cFLDDCT_USE_NEITHER...
     D                 C                   const('N')
      *
      *  Time stamp data formats ...
      *  ... of physical files
      *      (must be the same as defined for the CSV converter)
     D cFLDDCT_DTFMT_SAA...
     D                 C                   const('*SAA')
      *
      *  Time data formats ...
      *  ... of physical files
      *      (must be the same as defined for the CSV converter)
     D cFLDDCT_DTFMT_HMS...
     D                 C                   const('*HMS')
      *
      *  Date and time data formats ...
      *  ... of physical files
      *      (must be the same as defined for the CSV converter)
     D cFLDDCT_DTFMT_ISO...
     D                 C                   const('*ISO')
     D cFLDDCT_DTFMT_USA...
     D                 C                   const('*USA')
     D cFLDDCT_DTFMT_EUR...
     D                 C                   const('*EUR')
     D cFLDDCT_DTFMT_JIS...
     D                 C                   const('*JIS')
      *
      *  Data data formats ...
      *  ... of physical files
      *      (must be the same as defined for the CSV converter)
     D cFLDDCT_DTFMT_ERROR...
     D                 C                   const('?')
     D cFLDDCT_DTFMT_JOB...
     D                 C                   const('*JOB')
     D cFLDDCT_DTFMT_QDT...
     D                 C                   const('*QDT')
     D cFLDDCT_DTFMT_MDY...
     D                 C                   const('*MDY')
     D cFLDDCT_DTFMT_DMY...
     D                 C                   const('*DMY')
     D cFLDDCT_DTFMT_YMD...
     D                 C                   const('*YMD')
     D cFLDDCT_DTFMT_JUL...
     D                 C                   const('*JUL')
      *  ... of logical files
     D cFLDDCT_DTFMT_MDYY...
     D                 C                   const('*MDYY')
     D cFLDDCT_DTFMT_DMYY...
     D                 C                   const('*DMYY')
     D cFLDDCT_DTFMT_YYMD...
     D                 C                   const('*YYMD')
     D cFLDDCT_DTFMT_LONGJUL...
     D                 C                   const('*LONGJUL')
     D cFLDDCT_DTFMT_CMDY...
     D                 C                   const('*CMDY')
     D cFLDDCT_DTFMT_CDMY...
     D                 C                   const('*CDMY')
     D cFLDDCT_DTFMT_CYMD...
     D                 C                   const('*CYMD')
     D cFLDDCT_DTFMT_MY...
     D                 C                   const('*MY')
     D cFLDDCT_DTFMT_YM...
     D                 C                   const('*YM')
     D cFLDDCT_DTFMT_MYY...
     D                 C                   const('*MYY')
     D cFLDDCT_DTFMT_YYM...
     D                 C                   const('*YYM')
      *
      *  Date separaters ...
     D cFLDDCT_DTSEP_ERROR...
     D                 C                   const('?')
     D cFLDDCT_DTSEP_JOB...
     D                 C                   const('*JOB')
     D cFLDDCT_DTSEP_IMPL...
     D                 C                   const('*IMPLIED')
     D cFLDDCT_DTSEP_SLASH...
     D                 C                   const('/')
     D cFLDDCT_DTSEP_DASH...
     D                 C                   const('-')
     D cFLDDCT_DTSEP_PERIOD...
     D                 C                   const('.')
     D cFLDDCT_DTSEP_BLANK...
     D                 C                   const(' ')
     D cFLDDCT_DTSEP_COLON...
     D                 C                   const(':')
      *
      *  Field name special values ...
     D cFLDDCT_FLD_FIRST...
     D                 C                   const('*FIRST')
     D cFLDDCT_FLD_LAST...
     D                 C                   const('*LAST')
     D cFLDDCT_FLD_NEXT...
     D                 C                   const('*NEXT')
     D cFLDDCT_FLD_PREV...
     D                 C                   const('*PREV')
      *
