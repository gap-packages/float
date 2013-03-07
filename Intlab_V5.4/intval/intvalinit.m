function res = intvalinit(param,see)
%INTVALINIT   Initialization and defaults for intval toolbox
%
%   intvalinit(param,see)
%
%possible values for param:
%
%  'license'                 Gives license information
%
%  'Version'                 Gives INTLAB version information
%
%  'Init'                    Initialize global constants (for startup file)
%
%  'CheckRounding'           Check directed rounding
%
%  'StoreDefaultSetting'     Store current setting as default setting
%
%Default display of intervals:
%  'Display_'                Display with uncertainty (e.g. 3.14_) but change to inf/sup for real
%                              or to mid/rad for complex input if intervals too wide 
%  'Display__'               Display with uncertainty (e.g. 3.14_) independent of width of input
%  'DisplayInfsup'           Display infimum/supremum (e.g. [ 3.14 , 3.15 ])
%  'DisplayMidrad'           Display midpoint/radius (e.g. < 3.14 , 0.01 >)
%  'Display'                 res = 'Display_'
%                                  'Display__'
%                                  'DisplayInfsup'
%                                  'DisplayMidrad'
%
%Default evaluation of standard functions:
%  'ApproximateStdFcts'      Use faster standard functions (not rigorous)
%                              (likely to be correct, but *not* rigorous
%                               and sometimes weak)
%  'RigorousStdFcts'         Use rigorous standard functions
%  'StdFcts'                 res = 'ApproximateStdFcts'
%                                  'RigorousStdFcts'
%
%Default exception handling for real interval standard functions:
%  'RealStdFctsExcptnAuto'   Complex interval stdfct used automatically for
%                                real interval input out of range (without warning)
%  'RealStdFctsExcptnWarn'   As 'RealStdFctsExcptnAuto', but with warning
%  'RealStdFctsExcptnNaN'    Result NaN for real interval input out of range
%  'RealStdFctsExcptnIgnore' Input arguments out of range ignored
%  'RealStdFctsExcptn'       res = 'RealStdFctsExcptnAuto'
%                                  'RealStdFctsExcptnWarn'
%                                  'RealStdFctsExcptnNaN'
%                                  'RealStdFctsExcptnIgnore'
%  'RealStdFctsExcptnOccurred'   Flag: result 1 iff input argument was out of range 
%                                while option 'RealStdFctsExcptnIgnore' was set; 
%                                Flag is reset after check
%
%Default linear system solver with thin input matrix:
%  'DoubleResidual'          Residual in double precision
%  'ImprovedResidual'        Simulated higher precision residual improvement for improved
%                              accuracy, for details see intval\lssresidual
%  'QuadrupleResidual'       Quadruple precision residual, see utility\dot_
%  'Residual'                res = 'DoubleResidual'
%                                  'ImprovedResidual'
%                                  'QuadrupleResidual'
%
%Default linear system solver:
%  'LssFirstSecondStage'     Verifylss for dense systems applies second stage only if 
%                              first stage fails (for details, see verifylss)
%  'LssSecondStage'          Verifylss for dense systems starts immediately with second stage
%  'LssStages'               res = 'LssFirstSecondStage'
%                                  'LssSecondStage'
%
%Default thick real interval times thick real interval:
%  'FastIVmult'              Fast algorithm by midpoint/radius arithmetic
%                              absolutely rigorous, worst case overestimation 1.5
%  'SharpIVmult'             Slow algorithm by infimum/supremum arithmetic
%                              slow for larger matrices due to interpretation overhead
%  'IVmult'                  res = 'FastIVmult'
%                                  'SharpIVmult'
%
%Default warning handling for x(i)=c, where x real interval array and c complex
%  'RealComplexAssignAuto'   Real interval arrays automatically transformed to
%                                complex array if a component is assigned a
%                                complex value (without warning)
%  'RealComplexAssignWarn'   As 'RealComplexAssignAuto', but with warning
%  'RealComplexAssignError'  Assignment of a complex value to a component of a
%                                real interval array causes an error
%  'RealComplexAssign'       res = 'RealComplexAssignAuto'
%                                  'RealComplexAssignWarn'
%                                  'RealComplexAssignError'
%Default warning handling for complex interval defined by infsup(zinf,zsup)
%  'ComplexInfSupAssignWarn'     Warning issued if complex interval defined by infsup(zinf,zsup)
%  'ComplexInfSupAssignNoWarn'   No warning issued if complex interval defined by infsup(zinf,zsup)
%  'ComplexInfSupAssign'         res = 'ComplexInfSupAssignWarn'
%                                      'ComplexInfSupAssignWarn'
%
%A corresponding message is printed when changing a default mode unless
%  it is explicitly suppressed with the (optional) parameter see=0.
%

