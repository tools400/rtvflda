**free
//=====================================================================
//  Test program IDENtity column:
//=====================================================================
//  Command to create the service program:
//  RUCRTRPG TSTPGM(RPGUNIT/TEMPLATE) SRCFILE(RPGUNIT/QSRC)
//=====================================================================
//  Tools/400 STRPREPRC instructions:
//   >>PRE-COMPILER<<
//     >>CRTCMD<<  RUCRTRPG    TSTPGM(&LI/&OB) +
//                             SRCFILE(&SL/&SF) +
//                             SRCMBR(&SM);
//     >>COMPILE<<
//       >>PARM<< POPTION(*EVENTF);
//       >>PARM<< RPGPPOPT(*LVL2);
//       >>PARM<< DBGVIEW(*NONE);
//       >>PARM<< COMPILEOPT('DBGVIEW(*LIST)');
//       >>PARM<< BNDSRVPGM(RTVFLDA);
//     >>END-COMPILE<<
//     >>EXECUTE<<
//   >>END-PRE-COMPILER<<
//=====================================================================
//  Compile options:
//    *SrcStmt       - Assign SEU line numbers when compiling the
//                     source member. This option is required to
//                     position the LPEX editor to the line in error
//                     when the source member is opened from the
//                     RPGUnit view.
//    *NoDebugIO     - Do not generate breakpoints for input and
//                     output specifications. Optional but useful.
//=====================================================================
ctl-opt NoMain Option(*SrcStmt : *NoDebugIO);
dcl-f QSYSPRT printer(80) oflind(*in70) usropn;

/include qinclude,TESTCASE                  iRPGUnit Test Suite

/include qrtvflda,PRTVFLDA
/include qinclude,TESTCASE                  iRPGUnit Test Suite

exec sql
  set option commit = *none;

// ------------------------------------------------------------
//  Global type templates.
// ------------------------------------------------------------

//dcl-ds errCode_t qualified template;
//  bytPrv       int(10) inz(%size(errCode_t));
//  bytAvl       int(10) inz;
//  excId        char(7) inz;
//  reserved_1   char(1) inz;
//  excDta       char(100) inz;
//end-ds;

dcl-ds sql_status_t qualified template;
  ignSQLWarn ind inz(*off);
end-ds;

// ------------------------------------------------------------
//  Global Program Status.
// ------------------------------------------------------------

dcl-ds g_status qualified;
  srcSeq int(10);
  srcSeq2 int(10);
  sql likeds(sql_status_t) inz(*likeds);
end-ds;

// ============================================================
//  Opens the printer.
// ============================================================
dcl-proc openPrinter;
  dcl-pi *n extproc(*dclcase) end-pi;

  open QSYSPRT;

end-proc;

// ============================================================
//  Prints a message.
// ============================================================
dcl-proc print;
  dcl-pi *n extproc(*dclcase);
    text varchar(128) value options(*nopass);
  end-pi;

  dcl-ds lineOutput len(80);
  end-ds;

  if (%parms() >= 1);
    lineOutput = text;
  else;
    lineOutput = '';
  endif;
  write QSYSPRT lineOutput;

end-proc;

// ============================================================
//  Prints the IDENTITY column.
// ============================================================
dcl-proc printIdyCol export;
  dcl-pi *n extproc(*dclcase);
    i_flda0350 likeds(flda0350_t) const;
  end-pi;

  print('Column: ' + %trim(i_flda0350.name) + ' is an IDENTITY column');
  print('  START VALUE  ' + %char(i_flda0350.orgStrValue));
  print('    CURRENT    ' + %char(i_flda0350.currStrValue));
  print('  INCREMENT BY ' + %char(i_flda0350.incValue));
  print('  MIN VALUE    ' + %char(i_flda0350.minValue));
  print('  MAX VALUE    ' + %char(i_flda0350.maxValue));
  print('  CACHE        ' + %char(i_flda0350.numCache));
  print('  CYCLE        ' + %char(i_flda0350.isCycling));
  print('  ORDER        ' + %char(i_flda0350.isOrdering));

end-proc;

// ============================================================
//  Prints a non-identity column.
// ============================================================
dcl-proc printCol export;
  dcl-pi *n extproc(*dclcase);
    i_flda0350 likeds(flda0350_t) const;
  end-pi;

  print('Column: ' + %trim(i_flda0350.name));

end-proc;

// ============================================================
//  Closes the printer.
// ============================================================
dcl-proc closePrinter;
  dcl-pi *n extproc(*dclcase) end-pi;

  if (%open(QSYSPRT));
    close QSYSPRT;
  endif;

