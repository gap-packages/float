function intlablogo(angle)
%INTLABLOGO   Show INTLAB logo
%
%  intlablogo
%
%put cursor into figure and press
%
%  o  open
%  c  close
%  q  quit
%
%The call
%
%  intlablogo(angles)
%
%shows the dodecahedron in opening angles.
%

% generate file: print -djpeg100 -zbuffer picturefile
%

% written  10/16/98     S.M. Rump
% modified 04/04/04     S.M. Rump  revision
% modified 10/13/05     S.M. Rump  name and fonts adapted
%

  psi1 = 10.8123169636;
  psi2 = 52.6226318594;
  
  for i=1:5
    P{i} = polar2rect(1,72*i,psi2);
    P{5+i} = polar2rect(1,72*i,psi1);
    P{10+i} = polar2rect(1,72*i-36,-psi1);
    P{15+i} = polar2rect(1,72*i-36,-psi2);
  end
  
  M = zeros(18,5,3);
  
  M(1,:,:) = [ P{ 1} P{ 5} P{10} .5*(P{10}+P{11}) .5*(P{1}+P{6}) ]';
  M(2,:,:) = [ P{ 1} P{ 2} P{ 3} P{ 4} P{ 5} ]';
  M(3,:,:) = [ P{ 5} P{ 4} P{ 9} P{15} P{10} ]';
  M(4,:,:) = [ P{ 3} P{ 8} P{14} P{ 9} P{ 4} ]';
  M(5,:,:) = [ P{10} P{15} .5*(P{15}+P{20}) .5*(P{10}+P{11}) P{10}]';
  M(6,:,:) = [ P{ 1} P{ 2} .5*(P{2}+P{7}) .5*(P{6}+P{1}) P{1}]';
  M(7,:,:) = [ P{15} P{ 9} P{14} .5*(P{14}+P{19}) .5*(P{20}+P{15}) ]';
  M(8,:,:) = [ P{2} P{3} P{8} .5*(P{8}+P{13}) .5*(P{2}+P{7}) ]';
  M(9,:,:) = [ P{8} P{14} .5*(P{14}+P{19}) .5*(P{8}+P{13}) P{8} ]';
  M(10:18,:,:) = -M(1:9,:,:);
  
  dil = .25*( P{14}+P{19} + P{20}+P{15} );
  for i=1:3
    M(:,:,i) = M(:,:,i) - dil(i);
  end
  phi = atan2(dil(2),dil(1));
  T = [ cos(phi) -sin(phi) 0 ; ...
      sin(phi)  cos(phi) 0 ; ...
      0          0     1 ];
  M = reshape( reshape(M,90,3)*T , 18,5,3 );
  Az = 23.75; El = 12.5;
  close
  
  % show a couple of angles
  if nargin~=0
    psi = angle(1);
    omegaold = 0;
    for omega=angle
      psi = omega-omegaold;
      M = showlogo(psi,M);
      omegaold = omega;
      pause(0.05)
    end
    return
  end
  
  % open/close by hand
  psi = 30;
  delta = 5;
  omega = psi;
  change = 1;
  
  while change
    clf
    M = showlogo(psi,M);
    change = 0;
    
    title( [ 'move cursor into window and press  "o"  or  "c"  or,  "q" for quit' ], ...
             'FontName','Sans Serif','Fontsize',10 );
    shg
    waitforbuttonpress
    switch get(gcf,'CurrentCharacter')
      case 'o', 
        if omega <= 180,
          psi = delta; omega = omega + delta;
        else
          psi = 0;
        end
        change = 1;
      case 'c', 
        if omega >= delta
          psi = -delta; omega = omega - delta;
        else
          psi = 0;
        end
        change = 1;
    end
  end
  close
  

function M = showlogo(psi,M)
% opens logo by angle psi from current setting
  clf
  axis off
  axis equal
  axis([-1.5 1.5 -1.5 1.5 -.5 1.5])
  axis manual
  hold on
  Az = 23.75; El = 12.5;
  view(Az,El)
  
  for i=10:18
    rand('state',0);
    fill3(M(i,:,1),M(i,:,2),M(i,:,3),rand(1,5,3));
  end
  
  psi_ = psi/180*pi;
  T = [ cos(psi_) 0 -sin(psi_) ; ...
      0     1      0      ; ...
      sin(psi_) 0  cos(psi_) ];
  M(1:9,:,:) = reshape( reshape(M(1:9,:,:),45,3)*T , 9,5,3 );
  
  for i=1:9
    rand('state',0);
    fill3(M(i,:,1),M(i,:,2),M(i,:,3),rand(1,5,3));
  end
  addtext
  hold off
  

function x = polar2rect(r,phi,psi)     % in degrees
  x = zeros(3,1);
  sigma = pi/180;
  phi = sigma*phi;
  psi = sigma*psi;
  x(1) = cos(phi).*cos(psi);
  x(2) = sin(phi).*cos(psi);
  x(3) = sin(psi);
  x = r*x;


function addtext
  text(-1,-4  ,'INTLAB  -  INTerval LABoratory (Version 5.4)', ...
    'Fontsize',17, ...    % size 17 for intlablogo, size 14 for jpg
    'FontName','MS Reference Sans Serif', ...
    'HorizontalAlignment','left');
  text(-.47,-5.2,'Siegfried M. Rump, Institute for Reliable Computing, Hamburg University of Technology', ...
    'Fontsize',10, ...    % size 10 for intlablogo, size 8 for jpg
    'FontName','Sans Serif', ...
    'HorizontalAlignment','left');
  str(1) =    {' x = hessianinit(xs);'};
  str(2) =     {' y = f(x);'};
  str(3) = {' xs = xs - y.hx\\y.dx'';'};
  text(-.5, 7.2,str, ...
    'HorizontalAlignment','right', ...
    'Fontsize',13, ...
    'FontName','Courier');
  