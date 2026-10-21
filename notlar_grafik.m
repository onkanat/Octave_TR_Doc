clear; clc; close all;

%% 0. Hazirlik
warning("off", "all");
graphics_toolkit("gnuplot");
betik_dizini = fileparts(mfilename("fullpath"));
if isempty(betik_dizini); betik_dizini = pwd(); end
veri_dizini = fullfile(betik_dizini, "assets", "veri");
img_dizini = fullfile(betik_dizini, "assets", "img");
if ~exist(veri_dizini, "dir"); mkdir(veri_dizini); end
if ~exist(img_dizini, "dir"); mkdir(img_dizini); end

%% 1. Eslesen ogeleri tek printf ile yazdirma (hucre dizisi)
anahtarlar = {"insan", "fare", "tavuk"};
degerler = [64, 72, 70];
degerler_hucre = num2cell(degerler);
yeni = {anahtarlar{:}; degerler_hucre{:}};
printf("[1] eslesen degerler (hucre + printf):\n");
printf("Hesaplanan %s genom GC icerigi %i%%\n", yeni{:});

%% 2. Takas: gecici degisken olmadan deal
a = 1; b = 2;
[b, a] = deal(a, b);
printf("[2] deal ile takas: a = %d, b = %d\n", a, b);

%% 3. Fonksiyonun tum cikti argumanlarini toplama (nthargout)
function [a1, b1, c1] = uc_deger()
  [a1, b1, c1] = deal(1, 2, 3);
end
outargs = nthargout(1:3, @uc_deger);
printf("[3] nthargout ile toplanan cikti: %s (cell icinde %d oge)\n", ...
       mat2str(cell2mat(outargs)), numel(outargs));

%% 4. fprintf ile metin tablosu
Metin = {"Merhaba", "Dunya"; "Octave", "notlari"};
printf("[4] fprintf ile hizalanmis tablo (15 karakter):\n");
for k = 1:rows(Metin)
  fprintf("%15.15s | %15.15s\n", Metin{k, 1}, Metin{k, 2});
end

%% 5. CSV dosyasi: yaz, geri oku, karsilastir
M = [1, 2.5, 3; 4, 5.5, 6; 7, 8.5, 9];
csv_dosya = fullfile(veri_dizini, "ornek_tablo.csv");
csvwrite(csv_dosya, M);
M_okunan = csvread(csv_dosya);
kolon1 = textread(csv_dosya, "%d", "delimiter", ",");
printf("[5] CSV: %s yazildi (%d bayt)\n", "assets/veri/ornek_tablo.csv", dir(csv_dosya).bytes);
printf("[5]   csvread ile boyut %s, en buyuk fark %g\n", ...
       mat2str(size(M_okunan)), max(max(abs(M_okunan - M))));
printf("[5]   textread ile okunan %d deger, ilk 6: %s\n", ...
       numel(kolon1), mat2str(kolon1(1:6)'));
printf("[5]   csvwrite yalniz sayisal veri yazar; karisik tur icin IO paketindeki csv2cell gerekir\n");

%% 6. Degisken dizesini efsane olarak kullanma (grafik)
x = linspace(-1, 3, 100);
y = sin(x);
dataName = "Verilerim";
% Nottaki eski yontem: plot(x, y, "-1;ad;") — gnuplot efsane sozdizimi.
% Bu Octave surumunde plot() bunu cizgi ozelligi sanip hata veriyor; olculdu:
try
  f0 = figure("visible", "off"); graphics_toolkit(f0, "gnuplot");
  plot(x, y, sprintf("-1;%s;", dataName));
  printf("[6] \"-1;ad;\" efsane yontemi: calisti\n");
catch e
  printf("[6] \"-1;ad;\" efsane yontemi DESTEKLENMIYOR -> %s\n", e.message);
end
close all;
% Bu surumde gecerli yol: cizimden sonra legend() cagrisi
f = figure("visible", "off"); graphics_toolkit(f, "gnuplot");
h = plot(x, y, "LineWidth", 1.5);
legend(h, sprintf("%s: sin(x)", dataName));
grid on; xlabel("x"); ylabel("sin(x)");
title(sprintf("%s: sin(x) egrisi", dataName));
dosya = fullfile(img_dizini, "notlar_grafik-efsane.png");
print(f, dosya, "-dpng", "-r110");
printf("[6] grafik: %s (%d bayt), efsane metni degiskenden geldi\n", ...
       "notlar_grafik-efsane.png", dir(dosya).bytes);

%% Ozet
printf("\nOzet: %d eslesen deger, deal takasi, nthargout (%d cikti), %dx%d tablo,\n", ...
       numel(degerler), numel(outargs), rows(Metin), columns(Metin));
printf("      CSV gidis-donus (fark %g) ve dinamik efsaneli grafik olculdu.\n", ...
       max(max(abs(M_okunan - M))));
