      *=====================================================================*
      *  Author  :  Thomas Raddatz                                          *
      *  Date    :  25.09.2002                                              *
      *  E-mail  :  thomas.raddatz@Tools400.de                              *
      *  Homepage:  www.tools400.de                                         *
      *=====================================================================*
      *                                                                     *
      *  This software is free software, you can redistribute it and/or     *
      *  modify it under the terms of the GNU General Public License (GPL)  *
      *  as published by the Free Software Foundation.                      *
      *                                                                     *
      *  See GNU General Public License for details.                        *
      *          http://www.opensource.org                                  *
      *          http://www.opensource.org/licenses/gpl-license.html        *
      *                                                                     *
      *=====================================================================*
      *  Test file used when adding format FLDA0340:                        *
      *                                                                     *
      *     CREATE TABLE QTEMP.TEST (                                       *
      *      DATE_ DATE,                                                    *
      *      TIME_ TIME NOT NULL WITH DEFAULT CURRENT_TIME,                 *
      *      TIMESTAMP_ TIMESTAMP WITH DEFAULT NULL,                        *
      *      HEX_ CHAR(10) NOT NULL WITH DEFAULT x'C49695819384'            *
      *      BOOL_ CHAR(1) NOT NULL WITH DEFAULT '0'                        *
      *         CHECK (BOOL_ IN ('0', '1'))                                 *
      *      ) RCDFMT FTEST2                                                *
      *                                                                     *
      *  Values of 'Qdb_Qddfdft.Qddfdfta':                                  *
      *     date        :  no default                                       *
      *     time_       :  x'04'        expected: x'05'   dft + time        *
      *     timestamp_  :  x'20'        expected: x'21'   dft + null        *
      *     hex_        :  x'40'        expected: x'41'   dft + hex literal *
      *     bool_       :  x'00'        expected: x'01'   dft               *
      *                                                                     *
      *  Bit 'Qddfdftk' of 'Qdb_Qddfdft.Qddfdfta' is missing for fields     *
      *  with default values, isn't it?                                     *
      *                                                                     *
      *     R FTEST                                                         *
      *       DATE_           L         ALWNULL                             *
      *       TIME_           T                                             *
      *       TIMESTAMP_      Z         ALWNULL DFT(*NULL)                  *
      *       HEX_          10A         DFT(X'C4969581938440404040')        *
      *       BOOL_          1A         DFT('0') VALUES('1' '0')            *
      *                                                                     *
      *  Values of 'Qdb_Qddfdft.Qddfdfta':                                  *
      *     date        :  no default                                       *
      *     time_       :  no default   though initialized to CURRENT_TIME  *
      *     timestamp_  :  x'20'        expected: x'21'   dft + null        *
      *     hex_        :  x'40'        expected: x'41'   dft + hex literal *
      *     bool_       :  x'00'        expected: x'01'   dft               *
      *                                                                     *
      *=====================================================================*
      *  History:                                                           *
      *                                                                     *
      *  Datum       Name          Änderung                                 *
      *  ----------  ------------  ---------------------------------------  *
      *  17.02.2006  Th.Raddatz    Fixed problem that a wrong TEXT was      *
      *                            returned, when there is not field text.  *
      *                            Introduced format FLDA0310 to get        *
      *                            information about 'variable length'      *
      *                            fields.                                  *
      *                                                                     *
      *  21.02.2006  Th.Raddatz    Enabled data type CHARACTER (variable    *
      *                            length).                                 *
      *                                                                     *
      *  17.04.2007  Th.Raddatz    Changed i_fldName of f_FldDct_rtvFldAtr  *
      *                            to 258A *VARSIZE.                        *
      *                                                                     *
      *  10.08.2007  Th.Raddatz    Enabled data type GRAPHIC.               *
      *                                                                     *
      *  10.10.2007  Th.Raddatz    Fixed problem that column heading        *
      *                            contained garbage when a field did       *
      *                            not have a column heading.               *
      *                                                                     *
      *  24.09.2008  Th.Raddatz    Fixed problem that 'length' was not      *
      *                            properly set for VARLEN fields.          *
      *                            Actually 'isVarying' was not correctly   *
      *                            set.                                     *
      *                                                                     *
      *  26.09.2008  Th.Raddatz    Fixed problem that o_isDone was not      *
      *                            set by f_FldDct_delete().                *
      *                                                                     *
      *  04.12.2008  Th.Raddatz    f_FldDct_rtvFldAtr() now returns the     *
      *                            correct entry if a given alias name      *
      *                            is shorter than 10 characters.           *
      *                            Fixed call to f_rmvQuotes(). Parameters  *
      *                            had to be reversed.                      *
      *                                                                     *
      *  31.10.2012  Th.Raddatz    Added new format FLDA0330.               *
      *                                                                     *
      *  17.10.2013  Th.Raddatz    Added new format FLDA0340.               *
      *                                                                     *
      *  03.02.2015  Th.Raddatz    Added field type LOB. (cFLDDCT_TYPE_LOB) *
      *                                                                     *
      *=====================================================================*
      *   >>PRE-COMPILER<<                                                  *
      *     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                      *
      *                              SRCFILE(&SL/&SF) +                     *
      *                              SRCMBR(&SM);                           *
      *     >>COMPILE<<                                                     *
      *       >>PARM<< TRUNCNBR(*NO);                                       *
      *       >>PARM<< DBGVIEW(*LIST);                                      *
      *       >>PARM<< TGTRLS(V6R1M0);                                      *
      *     >>END-COMPILE<<                                                 *
      *     >>EXECUTE<<                                                     *
      *   >>END-PRE-COMPILER<<                                              *
      *=====================================================================*
     H NOMAIN
     H EXTBININT(*YES) BNDDIR('QC2LE')
     H DATFMT(*ISO) TIMFMT(*ISO) DEBUG(*YES)
      /COPY QRTVFLDA,COPYRIGHT
      *=====================================================================*
      *
      * ---------------------------------------------
      *  Prototypes of exported procedures
      * ---------------------------------------------
      /COPY QRTVFLDA,PRTVFLDA
      *
      * ---------------------------------------------
      *  Reference fields
      * ---------------------------------------------
      *
      *  Handle data
     D handle_t        DS                  based(pDummy)  qualified
     D  pointer                        *
     D  file                         10A
     D  lib                          10A
     D  lastFldNum                   10I 0
     D  lastFldPtr                     *
      *
      * ---------------------------------------------
      *  Prototypes of private procedures
      * ---------------------------------------------
     D f_intToExtDataType...
     D                 PR             1A
     D  i_intDataType                 2A   const
      *
     D f_intToExtUsage...
     D                 PR             1A
     D  i_intUsage                    1A   const
      *
     D f_intToExtDatTimFmt...
     D                 PR             4A
     D  i_intDataType                 2A   const
     D  i_intFmt                      1A   const
      *
     D f_intToExtDatTimSep...
     D                 PR             1A
     D  i_intDataType                 2A   const
     D  i_intSep                      1A   const
      *
      * ---------------------------------------------
      *  Prototypes of external procedures
      * ---------------------------------------------
      /COPY QRTVFLDA,QDBRTVFD                      Retrieve Database File Description (QDBRTVF
      *
      *  Get String Information (CEEGSI) API
     D CEEGSI...
     D                 PR                         extproc('CEEGSI')
     D  i_posNr                      10I 0 const
     D  o_dataType                   10I 0
     D  o_currLen                    10I 0
     D  o_maxLen                     10I 0
     D  o_fc                         12A          options(*omit)
      *
      *  Global constants
     D cDOUBLE_QUOTE   C                   '"'
      *
      *==================================================================*
      *  Create Field Attributes Dictionary
      *==================================================================*
      *
     P f_FldDct_new...
     P                 B                   export
      *
     D f_FldDct_new...
     D                 PI              N
     D  i_file                       10A   const
     D  i_lib                        10A   const
     D  i_rcdFormat                  10A   const
     D  o_handle                                 like(fldDct_handle_t)
     D  o_msg                                    likeds(msg_t        )
     D                                           options(*nopass)
      *
      *  Return value
     D o_isDone        S               N   inz(cFalse)
      *
      *  Positions of optional parameters
     D cpMsg           C                   const(5)
      *
      *  Handle data
     D handle          DS                  likeds(handle_t  )  based(pHandle)
      *
      *  Local fields
     D isError         S               N                    inz(cFalse)
     D isBuffer        S               N                    inz(cFalse)
     D bufferSize      S             10I 0                  inz
     D buffer          DS                  based(pBuffer  ) qualified
     D  bytRet                       10I 0
     D  bytAvl                       10I 0
      *
     D msg             DS                  likeds(msg_t       ) inz
     D errCode         DS                  likeds(errCode_t   ) inz
     D qFile           DS                  likeds(qObj_t      ) inz
     D qRetFile        DS                  likeds(qObj_t      ) inz
      * ---------------------------------------------------------
      *
      /FREE

         // Initialize return values
         o_isDone  = cFalse;
         clear   msg;

         // Initialize helper fields
         isError     = cFalse;
         isBuffer    = cFalse;

         // Retrieve file description ...
         dou   isError   or   o_isDone;

            // ... allocate memory
            bufferSize = %size(buffer);
            pBuffer    = %alloc(bufferSize);
            isBuffer   = cTrue;

            // ... determine size of memory actually needed
            qFile.name = i_file;
            qFile.lib  = i_lib;
            errCode    = f_newApiErrCode(cTrue);
            QDBRTVFD(buffer: bufferSize : qRetFile: 'FILD0200':
                     qFile : i_rcdFormat: '0'     : '*LCL'    :
                     '*EXT': errCode);
            if   f_isAPIError(errCode);
               msg = f_cvtApiErrCodeToMsg(errCode);
               isError = cTrue;
            else;

               // ... retrieve file description
               //     (incrementing buffer size as needed; strange API)
               qFile = qRetFile;
               dow   (buffer.bytAvl > buffer.bytRet)   and   not isError;
                  bufferSize = buffer.bytAvl;
                  pBuffer = %realloc(pBuffer: bufferSize);
                  QDBRTVFD(Buffer : bufferSize : qRetFile: 'FILD0200':
                           qFile  : i_rcdFormat: '0'     : '*LCL'    :
                           '*EXT' : errCode);
                  if   f_isAPIError(errCode);
                     msg = f_cvtApiErrCodeToMsg(errCode);
                     isError  = cTrue;
                  else;
                     clear   msg;
                     o_isDone = cTrue;
                  endif;
               enddo;

            endif;
         enddo;

         // If the file description is available ...
         if   o_isDone;
         // ... then allocate handle buffer and
         //     return the handle
            pHandle = %alloc(%size(handle));
            handle.Pointer    = pBuffer;
            handle.file       = qRetFile.name;
            handle.lib        = qRetFile.lib;
            handle.lastFldNum = 0;
            handle.lastFldPtr = *NULL;
            o_handle = pHandle;
         else;
         // ... else deallocate buffer and
         //     set return value to NULL
            if   isBuffer;
               dealloc(N)   pBuffer;
               isBuffer   = cFalse;
               bufferSize = 0;
            endif;
            o_handle = *NULL;
         endif;

         if   %parms >= cpMsg;
            o_msg = msg;
         endif;

         return   o_isDone;

      /END-FREE
      *
     P f_FldDct_new...
     P                 E
      *
      *==================================================================*
      *  Delete Field Attributes Dictionary
      *==================================================================*
      *
     P f_FldDct_delete...
     P                 B                   export
      *
     D f_FldDct_delete...
     D                 PI              N
     D  io_handle                                 like(fldDct_handle_t)
      *
      *  Return value
     D o_isDone        S               N   inz(cFalse)
      *
      *  Handle data
     D handle          DS                  likeds(handle_t  )  based(pHandle)
      * ---------------------------------------------------------
      *
      /FREE

         // Get access to handle data
         pHandle = io_handle;

         // Free file description buffer
         dealloc(N)   handle.Pointer;

         // Initialize handle data
         clear   handle;
         handle.Pointer  = *NULL;
         handle.file     = '';
         handle.lib      = '';

         // Deallocate handle buffer
         dealloc(N)   pHandle;

         // Return handle
         io_handle = pHandle;

         o_isDone = cTrue;

         return   o_isDone;

      /END-FREE
      *
     P f_FldDct_delete...
     P                 E
      *
      *==================================================================*
      *  Retrieve Field Attributes from Dictionary
      *==================================================================*
      *
     P f_FldDct_rtvFldAtr...
     P                 B                   export
      *
     D f_FldDct_rtvFldAtr...
     D                 PI              N   opdesc
     D  i_handle                           const  like(fldDct_handle_t)
     D  i_fldName                   258A   const  options(*varsize)
     D  o_data                     2048A          options(*varsize)
     D  i_format                      8A   const  options(*nopass)
      *
      *  Return value
     D o_isDone        S               N   inz(cFalse)
      *
      *  Positions of (optional) parameters
     D cpFldName       C                   const(2)
     D cpData          C                   const(3)
     D cpFormat        C                   const(4)
      *
      *  Optional parameter fields
     D format          S                   like(i_format    ) inz
      *
      *  Handle
     D handle          DS                  likeds(handle_t  )  based(pHandle)
      *
      *  Format Definition Header (Qdb_Qddfmt)
     D Qdb_Qddfmt      DS                  likeds(Qdb_Qddfmt_t)
     D                                     based(pQdb_Qddfmt )
      *
      *  Field Header (Qdb_Qddffld)
     D Qdb_Qddffld     DS                  likeds(Qdb_Qddffld_t  )
     D                                     based(pQdb_Qddffld   )
      *
      *  Alias name structure (Qdb_Qddfalis)
     D Qdb_Qddfalis    DS                  likeds(Qdb_Qddfalis_t )
     D                                     based(pQdb_Qddfalis  )
      *
      *  Reference Information (Qdb_Qddfrefi)
     D Qdb_Qddfrefi    DS                  likeds(Qdb_Qddfrefi_t )
     D                                     based(pQdb_Qddfrefi  )
      *
      *  Field Text (Qdb_Qddfftxt)
     D Qdb_Qddfftxt    DS                  likeds(Qdb_Qddfftxt_t )
     D                                     based(pQdb_Qddfftxt  )
      *
      *  Column Heading Information (Qdb_Qddfcolh)
     D Qdb_Qddfcolh    DS                  likeds(Qdb_Qddfcolh_t )
     D                                     based(pQdb_Qddfcolh  )
      *
      *  Edit Code/Edit Word Information (Qdb_Qddfedcw)
     D Qdb_Qddfedcw    DS                  likeds(Qdb_Qddfedcw_t )
     D                                     based(pQdb_Qddfedcw  )
      *
      *  Default Value Description Information (Qdb_Qddfdft)
     D Qdb_Qddfdft     DS                  likeds(Qdb_Qddfdft_t  )
     D                                     based(pQdb_Qddfdft   )
      *
      *  Local fields
     D isFound         S               N   inz
     D isVarying       S               N   inz
     D fldNum          S             20I 0 inz
     D y               S             20I 0 inz
     D blankText       S                   like(Qdb_Qddfftxt.Qddfftxt)
     D fldName         S            258A   varying inz
     D longFldName     S            258A   varying inz
      *
     D FLDA0100        DS                  likeds(flda0100_t)
     D FLDA0200        DS                  likeds(flda0200_t)
     D FLDA0300        DS                  likeds(flda0300_t)
     D FLDA0310        DS                  likeds(flda0310_t)
     D FLDA0320        DS                  likeds(flda0320_t)
     D FLDA0330        DS                  likeds(flda0330_t)
     D FLDA0340        DS                  likeds(flda0340_t)
      *
      *  String information of i_fldName
     D si_i_fldName    DS                  qualified
     D  dataType                     10I 0
     D  currLen                      10I 0
     D  maxLen                       10I 0
      *
      *  String information of o_data
     D si_o_data       DS                  qualified
     D  dataType                     10I 0
     D  currLen                      10I 0
     D  maxLen                       10I 0
      *-------------------------------------------------------------------
      /FREE

         // Get optional parameters
         if   %parms >= cpFormat;
            format = i_format;
         else;
            format = 'FLDA0100';
         endif;

         // Get string information of i_fldName
         CEEGSI(cpFldName:
                si_i_fldName.dataType:
                si_i_fldName.currLen: si_i_fldName.maxLen: *omit);

         fldName = %trimR(%subst(i_fldName: 1: si_i_fldName.currLen));

         // Get string information of o_data
         CEEGSI(cpData:
                si_o_data.dataType: si_o_data.currLen: si_o_data.maxLen: *omit);

         // Get access to handle data
         pHandle = i_handle;

         // Get access to "Format Definition Header"
         pQdb_Qddfmt = handle.pointer;

         // Initialize helper fields
         isFound        = cFalse;

         // Optimization for cFLDDCT_FLD_NEXT
         if   fldName = cFLDDCT_FLD_NEXT;
            y = handle.lastFldNum;
            // get access to "Field Header" of last field returned
            // to get entry length
            pQdb_Qddffld = handle.lastFldPtr;
         else;
            y = 1;
            // get access to "Field Header" of first field
            // to get entry length
            pQdb_Qddffld = %addr(Qdb_Qddfmt) + %size(Qdb_Qddfmt);
         endif;

         // Spin through the file format definition
         // and look for the field requested
         for   fldNum = y to Qdb_Qddfmt.Qddffldnum;

            // Get access to alias field name
            longFldName = '';
            if (Qdb_Qddffld.Qddfxals <> 0);
               pQdb_Qddfalis = pQdb_Qddffld + Qdb_Qddffld.Qddfxals;
               if (Qdb_Qddfalis.Qddfalsl > 0);
                  longFldName = %trimR(%subst(Qdb_Qddfalis.Qddfalsn
                                              : 1: Qdb_Qddfalis.Qddfalsl));
                  longFldName = f_rmvQuotes(longFldName: cDOUBLE_QUOTE);
               endif;
            endif;

            if longFldName = '';
               longFldName = %trimR(Qdb_Qddffld.Qddffldi);
            endif;

            // Process special value ...
            select;
            // ... FIRST
            when   (fldName = cFLDDCT_FLD_FIRST) and
                   (fldNum = 1);
               isFound = cTrue;
               leave;
            // ... LAST
            when   (fldName = cFLDDCT_FLD_LAST)  and
                   (fldNum = Qdb_Qddfmt.Qddffldnum);
               isFound = cTrue;
               leave;
            // ... NEXT
            when   (fldName = cFLDDCT_FLD_NEXT)  and
                   (fldNum = handle.lastFldNum + 1);
               isFound = cTrue;
               leave;
            // ... PREVIOUS
            when   (fldName = cFLDDCT_FLD_PREV)  and
                   (fldNum = handle.lastFldNum - 1);
               isFound = cTrue;
               leave;
            // ... and a named field
            other;
               if   (fldName = longFldName or
                     fldName = %trimR(Qdb_Qddffld.Qddffldi));
                  isFound = cTrue;
                  leave;
               endif;
            endsl;

            // get access to next field in list
            pQdb_Qddffld = pQdb_Qddffld + Qdb_Qddffld.Qddfdefl;
         endfor;

         // If the field could not be found, ...
         if   not isFound;
         // ... then return BAD
            o_isDone = cFalse;
            %subst(o_data: 1: si_o_data.currLen) = '';
         else;
         // ... else return OK and field data
            o_isDone = cTrue;
            %subst(o_data: 1: si_o_data.currLen) = '';

            // Get access to "Reference Information"
            if   Qdb_Qddffld.Qddfrefd > 0;
               pQdb_Qddfrefi = pQdb_Qddffld + Qdb_Qddffld.Qddfrefd;
            else;
               pQdb_Qddfrefi = *NULL;
            endif;

            // Get access to "Edit Code/Edit Word Information"
            if   Qdb_Qddffld.Qddfedtl = 0;
               pQdb_Qddfedcw = *NULL;
            else;
               pQdb_Qddfedcw = pQdb_Qddffld + Qdb_Qddffld.Qddfedtd;
            endif;

            // Get access to "Field Text"
            if Qdb_Qddffld.Qddftxtd = 0;
               pQdb_Qddfftxt = %addr(blankText);
            else;
               pQdb_Qddfftxt = pQdb_Qddffld + Qdb_Qddffld.Qddftxtd;
            endif;

            // Get access to "Default Value Information"
            if Qdb_Qddffld.Qddfdftd = 0;
               pQdb_Qddfdft = *NULL;
            else;
               pQdb_Qddfdft = pQdb_Qddffld + Qdb_Qddffld.Qddfdftd;
            endif;

            // Get access to "Column Heading Information"
            if Qdb_Qddffld.Qddfchd = 0;
               pQdb_Qddfcolh = *NULL;
            else;
               pQdb_Qddfcolh = pQdb_Qddffld + Qdb_Qddffld.Qddfchd;
            endif;

            // Determine if the field is a VARYING field
            if (f_isBitOn(x'20': Qdb_Qddffld.Qddffldst2)
                or Qdb_Qddffld.Qddfftyp = X'8004'    // = var character // Hack until PTF
                or Qdb_Qddffld.Qddfftyp = X'8005');  // = var graphic   // is available
               isVarying = cTrue;
            else;
               isVarying = cFalse;
            endif;

            // Set return data values
            clear   FLDA0100;
            FLDA0100.file      = handle.file;
            FLDA0100.lib       = handle.lib;
            FLDA0100.name      = Qdb_Qddffld.Qddffldi;
            FLDA0100.type      = f_intToExtDataType(Qdb_Qddffld.Qddfftyp);
            FLDA0100.use       = f_intToExtUsage(Qdb_Qddffld.Qddffiob);
            FLDA0100.outBufPos = Qdb_Qddffld.Qddffobo + 1;
            FLDA0100.inBufPos  = Qdb_Qddffld.Qddffibo + 1;

            if isVarying;
               FLDA0100.length    = Qdb_Qddffld.Qddffldb - 2;
            else;
               FLDA0100.length    = Qdb_Qddffld.Qddffldb;
            endif;

            FLDA0100.digits    = Qdb_Qddffld.Qddffldd;
            FLDA0100.decPos    = Qdb_Qddffld.Qddffldp;
            FLDA0100.text      = Qdb_Qddfftxt.Qddfftxt;

            // If there is no field edit code, ...
            if   pQdb_Qddfedcw = *NULL;
            // ... then clear the related fields
               FLDA0100.edtc    = '';
               FLDA0100.edtWLen = 0;
               FLDA0100.edtW    = '';
            else;
            // ... else
            //     If it is an edit word, ...
               if   Qdb_Qddffld.Qddfedtl > 16;                // => EditWord
            // ... then return edit word information
                  FLDA0100.edtc    = '';
                  FLDA0100.edtWLen = Qdb_Qddffld.Qddfedtl - 16;
                  FLDA0100.edtW    = %subst(Qdb_Qddfedcw.Qddfewd :
                                            1                    :
                                            FLDA0100.edtWLen     );
               else;
            //    ... else return edit code information
                  FLDA0100.edtc    = Qdb_Qddfedcw.Qddfecdi;
                  FLDA0100.edtWLen = 0;
                  FLDA0100.edtW    = '';
               endif;
            endif;

            if pQdb_Qddfcolh = *NULL;
               FLDA0100.colHdg1 = '';
               FLDA0100.colHdg2 = '';
               FLDA0100.colHdg3 = '';
            else;
               FLDA0100.colHdg1 = Qdb_Qddfcolh.Qddfch1;
               FLDA0100.colHdg2 = Qdb_Qddfcolh.Qddfch2;
               FLDA0100.colHdg3 = Qdb_Qddfcolh.Qddfch3;
            endif;

            FLDA0100.datTimFmt = f_intToExtDatTimFmt(Qdb_Qddffld.Qddfftyp :
                                                     Qdb_Qddffld.Qddfdttf );

            FLDA0100.datTimSep = f_intToExtDatTimSep(Qdb_Qddffld.Qddfftyp :
                                                     Qdb_Qddffld.Qddfdtts );

            // Set additional fields of format FLDA0200
            if   format = 'FLDA0200' or
                 format = 'FLDA0300' or
                 format = 'FLDA0310' or
                 format = 'FLDA0320' or
                 format = 'FLDA0330' or
                 format = 'FLDA0340';
               clear   FLDA0200;
               FLDA0200 = FLDA0100;

               // If there are reference information
               if   pQdb_Qddfrefi <> *NULL;
                  FLDA0200.refFile = Qdb_Qddfrefi.Qddfrfil;
                  FLDA0200.refLib  = Qdb_Qddfrefi.Qddfrlib;
                  FLDA0200.refFmt  = Qdb_Qddfrefi.Qddfrfmt;
                  FLDA0200.refFld  = Qdb_Qddfrefi.Qddfrfld;
               else;
                  FLDA0200.refFile = '';
                  FLDA0200.refLib  = '';
                  FLDA0200.refFmt  = '';
                  FLDA0200.refFld  = '';
               endif;

            endif;

            // Set additional fields of format FLDA0300
            if   format = 'FLDA0300' or
                 format = 'FLDA0310' or
                 format = 'FLDA0320' or
                 format = 'FLDA0330' or
                 format = 'FLDA0340';
               clear   FLDA0300;
               FLDA0300 = FLDA0200;

               if f_isBitOn(x'80': qdb_qddffld.Qddffldst2);
                  FLDA0300.alwNull = cTrue;
               else;
                  FLDA0300.alwNull = cFalse;
               endif;

               FLDA0300.ccsid = qdb_qddffld.Qddfcsid;
            endif;

            // Set additional fields of format FLDA0310
            if   format = 'FLDA0310' or
                 format = 'FLDA0320' or
                 format = 'FLDA0330' or
                 format = 'FLDA0340';
               clear   FLDA0310;
               FLDA0310 = FLDA0300;

               if isVarying;
                  FLDA0310.varLength  = cTrue;
                  FLDA0310.buffLength = Qdb_Qddffld.Qddffldb;
                  FLDA0310.alcLength  = Qdb_Qddffld.Qddflalc;
               else;
                  FLDA0310.varLength  = cFalse;
                  FLDA0310.buffLength = Qdb_Qddffld.Qddffldb;
                  FLDA0310.alcLength  = Qdb_Qddffld.Qddflalc;
               endif;
            endif;

            // Set additional fields of format FLDA0320
            if   format = 'FLDA0320' or
                 format = 'FLDA0330' or
                 format = 'FLDA0340';
               clear   FLDA0320;
               FLDA0320 = FLDA0310;
               FLDA0320.alias = longFldName;
            endif;

            // Set additional fields of format FLDA0330
            if   format = 'FLDA0330' or
                 format = 'FLDA0340';
               clear   FLDA0330;
               FLDA0330 = FLDA0320;
               FLDA0330.fieldNum = Qdb_Qddfmt.Qddffldnum;
            endif;

            // Set additional fields of format FLDA0340
            if   format = 'FLDA0340';
               clear   FLDA0340;
               FLDA0340 = FLDA0330;
               if (pQdb_Qddfdft = *NULL);
                  FLDA0340.lenDftValue   = 0;
                  FLDA0340.pDftValue     = *NULL;
                  FLDA0340.isDbcsGraphic = cFalse;
                  FLDA0340.isHexLiteral  = cFalse;
                  FLDA0340.isNullDft     = cFalse;
                  FLDA0340.isCurrTime    = cFalse;
                  FLDA0340.hasDtfKeyword = cFalse;
               else;
                  FLDA0340.lenDftValue  =
                        Qdb_Qddfdft.Qddfdftl - %size(Qdb_Qddfdft);
                  FLDA0340.pDftValue    =
                        %addr(Qdb_Qddfdft) + %size(Qdb_Qddfdft);
                  FLDA0340.isDbcsGraphic =
                        f_isBitOn(x'80':Qdb_Qddfdft.Qddfdfta);
                  FLDA0340.isHexLiteral  =
                        f_isBitOn(x'40':Qdb_Qddfdft.Qddfdfta);
                  FLDA0340.isNullDft     =
                        f_isBitOn(x'20':Qdb_Qddfdft.Qddfdfta);
                  FLDA0340.isCurrTime    =
                        f_isBitOn(x'04':Qdb_Qddfdft.Qddfdfta);
                  FLDA0340.hasDtfKeyword =
                        f_isBitOn(x'01':Qdb_Qddfdft.Qddfdfta);
               endif;
            endif;

            // Return format to caller
            select;
            when   format = 'FLDA0100';
               %subst(o_data: 1: si_o_data.currLen) = FLDA0100;
            when   format = 'FLDA0200';
               %subst(o_data: 1: si_o_data.currLen) = FLDA0200;
            when   format = 'FLDA0300';
               %subst(o_data: 1: si_o_data.currLen) = FLDA0300;
            when   format = 'FLDA0310';
               %subst(o_data: 1: si_o_data.currLen) = FLDA0310;
            when   format = 'FLDA0320';
               %subst(o_data: 1: si_o_data.currLen) = FLDA0320;
            when   format = 'FLDA0330';
               %subst(o_data: 1: si_o_data.currLen) = FLDA0330;
            when   format = 'FLDA0340';
               %subst(o_data: 1: si_o_data.currLen) = FLDA0340;
            other;
               %subst(o_data: 1: si_o_data.currLen) = '';
            endsl;

            // Remember last field information
            handle.lastFldNum = fldNum;
            handle.lastFldPtr = pQdb_Qddffld;
         endif;

         return   o_isDone;

      /END-FREE
      *
     P f_FldDct_rtvFldAtr...
     P                 E
      *
      *======================================================================================
      *  Get number of entries available
      *======================================================================================
 DEF  /DEFINE UNDEFINE_ALL
 DEF  /UNDEFINE UNDEFINE_ALL
      *
     P f_FldDct_getNumE...
     P                 B                   export
      *
     D f_FldDct_getNumE...
     D                 PI            10I 0
     D  i_handle                           const  like(fldDct_handle_t)
      *
      *  Return value
     D numEntries      S             10I 0 inz
      *
      *  Handle
     D handle          DS                  likeds(handle_t  )  based(pHandle)
      *
      *  Format Definition Header (Qdb_Qddfmt)
     D Qdb_Qddfmt      DS                  likeds(Qdb_Qddfmt_t)
     D                                     based(pQdb_Qddfmt )
      * ---------------------------------------------------------
      *
      /FREE

         // Einblenden Handle
         pHandle = i_handle;

         // Ermöglichen Zugriff auf "Format Definition Header"
         pQdb_Qddfmt = handle.pointer;

         // Ermitteln Anzahl Felder
         numEntries = Qdb_Qddfmt.Qddffldnum;

         return   numEntries;

      /END-FREE
      *
     P f_FldDct_getNumE...
     P                 E
      *
      *======================================================================================
      *  Returns cTrue if a given handle is NULL, else cFalse.
      *======================================================================================
 DEF  /DEFINE UNDEFINE_ALL
 DEF  /UNDEFINE UNDEFINE_ALL
      *
     P f_FldDct_isNull...
     P                 B                   export
      *
     D f_FldDct_isNull...
     D                 PI              N
     D  i_handle                           const  like(fldDct_handle_t)
      *
      *  Handle
     D handle          DS                  likeds(handle_t  )  based(pHandle)
      * ---------------------------------------------------------
      *
      /FREE

         if (i_handle = *NULL);
            return cTrue;
         else;
            return cFalse;
         endif;

      /END-FREE
      *
     P f_FldDct_isNull...
     P                 E
      *
      *======================================================================================
      *  Returns a NULL handle.
      *======================================================================================
 DEF  /DEFINE UNDEFINE_ALL
 DEF  /UNDEFINE UNDEFINE_ALL
      *
     P f_FldDct_null...
     P                 B                   export
      *
     D f_FldDct_null...
     D                 PI                         like(fldDct_handle_t)
      * ---------------------------------------------------------
      *
      /FREE

         return *NULL;

      /END-FREE
      *
     P f_FldDct_null...
     P                 E
      *
      *==================================================================*
      *  Convert internal data type to external representation
      *==================================================================*
      *
     P f_intToExtDataType...
     P                 B
      *
     D f_intToExtDataType...
     D                 PI             1A
     D  i_intDataType                 2A   const
      *
      *  Return value
     D o_extDataType   S              1A   inz
      *-------------------------------------------------------------------
      /FREE

         select;
         // Binary
         when   i_inTDataType = X'0000';
            o_extDataType = cFLDDCT_TYPE_BINARY;
         // Float
         when   i_inTDataType = X'0001';
            o_extDataType = cFLDDCT_TYPE_FLOAT;
         // Zoned decimal
         when   i_inTDataType = X'0002';
            o_extDataType = cFLDDCT_TYPE_ZONED;
         // Packed decimal
         when   i_inTDataType = X'0003';
            o_extDataType = cFLDDCT_TYPE_PACKED;
         // Character
         when   i_inTDataType = X'0004';
            o_extDataType = cFLDDCT_TYPE_CHAR;
         // Var Character
         when   i_inTDataType = X'8004';
            o_extDataType = cFLDDCT_TYPE_CHAR;
         // Graphic
         when   i_inTDataType = X'0005';
            o_extDataType = cFLDDCT_TYPE_GRAPHIC;
         // DBCS-capable (not yet supported)
         when   i_inTDataType = X'0006';
            o_extDataType = cFLDDCT_TYPE_ERROR;
         // Large object CLOB/BLOB
         when   i_inTDataType = X'4004';
            o_extDataType = cFLDDCT_TYPE_LOB;
         // Var graphic
         when   i_inTDataType = X'8005';
            o_extDataType = cFLDDCT_TYPE_GRAPHIC;
         // Var DBCS-capable (not yet supported)
         when   i_inTDataType = X'8006';
            o_extDataType = cFLDDCT_TYPE_ERROR;
         // Date
         when   i_inTDataType = X'000B';
            o_extDataType = cFLDDCT_TYPE_DATE;
         // Time
         when   i_inTDataType = X'000C';
            o_extDataType = cFLDDCT_TYPE_TIME;
         // Timestamp
         when   i_inTDataType = X'000D';
            o_extDataType = cFLDDCT_TYPE_TMSTMP;
         // NULL (not yet supported)
         when   i_inTDataType = X'FFFF';
            o_extDataType = cFLDDCT_TYPE_ERROR;
         // unknown data type
         other;
            o_extDataType = cFLDDCT_TYPE_ERROR;
         endsl;

         return   o_extDataType;

      /END-FREE
      *
     P f_intToExtDataType...
     P                 E
      *
      *==================================================================*
      *  Convert internal usage to to external representation
      *==================================================================*
      *
     P f_intToExtUsage...
     P                 B
      *
     D f_intToExtUsage...
     D                 PI             1A
     D  i_intUsage                    1A   const
      *
      *  Return value
     D o_extUsage      S              1A   inz
      *-------------------------------------------------------------------
      /FREE

         select;
         // Input
         when   i_intUsage = X'01';
            o_extUsage = cFLDDCT_USE_INPUT;
         // Output
         when   i_intUsage = X'02';
            o_extUsage = cFLDDCT_USE_OUTPUT;
         // Both input and output
         when   i_intUsage = X'03';
            o_extUsage = cFLDDCT_USE_BOTH;
         // Neither
         when   i_intUsage = X'04';
            o_extUsage = cFLDDCT_USE_NEITHER;
         // unbekannte Verwendung
         other;
            o_extUsage = cFLDDCT_USE_ERROR;
         endsl;

         return   o_extUsage;

      /END-FREE
      *
     P f_intToExtUsage...
     P                 E
      *
      *==================================================================*
      *  Convert internal date/time format to external representation
      *==================================================================*
      *
     P f_intToExtDatTimFmt...
     P                 B
      *
     D f_intToExtDatTimFmt...
     D                 PI             4A
     D  i_intDataType                 2A   const
     D  i_intFmt                      1A   const
      *
      *  Return value
     D o_extFmt        S              4A   inz
      *-------------------------------------------------------------------
      /FREE

         if   i_intDataType = X'000B'   or   // = Date
              i_intDataType = X'000C'   or   // = Time
              i_intDataType = X'000D';       // = Timestamp

         select;
            // The format associated with the job
            when   i_intFmt = X'FE';
               o_extFmt = cFLDDCT_DTFMT_JOB;
            // The format associated with the QDT
            when   i_intFmt = X'FF';
               o_extFmt = cFLDDCT_DTFMT_QDT;
            // *USA
            when   i_intFmt = X'01';
               o_extFmt = cFLDDCT_DTFMT_USA;
            // *ISO
            when   i_intFmt = X'03';
               o_extFmt = cFLDDCT_DTFMT_ISO;
            // *EUR
            when   i_intFmt = X'05';
               o_extFmt = cFLDDCT_DTFMT_EUR;
            // *JIS
            when   i_intFmt = X'07';
               o_extFmt = cFLDDCT_DTFMT_JIS;
            // SAA Timestamp
            when   i_intFmt = X'09';
               o_extFmt = cFLDDCT_DTFMT_SAA;
            // *MDY
            when   i_intFmt = X'17';
               o_extFmt = cFLDDCT_DTFMT_MDY;
            // *DMY
            when   i_intFmt = X'18';
               o_extFmt = cFLDDCT_DTFMT_DMY;
            // *YMD
            when   i_intFmt = X'19';
               o_extFmt = cFLDDCT_DTFMT_YMD;
            // *JUL
            when   i_intFmt = X'1A';
               o_extFmt = cFLDDCT_DTFMT_JUL;
            // *HMS
            when   i_intFmt = X'1B';
               o_extFmt = cFLDDCT_DTFMT_HMS;
            // CMDY
            when   i_intFmt = X'25';
               o_extFmt = cFLDDCT_DTFMT_CMDY;
            // CDMY
            when   i_intFmt = X'26';
               o_extFmt = cFLDDCT_DTFMT_CDMY;
            // CYMD
            when   i_intFmt = X'27';
               o_extFmt = cFLDDCT_DTFMT_CYMD;
            // MDYY
            when   i_intFmt = X'28';
               o_extFmt = cFLDDCT_DTFMT_MDYY;
            // *DMYY
            when   i_intFmt = X'29';
               o_extFmt = cFLDDCT_DTFMT_DMYY;
            // *YYMD
            when   i_intFmt = X'2A';
               o_extFmt = cFLDDCT_DTFMT_YYMD;
            // *YM
            when   i_intFmt = X'2B';
               o_extFmt = cFLDDCT_DTFMT_YM;
            // *MY
            when   i_intFmt = X'2C';
               o_extFmt = cFLDDCT_DTFMT_MY;
            // *YYM
            when   i_intFmt = X'2D';
               o_extFmt = cFLDDCT_DTFMT_YYM;
            // *MYY
            when   i_intFmt = X'2E';
               o_extFmt = cFLDDCT_DTFMT_MYY;
            // *LONGJUL
            when   i_intFmt = X'30';
               o_extFmt = cFLDDCT_DTFMT_LONGJUL;
            // unbekanntes Format
            other;
               o_extFmt = cFLDDCT_DTFMT_ERROR;
            endsl;

         else;
            o_extFmt = '';
         endif;

         return   o_extFmt;

      /END-FREE
      *
     P f_intToExtDatTimFmt...
     P                 E
      *
      *==================================================================*
      *  Convert internal date/time separator to external representation
      *==================================================================*
      *
     P f_intToExtDatTimSep...
     P                 B
      *
     D f_intToExtDatTimSep...
     D                 PI             1A
     D  i_intDataType                 2A   const
     D  i_intSep                      1A   const
      *
      *  Return value
     D o_extSep        S              1A   inz
      *-------------------------------------------------------------------
      /FREE

         if   i_intDataType = X'000B'   or   // = Date
              i_intDataType = X'000C'   or   // = Time
              i_intDataType = X'000D';       // = Timestamp

            select;
            // The format associated with the job
               when   i_intSep = X'00';
                  o_extSep = cFLDDCT_DTSEP_JOB;
            // The implied separator is used
               when   i_intSep = X'EE';
                  o_extSep = cFLDDCT_DTSEP_IMPL;
            // The slash ('/') ist used
               when   i_intSep = '/';
                  o_extSep = cFLDDCT_DTSEP_SLASH;
            // The dash ('-') ist used
               when   i_intSep = '-';
                  o_extSep = cFLDDCT_DTSEP_DASH;
            // The period ('.') ist used
               when   i_intSep = '.';
                  o_extSep = cFLDDCT_DTSEP_PERIOD;
            // The blank (' ') ist used
               when   i_intSep = ' ';
                  o_extSep = cFLDDCT_DTSEP_BLANK;
            // The colon (':') ist used
               when   i_intSep = ':';
                  o_extSep = cFLDDCT_DTSEP_COLON;
            // unknown date/time separator
               other;
                  o_extSep = cFLDDCT_DTSEP_ERROR;
            endsl;

         else;
            o_extSep = '';
         endif;

         return   o_extSep;

      /END-FREE
      *
     P f_intToExtDatTimSep...
     P                 E
      *
