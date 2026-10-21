clear; clc; close all;

%% 0. Hazirlik: basi bos uyarilar kapali, cizim dosyaya
warning("off", "all");
graphics_toolkit("gnuplot");
betik_dizini = fileparts(mfilename("fullpath"));
if isempty(betik_dizini); betik_dizini = pwd(); end
img_dizini = fullfile(betik_dizini, "assets", "img");
if ~exist(img_dizini, "dir"); mkdir(img_dizini); end

%% 1. Newton'un ikinci yasasi: F = m * a
m = 2;          % kutle (kg)
F = 10;         % net kuvvet (N)
a = F / m;      % ivme (m/s^2)
printf("[1] Newton II: F = %g N, m = %g kg -> a = F/m = %g m/s^2\n", F, m, a);

%% 2. Ikinci dereceden denklemi birinci derece sisteme cevir
% y(1) = konum x (m), y(2) = hiz v (m/s)
% dy(1)/dt = y(2)        (konumun turevi hizdir)
% dy(2)/dt = F/m         (hizin turevi ivmedir)
newton_ode = @(t, y) [y(2); F/m];
y0 = [0; 0];                 % [konum; hiz] baslangic kosulu
t_eval = 0:0.1:10;          % zaman vektoru (s)
printf("[2] durum vektoru y = [konum; hiz], y0 = [%g; %g], t = 0..%.0f s (%d nokta)\n", ...
       y0(1), y0(2), t_eval(end), numel(t_eval));

%% 3. ode45 ile sayisal cozum
[t, y] = ode45(newton_ode, t_eval, y0);
printf("[3] ode45: %d zaman noktasi dondurdu, adim %.2f s\n", numel(t), t(2) - t(1));

%% 4. Kapali cozumle karsilastir: x = a*t^2/2, v = a*t
konum_kapali = 0.5 * a * t.^2;
hiz_kapali   = a * t;
printf("[4] t (s)   konum (m)   hiz (m/s)   kapali konum   fark (m)\n");
for k = 1:20:numel(t)
  printf("    %5.1f   %9.4f   %9.4f   %12.4f   %.2e\n", ...
         t(k), y(k,1), y(k,2), konum_kapali(k), abs(y(k,1) - konum_kapali(k)));
end
printf("[4] en buyuk sapma: konum %.2e m, hiz %.2e m/s\n", ...
       max(abs(y(:,1) - konum_kapali)), max(abs(y(:,2) - hiz_kapali)));

%% 5. Konum ve hizi tek figurde iki panele yaz (basasiz: dosyaya)
f = figure("visible", "off"); graphics_toolkit(f, "gnuplot");
subplot(2, 1, 1);
plot(t, y(:,1), "b-", "LineWidth", 2); grid on;
xlabel("Zaman (s)"); ylabel("Konum (m)");
title("Newton'in ikinci yasasi: konum (ode45)");
subplot(2, 1, 2);
plot(t, y(:,2), "r--", "LineWidth", 2); grid on;
xlabel("Zaman (s)"); ylabel("Hiz (m/s)");
title("Newton'in ikinci yasasi: hiz (ode45)");
dosya = fullfile(img_dizini, "ode45_newton-hareket.png");
print(f, dosya, "-dpng", "-r110");
printf("[5] grafik: %s (%d bayt)\n", "ode45_newton-hareket.png", dir(dosya).bytes);

%% Ozet
printf("\nOzet: a = F/m = %g m/s^2 sabit ivme ile 10 s sonunda konum %.2f m,\n", a, y(end,1));
printf("      hiz %.2f m/s; ode45 cozumu kapali cozumle %.1e m icinde ortusuyor.\n", ...
       y(end,2), max(abs(y(:,1) - konum_kapali)));
