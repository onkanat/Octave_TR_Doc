clear; clc; close all;
1;

%% 0. Hazirlik: yerel fonksiyonlar kullanimdan once tanimlanir
% Octave (ve MATLAB) 1-tabanli indeksleme kullanir: ilk eleman dizi(1).
warning("off", "all");

%% Yerel fonksiyonlar
function sigma = hesapla_gerilme(M, c, I)
  % Egilme gerilmesi: sigma = M * c / I  (Pa)
  sigma = (M * c) / I;
end

function R_es = direnc_hesapla(direncler, tip)
  % Seri: toplam, paralel: harmonik toplam
  if strcmp(tip, "seri")
    R_es = sum(direncler);
  elseif strcmp(tip, "paralel")
    R_es = 1 / sum(1 ./ direncler);
  else
    error("Hatali tip: \"seri\" veya \"paralel\" giriniz.");
  end
end

%% 11. Maksimum egilme gerilmesi
moment = 12e3;      % N*m
mesafe = 0.15;      % m (tarafsiz eksene uzaklik)
atalet = 8.5e-6;    % m^4
max_gerilme = hesapla_gerilme(moment, mesafe, atalet);
printf("[11] egilme gerilmesi: M = %g Nm, c = %g m, I = %g m^4\n", moment, mesafe, atalet);
printf("[11]   sigma = M*c/I = %.2f Pa = %.2f MPa\n", max_gerilme, max_gerilme/1e6);

%% 12. Reynolds sayisi ve akis rejimi
rho = 1000;     % kg/m^3 (su)
mu = 0.001;     % Pa.s
D = 0.05;       % m (boru capi)
printf("[12] Reynolds: rho = %g kg/m^3, mu = %g Pa.s, D = %g m\n", rho, mu, D);
for v = [0.02, 0.05, 1.2]
  Re = (rho * v * D) / mu;
  if Re < 2300
    rejim = "LAMINER";
  elseif Re >= 2300 && Re <= 4000
    rejim = "GECIS BOLGESI";
  else
    rejim = "TURBULANSLI";
  end
  printf("[12]   v = %.2f m/s -> Re = %8.1f -> %s\n", v, Re, rejim);
end

%% 13. Esdeger direnc: seri ve paralel
R_liste = [100, 220, 330];     % ohm
printf("[13] direncler: %s ohm\n", mat2str(R_liste));
printf("[13]   seri esdeger   : %.2f ohm\n", direnc_hesapla(R_liste, "seri"));
printf("[13]   paralel esdeger: %.2f ohm\n", direnc_hesapla(R_liste, "paralel"));

%% 14. ADC simulasyonu: 0-5 V -> 10 bit (0-1023)
rand("seed", 42);
ornek_sayisi = 10;
adc_sonuclari = zeros(1, ornek_sayisi);
printf("[14] ADC: %d ornek, 0-5 V -> 0-1023 (10 bit)\n", ornek_sayisi);
for i = 1:ornek_sayisi
  analog_V = rand() * 5;
  dijital_deger = round((analog_V / 5) * 1023);
  adc_sonuclari(i) = dijital_deger;
  printf("[14]   ornek %2d: analog = %.4f V, dijital = %4d\n", i, analog_V, dijital_deger);
end
printf("[14]   min = %d, max = %d, ortalama = %.1f (1 tabanli dizi: adc(1) = %d)\n", ...
       min(adc_sonuclari), max(adc_sonuclari), mean(adc_sonuclari), adc_sonuclari(1));

%% 15. Newton-Raphson: x^3 - 5x + 1 = 0
f  = @(x) x^3 - 5*x + 1;
df = @(x) 3*x^2 - 5;
x = 2.0;
tol = 1e-6;
max_iter = 20;
printf("[15] Newton-Raphson: f(x) = x^3 - 5x + 1, x0 = %.1f, tol = %g\n", x, tol);
for i = 1:max_iter
  h = f(x) / df(x);
  x = x - h;
  printf("[15]   iterasyon %2d: x = %.10f, |h| = %.2e\n", i, x, abs(h));
  if abs(h) < tol
    break;
  end
end
printf("[15]   bulunan kok: %.10f (%d iterasyonda), f(x) = %.2e\n", x, i, f(x));

%% Ozet
printf("\nOzet: sigma = %.2f MPa, Re = %.0f (v = 1.2 m/s), R_seri = %.1f ohm,\n", ...
       max_gerilme/1e6, (rho*1.2*D)/mu, direnc_hesapla(R_liste, "seri"));
printf("      %d ADC ornegi ve x^3 - 5x + 1 denkleminin koku %.10f olculdu.\n", ...
       ornek_sayisi, x);
