function cc = chr_normf (bc)
cc=36;
if (bc>='0' && bc<='9') cc=bc-'0';
end
if (bc>='A' && bc<='Z') cc=bc-'A'+10;
end
if (bc>='a' && bc<='z') cc=bc-'a'+10;
end
if (bc==' ') cc=36;
end