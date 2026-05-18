**free
//=====================================================================*
//  Author  :  Thomas Raddatz                                          *
//  Date    :  17.10.2013                                              *
//  E-mail  :  thomas.raddatz@tools400.de                              *
//  Homepage:  www.tools400.de                                         *
//=====================================================================*
//                                                                     *
//  This software is free software, you can redistribute it and/or     *
//  modify it under the terms of the GNU General Public License (GPL)  *
//  as published by the Free Software Foundation.                      *
//                                                                     *
//  See GNU General Public License for details.                        *
//          http://www.opensource.org                                  *
//          http://www.opensource.org/licenses/gpl-license.html        *
//                                                                     *
//=====================================================================*
//  History:                                                           *
//                                                                     *
//  Datum       Name          nderung                                 *
//  ----------  ------------  ---------------------------------------  *
//                                                                     *
//=====================================================================*
//   >>PRE-COMPILER<<                                                  *
//     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                      *
//                              SRCFILE(&SL/&SF) +                     *
//                              SRCMBR(&SM);                           *
//     >>COMPILE<<                                                     *
//       >>PARM<< OPTION(*EVENTF);                                     *
//       >>PARM<< TRUNCNBR(*NO);                                       *
//       >>PARM<< DBGVIEW(*LIST);                                      *
//     >>END-COMPILE<<                                                 *
//     >>EXECUTE<<                                                     *
//     >>CMD<<     CRTPGM       PGM(&LI/&OB) +                         *
//                              MODULE(*PGM) +                         *
//                              BNDSRVPGM(&LI/RTVFLDA BASICS1) +       *
//                              ACTGRP(*NEW) +                         *
//                              DETAIL(*BASIC);                        *
//   >>END-PRE-COMPILER<<                                              *
//=====================================================================*
ctl-opt extbinint(*yes);
ctl-opt datfmt(*iso) timfmt(*iso) debug(*yes);
//=====================================================================*

/copy QRTVFLDA,PRTVFLDA

//  *ENTRY list
dcl-pr RTVFLDA_T extpgm('RTVFLDA_T6');
  gi_file    char(10) const;
  gi_fldName char(10) const;
end-pr;

//  Internal prototypes
dcl-pr main;
  i_file    char(10) const;
  i_fldName char(10) const;
end-pr;

//*******************************************************************
//  Program Entry Point
//*******************************************************************
dcl-pi RTVFLDA_T;
  gi_file    char(10) const;
  gi_fldName char(10) const;
end-pi;
//-------------------------------------------------------------------
main(gi_file: gi_fldName);

*inlr = *ON;


//==================================================================*
//  Main procedure
//==================================================================*
dcl-proc main export;
  dcl-pi *n;
    i_file    char(10) const;
    i_fldName char(10) const;
  end-pi;

  //  Local fields
  dcl-s isOK ind inz;
  dcl-s handle like(fldDct_handle_t) inz;

  dcl-ds msg likeds(msg_t) inz;
  dcl-ds errMsg likeds(msg_t) inz;
  dcl-ds flda0340 likeds(flda0340_t) inz;
  dcl-s default char(128) based(flda0340.pDftValue);
  //-------------------------------------------------------------------

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


end-proc;

