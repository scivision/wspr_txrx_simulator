% Maidenhead locators are letters+numerals grid squares designators  %
% covering the Earth used by Amatuer Radio Operators.                %
%                                                                    %

% User Entry: Longitude & Latitude
% For Del Mar, San Diego, USA:
%                             ============
                              dlong=-117.238;
                              dlat=   32.930;
%                             =============
 if(dlong<-180.0)
     dlong=dlong+360.0;
 end
 if(dlong>180.0)
     dlong=dlong-360.0;
 end
 %  Convert to units of 5 min of longitude, working east from 180 deg.
 % nlong=60.0*(180.0-dlong)/5.0;
 nlong=60.0*(180+dlong)/5.0;
 n1=floor(nlong/240);                     %20-degree field
 n2=floor((nlong-240*n1)/24 );             %2 degree square
 n3=floor(nlong-240*n1-24*n2);             %5 minute subsquare
 grid(1)=char(double('A')+n1) ;     %double - string to ASCII, char - ASCII 
                                    %to number
 grid(3)=char(double('0')+n2);
 grid(5)=char(double('a')+n3);
 
 %  Convert to units of 2.5 min of latitude, working north from -90 deg.
 nlat=60.0*(dlat+90)/2.5;
 n1=floor(nlat/240) ;                      %10-degree field
 n2=floor((nlat-240*n1)/24) ;              %1 degree square
 n3=floor(nlat-240*n1-24*n2) ;             %2.5 minuts subsquare
 grid(2)=char(double('A')+n1);
 grid(4)=char(double('0')+n2);
 grid(6)=char(double('a')+n3);
 disp ('maidenhead is:')
 disp(grid);
