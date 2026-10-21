clear; clc; close all;

%% 0. Hazirlik: tekrar uretilebilir gurultu, basi bos cizim
% Gurultu rastgele oldugu icin tohum sabitlenir; iki kosu ayni ciktiyi verir.
% Octave'de rand("seed") yalniz rand'i etkiler, randn'in durumu ayri tutulur.
rand("seed", 42);    % sozdizimi sozlesmesi (Octave 11'de tek basina yetmez)
rand("state", 42);   % ureteci durumu: iki kosuda ayni diziyi veren ayar
randn("state", 42);
warning("off", "all");   % basi bos kosuda fltk/gnuplot toolkit uyarilari
graphics_toolkit("gnuplot");

betik_dizini = fileparts(mfilename("fullpath"));
if isempty(betik_dizini); betik_dizini = pwd(); end
img_dizini = fullfile(betik_dizini, "assets", "img");
if ~exist(img_dizini, "dir"); mkdir(img_dizini); end

%% 1. Sinyal: 50 Hz + 120 Hz bilesenleri ve gurultu
Fs = 1000;               % ornekleme frekansi (Hz)
L  = 1500;               % ornek sayisi
t  = (0:L-1)/Fs;         % zaman vektoru (s)
temiz = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t);
X = temiz + 2*randn(size(t));
printf("[1] sinyal: %d ornek, Fs = %d Hz, sure = %.2f s\n", L, Fs, t(end));

%% 2. Tek tarafli genlik spektrumu (fft)
Y  = fft(X);
P2 = abs(Y/L);
P1 = P2(1:floor(L/2)+1);
P1(2:end-1) = 2*P1(2:end-1);          % tek tarafli spektrum olcegi
f  = Fs*(0:floor(L/2))/L;            % frekans ekseni (Hz)
% Zirveler: komsularindan buyuk olan yerel maksimumlar, 0.4 esiginin uzerinde
% (gurultu tabani ~0.2 genlikte; esik sinyal bilesenlerini ayirir)
aday = find(P1(2:end-1) > P1(1:end-2) & P1(2:end-1) > P1(3:end) ...
            & P1(2:end-1) > 0.4) + 1;
[~, sira] = sort(P1(aday), "descend");
zirve = aday(sira);
printf("[2] spektrum: %d frekans cubugu, cozunurluk %.3f Hz\n", numel(f), Fs/L);
for k = 1:numel(zirve)
  printf("[2] zirve %d: %.2f Hz, genlik %.3f\n", k, f(zirve(k)), P1(zirve(k)));
end

%% 3. FIR alcak geciren filtre: pencerelenmis sinc (cekirdek, paket gerekmez)
% signal paketindeki butter/cheby1 tasariminin esdegeri: kirpilmis sinc
% durtu yanitina Hamming penceresi uygulanir, kazanc 1'e normalize edilir.
Fc = 150; N = 101;
M  = (N-1)/2;
n  = -M:M;
b  = 2*Fc/Fs * sinc(2*Fc/Fs * n) .* hamming(N)';
b  = b / sum(b);
printf("[3] filtre: %d katsayi, kesim %.0f Hz, gecikme %d ornek\n", N, Fc, M);
printf("[3] b[1..3] = %s, b(merkez) = %.4f\n", ...
       num2str(b(1:3), "%.4f "), b(M+1));

%% 4. Filtreyi uygula ve gurultu azalmasini olc
y_filtre = filter(b, 1, X);
y_hizali = y_filtre(M+1:end);        % grup gecikmesi kadar kaydir
referans = temiz(1:end-M);
rms_temiz   = sqrt(mean(temiz.^2));
rms_gurultu = sqrt(mean((X - temiz).^2));
rms_kalan   = sqrt(mean((y_hizali - referans).^2));
printf("[4] RMS temiz sinyal      : %.4f\n", rms_temiz);
printf("[4] RMS gurultu bileseni  : %.4f\n", rms_gurultu);
printf("[4] RMS kalan hata        : %.4f\n", rms_kalan);
printf("[4] gurultu azalma        : %.1f dB\n", ...
       20*log10(rms_gurultu/rms_kalan));

%% 5. Olculen uc egriyi dosyaya yaz (gorunmez pencere, gnuplot)
f1 = figure("visible", "off"); graphics_toolkit(f1, "gnuplot");
subplot(3, 1, 1);
plot(t(1:300), temiz(1:300), "b-", t(1:300), X(1:300), "r-");
axis([0 t(300) -3.5 3.5]); grid on;
xlabel("t (s)"); ylabel("genlik"); title("temiz ve gurultulu sinyal (ilk 300 ornek)");
subplot(3, 1, 2);
plot(f, P1, "k-"); axis([0 250 0 1.2]); grid on;
xlabel("f (Hz)"); ylabel("|P1(f)|"); title("tek tarafli genlik spektrumu");
subplot(3, 1, 3);
plot(t(1:300), referans(1:300), "b-", t(1:300), y_hizali(1:300), "g-");
axis([0 t(300) -3.5 3.5]); grid on;
xlabel("t (s)"); ylabel("genlik"); title("filtrelenmis sinyal ve referans");
png = fullfile(img_dizini, "sinyal_isleme-analiz.png");
print(f1, png, "-dpng", "-r110");
printf("[5] grafik: %s (%d bayt)\n", "sinyal_isleme-analiz.png", ...
       dir(png).bytes);

%% Ozet
printf("\nOzet: %.0f Hz ve %.0f Hz bilesenleri fft ile bulundu; %d katsayili\n", ...
       f(zirve(1)), f(zirve(2)), N);
printf("      FIR alcak geciren filtre gurultuyu %.1f dB azaltti.\n", ...
       20*log10(rms_gurultu/rms_kalan));
