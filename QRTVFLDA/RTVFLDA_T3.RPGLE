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
dcl-f INFILE disk(32766) usropn extfile(g_theFileToOpen);

dcl-s g_theFileToOpen char(10) inz;
dcl-ds g_inBuffer len(32766);
end-ds;

/copy QRTVFLDA,PRTVFLDA

//  *ENTRY list
dcl-pr RTVFLDA_T extpgm('RTVFLDA_T3');
  gi_file char(10) const;
  gi_rrn  packed(15: 5) const;
end-pr;

//  Internal prototypes
dcl-pr main;
  i_file char(10) const;
  i_rrn  uns(10) const;
end-pr;

//*******************************************************************
//  Program Entry Point
//*******************************************************************
dcl-pi RTVFLDA_T;
  gi_file char(10) const;
  gi_rrn  packed(15: 5) const;
end-pi;
//-------------------------------------------------------------------

main(gi_file: gi_rrn);

*inlr = *ON;


//==================================================================*
//  Main procedure
//==================================================================*
dcl-proc main export;
  dcl-pi *n;
    i_file char(10) const;
    i_rrn  uns(10) const;
  end-pi;

  //  Local fields
  dcl-s isOK ind inz;
  dcl-s handle like(fldDct_handle_t) inz;

  dcl-ds msg likeds(msg_t) inz;
  dcl-ds flda0100 likeds(flda0100_t) inz;

  dcl-s data char(8196) inz;
  dcl-s pNumData pointer inz;
  dcl-s precision int(10) inz;
  //-------------------------------------------------------------------

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
  isOK = f_FldDct_rtvFldAtr(handle: cFLDDCT_FLD_FIRST: flda0100);

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
    isOK = f_FldDct_rtvFldAtr(handle: cFLDDCT_FLD_NEXT: flda0100);
  enddo;

  // Close dictionary
  isOK = f_FldDct_delete(handle);

  // Close file
  close INFILE;

  return;


end-proc;

