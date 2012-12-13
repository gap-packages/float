function setround(rnd)
%SETROUND     Switch rounding mode
%
%   setround(rnd)
%
%For  rnd = -1  switch rounding downwards (towards -inf)
%     rnd =  0  switch rounding to nearest
%     rnd =  1  switch rounding upwards (towards inf)
%     rnd =  2  switch rounding towards zero (chop)
%
%For Matlab V5.3+ and following under Windows this is already available
%  by the Matlab-routine 'system_dependent', see below. In this case delete
%  the routine 'setround.dll' (if it is present). INTLAB version 3.1+
%  should do that automatically for you.
%Otherwise, a corresponding 'setround.dll' routine is to be used.
%  For some architectures those can be found on our home page.
%
%It is assumed that the processor is permanently switched into the
%specified rounding mode, i.e. all subsequent operations are performed
%according to this rounding mode. When invoking INTLAB, always
%
%  intvalinit('CheckRounding')
%
%is called to be sure the preceding statement is true. Apparently, there
%are difficulties with DEC Alpha workstations in which op-codes carry
%an individual rounding mode.
%

% written  11/30/98     S.M. Rump
% modified 12/18/99     S.M. Rump  system dependent call for Matlab V5.3.1f
%                                  under Windows added
% modified 02/15/02     S.M. Rump  rounding to nearest changed to 0.5 (should work under Linux, too, 
%                                     thanks to Dr. Jaap A. van de Griend)
% modified 10/09/02     S.M. Rump  Rounding switch by global variable
% modified 11/02/05     S.M. Rump  this one only for older versions of Matlab
%

% The following should work under Matlab 6+, also under Linux operating system.
%

  global INTLAB_ROUND_TO_NEAREST
  
  switch rnd
    case  0, system_dependent('setround',INTLAB_ROUND_TO_NEAREST)         % round to nearest
    case -1, system_dependent('setround',-inf)        % round towards -inf
    case  1, system_dependent('setround',inf)         % round towards +inf
    case  2, system_dependent('setround',0)           % round towards zero (chop)
  otherwise
    error('invalid input argument to setround')
  end
