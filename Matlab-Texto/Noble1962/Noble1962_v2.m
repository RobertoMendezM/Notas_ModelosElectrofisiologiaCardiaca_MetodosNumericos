%{
              FUNCIÓN Noble1962
 IMPLEMENTACIÓN DEL MODELO DE NOBLE 1962 para ser resuelto
  con algún método numérico de Matlab

Referencias:
   https://models.cellml.org/e/2a6/noble_1962.cellml/view


Modelo a Programar:
 
  dn/dt = alpha_n(1 − n) − beta_n*n
  dh/dt = alpha_h(1 − h) − beta_h*h
  dm/dt = alpha_m(1 − m) − beta_m*m
  dV/dt = -(I_Na + i_K + I_L)/Cm
   
 

FUNCIÓN PROGRAMADA 
 La función  Noble1962(t,x) consta de dos parámetros t,x
                (t,x)
 donde
   t es el intervalo de tiempo 
   x = [n0 h0 m0 V0] es el vector de valores iniciales
  
  Interpretación de los x(i)
   x(1)  valores de n calculados usando  dn/dt
   x(2)  valores de h calculados usando  dh/dt
   x(3)  valores de m calculados usando  dm/dt
   x(4)  valores de V calculados usando  dV/dt  el Potencial de Membrana 

 Autores: ROBERTO MÉNDEZ MÉNDEZ
 
 Última revisión: 9 Sep 2024 v4

 Matlab 2024a
%}

function dydt = Noble1962_v2(t,x)

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %Capacitancia de la membrana 
  %%%%%%%%%%%%%%%%%%%%%%%%%%%

    Cm = 12;

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %  Cálculo de alfas y betas
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    alfa_n = 0.0001*( - x(4) - 50)/(exp((- x(4) - 50)/10) - 1);
    beta_n = 0.002 * exp((- x(4) - 90)/80);
    alfa_m = 0.1*(- x(4) - 48)/(exp((- x(4) - 48)/15) - 1);
    beta_m = 0.12*(x(4) + 8)/( exp((x(4) + 8)/5) - 1); 
    alfa_h = 0.17*exp((-x(4) - 90)/ 20);
    beta_h = 1/( exp((- x(4) - 42)/ 10) + 1);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %  Corriente de Potasio K
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%

    g_K1 = 1.2*exp((- x(4)- 90)/50) + 0.015*exp((x(4) + 90)/60);
    g_K2 = 1.2*(x(1))^4;

    I_K = (g_K1 + g_K2)*(x(4) + 100 );

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %   Corriente de Sodio Na
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    g_Na = 400*(x(3))^3*x(2);
    g_C  = .14;

    I_Na = (g_Na + g_C)*(x(4) - 40 );

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %  Corriente Extra
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    g_L = 0.075;
    I_L = g_L * (x(4) + 60);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %   Ecuaciones diferenciales
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    dydt = [ alfa_n*(1 - x(1)) - beta_n*x(1);...
            alfa_h*(1 - x(2)) - beta_h*x(2);...
            alfa_m*(1 - x(3)) - beta_m*x(3);...
            -(I_K + I_Na + I_L)/Cm];