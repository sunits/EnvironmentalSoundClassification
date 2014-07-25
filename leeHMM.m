
%[P,M,V]=leeHMM(modelo)

function [P,M,V]=leeHMM(modelo)

MAXGAUS=20000;
MAXC=100;

P=zeros(MAXGAUS,1);
M=zeros(MAXGAUS,MAXC);
V=zeros(MAXGAUS,MAXC);
G=zeros(MAXGAUS,1);

Ng=0;
Nc=0;

f=fopen(modelo);

linea=fgets(f);
while( length(linea)>2 )


  linea=upper(fliplr(deblank(fliplr(linea))));

  if((length(linea)>9) && strcmp(linea(1:9),'<MIXTURE>'))
    Ng=Ng+1;
    p=sscanf(linea(10:length(linea)),'%d %f');
    P(Ng)=p(2);
  end

  if((length(linea)>6) && strcmp(linea(1:6),'<MEAN>'))
    Nc=sscanf(linea(7:length(linea)),'%d',1);
    linea=fgets(f);
    linea=upper(fliplr(deblank(fliplr(linea))));
    M(Ng,1:Nc)=sscanf(linea,'%f',Nc)';
  end

  if((length(linea)>10) && strcmp(linea(1:10),'<VARIANCE>') && (Ng>0))
    Nc=sscanf(linea(11:length(linea)),'%d',1);
    linea=fgets(f);
    linea=upper(fliplr(deblank(fliplr(linea))));
    V(Ng,1:Nc)=sscanf(linea,'%f',Nc)';
  end

 if((length(linea)>8) && strcmp(linea(1:8),'<GCONST>'))
    G(Ng)=sscanf(linea(9:length(linea)),'%f',1);
  end

  linea=fgets(f);
end

fclose(f);
P=P(1:Ng);
M=M(1:Ng,1:Nc);
V=V(1:Ng,1:Nc);
G=G(1:Ng);

