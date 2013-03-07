;; This buffer is for notes you don't want to save, and for Lisp evaluation.
;; If you want to create a file, visit that file with C-x C-f,
;; then enter the text in that file's own buffer.

newt := function(f,z)
  local df, i, j, dz, v, newv, newz;
  df := Derivative(f);
  j := 1;
  repeat
    v := Value(f,z);
    if IsZero(v) then return z; fi;
    dz := v/Value(df,z);
    i := 0;
    repeat
      newz := z-dz;
      newv := Value(f,newz);
      if AbsoluteValue(newv)>=AbsoluteValue(v) then
        if i=0 then return z; fi;
        break;
      fi;
      z := newz;
      v := newv;
      i := i+1;
      j := j*2;
      if j>PrecisionFloat(z) then
        Info(InfoFR,1,"Seems not to converge");
        return z;
      fi;
    until false;
  until false;
end;
