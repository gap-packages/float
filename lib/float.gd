#############################################################################
##
#W  float.gd                       GAP library              Laurent Bartholdi
##
#Y  Copyright (C) 2008 Laurent Bartholdi
##
##  This file deals with general float functions
##

# with precision
DeclareConstructor("NewFloat",[IsFloat,IsFloat,IsInt]);
DeclareOperation("MakeFloat",[IsFloat,IsFloat,IsInt]);

#############################################################################
##
#C IsMPFRFloat
##
## <#GAPDoc Label="IsMPFRFloat">
## <ManSection>
##   <Filt Name="IsMPFRFloat"/>
##   <Var Name="TYPE_MPFR"/>
##   <Description>
##     The category of floating-point numbers.
##
##     <P/> Note that they are treated as commutative and scalar, but are
##     not necessarily associative.
##   </Description>
## </ManSection>
## <#/GAPDoc>
##
if IsBound(MPFR_INT) then
DeclareRepresentation("IsMPFRFloat", IsFloat and IsDataObjectRep, []);
BindGlobal("MPFRFloatsFamily", NewFamily("MPFRFloatsFamily", IsMPFRFloat));
DeclareProperty("IsMPFRFloatFamily",IsFloatFamily);
SetIsMPFRFloatFamily(MPFRFloatsFamily,true);
BindGlobal("TYPE_MPFR", NewType(MPFRFloatsFamily, IsMPFRFloat));
DeclareGlobalVariable("MPFR");
fi;
#############################################################################

#############################################################################
##
#C IsMPFIFloat
##
## <#GAPDoc Label="IsMPFIFloat">
## <ManSection>
##   <Filt Name="IsMPFIFloat"/>
##   <Var Name="TYPE_MPFI"/>
##   <Description>
##     The category of intervals of floating-point numbers.
##
##     <P/> Note that they are treated as commutative and scalar, but are
##     not necessarily associative.
##   </Description>
## </ManSection>
## <#/GAPDoc>
##
if IsBound(MPFI_INT) then
DeclareRepresentation("IsMPFIFloat", IsFloatInterval and IsDataObjectRep, []);
BindGlobal("MPFIFloatsFamily", NewFamily("MPFIFloatsFamily", IsMPFIFloat));
DeclareProperty("IsMPFIFloatFamily",IsFloatFamily);
SetIsMPFIFloatFamily(MPFIFloatsFamily,true);
BindGlobal("TYPE_MPFI", NewType(MPFIFloatsFamily, IsMPFIFloat));
DeclareGlobalVariable("MPFI");
fi;
#############################################################################

#############################################################################
##
#C IsMPCFloat
##
## <#GAPDoc Label="IsMPCFloat">
## <ManSection>
##   <Filt Name="IsMPCFloat"/>
##   <Var Name="TYPE_MPC"/>
##   <Description>
##     The category of intervals of floating-point numbers.
##
##     <P/> Note that they are treated as commutative and scalar, but are
##     not necessarily associative.
##   </Description>
## </ManSection>
## <#/GAPDoc>
##
if IsBound(MPC_INT) then
DeclareRepresentation("IsMPCFloat", IsComplexFloat and IsDataObjectRep, []);
BindGlobal("MPCFloatsFamily", NewFamily("MPCFloatsFamily", IsMPCFloat));
DeclareProperty("IsMPCFloatFamily",IsFloatFamily);
SetIsMPCFloatFamily(MPCFloatsFamily,true);
BindGlobal("TYPE_MPC", NewType(MPCFloatsFamily, IsMPCFloat));
DeclareGlobalVariable("MPC");

DeclareAttribute("SphereProject", IsMPCFloat);
fi;
#############################################################################

