function nnd19os(cmd,arg1,arg2,arg3)
%NND19OS Orienting subsystem demonstration.

% $Revision: 1.6 $
% Copyright 1994-2002 PWS Publishing Company and The MathWorks, Inc.
% First Version, 8-31-95.

%==================================================================

% GLOBALS
global p;
global a;
global A;
global B;

% CONSTANTS
me = 'nnd19os';
Fs = 8192;

% DEFAULTS
if nargin == 0, cmd = ''; else cmd = lower(cmd); end

% FIND WINDOW IF IT EXISTS
fig = nndfgflg(me);
if length(get(fig,'children')) == 0, fig = 0; end

% GET WINDOW DATA IF IT EXISTS
if fig
  H = get(fig,'userdata');
  fig_axis = H(1);         % window axis
  desc_text = H(2);        % handle to first line of text sequence
  big_axis = H(3);         % Big axis
  p1_on = H(4);
  p1_off = H(5);
  p2_on = H(6);
  p2_off = H(7);
  a1_on = H(8);
  a1_off = H(9);
  a2_on = H(10);
  a2_off = H(11);
  old_ptr = H(12);
  last_ptr = H(13);
  A_bar = H(14);
  A_text = H(15);
  B_bar = H(16);
  B_text = H(17);
  big_line = H(18);
end

%==================================================================
% Activate the window.
%
% ME() or ME('')
%==================================================================

if strcmp(cmd,'')
  if fig
    figure(fig)
    set(fig,'visible','on')
  else
    feval(me,'init')
  end

%==================================================================
% Close the window.
%
% ME() or ME('')
%==================================================================

elseif strcmp(cmd,'close') & (fig)
  delete(fig)

%==================================================================
% Initialize the window.
%
% ME('init')
%==================================================================

