#############################################################################
##
#W  pslq.gi                        GAP float                  Steve A. Linton
##
#Y  Copyright (C) 2014 Steve Linton & Laurent Bartholdi
##
##  This file implements the PSLQ and multi-pair PSLQ algorithms as described
##  in "Parallel Integer Relation Detection: Techniques and Applications
##  David H. Bailey and David J. Broadhurst" Math.Comput. 70 (2001) 1719-1736
##
##  Both implementations follow the paper quite closely. The main input
##  is a vector of floats in some appropriate extended precision representation
##  There is currently no detection of whether the representation is extended
##  enough, although the algorithm will probably not terminate if it is not
##  when this class is set to level 2 or higher it prints a few numbers
##  indicating progress at each iteration

# TODO: implement the multi-level version
# TODO: parallelise the multi-pair version.
# TODO: detect when there is insufficient precisiona and fail cleanly.

BindGlobal("defaultgamma@", 2.0/Sqrt(3.0));

## <#GAPDoc Label="PSLQ">
## The PSLQ algorithm has been implemented by Steve A. Linton, as an external
## contribution to <Package>Float</Package>. This algorithm receives as
## input a vector of floats <M>x</M> and a required precision <M>\epsilon</M>,
## and seeks an integer vector <M>v</M> such that
## <M>|x\cdot v|&lt;\epsilon</M>. The implementation follows quite closely the
## original article <Cite Key="MR1836930"/>.
##
## <ManSection>
##   <Func Name="PSLQ" Arg="x, epsilon[, gamma]"/>
##   <Func Name="PSLQ_MP" Arg="x, epsilon[, gamma [,beta]]"/>
##   <Returns>An integer vector <M>v</M> with <M>|x\cdot v|&lt;\epsilon</M>.</Returns>
##   <Description>
##     The PSLQ algorithm by Bailey and Broadhurst (see <Cite Key="MR1836930"/>)
##     searches for an integer relation between the entries in <M>x</M>.
##
##     <P/><M>\beta</M> and <M>\gamma</M> are algorithm tuning parameters, and
##     default to <M>4/10</M> and <M>2/\sqrt(3)</M> respectively.
##
##     <P/>The second form implements the "Multi-pair" variant of the algorithm, which is
##     better suited to parallelization.
## <Example><![CDATA[
## gap> PSLQ([1.0,(1+Sqrt(5.0))/2],1.e-2);
## [ 55, -34 ] # Fibonacci numbers
## gap> RootsFloat([1,-4,2]*1.0);
## [ 0.292893, 1.70711 ] # roots of 2x^2-4x+1
## gap> PSLQ(List([0..2],i->last[1]^i),1.e-7);
## [ 1, -4, 2 ] # a degree-2 polynomial fitting well
## ]]></Example>
##   </Description>
## </ManSection>
## <#/GAPDoc>
##
BindGlobal("PSLQ", function(arg)
    local  sample, eps, gamma, one, zero, redentry, swapEntries, n, i, 
           y, A, B, s, s2, t, H, j, count, best, m, q, a, t0, t1, t2, 
           t3, t4, l, M, rp, ym, x;
    
    # Process arguments and set up a few constants
    
    if Length(arg) < 2 or Length(arg) > 4 or not ForAll(arg[1], IsFloat) then
        Error("Usage: pslq(x, epsilon [, gamma] )  default gamme is 2/sqrt(3)");
    fi;
    
    x := arg[1];
    sample := x[1];
    eps := arg[2];
    if Length(arg) = 3 then
        gamma := arg[3];
    else
        gamma := MakeFloat(sample, defaultgamma@);
    fi;
    
    #
    # We can't just use 1.0 or 0.0 because they might not have the right representation
    #
    
    one := One(sample);
    zero := Zero(sample);
    
    
    #
    # Basic step in HNF calculations, used in a couple of places
    #
    
    redentry := function(i,j)
        local  t, ti;
        t := Round(H[i][j]/H[j][j]);
        ti := Int(t);
        y[j] := y[j] + t*y[i];
        AddRowVector(H[i],H[j],-t,1,j);
        AddRowVector(A[i],A[j],-ti,1,n);
        AddRowVector(B[j],B[i],ti,1,n);
    end;
    
    
    #
    # swap entries m and m+1 in list a
    #
  
    swapEntries := function(a, m)
        local t;
        t := a[m];
        a[m] := a[m+1];
        a[m+1] := t;
    end;
    
    
    n := Length(x);    
    
    #
    # If the list includes something close enough to zero, the problem is easy
    #
    i := PositionProperty(x, y->AbsoluteValue(y) < eps);
    if i <> fail then
        y := ListWithIdenticalEntries(n,0);
        y[i] := 1;
        return y;
    fi;
    
    #
    # and now to work.
    #
    
    
    #
    # Initial setup
    #
    
    A := IdentityMat(n,Integers);
    B := IdentityMat(n,Integers);
    s := [];
    s2 := zero;    
    for i in [n,n-1..1] do
        s2 := s2 + x[i]^2;        
        s[i] := Sqrt(s2);
    od;
    t := one/s[1];
    y := t*x;
    s := t*s;
    H := List([1..n], i->[]);
    for j in [1..n-1] do
        for i in [1..j-1] do
            H[i][j] := zero;
        od;
        H[j][j] := s[j+1]/s[j];
        for i in [j+1..n] do
            H[i][j] := -y[i]*y[j]/(s[j]*s[j+1]);
        od;
    od;
    
    for i in [2..n] do
        for j in [i-1,i-2..1] do
            redentry(i,j);
        od;
    od;
    
    count := 0;
    
    #
    # Main loop
    #
    repeat
        count := count+1;
        
        #
        # find row to work on (maximum of gamma^i*H[i][i])
        #
        best := -one;
        m := fail;
        q := one;
        for i in [1..n-1] do
            q := q*gamma;
            a := q*AbsoluteValue(H[i][i]);
            if a > best then
                m := i;
                best := a;
            fi;
        od;
        
        #
        # exchange step
        #
        swapEntries(y,m);
        swapEntries(A,m);
        swapEntries(B,m);
        swapEntries(H,m);
        
        
        #
        # Corner step
        #
        
        if m <= n-2 then
            t0 := Sqrt(H[m][m]^2 + H[m][m+1]^2);
            t1 := H[m][m]/t0;
            t2 := H[m][m+1]/t0;
            for i in [m..n] do
                t3 := H[i][m];
                t4 := H[i][m+1];
                H[i][m] := t1*t3 + t2*t4;
                H[i][m+1] := -t2*t3 + t1*t4;
            od;
        fi;
        
        #
        # Reduction step
        #
        
        for i in [m+1..n] do
            l := Minimum(i-1,m+1);
            for j in [l,l-1..1] do
                redentry(i,j);
            od;
        od;
        
        #
        # Take stock at the end of the iteration
        #
        
        M := 1.0/Maximum(List([1..n-1], i->AbsoluteValue(H[i][i])));
        
        rp := 1;
        ym := AbsoluteValue(y[1]);
        for i in [2..n] do 
            t := AbsoluteValue(y[i]);
            if t < ym then
                ym := t;
                rp := i;
            fi;
        od;
        Info(InfoFloat, 2, count,": ",Int(M)," ",Int(Log10(ym)));
        
    until ym < eps;
    return B[rp];
end);