#############################################################################
##
#C IsCXSCFloat
##
## <#GAPDoc Label="IsCXSCFloat">
## <ManSection>
##   <Filt Name="IsCXSCReal"/>
##   <Filt Name="IsCXSCComplex"/>
##   <Filt Name="IsCXSCInterval"/>
##   <Filt Name="IsCXSCBox"/>
##   <Var Name="TYPE_CXSC_RP"/>
##   <Var Name="TYPE_CXSC_CP"/>
##   <Var Name="TYPE_CXSC_RI"/>
##   <Var Name="TYPE_CXSC_CI"/>
##   <Description>
##     The category of floating-point numbers.
##
##     <P/> Note that they are treated as commutative and scalar, but are
##     not necessarily associative.
##   </Description>
## </ManSection>
## <#/GAPDoc>
##
if IsBound(CXSC_INT) then
DeclareCategory("IsCXSCFloat", IsFloat); # virtual class containing all below

DeclareRepresentation("IsCXSCFloatRep", IsCXSCFloat and IsDataObjectRep, []);

DeclareCategory("IsCXSCReal", IsFloat and IsCXSCFloatRep);
DeclareCategoryCollections("IsCXSCReal");
DeclareCategoryCollections("IsCXSCRealCollection");
DeclareCategory("IsCXSCComplex", IsComplexFloat and IsCXSCFloatRep);
DeclareCategoryCollections("IsCXSCComplex");
DeclareCategoryCollections("IsCXSCComplexCollection");
DeclareCategory("IsCXSCInterval", IsFloatInterval and IsCXSCFloatRep);
DeclareCategoryCollections("IsCXSCInterval");
DeclareCategoryCollections("IsCXSCIntervalCollection");
DeclareCategory("IsCXSCBox", IsComplexFloatInterval and IsCXSCFloatRep);
DeclareCategoryCollections("IsCXSCBox");
DeclareCategoryCollections("IsCXSCBoxCollection");

BindGlobal("CXSCFloatsFamily", NewFamily("CXSCFloatsFamily", IsCXSCFloat));
DeclareProperty("IsCXSCFloatFamily",IsFloatFamily);
SetIsCXSCFloatFamily(CXSCFloatsFamily,true);

BindGlobal("TYPE_CXSC_RP", NewType(CXSCFloatsFamily, IsCXSCReal));
BindGlobal("TYPE_CXSC_CP", NewType(CXSCFloatsFamily, IsCXSCComplex));
BindGlobal("TYPE_CXSC_RI", NewType(CXSCFloatsFamily, IsCXSCInterval));
BindGlobal("TYPE_CXSC_CI", NewType(CXSCFloatsFamily, IsCXSCBox));

DeclareGlobalVariable("CXSC");
fi;
#############################################################################

#############################################################################
##
#C FPLLL
##
## <#GAPDoc Label="FPLLL">
## <ManSection>
##   <Oper Name="FPLLLReducedBasis" Arg="m"/>
##   <Returns>A matrix spanning the same lattice as <A>m</A>.</Returns>
##   <Description>
##     This function implements the LLL (Lenstra-Lenstra-Lovász) lattice
##     reduction algorithm via the external library <Package>fplll</Package>.
##
##     <P/> The result is guaranteed to be optimal up to 1%.
##   </Description>
## </ManSection>
##
## <ManSection>
##   <Oper Name="FPLLLShortestVector" Arg="m"/>
##   <Returns>A short vector in the lattice spanned by <A>m</A>.</Returns>
##   <Description>
##     This function implements the LLL (Lenstra-Lenstra-Lovász) lattice
##     reduction algorithm via the external library <Package>fplll</Package>,
##     and then computes a short vector in this lattice.
##
##     <P/> The result is guaranteed to be optimal up to 1%.
##   </Description>
## </ManSection>
## <#/GAPDoc>
##
if IsBound(@FPLLL) then
DeclareOperation("FPLLLReducedBasis", [IsMatrix]);
DeclareOperation("FPLLLShortestVector", [IsMatrix]);
fi;
#############################################################################

#############################################################################
#E