elseif strcmp(cmd,'init') & (~fig)

  % CONSTANTS
  p1 = 1;
  p2 = 1;
  a1 = 1;
  a2 = 0;
  p = [p1;p2];
  a = [a1;a2];
  A = 3;
  B = 4;

  % NEW DEMO FIGURE
  fig = nndemof2(me,'DESIGN','Orienting Subsystem','','Chapter 19');

  set(fig, ...
    'windowbuttondownfcn',nncallbk(me,'down'), ...
    'BackingStore','off',...
    'nextplot','add');
  H = get(fig,'userdata');
  fig_axis = H(1);
  desc_text = H(2);

  % ICON
  nndicon(19,458,363,'shadow')

  % FIRST INPUT RADIO BUTTON
  x = 30;
  y = 130;
  text(x,y,'Input p(1):',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','left')
  p1_off = uicontrol(...
    'units','points',...
    'pos',[x+80 y-10 30 20],...
    'style','radio',...
    'string','0',...
    'back',nnltgray,...
    'value',1-p1,...
    'callback',[me '(''p1off'')']);
  p1_on = uicontrol(...
    'units','points',...
    'pos',[x+115 y-10 30 20],...
    'style','radio',...
    'string','1',...
    'back',nnltgray,...
    'value',p1,...
    'callback',[me '(''p1on'')']);

  % SECOND INPUT RADIO BUTTON
  x = 30;
  y = 95;
  text(x,y,'Input p(2):',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','left')
  p2_off = uicontrol(...
    'units','points',...
    'pos',[x+80 y-10 30 20],...
    'style','radio',...
    'string','0',...
    'back',nnltgray,...
    'value',1-p2,...
    'callback',[me '(''p2off'')']);
  p2_on = uicontrol(...
    'units','points',...
    'pos',[x+115 y-10 30 20],...
    'style','radio',...
    'string','1',...
    'back',nnltgray,...
    'value',p2,...
    'callback',[me '(''p2on'')']);

  % FIRST OUTPUT RADIO BUTTON
  x = 210;
  y = 130;
  text(x,y,'Input a1(1):',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','left')
  a1_off = uicontrol(...
    'units','points',...
    'pos',[x+80 y-10 30 20],...
    'style','radio',...
    'string','0',...
    'back',nnltgray,...
    'value',1-a1,...
    'callback',[me '(''a1off'')']);
  a1_on = uicontrol(...
    'units','points',...
    'pos',[x+115 y-10 30 20],...
    'style','radio',...
    'string','1',...
    'back',nnltgray,...
    'value',a1,...
    'callback',[me '(''a1on'')']);

  % SECOND OUTPUT RADIO BUTTON
  x = 210;
  y = 95;
  text(x,y,'Input a1(2):',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','left')
  a2_off = uicontrol(...
    'units','points',...
    'pos',[x+80 y-10 30 20],...
    'style','radio',...
    'string','0',...
    'back',nnltgray,...
    'value',1-a2,...
    'callback',[me '(''a2off'')']);
  a2_on = uicontrol(...
    'units','points',...
    'pos',[x+115 y-10 30 20],...
    'style','radio',...
    'string','1',...
    'back',nnltgray,...
    'value',a2,...
    'callback',[me '(''a2on'')']);

  % W+ VALUES
  x = 30;
  y = 60;
  len = 140;
  text(x,y,'+W0 Elements:',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','left')
  A_text = text(x+len,y,sprintf('%3.1f',A),...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','right');
  text(x,y-36,'0.1',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',10,...
    'horizontalalignment','left')
  text(x+len,y-36,'5.0',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',10,...
    'horizontalalignment','right');
  A_bar = uicontrol(...
    'units','points',...
    'position',[x y-25 len 16],...
    'style','slider',...
    'backg',nnltgray,...
    'callback',[me '(''a'')'],...
    'min',0,...
    'max',5,...
    'value',A);

  % TRANSFER FUNCTION CONSTANT
  x = 210;
  y = 60;
  len = 140;
  text(x,y,'-W0 Elements:',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','left')
  B_text = text(x+len,y,sprintf('%3.1f',B),...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','right');
  text(x,y-36,'0.1',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',10,...
    'horizontalalignment','left')
  text(x+len,y-36,'5.0',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',10,...
    'horizontalalignment','right');
  B_bar = uicontrol(...
    'units','points',...
    'position',[x y-25 len 16],...
    'style','slider',...
    'backg',nnltgray,...
    'callback',[me '(''b'')'],...
    'min',0,...
    'max',5,...
    'value',B);

  % BIG AXES
  big_axis = nnsfo('a1','Response','Time','Reset a0');
  set(big_axis,...
    'position',[50 180 300 160],...
    'xlim',[-0.004 0.204],...
    'xtick',0:0.05:0.2,...
    'ylim',[-1.1 1.1],...
    'ytick',-1:0.5:1)
  big_line = plot([-0.004 0.204],[0 0],'--',...
    'color',nndkblue,...
    'erasemode','none');

  % PLOT RESPONSE
  [T,Y] = ode45('nndao',[0 0.2],0);
  Y = Y';
  T = T';
  set(fig,'nextplot','add')
  last = plot(T,Y(1,:),...
    'color',nnred,...
    'linewidth',2,...
    'erasemode','none');

  % BUTTONS
  uicontrol(...
    'units','points',...
    'position',[410 165 60 20],...
    'string','Update',...
    'callback',[me '(''update'')'])
  uicontrol(...
    'units','points',...
    'position',[410 130 60 20],...
    'string','Clear',...
    'callback',[me '(''clear'')'])
  uicontrol(...
    'units','points',...
    'position',[410 95 60 20],...
    'string','Contents',...
    'callback','nndtoc')
  uicontrol(...
    'units','points',...
    'position',[410 60 60 20],...
    'string','Close',...
    'callback',[me '(''close'')'])

  % SAVE WINDOW DATA AND LOCK
  old_ptr = uicontrol('visible','off','userdata',[]);
  last_ptr = uicontrol('visible','off','userdata',last);

  H = [fig_axis, ...
       desc_text,...
       big_axis, ...
       p1_on p1_off p2_on p2_off, ...
       a1_on a1_off a2_on a2_off,...
       old_ptr, last_ptr,...
       A_bar A_text B_bar B_text,...
       big_line];

  set(fig,'userdata',H,'nextplot','new')

  % INSTRUCTION TEXT
  feval(me,'instr');

  % LOCK WINDOW
  set(fig,...
   'nextplot','new',...
   'color',nnltgray);

  nnchkfs;

%==================================================================
% Display the instructions.
%
% ME('instr')
%==================================================================

elseif strcmp(cmd,'instr') & (fig)
  nnsettxt(desc_text,...
    'Adjust the inputs,',...
    '& constants then',...
    'push [Update] to',...
    'see the system',...
    'respond.',...
    '',...
    'Click [Clear] to',...
    'remove old responses.')
    
%==================================================================
% Clear input vectors.
%
% ME('clear')
%==================================================================

elseif strcmp(cmd,'clear') & (fig) & (nargin == 1)
  
  % GET DATA
  old = get(old_ptr,'userdata');
  last = get(last_ptr,'userdata');

  % REMOVE OLD
  set(old,'color',nnltyell);
  set(last(1),'color',nnred)
  set(big_line,'color',nndkblue);
  drawnow
  delete(old);

  % SAVE DATA
  set(old_ptr,'userdata',[]);

%==================================================================
% Respond to p1 on.
%
% ME('p1on')
%==================================================================

elseif strcmp(cmd,'p1on')
  
  set(p1_off,'value',0)

%==================================================================
% Respond to p1 off.
%
% ME('p1off')
%==================================================================

elseif strcmp(cmd,'p1off')
  
  set(p1_on,'value',0)

%==================================================================
% Respond to p2 on.
%
% ME('p2on')
%==================================================================

elseif strcmp(cmd,'p2on')
  
  set(p2_off,'value',0)

%==================================================================
% Respond to p2 off.
%
% ME('p2off')
%==================================================================

elseif strcmp(cmd,'p2off')
  
  set(p2_on,'value',0)

%==================================================================
% Respond to a1 on.
%
% ME('a1on')
%==================================================================

elseif strcmp(cmd,'a1on')
  
  set(a1_off,'value',0)

%==================================================================
% Respond to a1 off.
%
% ME('a1off')
%==================================================================

elseif strcmp(cmd,'a1off')
  
  set(a1_on,'value',0)

%==================================================================
% Respond to a2 on.
%
% ME('a2on')
%==================================================================

elseif strcmp(cmd,'a2on')
  
  set(a2_off,'value',0)

%==================================================================
% Respond to a2 off.
%
% ME('a2off')
%==================================================================

elseif strcmp(cmd,'a2off')
  
  set(a2_on,'value',0)


%==================================================================
% Respond to gain slider.
%
% ME('a')
%==================================================================

elseif strcmp(cmd,'a')
  
  % GET DATA
  A = get(A_bar,'value');

  % UPDATE BAR
  set(A_text,'string',sprintf('%3.1f',A))

%==================================================================
% Respond to gain slider.
%
% ME('a')
%==================================================================

elseif strcmp(cmd,'b')
  
  % GET DATA
  B = get(B_bar,'value');

  % UPDATE BAR
  set(B_text,'string',sprintf('%3.1f',B))

%==================================================================
% Respond to time constant slider.
%
% ME('update')
%==================================================================

elseif strcmp(cmd,'update')

  % GET DATA
  p1 = get(p1_on,'value');
  p2 = get(p2_on,'value');
  a1 = get(a1_on,'value');
  a2 = get(a2_on,'value');
  A = get(A_bar,'value');
  B = get(B_bar,'value');
  old = get(old_ptr,'userdata');
  last = get(last_ptr,'userdata');
  p = [p1; p2];
  a = [a1; a2];

  % MAKE LAST LINE OLD
  set(last,'color',nndkgray);
  old = [old last];
  if size(old,2) > 1
    gone = old(:,1);
    old(:,1) = [];
  else
    gone = [];
  end
  set(gone,'color',nnltyell);
  set(old,'color',nnltgray)
  drawnow
  delete(gone);

  % PLOT RESPONSE
  [T,Y] = ode45('nndao',[0 0.2],0);
  Y = Y';
  T = T';

  set(fig,'nextplot','add')
  axes(big_axis)
  last = plot(T,Y(1,:),...
    'color',nnred,...
    'linewidth',2,...
    'erasemode','none');
  set(big_line,'color',nndkblue);
  set(fig,'nextplot','new')

  % SAVE DATA
  set(old_ptr,'userdata',old);
  set(last_ptr,'userdata',last);

end

