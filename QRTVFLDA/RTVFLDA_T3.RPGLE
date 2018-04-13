      *=====================================================================*
      *  Author  :  Thomas Raddatz                                          *
      *  Date    :  25.09.2002                                              *
      *  E-mail  :  thomas.raddatz@tools400.de                              *
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
      *  History:                                                           *
      *                                                                     *
      *  Datum       Name          Änderung                                 *
      *  ----------  ------------  ---------------------------------------  *
      *  15.06.2012  Th.Raddatz    Changed program to /FREE.                *
      *                                                                     *
      *=====================================================================*
      *   >>PRE-COMPILER<<                                                  *
      *                                                                     *
      *     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                      *
      *                              SRCFILE(&SL/&SF) +                     *
      *                              SRCMBR(&SM);                           *
      *                                                                     *
      *     >>COMPILE<<                                                     *
      *       >>PARM<< TRUNCNBR(*NO);                                       *
      *       >>PARM<< DBGVIEW(*LIST);                                      *
      *     >>END-COMPILE<<                                                 *
      *                                                                     *
      *     >>EXECUTE<<                                                     *
      *                                                                     *
      *     >>CMD<<     CRTPGM       PGM(&LI/&OB) +                         *
      *                              MODULE(*PGM) +                         *
      *                              BNDSRVPGM(&LI/RTVFLDA BASICS1) +       *
      *                              ACTGRP(*NEW) +                         *
      *                              DETAIL(*BASIC);                        *
      *                                                                     *
      *   >>END-PRE-COMPILER<<                                              *
      *=====================================================================*
     H BNDDIR('QC2LE')
     H EXTBININT(*YES)
     H DATFMT(*ISO) TIMFMT(*ISO) DEBUG(*YES)
      *=====================================================================*
     FINFILE    IF   F32766        DISK    usropn
     F                                     extfile(g_theFileToOpen)
      *
     D g_theFileToOpen...
     D                 S             10A   inz
     D g_inBuffer      DS         32766
      *
      /COPY QRTVFLDA,PRTVFLDA
      *
      *  *ENTRY list
     D RTVFLDA_T...
     D                 PR                  extpgm('RTVFLDA_T3')
     D  gi_file                      10A   const
     D  gi_rrn                       15P 5 const
      *
      *  Internal prototypes
     D main...
     D                 PR
     D  i_file                       10A   const
     D  i_rrn                        10U 0 const
      *
      ********************************************************************
      *  Program Entry Point
      ********************************************************************
     D RTVFLDA_T...
     D                 PI
     D  gi_file                      10A   const
     D  gi_rrn                       15P 5 const
      *-------------------------------------------------------------------
      /FREE

         main(gi_file: gi_rrn);

         *inlr = *ON;

      /END-FREE
      *
      *==================================================================*
      *  Main procedure
      *==================================================================*
     P main...
     P                 B                   export
     D                 PI
     D  i_file                       10A   const
     D  i_rrn                        10U 0 const
      *
      *  Local fields
     D isOK            S               N   inz
     D handle          S                   like(fldDct_handle_t) inz
      *
     D msg             DS                  likeds(msg_t        ) inz
     D flda0100        DS                  likeds(flda0100_t   ) inz
     D fldAttr         S                   like(flda0100       ) inz
      *
     D data            S           8196A   inz
     D pNumData        S               *   inz
     D precision       S             10I 0 inz
      *-------------------------------------------------------------------
      /FREE

         // Open file
         g_theFileToOpen = i_file;
         open INFILE;

         // Read record to disply
         chain i_rrn INFILE g_inBuffer;
         if (not %found(INFILE));
            close INFILE;
            msg = f_newMsg('CPF9898': 'Record not found': cMSG_ESCAPE);
            f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
         endif;

         // Open dictionary of file
         isOK = f_fldDct_new(i_file: '*LIBL': '*FIRST': handle: msg);

         // Spin through field list ...
         // ... get first field
         isOK = f_FldDct_rtvFldAtr(handle: cFLDDCT_FLD_FIRST: fldAttr);

         flda0100 = fldAttr;

         dow isOK;

            // ... get field data from buffer ...
            select;
            // ... alpha-numeric
            when (flda0100.type = 'A');
               data = %subst(g_inBuffer: flda0100.inbufpos: flda0100.length);
            // ... binary/integer
            when (flda0100.type = 'B');
               // ... get raw field data
               pNumData = %addr(g_inBuffer) + flda0100.inbufpos - 1;

               // ... edit data
               select;
               when (flda0100.length = 1);
                  precision = 3;
               when (flda0100.length = 2);
                  precision = 5;
               when (flda0100.length = 4);
                  precision = 10;
               other;
                  precision = 20;
               endsl;
               data = f_editcode(pNumData: precision: 0: flda0100.type: 'X');
            // ... date
            when (flda0100.type = 'L');
               data = %subst(g_inBuffer: flda0100.inbufpos: flda0100.length);
            // ... time
            when (flda0100.type = 'T');
               data = %subst(g_inBuffer: flda0100.inbufpos: flda0100.length);
            // ... timestamp
            when (flda0100.type = 'Z');
               data = %subst(g_inBuffer: flda0100.inbufpos: flda0100.length);
            // ... packed
            when (flda0100.type = 'P');
               // ... get raw field data
               pNumData = %addr(g_inBuffer) + flda0100.inbufpos - 1;

               // ... edit data
               data = f_editcode(pNumData: flda0100.digits
                                 : flda0100.decpos: flda0100.type: 'J');
            // ... zoned
            when (flda0100.type = 'S');
               // ... get raw field data
               pNumData = %addr(g_inBuffer) + flda0100.inbufpos - 1;

               // ... edit data
               data = f_editcode(pNumData: flda0100.digits
                                 : flda0100.decpos: flda0100.type: 'J');
            other;
               data = '';
            endsl;

            // ... show field data
            msg = f_newMsg('CPF9897': flda0100.name + ': ' + data);
            f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

            // ... get next field
            isOK = f_FldDct_rtvFldAtr(handle: cFLDDCT_FLD_NEXT: fldAttr);
            flda0100 = fldAttr;
         enddo;

         // Close dictionary
         isOK = f_FldDct_delete(handle);

         // Close file
         close INFILE;

         return;

      /END-FREE
      *
     P                 E
      *
