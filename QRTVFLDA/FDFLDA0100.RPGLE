      /IF NOT DEFINED(flda0100_t)
      /DEFINE flda0100_t
      *===============================================================*
      *  QDBRTVFD API - FLDA0100                                      *
      * ============================================================= *
     D flda0100_t...
     D                 DS                   qualified
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
      /ENDIF
