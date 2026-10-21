clear; clc; close all;

%% 0. Hazirlik: image paketi, tekrar uretilebilir sentetik goruntu
pkg load image;
rand("seed", 42);
randn("state", 42);

betik_dizini = fileparts(mfilename("fullpath"));
if isempty(betik_dizini); betik_dizini = pwd(); end
img_dizini = fullfile(betik_dizini, "assets", "img");
if ~exist(img_dizini, "dir"); mkdir(img_dizini); end

%% 1. Sentetik RGB goruntu: gradyan zemin + iki renkli dikdortgen + gurultu
H = 120; W = 160;
gradyan = repmat(linspace(0.15, 0.85, W), H, 1);
R = gradyan; G = gradyan; B = 0.9*gradyan;
R(20:60,  20:70) = 0.90; G(20:60,  20:70) = 0.20; B(20:60,  20:70) = 0.15;
R(70:105, 95:140) = 0.15; G(70:105, 95:140) = 0.75; B(70:105, 95:140) = 0.85;
img = cat(3, R, G, B);
img = min(max(img + 0.03*randn(H, W, 3), 0), 1);
printf("[1] goruntu: %d x %d x %d, tur %s\n", rows(img), columns(img), ...
       size(img, 3), class(img));

%% 2. Gri tonlama ve temel istatistik
gri = rgb2gray(img);
printf("[2] gri: %d x %d, en kucuk %.3f, en buyuk %.3f, ortalama %.3f\n", ...
       rows(gri), columns(gri), min(gri(:)), max(gri(:)), mean(gri(:)));

%% 3. Manipulasyon: yeniden boyutlandirma, dondurme, kirpma
kucuk    = imresize(img, 0.5);
dondur   = imrotate(img, 30);
kirp     = imcrop(img, [20, 20, 80, 60]);   % [x, y, genislik, yukseklik]
printf("[3] imresize 0.5 : %d x %d\n", rows(kucuk), columns(kucuk));
printf("[3] imrotate 30  : %d x %d\n", rows(dondur), columns(dondur));
printf("[3] imcrop       : %d x %d\n", rows(kirp), columns(kirp));

%% 4. Kenar tespiti ve histogram
kenar = edge(gri, "sobel");
printf("[4] sobel kenar  : %d piksel (%.1f%%)\n", nnz(kenar), ...
       100*nnz(kenar)/numel(gri));
[sayim, kutu] = imhist(gri);
[en_cok, yer] = max(sayim);
printf("[4] histogram    : %d kutu, en kalabalik kutu %.3f (parlaklik), %d piksel\n", ...
       numel(sayim), kutu(yer), en_cok);
printf("[4] histogram    : dolu kutu %d/%d, agirlik merkezi %.3f\n", ...
       nnz(sayim), numel(sayim), sum(kutu(:).*sayim(:))/sum(sayim));

%% 5. Dosyaya yaz, geri oku ve ayni mi diye dogrula
girdi_png = fullfile(img_dizini, "goruntu_isleme-girdi.png");
gri_png   = fullfile(img_dizini, "goruntu_isleme-gri.png");
kenar_png = fullfile(img_dizini, "goruntu_isleme-kenar.png");
% double goruntu [0,1] araliginda; PNG'ye 8 bit yazmak icin uint8'e cevrilir
imwrite(uint8(round(255*img)), girdi_png);
imwrite(uint8(round(255*gri)), gri_png);
imwrite(uint8(255*kenar), kenar_png);
geri = imread(girdi_png);
% PNG 8 bit saklar: double goruntu yazilirken 1/255 adimina yuvarlanir,
% bu yuzden birebir esitlik degil, en buyuk yuvarlama hatasi olculur.
fark = abs(double(geri)/255 - img);
printf("[5] goruntu_isleme-girdi.png : %d bayt, en buyuk 8-bit yuvarlama hatasi %.5f\n", ...
       dir(girdi_png).bytes, max(fark(:)));
printf("[5] goruntu_isleme-gri.png   : %d bayt\n", dir(gri_png).bytes);
printf("[5] goruntu_isleme-kenar.png : %d bayt\n", dir(kenar_png).bytes);

%% Ozet
printf("\nOzet: %d x %d RGB goruntu uzerinde rgb2gray, imresize, imrotate, imcrop,\n", H, W);
printf("      edge(sobel) ve imhist olculdu; 3 PNG dosyasi assets/img/ altina yazildi.\n");
