**free
//=====================================================================*
//  Author  :  Thomas Raddatz                                          *
//  Date    :  25.09.2002                                              *
//  E-mail  :  thomas.raddatz@tools400.de                              *
//  Homepage:  www.tools400.de                                         *
//=====================================================================*

/copy QRTVFLDA,FDFLDA0100
/copy QRTVFLDA,FDFLDA0200
/copy QRTVFLDA,FDFLDA0300
/copy QRTVFLDA,FDFLDA0310
/copy QRTVFLDA,FDFLDA0320
/copy QRTVFLDA,FDFLDA0330
/copy QRTVFLDA,FDFLDA0340
/copy QRTVFLDA,FDFLDA0350

dcl-s fldDct_handle_t pointer based(pDummy);

/copy QBASICS1,PBASICS1

//===============================================================*
//  Open Field Attributes Dictionary
//===============================================================*

dcl-pr f_FldDct_new ind extproc('RTVFLDA_f_FldDct_new');
  i_fileName  char(10) const;
  i_fileLib   char(10) const;
  i_rcdFormat char(10) const;
  o_handle    like(fldDct_handle_t);
  o_msg       likeds(msg_t) options(*nopass);
end-pr;

//===============================================================*
//  Close Field Attributes Dictionary
//===============================================================*

dcl-pr f_FldDct_delete ind extproc('RTVFLDA_f_FldDct_delete');
  io_handle like(fldDct_handle_t);
end-pr;

//===============================================================*
//  Retrieve Field Attributes from Dictionary
//===============================================================*

dcl-pr f_FldDct_rtvFldAtr ind opdesc extproc('RTVFLDA_f_FldDct_rtvFldAtr');
  i_handle  like(fldDct_handle_t) const;
  i_fldName char(258) options(*varsize) const;
  o_data    char(2048) options(*varsize);
  i_format  char(8) options(*nopass) const;
end-pr;

//===============================================================*
//  Get Number of Entries available
//===============================================================*
dcl-pr f_FldDct_getNumE int(10) extproc('RTVFLDA_f_FldDct_getNumE');
  i_handle like(fldDct_handle_t) const;
end-pr;

//===============================================================*
//  Returns cTrue if a given handle is NULL, else cFalse.
//===============================================================*

dcl-pr f_FldDct_isNull ind extproc('RTVFLDA_f_FldDct_isNull');
  i_handle like(fldDct_handle_t) const;
end-pr;

//===============================================================*
//  Returns a NULL handle.
//===============================================================*

dcl-pr f_FldDct_null like(fldDct_handle_t) extproc('RTVFLDA_f_FldDct_null');
end-pr;

//===============================================================*
//  Constants
//===============================================================*
dcl-c cFLDDCT_RCDFMT_FIRST '*FIRST';

dcl-c cFLDDCT_TYPE_ERROR '?';
dcl-c cFLDDCT_TYPE_BINARY 'B';
dcl-c cFLDDCT_TYPE_FLOAT 'F';
dcl-c cFLDDCT_TYPE_ZONED 'S';
dcl-c cFLDDCT_TYPE_PACKED 'P';
dcl-c cFLDDCT_TYPE_CHAR 'A';
dcl-c cFLDDCT_TYPE_GRAPHIC 'G';
dcl-c cFLDDCT_TYPE_DATE 'L';
dcl-c cFLDDCT_TYPE_TIME 'T';
dcl-c cFLDDCT_TYPE_TMSTMP 'Z';
dcl-c cFLDDCT_TYPE_LOB '1';

dcl-c cFLDDCT_USE_ERROR '?';
dcl-c cFLDDCT_USE_INPUT 'I';
dcl-c cFLDDCT_USE_OUTPUT 'O';
dcl-c cFLDDCT_USE_BOTH 'B';
dcl-c cFLDDCT_USE_NEITHER 'N';

//  Time stamp data formats ...
//  ... of physical files
//      (must be the same as defined for the CSV converter)
dcl-c cFLDDCT_DTFMT_SAA '*SAA';

//  Time data formats ...
//  ... of physical files
//      (must be the same as defined for the CSV converter)
dcl-c cFLDDCT_DTFMT_HMS '*HMS';

//  Date and time data formats ...
//  ... of physical files
//      (must be the same as defined for the CSV converter)
dcl-c cFLDDCT_DTFMT_ISO '*ISO';
dcl-c cFLDDCT_DTFMT_USA '*USA';
dcl-c cFLDDCT_DTFMT_EUR '*EUR';
dcl-c cFLDDCT_DTFMT_JIS '*JIS';

//  Data data formats ...
//  ... of physical files
//      (must be the same as defined for the CSV converter)
dcl-c cFLDDCT_DTFMT_ERROR '?';
dcl-c cFLDDCT_DTFMT_JOB '*JOB';
dcl-c cFLDDCT_DTFMT_QDT '*QDT';
dcl-c cFLDDCT_DTFMT_MDY '*MDY';
dcl-c cFLDDCT_DTFMT_DMY '*DMY';
dcl-c cFLDDCT_DTFMT_YMD '*YMD';
dcl-c cFLDDCT_DTFMT_JUL '*JUL';
//  ... of logical files
dcl-c cFLDDCT_DTFMT_MDYY '*MDYY';
dcl-c cFLDDCT_DTFMT_DMYY '*DMYY';
dcl-c cFLDDCT_DTFMT_YYMD '*YYMD';
dcl-c cFLDDCT_DTFMT_LONGJUL '*LONGJUL';
dcl-c cFLDDCT_DTFMT_CMDY '*CMDY';
dcl-c cFLDDCT_DTFMT_CDMY '*CDMY';
dcl-c cFLDDCT_DTFMT_CYMD '*CYMD';
dcl-c cFLDDCT_DTFMT_MY '*MY';
dcl-c cFLDDCT_DTFMT_YM '*YM';
dcl-c cFLDDCT_DTFMT_MYY '*MYY';
dcl-c cFLDDCT_DTFMT_YYM '*YYM';

//  Date separaters ...
dcl-c cFLDDCT_DTSEP_ERROR '?';
dcl-c cFLDDCT_DTSEP_JOB '*JOB';
dcl-c cFLDDCT_DTSEP_IMPL '*IMPLIED';
dcl-c cFLDDCT_DTSEP_SLASH '/';
dcl-c cFLDDCT_DTSEP_DASH '-';
dcl-c cFLDDCT_DTSEP_PERIOD '.';
dcl-c cFLDDCT_DTSEP_BLANK ' ';
dcl-c cFLDDCT_DTSEP_COLON ':';

//  Field name special values ...
dcl-c cFLDDCT_FLD_FIRST '*FIRST';
dcl-c cFLDDCT_FLD_LAST '*LAST';
dcl-c cFLDDCT_FLD_NEXT '*NEXT';
dcl-c cFLDDCT_FLD_PREV '*PREV';

