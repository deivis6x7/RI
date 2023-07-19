continua=true;

while continua;
x0=input("Insira x atual aqui:");
y0=input("Insira Y atual aqui:");
mod0=sqrt(x0^2+y0^2);
while mod0>16 ;
        x0=input("Insira x atual valido aqui:");
        y0=input("Insira Y atual valido aqui:");
        mod0=sqrt(x0^2+y0^2);
end
yf=input("Insira Y final aqui:");
xf=input("Insira x final aqui:");
mod1=sqrt(xf^2+yf^2);
while  mod1>16;
        yf=input("Insira Y final valido aqui:");
        xf=input("Insira x final valido aqui:");
        mod1=sqrt(xf^2+yf^2);
end


proporcao_a=2*pi/2038;
tam=8;
metodo_errado=true;



angulo_base=acos(((((x0)^2+y0^2)^(1/2)))/(tam*2) );
angulo01=rad2deg(2*angulo_base);
angulo00=rad2deg(-(angulo_base-atan2(y0,x0)));

angulo_base=acos(((((xf)^2+yf^2)^(1/2)))/(tam*2) );
angulof1=rad2deg(2*angulo_base);
angulof=rad2deg(-(angulo_base-atan2(yf,xf)));

while metodo_errado;
    metodo=input("0-sair.\n1-um braco depois o outro.\n2-ambos com mesma velocidade.\n3-velocidades proporcionais.\n4-linha reta. \nEscreva o numero do metodo a ser utilizado:");
    if metodo==0||metodo==1||metodo==2||metodo==3||metodo==4
        metodo_errado=false;
    end    
end
if metodo==0;
    break
end
metodo_errado=true;
while metodo_errado;
    verbose=input("0-com simulacao .\n1-sem simulacao.\nEscreva o numero caso queira o robotics:");
    if verbose==0||verbose==1
        metodo_errado=false;
    end    
end
delete(instrfind);
arduino=serial("COM3");%ver se da erro
fopen(arduino);

tf=0.5;
tf1=0.5;


proporcao=abs(angulof1-angulo01)/abs(angulof-angulo00);
%calculo das variaveis para a suavisacao 




%caso for fazer o plot do grafico é recomendado alterar o valo

%theta - d - a -alfa

work =[-7,7 -7,7 -1,7]*3;
%definicao das variaveis por DH
theta0 =  deg2rad(angulof);
d0=0 ;
alfa0=0;
rp0=0;

theta1 = deg2rad(angulof1);
d1=0 ;
alfa1=0;
rp1=0;
% definicao do robo no robotics
L0 = Link([theta0 ,d0,tam ,alfa0,rp0]);
L1 = Link([theta1 ,d1,tam ,alfa1,rp1]);
bot = SerialLink([L0 L1], 'name', 'Klebinho');
bot.fkine([theta0, theta1]);

%simulacao no robotics 
t = 0:0.01:tf;

if metodo~=4;
theta0=deg2rad(angulo00);
thetaf=deg2rad(angulof);
A=[1 0 0 0; 1 tf tf^2 tf^3;0 1 0 0; 0 1 2*tf 3*tf^2];
B=[theta0 ; thetaf ; 0 ; 0];
x=inv(A)*B;
a0=x(1);
a1=x(2);
a2=x(3);
a3=x(4);
end


theta0=deg2rad(angulo01);
thetaf=deg2rad(angulof1);
if metodo~=2;
A1=[1 0 0 0; 1 tf tf^2 tf^3;0 1 0 0; 0 1 2*tf 3*tf^2];
B1=[theta0 ; thetaf ; 0 ; 0];
x1=inv(A1)*B1;
b0=x1(1);
b1=x1(2);
b2=x1(3);
b3=x1(4);
else
tf1=proporcao*tf;
A1=[1 0 0 0; 1 tf1 tf1^2 tf1^3;0 1 0 0; 0 1 2*tf1 3*tf1^2];
B1=[theta0 ; thetaf ; 0 ; 0];
x1=inv(A1)*B1;
b0=x1(1);
b1=x1(2);
b2=x1(3);
b3=x1(4);
end




if metodo~=4
    
if metodo==2
t1 = 0:0.01:tf1;
angulo1 = a0+a1*t+a2*t.^2+a3*t.^3 ;
angulo2 = b0+b1*t1+b2*t1.^2+b3*t1.^3;
A=angulo1/proporcao_a;
B=angulo2/proporcao_a;
logic=size(t)>=size(t1);
if logic(2)
    valor=tf;
else
    valor=tf1;
