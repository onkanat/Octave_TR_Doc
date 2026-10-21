clear; clc; close all;

%% 0. Hazirlik: ornek girdiler betigin icinde (input() yok)
warning("off", "all");
graphics_toolkit("gnuplot");
betik_dizini = fileparts(mfilename("fullpath"));
if isempty(betik_dizini); betik_dizini = pwd(); end
veri_dizini = fullfile(betik_dizini, "assets", "veri");
if ~exist(veri_dizini, "dir"); mkdir(veri_dizini); end

%% 6. Serbest dusme: v = g*t, h = g*t^2/2
G_IVME = 9.81;          % yercekimi ivmesi (m/s^2), sabit
t = 3.5;                % dusus suresi (s) -- ornek girdi
v = G_IVME * t;
h = 0.5 * G_IVME * t^2;
printf("[6] serbest dusme: t = %.2f s\n", t);
printf("[6]   hiz            : %.2f m/s\n", v);
printf("[6]   dusus mesafesi : %.2f m\n", h);

%% 7. Ideal gaz yasasi: P*V = n*R*T (uclu yon de hesaplanir)
R = 0.0821;             % gaz sabiti (L*atm / mol*K)
n = 1;                  % mol
V = 22.4;               % L
T = 273.15;             % K
P = (n * R * T) / V;
printf("[7] ideal gaz: n = %g mol, V = %.1f L, T = %.2f K\n", n, V, T);
printf("[7]   P = nRT/V = %.4f atm\n", P);
printf("[7]   ters yon  : V = nRT/P = %.4f L, T = PV/(nR) = %.4f K\n", ...
       (n*R*T)/P, (P*V)/(n*R));

%% 8. Egik atis: menzil ve maksimum yukseklik
v0 = 45;                % ilk hiz (m/s)
derece = 40;            % firlatma acisi (derece)
radyan = derece * (pi / 180);
g = 9.81;
menzil = (v0^2 * sin(2*radyan)) / g;
max_h  = (v0^2 * sin(radyan)^2) / (2*g);
printf("[8] egik atis: v0 = %g m/s, aci = %g derece (%.4f rad)\n", v0, derece, radyan);
printf("[8]   menzil            : %.2f m\n", menzil);
printf("[8]   maksimum yukseklik: %.2f m\n", max_h);

%% 9. Coulomb yasasi: F = k*|q1*q2|/r^2
k = 8.99e9;             % Coulomb sabiti (N*m^2/C^2)
q1 = 2e-6;              % C
q2 = 3e-6;              % C
r  = 0.35;              % m
F_coulomb = k * (abs(q1 * q2) / r^2);
printf("[9] Coulomb: q1 = %.1e C, q2 = %.1e C, r = %.2f m\n", q1, q2, r);
printf("[9]   F = %.4e N (%s)\n", F_coulomb, ...
       merge(abs(q1*q2) > 0 && q1*q2 > 0, "itme", "cekim"));

%% 10. Basit harmonik hareket: x(t) = A*cos(omega*t) dongu ile dosyaya
A = 0.5;                % genlik (m)
omega = 2.0;            % acisal hiz (rad/s)
t_son = 10;             % bitis suresi (s)
dt = 0.1;               % zaman adimi
dosya = fullfile(veri_dizini, "sarkac.txt");
fid = fopen(dosya, "w");
if (fid == -1); error("sarkac.txt yazilamadi"); end
fprintf(fid, "Zaman(s)   Konum(m)\n");
fprintf(fid, "------------------\n");
satir = 0;
for tt = 0:dt:t_son
  x = A * cos(omega * tt);
  fprintf(fid, "%-10.2f %-10.4f\n", tt, x);
  satir = satir + 1;
end
fclose(fid);
printf("[10] harmonik hareket: A = %.2f m, omega = %.2f rad/s, periyot = %.4f s\n", ...
       A, omega, 2*pi/omega);
printf("[10]   %s: %d veri satiri yazildi (basliklar dahil %d satir)\n", ...
       "assets/veri/sarkac.txt", satir, satir + 2);
printf("[10]   ilk ornek t = 0.00 -> x = %.4f m, son ornek t = %.2f -> x = %.4f m\n", ...
       A*cos(omega*0), t_son, A*cos(omega*t_son));

%% Ozet
printf("\nOzet: bes fizik problemi (serbest dusme, ideal gaz, egik atis, Coulomb,\n");
printf("      harmonik hareket) sabit ornek girdilerle olculdu; hicbiri input() beklemez.\n");