% written  10/16/98     S.M. Rump
% modified 10/24/99     S.M. Rump  adapted to INTLAB V3, data files
%                                  appended with Matlab version, welcome
% modified 09/02/00     S.M. Rump  real/complex asignment
%                                  rounding unchanged after use
%                                  std fcts switch non-rigorous corrected
%                                    (thanks to S. Christiansen and N. Albertsen)
% modified 11/16/01     S.M. Rump  isieee removed
% modified 12/15/01     S.M. Rump  displaywidth added
% modified 02/15/02     S.M. Rump  Execution terminated if rounding fails
%                                  Automatic choice of setround .m / .dll
%                                  system_dependent('setround',0.5) for round to nearest (thanks to J.A. van de Griend)
% modified 03/09/02     S.M. Rump  Windows for stdfctsdata etc. deleted (Matlab problems)
% modified 04/02/02     S.M. Rump  Residual switch added
% modified 10/09/02     S.M. Rump  Rounding switch by global variable
% modified 11/30/03     S.M. Rump  second stage and quadruple prec. residual added
% modified 01/10/04     S.M. Rump  default display changed to infsup
% modified 04/04/04     S.M. Rump  set round to nearest for safety
%                                    InfNanFlag added
% modified 08/15/04     S.M. Rump  various little changes
% modified 08/21/04     S.M. Rump  INTLAB version added, file naming to cure Matlab/Unix problems
%                                    (thanks to George Corliss and Annie Yuk for pointing to this)
% modified 10/04/04     S.M. Rump  Warning for infsup(zinf,zsup) added
% modified 01/06/05     S.M. Rump  Check for Atlas BLAS added
% modified 04/06/05     S.M. Rump  rounding unchanged
% modified 12/02/05     S.M. Rump  'realstdfctsexcptnignore' added
% modified 02/11/06     S.M. Rump  SparseInfNanFlag removed
%				     wording (thanks to Jiri Rohn)
% modified 06/30/06     S.M. Rump  Sequence of checkrounding changed
% modified 12/03/06     S.M. Rump  Sparse Bug global flag (thanks to Arnold)
% modified 12/05/06     S.M. Rump  flag Display__, helpp file added
% modified 02/18/07     S.M. Rump  welcome, thanks to J. Rohn and C. Linsenmann
%

  e = 1e-30;
  if 1+e==1-e                           % fast check for rounding to nearest
    rndold = 0;
  else
    rndold = getround;
    setround(0)
  end

  if ( nargin==1 )
    see = 1;
  end

  switch lower(param)
    
  case 'checkrounding'
    %%%%%%%%%%%%%%%%% test for directed rounding  %%%%%%%%%%%%%%%%%

    r = TestRounding(0);
    if r~=0       % maybe wrong setround in use
      p = which('setround.dll');
      rmpath(p(1:end-13));
      ChooseSetRound;
      r = TestRounding(1);
      if r~=0       % rounding does not work
        disp('*********************************************************************')
        disp('*********************************************************************')
        disp('**                                                                 **')
        disp('** Errors in switching of rounding mode detected!                  **')
        disp('**                                                                 **')
        disp('** Any use of interval routines may produce **erreneous** results! **')
        disp('**                                                                 **')
        disp('** For Matlab 5.3, R11 or older under Windows:                     **')
        disp('**   Probably the .dll file for function "setround" is not         **')
        disp('**   installed or in the wrong path.                               **')
        disp('**                                                                 **')
        disp('** For Matlab 5.3, R12 and higher under Windows:                   **')
        disp('**   Delete "setround.dll" to allow access to the INTLAB           **')
        disp('**   function "setround.m".                                        **')
        disp('**                                                                 **')
        disp('** For other operatings systems, provide file for switching        **')
        disp('**   rounding mode (see INTLAB homepage).                          **')
        disp('**                                                                 **')
        disp('** Press Enter to terminate INTLAB                                 **')
        disp('**                                                                 **')
        disp('*********************************************************************')
        disp('*********************************************************************')
        pause
        exit
      end
    end
    % extra test for BLAS library
    x = 0.1*ones(2,1);
    if diam(x'*intval(x))==0
      disp('*********************************************************************')
      disp('*********************************************************************')
      disp('**                                                                 **')
      disp('** Errors in switching of rounding mode in BLAS detected!          **')
      disp('**                                                                 **')
      disp('** Any use of interval routines may produce **erreneous** results! **')
      disp('**                                                                 **')
      disp('** Probably you use Math Kernel Library (MKL) BLAS.                **')
      disp('**                                                                 **')
      disp('** Please switch environment to use the ATLAS library by setting   **')
      disp('**   the corresponding environment variable BLAS_VERSION.          **')
      disp('** Under Windows: In Start -> Settings -> Control Panel ->         **')
      disp('**       System -> Properties dialog box                           **')
      disp('**    click the new button and define a new user-defined           **')
      disp('**    environment variable BLAS_VERSION to be atlas_***.dll,       **')
      disp('**    where the appropriate atlas library for your processor       **')
      disp('**    can be found in <Matlab>\bin\win32 .                         **')
      disp('** For other operating systems check your Install guide or         **')
      disp('**   release notes - just search in the doc for it.                **')
      disp('** See file FAQ.txt for more information.                          **')
      disp('**                                                                 **')
      disp('** Press Enter to terminate INTLAB                                 **')
      disp('**                                                                 **')
      disp('*********************************************************************')
      disp('*********************************************************************')
      pause
      exit
    end
    disp('===> rounding checked and no errors detected')

  case 'license'
    disp(' ')
    disp('=========================================================================')
    disp('*****  Free for private and academic use. Commercial use or use in  *****')
    disp('*****  conjunction with a commercial program which requires INTLAB  *****')
    disp('*****  or part of INTLAB to functioning properly is prohibited.     *****')
    disp('=========================================================================')
    disp(' ')

  case 'storedefaultsetting'
    global INTLAB_SETTING
    INTLAB_SETTING = intlabsetting(0);
    
  case 'version'
    res = 'INTLAB_5.4';
    
  case 'init'
    %%%%%%%%%%%%%%%%% global variables for INTVAL %%%%%%%%%%%%%%%%%%%
    if see
      disp('===> Initialization of INTLAB toolbox')
    end

    intvalinit('checkrounding');       % for safety: check rounding
    setround(0)                        % initialize rounding mode
    
    global INTLAB_INTVAL_DISPLAY       % switch default display
    if isempty(INTLAB_INTVAL_DISPLAY)
      disp(' ')
      disp('**************************************************************')
      disp('*** Welcome to INTLAB - INTerval LABoratory Version 5.4    ***')
      disp('***   The Matlab toolbox for Reliable Computing            ***')
      disp('***   Siegfried M. Rump, Insitute for Reliable Computing   ***')
      disp('***   Hamburg University of Technology, Germany            ***')
      disp('**************************************************************')
      disp(' ')
    end
    INTLAB_INTVAL_DISPLAY = 'DisplayInfsup';
    
    v = version;
    index = findstr(v,'.');
    global INTLAB_SPARSE_BUG
    INTLAB_SPARSE_BUG = ( str2num(v(1:index(1)))<7 ) | ( str2num(v(index(1)+1:index(2)))<2 );

    global INTLAB_DISPLAY_WIDTH
    displaywidth(120,0);               % default width of display

    global INTLAB_INTVAL_STDFCTS       % switch approximate/rigorous stdfcts
    INTLAB_INTVAL_STDFCTS = 1;         % initialized to be rigrous

    global INTLAB_INTVAL_STDFCTS_EXCPTN % switch stdfct input out of real range
    INTLAB_INTVAL_STDFCTS_EXCPTN = 1;  % initialized to switch to complex
                                       %   interval stdfct with warning

    global INTLAB_INTVAL_STDFCTS_EXCPTN_ % flag: input out of range occurred while
    INTLAB_INTVAL_STDFCTS_EXCPTN_ = 0;   % 'RealStdFctsExcptnIgnore' active

    global INTLAB_INTVAL_RESIDUAL      % Residual calculation in verifylss
    INTLAB_INTVAL_RESIDUAL = 1;        % initialized to be more accurate
    
    global INTLAB_INTVAL_FIRST_SECOND_STAGE
    INTLAB_INTVAL_FIRST_SECOND_STAGE = 1;  % Verifylss for dense systems applies 
                                       % second stage only if first stage fails
                                       
    global INTLAB_INTVAL_IVMULT        % Real interval multiplication
    INTLAB_INTVAL_IVMULT = 0;          % initialized to be fast

    global INTLAB_INTVAL_STDFCTS_RCASSIGN % Real interval array(i) = complex
    INTLAB_INTVAL_STDFCTS_RCASSIGN = 1; % initialized to be done with type
                                       %  conversion to complex (with warning)

    global INTLAB_INTVAL_EPSSTDFCTS    % extra inflation for standard functions
    INTLAB_INTVAL_EPSSTDFCTS = 4*eps;

    global INTLAB_INTVAL_STDFCTS_LOGREALMAX   % largest x with exp(x) finite
    INTLAB_INTVAL_STDFCTS_LOGREALMAX = (12486629536300000+30718)*2^-44;

    global INTLAB_INTVAL_ETA           % smallest positive denormalized fl-pt
    INTLAB_INTVAL_ETA = realmin/2^52;

    global INTLAB_INTVAL_POWER10
    fname = intvalinit('version');
    fname(fname=='.') = '_';
    fname = [ 'power10tobinary' lower(computer) fname ];
    try
      load(fname)
    catch
      disp('**** File power10tobinary.mat for rigorous interval output is missing')
      disp('**** Data will be generated now and saved in file power10tobinary.mat')
      disp('**** (takes a short while)')
      initpower10
      save(fname,'INTLAB_INTVAL_POWER10')
      disp('**** Data successfully generated and stored to file power10tobinary.mat')
    end

  case 'display'
    global INTLAB_INTVAL_DISPLAY
    res = INTLAB_INTVAL_DISPLAY;

  case 'display_'
    global INTLAB_INTVAL_DISPLAY
    INTLAB_INTVAL_DISPLAY = 'Display_';
    if see
      disp('===> Default display of intervals with uncertainty (e.g. 3.14_), inf/sup or mid/rad if input too wide ')
    end

  case 'display__'
    global INTLAB_INTVAL_DISPLAY
    INTLAB_INTVAL_DISPLAY = 'Display__';
    if see
      disp('===> Default display of intervals with uncertainty (e.g. 3.14_) independent of input width ')
    end

  case 'displayinfsup'
    global INTLAB_INTVAL_DISPLAY
    INTLAB_INTVAL_DISPLAY = 'DisplayInfsup';
    if see
      disp('===> Default display of intervals by infimum/supremum (e.g. [ 3.14 , 3.15 ])')
    end

  case 'displaymidrad'
    global INTLAB_INTVAL_DISPLAY
    INTLAB_INTVAL_DISPLAY = 'DisplayMidrad';
    if see
      disp('===> Default display of intervals by midpoint/radius (e.g. < 3.14 , 0.01 >)')
    end

  case 'stdfcts'
    global INTLAB_INTVAL_STDFCTS
    if INTLAB_INTVAL_STDFCTS
      res = 'RigorousStdFcts';
    else
      res = 'ApproximateStdFcts';
    end
    
  case 'stdfctsfile'
    version_ = version;
    i = find( version_==' ' );
    if ~isempty(i)
      version_ = version_(1:i-1);
    end
    version_ = [ intvalinit('version') '.' lower(computer) version_ ];
    version_(version_=='.') = '_';
    res = [ 'stdfctsdata' version_ '.mat' ];

  case 'helppfile'
    res = 'helppdata.mat';

  case 'approximatestdfcts'
    global INTLAB_INTVAL_STDFCTS
    INTLAB_INTVAL_STDFCTS = 0;
    if see
      disp('===> Faster but not rigorous standard functions in use')
    end

  case 'rigorousstdfcts'
    fname = intvalinit('stdfctsfile');
    global INTLAB_INTVAL_STDFCTS_SUCCESS
    global INTLAB_INTVAL_STDFCTS
    try
      load(fname)
    catch
      disp('**** Data for rigorous standard functions are missing,       ')
      disp('**** generation takes about 2 minutes on a 1.2 GHz Laptop.   ')
      disp('**** Data will be generated _once_ and stored during the     ')
      disp('**** very first call of a new version of Matlab or INTLAB.   ')
      stdfctsdata
    end
    stdfctsinit
    if INTLAB_INTVAL_STDFCTS_SUCCESS
      INTLAB_INTVAL_STDFCTS = 1;
      if see
        disp('===> Rigorous standard functions in use')
      end
    else
      INTLAB_INTVAL_STDFCTS = 0;
      disp('*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*')
      disp('*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*')
      disp('*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*')
      warning('Relative errors too large; APPROXIMATE STANDARD FUNCTIONS STILL IN USE')
      disp('===> Faster but ***not rigorous*** interval standard functions in use **')
      disp('===> --- [ Computation on the base of  y*(1+/-eps) ]                  **')
      disp('*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*')
      disp('*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*')
      disp('*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*')
    end

  case 'realstdfctsexcptn'
    global INTLAB_INTVAL_STDFCTS_EXCPTN
    switch INTLAB_INTVAL_STDFCTS_EXCPTN
      case 0, res = 'RealStdFctsExcptnAuto';
      case 1, res = 'RealStdFctsExcptnWarn';
      case 2, res = 'RealStdFctsExcptnNaN';
      case 3, res = 'RealStdFctsExcptnIgnore';
    end

  case 'realstdfctsexcptnauto'
    global INTLAB_INTVAL_STDFCTS_EXCPTN
    INTLAB_INTVAL_STDFCTS_EXCPTN = 0;
    if see
      disp(sprintf([ '===> Complex interval stdfct used automatically for real interval input \n'  ...
                     '         out of range (without warning)']))
    end

  case 'realstdfctsexcptnwarn'
    global INTLAB_INTVAL_STDFCTS_EXCPTN
    INTLAB_INTVAL_STDFCTS_EXCPTN = 1;
    if see
      disp(sprintf([ '===> Complex interval stdfct used automatically for real interval input \n'  ...
             '         out of range, but with warning']))
    end

  case 'realstdfctsexcptnnan'
    global INTLAB_INTVAL_STDFCTS_EXCPTN
    INTLAB_INTVAL_STDFCTS_EXCPTN = 2;
    if see
      disp([ '===> Result NaN for real interval input out of range '])
    end

  case 'realstdfctsexcptnignore'
    global INTLAB_INTVAL_STDFCTS_EXCPTN
    INTLAB_INTVAL_STDFCTS_EXCPTN = 3;
    if see
      disp([ '===> !!! Caution: Input arguments out of range are ignored !!!'])
    end
    s = sprintf([ '===> !!! Caution: Input arguments out of range are ignored !!! \n' ...
                  '         ===> !!! Use intvalinit(''RealStdFctsExcptnOccurred'') to check whether this happened !!! \n' ...
                  '         ===> !!! Using Brouwer''s Fixed Point Theorem may yield erroneous results (see Readme.txt) !!!']);
    warning(s)

  case 'realstdfctsexcptnoccurred'
    global INTLAB_INTVAL_STDFCTS_EXCPTN_
    res = INTLAB_INTVAL_STDFCTS_EXCPTN_;
    INTLAB_INTVAL_STDFCTS_EXCPTN_ = 0;

  case 'residual'
    global INTLAB_INTVAL_RESIDUAL
    if INTLAB_INTVAL_RESIDUAL==0
      res = 'DoubleResidual';
    elseif INTLAB_INTVAL_RESIDUAL==1
      res = 'ImprovedResidual';
    else
      res = 'QuadrupleResidual';
    end

  case 'doubleresidual'
    global INTLAB_INTVAL_RESIDUAL
    INTLAB_INTVAL_RESIDUAL = 0;
    if see
      disp('===> Double precision residual calculation in verifylss')
    end

  case 'improvedresidual'
    global INTLAB_INTVAL_RESIDUAL
    INTLAB_INTVAL_RESIDUAL = 1;
    if see
      disp('===> Improved residual calculation in verifylss')
    end
    
  case 'quadrupleresidual'
    global INTLAB_INTVAL_RESIDUAL
    INTLAB_INTVAL_RESIDUAL = 2;
    if see
      disp('===> Quadruple precision residual calculation by dot_ in verifylss')
    end
    
  case 'lssstages'
    global INTLAB_INTVAL_FIRST_SECOND_STAGE
    if INTLAB_INTVAL_FIRST_SECOND_STAGE
      res = 'LssFirstSecondStage';
    else
      res = 'LssSecondStage';
    end

  case 'lssfirstsecondstage'
    global INTLAB_INTVAL_FIRST_SECOND_STAGE
    INTLAB_INTVAL_FIRST_SECOND_STAGE = 1;
    if see
      disp('===> Verifylss for dense systems applies second stage only if first stage fails')
    end

  case 'lsssecondstage'
    global INTLAB_INTVAL_FIRST_SECOND_STAGE
    INTLAB_INTVAL_FIRST_SECOND_STAGE = 0;
    if see
      disp('===> Verifylss for dense systems omits first stage and applies only second stage')
    end
    
  case 'ivmult'
    global INTLAB_INTVAL_IVMULT
    if INTLAB_INTVAL_IVMULT
      res = 'SharpIVmult';
    else
      res = 'FastIVmult';
    end
    
  case 'fastivmult'
    global INTLAB_INTVAL_IVMULT
    INTLAB_INTVAL_IVMULT = 0;
    if see
      disp(sprintf([ '===> Fast interval matrix multiplication in use (maximum overestimation \n'  ...
             '         factor 1.5 in radius)']))
    end

  case 'sharpivmult'
    global INTLAB_INTVAL_IVMULT
    INTLAB_INTVAL_IVMULT = 1;
    if see
      disp('===> Slow but sharp interval matrix multiplication in use')
    end

  case 'realcomplexassign'
    global INTLAB_INTVAL_STDFCTS_RCASSIGN
    switch INTLAB_INTVAL_STDFCTS_RCASSIGN
      case 0, res = 'RealComplexAssignAuto';
      case 1, res = 'RealComplexAssignWarn';
      case 2, res = 'RealComplexAssignError';
    end

  case 'realcomplexassignauto'
    global INTLAB_INTVAL_STDFCTS_RCASSIGN
    INTLAB_INTVAL_STDFCTS_RCASSIGN = 0;
    if see
      disp(sprintf([ '===> Real interval arrays automatically transformed to complex array \n'  ...
             '         if a component is assigned a complex value (without warning)']))
    end

  case 'realcomplexassignwarn'
    global INTLAB_INTVAL_STDFCTS_RCASSIGN
    INTLAB_INTVAL_STDFCTS_RCASSIGN = 1;
    if see
      disp(sprintf([ '===> Real interval arrays automatically transformed to complex array \n'  ...
             '         if a component is assigned a complex value (with warning)']))
    end

  case 'realcomplexassignerror'
    global INTLAB_INTVAL_STDFCTS_RCASSIGN
    INTLAB_INTVAL_STDFCTS_RCASSIGN = 2;
    if see
      disp(sprintf([ '===> An error message is caused when a component of a real interval array \n'  ...
                     '         component is assigned a complex value ']))
    end

  case 'complexinfsupassign'
    global INTLAB_INTVAL_CINFSUPASGN
    if INTLAB_INTVAL_CINFSUPASGN
      res = 'ComplexInfSupAssignWarn';
    else
      res = 'ComplexInfSupAssignNoWarn';
    end
    
  case 'complexinfsupassignwarn'
    global INTLAB_INTVAL_CINFSUPASGN
    INTLAB_INTVAL_CINFSUPASGN = 1;
    if see
      disp('===> Warning issued when complex interval defined by infsup(zinf,zsup)')
    end

  case 'complexinfsupassignnowarn'
    global INTLAB_INTVAL_CINFSUPASGN
    INTLAB_INTVAL_CINFSUPASGN = 0;
    if see
      disp('===> No warning issued when complex interval defined by infsup(zinf,zsup)')
    end

  otherwise
    error('intvalinit called with invalid argument')

  end
  
  
  if rndold~=0
    setround(rndold)
  end
  
  
  
function ChooseSetRound
% called, when .dll does not work
% first option, use feature, the fastest
% if this does not work, use system_dependent

  % test whether feature is available
  lasterr('');
  success = 1;
  try
    feature('setround',-inf);
    feature('setround',0.5);
    feature('setround',inf);
    feature('setround',0);
    success = 1;
  catch
    success = 0;                % by initialization, \setround_\setround.m is used
  end    
  
  if success
    p = which('setround.m');    % use faster \intval\setround.m with feature
    rmpath(p(1:end-11));
    lasterr('');
    % cross check whether feature is available
    try
      setround(-1)
      setround(1)
      setround(2)
      setround(0)
    catch
      addpath(p(1:end-11));     % this should never happen
      lasterr('');
      success = 0;
    end
  end

  if ~success                   % feature not available, use system_dependent
    % test rounding to nearest in system_dependent for parameter 0.5 or 'nearest'
    lasterr('');
    global INTLAB_ROUND_TO_NEAREST
    INTLAB_ROUND_TO_NEAREST = 0.5;
    try
      system_dependent('setround',INTLAB_ROUND_TO_NEAREST);
    catch
      INTLAB_ROUND_TO_NEAREST = 'nearest';
      lasterr('');
    end
  end


  

function res = TestRounding(see)
%INTVAL extensive test of rounding
%
% res = 0   finished without errors detected
%       1   errors detected
% see = 0   suppress error codes
%       1   show errors
%

  res = 0;
  
  setround(0)
  e=eps*eps;
  if (1+e)~=1
    res = 1;
    if see, disp('error in rounding to nearest 1'), end
  end
  if (-1+e)~=-1
    res = 1;
    if see, disp('error in rounding to nearest 2'), end
  end

  setround(1)
  if (1+e)<=1
    res = 1;
    if see, disp('error in rounding to up 1    '), end
  end
  if (-1+e)<=-1
    res = 1;
    if see, disp('error in rounding to up 2    '), end
  end

  setround(-1)
  if (1-e)>=1
    res = 1;
    if see, disp('error in rounding to down 1 '), end
  end
  if (-1-e)>=-1
    res = 1;
    if see, disp('error in rounding to down 2 '), end
  end

  setround(0)
  if (1+e)~=1
    res = 1;
    if see, disp('error in rounding to nearest 3'), end
  end
  if (-1+e)~=-1
    res = 1;
    if see, disp('error in rounding to nearest 4'), end
  end


function initpower10
%Initialization of global variable INTLAB_INTVAL_POWER10
%
%For integer e in [-340,309] and integer m in [1,9] it is
%
%  INTLAB_INTVAL_POWER10.inf(m,E)  <= m*10^e <=  INTLAB_INTVAL_POWER10.sup(m,E)
%
%where E:=e+341 and binary numbers INTLAB_INTVAL_POWER10.inf and
%  INTLAB_INTVAL_POWER10.sup are best possible.
%For fast computations, INTLAB_INTVAL_POWER10.sup(1) := 0 !
%
%Implementation uses a simplified long arithmetic with long representing
%
%    sum( i , long(i) * base^i )
%
%for base = 2^47 and 0 <= long(i) < 2*base
%

  global INTLAB_INTVAL_POWER10
  setround(0)

  baseExponent = 47;
  base = 2^baseExponent;
  imax = 4;
  emin = -340;
  emax = 309;
  INTLAB_INTVAL_POWER10.inf = zeros(9,emax-emin+1);
  INTLAB_INTVAL_POWER10.sup = zeros(9,emax-emin+1);

  long = zeros(1,23+imax);   % exponents >= 0
  long(23) = 1;
  first = 23;
  for e=0:emax
    for m=1:9

      long_ = m*long;

      setround(-1)
      s = 0;
      for i=imax:-1:0
        s = s/base + long_(first+i) ;
      end
      INTLAB_INTVAL_POWER10.inf(m,e-emin+1) = ...
        s * 2^( baseExponent*(23-first) );
      setround(1)
      s = any(long_(first+imax+1:end)~=0)/base;
      for i=imax:-1:0
        s = s/base + long_(first+i) ;
      end
      INTLAB_INTVAL_POWER10.sup(m,e-emin+1) = ...
        s * 2^( baseExponent*(23-first) );
      setround(0)
    end

    long = 10*long;
    q = floor(long/base);
    long = long - q*base;
    long(1:end-1) = long(1:end-1) + q(2:end);
    first = first - (long(first-1)~=0);
  end

  lmax = 30;

  long = zeros(1,lmax);   % exponents < 0, rounding downwards
  long(1) = 1;
  first = 1;
  for e=-1:-1:emin

    for i=first:lmax-1
      q = floor(long(i)/10);
      long(i+1) = long(i+1) + (long(i)-10*q)*base;
      long(i) = q;
    end
    long(lmax) = floor(long(lmax)/10);
    first = first + (long(first)==0);

    for m=1:9

      long_ = m*long;

      setround(-1)
      s = 0;
      for i=imax:-1:0
        s = s/base + long_(first+i) ;
      end
      INTLAB_INTVAL_POWER10.inf(m,e-emin+1) = ...        % avoid underflow
        s * 2^( baseExponent*(10-first) ) * 2^( baseExponent*(-9) );
      setround(0)
    end
  end

  long = zeros(1,lmax);   % exponents < 0, rounding upwards
  long(1) = 1;
  first = 1;
  for e=-1:-1:emin

    for i=first:lmax-1
      q = floor(long(i)/10);
      long(i+1) = long(i+1) + (long(i)-10*q)*base;
      long(i) = q;
    end
    long(lmax) = floor(long(lmax)/10) + 1;
    first = first + (long(first)==0);

    for m=1:9

      long_ = m*long;

      setround(1)
      s = 1/base;
      for i=imax:-1:0
        s = s/base + long_(first+i) ;
      end
      INTLAB_INTVAL_POWER10.sup(m,e-emin+1) = ...        % avoid underflow
        s * 2^( baseExponent*(10-first) ) * 2^( baseExponent*(-9) );
      setround(0)
    end
  end

  INTLAB_INTVAL_POWER10.sup(1) = 0;
  INTLAB_INTVAL_POWER10.inf(3056) = 0.5;
  INTLAB_INTVAL_POWER10.sup(3056) = 0.5;
