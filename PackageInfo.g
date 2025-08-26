#############################################################################
##  
##  PackageInfo.g for the package `float'                   Laurent Bartholdi
##
SetPackageInfo( rec(
PackageName := "float",
Subtitle := "Integration of mpfr, mpfi, mpc, fplll and cxsc in GAP",
Version := "1.0.9",
Date := "26/08/2025", # dd/mm/yyyy format
License := "GPL-2.0-or-later",
## <#GAPDoc Label="Version">
## <!ENTITY Version "1.0.9">
## <!ENTITY Date "26/08/2025">
## <#/GAPDoc>
Persons := [
  rec( 
    LastName      := "Bartholdi",
    FirstNames    := "Laurent",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "laurent.bartholdi@gmail.com",
    WWWHome       := "https://www.math.uni-sb.de/ag/bartholdi/",
    PostalAddress := Concatenation( [
                       "FR Mathematik\n",
                       "D-68041 Saarbrücken\n",
                       "Germany" ] ),
    Place         := "Saarbrücken",
    Institution   := "Universität des Saarlandes"
  )
],

Status := "deposited",

SourceRepository := rec(
    Type := "git",
    URL := Concatenation( "https://github.com/gap-packages/", ~.PackageName ),
),
IssueTrackerURL := Concatenation( ~.SourceRepository.URL, "/issues" ),
PackageWWWHome  := Concatenation( "https://gap-packages.github.io/", ~.PackageName ),
README_URL      := Concatenation( ~.PackageWWWHome, "/README.md" ),
PackageInfoURL  := Concatenation( ~.PackageWWWHome, "/PackageInfo.g" ),
ArchiveURL      := Concatenation( ~.SourceRepository.URL,
                                 "/releases/download/v", ~.Version,
                                 "/", ~.PackageName, "-", ~.Version ),
ArchiveFormats := ".tar.gz",

AbstractHTML := "The <span class=\"pkgname\">float</span> package allows \
                    GAP to manipulate floating-point numbers with arbitrary \
                    precision. It is based on MPFR, MPFI, MPC, CXSC, FPLLL",
PackageWWWHome := "https://gap-packages.github.io/float/",

PackageDoc := rec(
  BookName  := "float",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0_mj.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Floating-point numbers",
),

Dependencies := rec(
  GAP := ">=4.12.0",
  NeededOtherPackages := [["GAPDoc",">=1.0"]],
  SuggestedOtherPackages := [],
  ExternalConditions := ["GAP compiled with GMP support"]                      
),

AvailabilityTest := function()
  if not IsKernelExtensionAvailable("float") then
    LogPackageLoadingMessage(PACKAGE_WARNING,
            [Concatenation("The DLL program `",
                Filename(DirectoriesPackagePrograms("float")[1], "float.so"),
                    "' was not compiled, and is needed for the float package."),
             "Run `./configure && make' in its home directory"]);
    return false;
  fi;
  return true;
end,
                    
BannerString := Concatenation(~.PackageName, " ", String(~.Version), " with modules [?] ...\n"),
BannerFunction := function(info)
    local str, modules;

    str:= info.BannerString;
    modules := [];

    if IsBound(MPFR_INT) then
        Add(modules,"mpfr");
    fi;
    if IsBound(MPFI_INT) then
        Add(modules,"mpfi");
    fi;
    if IsBound(MPC_INT) then
        Add(modules,"mpc");
    fi;
    if IsBound(@FPLLL) then
        Add(modules,"fplll");
    fi;
    if IsBound(CXSC_INT) then
        Add(modules,"cxsc");
    fi;
    modules := JoinStringsWithSeparator(modules, ", ");

    return ReplacedString(str, "?", modules);
end,

TestFile := "tst/testall.g",
Keywords := ["floating-point"]
));
