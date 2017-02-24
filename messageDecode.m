function message= messageDecode(data0)
space=' ';
blank='   ';

% unpack the message code into n1 for callsign and n2 for locator & power
      for j=1:length(data0)
         if (data0(j)< 0) 
             data0(j)=data0(j)+256;
         end
      end
      i=data0(1);
      i4=bitand(i,255);
      n1=bitshift(i4,20);
      i=data0(2);
      i4=bitand(i,255);
      n1=n1 + bitshift(i4,12);
      i=data0(3);
      i4=bitand(i,255);
      n1=n1 + bitshift(i4,4);
      i=data0(4);
      i4=bitand(i,255);
      n1=n1 + bitand(bitshift(i4,-4),15);
      n2=bitshift(bitand(i4,15),18);
      i=data0(5);
      i4=bitand(i,255);
      n2=n2 + bitshift(i4,10);
      i=data0(6);
      i4=bitand(i,255);
      n2=n2 + bitshift(i4,2);
      i=data0(7);
      i4=bitand(i,255);
      n2=n2 + bitand(bitshift(i4,-6),3);


%
%unpack n1 for callsign
      c ='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ ';
      callsign='      ';
      
%Plain text message ...
      if(n1>262177560)
          return          
      else
        i=mod(n1,27)+11;
        callsign(6)=c(i);
        n1=n1/27;
        i=floor(mod(n1,27)+11);
        callsign(5)=c(i);
        n1=n1/27;
        i=floor(mod(n1,27)+11);
        callsign(4)=c(i);
        n1=n1/27;
        i=floor(mod(n1,10)+1);
        callsign(3)=c(i);
        n1=n1/10;
        i=floor(mod(n1,36)+1);
        callsign(2)=c(i);
        n1=n1/36;
        i=floor(n1+1);
        callsign(1)=c(i);
      end

% unpack n2 for locator (Transmit uses maidenhead-> log,lat)
%                       (Receive reverses long,lat -> maidenhead)
          ng=n2/128;
          dlat=mod(ng,180)-90;
          dlong=-(ng/180)*2 - 180;        
          if(dlong<-180.0)
             dlong=dlong+360.0;
          end
          if(dlong>180.0)
             dlong=dlong-360.0;
          end
          nlong=60.0*(180+dlong)/5.0;
          na=floor(nlong/240);                     
          nb=floor((nlong-240*na)/24 );            
          grid(1)=char(double('A')+na) ;    
          grid(3)=char(double('0')+nb);
          nlat=60.0*(dlat+90)/2.5;
          na=floor(nlat/240) ;                     
          nb=floor((nlat-240*na)/24) ;              
          grid(2)=char(double('A')+na);
          grid(4)=char(double('0')+nb);
          
% unpack n2 for power
    ntype=bitand(n2,127)-64;
    
% Standard WSPR power message (types 0 3 7 10 13 17 ... 60)
 if(ntype>0 && ntype < 62)
    nu=mod(ntype,10);   
    if(nu==0 || nu==3 || nu==7)
        pwr=num2str(ntype);  
        [~,i1]=sscanf(callsign,'%c');
        message=strcat(callsign(1:i1),{space},grid,{space},pwr);       
    else
        [~,i2]=sscanf(callsign,' ');
        message=strcat(callsign(1:i2),blank);    
    end
 end
end

