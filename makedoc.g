#if fail = LoadPackage("AutoDoc", ">= 2016.01.21") then
#    Error("AutoDoc 2016.01.21 or newer is required");
#fi;
#AutoDoc(rec(gapdoc := rec(files:=["PackageInfo.g"])));

MakeGAPDocDoc("doc","float",
            ["../lib/float.gd","../lib/pslq.gi","../PackageInfo.g"],"float","MathJax");
CopyHTMLStyleFiles("doc");
GAPDocManualLab("Float");

QUIT;