end
valor=valor*100;
if verbose==0;
for  i=1:1:valor;
    if logic(2)
        if t(i)<tf1;
            bot.plot([angulo1(i) angulo2(i) ],'workspace',work);
        else
            bot.plot([angulo1(i) deg2rad(angulof1) ],'workspace',work);
        end
    else
        if t1(i)<(tf);
            bot.plot([angulo1(i) angulo2(i) ],'workspace',work);
        else
            bot.plot([deg2rad(angulof)  angulo2(i)],'workspace',work);
        end
    end
end
end
go=true;
formatSpec = '%d %d\n';
fprintf(arduino,formatSpec,[0,0])
%h=fscanf(arduino,'%s')
pause(2);
tamanho=valor;
sinal_a=0;
previus_a=A(1);
passos_a=0;
previus_b=B(1);
passos_b=0;
sinal_b=0;  
pause(3)

    

for  i=1:1:valor;
    if logic(2)
        if t(i)<tf1;
    if(abs(abs(A(i))-abs(previus_a))>=1)
        passos_a=round(abs(abs(A(i))-abs(previus_a)));
        if(A(i)>previus_a)
            sinal_a=1;
        else
            sinal_a=-1;
        end
        passos_a=passos_a*sinal_a
        previus_a=passos_a+previus_a;
    end
    if(abs(abs(B(i))-abs(previus_b))>=1)
        passos_b=round(abs(abs(B(i))-abs(previus_b)));
        if(B(i)>previus_b)
            sinal_b=1;
        else
            sinal_b=-1;
        end
        passos_b=passos_b*sinal_b
        previus_b=passos_b+previus_b;
    end
    fprintf(arduino,formatSpec,[passos_a,-passos_b]);
    passos_a=0;
    passos_b=0;
    h=fscanf(arduino,'%s');
        else
    if(abs(abs(A(i))-abs(previus_a))>=1)
        passos_a=round(abs(abs(A(i))-abs(previus_a)));
        if(A(i)>previus_a)
            sinal_a=1;
        else
            sinal_a=-1;
        end
        passos_a=passos_a*sinal_a
        previus_a=passos_a+previus_a;
    end
    fprintf(arduino,formatSpec,[passos_a,0]);
    passos_a=0;
    h=fscanf(arduino,'%s');
        end
    else
        if t1(i)<(tf);
    if(abs(abs(A(i))-abs(previus_a))>=1)
        passos_a=round(abs(abs(A(i))-abs(previus_a)));
        if(A(i)>previus_a)
            sinal_a=1;
        else
            sinal_a=-1;
        end
        passos_a=passos_a*sinal_a
        previus_a=passos_a+previus_a;
    end
    if(abs(abs(B(i))-abs(previus_b))>=1)
        passos_b=round(abs(abs(B(i))-abs(previus_b)));
        if(B(i)>previus_b)
            sinal_b=1;
        else
            sinal_b=-1;
        end
        passos_b=passos_b*sinal_b
        previus_b=passos_b+previus_b;
    end
    fprintf(arduino,formatSpec,[passos_a,-passos_b]);
    passos_a=0;
    passos_b=0;
    h=fscanf(arduino,'%s');
        else
    if(abs(abs(B(i))-abs(previus_b))>=1)
        passos_b=round(abs(abs(B(i))-abs(previus_b)));
        if(B(i)>previus_b)
            sinal_b=1;
        else
            sinal_b=-1;
        end
        passos_b=passos_b*sinal_b
        previus_b=passos_b+previus_b;
    end
    fprintf(arduino,formatSpec,[0,-passos_b]);
    passos_b=0;
    h=fscanf(arduino,'%s');
        end
    end
end
else




angulo1 = a0+a1*t+a2*t.^2+a3*t.^3;
angulo2 = b0+b1*t+b2*t.^2+b3*t.^3;
if verbose==0;
if metodo==3
for  i=1:1:100*tf;
    bot.plot([angulo1(i) angulo2(i) ],'workspace',work);
    %bot.teach
end
else
    for  i=1:1:100*tf;
    bot.plot([angulo1(i) angulo2(1) ],'workspace',work);
    %bot.teach
    end
    lasy=i
    for  i=1:1:100*tf;
    bot.plot([angulo1(lasy) angulo2(i) ],'workspace',work);
    %bot.teach
    end
end
end

