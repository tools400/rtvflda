**free
/if NOT DEFINED(flda0310_t)
/define flda0310_t
//===============================================================*
//  QDBRTVFD API - FLDA0310                                      *
// ============================================================= *
dcl-ds flda0310_t qualified;
  // File name
  file       char(10);
  // Library name
  lib        char(10);
  // Field name
  name       char(10);
  // Data type
  type       char(1);
  // Use
  use        char(1);
  // Output buffer position
  outBufPos  int(10);
  // Input buffer position
  inBufPos   int(10);
  // Field length in bytes
  length     int(10);
  // Digits
  digits     int(10);
  // Decimal position
  decPos     int(10);
  // Field text description
  text       char(50);
  // Edit code
  edtC       char(2);
  // Edit word length
  edtWLen    bindec(9);
  // Edit word
  edtW       char(64);
  // Column heading 1
  colHdg1    char(20);
  // Column heading 2
  colHdg2    char(20);
  // Column heading 3
  colHdg3    char(20);
  // Date and time format
  datTimFmt  char(4);
  // Date and time separator
  datTimSep  char(1);

  //  Additional fields of format FLDA0200
  // Reference file name
  refFile    char(10);
  // Reference library name
  refLib     char(10);
  // Reference record format name
  refFmt     char(10);
  // Reference field name
  refFld     char(10);

  //  Additional fields of format FLDA0300
  alwNull    ind;
  ccsid      uns(10);

  //  Additional fields of format FLDA0310
  varLength  ind;
  buffLength int(10);
  alcLength  int(10);
end-ds;

/endif