end-proc;

// ------------------------------------------------------------
//  Specifies whether SQL warnings are ignored when
//  calling isSQLError().
// ------------------------------------------------------------
dcl-proc setIgnSQLWarn;
  dcl-pi *n extproc(*dclcase);
    i_ignore ind const;
  end-pi;

  g_status.sql.ignSQLWarn = i_ignore;

end-proc;

// ------------------------------------------------------------
//  Returns *on, when the last SQL statement ended with an
//  error, else *off;
// ------------------------------------------------------------
dcl-proc isSQLError;
  dcl-pi *n ind extproc(*dclcase);
    i_state   char(5) const;
  end-pi;

  dcl-ds sqlState qualified;
    class char(2);
    qualifier char(3);
  end-ds;

  dcl-ds sql likeds(sql_status_t);

  sqlState = i_state;
  sql = g_status.sql;

  reset g_status.sql;

  select;
  // SQL code 00: Unqualified Successful Completion
  when (sqlState = '00000');
    // Execution of the operation was successful and did not
    // result in any type of warning or exception condition.
    return *off;

  // SQL code 01: Warning
  When (sqlState.class = '01');
    // Valid warning SQLSTATEs returned by an SQL routine.
    // Also used for RAISE_ERROR and SIGNAL.
    if (sql.ignSQLWarn);
      return *off;
    else;
      return *on;
    endif;

  // SQL code 02: No data
  When (sqlState = '02000');
    return *off;

  other;
    // Other problem or error
    return *on;
  endsl;

end-proc;

// ------------------------------------------------------------
//  Returns *ON, when the specified object exists, eöse *OFF.
// ------------------------------------------------------------
dcl-proc exist;
  dcl-pi *n ind extproc(*dclcase);
    i_lib varchar(10) const;
    i_obj varchar(10) const;
    i_type varchar(10) const;
    i_mbr varchar(10) options(*nopass: *omit) const;
  end-pi;

  // Retrieve Object Description (QUSROBJD) API
  dcl-pr QUSROBJD extpgm('QUSROBJD');
    o_rcvVar     char(65535) options(*varsize);
    i_lenRcvVar  int(10)     const;
    i_format     char(8)     const;
    i_qObj       char(20)    const;
    i_type       char(10)    const;
    io_errCode   char(65535) options(*nopass: *varsize);
  end-pr;

  dcl-ds objd0100 qualified;
    bytRet       int(10);
    bytAvl       int(10);
    name         char(10);
    lib          char(10);
    type         char(10);
    rtnLib       char(10);
    auxStgP      int(10);
    owner        char(10);
    domain       char(2);
    crtDatTim    char(13);
    chgDatTim    char(13);
  end-ds;

  // Retrieve Member Description (QUSRMBRD) API
  dcl-pr QUSRMBRD extpgm('QUSRMBRD');
    o_rcvVar     char(65535) options(*varsize);
    i_lenRcvVar  int(10)     const;
    i_format     char(8)     const;
    i_qFile      char(20)    const;
    i_mbr        char(10)    const;
    i_ovrPrc     char(1)     const;
    io_errCode   char(65535) options(*nopass: *varsize);
  end-pr;

  dcl-ds mbrd0100 qualified;
    bytRet       int(10);
    bytAvl       int(10);
    file         char(10);
    lib          char(10);
    mbr          char(10);
    attr         char(10);
    srcType      char(10);
    crtDatTim    char(13);
    srcChgDatTim char(13);
    text         char(50);
    isSrcFile    char(1);
  end-ds;

  dcl-ds errCode likeds(errCode_t) inz;

  dcl-ds qObj qualified;
    name         char(10);
    lib          char(10);
  end-ds;

  clear qObj;
  qObj.name = i_obj;
  qObj.lib = i_lib;

  clear errCode;
  errCode.bytPrv = %size(errCode);

  if (i_type = '*FILE' and %parms() >= %parmnum(i_mbr));
    QUSRMBRD(mbrd0100: %size(mbrd0100): 'MBRD0100': qObj: i_mbr: '0': errCode);
  else;
    QUSROBJD(objd0100: %size(objd0100): 'OBJD0100': qObj: i_type: errCode);
  endif;

  return errCode.bytAvl = 0;

end-proc;

