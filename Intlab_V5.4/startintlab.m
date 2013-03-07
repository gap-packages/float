function startintlab
%STARTINTLAB  Initialization of paths, global variables etc.
%             Adapt this to your local needs
%

% written  10/16/98   S.M. Rump
% modified 11/05/98   allow blanks in path name, Max Jerrell, Flagstaff
% modified 10/23/99   S.M. Rump  change directory before intvalinit('init'),
%                                work directory
% modified 12/15/01   S.M. Rump  displaywidth added
% modified 12/08/02   S.M. Rump  reset directory to old dir (Matlab problems under unix)
% modified 12/18/02   S.M. Rump  Hessians added
% modified 04/04/04   S.M. Rump  working directory added, clear removed, changed to function
%                                  adapted to new functionalities
% modified 11/09/05   S.M. Rump  working dir and cd(INTLABPATH) removed, INTLABPATH computed
% modified 02/11/06   S.M. Rump  SparseInfNanFlag removed
% modified 06/15/06   S.M. Rump  directory name corrected (thanks to Jaap van de Griend)
% modified 05/09/07   S.M. Rump  path corrected (thanks to Bastian Ebeling)
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Default setting:  change these lines to your needs   %%%%%%%%%%%%%%
%VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV

% Intlab directory

% Defines INTLABPATH to be the directory, in which this file "startintlab" is contained
  dir_startintlab = which('startintlab');
  INTLABPATH = dir_startintlab(1:end-13);

% If INTLAB is contained in another directory, please uncomment and adapt this line
% INTLABPATH = 'C:\INTLAB VERSIONS\INTLAB\';           % blanks allowed 


%AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%% add new paths
 
  addpath( [ INTLABPATH ]                           , ...
           [ INTLABPATH 'setround_' ]               , ...
           [ INTLABPATH 'setround' ]                , ...
           [ INTLABPATH 'intval' ]                  , ...
           [ INTLABPATH 'gradient' ]                , ...
           [ INTLABPATH 'hessian' ]                 , ...
           [ INTLABPATH 'slope' ]                   , ...
           [ INTLABPATH 'polynom' ]                 , ...
           [ INTLABPATH 'utility' ]                 , ...
           [ INTLABPATH 'long' ]                    , ...
           [ INTLABPATH 'demos' ])

%%%%%%%%%% set INTLAB environment

  format compact
  format short


%%%%%%%%%% initialize sparse systems

  spparms('autommd',0);            % switch off automatic band reduction
                                   % ( switching on may slow down sparse
                                   %   computations dramatically )


%%%%%%%%%% initialize interval toolbox (see "help intvalinit")

  intvalinit('Init')               % Initialize global constants
  intvalinit('CheckRounding')      % Check directed rounding



%%%%%%%%%% initialize gradient toolbox

  gradientinit


%%%%%%%%%% initialize Hessian toolbox

  hessianinit


%%%%%%%%%% initialize slope toolbox

  slopeinit


%%%%%%%%%% initialize long toolbox

  longinit('Init')


%%%%%%%%%% initialize polynom toolbox

  polynominit('Init')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Default setting:  change these lines to your needs   %%%%%%%%%%%%%%
%VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV

  displaywidth(120);               % width of output

  intvalinit('Display_')
  intvalinit('RigorousStdFcts')
  intvalinit('RealStdFctsExcptnWarn')
  intvalinit('ImprovedResidual')
  intvalinit('LssFirstSecondStage')
  intvalinit('FastIVMult')
  intvalinit('RealComplexAssignAuto')
  intvalinit('ComplexInfSupAssignWarn')

  longinit('WithErrorTerm')

  sparsegradient(50);     % Gradients stored sparse for fifty and more variables
  gradientinit('GradientSparseArrayDerivWarn')

  polynominit('DisplayUPolySparse')
  polynominit('EvaluateUPolyHorner')
  polynominit('EvaluateMPolyPower')
  polynominit('AccessVariableWarn')

  slopeinit('SlopeSparseArrayDerivWarn')

  sparsehessian(10);      % Hessians stored sparse for ten and more variables
  hessianinit('HessianSparseArrayDerivWarn')

%AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  intlablogo([0:4:32 32:-4:24 24:4:32])
  pause(0.5)
  close
  intvalinit('license')
  
  
%%%%%%%%%% store current setting as default setting
  
  intvalinit('StoreDefaultSetting')
  
  
%%%%%%%%%% set working environment

setround(0)             % set rounding to nearest

% uncomment and adapt this statement if necessary
% cd('c:\rump\matlab\work')
  