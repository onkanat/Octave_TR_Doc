clear; clc; close all;

%% 0. Hazirlik
warning("off", "all");
graphics_toolkit("gnuplot");
betik_dizini = fileparts(mfilename("fullpath"));
if isempty(betik_dizini); betik_dizini = pwd(); end
img_dizini = fullfile(betik_dizini, "assets", "img");
if ~exist(img_dizini, "dir"); mkdir(img_dizini); end

%% 1. Devre bilesenleri
R1 = 10;          % RC filtre direnci (ohm)
C1 = 1000e-6;     % RC filtre kondansatoru (F) = 1000 uF
L1 = 100e-6;      % LR filtre enduktansi (H) = 100 uH
R2 = 1;           % LR filtre direnci (ohm)
printf("[1] R1 = %g ohm, C1 = %g F, L1 = %g H, R2 = %g ohm\n", R1, C1, L1, R2);

%% 2. Frekans ekseni ve iki filtrenin transfer fonksiyonlari
f = logspace(1, 6, 1000);                     % 10 Hz - 1 MHz
H_rc = 1 ./ (1 + 1i*2*pi*f*R1*C1);            % H_RC = 1/(1 + j*w*R1*C1)
H_lr = 1 ./ (1 + 1i*2*pi*f*L1/R2);            % H_LR = 1/(1 + j*w*L1/R2)
H_total = H_rc .* H_lr;                       % seri iki filtre: carpim
printf("[2] %d frekans noktasi: %.0f Hz - %.0f Hz\n", numel(f), f(1), f(end));

%% 3. Kesim frekanslari (kose frekanslari)
fc_rc = 1 / (2*pi*R1*C1);
fc_lr = R2 / (2*pi*L1);
printf("[3] RC kesim frekansi: %.3f Hz\n", fc_rc);
printf("[3] LR kesim frekansi: %.3f Hz\n", fc_lr);

%% 4. Onemli frekanslarda olculen genlik ve faz
printf("[4] f (Hz)      |H| (dB)    faz (derece)\n");
for fq = [10, 100, 1000, 10000, 100000, 1000000]
  [~, idx] = min(abs(f - fq));
  printf("[4] %8.0f   %9.2f   %10.1f\n", f(idx), ...
         20*log10(abs(H_total(idx))), angle(H_total(idx))*180/pi);
end

%% 5. Toplam filtrenin -3 dB noktasi (genlik 1/sqrt(2) altina ilk dusus)
genlik_db = 20*log10(abs(H_total));
idx3 = find(genlik_db <= -3, 1, "first");
printf("[5] -3 dB noktasi: %.1f Hz (kazanc %.2f dB)\n", f(idx3), genlik_db(idx3));
printf("[5] DC kazanci: %.4f dB, 1 MHz kazanci: %.1f dB\n", ...
       genlik_db(1), genlik_db(end));

%% 6. Genlik ve faz cevabini tek figurde iki panele yaz
fig = figure("visible", "off"); graphics_toolkit(fig, "gnuplot");
subplot(2, 1, 1);
semilogx(f, genlik_db, "b-", "LineWidth", 1.5); grid on;
xlabel("Frekans (Hz)"); ylabel("Kazanc (dB)");
title("Guc kaynagi filtresi: genlik cevabi");
xlim([10, 1e6]); ylim([-100, 5]);
subplot(2, 1, 2);
semilogx(f, angle(H_total)*180/pi, "r-", "LineWidth", 1.5); grid on;
xlabel("Frekans (Hz)"); ylabel("Faz (derece)");
title("Guc kaynagi filtresi: faz cevabi");
xlim([10, 1e6]); ylim([-180, 0]);
dosya = fullfile(img_dizini, "power_supply-bode.png");
print(fig, dosya, "-dpng", "-r110");
printf("[6] grafik: %s (%d bayt)\n", "power_supply-bode.png", dir(dosya).bytes);

%% Ozet
printf("\nOzet: RC (%.1f Hz) ve LR (%.1f Hz) alcak geciren filtrelerin carpimi\n", fc_rc, fc_lr);
printf("      %.1f Hz uzerinde -3 dB'nin altina iniyor; 1 MHz'de faz %.0f derece.\n", ...
       f(idx3), angle(H_total(end))*180/pi);
