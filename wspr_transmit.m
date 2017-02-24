%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Weak Signal Propagation Reporter (WSPR) Transmit Code        %
%      Refernece credit to Dr. Jonathon Y. Cheah (NZ0C)          %
%                   for the use of this code                     %
%           Ultra low baud rate communication study              %
%                                                                %
%               Consult www.wsprnet.org for details              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% clear all Matlab memory buffers
close all
clear all
clc

% user entries         ================== % call must have 6 letter 
                        call='NZ0C  '     % spaces for standard HAM
                         loc='DM12'        % Radio callsign.
                        power=30
%                      ==================



%
% process various callsign types  
if (chr_normf(call(3))>9)
        
        call(6)=call(5);
        call(5)=call(4);
        call(4)=call(3);
        call(3)=call(2);
        call(2)=call(1);
        call(1)=' ';
end

%
% pack callsign
n1=chr_normf(call(1));
n1=n1*36+chr_normf(call(2));
n1=n1*10+chr_normf(call(3));
n1=n1*27+chr_normf(call(4))-10;
n1=n1*27+chr_normf(call(5))-10;
n1=n1*27+chr_normf(call(6))-10;

%
% pack locator 
m1=179-10*(chr_normf(loc(1))-10)-chr_normf(loc(3));
m1=m1*180+10*(chr_normf(loc(2))-10)+chr_normf(loc(4));

%
% pack power dBm
m1=m1*128+power+64;

c(1)=bitsll(uint32(n1),4);
c(1)=c(1)+ bitand(15,bitsrl(uint32(m1),18));
c(2)=bitsll(uint32(m1),6);

%Turn c(1) and C(2) into HEX characters
H1=dec2hex(c(1));
H2=dec2hex(c(2));
if numel(H2)<6
    H2(2:6)=H2;
    H2(1)='0';
   h=strcat(H1(1:8),H2(1:6));
end
if numel(H2)==6
   h=strcat(H1(1:8),H2);
end
if numel(H2)>6
    h=strcat(H1(1:8),H2(2:7));
end

disp('Source-encoded message')
disp(h)

%
%To convolve with Polynomials
x{1}=dec2bin(hex2dec('F2D05351'));
x{2}=dec2bin(hex2dec('E4613C47'));
h= dec2bin(hex2dec(h));
m=length(x{1});
n=length(h);

%
%allocate memory
X(1,:)=[x{1},zeros(1,m)]; 
X(2,:)=[x{2},zeros(1,m)];
H=[h,zeros(1,(n+m))]; 

% create a temporary m-length register TH
% for h data stream
TH=zeros(1,m);

% create 2 output bit registers
Y(1,:)=zeros(1,(n+m));
Y(2,:)=zeros(1,(n+m));

% shifting H into TH
for i=1:m+n
      TH=[TH(2:end) 0];
    if str2num(H(i))>0
        TH(m)=1;
    else
        TH(m)=0;
    end
    
% got register TH with h a bit at a time
% AND TH with polynomials
  for k=1:2
    for j=1:m      
% sum the AND value and keeps count
         Y(k,i)=Y(k,i)+sum(str2num(X(k,j))& TH(j));
    end
% parity bit is 0 if the sum is even.
    Y(k,i)=mod(Y(k,i),2);
  end
end

% interlace the 2 polynomial outputs.
YI=zeros(1,2*(m+n));
YI(1:2:end)=Y(1,:);
YI(2:2:end)=Y(2,:);

%%%    for display purposes only. can be deleted %%          
disp(' ')                                         %
disp('FEC symbols in Hex')                        %
%This is just for the sake of a nice display      %
% needs a lot of twists and turns                 %
A=reshape(YI,8,length(YI)/8);                     %
A=A';                                             %
B=fliplr(A);                                      %
B=bi2de(B);                                       %
C=dec2hex(B);                                     %
C=C';                                             %
disp(C)                                           %
disp(' ')                                         %
disp('FEC Symbols in bin')                        %
yi=reshape(YI,8,length(YI)/8)';                   %
disp(yi)                                          %
%                                                %%

%interleave
sym=zeros(1,168); 
P=1;
I=0;
while P < 162
        J=bin2dec(fliplr(bin(fi(I,0,8,0))));
        if J<162
            sym(J+1)=YI(P);
            P=P+1;
        end
    I=I+1;
end

disp(' ')
disp('Interleave data')
SYM=reshape(sym,8,length(sym)/8)';
disp(SYM)

% add sync bits
  sync=textread('sync.dat','%u');

% Channel symbol with sync added.
smb=sync'+2*sym;

disp(' ') 
disp('Channel symbols')
ch=reshape(smb,8,length(smb)/8)';
disp(ch)

% The channel symbols in output
% This file is ready for wspr beacon implementation
fid=fopen('signal.dat','w');
fprintf(fid,'%i\n', smb);
fclose(fid);
