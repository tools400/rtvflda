      /IF NOT DEFINED(flda0350_t)
      /DEFINE flda0350_t
      *===============================================================*
      *  QDBRTVFD API - FLDA0350                                      *
      * ============================================================= *
     D flda0350_t...
     D                 DS                   qualified template
      * File name
     D  file                         10A
      * Library name
     D  lib                          10A
      * Field name
     D  name                         10A
      * Data type
     D  type                          1A
      * Use
     D  use                           1A
      * Output buffer position
     D  outBufPos                    10I 0
      * Input buffer position
     D  inBufPos                     10I 0
      * Field length in bytes
     D  length                       10I 0
      * Digits
     D  digits                       10I 0
      * Decimal position
     D  decPos                       10I 0
      * Field text description
     D  text                         50A
      * Edit code
     D  edtC                          2A
      * Edit word length
     D  edtWLen                       9B 0
      * Edit word
     D  edtW                         64A
      * Column heading 1
     D  colHdg1                      20A
      * Column heading 2
     D  colHdg2                      20A
      * Column heading 3
     D  colHdg3                      20A
      * Date and time format
     D  datTimFmt                     4A
      * Date and time separator
     D  datTimSep                     1A
      *
      *  Additional fields of format FLDA0200
      * Reference file name
     D  refFile                      10A
      * Reference library name
     D  refLib                       10A
      * Reference record format name
     D  refFmt                       10A
      * Reference field name
     D  refFld                       10A
      *
      *  Additional fields of format FLDA0300
     D  alwNull                        N
     D  ccsid                        10U 0
      *
      *  Additional fields of format FLDA0310
     D  varLength                      N
     D  buffLength                   10I 0
     D  alcLength                    10I 0
      *
      *  Additional fields of format FLDA0320
     D  alias                       258A   varying
      *
      *  Additional fields of format FLDA0330
     D  fieldNum                     10I 0
      *
      *  Additional fields of format FLDA0340
     D  lenDftValue                  10I 0
     D  pDftValue                      *
     D  isDbcsGraphic                  N
     D  isHexLiteral                   N
     D  isNullDft                      N
     D  isCurrTime                     N
     D  hasDtfKeyword                  N
      *
      *  Additional fields of format FLDA0350
     D  isIdyCol                       N
     D  orgStrValue                  20I 0                                      START WITH
     D  currStrValue                 20I 0
     D  incValue                     20I 0                                      INCREMENT BY
     D  minValue                     20I 0                                      MINVALUE
     D  maxValue                     20I 0                                      MAXVALUE
     D  numCache                     10I 0                                      CACHE n / NO CACHE
     D  isCycling                      N                                        CYCLE / NO CYCLE
     D  isOrdering                     N                                        ORDER / NO ORDER
      *
      /ENDIF
