**free
/if NOT DEFINED(flda0350_t)
/define flda0350_t
//===============================================================*
//  QDBRTVFD API - FLDA0350                                      *
// ============================================================= *
dcl-ds flda0350_t qualified template;
  // File name
  file          char(10);
  // Library name
  lib           char(10);
  // Field name
  name          char(10);
  // Data type
  type          char(1);
  // Use
  use           char(1);
  // Output buffer position
  outBufPos     int(10);
  // Input buffer position
  inBufPos      int(10);
  // Field length in bytes
  length        int(10);
  // Digits
  digits        int(10);
  // Decimal position
  decPos        int(10);
  // Field text description
  text          char(50);
  // Edit code
  edtC          char(2);
  // Edit word length
  edtWLen       bindec(9);
  // Edit word
  edtW          char(64);
  // Column heading 1
  colHdg1       char(20);
  // Column heading 2
  colHdg2       char(20);
  // Column heading 3
  colHdg3       char(20);
  // Date and time format
  datTimFmt     char(4);
  // Date and time separator
  datTimSep     char(1);

  //  Additional fields of format FLDA0200
  // Reference file name
  refFile       char(10);
  // Reference library name
  refLib        char(10);
  // Reference record format name
  refFmt        char(10);
  // Reference field name
  refFld        char(10);

  //  Additional fields of format FLDA0300
  alwNull       ind;
  ccsid         uns(10);

  //  Additional fields of format FLDA0310
  varLength     ind;
  buffLength    int(10);
  alcLength     int(10);

  //  Additional fields of format FLDA0320
  alias         varchar(258);

  //  Additional fields of format FLDA0330
  fieldNum      int(10);

  //  Additional fields of format FLDA0340
  lenDftValue   int(10);
  pDftValue     pointer;
  isDbcsGraphic ind;
  isHexLiteral  ind;
  isNullDft     ind;
  isCurrTime    ind;
  hasDtfKeyword ind;

  //  Additional fields of format FLDA0350
  isIdyCol      ind;
  orgStrValue   int(20); // START WITH
  currStrValue  int(20);
  incValue      int(20); // INCREMENT BY
  minValue      int(20); // MINVALUE
  maxValue      int(20); // MAXVALUE
  numCache      int(10); // CACHE n / NO CACH
  isCycling     ind; // CYCLE / NO CYCLE
  isOrdering    ind; // ORDER / NO ORDER
end-ds;

/endif
