*!* mr_getopenfilename

#define OFN_READONLY                 0x00000001
#define OFN_OVERWRITEPROMPT          0x00000002
#define OFN_HIDEREADONLY             0x00000004
#define OFN_NOCHANGEDIR              0x00000008
#define OFN_SHOWHELP                 0x00000010
#define OFN_ENABLEHOOK               0x00000020
#define OFN_ENABLETEMPLATE           0x00000040
#define OFN_ENABLETEMPLATEHANDLE     0x00000080
#define OFN_NOVALIDATE               0x00000100
#define OFN_ALLOWMULTISELECT         0x00000200
#define OFN_EXTENSIONDIFFERENT       0x00000400
#define OFN_PATHMUSTEXIST            0x00000800
#define OFN_FILEMUSTEXIST            0x00001000
#define OFN_CREATEPROMPT             0x00002000
#define OFN_SHAREAWARE               0x00004000
#define OFN_NOREADONLYRETURN         0x00008000
#define OFN_NOTESTFILECREATE         0x00010000
#define OFN_NONETWORKBUTTON          0x00020000
#define OFN_NOLONGNAMES              0x00040000     && force no long names for 4.x modules
#define OFN_EXPLORER                 0x00080000     && new look commdlg
#define OFN_NODEREFERENCELINKS       0x00100000
#define OFN_LONGNAMES                0x00200000     && force long names for 3.x modules
#define OFN_ENABLEINCLUDENOTIFY      0x00400000     && send include message to callback
#define OFN_ENABLESIZING             0x00800000
#define OFN_DONTADDTORECENT          0x02000000
#define OFN_FORCESHOWHIDDEN          0x10000000     && Show All files including System and hidden files
#define OFN_EX_NOPLACESBAR			 0x00000001

#define CDN_FIRST			-601
#define CDN_LAST			-699
#define CDN_INITDONE		-601
#define CDN_SELCHANGE		-602
#define CDN_FOLDERCHANGE	-603
#define CDN_SHAREVIOLATION	-604
#define CDN_HELP			-605
#define CDN_FILEOK			-606
#define CDN_TYPECHANGE		-607
#define CDN_INCLUDEITEM		-608

#define CDM_FIRST			0x464
#define CDM_LAST			0x4C8
#define CDM_GETSPEC			0x464
#define CDM_GETFILEPATH		0x465
#define CDM_GETFOLDERPATH	0x466
#define CDM_GETFOLDERIDLIST	0x467
#define CDM_SETCONTROLTEXT	0x468
#define CDM_HIDECONTROL		0x469
#define CDM_SETDEFEXT		0x470

#define IDOK				1
#define IDCANCEL			2

Local cdialogtitle, cfile, cfilefilters, cfilename, cinitialdirectory, initialdirectory, nflags
Local nflagsex

vfp2c32()

m.nflags			= OFN_EXPLORER + OFN_DONTADDTORECENT + OFN_FILEMUSTEXIST + OFN_NOCHANGEDIR + OFN_ENABLESIZING
m.cfilefilters		= 'properties' + chr(0) + '*.properties'
m.cfilename			= ''
m.cinitialdirectory	= ''
m.cdialogtitle		= ''
m.nflagsex			= 0

m.cfile = GetOpenFileName(m.nflags, m.cfilefilters, m.cfilename, m.cinitialdirectory, m.cdialogtitle, m.nflagsex)

if vartype(m.cfile) = 'C'


endif



 