  % Power Supply Analysis                                                                                
clear; clc;                                                                                            
                                                                                                       
% Component values                                                                                     
R1 = 10;          % RC filter resistance (ohm)                                                         
C1 = 1000e-6;     % RC filter capacitance (F)                                                          
L1 = 100e-6;      % LR filter inductance (H)                                                           
R2 = 1;           % LR filter resistance (ohm)                                                         
                                                                                                       
% Frequency range                                                                                      
f = logspace(1, 6, 1000);  % 10Hz to 1MHz                                                              
                                                                                                       
% RC filter transfer function                                                                          
H_rc = 1 ./ (1 + 1i*2*pi*f*R1*C1);                                                                     
                                                                                                         
% LR filter transfer function                                                                          
H_lr = 1 ./ (1 + 1i*2*pi*f*L1/R2);                                                                     
                                                                                                         
% Combined filter response                                                                             
H_total = H_rc .* H_lr;                                                                                
                                                                                                         
% Plot magnitude response                                                                              
figure;                                                                                                
semilogx(f, 20*log10(abs(H_total)));                                                                   
grid on;                                                                                               
xlabel('Frequency (Hz)');                                                                              
ylabel('Gain (dB)');                                                                                   
title('Power Supply Filter Response');                                                                 
xlim([10, 1e6]);                                                                                       
ylim([-100, 0]);                                                                                       
                                                                                                         
% Plot phase response                                                                                  
figure;                                                                                               
semilogx(f, angle(H_total)*180/pi);                                                                   
grid on;                                                                                               
xlabel('Frequency (Hz)');                                                                              
ylabel('Phase (degrees)');                                                                             
title('Power Supply Filter Phase Response');                                                          
xlim([10, 1e6]);                                                                                       
ylim([-180, 0]);  