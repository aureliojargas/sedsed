#n
#!/bin/sed -nf
# sokoban.sed  <http://aurelio.net/sed/sokoban>
#   by Aurelio Marinho Jargas <verde (a) aurelio net>
#
# Motivated by reading the amazing Adventure (Colossal Cave) history
#      <http://www.rickadams.org/adventure/a_history.html>
# GPL levels took from Mike Sharpe's sokoban.vim <http://vim.sourceforge.net>
#
# IMPORTANT
# This script has terminal control chars, so you must DOWNLOAD this
# file. Just copy/paste or printing it to a file (lynx) will NOT work.
#
# THE GAME
# You know sokoban. Everybody knows sokoban.
# Right, if you don't, it's a box pushing game. You have a mess, boxes
# all over the room and must place them on the boxes place. To move a
# box you must push it. You can only push a box if the path is clear
# with no wall or other box on the way (You are not that strong).
#
#   COMMANDS                       MOVING AROUND
#     :q   quit                      h or <left-arrow>  - move left
#     :r   restart level             j or <down-arrow>  - move down
#     :z   refresh screen            k or <up-arrow>    - move up
#     :gN  go to level N             l or <right-arrow> - move right
#
#   ACTORS
#     o box                  % wall
#     . box place            @ you
#     O box placed right     ! you over a box place
#
#
# RUNNING
# prompt$ ./sokoban.sed <enter>
# <enter>
# 1
# Now just move! (:q quits)
#
# DETAILS
# It's all written in SED, so we've got some limitations:
# - As a line-oriented editor, you MUST hit <ENTER> after *any* move.
#   Yes, that sucks. But you can accumulate various movements and hit
#   <ENTER> just once.
# - When you run sokoban.sed, you must first press any key to feed SED
#   and then you'll see the welcome message.
# - If your sed is not on /bin, edit the first line of this script,
#   or call it as: sed -nf sokoban.sed 
# - This script is 'sedcheck' <http://lvogel.free.fr/sed/sedcheck.sed>
#   compliant, so it must run fine in *any* SED version
#
# And always remember, it's cool because it's SED. If you don't like it
# you can try xsokoban instead <http://www.cs.cornell.edu/andru/xsokoban.html>
#
# CHANGES
# 20020315 v0.0 debut release
# 20020321 v0.1 clear screen, download note, fancy victory, sound ^G, lvl0
#               fixed * on map bug, added :g, :r and :z commands
#               pseudo-functions (now it's faster!)
# 20020709 v0.2 comments prefix '#r' changed to plain '#'. dummy me.
# 20031011 v0.3 now sokoban is 'sedcheck' compliant, so it will run in
#               most (all?) SED versions out there (thanks Laurent!)
# skip functions
		t zzset001
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b zero

		t zzclr001
		:zzset001
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b zero

		:zzclr001
#--------------------------------------------------
b zero
# function welcome
		i\
COMM::welcome
#--------------------------------------------------
:welcome
		i\
COMM:i\\\\N       Welcome to the SED Sokoban\\\\N\\\\NPlease select a level to begin [1-90]:
#--------------------------------------------------
i\
       Welcome to the SED Sokoban\
\
Please select a level to begin [1-90]:
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:d
#--------------------------------------------------
d
# function loadmap
		t zzset002
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM::loadmap

		t zzclr002
		:zzset002
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM::loadmap

		:zzclr002
#--------------------------------------------------
:loadmap
# clear screen
		i\
