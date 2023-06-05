%parametros de uso
peso=1;

posicao_trilha=300/peso        %deslocamento max = 600 mm
angulo_base=pi/8
angulo_secundario=angulo_base*2
angulo_efetuador=pi/4
posicao_efetuador=60/peso     %deslocamento max = 100 mm


%Definicao dos parametros a partir de Denavit-Hartenberg
tetha0 = -pi/2;
d0=0/peso ;
a0=0/peso; 
alfa0=-pi/2;
rp0=1;

tetha1 = 0;
d1= posicao_trilha;
a1=0/peso; 
alfa1=pi/2;
rp1=1;

tetha2 = angulo_base;
d2= 300/peso;
a2=225/peso; 
alfa2=0;
rp2=0;

tetha3 = angulo_secundario;
d3= 10/peso;
a3=225/peso; 
alfa3=pi;
rp3=0;

tetha4 = angulo_efetuador; 
d4= 0/peso;
a4=0/peso; 
alfa4=0;
rp4=0;

tetha5 = 0;
d5= posicao_efetuador/peso;
a5=0/peso; 
alfa5=0;
rp5=1;

%cinematica direta geometrica

y_=-(cos(tetha2)*225+cos(tetha2+tetha3)*225)
x_=d1+(sin(tetha2)*225+sin(tetha2+tetha3)*225)
z_=d2+d3-d5

%Denavit-Hartenberg á mão
hb_0=[cos(tetha0),-sin(tetha0)*cos(alfa0),sin(alfa0)*sin(tetha0),a0*cos(tetha0);sin(tetha0),cos(tetha0)*cos(alfa0),-cos(tetha0)*sin(alfa0),a0*sin(tetha0);0,sin(alfa0),cos(alfa0),d0;0,0,0,1];
h0_1=[cos(tetha1),-sin(tetha1)*cos(alfa1),sin(alfa1)*sin(tetha1),a1*cos(tetha1);sin(tetha1),cos(tetha1)*cos(alfa1),-cos(tetha1)*sin(alfa1),a1*sin(tetha1);0,sin(alfa1),cos(alfa1),d1;0,0,0,1];
h1_2=[cos(tetha2),-sin(tetha2)*cos(alfa2),sin(alfa2)*sin(tetha2),a2*cos(tetha2);sin(tetha2),cos(tetha2)*cos(alfa2),-cos(tetha2)*sin(alfa2),a2*sin(tetha2);0,sin(alfa2),cos(alfa2),d2;0,0,0,1];
h2_3=[cos(tetha3),-sin(tetha3)*cos(alfa3),sin(alfa3)*sin(tetha3),a3*cos(tetha3);sin(tetha3),cos(tetha3)*cos(alfa3),-cos(tetha3)*sin(alfa3),a3*sin(tetha3);0,sin(alfa3),cos(alfa3),d3;0,0,0,1];
h3_4=[cos(tetha4),-sin(tetha4)*cos(alfa4),sin(alfa4)*sin(tetha4),a4*cos(tetha4);sin(tetha4),cos(tetha4)*cos(alfa4),-cos(tetha4)*sin(alfa4),a4*sin(tetha4);0,sin(alfa4),cos(alfa4),d4;0,0,0,1];
h4_5=[cos(tetha5),-sin(tetha5)*cos(alfa5),sin(alfa5)*sin(tetha5),a5*cos(tetha5);sin(tetha5),cos(tetha5)*cos(alfa5),-cos(tetha5)*sin(alfa5),a5*sin(tetha5);0,sin(alfa5),cos(alfa5),d5;0,0,0,1];

M_f=hb_0*h0_1*h1_2*h2_3*h3_4*h4_5

% cinematica inversa geometrica
z=z_
x=x_
y=y_

if(x<=600 && x>=0)
    posicao_trilha_=x
else
    if(x>600)
        posicao_trilha_=600
    else
        posicao_trilha_=0
    end    
end
angulo_base_=acos(((((x-posicao_trilha_)^2+y^2)^(1/2)))/(225*2) );
angulo_secundario_=2*angulo_base_
angulo_base_=-(angulo_base_+atan((x-posicao_trilha_)/y))
angulo_efetuador_=angulo_efetuador  %é nescessario?
posicao_efetuador_=(d2+d3-z)*peso     %dislocamento max = 100 mm

%Simulação em Matlab usando a toolbox robotics para verificar a modelagem manual.
L0 = Link([tetha0 ,d0,a0 ,alfa0,rp0]);% montagem do robo
L1 = Link([tetha1 ,d1,a1 ,alfa1,rp1]);% trilha que o robo é colocado em cima
L2 = Link([tetha2 ,d2,a2 ,alfa2,rp2]);% rotacao da base
L3 = Link([tetha3 ,d3,a3 ,alfa3,rp3]);% rotacao secundaria
L4 = Link([tetha4 ,d4,a4 ,alfa4,rp4]);% rotacao do efetuador final
L5 = Link([tetha5 ,d5,a5 ,alfa5,rp5]);% altura do efetuador final

work =[-5,12.5 -5,5 -0.5,4]*100/peso;
bot = SerialLink([L0 L1 L2 L3 L4 L5], 'name', 'Sinhôzin');
bot.fkine([d0 ,d1, tetha2, tetha3, tetha4 , d5])
bot.plot([d0 ,posicao_trilha_, angulo_base_, angulo_secundario_, angulo_efetuador_ , posicao_efetuador_],'workspace',work);

