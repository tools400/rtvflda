**free
//=====================================================================*
//  Author  :  Thomas Raddatz                                          *
//  Date    :  25.09.2002                                              *
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
//  15.06.2012  Th.Raddatz    Changed program to /FREE.                *
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
dcl-pr RTVFLDA_T extpgm('RTVFLDA_T4');
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
  dcl-ds flda0300 likeds(flda0300_t) inz;
  //-------------------------------------------------------------------

  errMsg = f_newMsg(cMSG_ID_OK);

  dou '1';

    // Open dictionary
    isOK = f_fldDct_new(i_file: '*LIBL': '*FIRST': handle: msg);

    // Get attributes of i_fldName
    isOK = f_FldDct_rtvFldAtr(handle: i_fldName: flda0300: 'FLDA0300');
    if (isOK);
      msg = f_newMsg('CPF9897'
                     : 'Field ' + %trim(flda0300.name) +
                       ', ALWNULL is ' + FLDA0300.ALWNULL +
                       ' CCSID is ' + %CHAR(FLDA0300.CCSID));
      f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
    else;
      errMsg = f_newMsg('CPF9898'
                     : 'Field not found'
                     : cMSG_ESCAPE);
      leave;
    endif;

    // Get attributes of previous field
    isOK = f_FldDct_rtvFldAtr(
                    handle: cFLDDCT_FLD_PREV: flda0300: 'FLDA0300');
    if (isOK);
      msg = f_newMsg('CPF9897'
                     : 'Previous field ' + %trim(flda0300.name) +
                       ', ALWNULL is ' + FLDA0300.ALWNULL +
                       ' CCSID is ' + %CHAR(FLDA0300.CCSID));
      f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
    else;
      msg = f_newMsg('CPF9897'
                     : i_fldName +
                       ' is the first field of the record.');
      f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
    endif;

    // Position back to i_fldName
    isOK = f_FldDct_rtvFldAtr(handle: i_fldName: flda0300: 'FLDA0300');

    // Get attributes of next field
    isOK = f_FldDct_rtvFldAtr(
                    handle: cFLDDCT_FLD_NEXT: flda0300: 'FLDA0300');
    if (isOK);
      msg = f_newMsg('CPF9897'
                     : 'Next field ' + %trim(flda0300.name) +
                       ', ALWNULL is ' + FLDA0300.ALWNULL +
                       ' CCSID is ' + %CHAR(FLDA0300.CCSID));
      f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
    else;
      msg = f_newMsg('CPF9897'
                     : i_fldName +
                       ' is the last field of the record.');
      f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
    endif;

    // Get attributes of first field of record
    isOK = f_FldDct_rtvFldAtr(
                    handle: cFLDDCT_FLD_FIRST: flda0300: 'FLDA0300');
    if (isOK);
      msg = f_newMsg('CPF9897'
                     : 'First field ' + %trim(flda0300.name) +
                       ', ALWNULL is ' + FLDA0300.ALWNULL +
                       ' CCSID is ' + %CHAR(FLDA0300.CCSID));
      f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
    else;
      msg = f_newMsg('CPF9898'
                     : 'Failed retrieving attributes of first field'
                     : cMSG_ESCAPE);
      leave;
    endif;

    // Get attributes of last field of record
    isOK = f_FldDct_rtvFldAtr(
                    handle: cFLDDCT_FLD_LAST: flda0300: 'FLDA0300');
    if (isOK);
      msg = f_newMsg('CPF9897'
                     : 'Last field ' + %trim(flda0300.name) +
                       ', ALWNULL is ' + FLDA0300.ALWNULL +
                       ' CCSID is ' + %CHAR(FLDA0300.CCSID));
      f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
    else;
      msg = f_newMsg('CPF9898'
                     : 'Failed retrieving attributes of last field'
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