A=angulo1/proporcao_a;
B=angulo2/proporcao_a;
go=true;
y=0;
formatSpec = '%d %d\n';
fprintf(arduino,formatSpec,[0,0])
%h=fscanf(arduino,'%s')
pause(2);
tamanho=size(A);
sinal_a=0;
previus_a=A(1);
passos_a=0;
previus_b=B(1);
passos_b=0;
sinal_b=0;  
pause(3)
if(metodo==3)
while go
    y=y+1;
    if(abs(abs(A(y))-abs(previus_a))>=1)
        passos_a=round(abs(abs(A(y))-abs(previus_a)));
        if(A(y)>previus_a)
            sinal_a=1;
        else
            sinal_a=-1;
        end
        passos_a=passos_a*sinal_a;
        previus_a=passos_a+previus_a;
    end
    if(abs(abs(B(y))-abs(previus_b))>=1)
        passos_b=round(abs(abs(B(y))-abs(previus_b)));
        if(B(y)>previus_b)
            sinal_b=1;
        else
            sinal_b=-1;
        end
        passos_b=passos_b*sinal_b;
        previus_b=passos_b+previus_b;
    end
    fprintf(arduino,formatSpec,[passos_a,-passos_b]);
    passos_a=0;
    passos_b=0;
    h=fscanf(arduino,'%s');
    %h=fscanf(arduino,'%s')
    if y==tamanho(2)
    	go=false;
    end
end
else
while go
    y=y+1;
    if(abs(abs(A(y))-abs(previus_a))>=1)
        passos_a=round(abs(abs(A(y))-abs(previus_a)));
        if(A(y)>previus_a)
            sinal_a=1;
        else
            sinal_a=-1;
        end
        passos_a=passos_a*sinal_a;
        previus_a=passos_a+previus_a;
    end
    fprintf(arduino,formatSpec,[passos_a,0]);
    passos_a=0;
    h=fscanf(arduino,'%s');
    %h=fscanf(arduino,'%s')
    if y==tamanho(2)
    	go=false;
    end
end
go=true;
y=0;
tamanho=size(B);
previus_b=B(1);
passos_b=0;
sinal_b=0;  
pause(3)
    while go
    y=y+1;
    if(abs(abs(B(y))-abs(previus_b))>=1)
        passos_b=round(abs(abs(B(y))-abs(previus_b)));
        if(B(y)>previus_b)
            sinal_b=1;
        else
            sinal_b=-1;
        end
        passos_b=passos_b*sinal_b;
        previus_b=passos_b+previus_b;
    end
    fprintf(arduino,formatSpec,[0,-passos_b]);
    passos_b=0;
    h=fscanf(arduino,'%s');
    if y==tamanho(2)
    	go=false;
    end
    end
end
end

else
    x2=linspace(x0,xf,100*tf);
    y2=linspace(y0,yf,100*tf);
    mod=sqrt(x2.^2+y2.^2);
    go=true;
    y=0;
    i=1;
    anguloa=(atan2(y2(i),x2(i)))-(acos(mod(i)/(tam*2)));
    angulob=2*(acos(mod(i)/(tam*2)));
    A=anguloa/proporcao_a
    B=angulob/proporcao_a
    formatSpec = '%d %d\n';
    fprintf(arduino,formatSpec,[0,0])
    %h=fscanf(arduino,'%s')
    sinal_a=0;
    previus_a=A;
    passos_a=0;
    previus_b=B;
    passos_b=0;
    sinal_b=0;  
    if verbose==0;
    for i=1:1:100*tf;
    anguloa=(atan2(y2(i),x2(i)))-(acos(mod(i)/(tam*2)));
    angulofa=2*(acos(mod(i)/(tam*2)));
    bot.plot([anguloa angulofa],'workspace',work);
    %bot.teach
    end
    end
    for i=1:1:100*tf;
    anguloa=(atan2(y2(i),x2(i)))-(acos(mod(i)/(tam*2)));
    angulob=2*(acos(mod(i)/(tam*2)));
    A=anguloa/proporcao_a;
    B=angulob/proporcao_a;
    if(abs(abs(A)-abs(previus_a))>=1)
        passos_a=round(abs(abs(A)-abs(previus_a)));
        if(A>previus_a)
            sinal_a=1;
        else
            sinal_a=-1;
        end
        passos_a=passos_a*sinal_a;
        previus_a=passos_a+previus_a;
    end
    if(abs(abs(B)-abs(previus_b))>=1)
        passos_b=round(abs(abs(B)-abs(previus_b)));
        if(B>previus_b)
            sinal_b=1;
        else
            sinal_b=-1;
        end
        passos_b=passos_b*sinal_b;
        previus_b=passos_b+previus_b;
    end
    fprintf(arduino,formatSpec,[passos_a,-passos_b]);
    passos_a=0;
    passos_b=0;
    h=fscanf(arduino,'%s');
end
end
fclose(arduino);
end
