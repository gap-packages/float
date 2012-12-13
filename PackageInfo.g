#############################################################################
##  
##  PackageInfo.g for the package `float'                   Laurent Bartholdi
##
## $Id$
##
SetPackageInfo( rec(
PackageName := "Float",
Subtitle := "Integration of mpfr, mpfi, mpc, fplll and cxsc in GAP",
Version := "0.5.5",
Date := "13/12/2012",
## <#GAPDoc Label="Version">
## <!ENTITY Version "0.5.5">
## <!ENTITY Date "13/12/2012">
## <#/GAPDoc>
ArchiveURL := Concatenation("https://github.com/laurentbartholdi/float/archive/",~.Version),
ArchiveFormats := ".tar.gz",
Persons := [
  rec( 
    LastName      := "Bartholdi",
    FirstNames    := "Laurent",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "laurent.bartholdi@gmail.com",
    WWWHome       := "http://www.uni-math.gwdg.de/laurent",
    PostalAddress := Concatenation( [
                       "Mathematisches Institut\n",
                       "Bunsenstraße 3—5\n",
                       "D-37073 Göttingen\n",
                       "Germany" ] ),
    Place         := "Göttingen",
    Institution   := "Georg-August Universität zu Göttingen"
  )
],

Status := "deposited",

README_URL := "http://laurentbartholdi.github.com/float/README.float",
PackageInfoURL := "http://laurentbartholdi.github.com/float/PackageInfo.g",
AbstractHTML := "The <span class=\"pkgname\">Float</span> package allows \
                    GAP to manipulate floating-point numbers with arbitrary \
                    precision. It is based on MPFR, MPFI, MPC, CXSC, FPLLL",
PackageWWWHome := "http://laurentbartholdi.github.com/float/",

PackageDoc := rec(
  BookName  := "Float",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Floating-point numbers",
  Autoload  := true
),

Dependencies := rec(
  GAP := ">=4.5.0",
  NeededOtherPackages := [["GAPDoc",">=1.0"]],
  SuggestedOtherPackages := [],
  ExternalConditions := []                      
),

AvailabilityTest := function()
    local f;
    f := Filename(DirectoriesPackagePrograms("float"),"float.so");
    if f=fail then
        LogPackageLoadingMessage(PACKAGE_WARNING,
            [Concatenation("The DLL program `",
                Filename(DirectoriesPackagePrograms("float")[1],"float.so"),
                    "' was not compiled, and is needed for the FLOAT package."),
             "Run `./configure && make' in its home directory"]);
    fi;
    return f<>fail;
end,
                    
BannerString := Concatenation("Loading FLOAT ", String(~.Version), " ...\n"),

Autoload := false,
TestFile := "tst/testall.g",
Keywords := ["floating-point"]
));