// ============================================================
//  Set up test suite. Executed once per RUCALLTST.
// ============================================================
dcl-proc setUpSuite export;
  dcl-pi *n extproc(*dclcase) end-pi;

  dcl-s rc char(1);

  runCmd('OVRPRTF FILE(QSYSPRT) TOFILE(*FILE) +
          SPLFNAME(IDYCOL) OVRSCOPE(*ACTGRPDFN)');
  openPrinter();

  // Remove the QSYSPRT override.
  runCmd('DLTOVR FILE(QSYSPRT) LVL(*ACTGRPDFN)');

end-proc;

// ============================================================
//  Tear down test suite.
// ============================================================
dcl-proc tearDownSuite export;
  dcl-pi *n extproc(*dclcase) end-pi;

  closePrinter();

end-proc;

// ============================================================
//  Set up test case.
// ============================================================
dcl-proc setUp export;
  dcl-pi *n extproc(*dclcase) end-pi;

  if (exist('QTEMP': 'IDYCOL': '*FILE'));
    runCmd('DLTF FILE(QTEMP/IDYCOL)');
  endif;

end-proc;

// ============================================================
//  Tear down test case.
// ============================================================
dcl-proc tearDown export;
  dcl-pi *n extproc(*dclcase) end-pi;

end-proc;

// ============================================================
//  Tear down test case.
// ============================================================
dcl-proc assertNonIdentityColumn export;
  dcl-pi *n extproc(*dclcase);
    i_flda0350 likeds(flda0350_t) const;
  end-pi;

  assert(i_flda0350.isIdyCol = *off
         : 'All other fields are not an identity column');
  assert(i_flda0350.orgStrValue = 0: 'Original start value must be 0');
  assert(i_flda0350.currStrValue = 0: 'Current start value must be 0');
  assert(i_flda0350.incValue = 0: 'Increment by must be 0');
  assert(i_flda0350.minValue = 0: 'Minimum value must be 0');
  assert(i_flda0350.maxValue = 0: 'Maximum value must be 0');
  assert(i_flda0350.isCycling = *off: 'Cycling must be disabled');
  assert(i_flda0350.isOrdering = *off: 'Ordering must be disabled');
  assert(i_flda0350.numCache = 0: 'Number of cache values must be 0');

end-proc;

// ============================================================
//  Test IDENTITY column with default values.
// ============================================================
dcl-proc testIdentityColumn_all_default_values export;
  dcl-pi *n extproc(*dclcase) end-pi;

  dcl-s handle like(fldDct_handle_t);
  dcl-ds flda0350 likeds(flda0350_t) inz;
  dcl-s option varchar(10);

  print('=> testIdentityColumn_all_default_values:');

  // Run
  exec sql
    CREATE TABLE qtemp.idycol (
      IDYCOL BIGINT GENERATED ALWAYS AS IDENTITY (
      START WITH 1 INCREMENT BY 5
      NO MINVALUE
      NO MAXVALUE
      NO CYCLE
      ORDER
      NO CACHE ),
      DATA VARCHAR(20) NOT NULL WITH DEFAULT
      );
  assert(not isSqlError(sqlState));

  if (f_fldDct_new('IDYCOL': '*LIBL': cFLDDCT_RCDFMT_FIRST: handle));
    option = cFLDDCT_FLD_FIRST;
    dow (f_FldDct_rtvFldAtr(handle: option: flda0350: 'FLDA0350'));

      select;
      when (flda0350.name = 'IDYCOL');
        assert(flda0350.isIdyCol: 'Field IDYCOL must be an identity column');
        assert(flda0350.orgStrValue = 1: 'Original start value must be 1');
        assert(flda0350.currStrValue = 1: 'Current start value must be 1');
        assert(flda0350.incValue = 5: 'Increment by must be 5');
        assert(flda0350.minValue = 1: 'Minimum value must be 1');
        assert(flda0350.maxValue = 9223372036854775807
                                    : 'Minimum value must be 9223372036854775807');
        assert(flda0350.isCycling = *off: 'Cycling must be disabled');
        assert(flda0350.isOrdering = *on: 'Cycling must be enabled');
        assert(flda0350.numCache = 0: 'Number of cache values must be 0');
      other;
        assertNonIdentityColumn(flda0350);
      endsl;

      if (flda0350.isIdyCol);
        printIdyCol(flda0350);
      else;
        printCol(flda0350.name);
      endif;
      option = cFLDDCT_FLD_NEXT;
    enddo;
  endif;


end-proc;

// ============================================================
//  Test IDENTITY column, CACHE enabled.
// ============================================================
dcl-proc testIdentityColumn_Caching_enabled export;
  dcl-pi *n extproc(*dclcase) end-pi;

  dcl-s handle like(fldDct_handle_t);
  dcl-ds flda0350 likeds(flda0350_t) inz;
  dcl-s option varchar(10);
  dcl-s i int(10);

  print('=> testIdentityColumn_Caching_enabled:');

  // Run
  exec sql
    CREATE TABLE qtemp.idycol (
      IDYCOL BIGINT GENERATED ALWAYS AS IDENTITY (
      START WITH 1 INCREMENT BY 5
      NO MINVALUE
      NO MAXVALUE
      NO CYCLE
      ORDER
      CACHE 10),       // Caching enabled
      DATA VARCHAR(20) NOT NULL WITH DEFAULT
      );
  assert(not isSqlError(sqlState));

  for i = 1 to 3;
    exec sql
      INSERT INTO qtemp.idycol (data) VALUES('FOO');
    assert(not isSqlError(sqlState));
  endfor;

  if (f_fldDct_new('IDYCOL': '*LIBL': cFLDDCT_RCDFMT_FIRST: handle));
    option = cFLDDCT_FLD_FIRST;
    dow (f_FldDct_rtvFldAtr(handle: option: flda0350: 'FLDA0350'));

      select;
      when (flda0350.name = 'IDYCOL');
        assert(flda0350.numCache = 10: 'Number of cache values must be 10');
      other;
        assertNonIdentityColumn(flda0350);
      endsl;

      if (flda0350.isIdyCol);
        printIdyCol(flda0350);
      else;
        printCol(flda0350.name);
      endif;
      option = cFLDDCT_FLD_NEXT;
    enddo;
  endif;

end-proc;

// ============================================================
//  Test IDENTITY column, START, MIN VALUE und MAX VALUE.
// ============================================================
dcl-proc testIdentityColumn_StartMinMax_values_set export;
  dcl-pi *n extproc(*dclcase) end-pi;

  dcl-s handle like(fldDct_handle_t);
  dcl-ds flda0350 likeds(flda0350_t) inz;
  dcl-s option varchar(10);
  dcl-s i int(10);

  print('=> testIdentityColumn_StartMinMax_values_set:');

  // Run
  exec sql
    CREATE TABLE qtemp.idycol (
      IDYCOL BIGINT GENERATED ALWAYS AS IDENTITY (
      START WITH 60 INCREMENT BY 5 // start value set
      MINVALUE 30                  // min value set
      MAXVALUE 250000              // max value set
      NO CYCLE
      ORDER
      NO CACHE),
      DATA VARCHAR(20) NOT NULL WITH DEFAULT
      );
  assert(not isSqlError(sqlState));

  if (f_fldDct_new('IDYCOL': '*LIBL': cFLDDCT_RCDFMT_FIRST: handle));
    option = cFLDDCT_FLD_FIRST;
    dow (f_FldDct_rtvFldAtr(handle: option: flda0350: 'FLDA0350'));

      select;
      when (flda0350.name = 'IDYCOL');
        assert(flda0350.orgStrValue = 60: 'Number of start value must be 60');
        assert(flda0350.minValue = 30: 'Minimum value must be 30');
        assert(flda0350.maxValue = 250000: 'Minimum value must be 250000');
      other;
        assertNonIdentityColumn(flda0350);
      endsl;

      if (flda0350.isIdyCol);
        printIdyCol(flda0350);
      else;
        printCol(flda0350.name);
      endif;
      option = cFLDDCT_FLD_NEXT;
    enddo;
  endif;

end-proc;

// ============================================================
//  Test IDENTITY column, START value changed.
// ============================================================
dcl-proc testIdentityColumn_Start_changed export;
  dcl-pi *n extproc(*dclcase) end-pi;

  dcl-s handle like(fldDct_handle_t);
  dcl-ds flda0350 likeds(flda0350_t) inz;
  dcl-s option varchar(10);
  dcl-s i int(10);

  print('=> testIdentityColumn_Start_changed:');

  // Run
  exec sql
    CREATE TABLE qtemp.idycol (
      IDYCOL BIGINT GENERATED ALWAYS AS IDENTITY (
      START WITH 60 INCREMENT BY 5 // start value set
      MINVALUE 30                  // min value set
      MAXVALUE 250000              // max value set
      NO CYCLE
      ORDER
      NO CACHE),
      DATA VARCHAR(20) NOT NULL WITH DEFAULT
      );
  assert(not isSqlError(sqlState));

  exec sql
    INSERT INTO qtemp.idycol (data) VALUES('FOO');
  assert(not isSqlError(sqlState));

  exec sql
    ALTER TABLE qtemp.idycol
      ALTER COLUMN idycol RESTART WITH 100;
  assert(not isSqlError(sqlState));

  exec sql
    INSERT INTO qtemp.idycol (data) VALUES('FOO');
  assert(not isSqlError(sqlState));

  if (f_fldDct_new('IDYCOL': '*LIBL': cFLDDCT_RCDFMT_FIRST: handle));
    option = cFLDDCT_FLD_FIRST;
    dow (f_FldDct_rtvFldAtr(handle: option: flda0350: 'FLDA0350'));

      select;
      when (flda0350.name = 'IDYCOL');
        assert(flda0350.orgStrValue = 60: 'Number of start value must be 60');
        // See support case: TS004801354
        assert(flda0350.currStrValue = 60: 'Number of start value must match ''orgStrValue''');
        assert(flda0350.minValue = 30: 'Minimum value must be 30');
        assert(flda0350.maxValue = 250000: 'Minimum value must be 250000');
      other;
        assertNonIdentityColumn(flda0350);
      endsl;

      if (flda0350.isIdyCol);
        printIdyCol(flda0350);
      else;
        printCol(flda0350.name);
      endif;
      option = cFLDDCT_FLD_NEXT;
    enddo;
  endif;

end-proc;

// ============================================================
//  Test IDENTITY column, NO ORDER.
// ============================================================
dcl-proc testIdentityColumn_Ordering_disabled export;
  dcl-pi *n extproc(*dclcase) end-pi;

  dcl-s handle like(fldDct_handle_t);
  dcl-ds flda0350 likeds(flda0350_t) inz;
  dcl-s option varchar(10);

  print('=> testIdentityColumn_Ordering_disabled:');

  // Run
  exec sql
    CREATE TABLE qtemp.idycol (
      IDYCOL BIGINT GENERATED ALWAYS AS IDENTITY (
      START WITH 1 INCREMENT BY 5
      NO MINVALUE
      NO MAXVALUE
      NO CYCLE
      NO ORDER         // Ordering disabled
      NO CACHE ),
      DATA VARCHAR(20) NOT NULL WITH DEFAULT
      );
  assert(not isSqlError(sqlState));

  if (f_fldDct_new('IDYCOL': '*LIBL': cFLDDCT_RCDFMT_FIRST: handle));
    option = cFLDDCT_FLD_FIRST;
    dow (f_FldDct_rtvFldAtr(handle: option: flda0350: 'FLDA0350'));

      select;
      when (flda0350.name = 'IDYCOL');
        assert(flda0350.isOrdering = *off: 'Ordering must be disabled');
      other;
        assertNonIdentityColumn(flda0350);
      endsl;

      if (flda0350.isIdyCol);
        printIdyCol(flda0350);
      else;
        printCol(flda0350.name);
      endif;
      option = cFLDDCT_FLD_NEXT;
    enddo;
  endif;


end-proc;

// ============================================================
//  Test IDENTITY column, CYCLE.
// ============================================================
dcl-proc testIdentityColumn_Cycling_enabled export;
  dcl-pi *n extproc(*dclcase) end-pi;

  dcl-s handle like(fldDct_handle_t);
  dcl-ds flda0350 likeds(flda0350_t) inz;
  dcl-s option varchar(10);

  print('=> testIdentityColumn_Cycling_enabled:');

  // Run
  exec sql
    CREATE TABLE qtemp.idycol (
      IDYCOL BIGINT GENERATED ALWAYS AS IDENTITY (
      START WITH 1 INCREMENT BY 5
      NO MINVALUE
      NO MAXVALUE
      CYCLE            // Cycling enabled
      ORDER
      NO CACHE ),
      DATA VARCHAR(20) NOT NULL WITH DEFAULT
      );
  assert(not isSqlError(sqlState));

  if (f_fldDct_new('IDYCOL': '*LIBL': cFLDDCT_RCDFMT_FIRST: handle));
    option = cFLDDCT_FLD_FIRST;
    dow (f_FldDct_rtvFldAtr(handle: option: flda0350: 'FLDA0350'));

      select;
      when (flda0350.name = 'IDYCOL');
        assert(flda0350.isCycling = *on: 'Cycling must be enabled');
      other;
        assertNonIdentityColumn(flda0350);
      endsl;

      if (flda0350.isIdyCol);
        printIdyCol(flda0350);
      else;
        printCol(flda0350.name);
      endif;
      option = cFLDDCT_FLD_NEXT;
    enddo;
  endif;


end-proc;