COMM:i\\\\N[2J
#--------------------------------------------------
i\
[2J
		t zzset003
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/^0$/ {

		t zzclr003
		:zzset003
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/^0$/ {

		:zzclr003
#--------------------------------------------------
/^0$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 0 (victory test)\\\\N\\\\N     %%%%%            \\\\N     %@o.%            \\\\N     %%%%%            \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 0 (victory test)\
\
     %%%%%            \
     %@o.%            \
     %%%%%            \
/
		t zzset004
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr004
		:zzset004
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr004
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^1$/ {
#--------------------------------------------------
/^1$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 1\\\\N\\\\N     %%%%%            \\\\N     %   %            \\\\N     %o  %            \\\\N   %%%  o%%           \\\\N   %  o o %           \\\\N %%% % %% %   %%%%%%  \\\\N %   % %% %%%%%  ..%  \\\\N % o  o          ..%  \\\\N %%%%% %%% %@%%  ..%  \\\\N     %     %%%%%%%%%  \\\\N     %%%%%%%          \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 1\
\
     %%%%%            \
     %   %            \
     %o  %            \
   %%%  o%%           \
   %  o o %           \
 %%% % %% %   %%%%%%  \
 %   % %% %%%%%  ..%  \
 % o  o          ..%  \
 %%%%% %%% %@%%  ..%  \
     %     %%%%%%%%%  \
     %%%%%%%          \
/
		t zzset005
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr005
		:zzset005
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr005
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^2$/ {
#--------------------------------------------------
/^2$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 2\\\\N\\\\N %%%%%%%%%%%%         \\\\N %..  %     %%%       \\\\N %..  % o  o  %       \\\\N %..  %o%%%%  %       \\\\N %..    @ %%  %       \\\\N %..  % %  o %%       \\\\N %%%%%% %%o o %       \\\\N   % o  o o o %       \\\\N   %    %     %       \\\\N   %%%%%%%%%%%%       \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 2\
\
 %%%%%%%%%%%%         \
 %..  %     %%%       \
 %..  % o  o  %       \
 %..  %o%%%%  %       \
 %..    @ %%  %       \
 %..  % %  o %%       \
 %%%%%% %%o o %       \
   % o  o o o %       \
   %    %     %       \
   %%%%%%%%%%%%       \
/
		t zzset006
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr006
		:zzset006
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr006
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^3$/ {
#--------------------------------------------------
/^3$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 3\\\\N\\\\N         %%%%%%%%     \\\\N         %     @%     \\\\N         % o%o %%     \\\\N         % o  o%      \\\\N         %%o o %      \\\\N %%%%%%%%% o % %%%    \\\\N %....  %% o  o  %    \\\\N %%...    o  o   %    \\\\N %....  %%%%%%%%%%    \\\\N %%%%%%%%             \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 3\
\
         %%%%%%%%     \
         %     @%     \
         % o%o %%     \
         % o  o%      \
         %%o o %      \
 %%%%%%%%% o % %%%    \
 %....  %% o  o  %    \
 %%...    o  o   %    \
 %....  %%%%%%%%%%    \
 %%%%%%%%             \
/
		t zzset007
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr007
		:zzset007
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr007
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^4$/ {
#--------------------------------------------------
/^4$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 4\\\\N\\\\N            %%%%%%%%  \\\\N            %  ....%  \\\\N %%%%%%%%%%%%  ....%  \\\\N %    %  o o   ....%  \\\\N % ooo%o  o %  ....%  \\\\N %  o     o %  ....%  \\\\N % oo %o o o%%%%%%%%  \\\\N %  o %     %         \\\\N %% %%%%%%%%%         \\\\N %    %    %%         \\\\N %     o   %%         \\\\N %  oo%oo  @%         \\\\N %    %    %%         \\\\N %%%%%%%%%%%          \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 4\
\
            %%%%%%%%  \
            %  ....%  \
 %%%%%%%%%%%%  ....%  \
 %    %  o o   ....%  \
 % ooo%o  o %  ....%  \
 %  o     o %  ....%  \
 % oo %o o o%%%%%%%%  \
 %  o %     %         \
 %% %%%%%%%%%         \
 %    %    %%         \
 %     o   %%         \
 %  oo%oo  @%         \
 %    %    %%         \
 %%%%%%%%%%%          \
/
		t zzset008
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr008
		:zzset008
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr008
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^5$/ {
#--------------------------------------------------
/^5$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 5\\\\N\\\\N         %%%%%        \\\\N         %   %%%%%    \\\\N         % %o%%  %    \\\\N         %     o %    \\\\N %%%%%%%%% %%%   %    \\\\N %....  %% o  o%%%    \\\\N %....    o oo %%     \\\\N %....  %%o  o @%     \\\\N %%%%%%%%%  o  %%     \\\\N         % o o  %     \\\\N         %%% %% %     \\\\N           %    %     \\\\N           %%%%%%     \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 5\
\
         %%%%%        \
         %   %%%%%    \
         % %o%%  %    \
         %     o %    \
 %%%%%%%%% %%%   %    \
 %....  %% o  o%%%    \
 %....    o oo %%     \
 %....  %%o  o @%     \
 %%%%%%%%%  o  %%     \
         % o o  %     \
         %%% %% %     \
           %    %     \
           %%%%%%     \
/
		t zzset009
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr009
		:zzset009
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr009
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^6$/ {
#--------------------------------------------------
/^6$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 6\\\\N\\\\N %%%%%%  %%%          \\\\N %..  % %%@%%         \\\\N %..  %%%   %         \\\\N %..     oo %         \\\\N %..  % % o %         \\\\N %..%%% % o %         \\\\N %%%% o %o  %         \\\\N    %  o% o %         \\\\N    % o  o  %         \\\\N    %  %%   %         \\\\N    %%%%%%%%%         \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 6\
\
 %%%%%%  %%%          \
 %..  % %%@%%         \
 %..  %%%   %         \
 %..     oo %         \
 %..  % % o %         \
 %..%%% % o %         \
 %%%% o %o  %         \
    %  o% o %         \
    % o  o  %         \
    %  %%   %         \
    %%%%%%%%%         \
/
		t zzset010
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr010
		:zzset010
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr010
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^7$/ {
#--------------------------------------------------
/^7$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 7\\\\N\\\\N        %%%%%         \\\\N  %%%%%%%   %%        \\\\N %% % @%% oo %        \\\\N %    o      %        \\\\N %  o  %%%   %        \\\\N %%% %%%%%o%%%        \\\\N % o  %%% ..%         \\\\N % o o o ...%         \\\\N %    %%%...%         \\\\N % oo % %...%         \\\\N %  %%% %%%%%         \\\\N %%%%                 \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 7\
\
        %%%%%         \
  %%%%%%%   %%        \
 %% % @%% oo %        \
 %    o      %        \
 %  o  %%%   %        \
 %%% %%%%%o%%%        \
 % o  %%% ..%         \
 % o o o ...%         \
 %    %%%...%         \
 % oo % %...%         \
 %  %%% %%%%%         \
 %%%%                 \
/
		t zzset011
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr011
		:zzset011
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr011
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^8$/ {
#--------------------------------------------------
/^8$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 8\\\\N\\\\N   %%%%               \\\\N   %  %%%%%%%%%%%     \\\\N   %    o   o o %     \\\\N   % o% o %  o  %     \\\\N   %  o o  %    %     \\\\N %%% o% %  %%%% %     \\\\N %@%o o o  %%   %     \\\\N %    o %o%   % %     \\\\N %   o    o o o %     \\\\N %%%%%  %%%%%%%%%     \\\\N   %      %           \\\\N   %      %           \\\\N   %......%           \\\\N   %......%           \\\\N   %......%           \\\\N   %%%%%%%%           \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 8\
\
   %%%%               \
   %  %%%%%%%%%%%     \
   %    o   o o %     \
   % o% o %  o  %     \
   %  o o  %    %     \
 %%% o% %  %%%% %     \
 %@%o o o  %%   %     \
 %    o %o%   % %     \
 %   o    o o o %     \
 %%%%%  %%%%%%%%%     \
   %      %           \
   %      %           \
   %......%           \
   %......%           \
   %......%           \
   %%%%%%%%           \
/
		t zzset012
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr012
		:zzset012
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr012
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^9$/ {
#--------------------------------------------------
/^9$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 9\\\\N\\\\N           %%%%%%%    \\\\N           %  ...%    \\\\N       %%%%%  ...%    \\\\N       %      . .%    \\\\N       %  %%  ...%    \\\\N       %% %%  ...%    \\\\N      %%% %%%%%%%%    \\\\N      % ooo %%        \\\\N  %%%%%  o o %%%%%    \\\\N %%   %o o   %   %    \\\\N %@ o  o    o  o %    \\\\N %%%%%% oo o %%%%%    \\\\N      %      %        \\\\N      %%%%%%%%        \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 9\
\
           %%%%%%%    \
           %  ...%    \
       %%%%%  ...%    \
       %      . .%    \
       %  %%  ...%    \
       %% %%  ...%    \
      %%% %%%%%%%%    \
      % ooo %%        \
  %%%%%  o o %%%%%    \
 %%   %o o   %   %    \
 %@ o  o    o  o %    \
 %%%%%% oo o %%%%%    \
      %      %        \
      %%%%%%%%        \
/
		t zzset013
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr013
		:zzset013
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr013
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^10$/ {
#--------------------------------------------------
/^10$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 10\\\\N\\\\N  %%%  %%%%%%%%%%%%%  \\\\N %%@%%%%       %   %  \\\\N % oo   oo  o o ...%  \\\\N %  ooo%    o  %...%  \\\\N % o   % oo oo %...%  \\\\N %%%   %  o    %...%  \\\\N %     % o o o %...%  \\\\N %    %%%%%% %%%...%  \\\\N %% %  %  o o  %...%  \\\\N %  %% % oo o o%%..%  \\\\N % ..% %  o      %.%  \\\\N % ..% % ooo ooo %.%  \\\\N %%%%% %       % %.%  \\\\N     % %%%%%%%%% %.%  \\\\N     %           %.%  \\\\N     %%%%%%%%%%%%%%%  \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 10\
\
  %%%  %%%%%%%%%%%%%  \
 %%@%%%%       %   %  \
 % oo   oo  o o ...%  \
 %  ooo%    o  %...%  \
 % o   % oo oo %...%  \
 %%%   %  o    %...%  \
 %     % o o o %...%  \
 %    %%%%%% %%%...%  \
 %% %  %  o o  %...%  \
 %  %% % oo o o%%..%  \
 % ..% %  o      %.%  \
 % ..% % ooo ooo %.%  \
 %%%%% %       % %.%  \
     % %%%%%%%%% %.%  \
     %           %.%  \
     %%%%%%%%%%%%%%%  \
/
		t zzset014
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr014
		:zzset014
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr014
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^11$/ {
#--------------------------------------------------
/^11$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 11\\\\N\\\\N           %%%%       \\\\N      %%%% %  %       \\\\N    %%% @%%%o %       \\\\N   %%      o  %       \\\\N  %%  o oo%% %%       \\\\N  %  %o%%     %       \\\\N  % % o oo % %%%      \\\\N  %   o %  % o %%%%%  \\\\N %%%%    %  oo %   %  \\\\N %%%% %% o         %  \\\\N %.    %%%  %%%%%%%%  \\\\N %.. ..% %%%%         \\\\N %...%.%              \\\\N %.....%              \\\\N %%%%%%%              \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 11\
\
           %%%%       \
      %%%% %  %       \
    %%% @%%%o %       \
   %%      o  %       \
  %%  o oo%% %%       \
  %  %o%%     %       \
  % % o oo % %%%      \
  %   o %  % o %%%%%  \
 %%%%    %  oo %   %  \
 %%%% %% o         %  \
 %.    %%%  %%%%%%%%  \
 %.. ..% %%%%         \
 %...%.%              \
 %.....%              \
 %%%%%%%              \
/
		t zzset015
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr015
		:zzset015
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr015
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^12$/ {
#--------------------------------------------------
/^12$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 12\\\\N\\\\N %%%%%%%%%%%%%%%%     \\\\N %              %     \\\\N % % %%%%%%     %     \\\\N % %  o o o o%  %     \\\\N % %   o@o   %% %%    \\\\N % %  o o o%%%...%    \\\\N % %   o o  %%...%    \\\\N % %%%ooo o %%...%    \\\\N %     % %% %%...%    \\\\N %%%%%   %% %%...%    \\\\N     %%%%%     %%%    \\\\N         %     %      \\\\N         %%%%%%%      \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 12\
\
 %%%%%%%%%%%%%%%%     \
 %              %     \
 % % %%%%%%     %     \
 % %  o o o o%  %     \
 % %   o@o   %% %%    \
 % %  o o o%%%...%    \
 % %   o o  %%...%    \
 % %%%ooo o %%...%    \
 %     % %% %%...%    \
 %%%%%   %% %%...%    \
     %%%%%     %%%    \
         %     %      \
         %%%%%%%      \
/
		t zzset016
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr016
		:zzset016
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr016
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^13$/ {
#--------------------------------------------------
/^13$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 13\\\\N\\\\N    %%%%%%%%%         \\\\N   %%   %%  %%%%%     \\\\N %%%     %  %    %%%  \\\\N %  o %o %  %  ... %  \\\\N % % o%@o%% % %.%. %  \\\\N %  % %o  %    . . %  \\\\N % o    o % % %.%. %  \\\\N %   %%  %%o o . . %  \\\\N % o %   %  %o%.%. %  \\\\N %% o  o   o  o... %  \\\\N  %o %%%%%%    %%  %  \\\\N  %  %    %%%%%%%%%%  \\\\N  %%%%                \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 13\
\
    %%%%%%%%%         \
   %%   %%  %%%%%     \
 %%%     %  %    %%%  \
 %  o %o %  %  ... %  \
 % % o%@o%% % %.%. %  \
 %  % %o  %    . . %  \
 % o    o % % %.%. %  \
 %   %%  %%o o . . %  \
 % o %   %  %o%.%. %  \
 %% o  o   o  o... %  \
  %o %%%%%%    %%  %  \
  %  %    %%%%%%%%%%  \
  %%%%                \
/
		t zzset017
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr017
		:zzset017
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr017
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^14$/ {
#--------------------------------------------------
/^14$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 14\\\\N\\\\N        %%%%%%%       \\\\N  %%%%%%%     %       \\\\N  %     % o@o %       \\\\N  %oo %   %%%%%%%%%   \\\\N  % %%%......%%   %   \\\\N  %   o......%% % %   \\\\N  % %%%......     %   \\\\N %%   %%%% %%% %o%%   \\\\N %  %o   %  o  % %    \\\\N %  o ooo  % o%% %    \\\\N %   o o %%%oo % %    \\\\N %%%%%     o   % %    \\\\N     %%% %%%   % %    \\\\N       %     %   %    \\\\N       %%%%%%%%  %    \\\\N              %%%%    \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 14\
\
        %%%%%%%       \
  %%%%%%%     %       \
  %     % o@o %       \
  %oo %   %%%%%%%%%   \
  % %%%......%%   %   \
  %   o......%% % %   \
  % %%%......     %   \
 %%   %%%% %%% %o%%   \
 %  %o   %  o  % %    \
 %  o ooo  % o%% %    \
 %   o o %%%oo % %    \
 %%%%%     o   % %    \
     %%% %%%   % %    \
       %     %   %    \
       %%%%%%%%  %    \
              %%%%    \
/
		t zzset018
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr018
		:zzset018
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr018
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^15$/ {
#--------------------------------------------------
/^15$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 15\\\\N\\\\N    %%%%%%%%          \\\\N    %   %  %          \\\\N    %  o   %          \\\\N  %%% %o   %%%%       \\\\N  %  o  %%o   %       \\\\N  %  % @ o % o%       \\\\N  %  %      o %%%%    \\\\N  %% %%%%o%%     %    \\\\N  % o%.....% %   %    \\\\N  %  o..OO. o% %%%    \\\\N %%  %.....%   %      \\\\N %   %%% %%%%%%%      \\\\N % oo  %  %           \\\\N %  %     %           \\\\N %%%%%%   %           \\\\N      %%%%%           \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 15\
\
    %%%%%%%%          \
    %   %  %          \
    %  o   %          \
  %%% %o   %%%%       \
  %  o  %%o   %       \
  %  % @ o % o%       \
  %  %      o %%%%    \
  %% %%%%o%%     %    \
  % o%.....% %   %    \
  %  o..OO. o% %%%    \
 %%  %.....%   %      \
 %   %%% %%%%%%%      \
 % oo  %  %           \
 %  %     %           \
 %%%%%%   %           \
      %%%%%           \
/
		t zzset019
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr019
		:zzset019
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr019
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^16$/ {
#--------------------------------------------------
/^16$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 16\\\\N\\\\N %%%%%                \\\\N %   %%               \\\\N %    %  %%%%         \\\\N % o  %%%%  %         \\\\N %  oo o   o%         \\\\N %%%@ %o    %%        \\\\N  %  %%  o o %%       \\\\N  % o  %% %% .%       \\\\N  %  %o%%o  %.%       \\\\N  %%%   o..%%.%       \\\\N   %    %.O...%       \\\\N   % oo %.....%       \\\\N   %  %%%%%%%%%       \\\\N   %  %               \\\\N   %%%%               \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 16\
\
 %%%%%                \
 %   %%               \
 %    %  %%%%         \
 % o  %%%%  %         \
 %  oo o   o%         \
 %%%@ %o    %%        \
  %  %%  o o %%       \
  % o  %% %% .%       \
  %  %o%%o  %.%       \
  %%%   o..%%.%       \
   %    %.O...%       \
   % oo %.....%       \
   %  %%%%%%%%%       \
   %  %               \
   %%%%               \
/
		t zzset020
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr020
		:zzset020
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr020
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^17$/ {
#--------------------------------------------------
/^17$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 17\\\\N\\\\N    %%%%%%%%%%        \\\\N    %..  %   %        \\\\N    %..      %        \\\\N    %..  %  %%%%      \\\\N   %%%%%%%  %  %%     \\\\N   %            %     \\\\N   %  %  %%  %  %     \\\\N %%%% %%  %%%% %%     \\\\N %  o  %%%%% %  %     \\\\N % % o  o  % o  %     \\\\N % @o  o   %   %%     \\\\N %%%% %% %%%%%%%      \\\\N    %    %            \\\\N    %%%%%%            \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 17\
\
    %%%%%%%%%%        \
    %..  %   %        \
    %..      %        \
    %..  %  %%%%      \
   %%%%%%%  %  %%     \
   %            %     \
   %  %  %%  %  %     \
 %%%% %%  %%%% %%     \
 %  o  %%%%% %  %     \
 % % o  o  % o  %     \
 % @o  o   %   %%     \
 %%%% %% %%%%%%%      \
    %    %            \
    %%%%%%            \
/
		t zzset021
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr021
		:zzset021
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr021
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^18$/ {
#--------------------------------------------------
/^18$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 18\\\\N\\\\N      %%%%%%%%%%%     \\\\N      %  .  %   %     \\\\N      % %.    @ %     \\\\N  %%%%% %%..% %%%%    \\\\N %%  % ..%%%     %%%  \\\\N % o %...   o %  o %  \\\\N %    .. %%  %% %% %  \\\\N %%%%o%%o% o %   % %  \\\\N   %% %    %o oo % %  \\\\N   %  o % %  % o%% %  \\\\N   %               %  \\\\N   %  %%%%%%%%%%%  %  \\\\N   %%%%         %%%%  \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 18\
\
      %%%%%%%%%%%     \
      %  .  %   %     \
      % %.    @ %     \
  %%%%% %%..% %%%%    \
 %%  % ..%%%     %%%  \
 % o %...   o %  o %  \
 %    .. %%  %% %% %  \
 %%%%o%%o% o %   % %  \
   %% %    %o oo % %  \
   %  o % %  % o%% %  \
   %               %  \
   %  %%%%%%%%%%%  %  \
   %%%%         %%%%  \
/
		t zzset022
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr022
		:zzset022
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr022
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^19$/ {
#--------------------------------------------------
/^19$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 19\\\\N\\\\N   %%%%%%             \\\\N   %   @%%%%          \\\\N %%%%% o   %          \\\\N %   %%    %%%%       \\\\N % o %  %%    %       \\\\N % o %  %%%%% %       \\\\N %% o  o    % %       \\\\N %% o o %%% % %       \\\\N %% %  o  % % %       \\\\N %% % %o%   % %       \\\\N %% %%%   % % %%%%%%  \\\\N %  o  %%%% % %....%  \\\\N %    o    o   ..%.%  \\\\N %%%%o  o% o   ....%  \\\\N %       %  %% ....%  \\\\N %%%%%%%%%%%%%%%%%%%  \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 19\
\
   %%%%%%             \
   %   @%%%%          \
 %%%%% o   %          \
 %   %%    %%%%       \
 % o %  %%    %       \
 % o %  %%%%% %       \
 %% o  o    % %       \
 %% o o %%% % %       \
 %% %  o  % % %       \
 %% % %o%   % %       \
 %% %%%   % % %%%%%%  \
 %  o  %%%% % %....%  \
 %    o    o   ..%.%  \
 %%%%o  o% o   ....%  \
 %       %  %% ....%  \
 %%%%%%%%%%%%%%%%%%%  \
/
		t zzset023
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr023
		:zzset023
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr023
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^20$/ {
#--------------------------------------------------
/^20$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 20\\\\N\\\\N     %%%%%%%%%%       \\\\N %%%%%        %%%%    \\\\N %     %   o  %@ %    \\\\N % %%%%%%%o%%%%  %%%  \\\\N % %    %% %  %o ..%  \\\\N % % o     %  %  %.%  \\\\N % % o  %     %o ..%  \\\\N % %  %%% %%     %.%  \\\\N % %%%  %  %  %o ..%  \\\\N % %    %  %%%%  %.%  \\\\N % %o   o  o  %o ..%  \\\\N %    o % o o %  %.%  \\\\N %%%% o%%%    %o ..%  \\\\N    %    oo %%%....%  \\\\N    %      %% %%%%%%  \\\\N    %%%%%%%%          \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 20\
\
     %%%%%%%%%%       \
 %%%%%        %%%%    \
 %     %   o  %@ %    \
 % %%%%%%%o%%%%  %%%  \
 % %    %% %  %o ..%  \
 % % o     %  %  %.%  \
 % % o  %     %o ..%  \
 % %  %%% %%     %.%  \
 % %%%  %  %  %o ..%  \
 % %    %  %%%%  %.%  \
 % %o   o  o  %o ..%  \
 %    o % o o %  %.%  \
 %%%% o%%%    %o ..%  \
    %    oo %%%....%  \
    %      %% %%%%%%  \
    %%%%%%%%          \
/
		t zzset024
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr024
		:zzset024
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr024
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^21$/ {
#--------------------------------------------------
/^21$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 21\\\\N\\\\N %%%%%%%%%            \\\\N %       %            \\\\N %       %%%%         \\\\N %% %%%% %  %         \\\\N %% %@%%    %         \\\\N % ooo o  oo%         \\\\N %  % %% o  %         \\\\N %  % %%  o %%%%      \\\\N %%%%  ooo o%  %      \\\\N  %   %%   ....%      \\\\N  % %   % %.. .%      \\\\N  %   % % %%...%      \\\\N  %%%%% o  %...%      \\\\N      %%   %%%%%      \\\\N       %%%%%          \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 21\
\
 %%%%%%%%%            \
 %       %            \
 %       %%%%         \
 %% %%%% %  %         \
 %% %@%%    %         \
 % ooo o  oo%         \
 %  % %% o  %         \
 %  % %%  o %%%%      \
 %%%%  ooo o%  %      \
  %   %%   ....%      \
  % %   % %.. .%      \
  %   % % %%...%      \
  %%%%% o  %...%      \
      %%   %%%%%      \
       %%%%%          \
/
		t zzset025
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr025
		:zzset025
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr025
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^22$/ {
#--------------------------------------------------
/^22$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 22\\\\N\\\\N %%%%%%     %%%%      \\\\N %    %%%%%%%  %%%%%  \\\\N %   o%  %  o  %   %  \\\\N %  o  o  o % o o  %  \\\\N %%o o   % @% o    %  \\\\N %  o %%%%%%%%%%% %%  \\\\N % %   %.......% o%   \\\\N % %%  % ......%  %   \\\\N % %   o........o %   \\\\N % % o %.... ..%  %   \\\\N %  o o%%%%o%%%% o%   \\\\N % o   %%% o   o  %%  \\\\N % o     o o  o    %  \\\\N %% %%%%%% o %%%%% %  \\\\N %         %       %  \\\\N %%%%%%%%%%%%%%%%%%%  \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 22\
\
 %%%%%%     %%%%      \
 %    %%%%%%%  %%%%%  \
 %   o%  %  o  %   %  \
 %  o  o  o % o o  %  \
 %%o o   % @% o    %  \
 %  o %%%%%%%%%%% %%  \
 % %   %.......% o%   \
 % %%  % ......%  %   \
 % %   o........o %   \
 % % o %.... ..%  %   \
 %  o o%%%%o%%%% o%   \
 % o   %%% o   o  %%  \
 % o     o o  o    %  \
 %% %%%%%% o %%%%% %  \
 %         %       %  \
 %%%%%%%%%%%%%%%%%%%  \
/
		t zzset026
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr026
		:zzset026
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr026
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^23$/ {
#--------------------------------------------------
/^23$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 23\\\\N\\\\N     %%%%%%%          \\\\N     %  %  %%%%       \\\\N %%%%% o%o %  %%      \\\\N %.. %  %  %   %      \\\\N %.. % o%o %  o%%%%   \\\\N %.  %     %o  %  %   \\\\N %..   o%  % o    %   \\\\N %..@%  %o %o  %  %   \\\\N %.. % o%     o%  %   \\\\N %.. %  %oo%o  %  %%  \\\\N %.. % o%  %  o%o  %  \\\\N %.. %  %  %   %   %  \\\\N %%. %%%%  %%%%%   %  \\\\N  %%%%  %%%%   %%%%%  \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 23\
\
     %%%%%%%          \
     %  %  %%%%       \
 %%%%% o%o %  %%      \
 %.. %  %  %   %      \
 %.. % o%o %  o%%%%   \
 %.  %     %o  %  %   \
 %..   o%  % o    %   \
 %..@%  %o %o  %  %   \
 %.. % o%     o%  %   \
 %.. %  %oo%o  %  %%  \
 %.. % o%  %  o%o  %  \
 %.. %  %  %   %   %  \
 %%. %%%%  %%%%%   %  \
  %%%%  %%%%   %%%%%  \
/
		t zzset027
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr027
		:zzset027
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr027
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^24$/ {
#--------------------------------------------------
/^24$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 24\\\\N\\\\N %%%%%%%%%%%%%%%      \\\\N %..........  .%%%%   \\\\N %..........oo.%  %   \\\\N %%%%%%%%%%%o %   %%  \\\\N %      o  o     o %  \\\\N %% %%%%   %  o %  %  \\\\N %      %   %%  % %%  \\\\N %  o%  % %%  %%% %%  \\\\N % o %o%%%    %%% %%  \\\\N %%%  o %  %  %%% %%  \\\\N %%%    o %% %  % %%  \\\\N  % o  %  o  o o   %  \\\\N  %  o  o%ooo  %   %  \\\\N  %  %  o      %%%%%  \\\\N  % @%%  %  %  %      \\\\N  %%%%%%%%%%%%%%      \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 24\
\
 %%%%%%%%%%%%%%%      \
 %..........  .%%%%   \
 %..........oo.%  %   \
 %%%%%%%%%%%o %   %%  \
 %      o  o     o %  \
 %% %%%%   %  o %  %  \
 %      %   %%  % %%  \
 %  o%  % %%  %%% %%  \
 % o %o%%%    %%% %%  \
 %%%  o %  %  %%% %%  \
 %%%    o %% %  % %%  \
  % o  %  o  o o   %  \
  %  o  o%ooo  %   %  \
  %  %  o      %%%%%  \
  % @%%  %  %  %      \
  %%%%%%%%%%%%%%      \
/
		t zzset028
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr028
		:zzset028
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr028
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^25$/ {
#--------------------------------------------------
/^25$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 25\\\\N\\\\N %%%%                 \\\\N %  %%%%%%%%%%%%%%    \\\\N %  %   ..%......%    \\\\N %  % % %%%%% ...%    \\\\N %%o%    ........%    \\\\N %   %%o%%%%%%  %%%%  \\\\N % o %     %%%%%%@ %  \\\\N %%o % o   %%%%%%  %  \\\\N %  o %ooo%%       %  \\\\N %      %    %o%o%%%  \\\\N % %%%% %ooooo    %   \\\\N % %    o     %   %   \\\\N % %   %%        %%%  \\\\N % %%%%%%o%%%%%% o %  \\\\N %        %    %   %  \\\\N %%%%%%%%%%    %%%%%  \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 25\
\
 %%%%                 \
 %  %%%%%%%%%%%%%%    \
 %  %   ..%......%    \
 %  % % %%%%% ...%    \
 %%o%    ........%    \
 %   %%o%%%%%%  %%%%  \
 % o %     %%%%%%@ %  \
 %%o % o   %%%%%%  %  \
 %  o %ooo%%       %  \
 %      %    %o%o%%%  \
 % %%%% %ooooo    %   \
 % %    o     %   %   \
 % %   %%        %%%  \
 % %%%%%%o%%%%%% o %  \
 %        %    %   %  \
 %%%%%%%%%%    %%%%%  \
/
		t zzset029
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr029
		:zzset029
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr029
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^26$/ {
#--------------------------------------------------
/^26$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 26\\\\N\\\\N  %%%%%%%             \\\\N  %  %  %%%%%         \\\\N %%  %  %...%%%       \\\\N %  o%  %...  %       \\\\N % o %oo ...  %       \\\\N %  o%  %... .%       \\\\N %   % o%%%%%%%%      \\\\N %%o       o o %      \\\\N %%  %  oo %   %      \\\\N  %%%%%%  %%oo@%      \\\\N       %      %%      \\\\N       %%%%%%%%       \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 26\
\
  %%%%%%%             \
  %  %  %%%%%         \
 %%  %  %...%%%       \
 %  o%  %...  %       \
 % o %oo ...  %       \
 %  o%  %... .%       \
 %   % o%%%%%%%%      \
 %%o       o o %      \
 %%  %  oo %   %      \
  %%%%%%  %%oo@%      \
       %      %%      \
       %%%%%%%%       \
/
		t zzset030
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr030
		:zzset030
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr030
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^27$/ {
#--------------------------------------------------
/^27$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 27\\\\N\\\\N  %%%%%%%%%%%%%%%%%   \\\\N  %...   %    %   %%  \\\\N %%.....  o%% % %o %  \\\\N %......%  o  %    %  \\\\N %......%  %  % %  %  \\\\N %%%%%%%%% o  o o  %  \\\\N   %     %o%%o %%o%%  \\\\N  %%   o    % o    %  \\\\N  %  %% %%% %  %%o %  \\\\N  % o oo     o  o  %  \\\\N  % o    o%%o %%%%%%  \\\\N  %%%%%%%  @ %%       \\\\N        %%%%%%        \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 27\
\
  %%%%%%%%%%%%%%%%%   \
  %...   %    %   %%  \
 %%.....  o%% % %o %  \
 %......%  o  %    %  \
 %......%  %  % %  %  \
 %%%%%%%%% o  o o  %  \
   %     %o%%o %%o%%  \
  %%   o    % o    %  \
  %  %% %%% %  %%o %  \
  % o oo     o  o  %  \
  % o    o%%o %%%%%%  \
  %%%%%%%  @ %%       \
        %%%%%%        \
/
		t zzset031
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr031
		:zzset031
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr031
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^28$/ {
#--------------------------------------------------
/^28$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 28\\\\N\\\\N          %%%%%       \\\\N      %%%%%   %       \\\\N     %% o  o  %%%%    \\\\N %%%%% o  o o %%.%    \\\\N %       oo  %%..%    \\\\N %  %%%%%% %%%.. %    \\\\N %% %  %    %... %    \\\\N % o   %    %... %    \\\\N %@ %o %% %%%%...%    \\\\N %%%%  o oo  %%..%    \\\\N    %%  o o  o...%    \\\\N     % oo  o %  .%    \\\\N     %   o o  %%%%    \\\\N     %%%%%%   %       \\\\N          %%%%%       \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 28\
\
          %%%%%       \
      %%%%%   %       \
     %% o  o  %%%%    \
 %%%%% o  o o %%.%    \
 %       oo  %%..%    \
 %  %%%%%% %%%.. %    \
 %% %  %    %... %    \
 % o   %    %... %    \
 %@ %o %% %%%%...%    \
 %%%%  o oo  %%..%    \
    %%  o o  o...%    \
     % oo  o %  .%    \
     %   o o  %%%%    \
     %%%%%%   %       \
          %%%%%       \
/
		t zzset032
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr032
		:zzset032
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr032
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^29$/ {
#--------------------------------------------------
/^29$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 29\\\\N\\\\N %%%%%                \\\\N %   %%               \\\\N % o  %%%%%%%%%       \\\\N %% % %       %%%%%%  \\\\N %% %   o%o%@  %   %  \\\\N %  %      o %   o %  \\\\N %  %%% %%%%%%%%% %%  \\\\N %  %% ..O..... % %%  \\\\N %% %% O.O..O.O % %%  \\\\N % o%%%%%%%%%% %%o %  \\\\N %  o   o  o    o  %  \\\\N %  %   %   %   %  %  \\\\N %%%%%%%%%%%%%%%%%%%  \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 29\
\
 %%%%%                \
 %   %%               \
 % o  %%%%%%%%%       \
 %% % %       %%%%%%  \
 %% %   o%o%@  %   %  \
 %  %      o %   o %  \
 %  %%% %%%%%%%%% %%  \
 %  %% ..O..... % %%  \
 %% %% O.O..O.O % %%  \
 % o%%%%%%%%%% %%o %  \
 %  o   o  o    o  %  \
 %  %   %   %   %  %  \
 %%%%%%%%%%%%%%%%%%%  \
/
		t zzset033
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr033
		:zzset033
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr033
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^30$/ {
#--------------------------------------------------
/^30$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 30\\\\N\\\\N        %%%%%%%%%%%   \\\\N        %   %     %   \\\\N %%%%%  %     o o %   \\\\N %   %%%%% o%% % %%   \\\\N % o %%   % %% o  %   \\\\N % o  @oo % %%ooo %   \\\\N %% %%%   % %%    %   \\\\N %% %   %%% %%%%%o%   \\\\N %% %     o  %....%   \\\\N %  %%% %% o %....%%  \\\\N % o   o %   %..o. %  \\\\N %  %% o %  %%.... %  \\\\N %%%%%   %%%%%%...%%  \\\\N     %%%%%    %%%%%   \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 30\
\
        %%%%%%%%%%%   \
        %   %     %   \
 %%%%%  %     o o %   \
 %   %%%%% o%% % %%   \
 % o %%   % %% o  %   \
 % o  @oo % %%ooo %   \
 %% %%%   % %%    %   \
 %% %   %%% %%%%%o%   \
 %% %     o  %....%   \
 %  %%% %% o %....%%  \
 % o   o %   %..o. %  \
 %  %% o %  %%.... %  \
 %%%%%   %%%%%%...%%  \
     %%%%%    %%%%%   \
/
		t zzset034
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr034
		:zzset034
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr034
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^31$/ {
#--------------------------------------------------
/^31$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 31\\\\N\\\\N   %%%%               \\\\N   %  %%%%%%%%%       \\\\N  %%  %%  %   %       \\\\N  %  o% o@o   %%%%    \\\\N  %o  o  % o o%  %%   \\\\N %%  o%% %o o     %   \\\\N %  %  % %   ooo  %   \\\\N % o    o  o%% %%%%   \\\\N % o o %o%  %  %      \\\\N %%  %%%  %%%o %      \\\\N  %  %....     %      \\\\N  %%%%......%%%%      \\\\N    %....%%%%         \\\\N    %...%%            \\\\N    %...%             \\\\N    %%%%%             \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 31\
\
   %%%%               \
   %  %%%%%%%%%       \
  %%  %%  %   %       \
  %  o% o@o   %%%%    \
  %o  o  % o o%  %%   \
 %%  o%% %o o     %   \
 %  %  % %   ooo  %   \
 % o    o  o%% %%%%   \
 % o o %o%  %  %      \
 %%  %%%  %%%o %      \
  %  %....     %      \
  %%%%......%%%%      \
    %....%%%%         \
    %...%%            \
    %...%             \
    %%%%%             \
/
		t zzset035
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr035
		:zzset035
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr035
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^32$/ {
#--------------------------------------------------
/^32$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 32\\\\N\\\\N       %%%%           \\\\N   %%%%%  %           \\\\N  %%     o%           \\\\N %% o  %% %%%         \\\\N %@o o % o  %         \\\\N %%%% %%   o%         \\\\N  %....%o o %         \\\\N  %....%   o%         \\\\N  %....  oo %%        \\\\N  %... % o   %        \\\\N  %%%%%%o o  %        \\\\N       %   %%%        \\\\N       %o %%%         \\\\N       %  %           \\\\N       %%%%           \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 32\
\
       %%%%           \
   %%%%%  %           \
  %%     o%           \
 %% o  %% %%%         \
 %@o o % o  %         \
 %%%% %%   o%         \
  %....%o o %         \
  %....%   o%         \
  %....  oo %%        \
  %... % o   %        \
  %%%%%%o o  %        \
       %   %%%        \
       %o %%%         \
       %  %           \
       %%%%           \
/
		t zzset036
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr036
		:zzset036
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr036
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^33$/ {
#--------------------------------------------------
/^33$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 33\\\\N\\\\N  %%%%%%%%%%%         \\\\N  %     %%  %         \\\\N  %   o   o %         \\\\N %%%% %% oo %         \\\\N %   o %    %         \\\\N % ooo % %%%%         \\\\N %   % % o %%         \\\\N %  %  %  o %         \\\\N % o% o%    %         \\\\N %   ..% %%%%         \\\\N %%%%.. o %@%         \\\\N %.....% o% %         \\\\N %%....%  o %         \\\\N  %%..%%    %         \\\\N   %%%%%%%%%%         \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 33\
\
  %%%%%%%%%%%         \
  %     %%  %         \
  %   o   o %         \
 %%%% %% oo %         \
 %   o %    %         \
 % ooo % %%%%         \
 %   % % o %%         \
 %  %  %  o %         \
 % o% o%    %         \
 %   ..% %%%%         \
 %%%%.. o %@%         \
 %.....% o% %         \
 %%....%  o %         \
  %%..%%    %         \
   %%%%%%%%%%         \
/
		t zzset037
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr037
		:zzset037
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr037
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^34$/ {
#--------------------------------------------------
/^34$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 34\\\\N\\\\N  %%%%%%%%%           \\\\N  %....   %%          \\\\N  %.%.%  o %%         \\\\N %%....% % @%%        \\\\N % ....%  %  %%       \\\\N %     %o %%o %       \\\\N %% %%%  o    %       \\\\N  %o  o o o%  %       \\\\N  % %  o o %% %       \\\\N  %  %%%  %%  %       \\\\N  %    %% %% %%       \\\\N  %  o %  o  %        \\\\N  %%%o o   %%%        \\\\N    %  %%%%%          \\\\N    %%%%              \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 34\
\
  %%%%%%%%%           \
  %....   %%          \
  %.%.%  o %%         \
 %%....% % @%%        \
 % ....%  %  %%       \
 %     %o %%o %       \
 %% %%%  o    %       \
  %o  o o o%  %       \
  % %  o o %% %       \
  %  %%%  %%  %       \
  %    %% %% %%       \
  %  o %  o  %        \
  %%%o o   %%%        \
    %  %%%%%          \
    %%%%              \
/
		t zzset038
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr038
		:zzset038
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr038
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^35$/ {
#--------------------------------------------------
/^35$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 35\\\\N\\\\N %%%%%%%%%%%% %%%%%%  \\\\N %   %    % %%%....%  \\\\N %   oo%   @  .....%  \\\\N %   % %%%   % ....%  \\\\N %% %% %%%  %  ....%  \\\\N  % o o     % % %%%%  \\\\N  %  o o%%  %      %  \\\\N %%%% %  %%%% % %% %  \\\\N %  % %o   %% %    %  \\\\N % o  o  % %% %   %%  \\\\N % % o o    % %   %   \\\\N %  o %% %% % %%%%%   \\\\N % oo     oo  %       \\\\N %% %% %%% o  %       \\\\N  %    % %    %       \\\\N  %%%%%% %%%%%%       \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 35\
\
 %%%%%%%%%%%% %%%%%%  \
 %   %    % %%%....%  \
 %   oo%   @  .....%  \
 %   % %%%   % ....%  \
 %% %% %%%  %  ....%  \
  % o o     % % %%%%  \
  %  o o%%  %      %  \
 %%%% %  %%%% % %% %  \
 %  % %o   %% %    %  \
 % o  o  % %% %   %%  \
 % % o o    % %   %   \
 %  o %% %% % %%%%%   \
 % oo     oo  %       \
 %% %% %%% o  %       \
  %    % %    %       \
  %%%%%% %%%%%%       \
/
		t zzset039
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr039
		:zzset039
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr039
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^36$/ {
#--------------------------------------------------
/^36$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 36\\\\N\\\\N             %%%%%    \\\\N %%%%%  %%%%%%   %    \\\\N %   %%%%  o o o %    \\\\N % o   %% %% %%  %%   \\\\N %   o o     o  o %   \\\\N %%% o  %% %%     %%  \\\\N   % %%%%% %%%%%oo %  \\\\N  %%o%%%%% @%%     %  \\\\N  % o  %%%o%%% o  %%  \\\\N  % o  %   %%%  %%%   \\\\N  % oo o %   oo %     \\\\N  %     %   %%  %     \\\\N  %%%%%%%.. .%%%      \\\\N     %.........%      \\\\N     %.........%      \\\\N     %%%%%%%%%%%      \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 36\
\
             %%%%%    \
 %%%%%  %%%%%%   %    \
 %   %%%%  o o o %    \
 % o   %% %% %%  %%   \
 %   o o     o  o %   \
 %%% o  %% %%     %%  \
   % %%%%% %%%%%oo %  \
  %%o%%%%% @%%     %  \
  % o  %%%o%%% o  %%  \
  % o  %   %%%  %%%   \
  % oo o %   oo %     \
  %     %   %%  %     \
  %%%%%%%.. .%%%      \
     %.........%      \
     %.........%      \
     %%%%%%%%%%%      \
/
		t zzset040
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr040
		:zzset040
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr040
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^37$/ {
#--------------------------------------------------
/^37$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 37\\\\N\\\\N %%%%%%%%%%%          \\\\N %......   %%%%%%%%%  \\\\N %......   %  %%   %  \\\\N %..%%% o    o     %  \\\\N %... o o %   %%   %  \\\\N %...%o%%%%%    %  %  \\\\N %%%    %   %o  %o %  \\\\N   %  oo o o  o%%  %  \\\\N   %  o   %o%o %%o %  \\\\N   %%% %% %    %%  %  \\\\N    %  o o %% %%%%%%  \\\\N    %    o  o  %      \\\\N    %%   % %   %      \\\\N     %%%%%@%%%%%      \\\\N         %%%          \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 37\
\
 %%%%%%%%%%%          \
 %......   %%%%%%%%%  \
 %......   %  %%   %  \
 %..%%% o    o     %  \
 %... o o %   %%   %  \
 %...%o%%%%%    %  %  \
 %%%    %   %o  %o %  \
   %  oo o o  o%%  %  \
   %  o   %o%o %%o %  \
   %%% %% %    %%  %  \
    %  o o %% %%%%%%  \
    %    o  o  %      \
    %%   % %   %      \
     %%%%%@%%%%%      \
         %%%          \
/
		t zzset041
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr041
		:zzset041
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr041
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^38$/ {
#--------------------------------------------------
/^38$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 38\\\\N\\\\N       %%%%           \\\\N %%%%%%% @%           \\\\N %     o  %           \\\\N %   o%% o%           \\\\N %%o%...% %           \\\\N  % o...  %           \\\\N  % %. .% %%          \\\\N  %   % %o %          \\\\N  %o  o    %          \\\\N  %  %%%%%%%          \\\\N  %%%%                \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 38\
\
       %%%%           \
 %%%%%%% @%           \
 %     o  %           \
 %   o%% o%           \
 %%o%...% %           \
  % o...  %           \
  % %. .% %%          \
  %   % %o %          \
  %o  o    %          \
  %  %%%%%%%          \
  %%%%                \
/
		t zzset042
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr042
		:zzset042
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr042
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^39$/ {
#--------------------------------------------------
/^39$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 39\\\\N\\\\N              %%%%%%  \\\\N  %%%%%%%%%%%%%....%  \\\\N %%   %%     %%....%  \\\\N %  oo%%  o @%%....%  \\\\N %      oo o%  ....%  \\\\N %  o %% oo % % ...%  \\\\N %  o %% o  %  ....%  \\\\N %% %%%%% %%% %%.%%%  \\\\N %%   o  o %%   .  %  \\\\N % o%%%  % %%%%% %%%  \\\\N %   o   %       %    \\\\N %  o %o o o%%%  %    \\\\N % ooo% o   % %%%%    \\\\N %    %  oo %         \\\\N %%%%%%   %%%         \\\\N      %%%%%           \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 39\
\
              %%%%%%  \
  %%%%%%%%%%%%%....%  \
 %%   %%     %%....%  \
 %  oo%%  o @%%....%  \
 %      oo o%  ....%  \
 %  o %% oo % % ...%  \
 %  o %% o  %  ....%  \
 %% %%%%% %%% %%.%%%  \
 %%   o  o %%   .  %  \
 % o%%%  % %%%%% %%%  \
 %   o   %       %    \
 %  o %o o o%%%  %    \
 % ooo% o   % %%%%    \
 %    %  oo %         \
 %%%%%%   %%%         \
      %%%%%           \
/
		t zzset043
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr043
		:zzset043
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr043
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^40$/ {
#--------------------------------------------------
/^40$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 40\\\\N\\\\N     %%%%%%%%%%%%     \\\\N     %          %%    \\\\N     %  % %oo o  %    \\\\N     %o %o%  %% @%    \\\\N    %% %% % o % %%    \\\\N    %   o %o  % %     \\\\N    %   % o   % %     \\\\N    %% o o   %% %     \\\\N    %  %  %%  o %     \\\\N    %    %% oo% %     \\\\N %%%%%%oo   %   %     \\\\N %....%  %%%%%%%%     \\\\N %.%... %%            \\\\N %....   %            \\\\N %....   %            \\\\N %%%%%%%%%            \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 40\
\
     %%%%%%%%%%%%     \
     %          %%    \
     %  % %oo o  %    \
     %o %o%  %% @%    \
    %% %% % o % %%    \
    %   o %o  % %     \
    %   % o   % %     \
    %% o o   %% %     \
    %  %  %%  o %     \
    %    %% oo% %     \
 %%%%%%oo   %   %     \
 %....%  %%%%%%%%     \
 %.%... %%            \
 %....   %            \
 %....   %            \
 %%%%%%%%%            \
/
		t zzset044
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr044
		:zzset044
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr044
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^41$/ {
#--------------------------------------------------
/^41$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 41\\\\N\\\\N            %%%%%     \\\\N           %%   %%    \\\\N          %%     %    \\\\N         %%  oo  %    \\\\N        %% oo  o %    \\\\N        % o    o %    \\\\N %%%%   %   oo %%%%%  \\\\N %  %%%%%%%% %%    %  \\\\N %.            ooo@%  \\\\N %.% %%%%%%% %%   %%  \\\\N %.% %%%%%%%. %o o%%  \\\\N %........... %    %  \\\\N %%%%%%%%%%%%%%  o %  \\\\N              %%  %%  \\\\N               %%%%   \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 41\
\
            %%%%%     \
           %%   %%    \
          %%     %    \
         %%  oo  %    \
        %% oo  o %    \
        % o    o %    \
 %%%%   %   oo %%%%%  \
 %  %%%%%%%% %%    %  \
 %.            ooo@%  \
 %.% %%%%%%% %%   %%  \
 %.% %%%%%%%. %o o%%  \
 %........... %    %  \
 %%%%%%%%%%%%%%  o %  \
              %%  %%  \
               %%%%   \
/
		t zzset045
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr045
		:zzset045
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr045
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^42$/ {
#--------------------------------------------------
/^42$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 42\\\\N\\\\N      %%%%%%%%        \\\\N   %%%%      %%%%%%   \\\\N   %    %% o o   @%   \\\\N   % %% %%o%o o o%%   \\\\N %%% ......%  oo %%   \\\\N %   ......%  %   %   \\\\N % % ......%o  o  %   \\\\N % %o...... oo% o %   \\\\N %   %%% %%%o  o %%   \\\\N %%%  o  o  o  o %    \\\\N   %  o  o  o  o %    \\\\N   %%%%%%   %%%%%%    \\\\N        %%%%%         \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 42\
\
      %%%%%%%%        \
   %%%%      %%%%%%   \
   %    %% o o   @%   \
   % %% %%o%o o o%%   \
 %%% ......%  oo %%   \
 %   ......%  %   %   \
 % % ......%o  o  %   \
 % %o...... oo% o %   \
 %   %%% %%%o  o %%   \
 %%%  o  o  o  o %    \
   %  o  o  o  o %    \
   %%%%%%   %%%%%%    \
        %%%%%         \
/
		t zzset046
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr046
		:zzset046
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr046
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^43$/ {
#--------------------------------------------------
/^43$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 43\\\\N\\\\N         %%%%%%%      \\\\N     %%%%%  %  %%%%   \\\\N     %   %   o    %   \\\\N  %%%% %oo %% %%  %   \\\\N %%      % %  %% %%%  \\\\N %  %%% o%o  o  o  %  \\\\N %...    % %%  %   %  \\\\N %...%    @ % %%% %%  \\\\N %...%  %%%  o  o  %  \\\\N %%%%%%%% %%   %   %  \\\\N           %%%%%%%%%  \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 43\
\
         %%%%%%%      \
     %%%%%  %  %%%%   \
     %   %   o    %   \
  %%%% %oo %% %%  %   \
 %%      % %  %% %%%  \
 %  %%% o%o  o  o  %  \
 %...    % %%  %   %  \
 %...%    @ % %%% %%  \
 %...%  %%%  o  o  %  \
 %%%%%%%% %%   %   %  \
           %%%%%%%%%  \
/
		t zzset047
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr047
		:zzset047
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr047
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^44$/ {
#--------------------------------------------------
/^44$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 44\\\\N\\\\N  %%%%%               \\\\N  %   %               \\\\N  % % %%%%%%%         \\\\N  %      o@%%%%%%     \\\\N  % o %%o %%%   %     \\\\N  % %%%% o    o %     \\\\N  % %%%%% %  %o %%%%  \\\\N %%  %%%% %%o      %  \\\\N %  o%  o  % %% %% %  \\\\N %         % %...% %  \\\\N %%%%%%  %%%  ...  %  \\\\N      %%%% % %...% %  \\\\N           % %%% % %  \\\\N           %       %  \\\\N           %%%%%%%%%  \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 44\
\
  %%%%%               \
  %   %               \
  % % %%%%%%%         \
  %      o@%%%%%%     \
  % o %%o %%%   %     \
  % %%%% o    o %     \
  % %%%%% %  %o %%%%  \
 %%  %%%% %%o      %  \
 %  o%  o  % %% %% %  \
 %         % %...% %  \
 %%%%%%  %%%  ...  %  \
      %%%% % %...% %  \
           % %%% % %  \
           %       %  \
           %%%%%%%%%  \
/
		t zzset048
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr048
		:zzset048
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr048
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^45$/ {
#--------------------------------------------------
/^45$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 45\\\\N\\\\N %%%%% %%%%           \\\\N %...% %  %%%%        \\\\N %...%%%  o  %        \\\\N %....%% o  o%%%      \\\\N %%....%%   o  %      \\\\N %%%... %% o o %      \\\\N % %%    %  o  %      \\\\N %  %% % %%% %%%%     \\\\N % o % %o  o    %     \\\\N %  o @ o    o  %     \\\\N %   % o oo o %%%     \\\\N %  %%%%%%  %%%       \\\\N % %%    %%%%         \\\\N %%%                  \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 45\
\
 %%%%% %%%%           \
 %...% %  %%%%        \
 %...%%%  o  %        \
 %....%% o  o%%%      \
 %%....%%   o  %      \
 %%%... %% o o %      \
 % %%    %  o  %      \
 %  %% % %%% %%%%     \
 % o % %o  o    %     \
 %  o @ o    o  %     \
 %   % o oo o %%%     \
 %  %%%%%%  %%%       \
 % %%    %%%%         \
 %%%                  \
/
		t zzset049
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr049
		:zzset049
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr049
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^46$/ {
#--------------------------------------------------
/^46$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 46\\\\N\\\\N %%%%%%%%%%           \\\\N %        %%%%        \\\\N % %%%%%% %  %%       \\\\N % % o o o  o %       \\\\N %       %o   %       \\\\N %%%o  oo%  %%%       \\\\N   %  %% % o%%        \\\\N   %%o%   o @%        \\\\N    %  o o %%%        \\\\N    % %   o  %        \\\\N    % %%   % %        \\\\N   %%  %%%%% %        \\\\N   %         %        \\\\N   %.......%%%        \\\\N   %.......%          \\\\N   %%%%%%%%%          \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 46\
\
 %%%%%%%%%%           \
 %        %%%%        \
 % %%%%%% %  %%       \
 % % o o o  o %       \
 %       %o   %       \
 %%%o  oo%  %%%       \
   %  %% % o%%        \
   %%o%   o @%        \
    %  o o %%%        \
    % %   o  %        \
    % %%   % %        \
   %%  %%%%% %        \
   %         %        \
   %.......%%%        \
   %.......%          \
   %%%%%%%%%          \
/
		t zzset050
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr050
		:zzset050
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr050
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^47$/ {
#--------------------------------------------------
/^47$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 47\\\\N\\\\N          %%%%        \\\\N  %%%%%%%%%  %%       \\\\N %%  o      o %%%%%   \\\\N %   %% %%   %%...%   \\\\N % %oo o oo%o%%...%   \\\\N % %   @   %   ...%   \\\\N %  o% %%%oo   ...%   \\\\N % o  oo  o %%....%   \\\\N %%%o       %%%%%%%   \\\\N   %  %%%%%%%         \\\\N   %%%%               \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 47\
\
          %%%%        \
  %%%%%%%%%  %%       \
 %%  o      o %%%%%   \
 %   %% %%   %%...%   \
 % %oo o oo%o%%...%   \
 % %   @   %   ...%   \
 %  o% %%%oo   ...%   \
 % o  oo  o %%....%   \
 %%%o       %%%%%%%   \
   %  %%%%%%%         \
   %%%%               \
/
		t zzset051
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr051
		:zzset051
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr051
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^48$/ {
#--------------------------------------------------
/^48$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 48\\\\N\\\\N   %%%%%%%%%          \\\\N   %O.O%O.O%          \\\\N   %.O.O.O.%          \\\\N   %O.O.O.O%          \\\\N   %.O.O.O.%          \\\\N   %O.O.O.O%          \\\\N   %%%   %%%          \\\\N     %   %            \\\\N %%%%%% %%%%%%        \\\\N %           %        \\\\N % o o o o o %        \\\\N %% o o o o %%        \\\\N  %o o o o o%         \\\\N  %   o@o   %         \\\\N  %  %%%%%  %         \\\\N  %%%%   %%%%         \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 48\
\
   %%%%%%%%%          \
   %O.O%O.O%          \
   %.O.O.O.%          \
   %O.O.O.O%          \
   %.O.O.O.%          \
   %O.O.O.O%          \
   %%%   %%%          \
     %   %            \
 %%%%%% %%%%%%        \
 %           %        \
 % o o o o o %        \
 %% o o o o %%        \
  %o o o o o%         \
  %   o@o   %         \
  %  %%%%%  %         \
  %%%%   %%%%         \
/
		t zzset052
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr052
		:zzset052
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr052
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^49$/ {
#--------------------------------------------------
/^49$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 49\\\\N\\\\N        %%%%          \\\\N        %  %%         \\\\N        %   %%        \\\\N        % oo %%       \\\\N      %%%o  o %%      \\\\N   %%%%    o   %      \\\\N %%%  % %%%%%  %      \\\\N %    % %....o %      \\\\N % %   o ....% %      \\\\N %  o % %.O..% %      \\\\N %%%  %%%% %%% %      \\\\N   %%%% @o  %%o%%     \\\\N      %%% o     %     \\\\N        %  %%   %     \\\\N        %%%%%%%%%     \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 49\
\
        %%%%          \
        %  %%         \
        %   %%        \
        % oo %%       \
      %%%o  o %%      \
   %%%%    o   %      \
 %%%  % %%%%%  %      \
 %    % %....o %      \
 % %   o ....% %      \
 %  o % %.O..% %      \
 %%%  %%%% %%% %      \
   %%%% @o  %%o%%     \
      %%% o     %     \
        %  %%   %     \
        %%%%%%%%%     \
/
		t zzset053
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr053
		:zzset053
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr053
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^50$/ {
#--------------------------------------------------
/^50$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 50\\\\N\\\\N       %%%%%%%%%%%%   \\\\N      %%..    %   %   \\\\N     %%..O o    o %   \\\\N    %%..O.% % % o%%   \\\\N    %..O.% % % o  %   \\\\N %%%%...%  %    % %   \\\\N %  %% %          %   \\\\N % @o o %%%  %   %%   \\\\N % o   o   % %   %    \\\\N %%%oo   % % % % %    \\\\N   %   o   % % %%%%%  \\\\N   % o% %%%%%      %  \\\\N   %o   %   %    % %  \\\\N   %  %%%   %%     %  \\\\N   %  %      %    %%  \\\\N   %%%%      %%%%%%   \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 50\
\
       %%%%%%%%%%%%   \
      %%..    %   %   \
     %%..O o    o %   \
    %%..O.% % % o%%   \
    %..O.% % % o  %   \
 %%%%...%  %    % %   \
 %  %% %          %   \
 % @o o %%%  %   %%   \
 % o   o   % %   %    \
 %%%oo   % % % % %    \
   %   o   % % %%%%%  \
   % o% %%%%%      %  \
   %o   %   %    % %  \
   %  %%%   %%     %  \
   %  %      %    %%  \
   %%%%      %%%%%%   \
/
		t zzset054
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr054
		:zzset054
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr054
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^51$/ {
#--------------------------------------------------
/^51$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 51\\\\N\\\\N  %%%%%%%%%           \\\\N  %       %           \\\\N  % o oo o%           \\\\N %%% %  o %           \\\\N %.%   oo %%          \\\\N %.%%%   o %          \\\\N %.%. o %% %%%%       \\\\N %...  o%% o  %       \\\\N %...o   o    %       \\\\N %..%%%o%%% %@%       \\\\N %..% %     %%%       \\\\N %%%% %%%%%%%         \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 51\
\
  %%%%%%%%%           \
  %       %           \
  % o oo o%           \
 %%% %  o %           \
 %.%   oo %%          \
 %.%%%   o %          \
 %.%. o %% %%%%       \
 %...  o%% o  %       \
 %...o   o    %       \
 %..%%%o%%% %@%       \
 %..% %     %%%       \
 %%%% %%%%%%%         \
/
		t zzset055
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr055
		:zzset055
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr055
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^52$/ {
#--------------------------------------------------
/^52$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 52\\\\N\\\\N            %%%%%%%%  \\\\N            %......%  \\\\N    %%%%    %......%  \\\\N    %  %%%%%%%%%...%  \\\\N    % o   o    %...%  \\\\N    %  % % % % %   %  \\\\N %%%%% % % %@% %   %  \\\\N %   % %%% %%% %% %%  \\\\N %    o % o o o % %   \\\\N % ooo  o   %     %   \\\\N %   % %%%o%%%o%% %   \\\\N %%% %  o   %     %   \\\\N  %% o  % o o o %%%   \\\\N  %  % %%% %%% %%     \\\\N  % o          %      \\\\N  %  %%%%%%%%%%%      \\\\N  %%%%                \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 52\
\
            %%%%%%%%  \
            %......%  \
    %%%%    %......%  \
    %  %%%%%%%%%...%  \
    % o   o    %...%  \
    %  % % % % %   %  \
 %%%%% % % %@% %   %  \
 %   % %%% %%% %% %%  \
 %    o % o o o % %   \
 % ooo  o   %     %   \
 %   % %%%o%%%o%% %   \
 %%% %  o   %     %   \
  %% o  % o o o %%%   \
  %  % %%% %%% %%     \
  % o          %      \
  %  %%%%%%%%%%%      \
  %%%%                \
/
		t zzset056
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr056
		:zzset056
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr056
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^53$/ {
#--------------------------------------------------
/^53$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 53\\\\N\\\\N %%%%%%%%%%%%%%%%%%   \\\\N %                %%  \\\\N % o%   o %%  o    %  \\\\N %    o%%%    % oo %  \\\\N %.%%%     o o %%  %% \\\\N %...%  %  %    %o  % \\\\N %..%%oo%%%% o  %   % \\\\N %...%      o %%  %%% \\\\N %...o  %%%  %    % % \\\\N %%..  o%  %%   %%@ % \\\\N  %%.%              % \\\\N   %%%%%%%%%%%%%%%%%% \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 53\
\
 %%%%%%%%%%%%%%%%%%   \
 %                %%  \
 % o%   o %%  o    %  \
 %    o%%%    % oo %  \
 %.%%%     o o %%  %% \
 %...%  %  %    %o  % \
 %..%%oo%%%% o  %   % \
 %...%      o %%  %%% \
 %...o  %%%  %    % % \
 %%..  o%  %%   %%@ % \
  %%.%              % \
   %%%%%%%%%%%%%%%%%% \
/
		t zzset057
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr057
		:zzset057
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr057
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^54$/ {
#--------------------------------------------------
/^54$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 54\\\\N\\\\N %%%%%%%%%%%%%%%%%%%% \\\\N %   %    %   %   %@% \\\\N % o      o   o   % % \\\\N %% %%%..%% %%%     % \\\\N %   %....%o%  o%%% % \\\\N % o %....%  o  o o % \\\\N %   %....% % % o o % \\\\N %   %%..%%   %o%   % \\\\N %%o%%    %%  %  %o%% \\\\N %   o  o     %  %  % \\\\N %   %    %   %     % \\\\N %%%%%%%%%%%%%%%%%%%% \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 54\
\
 %%%%%%%%%%%%%%%%%%%% \
 %   %    %   %   %@% \
 % o      o   o   % % \
 %% %%%..%% %%%     % \
 %   %....%o%  o%%% % \
 % o %....%  o  o o % \
 %   %....% % % o o % \
 %   %%..%%   %o%   % \
 %%o%%    %%  %  %o%% \
 %   o  o     %  %  % \
 %   %    %   %     % \
 %%%%%%%%%%%%%%%%%%%% \
/
		t zzset058
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr058
		:zzset058
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr058
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^55$/ {
#--------------------------------------------------
/^55$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 55\\\\N\\\\N %%%%%%%%%%%%%%%%%%%% \\\\N %    @%%      %   %% \\\\N %    %%    o    o %% \\\\N %  %%%....% % %  %%% \\\\N %   %....% % % o   % \\\\N %%% %...%  %       % \\\\N %%  %%.%     o   o % \\\\N %%  o o %%%  % % %%% \\\\N %% o       % % o   % \\\\N %%%% o  o% % % % o % \\\\N %%%%         % %  %% \\\\N %%%%%%%%%%%%%%%%%%%% \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 55\
\
 %%%%%%%%%%%%%%%%%%%% \
 %    @%%      %   %% \
 %    %%    o    o %% \
 %  %%%....% % %  %%% \
 %   %....% % % o   % \
 %%% %...%  %       % \
 %%  %%.%     o   o % \
 %%  o o %%%  % % %%% \
 %% o       % % o   % \
 %%%% o  o% % % % o % \
 %%%%         % %  %% \
 %%%%%%%%%%%%%%%%%%%% \
/
		t zzset059
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr059
		:zzset059
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr059
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^56$/ {
#--------------------------------------------------
/^56$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 56\\\\N\\\\N %%%%%%%%%%%%%%%%%%%% \\\\N %  %  %%    %   @%%% \\\\N %%    o    % o%%%  % \\\\N %%o% o %%o% o o    % \\\\N %   o%    o      %%% \\\\N % %%   o %%%  %....% \\\\N % % o% % % % %....%% \\\\N %    o o %  %....%%% \\\\N %%o %%%  o %....%%%% \\\\N %  % o        %%%%%% \\\\N %      % %    %%%%%% \\\\N %%%%%%%%%%%%%%%%%%%% \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 56\
\
 %%%%%%%%%%%%%%%%%%%% \
 %  %  %%    %   @%%% \
 %%    o    % o%%%  % \
 %%o% o %%o% o o    % \
 %   o%    o      %%% \
 % %%   o %%%  %....% \
 % % o% % % % %....%% \
 %    o o %  %....%%% \
 %%o %%%  o %....%%%% \
 %  % o        %%%%%% \
 %      % %    %%%%%% \
 %%%%%%%%%%%%%%%%%%%% \
/
		t zzset060
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr060
		:zzset060
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr060
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^57$/ {
#--------------------------------------------------
/^57$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 57\\\\N\\\\N %%%%%%%%%%%%%%%%%%%% \\\\N %@     %%%   %  %  % \\\\N % % %  %  o  o     % \\\\N %%%%%     % o o%o% % \\\\N %.%..%    %%o o    % \\\\N %.....    o   %   %% \\\\N %.....    %%%o%%o%%% \\\\N %.%..%    o    %   % \\\\N %%%%%     %  %o  o % \\\\N %%%%%  %  o    o o % \\\\N %%%%%  %  %  %  %  % \\\\N %%%%%%%%%%%%%%%%%%%% \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 57\
\
 %%%%%%%%%%%%%%%%%%%% \
 %@     %%%   %  %  % \
 % % %  %  o  o     % \
 %%%%%     % o o%o% % \
 %.%..%    %%o o    % \
 %.....    o   %   %% \
 %.....    %%%o%%o%%% \
 %.%..%    o    %   % \
 %%%%%     %  %o  o % \
 %%%%%  %  o    o o % \
 %%%%%  %  %  %  %  % \
 %%%%%%%%%%%%%%%%%%%% \
/
		t zzset061
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr061
		:zzset061
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr061
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^58$/ {
#--------------------------------------------------
/^58$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 58\\\\N\\\\N %%%%%%%%%%%%%%%%%%%% \\\\N %%...   %% %    %  % \\\\N %....         o %% % \\\\N %....% % %o%%%o    % \\\\N %...%    %       % % \\\\N %%.%  %o %     o%% % \\\\N %  %  % o o %%%  o % \\\\N %     o  o %  % %% % \\\\N %% % %% %oo% o%  % % \\\\N %  %   o o %      %% \\\\N %    %     %  %   @% \\\\N %%%%%%%%%%%%%%%%%%%% \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 58\
\
 %%%%%%%%%%%%%%%%%%%% \
 %%...   %% %    %  % \
 %....         o %% % \
 %....% % %o%%%o    % \
 %...%    %       % % \
 %%.%  %o %     o%% % \
 %  %  % o o %%%  o % \
 %     o  o %  % %% % \
 %% % %% %oo% o%  % % \
 %  %   o o %      %% \
 %    %     %  %   @% \
 %%%%%%%%%%%%%%%%%%%% \
/
		t zzset062
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr062
		:zzset062
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr062
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^59$/ {
#--------------------------------------------------
/^59$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 59\\\\N\\\\N %%%%%%%%%%%%%%%%%%%% \\\\N %   %  %@% %%  %%%%% \\\\N % % %  o    o  %%%%% \\\\N % %    %%%%%% o  %%% \\\\N %   %  %....%  oo  % \\\\N %%o%%o%%....%      % \\\\N %      %....%%o%%o%% \\\\N %  oo  %....%      % \\\\N % o  o  %  %  %%%  % \\\\N %%%%%  o   o    o  % \\\\N %%%%% %    %  %   %% \\\\N %%%%%%%%%%%%%%%%%%%% \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 59\
\
 %%%%%%%%%%%%%%%%%%%% \
 %   %  %@% %%  %%%%% \
 % % %  o    o  %%%%% \
 % %    %%%%%% o  %%% \
 %   %  %....%  oo  % \
 %%o%%o%%....%      % \
 %      %....%%o%%o%% \
 %  oo  %....%      % \
 % o  o  %  %  %%%  % \
 %%%%%  o   o    o  % \
 %%%%% %    %  %   %% \
 %%%%%%%%%%%%%%%%%%%% \
/
		t zzset063
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr063
		:zzset063
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr063
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^60$/ {
#--------------------------------------------------
/^60$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 60\\\\N\\\\N %%%%%%%%%%%%%%%%%%%% \\\\N % %     %          % \\\\N %       o  %% %%% %% \\\\N %%%%%  %%   o  o   % \\\\N %%..%%  % % o % %  % \\\\N %....  o     %%o% %% \\\\N %....  o%%%%%   %o%% \\\\N %%..% %  %   %  o  % \\\\N %%%.% %  o   o  % @% \\\\N %%  o  o %   %  %%%% \\\\N %%       %%%%%%%%%%% \\\\N %%%%%%%%%%%%%%%%%%%% \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 60\
\
 %%%%%%%%%%%%%%%%%%%% \
 % %     %          % \
 %       o  %% %%% %% \
 %%%%%  %%   o  o   % \
 %%..%%  % % o % %  % \
 %....  o     %%o% %% \
 %....  o%%%%%   %o%% \
 %%..% %  %   %  o  % \
 %%%.% %  o   o  % @% \
 %%  o  o %   %  %%%% \
 %%       %%%%%%%%%%% \
 %%%%%%%%%%%%%%%%%%%% \
/
		t zzset064
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr064
		:zzset064
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr064
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^61$/ {
#--------------------------------------------------
/^61$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 61\\\\N\\\\N %%%%%%%%%%%%%%%%%%%% \\\\N %     %%%..%%%     % \\\\N % oo  %%%..%%%  o@ % \\\\N %  % %%......%  o  % \\\\N %     %......%  o  % \\\\N %%%%  %%%..%%%%%%o % \\\\N %   ooo %..%    %  % \\\\N % o%   o  o  oo %o % \\\\N %  %  %% o  %%  %  % \\\\N % o    o %% o    o % \\\\N %  %  %%    %%  %  % \\\\N %%%%%%%%%%%%%%%%%%%% \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 61\
\
 %%%%%%%%%%%%%%%%%%%% \
 %     %%%..%%%     % \
 % oo  %%%..%%%  o@ % \
 %  % %%......%  o  % \
 %     %......%  o  % \
 %%%%  %%%..%%%%%%o % \
 %   ooo %..%    %  % \
 % o%   o  o  oo %o % \
 %  %  %% o  %%  %  % \
 % o    o %% o    o % \
 %  %  %%    %%  %  % \
 %%%%%%%%%%%%%%%%%%%% \
/
		t zzset065
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr065
		:zzset065
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr065
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^62$/ {
#--------------------------------------------------
/^62$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 62\\\\N\\\\N %%%%%%%%%%%%%%%%%%%% \\\\N %    %  % %  %  %  % \\\\N % @% % %% o   o   %% \\\\N %%%% %    %  % o   % \\\\N %    % %% %o %% %% % \\\\N %      o   o   o   % \\\\N %..%%%oo%% o%%o %% % \\\\N %..%.%  % o   o %  % \\\\N %....% oo   %%o %%%% \\\\N %....%  %%%%%      % \\\\N %...%%%        %%  % \\\\N %%%%%%%%%%%%%%%%%%%% \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 62\
\
 %%%%%%%%%%%%%%%%%%%% \
 %    %  % %  %  %  % \
 % @% % %% o   o   %% \
 %%%% %    %  % o   % \
 %    % %% %o %% %% % \
 %      o   o   o   % \
 %..%%%oo%% o%%o %% % \
 %..%.%  % o   o %  % \
 %....% oo   %%o %%%% \
 %....%  %%%%%      % \
 %...%%%        %%  % \
 %%%%%%%%%%%%%%%%%%%% \
/
		t zzset066
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr066
		:zzset066
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr066
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^63$/ {
#--------------------------------------------------
/^63$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 63\\\\N\\\\N %%%%%%%%%%%%%%%%%%%% \\\\N %....%       %  %  % \\\\N %....% % o  o      % \\\\N %.... %%  o% % o%o % \\\\N %...%   o   o%  o  % \\\\N %..%%%%  % o   oo  % \\\\N %      %%%% %%%% %%% \\\\N %        %   %     % \\\\N % %%   %   o % o o % \\\\N % %%    o %% o  o  % \\\\N %     @%     %   % % \\\\N %%%%%%%%%%%%%%%%%%%% \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 63\
\
 %%%%%%%%%%%%%%%%%%%% \
 %....%       %  %  % \
 %....% % o  o      % \
 %.... %%  o% % o%o % \
 %...%   o   o%  o  % \
 %..%%%%  % o   oo  % \
 %      %%%% %%%% %%% \
 %        %   %     % \
 % %%   %   o % o o % \
 % %%    o %% o  o  % \
 %     @%     %   % % \
 %%%%%%%%%%%%%%%%%%%% \
/
		t zzset067
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr067
		:zzset067
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr067
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^64$/ {
#--------------------------------------------------
/^64$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 64\\\\N\\\\N %%%%%%%%%%%%%%%%%%%% \\\\N %....%%%           % \\\\N %....%%%%% %  %o% %% \\\\N %....%%%   %o  o   % \\\\N %....%%%    o  %oo%% \\\\N %%  %%%% o%  %o o  % \\\\N %%  %%%%  o  o  %  % \\\\N %@  %%%%o%%%o%% o  % \\\\N %%        %  %  o  % \\\\N %%   %%%  %  o  %%%% \\\\N %%%%%%%%  %  %     % \\\\N %%%%%%%%%%%%%%%%%%%% \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 64\
\
 %%%%%%%%%%%%%%%%%%%% \
 %....%%%           % \
 %....%%%%% %  %o% %% \
 %....%%%   %o  o   % \
 %....%%%    o  %oo%% \
 %%  %%%% o%  %o o  % \
 %%  %%%%  o  o  %  % \
 %@  %%%%o%%%o%% o  % \
 %%        %  %  o  % \
 %%   %%%  %  o  %%%% \
 %%%%%%%%  %  %     % \
 %%%%%%%%%%%%%%%%%%%% \
/
		t zzset068
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr068
		:zzset068
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr068
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^65$/ {
#--------------------------------------------------
/^65$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 65\\\\N\\\\N %%%%%%%%%%%%%%%%%%%% \\\\N %     %     @%...%%% \\\\N %     %      %%...%% \\\\N % % % %%o%% %% ....% \\\\N %   o %   ooo  ....% \\\\N %%%o%%% oo  %%% %%.% \\\\N %     o  %    % %%%% \\\\N %  o  %  %%%  % %  % \\\\N %% %o%%    o  oo   % \\\\N %   o %%   %  % %  % \\\\N %     %    %  %    % \\\\N %%%%%%%%%%%%%%%%%%%% \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 65\
\
 %%%%%%%%%%%%%%%%%%%% \
 %     %     @%...%%% \
 %     %      %%...%% \
 % % % %%o%% %% ....% \
 %   o %   ooo  ....% \
 %%%o%%% oo  %%% %%.% \
 %     o  %    % %%%% \
 %  o  %  %%%  % %  % \
 %% %o%%    o  oo   % \
 %   o %%   %  % %  % \
 %     %    %  %    % \
 %%%%%%%%%%%%%%%%%%%% \
/
		t zzset069
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr069
		:zzset069
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr069
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^66$/ {
#--------------------------------------------------
/^66$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 66\\\\N\\\\N %%%%%%%%%%%%%%%%%%%% \\\\N %     %  %...%@    % \\\\N % %       ....%    % \\\\N %  o  %   %....%   % \\\\N % %%o%%%% %%....%  % \\\\N % o   o  %  %...%  % \\\\N % oo %   %   % oo  % \\\\N %%%  ooo%   oo  o  % \\\\N % o  %  %    % o%  % \\\\N %   o%  %       o  % \\\\N %  %    %    %  %  % \\\\N %%%%%%%%%%%%%%%%%%%% \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 66\
\
 %%%%%%%%%%%%%%%%%%%% \
 %     %  %...%@    % \
 % %       ....%    % \
 %  o  %   %....%   % \
 % %%o%%%% %%....%  % \
 % o   o  %  %...%  % \
 % oo %   %   % oo  % \
 %%%  ooo%   oo  o  % \
 % o  %  %    % o%  % \
 %   o%  %       o  % \
 %  %    %    %  %  % \
 %%%%%%%%%%%%%%%%%%%% \
/
		t zzset070
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr070
		:zzset070
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr070
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^67$/ {
#--------------------------------------------------
/^67$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 67\\\\N\\\\N %%%%%%%%%%%%%%%%%%%% \\\\N %%%%%@%%%.%%...%%  % \\\\N %%%%%o  ..%...%    % \\\\N %%%%    ......%  o % \\\\N %%%  o %.....%% % %% \\\\N %%  oo% %%%%%  o o % \\\\N %% o% o    %%  oo  % \\\\N %%  %  %    % o  o % \\\\N %%   oo %%% %o%%   % \\\\N %% o%      o o  o %% \\\\N %%%    %    %    %%% \\\\N %%%%%%%%%%%%%%%%%%%% \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 67\
\
 %%%%%%%%%%%%%%%%%%%% \
 %%%%%@%%%.%%...%%  % \
 %%%%%o  ..%...%    % \
 %%%%    ......%  o % \
 %%%  o %.....%% % %% \
 %%  oo% %%%%%  o o % \
 %% o% o    %%  oo  % \
 %%  %  %    % o  o % \
 %%   oo %%% %o%%   % \
 %% o%      o o  o %% \
 %%%    %    %    %%% \
 %%%%%%%%%%%%%%%%%%%% \
/
		t zzset071
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr071
		:zzset071
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr071
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^68$/ {
#--------------------------------------------------
/^68$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 68\\\\N\\\\N %%%%%%%%%%%%%%%%%%%% \\\\N %@     %   %       % \\\\N %% %%% %%  %%%% % %% \\\\N %    % %  oo       % \\\\N %  % % % o % o %% %% \\\\N %     o %  %oo %   % \\\\N %  %%%  %      %% %% \\\\N %..%.% o %  o %    % \\\\N %..%.%  o % %% oo  % \\\\N %....%%   oo  o  % % \\\\N %.....%%        %  % \\\\N %%%%%%%%%%%%%%%%%%%% \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 68\
\
 %%%%%%%%%%%%%%%%%%%% \
 %@     %   %       % \
 %% %%% %%  %%%% % %% \
 %    % %  oo       % \
 %  % % % o % o %% %% \
 %     o %  %oo %   % \
 %  %%%  %      %% %% \
 %..%.% o %  o %    % \
 %..%.%  o % %% oo  % \
 %....%%   oo  o  % % \
 %.....%%        %  % \
 %%%%%%%%%%%%%%%%%%%% \
/
		t zzset072
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr072
		:zzset072
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr072
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^69$/ {
#--------------------------------------------------
/^69$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 69\\\\N\\\\N %%%%%%%%%%%%%%%%%%%% \\\\N %  %      %   %   %% \\\\N % o% o o %%...o  o % \\\\N %  o  % %%....% o  % \\\\N % %% o %%....%   o % \\\\N % o    %....%% o   % \\\\N % o%%  %...%       % \\\\N %   ooo%%o%%  %%% %% \\\\N % % %  %   %  %    % \\\\N % o %  o  %%       % \\\\N %    %    %@       % \\\\N %%%%%%%%%%%%%%%%%%%% \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 69\
\
 %%%%%%%%%%%%%%%%%%%% \
 %  %      %   %   %% \
 % o% o o %%...o  o % \
 %  o  % %%....% o  % \
 % %% o %%....%   o % \
 % o    %....%% o   % \
 % o%%  %...%       % \
 %   ooo%%o%%  %%% %% \
 % % %  %   %  %    % \
 % o %  o  %%       % \
 %    %    %@       % \
 %%%%%%%%%%%%%%%%%%%% \
/
		t zzset073
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr073
		:zzset073
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr073
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^70$/ {
#--------------------------------------------------
/^70$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 70\\\\N\\\\N %%%%%%%%%%%%%%%%%%%% \\\\N %  %  % %    %  %  % \\\\N %   o      o o     % \\\\N %% %  %o%%%o%%  %% % \\\\N %   o     o  %  o  % \\\\N % %%%o%%o%   % o   % \\\\N % %   o o  %%%%%% o% \\\\N % o  oo o  %@%.%...% \\\\N % %     %  % %.%...% \\\\N % %%%%%%%%%% %.....% \\\\N %            %.....% \\\\N %%%%%%%%%%%%%%%%%%%% \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 70\
\
 %%%%%%%%%%%%%%%%%%%% \
 %  %  % %    %  %  % \
 %   o      o o     % \
 %% %  %o%%%o%%  %% % \
 %   o     o  %  o  % \
 % %%%o%%o%   % o   % \
 % %   o o  %%%%%% o% \
 % o  oo o  %@%.%...% \
 % %     %  % %.%...% \
 % %%%%%%%%%% %.....% \
 %            %.....% \
 %%%%%%%%%%%%%%%%%%%% \
/
		t zzset074
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr074
		:zzset074
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr074
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^71$/ {
#--------------------------------------------------
/^71$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 71\\\\N\\\\N %%%%%%%%%%%%%%%%%%%% \\\\N %  %     %  %%    %% \\\\N % o%   o %     %%  % \\\\N % o  o  %..%     o % \\\\N % o o  %....%   % %% \\\\N % o%  %......%%% o % \\\\N %   %  %....%  %o  % \\\\N % o  %%%%..%   %   % \\\\N %% o   %% % % o  o%% \\\\N %%% o    o%@o o%   % \\\\N %%%%   %       %   % \\\\N %%%%%%%%%%%%%%%%%%%% \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 71\
\
 %%%%%%%%%%%%%%%%%%%% \
 %  %     %  %%    %% \
 % o%   o %     %%  % \
 % o  o  %..%     o % \
 % o o  %....%   % %% \
 % o%  %......%%% o % \
 %   %  %....%  %o  % \
 % o  %%%%..%   %   % \
 %% o   %% % % o  o%% \
 %%% o    o%@o o%   % \
 %%%%   %       %   % \
 %%%%%%%%%%%%%%%%%%%% \
/
		t zzset075
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr075
		:zzset075
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr075
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^72$/ {
#--------------------------------------------------
/^72$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 72\\\\N\\\\N %%%%%%%%%%%%%%%%%%%% \\\\N %      ....%    %%%% \\\\N %      ....        % \\\\N % % %%%%%%%%%%     % \\\\N % %o   %      %%%..% \\\\N %  o   %oo%%%   %..% \\\\N % o %%% o   o   %..% \\\\N % o %   o o %  %%..% \\\\N %  %  oo % o %%   %% \\\\N %@%% o%  o  o     %% \\\\N %%       %%   %  %%% \\\\N %%%%%%%%%%%%%%%%%%%% \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 72\
\
 %%%%%%%%%%%%%%%%%%%% \
 %      ....%    %%%% \
 %      ....        % \
 % % %%%%%%%%%%     % \
 % %o   %      %%%..% \
 %  o   %oo%%%   %..% \
 % o %%% o   o   %..% \
 % o %   o o %  %%..% \
 %  %  oo % o %%   %% \
 %@%% o%  o  o     %% \
 %%       %%   %  %%% \
 %%%%%%%%%%%%%%%%%%%% \
/
		t zzset076
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr076
		:zzset076
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr076
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^73$/ {
#--------------------------------------------------
/^73$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 73\\\\N\\\\N %%%%%%%%%%%%%%%%%%%% \\\\N %        %   %@ %  % \\\\N % oo  %oo% % %  %% % \\\\N %  % o o %oo %     % \\\\N %% %  %  % % %  %  % \\\\N %   %%       %     % \\\\N %   % o %   %   %  % \\\\N % o %o %   %  o %..% \\\\N %%o %  %%%%    %...% \\\\N %  o          %....% \\\\N %   %  %     %.....% \\\\N %%%%%%%%%%%%%%%%%%%% \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 73\
\
 %%%%%%%%%%%%%%%%%%%% \
 %        %   %@ %  % \
 % oo  %oo% % %  %% % \
 %  % o o %oo %     % \
 %% %  %  % % %  %  % \
 %   %%       %     % \
 %   % o %   %   %  % \
 % o %o %   %  o %..% \
 %%o %  %%%%    %...% \
 %  o          %....% \
 %   %  %     %.....% \
 %%%%%%%%%%%%%%%%%%%% \
/
		t zzset077
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr077
		:zzset077
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr077
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^74$/ {
#--------------------------------------------------
/^74$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 74\\\\N\\\\N %%%%%%%%%%%%%%%%%%%% \\\\N %     %   %%%%%    % \\\\N %% o  %   %%%%  o  % \\\\N %%%% oo   %..%  %  % \\\\N %  o  o  %%..%%%% %% \\\\N % o   %%%....   oo % \\\\N %  %o%   ....% % o % \\\\N % %  % o ..%%%o%   % \\\\N % %   o %..%   %%  % \\\\N %   o%  %%%%   % o%% \\\\N % %  %    @%      %% \\\\N %%%%%%%%%%%%%%%%%%%% \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 74\
\
 %%%%%%%%%%%%%%%%%%%% \
 %     %   %%%%%    % \
 %% o  %   %%%%  o  % \
 %%%% oo   %..%  %  % \
 %  o  o  %%..%%%% %% \
 % o   %%%....   oo % \
 %  %o%   ....% % o % \
 % %  % o ..%%%o%   % \
 % %   o %..%   %%  % \
 %   o%  %%%%   % o%% \
 % %  %    @%      %% \
 %%%%%%%%%%%%%%%%%%%% \
/
		t zzset078
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr078
		:zzset078
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr078
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^75$/ {
#--------------------------------------------------
/^75$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 75\\\\N\\\\N %%%%%%%%%%%%%%%%%%%% \\\\N %   %   %    %   %@% \\\\N %   o  o     % o % % \\\\N %%o% o%%% %    oo% % \\\\N %  %  %.%%%  %o o  % \\\\N %  %o%....%  % %%% % \\\\N % o  %.....%%    % % \\\\N %%o  %.%....%oo o  % \\\\N %  %%%%%%..%% %  % % \\\\N %  o         o %%% % \\\\N %   %   %        % % \\\\N %%%%%%%%%%%%%%%%%%%% \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 75\
\
 %%%%%%%%%%%%%%%%%%%% \
 %   %   %    %   %@% \
 %   o  o     % o % % \
 %%o% o%%% %    oo% % \
 %  %  %.%%%  %o o  % \
 %  %o%....%  % %%% % \
 % o  %.....%%    % % \
 %%o  %.%....%oo o  % \
 %  %%%%%%..%% %  % % \
 %  o         o %%% % \
 %   %   %        % % \
 %%%%%%%%%%%%%%%%%%%% \
/
		t zzset079
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr079
		:zzset079
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr079
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^76$/ {
#--------------------------------------------------
/^76$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 76\\\\N\\\\N %%%%%%%%%%%%%%%%%%%% \\\\N % % % %   %@%%   % % \\\\N %             o    % \\\\N %  %%o% %%%%% o % %% \\\\N %%    %%.....%  %  % \\\\N %%o%%o%.....%%%o%o % \\\\N %   % %%.....%  % %% \\\\N %  o    %%..%%  %  % \\\\N % o %   o   o  ooo % \\\\N %% o  o% %  %  o   % \\\\N %   %%   %  %      % \\\\N %%%%%%%%%%%%%%%%%%%% \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 76\
\
 %%%%%%%%%%%%%%%%%%%% \
 % % % %   %@%%   % % \
 %             o    % \
 %  %%o% %%%%% o % %% \
 %%    %%.....%  %  % \
 %%o%%o%.....%%%o%o % \
 %   % %%.....%  % %% \
 %  o    %%..%%  %  % \
 % o %   o   o  ooo % \
 %% o  o% %  %  o   % \
 %   %%   %  %      % \
 %%%%%%%%%%%%%%%%%%%% \
/
		t zzset080
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr080
		:zzset080
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr080
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^77$/ {
#--------------------------------------------------
/^77$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 77\\\\N\\\\N %%%%%%%%%%%%%%%%%%%% \\\\N %    %%   %    %   % \\\\N %  o  o     %% o   % \\\\N %% %%%%%  .%%%%%% %% \\\\N  % %%  %%....%%%% %% \\\\N %% %%o %%%..%%     % \\\\N %      %... .% o o % \\\\N % o %% %% . %%% %%%% \\\\N % % o    %.%% % %    \\\\N % o o %   .%%%% %%   \\\\N % %  %% % %%  %  %%  \\\\N %%%%%%%  o%%o   o %  \\\\N       %%      o %@%  \\\\N        %  %% %%%%%%  \\\\N        %%%%%%%       \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 77\
\
 %%%%%%%%%%%%%%%%%%%% \
 %    %%   %    %   % \
 %  o  o     %% o   % \
 %% %%%%%  .%%%%%% %% \
  % %%  %%....%%%% %% \
 %% %%o %%%..%%     % \
 %      %... .% o o % \
 % o %% %% . %%% %%%% \
 % % o    %.%% % %    \
 % o o %   .%%%% %%   \
 % %  %% % %%  %  %%  \
 %%%%%%%  o%%o   o %  \
       %%      o %@%  \
        %  %% %%%%%%  \
        %%%%%%%       \
/
		t zzset081
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr081
		:zzset081
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr081
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^78$/ {
#--------------------------------------------------
/^78$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 78\\\\N\\\\N        %%%%%%%%%%%   \\\\N        %         %   \\\\N        %    o o  %   \\\\N %%%%%% % o %%%%% %   \\\\N %    %%%%% o  %%o%   \\\\N %       o o      %   \\\\N %          %% %% %   \\\\N %    %%@%%%%% %% %   \\\\N %    %%%%   % %% %%  \\\\N %....%      % o   %  \\\\N %....%      %     %  \\\\N %%%%%%      %%%%%%%  \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 78\
\
        %%%%%%%%%%%   \
        %         %   \
        %    o o  %   \
 %%%%%% % o %%%%% %   \
 %    %%%%% o  %%o%   \
 %       o o      %   \
 %          %% %% %   \
 %    %%@%%%%% %% %   \
 %    %%%%   % %% %%  \
 %....%      % o   %  \
 %....%      %     %  \
 %%%%%%      %%%%%%%  \
/
		t zzset082
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr082
		:zzset082
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr082
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^79$/ {
#--------------------------------------------------
/^79$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 79\\\\N\\\\N %%%%%%%%%%%%%        \\\\N %           %        \\\\N % %%% oo    %        \\\\N %   % o  o  %        \\\\N %  o%%%%o%%%%%%      \\\\N % o %%        %%%%%  \\\\N %  oo o        ...%  \\\\N %%% %% oo%     ...%  \\\\N   % %%   %     ...%  \\\\N   %      %     ...%  \\\\N   %%%@%%%%%%%%%%%%%  \\\\N     %%%              \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 79\
\
 %%%%%%%%%%%%%        \
 %           %        \
 % %%% oo    %        \
 %   % o  o  %        \
 %  o%%%%o%%%%%%      \
 % o %%        %%%%%  \
 %  oo o        ...%  \
 %%% %% oo%     ...%  \
   % %%   %     ...%  \
   %      %     ...%  \
   %%%@%%%%%%%%%%%%%  \
     %%%              \
/
		t zzset083
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr083
		:zzset083
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr083
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^80$/ {
#--------------------------------------------------
/^80$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 80\\\\N\\\\N   %%%%%%%%%%%%%%%%%  \\\\N %%%@%%         ...%  \\\\N %    %         ...%  \\\\N % o  %         ...%  \\\\N % oo %         ...%  \\\\N %% o %%%o%%%%%%%%%%  \\\\N  % %%%  o %          \\\\N %%   o  o %          \\\\N %  o %  o %          \\\\N % o  %    %          \\\\N %  o %    %          \\\\N %    %    %          \\\\N %%%%%%%%%%%          \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 80\
\
   %%%%%%%%%%%%%%%%%  \
 %%%@%%         ...%  \
 %    %         ...%  \
 % o  %         ...%  \
 % oo %         ...%  \
 %% o %%%o%%%%%%%%%%  \
  % %%%  o %          \
 %%   o  o %          \
 %  o %  o %          \
 % o  %    %          \
 %  o %    %          \
 %    %    %          \
 %%%%%%%%%%%          \
/
		t zzset084
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr084
		:zzset084
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr084
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^81$/ {
#--------------------------------------------------
/^81$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 81\\\\N\\\\N               %%%%%  \\\\N      %%%%%%%%%%   %  \\\\N      %        %   %  \\\\N      %  o o    oo %  \\\\N      % %%%%% %% o %  \\\\N      %oo   %o%% o %  \\\\N      % %%% % %%o  %  \\\\N %%%%%% %%% o o    %  \\\\N %....        %%   %  \\\\N %....        %%%%%%  \\\\N %....        %       \\\\N %%%%%%%%%%%@%%       \\\\N           %%%        \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 81\
\
               %%%%%  \
      %%%%%%%%%%   %  \
      %        %   %  \
      %  o o    oo %  \
      % %%%%% %% o %  \
      %oo   %o%% o %  \
      % %%% % %%o  %  \
 %%%%%% %%% o o    %  \
 %....        %%   %  \
 %....        %%%%%%  \
 %....        %       \
 %%%%%%%%%%%@%%       \
           %%%        \
/
		t zzset085
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr085
		:zzset085
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr085
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^82$/ {
#--------------------------------------------------
/^82$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 82\\\\N\\\\N     %%%%%%           \\\\N  %%%%    %           \\\\N  %    %% %           \\\\N  % o     %           \\\\N %%% %%%% %%%%%%%%    \\\\N %  o   o %%  ...%    \\\\N %   oo oo    ...%    \\\\N %    o  o%%  ...%    \\\\N %%@%% %% %%  ...%    \\\\N  %%%  o  %%%%%%%%    \\\\N  %   oo  %           \\\\N  %    %  %           \\\\N  %%%%%%%%%           \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 82\
\
     %%%%%%           \
  %%%%    %           \
  %    %% %           \
  % o     %           \
 %%% %%%% %%%%%%%%    \
 %  o   o %%  ...%    \
 %   oo oo    ...%    \
 %    o  o%%  ...%    \
 %%@%% %% %%  ...%    \
  %%%  o  %%%%%%%%    \
  %   oo  %           \
  %    %  %           \
  %%%%%%%%%           \
/
		t zzset086
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr086
		:zzset086
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr086
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^83$/ {
#--------------------------------------------------
/^83$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 83\\\\N\\\\N %%%%%%% %%%%%%%%%    \\\\N %     % %   %%  %    \\\\N % %%% % %   o   %    \\\\N % % o %%%   o   %    \\\\N %   oo      %%o %    \\\\N %    %%%%   %%  %    \\\\N %@%%%%%%%%%%%% %%    \\\\N %%%..    %%%%%o %    \\\\N   %..    %%%%   %    \\\\N   %..       oo  %    \\\\N   %..    %%%% o %    \\\\N   %..    %  %   %    \\\\N   %%%%%%%%  %%%%%    \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 83\
\
 %%%%%%% %%%%%%%%%    \
 %     % %   %%  %    \
 % %%% % %   o   %    \
 % % o %%%   o   %    \
 %   oo      %%o %    \
 %    %%%%   %%  %    \
 %@%%%%%%%%%%%% %%    \
 %%%..    %%%%%o %    \
   %..    %%%%   %    \
   %..       oo  %    \
   %..    %%%% o %    \
   %..    %  %   %    \
   %%%%%%%%  %%%%%    \
/
		t zzset087
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr087
		:zzset087
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr087
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^84$/ {
#--------------------------------------------------
/^84$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 84\\\\N\\\\N %%%%%%%              \\\\N %     %%%%%%%%%%     \\\\N %     %    %  %%     \\\\N % o   %   o o  %     \\\\N %  o  %  o %%  %     \\\\N % oo  %%o o    %     \\\\N %% %  %% %%%%%%%     \\\\N %% %  %%    ...%     \\\\N %  %o       ...%     \\\\N %   oo      ...%     \\\\N %     %%@%  ...%     \\\\N %%%%%%%%%%%%%%%%     \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 84\
\
 %%%%%%%              \
 %     %%%%%%%%%%     \
 %     %    %  %%     \
 % o   %   o o  %     \
 %  o  %  o %%  %     \
 % oo  %%o o    %     \
 %% %  %% %%%%%%%     \
 %% %  %%    ...%     \
 %  %o       ...%     \
 %   oo      ...%     \
 %     %%@%  ...%     \
 %%%%%%%%%%%%%%%%     \
/
		t zzset088
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr088
		:zzset088
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr088
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^85$/ {
#--------------------------------------------------
/^85$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 85\\\\N\\\\N %%%%%%%%%%%%         \\\\N %      %   %%        \\\\N % o  o   %  %%%%%%   \\\\N %%%%  %%%%%      %   \\\\N  %..  %     %%%% %   \\\\N  %.%%%%  %%%%    %   \\\\N  %....    %  o %%%%  \\\\N  % ...%   % ooo%  %% \\\\N %%%.%%%% %%  o@o   % \\\\N %     %%%%% o %    % \\\\N % %.% o      o%%%o % \\\\N % %.%%%%%%%%  %  o % \\\\N % %..        %%  o % \\\\N % % %%%%%%% o % %  % \\\\N %   %     %       %% \\\\N %%%%%     %%%%%%%%%% \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 85\
\
 %%%%%%%%%%%%         \
 %      %   %%        \
 % o  o   %  %%%%%%   \
 %%%%  %%%%%      %   \
  %..  %     %%%% %   \
  %.%%%%  %%%%    %   \
  %....    %  o %%%%  \
  % ...%   % ooo%  %% \
 %%%.%%%% %%  o@o   % \
 %     %%%%% o %    % \
 % %.% o      o%%%o % \
 % %.%%%%%%%%  %  o % \
 % %..        %%  o % \
 % % %%%%%%% o % %  % \
 %   %     %       %% \
 %%%%%     %%%%%%%%%% \
/
		t zzset089
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr089
		:zzset089
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr089
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^86$/ {
#--------------------------------------------------
/^86$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 86\\\\N\\\\N %%%%%%%%%%%%%%%%     \\\\N %       %@ %   %     \\\\N % % % % % o  oo%     \\\\N % %...% %ooo   %     \\\\N %  ...% % o  oo%%    \\\\N % %%.%% % %%    %    \\\\N % %...     o    %    \\\\N % %% %%%  %%%%%%%    \\\\N %    % %%%%          \\\\N %%%%%%               \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 86\
\
 %%%%%%%%%%%%%%%%     \
 %       %@ %   %     \
 % % % % % o  oo%     \
 % %...% %ooo   %     \
 %  ...% % o  oo%%    \
 % %%.%% % %%    %    \
 % %...     o    %    \
 % %% %%%  %%%%%%%    \
 %    % %%%%          \
 %%%%%%               \
/
		t zzset090
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr090
		:zzset090
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr090
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^87$/ {
#--------------------------------------------------
/^87$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 87\\\\N\\\\N     %%%%%            \\\\N  %%%%   %% %%%%%     \\\\N  %  o    %%%   %     \\\\N  % o@o o    o  %     \\\\N  % %o%%%%%%%% %%     \\\\N  % %  o  %     %     \\\\N  % % o o % %   %     \\\\N %% %  o% % %%%%%     \\\\N %  %%    %     %     \\\\N %    o % %%%   %     \\\\N %%%%% %%  %....%     \\\\N %    o     ....%     \\\\N %         %....%     \\\\N %%%%%%%%%%%%%%%%     \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 87\
\
     %%%%%            \
  %%%%   %% %%%%%     \
  %  o    %%%   %     \
  % o@o o    o  %     \
  % %o%%%%%%%% %%     \
  % %  o  %     %     \
  % % o o % %   %     \
 %% %  o% % %%%%%     \
 %  %%    %     %     \
 %    o % %%%   %     \
 %%%%% %%  %....%     \
 %    o     ....%     \
 %         %....%     \
 %%%%%%%%%%%%%%%%     \
/
		t zzset091
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr091
		:zzset091
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr091
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^88$/ {
#--------------------------------------------------
/^88$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 88\\\\N\\\\N %%%%%%%%%%%%%        \\\\N %........%%%%        \\\\N %...%%%% %  %%%%%    \\\\N %...%  %%%    o %    \\\\N %...oo     o o  %    \\\\N %  .%  o o% o  %%    \\\\N %...% %o%   o  %     \\\\N %.% % o   o    %     \\\\N %.  %o%%%o%%%%o%     \\\\N %%  %   o o    %     \\\\N  %  %  o@o  %  %     \\\\N  %  % %%%% o  o%     \\\\N  %  %    %%%   %     \\\\N  %  % oo % %%%%%     \\\\N  %  %    %           \\\\N  %%%%%%%%%           \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 88\
\
 %%%%%%%%%%%%%        \
 %........%%%%        \
 %...%%%% %  %%%%%    \
 %...%  %%%    o %    \
 %...oo     o o  %    \
 %  .%  o o% o  %%    \
 %...% %o%   o  %     \
 %.% % o   o    %     \
 %.  %o%%%o%%%%o%     \
 %%  %   o o    %     \
  %  %  o@o  %  %     \
  %  % %%%% o  o%     \
  %  %    %%%   %     \
  %  % oo % %%%%%     \
  %  %    %           \
  %%%%%%%%%           \
/
		t zzset092
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr092
		:zzset092
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr092
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^89$/ {
#--------------------------------------------------
/^89$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 89\\\\N\\\\N  %%%%%%%%%%%%%%%%%%  \\\\N  %   o       ...%.%% \\\\N  %       %%%%..... % \\\\N  % %%%%%%%  %..... % \\\\N  % %    o o %%....%% \\\\N  % %  o % % %%%...%  \\\\N  % % o@o o  %%%%% %  \\\\N %% %  o  o oo   o %  \\\\N %  %o% o%   % o%% %  \\\\N % %%    %% %% o % %  \\\\N % % o% o o  %     %  \\\\N % %         %%%%%%%  \\\\N % %%%%%%%%o%%   %    \\\\N %        %  o   %    \\\\N %%%%%%%%    %%%%%    \\\\N        %%%  %        \\\\N          %%%%        \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 89\
\
  %%%%%%%%%%%%%%%%%%  \
  %   o       ...%.%% \
  %       %%%%..... % \
  % %%%%%%%  %..... % \
  % %    o o %%....%% \
  % %  o % % %%%...%  \
  % % o@o o  %%%%% %  \
 %% %  o  o oo   o %  \
 %  %o% o%   % o%% %  \
 % %%    %% %% o % %  \
 % % o% o o  %     %  \
 % %         %%%%%%%  \
 % %%%%%%%%o%%   %    \
 %        %  o   %    \
 %%%%%%%%    %%%%%    \
        %%%  %        \
          %%%%        \
/
		t zzset093
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr093
		:zzset093
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr093
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/^90$/ {
#--------------------------------------------------
/^90$/ {
		i\
COMM:s/.*/\\\\NSED Sokoban - LEVEL 90\\\\N\\\\N %%%%%%%%%%%%%%%%%%%% \\\\N %..%    %          % \\\\N %.o  o  %oo  o%% o%% \\\\N %.o%  %%%  %% %%   % \\\\N %  % o %  oo   o   % \\\\N % %%%  % %  %o  %%%% \\\\N %  %% % o   %@ %   % \\\\N % o    o  %%.%%  o % \\\\N %  % o% o% o     %%% \\\\N %  %  %  %   %%%   % \\\\N %  %%%%%%%% %      % \\\\N %           %  %.%.% \\\\N %%o%%%%%%%%o%   ...% \\\\N %    .O  %    %%.%.% \\\\N % .O...O   o  .....% \\\\N %%%%%%%%%%%%%%%%%%%% \\\\N                      \\\\N/
#--------------------------------------------------
s/.*/\
SED Sokoban - LEVEL 90\
\
 %%%%%%%%%%%%%%%%%%%% \
 %..%    %          % \
 %.o  o  %oo  o%% o%% \
 %.o%  %%%  %% %%   % \
 %  % o %  oo   o   % \
 % %%%  % %  %o  %%%% \
 %  %% % o   %@ %   % \
 % o    o  %%.%%  o % \
 %  % o% o% o     %%% \
 %  %  %  %   %%%   % \
 %  %%%%%%%% %      % \
 %           %  %.%.% \
 %%o%%%%%%%%o%   ...% \
 %    .O  %    %%.%.% \
 % .O...O   o  .....% \
 %%%%%%%%%%%%%%%%%%%% \
                      \
/
		t zzset094
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		t zzclr094
		:zzset094
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b endmap

		:zzclr094
#--------------------------------------------------
b endmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/SED Soko/ !{
#--------------------------------------------------
/SED Soko/ !{
		i\
COMM:s/.*/there is no '&' level!/p
#--------------------------------------------------
s/.*/there is no '&' level!/p
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:q
#--------------------------------------------------
q
		t zzset095
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:}

		t zzclr095
		:zzset095
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:}

		:zzclr095
#--------------------------------------------------
}
		i\
COMM::endmap
#--------------------------------------------------
:endmap
# back to line 1 col 1
		i\
COMM:s/^/[H/
#--------------------------------------------------
s/^/[H/
# show available commands
		t zzset096
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s,\\(\\n\\)$,\\1\\1[ h j k l :q :r :z :gN ],

		t zzclr096
		:zzset096
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s,\\(\\n\\)$,\\1\\1[ h j k l :q :r :z :gN ],

		:zzclr096
#--------------------------------------------------
s,\(\n\)$,\1\1[ h j k l :q :r :z :gN ],
		t zzset097
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:x

		t zzclr097
		:zzset097
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:x

		:zzclr097
#--------------------------------------------------
x
		t zzset098
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/:p / !s/.*//

		t zzclr098
		:zzset098
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/:p / !s/.*//

		:zzclr098
#--------------------------------------------------
/:p / !s/.*//
		t zzset099
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b ini

		t zzclr099
		:zzset099
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b ini

		:zzclr099
#--------------------------------------------------
b ini
		i\
COMM::zero
#--------------------------------------------------
:zero
# welcome message
		i\
COMM:1 b welcome
#--------------------------------------------------
1 b welcome
# first map loading
		i\
COMM:2 b loadmap
#--------------------------------------------------
2 b loadmap
# supporting arrow keys also
		i\
COMM:// {
#--------------------------------------------------
// {
		i\
COMM:s/\\[A/k/g
#--------------------------------------------------
s/\[A/k/g
		t zzset100
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\[B/j/g

		t zzclr100
		:zzset100
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\[B/j/g

		:zzclr100
#--------------------------------------------------
s/\[B/j/g
		t zzset101
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\[C/l/g

		t zzclr101
		:zzset101
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\[C/l/g

		:zzclr101
#--------------------------------------------------
s/\[C/l/g
		t zzset102
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\[D/h/g

		t zzclr102
		:zzset102
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\[D/h/g

		:zzclr102
#--------------------------------------------------
s/\[D/h/g
		t zzset103
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:}

		t zzclr103
		:zzset103
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:}

		:zzclr103
#--------------------------------------------------
}
# command aliases
		i\
COMM:s//:z/g
#--------------------------------------------------
s//:z/g
# lowercase commands
		t zzset104
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:y/HJKLQGZR/hjklqgzr/

		t zzclr104
		:zzset104
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:y/HJKLQGZR/hjklqgzr/

		:zzclr104
#--------------------------------------------------
y/HJKLQGZR/hjklqgzr/
# wipe trash (anything that is not command)
		t zzset105
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/[^hjklqgzr:0-9]//g

		t zzclr105
		:zzset105
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/[^hjklqgzr:0-9]//g

		:zzclr105
#--------------------------------------------------
s/[^hjklqgzr:0-9]//g
# commands!
		t zzset106
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/^:/ {

		t zzclr106
		:zzset106
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/^:/ {

		:zzclr106
#--------------------------------------------------
/^:/ {
# quit
		i\
COMM:/^:q/ q
#--------------------------------------------------
/^:q/ q
# refresh screen
		t zzset107
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/^:z/ {

		t zzclr107
		:zzset107
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/^:z/ {

		:zzclr107
#--------------------------------------------------
/^:z/ {
		i\
COMM:s/.*/[2J/p
#--------------------------------------------------
s/.*/[2J/p
		t zzset108
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/.*/:p [refresh]/

		t zzclr108
		:zzset108
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/.*/:p [refresh]/

		:zzclr108
#--------------------------------------------------
s/.*/:p [refresh]/
		t zzset109
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b ini

		t zzclr109
		:zzset109
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b ini

		:zzclr109
#--------------------------------------------------
b ini
		i\
COMM:}
#--------------------------------------------------
}
# goto level N (optional g)
		i\
COMM:/^:g\\{0,1\\}\\([0-9]\\{1,\\}\\)$/ {
#--------------------------------------------------
/^:g\{0,1\}\([0-9]\{1,\}\)$/ {
		i\
COMM:s//\\1/
		/^:g\{0,1\}\([0-9]\{1,\}\)$/y/!/!/
#--------------------------------------------------
s//\1/
		t zzset110
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:h

		t zzclr110
		:zzset110
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:h

		:zzclr110
#--------------------------------------------------
h
		t zzset111
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:x

		t zzclr111
		:zzset111
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:x

		:zzclr111
#--------------------------------------------------
x
		t zzset112
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/.*/:p [goto level &]/

		t zzclr112
		:zzset112
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/.*/:p [goto level &]/

		:zzclr112
#--------------------------------------------------
s/.*/:p [goto level &]/
		t zzset113
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:x

		t zzclr113
		:zzset113
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:x

		:zzclr113
#--------------------------------------------------
x
		t zzset114
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b loadmap

		t zzclr114
		:zzset114
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b loadmap

		:zzclr114
#--------------------------------------------------
b loadmap
		i\
COMM:}
#--------------------------------------------------
}
# restarting level
		i\
COMM:/^:r/ {
#--------------------------------------------------
/^:r/ {
		i\
COMM:s/.*/:p [restart]/
#--------------------------------------------------
s/.*/:p [restart]/
		t zzset115
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:x

		t zzclr115
		:zzset115
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:x

		:zzclr115
#--------------------------------------------------
x
		t zzset116
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/.*LEVEL \\([0-9]\\{1,\\}\\).*/\\1/

		t zzclr116
		:zzset116
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/.*LEVEL \\([0-9]\\{1,\\}\\).*/\\1/

		:zzclr116
#--------------------------------------------------
s/.*LEVEL \([0-9]\{1,\}\).*/\1/
		t zzset117
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b loadmap

		t zzclr117
		:zzset117
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b loadmap

		:zzclr117
#--------------------------------------------------
b loadmap
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:}
#--------------------------------------------------
}
# here the party begins
		i\
COMM::ini
#--------------------------------------------------
:ini
# print message (XXX bad idea)
		i\
COMM:/^:p / {
#--------------------------------------------------
/^:p / {
		i\
COMM:s/.*//
#--------------------------------------------------
s/.*//
#s//last command: /; s/$/       /p;
#s/last .*// 
		t zzset118
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:}

		t zzclr118
		:zzset118
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:}

		:zzclr118
#--------------------------------------------------
}
# empty command, jump to end
		i\
COMM:/./ !{
#--------------------------------------------------
/./ !{
		i\
COMM:x
#--------------------------------------------------
x
		t zzset119
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b x

		t zzclr119
		:zzset119
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b x

		:zzclr119
#--------------------------------------------------
b x
		i\
COMM:}
#--------------------------------------------------
}
# -------------[ LEFT ]--------------------------
		i\
COMM:/^h/ {
#--------------------------------------------------
/^h/ {
# del current move and save others
		i\
COMM:s///
		/^h/y/!/!/
#--------------------------------------------------
s///
		t zzset120
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:x

		t zzclr120
		:zzset120
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:x

		:zzclr120
#--------------------------------------------------
x
# reset 't' status
		t zzset121
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t zeroleft

		t zzclr121
		:zzset121
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t zeroleft

		:zzclr121
#--------------------------------------------------
t zeroleft
		i\
COMM::zeroleft
#--------------------------------------------------
:zeroleft
# clear path
		i\
COMM:s/ @/@ /
#--------------------------------------------------
s/ @/@ /
		t zzset122
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr122
		:zzset122
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr122
#--------------------------------------------------
t x
# push load
		i\
COMM:s/ o@/o@ /
#--------------------------------------------------
s/ o@/o@ /
		t zzset123
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr123
		:zzset123
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr123
#--------------------------------------------------
t x
# enter overdot
		i\
COMM:s/\\.@/! /
#--------------------------------------------------
s/\.@/! /
		t zzset124
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr124
		:zzset124
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr124
#--------------------------------------------------
t x
# continue overdot
		i\
COMM:s/\\.!/!./
#--------------------------------------------------
s/\.!/!./
		t zzset125
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr125
		:zzset125
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr125
#--------------------------------------------------
t x
# out overdot
		i\
COMM:s/ !/@./
#--------------------------------------------------
s/ !/@./
		t zzset126
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr126
		:zzset126
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr126
#--------------------------------------------------
t x
# enter load overdot
		i\
COMM:s/\\.o@/O@ /
#--------------------------------------------------
s/\.o@/O@ /
		t zzset127
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr127
		:zzset127
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr127
#--------------------------------------------------
t x
# enter overdot with load
		i\
COMM:s/\\.O@/O! /
#--------------------------------------------------
s/\.O@/O! /
		t zzset128
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr128
		:zzset128
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr128
#--------------------------------------------------
t x
# continue overdot with load
		i\
COMM:s/\\.O!/O!./
#--------------------------------------------------
s/\.O!/O!./
		t zzset129
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr129
		:zzset129
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr129
#--------------------------------------------------
t x
# out load overdot / enter overdot
		i\
COMM:s/ O@/o! /
#--------------------------------------------------
s/ O@/o! /
		t zzset130
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr130
		:zzset130
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr130
#--------------------------------------------------
t x
# out load overdot / continue overdot
		i\
COMM:s/ O!/o!./
#--------------------------------------------------
s/ O!/o!./
		t zzset131
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr131
		:zzset131
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr131
#--------------------------------------------------
t x
# out overdot with load
		i\
COMM:s/ o!/o@./
#--------------------------------------------------
s/ o!/o@./
		t zzset132
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr132
		:zzset132
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr132
#--------------------------------------------------
t x
# out overdot with load / enter overdot
		i\
COMM:s/\\.o!/O@./
#--------------------------------------------------
s/\.o!/O@./
		t zzset133
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr133
		:zzset133
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr133
#--------------------------------------------------
t x
# can't pass
		i\
COMM:b x
#--------------------------------------------------
b x
		i\
COMM:}
#--------------------------------------------------
}
# -------------[ RIGHT ]-------------------------
		i\
COMM:/^l/ {
#--------------------------------------------------
/^l/ {
# del current move and save others
		i\
COMM:s///
		/^l/y/!/!/
#--------------------------------------------------
s///
		t zzset134
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:x

		t zzclr134
		:zzset134
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:x

		:zzclr134
#--------------------------------------------------
x
# reset 't' status
		t zzset135
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t zerorght

		t zzclr135
		:zzset135
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t zerorght

		:zzclr135
#--------------------------------------------------
t zerorght
		i\
COMM::zerorght
#--------------------------------------------------
:zerorght
# clear path
		i\
COMM:s/@ / @/
#--------------------------------------------------
s/@ / @/
		t zzset136
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr136
		:zzset136
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr136
#--------------------------------------------------
t x
# push load
		i\
COMM:s/@o / @o/
#--------------------------------------------------
s/@o / @o/
		t zzset137
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr137
		:zzset137
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr137
#--------------------------------------------------
t x
# enter overdot
		i\
COMM:s/@\\./ !/
#--------------------------------------------------
s/@\./ !/
		t zzset138
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr138
		:zzset138
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr138
#--------------------------------------------------
t x
# continue overdot
		i\
COMM:s/!\\./.!/
#--------------------------------------------------
s/!\./.!/
		t zzset139
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr139
		:zzset139
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr139
#--------------------------------------------------
t x
# out overdot
		i\
COMM:s/! /.@/
#--------------------------------------------------
s/! /.@/
		t zzset140
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr140
		:zzset140
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr140
#--------------------------------------------------
t x
# enter load overdot
		i\
COMM:s/@o\\./ @O/
#--------------------------------------------------
s/@o\./ @O/
		t zzset141
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr141
		:zzset141
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr141
#--------------------------------------------------
t x
# enter overdot with load
		i\
COMM:s/@O\\./ !O/
#--------------------------------------------------
s/@O\./ !O/
		t zzset142
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr142
		:zzset142
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr142
#--------------------------------------------------
t x
# continue overdot with load
		i\
COMM:s/!O\\./.!O/
#--------------------------------------------------
s/!O\./.!O/
		t zzset143
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr143
		:zzset143
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr143
#--------------------------------------------------
t x
# out load overdot / enter overdot
		i\
COMM:s/@O / !o/
#--------------------------------------------------
s/@O / !o/
		t zzset144
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr144
		:zzset144
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr144
#--------------------------------------------------
t x
# out load overdot / continue overdot
		i\
COMM:s/!O /.!o/
#--------------------------------------------------
s/!O /.!o/
		t zzset145
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr145
		:zzset145
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr145
#--------------------------------------------------
t x
# out overdot with load
		i\
COMM:s/!o /.@o/
#--------------------------------------------------
s/!o /.@o/
		t zzset146
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr146
		:zzset146
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr146
#--------------------------------------------------
t x
# out overdot with load / enter overdot
		i\
COMM:s/!o\\./.@O/
#--------------------------------------------------
s/!o\./.@O/
		t zzset147
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr147
		:zzset147
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr147
#--------------------------------------------------
t x
# can't pass
		i\
COMM:b x
#--------------------------------------------------
b x
		i\
COMM:}
#--------------------------------------------------
}
# -------------[ DOWN ]--------------------------
		i\
COMM:/^j/ {
#--------------------------------------------------
/^j/ {
# del current move and save others
		i\
COMM:s///
		/^j/y/!/!/
#--------------------------------------------------
s///
		t zzset148
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:x

		t zzclr148
		:zzset148
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:x

		:zzclr148
#--------------------------------------------------
x
# reset 't' status
		t zzset149
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t zerodown

		t zzclr149
		:zzset149
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t zerodown

		:zzclr149
#--------------------------------------------------
t zerodown
		i\
COMM::zerodown
#--------------------------------------------------
:zerodown
# clear path
		i\
COMM:s/@\\(.\\{22\\}\\) / \\1@/
#--------------------------------------------------
s/@\(.\{22\}\) / \1@/
		t zzset150
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr150
		:zzset150
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr150
#--------------------------------------------------
t x
# push load
		i\
COMM:s/@\\(.\\{22\\}\\)o\\(.\\{22\\}\\) / \\1@\\2o/
#--------------------------------------------------
s/@\(.\{22\}\)o\(.\{22\}\) / \1@\2o/
		t zzset151
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr151
		:zzset151
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr151
#--------------------------------------------------
t x
# enter overdot
		i\
COMM:s/@\\(.\\{22\\}\\)\\./ \\1!/
#--------------------------------------------------
s/@\(.\{22\}\)\./ \1!/
		t zzset152
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr152
		:zzset152
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr152
#--------------------------------------------------
t x
# continue overdot
		i\
COMM:s/!\\(.\\{22\\}\\)\\./.\\1!/
#--------------------------------------------------
s/!\(.\{22\}\)\./.\1!/
		t zzset153
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr153
		:zzset153
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr153
#--------------------------------------------------
t x
# out overdot
		i\
COMM:s/!\\(.\\{22\\}\\) /.\\1@/
#--------------------------------------------------
s/!\(.\{22\}\) /.\1@/
		t zzset154
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr154
		:zzset154
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr154
#--------------------------------------------------
t x
# enter load overdot
		i\
COMM:s/@\\(.\\{22\\}\\)o\\(.\\{22\\}\\)\\./ \\1@\\2O/
#--------------------------------------------------
s/@\(.\{22\}\)o\(.\{22\}\)\./ \1@\2O/
		t zzset155
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr155
		:zzset155
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr155
#--------------------------------------------------
t x
# enter overdot with load
		i\
COMM:s/@\\(.\\{22\\}\\)O\\(.\\{22\\}\\)\\./ \\1!\\2O/
#--------------------------------------------------
s/@\(.\{22\}\)O\(.\{22\}\)\./ \1!\2O/
		t zzset156
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr156
		:zzset156
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr156
#--------------------------------------------------
t x
# continue overdot with load
		i\
COMM:s/!\\(.\\{22\\}\\)O\\(.\\{22\\}\\)\\./.\\1!\\2O/
#--------------------------------------------------
s/!\(.\{22\}\)O\(.\{22\}\)\./.\1!\2O/
		t zzset157
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr157
		:zzset157
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr157
#--------------------------------------------------
t x
# out load overdot / enter overdot
		i\
COMM:s/@\\(.\\{22\\}\\)O\\(.\\{22\\}\\) / \\1!\\2o/
#--------------------------------------------------
s/@\(.\{22\}\)O\(.\{22\}\) / \1!\2o/
		t zzset158
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr158
		:zzset158
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr158
#--------------------------------------------------
t x
# out load overdot / continue overdot
		i\
COMM:s/!\\(.\\{22\\}\\)O\\(.\\{22\\}\\) /.\\1!\\2o/
#--------------------------------------------------
s/!\(.\{22\}\)O\(.\{22\}\) /.\1!\2o/
		t zzset159
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr159
		:zzset159
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr159
#--------------------------------------------------
t x
# out overdot with load
		i\
COMM:s/!\\(.\\{22\\}\\)o\\(.\\{22\\}\\) /.\\1@\\2o/
#--------------------------------------------------
s/!\(.\{22\}\)o\(.\{22\}\) /.\1@\2o/
		t zzset160
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr160
		:zzset160
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr160
#--------------------------------------------------
t x
# out overdot with load / enter overdot
		i\
COMM:s/!\\(.\\{22\\}\\)o\\(.\\{22\\}\\)\\./.\\1@\\2O/
#--------------------------------------------------
s/!\(.\{22\}\)o\(.\{22\}\)\./.\1@\2O/
		t zzset161
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr161
		:zzset161
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr161
#--------------------------------------------------
t x
# target not free
		i\
COMM:b x
#--------------------------------------------------
b x
		i\
COMM:}
#--------------------------------------------------
}
# ---------------[ UP ]--------------------------
		i\
COMM:/^k/ {
#--------------------------------------------------
/^k/ {
# del current move and save others
		i\
COMM:s///
		/^k/y/!/!/
#--------------------------------------------------
s///
		t zzset162
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:x

		t zzclr162
		:zzset162
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:x

		:zzclr162
#--------------------------------------------------
x
# reset 't' status
		t zzset163
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t zeroup

		t zzclr163
		:zzset163
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t zeroup

		:zzclr163
#--------------------------------------------------
t zeroup
		i\
COMM::zeroup
#--------------------------------------------------
:zeroup
# clear path
		i\
COMM:s/ \\(.\\{22\\}\\)@/@\\1 /
#--------------------------------------------------
s/ \(.\{22\}\)@/@\1 /
		t zzset164
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr164
		:zzset164
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr164
#--------------------------------------------------
t x
# push load
		i\
COMM:s/ \\(.\\{22\\}\\)o\\(.\\{22\\}\\)@/o\\1@\\2 /
#--------------------------------------------------
s/ \(.\{22\}\)o\(.\{22\}\)@/o\1@\2 /
		t zzset165
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr165
		:zzset165
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr165
#--------------------------------------------------
t x
# enter overdot
		i\
COMM:s/\\.\\(.\\{22\\}\\)@/!\\1 /
#--------------------------------------------------
s/\.\(.\{22\}\)@/!\1 /
		t zzset166
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr166
		:zzset166
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr166
#--------------------------------------------------
t x
# continue overdot
		i\
COMM:s/\\.\\(.\\{22\\}\\)!/!\\1./
#--------------------------------------------------
s/\.\(.\{22\}\)!/!\1./
		t zzset167
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr167
		:zzset167
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr167
#--------------------------------------------------
t x
# out overdot
		i\
COMM:s/ \\(.\\{22\\}\\)!/@\\1./
#--------------------------------------------------
s/ \(.\{22\}\)!/@\1./
		t zzset168
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr168
		:zzset168
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr168
#--------------------------------------------------
t x
# enter load overdot
		i\
COMM:s/\\.\\(.\\{22\\}\\)o\\(.\\{22\\}\\)@/O\\1@\\2 /
#--------------------------------------------------
s/\.\(.\{22\}\)o\(.\{22\}\)@/O\1@\2 /
		t zzset169
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr169
		:zzset169
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr169
#--------------------------------------------------
t x
# enter overdot with load
		i\
COMM:s/\\.\\(.\\{22\\}\\)O\\(.\\{22\\}\\)@/O\\1!\\2 /
#--------------------------------------------------
s/\.\(.\{22\}\)O\(.\{22\}\)@/O\1!\2 /
		t zzset170
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr170
		:zzset170
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr170
#--------------------------------------------------
t x
# continue overdot with load
		i\
COMM:s/\\.\\(.\\{22\\}\\)O\\(.\\{22\\}\\)!/O\\1!\\2./
#--------------------------------------------------
s/\.\(.\{22\}\)O\(.\{22\}\)!/O\1!\2./
		t zzset171
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr171
		:zzset171
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr171
#--------------------------------------------------
t x
# out load overdot / enter overdot
		i\
COMM:s/ \\(.\\{22\\}\\)O\\(.\\{22\\}\\)@/o\\1!\\2 /
#--------------------------------------------------
s/ \(.\{22\}\)O\(.\{22\}\)@/o\1!\2 /
		t zzset172
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr172
		:zzset172
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr172
#--------------------------------------------------
t x
# out load overdot / continue overdot
		i\
COMM:s/ \\(.\\{22\\}\\)O\\(.\\{22\\}\\)!/o\\1!\\2./
#--------------------------------------------------
s/ \(.\{22\}\)O\(.\{22\}\)!/o\1!\2./
		t zzset173
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr173
		:zzset173
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr173
#--------------------------------------------------
t x
# out overdot with load
		i\
COMM:s/ \\(.\\{22\\}\\)o\\(.\\{22\\}\\)!/o\\1@\\2./
#--------------------------------------------------
s/ \(.\{22\}\)o\(.\{22\}\)!/o\1@\2./
		t zzset174
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr174
		:zzset174
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr174
#--------------------------------------------------
t x
# out overdot with load / enter overdot
		i\
COMM:s/\\.\\(.\\{22\\}\\)o\\(.\\{22\\}\\)!/O\\1@\\2./
#--------------------------------------------------
s/\.\(.\{22\}\)o\(.\{22\}\)!/O\1@\2./
		t zzset175
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		t zzclr175
		:zzset175
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t x

		:zzclr175
#--------------------------------------------------
t x
# target not free
		i\
COMM:b x
#--------------------------------------------------
b x
		i\
COMM:}
#--------------------------------------------------
}
# wrong command, do nothing
		i\
COMM:s/^.//
#--------------------------------------------------
s/^.//
		t zzset176
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:x

		t zzclr176
		:zzset176
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:x

		:zzclr176
#--------------------------------------------------
x
# ----------------[ THE END ]-----------------
		t zzset177
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM::x

		t zzclr177
		:zzset177
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM::x

		:zzclr177
#--------------------------------------------------
:x
# adding color codes
		i\
COMM:s/%/[46;36m&[m/g
#--------------------------------------------------
s/%/[46;36m&[m/g
		t zzset178
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/[!@]/[33;1m&[m/g

		t zzclr178
		:zzset178
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/[!@]/[33;1m&[m/g

		:zzclr178
#--------------------------------------------------
s/[!@]/[33;1m&[m/g
		t zzset179
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/O/[37;1m&[m/g

		t zzclr179
		:zzset179
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/O/[37;1m&[m/g

		:zzclr179
#--------------------------------------------------
s/O/[37;1m&[m/g
		t zzset180
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\./[31;1m&[m/g

		t zzclr180
		:zzset180
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\./[31;1m&[m/g

		:zzclr180
#--------------------------------------------------
s/\./[31;1m&[m/g
# uncomment this line if you DON'T want colorized output (why not?)
### s/\[[0-9;]*m//g
# update screen
		t zzset181
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:p

		t zzclr181
		:zzset181
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:p

		:zzclr181
#--------------------------------------------------
p
# removing color codes from maze
		t zzset182
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\[[0-9;]*m//g

		t zzclr182
		:zzset182
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\[[0-9;]*m//g

		:zzclr182
#--------------------------------------------------
s/\[[0-9;]*m//g
# no more messy boxes ('o'), level finished!
		t zzset183
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/%%%.*o.*%%%/ !{

		t zzclr183
		:zzset183
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/%%%.*o.*%%%/ !{

		:zzclr183
#--------------------------------------------------
/%%%.*o.*%%%/ !{
		i\
COMM:s/.*/[37;01m(( [31mV[32mI[33mC[34mT/
#--------------------------------------------------
s/.*/[37;01m(( [31mV[32mI[33mC[34mT/
		t zzset184
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/$/[31mO[32mR[33mY[34m![37m ))[m/

		t zzclr184
		:zzset184
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/$/[31mO[32mR[33mY[34m![37m ))[m/

		:zzclr184
#--------------------------------------------------
s/$/[31mO[32mR[33mY[34m![37m ))[m/
		t zzset185
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/$/                                                   /

		t zzclr185
		:zzset185
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/$/                                                   /

		:zzclr185
#--------------------------------------------------
s/$/                                                   /
# uncomment here if you DON'T want color or sound on victory
# s///g ; s/\[[0-9;]*m//g
		t zzset186
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:p

		t zzclr186
		:zzset186
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:p

		:zzclr186
#--------------------------------------------------
p
		t zzset187
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:i\\\\N  You're a master of this level. Try the next!

		t zzclr187
		:zzset187
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:i\\\\N  You're a master of this level. Try the next!

		:zzclr187
#--------------------------------------------------
i\
  You're a master of this level. Try the next!
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:q
#--------------------------------------------------
q
		t zzset188
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:}

		t zzclr188
		:zzset188
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:}

		:zzclr188
#--------------------------------------------------
}
# save current position on hold space
		i\
COMM:x
#--------------------------------------------------
x
# skipping loop
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:2 d
#--------------------------------------------------
2 d
# nice loop for accumulated moves
		t zzset189
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/./ {

		t zzclr189
		:zzset189
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/./ {

		:zzclr189
#--------------------------------------------------
/./ {
		i\
COMM:p
#--------------------------------------------------
p
		t zzset190
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b ini

		t zzclr190
		:zzset190
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b ini

		:zzclr190
#--------------------------------------------------
b ini
		i\
COMM:}
#--------------------------------------------------
}
# The End ;(
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x

# Debugged SED script generated by sedsed (http://aurelio.net/projects/sedsed/)
