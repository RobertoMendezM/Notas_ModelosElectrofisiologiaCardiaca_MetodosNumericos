%{
             PROGRAMA UsaNoble.m 
 USANDO  ode45, ode23 y ode15s,  SE RESUELVE EL SISTEMA DE 
 ECUACIONES DIFERENCIALES ORDINARIAS  DEL MODELO DE NOBLE,
 QUE SE ESPECIFICAN EN LA FUNCIÓN
                    Noble1962_v2.m
  Y  SE GRAFICAN ALGUNOS RESULTADOS.

  Las funciones ode regresan un vector de la forma
  [T, Y], siendo:          
  T : vector columna de tiempos
  Y : matriz de dimensión length(T)x4 donde cada columna 
     representa las siguientes variables 
                [m , h , n, V] 
      
 Autor:  ROBERTO MÉNDEZ MÉNDEZ
                   
 Última revisión: 7 Sep 24
%}
close all
clear
clc
% Intervalo de tiempo
t = [0 1000];
% Valores iniciales
x = [.01 0.8 .01  -87];

%%  Solución con ode45
tic
[T,Y] = ode45(@Noble1962_v2,t,x);
elapsedTimeOde45 = toc;
lrk = length(T)-1;
numpasosRK = num2str(lrk);

% Tamaño de paso fijo k= 0.31 (sin corrección de error) que induce error 
% con ode23 ode45 y ode113 ; "Correcto" con: ode78, ode89, ode23tb
% Con ode45 pareciera ser correcto aunque no lo es.
k2=.31;
options = odeset('MaxStep', k2, 'InitialStep', k2, ...
           'AbsTol', 10^6,'Refine', 1);
[Tf,Yf] = ode45(@Noble1962_v2,t,x,options);
numpasoRK45e = length(Tf)-1;
numpasosRK45fe = num2str(numpasoRK45e);

% Tamaño de paso fijo k=.3 y evitando corrección de error

k=.3;
options = odeset('MaxStep', k, 'InitialStep', k, ...
         'AbsTol',10^6,'Refine', 1); 
tic
[Tf2,Yf2] = ode45(@Noble1962_v2,t,x,options);
elapsedTimeOde45p3 = toc;
lRK45f2 = length(Tf2)-1;
numpasosRK45f = num2str(lRK45f2);

% Tamaño de paso fijo k=0.0023 y evitando corrección de error

k3=.0023;
options = odeset('MaxStep', k3, 'InitialStep', k3, ...
         'AbsTol',10^6,'Refine', 1);   
[Tf3,Yf3] = ode45(@Noble1962,t,x,options);
lRK45f1 = length(Tf3)-1;
numpasosRK45f2 = num2str(lRK45f1);


%%  Solución con ode23
tic
[T23,Y23] = ode23(@Noble1962_v2,t,x);
elapsedTimeOde23 = toc;
lrk23 = length(T23)-1;
numpasos23 = num2str(lrk23);

%% Solución con ode113

tic
[T113,Y113] = ode113(@Noble1962_v2,t,x);
elapsedTimeOde113 = toc;
 l113 = length(T113)-1;
 numpasos113 = num2str(l113);



%% Solución con ode15s

tic
[T2,Y2] = ode15s(@Noble1962_v2,t,x);
elapsedTimeOde15s = toc;
 lrig = length(T2)-1;
 numpasosRIG = num2str(lrig);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     GRÁFICAS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Comparativa del potencial de acción
%  calculado con ode15s y ode45 de paso libre y fijo 

figure('NumberTitle','off','FileName', ...
       'c4Noble_PA_ode15sode45', 'Name', ...
       'Noble Potencial de Acción Comparativo', ...
       'Position', [60 , 220,550,420])
plot(T,Y(:,4),T2,Y2(:,4),Tf2,Yf2(:,4))
strleg = ['ode45 k = ', num2str(k)];
legend('ode45','ode15s', strleg,'Location','North')
xlabel('tiempo (ms)')
ylabel('V_m (mV)')



%% Para ode45 

% Potencial de acción, k=.31 fijo con error
figure('NumberTitle','off','FileName', 'c4Noble_PA_ode45f',...
       'Name', 'Noble Potencial de Acción  k fijo', 'Position', ...
       [190 , 220, 550,420])
plot(Tf(:),Yf(:,4))
legend(['ode45,  k = ' num2str(k2)])
xlrk = {'tiempo (ms)'};    
xlabel(xlrk)
ylabel('V_m (mV)')
text(360,0.92 ,['Num. de Pasos = ',  numpasosRK45fe ])


% Compuertas, k irrestricto
figure('NumberTitle','off', 'Name', 'Noble Compuertas con ode45', ...
       'FileName','c4Noble_Compuertas_ode45', 'Position', ...
       [320 , 220, 550,420])
plot(T,Y(:,1),'.',T,Y(:,2),'.',T,Y(:,3),'.')
ylim([0, 1])
legend('m','h','n')
xlabel('tiempo (ms)')
ylabel('Valor')
text(375,0.92 ,['Num. de Pasos = ',  numpasosRK])



%% ode113

% Compuertas m ,n, h
figure('NumberTitle','off', 'Name', 'Noble Compuertas ode113', ...
       'FileName', 'c4Noble_Compuertas_ode113','Position', ...
       [450 , 220, 550,420])
plot(T113,Y113(:,1),'.',T113,Y113(:,2),'.',T113,Y113(:,3),'.')
legend('m','h','n')
xlabel('tiempo (ms)')
ylabel('Valor')
text(375,0.92 ,['Num. de Pasos = ',  numpasos113])


%% ode15s

% Compuertas m ,n, h
figure('NumberTitle','off', 'Name', 'Noble Compuertas ode15s', ...
       'FileName', 'c4Noble_Compuertas_ode15s','Position', ...
       [570 , 220, 550,420])
plot(T2,Y2(:,1),'.',T2,Y2(:,2),'.',T2,Y2(:,3),'.')
legend('m','h','n')
xlabel('tiempo (ms)')
ylabel('Valor')
text(375,0.92 ,['Num. de Pasos = ',  numpasosRIG])