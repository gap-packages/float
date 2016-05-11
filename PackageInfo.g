#############################################################################
##  
##  PackageInfo.g for the package `float'                   Laurent Bartholdi
##
SetPackageInfo( rec(
PackageName := "float",
Subtitle := "Integration of mpfr, mpfi, mpc, fplll and cxsc in GAP",
Version := "0.7.3",
Date := "11/05/2016",
## <#GAPDoc Label="Version">
## <!ENTITY Version "0.7.3">
## <!ENTITY Date "11/05/2016">
## <#/GAPDoc>
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

SourceRepository := rec(
    Type := "git",
    URL := Concatenation( "https://github.com/gap-packages/", ~.PackageName ),
),
IssueTrackerURL := Concatenation( ~.SourceRepository.URL, "/issues" ),
PackageWWWHome  := Concatenation( "https://gap-packages.github.io/", ~.PackageName ),
README_URL      := Concatenation( ~.PackageWWWHome, "/README" ),
PackageInfoURL  := Concatenation( ~.PackageWWWHome, "/PackageInfo.g" ),
ArchiveURL      := Concatenation( ~.SourceRepository.URL,
                                 "/releases/download/v", ~.Version,
                                 "/", ~.PackageName, "-", ~.Version ),
ArchiveFormats := ".tar.gz",

AbstractHTML := "The <span class=\"pkgname\">float</span> package allows \
                    GAP to manipulate floating-point numbers with arbitrary \
                    precision. It is based on MPFR, MPFI, MPC, CXSC, FPLLL",
PackageWWWHome := "http://gap-packages.github.io/float/",

PackageDoc := rec(
  BookName  := "float",
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
  ExternalConditions := ["GAP compiled with GMP support"]                      
),

AvailabilityTest := function()
    local f;
    f := Filename(DirectoriesPackagePrograms("float"),"float.so");
    if f=fail then
        LogPackageLoadingMessage(PACKAGE_WARNING,
            [Concatenation("The DLL program `",
                Filename(DirectoriesPackagePrograms("float")[1],"float.so"),
                    "' was not compiled, and is needed for the float package."),
             "Run `./configure && make' in its home directory"]);
    fi;
    return f<>fail;
end,
                    
BannerString := Concatenation("Loading ", ~.PackageName, " ", String(~.Version), " ...\n"),

Autoload := false,
TestFile := "tst/testall.g",
Keywords := ["floating-point"]
));
