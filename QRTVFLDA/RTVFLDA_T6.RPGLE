      *=====================================================================*
      *  Author  :  Thomas Raddatz                                          *
      *  Date    :  17.10.2013                                              *
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
     H EXTBININT(*YES)
     H DATFMT(*ISO) TIMFMT(*ISO) DEBUG(*YES)
      *=====================================================================*
      *
      /COPY QRTVFLDA,PRTVFLDA
      *
      *  *ENTRY list
     D RTVFLDA_T...
     D                 PR                  extpgm('RTVFLDA_T6')
     D  gi_file                      10A   const
     D  gi_fldName                   10A   const
      *
      *  Internal prototypes
     D main...
     D                 PR
     D  i_file                       10A   const
     D  i_fldName                    10A   const
      *
      ********************************************************************
      *  Program Entry Point
      ********************************************************************
      *
     D RTVFLDA_T...
     D                 PI
     D  gi_file                      10A   const
     D  gi_fldName                   10A   const
      *-------------------------------------------------------------------
      /FREE
         main(gi_file: gi_fldName);

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
     D  i_fldName                    10A   const
      *
      *  Local fields
     D isOK            S               N   inz
     D handle          S                   like(fldDct_handle_t) inz
      *
     D msg             DS                  likeds(msg_t        ) inz
     D errMsg          DS                  likeds(msg_t        ) inz
     D flda0340        DS                  likeds(flda0340_t   ) inz
     D default         S            128A   based(flda0340.pDftValue)
      *-------------------------------------------------------------------
      /FREE

         errMsg = f_newMsg(cMSG_ID_OK);

         dou '1';

            // Open dictionary
            isOK = f_fldDct_new(i_file: '*LIBL': '*FIRST': handle: msg);

            // Get attributes of i_fldName
            isOK = f_FldDct_rtvFldAtr(handle: i_fldName: flda0340: 'FLDA0340');
            if (isOK);
               select;
               when (flda0340.isNullDft);
                  msg = f_newMsg('CPF9897'
                                 : 'Field ' + %trim(flda0340.name) +
                                   ', Default is NULL');
               when (flda0340.isCurrTime);
                  msg = f_newMsg('CPF9897'
                                 : 'Field ' + %trim(flda0340.name) +
                                   ', Default is CURRENT_TIME');
               when (flda0340.hasDtfKeyword);
                  if (%subst(default: 1: flda0340.lenDftValue) = 'USER');
                     msg = f_newMsg('CPF9897'
                                    : 'Field ' + %trim(flda0340.name) +
                                      ', Default is CURRENT_USER');
                  else;
                     msg = f_newMsg('CPF9897'
                                 : 'Field ' + %trim(flda0340.name) +
                                   ', Default is ' +
                                      %subst(default: 1: flda0340.lenDftValue));
                  endif;
               other;
                  msg = f_newMsg('CPF9897'
                                 : 'Field ' + %trim(flda0340.name) +
                                   ', has no default value');
               endsl;
               f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
            else;
               errMsg = f_newMsg('CPF9898'
                              : 'Field not found'
                              : cMSG_ESCAPE);
               leave;
            endif;

         enddo;

         // Close dictionary
         isOK = f_FldDct_delete(handle);

         if (errMsg.ID <> cMSG_ID_OK);
            f_sndPgmMsg(errMsg: cMsg_Prv: cMsg_ToCtlBdy);
         endif;

         return;

      /END-FREE
      *
     P                 E
      *