BindGlobal("defaultbeta@", 4/10);

BindGlobal("PSLQ_MP", function(arg)
    local  swapEntries, x, eps, sample, n, one, zero, gamma, betan, i, 
           y, A, B, s, s2, t, H, j, count, v, q, l, used, pairs, p, m, 
           t0, t1, t2, t3, t4, T, k, M, rp, ym;
    #
    # swap entries m and m+1 in list a
    #
  
    swapEntries := function(a, m)
        local t;
        t := a[m];
        a[m] := a[m+1];
        a[m+1] := t;
    end;
    
    if Length(arg) < 2 or Length(arg) > 4 or not ForAll(arg[1],IsFloat) then
        Error("Usage: pslqMP( x, epsilon[, gamma[, beta]])");
    fi;
    x := arg[1];
    eps := arg[2];
    
    sample := x[1];
    n := Length(x);    
    one := One(sample);
    zero := Zero(sample);
    
    if Length(arg) > 2 then
        gamma := arg[3];
    else
        gamma := MakeFloat(sample, defaultgamma@);
    fi;
    
    if Length(arg) > 3 then
        betan := arg[4]*n;
    else
        betan := n*defaultbeta@;
    fi;
    
    #
    # If the list includes something close enough to zero, the problem is easy
    #
    i := PositionProperty(x, y->AbsoluteValue(y) < eps);
    if i <> fail then
        y := ListWithIdenticalEntries(n,0);
        y[i] := 1;
        return y;
    fi;
    
    #
    # Start the real work
    #

    A := IdentityMat(n,Integers);
    B := IdentityMat(n,Integers);
    s := [];
    s2 := zero;    
    for i in [n,n-1..1] do
        s2 := s2 + x[i]^2;        
        s[i] := Sqrt(s2);
    od;
    t := one/s[1];
    y := t*x;
    s := t*s;
    H := List([1..n], i->[]);
    for j in [1..n-1] do
        for i in [1..j-1] do
            H[i][j] := zero;
        od;
        H[j][j] := s[j+1]/s[j];
        for i in [j+1..n] do
            H[i][j] := -y[i]*y[j]/(s[j]*s[j+1]);
        od;
    od;
    
    count := 0;
    #
    # Main loop
    #
    repeat
        count := count+1;
        v := [];
        q := one;
        for i in [1..n-1] do
            q := q*gamma;
            # negate to get the sorting order, since that's all we actually care about
            Add(v, -q*AbsoluteValue(H[i][i]));
        od;
        l := [1..n-1];
        SortParallel(v,l);
        
        #
        # Now we sort out our pairs
        #
        
        used := BlistList([1..n],[]);
        pairs := [];
        for i in [1..n-1] do
            if not used[l[i]] and not used[l[i]+1] then
                Add(pairs,l[i]);
                used[l[i]] := true;
                used[l[i]+1] := true;
            fi;
            if Length(pairs) > betan then
                break;
            fi;
        od;

        
        
        p := Length(pairs);
        for m in pairs do
            swapEntries(y,m);
            swapEntries(A,m);
            swapEntries(B,m);
            swapEntries(H,m);
        od;

        
        for m in pairs do
            if m <= n-2 then
                t0 := Sqrt(H[m][m]^2 + H[m][m+1]^2);
                t1 := H[m][m]/t0;
                t2 := H[m][m+1]/t0;
                for i in [m..n] do
                    t3 := H[i][m];
                    t4 := H[i][m+1];
                    H[i][m] := t1*t3 + t2*t4;
                    H[i][m+1] := -t2*t3 + t1*t4;
                od;
            fi;
        od;
        
        
        T:= List([1..n], i->[]);
        for i in [2..n] do
            for j in [1..n-i+1] do
                l := i+j-1;
                for k in [j+1..l-1] do
                    H[l][j] := H[l][j] - T[l][k]*H[k][j];
                od;
                
                T[l][j] := Round(H[l][j]/H[j][j]);
                H[l][j] := H[l][j] - T[l][j]*H[j][j];
            od;
        od;
        
        for j in [1..n-1] do
            for i in [j+1..n] do
                y[j] := y[j] + T[i][j]*y[i];
            od;
        od;
        
        for j in [1..n-1] do
            for i in [j+1..n] do
                AddRowVector(A[i],A[j], -Int(T[i][j]));
                AddRowVector(B[j],B[i], Int(T[i][j]));
            od;
        od;
        
                
        
        M := one/Maximum(List([1..n-1], i->AbsoluteValue(H[i][i])));
        
        rp := 1;
        ym := AbsoluteValue(y[1]);
        for i in [2..n] do 
            t := AbsoluteValue(y[i]);
            if t < ym then
                ym := t;
                rp := i;
            fi;
        od;
        Info(InfoFloat,2,count,": ",Int(M)," ",Int(Log10(ym)));
        
    until ym < eps;
    return B[rp];
end);
          
# These examples are used in the paper cited above to generate a family of test data.

BindGlobal("MakePslqTest@", function(r,s)
    local  alpha, xs;
    alpha := Exp(Log(3.0)/r) - Exp(Log(2.0)/s);
    xs := List([0..r*s], i-> alpha^i);
    return xs;
end);

#############################################################################
#E
