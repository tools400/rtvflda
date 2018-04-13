      /IF NOT DEFINED(QDBRTVFD)
      /DEFINE QDBRTVFD
      *
      *  Retrieve Database File Description (QDBRTVFD) API
     D QDBRTVFD...
     D                 PR                  extpgm('QDBRTVFD')
     D  o_rcvVar                  65535A         options(*varsize)
     D  i_lenRcvVar                  10I 0 const
     D  o_retFileName                20A
     D  i_format                      8A   const
     D  i_qFile                      20A   const
     D  i_rcdFormat                  10A   const
     D  i_override                    1A   const
     D  i_system                     10A   const
     D  i_formatType                 10A   const
     D  io_errCode                65535A          options(*varsize )
      *
      * ---------------------------------------------------
      *  FILD0100:
      * ---------------------------------------------------
      *
      *  File Definition Header (Qdb_Qdbfh)
     D Qdb_Qdbfh_t     DS                  qualified               based(pDummy)
     D  Qdbfyret               1      4I 0
     D  Qdbfyavl               5      8I 0
     D  Qdbfhflg               9     10U 0
     D  Reserved_7            11     14A
     D  Qdbflbnum             15     16I 0
     D  Qdbfknum              17     18I 0
     D  Qdbfkmxl              19     20I 0
     D  Qdbfkflg              21     21A
     D  Qdbfkfdm              22     22A
     D  Reserved_10           23     30A
     D  Qdbfhaut              31     40A
     D  Qdbfhupl              41     41A
     D  Qdbfhmxm              42     43I 0
     D  Qdbfwtfi              44     45I 0
     D  Qdbfhfrt              46     47I 0
     D  Qdbfhmnum             48     49I 0
     D  Qdbfapsize            50     51I 0
     D  Reserved_11           52     58A
     D  Qdbfbrwt              59     60I 0
     D  Qaaf                  61     61A
     D  Qdbffmtnum            62     63I 0
     D  Qdbfhfl2              64     65A
     D  Qdbfvrm               66     67I 0
     D  Qaaf2                 68     69A
     D  Qdbfhcrt              70     82A
     D  Reserved_18           83     84A
     D  Qdbfhtxt              85    134A
     D  Reserved_19          135    147A
     D  Qdbfsrcf             148    157A
     D  Qdbfsrcm             158    167A
     D  Qdbfsrcl             168    177A
     D  Qdbfkrcv             178    178A
     D  Reserved_20          179    201A
     D  Qdbftcid             202    203I 0
     D  Qdbfasp              204    205I 0
     D  Qdbfnbit             206    206A
     D  Qdbfmxfnum           207    208I 0
     D  Reserved_22          209    284A
     D  Qdbfodic             285    288I 0
     D  Reserved_23          289    302A
     D  Qdbffigl             303    304I 0
     D  Qdbfmxrl             305    306I 0
     D  Reserved_24          307    314A
     D  Qdbfgkct             315    316I 0
     D  Qdbfos               317    320I 0
     D  Reserved_25          321    328A
     D  Qdbfocs              329    332I 0
     D  Reserved_26          333    336A
     D  Qdbfpact             337    338A
     D  Qdbfhrls             339    344A
     D  Reserved_27          345    364A
     D  Qdbpfof              365    368I 0
     D  Qdblfof              369    372I 0
     D  Qdbfnlsb             373    373A
     D  Qdbflang             374    376A
     D  Qdbfcnty             377    378A
     D  Qdbfjorn             379    382I 0
     D  Qdbfevid             383    386I 0
     D  Reserved_28          387    400A
      *
      *  File Scope Array (Qdb_Qdbfb)
     D Qdb_Qdbfb_t     DS                  qualified               based(pDummy)
     D  Reserved_48            1     48A
     D  Qdbfbf                49     58A
     D  Qdbfbfl               59     68A
     D  Qdbft                 69     78A
     D  Reserved_49           79    115A
     D  Qdbfbgky             116    117I 0
     D  Reserved_50          118    119A
     D  Qdbfblky             120    121I 0
     D  Reserved_51          122    123A
     D  Qdbffogl             124    125I 0
     D  Reserved_52          126    128A
     D  Qdbfsoon             129    130I 0
     D  Qdbfsoof             131    134I 0
     D  Qdbfksof             135    138I 0
     D  Qdbfkyct             139    140I 0
     D  Qdbfgenf             141    142I 0
     D  Qdbfodis             143    146I 0
     D  Reserved_53          146    160A
      *
      *  Key Specification Array (Qdb_Qdbfk)
     D Qdb_Qdbfk_t     DS                  qualified               based(pDummy)
     D  Qdbfkfld               1     10A
     D  Reserved_59           11     13A
     D  Qdbfksq               14     14A
     D  Reserved_61           15     32A
      *
      * ---------------------------------------------------
      *  FILD0200
      * ---------------------------------------------------
      *
      *  Format Definition Header (Qdb_Qddfmt)
     D Qdb_Qddfmt_t    DS           256    qualified               based(pDummy)
     D  bytRet                 1      4I 0
     D  bytAvl                 5      8I 0
     D  Reserved_62            9     32A
     D  Qddfmtf               33     33A
     D  Qddfxlto              34     37I 0
     D  Qddfrcao              38     41I 0
     D  Qddfdico              42     45I 0
     D  Qddfrcid              46     47I 0
     D  Qddfsrcd              48     49I 0
     D  Qddfrtcd              50     51I 0
     D  Qddfrlcd              52     53I 0
     D  Reserved_64           54     60A
     D  Qddftflgs             61     61A
     D  Qddflgs               62     62U 0
     D  Reserved_67           63     66A
     D  Qddfrlen              67     70I 0
     D  Qddfname              71     80A
     D  Qddfseq               81     93A
     D  Qddftext              94    143A
     D  Qddffldnum           144    145I 0
     D  Qddf_Identity_Off...
     D                       146    149I 0
      * Qddffldx             257    CHAR(*)   Start of field definition array (Qdb_Qddffld).
      *
      *  Field Header (Qdb_Qddffld)
     D Qdb_Qddffld_t   DS                  qualified               based(pDummy)
     D  Qddfdefl               1      4I 0
     D  Qddffldi               5     34A
     D  Qddfflde              35     64A
     D  Qddfftyp              65     66A
     D  Qddffiob              67     67A
     D  Qddffobo              68     71I 0
     D  Qddffibo              72     75I 0
     D  Qddffldb              76     77I 0
     D  Qddffldd              78     79I 0
     D  Qddffldp              80     81I 0
      *  ...
     D  Qddffldst2            86     86U 0
      *  ...
     D  Qddflalc              92     93U 0
     D  Qddfdttf              94     94A
     D  Qddfdtts              95     95A
     D  Qddfcsid              96     97U 0
      *  ...
     D  Qddfdftd             195    198U 0
      *  ...
     D  Qddftxtd             209    212I 0
     D  Reserved_102         213    214A
     D  Qddfrefd             215    218I 0
     D  Qddfedtl             219    220I 0
     D  Qddfedtd             221    224I 0
     D  Reserved_76          225    226I 0
     D  Qddfchd              227    230I 0
      *  ...
     D  Qddfxals             237    240I 0
      *
      *  Reference Information (Qdb_Qddfrefi)
     D Qdb_Qddfrefi_t  DS                  qualified               based(pDummy)
     D  Qddfrcde               1      1A
     D  Qddfrfil               2     11A
     D  Qddfrlib              12     21A
     D  Qddfrfmt              22     31A
     D  Qddfrfld              32     61A
     D  Reserved_78           62     80A
      *
      *  Edit Code/Edit Word Information (Qdb_Qddfedcw)
     D Qdb_Qddfedcw_t  DS                  qualified               based(pDummy)
     D  Qddfecdi               1      2A
     D  Qddfecde               1      1A
     D  Qddfecdx               2      2A
     D  Reserved_79            3     16A
     D  Qddfewd               17     80A
      *
      *  Field Text (Qdb_Qddfftxt)
     D Qdb_Qddfftxt_t  DS                  qualified               based(pDummy)
     D  Qddfftxt               1     50A
      *
      *  Alias name structure (Qdb_Qddfalis)
     D Qdb_Qddfalis_t  DS                  qualified               based(pDummy)
     D  Qddfalsl               1      2I 0
     D  Reserved_85            3     16A
     D  Qddfalsn              17    274A
      *
      *  Default Value Description Information (Qdb_Qddfdft)
     D Qdb_Qddfdft_t   DS                  qualified               based(pDummy)
     D  Qddfdftl               1      2I 0
     D  Qddfdfta               3      3U 0
     D  Reserved_87            4     16A
      * Qddfdftv              17    CHAR(*)   Default Value.
      *
     D QDDFDFTA_GRAPHIC...
     D                 C                   128                                  DBCS/graphic d
     D QDDFDFTA_HEX...
     D                 C                   32                                   Hex default.
     D QDDFDFTA_NULL...
     D                 C                   4                                    Null default.
     D QDDFDFTA_DATE_TIME...
     D                 C                   2                                    Current date/t
     D QDDFDFTA_DFT_KEYWORD...
     D                 C                   1                                    DFT/DFTVAL spe
      *
      *  Column Heading Information (Qdb_Qddfcolh)
     D Qdb_Qddfcolh_t  DS                  qualified               based(pDummy)
     D  Qddfch1                1     20A
     D  Qddfch2               21     40A
     D  Qddfch3               41     60A
      *
      /ENDIF
