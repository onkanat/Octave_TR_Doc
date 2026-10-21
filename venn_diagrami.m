clear; clc; close all;

%% 0. Hazirlik: basasiz cizim, dosya yolu betigin yaninda
warning("off", "all");
graphics_toolkit("gnuplot");
betik_dizini = fileparts(mfilename("fullpath"));
if isempty(betik_dizini); betik_dizini = pwd(); end
img_dizini = fullfile(betik_dizini, "assets", "img");
if ~exist(img_dizini, "dir"); mkdir(img_dizini); end

%% 1. Uc daire: merkezler ve yaricap
merkezler = [0, 0; 2, 0; 1, 1];
yaricap = 2;
renkler = {"r", "g", "b"};
printf("[1] %d daire, yaricap r = %g\n", rows(merkezler), yaricap);
for i = 1:rows(merkezler)
  printf("[1]   daire %d: merkez (%.1f, %.1f), renk %s\n", ...
         i, merkezler(i,1), merkezler(i,2), renkler{i});
end

%% 2. Kesisim geometrisi: merkezler arasi uzaklik < 2r ise daireler kesisir
printf("[2] merkezler arasi uzakliklar (2r = %g):\n", 2*yaricap);
for i = 1:rows(merkezler)
  for j = i+1:rows(merkezler)
    d = norm(merkezler(i,:) - merkezler(j,:));
    printf("[2]   %d-%d: %.4f -> %s\n", i, j, d, ...
           merge(d < 2*yaricap, "kesisiyor", "kesismiyor"));
  end
end

%% 3. Cizim: rectangle + Curvature = [1 1] tam daire verir
f = figure("visible", "off"); graphics_toolkit(f, "gnuplot");
hold on;
for i = 1:rows(merkezler)
  x = merkezler(i,1); y = merkezler(i,2); r = yaricap;
  rectangle("Position", [x - r, y - r, 2*r, 2*r], ...
            "Curvature", [1, 1], "FaceColor", renkler{i}, "FaceAlpha", 0.5);
end
text(0, 0, " community ", "FontSize", 26, "Color", "w", ...
     "HorizontalAlignment", "center");
daspect([1, 1, 1]);
axis off;
hold off;
dosya = fullfile(img_dizini, "venn_diagrami.png");
print(f, dosya, "-dpng", "-r110");
printf("[3] grafik: %s (%d bayt)\n", "venn_diagrami.png", dir(dosya).bytes);

%% 4. Ortak alan: uc dairenin de kesisim bolgesinde kalan ornek noktalar
% Nokta izgarasi taranir; merkeze uzaklik <= r kosulu uc daire icin de dogruysa
% nokta ortak alandadir. Alan, izgara hucresi alaniyla carpilarak yaklasik bulunur.
adim = 0.02;
[X, Y] = meshgrid(-2.5:adim:4.5, -2.5:adim:3.5);
icinde = true(size(X));
for i = 1:rows(merkezler)
  icinde = icinde & ((X - merkezler(i,1)).^2 + (Y - merkezler(i,2)).^2 <= yaricap^2);
end
alan = sum(icinde(:)) * adim^2;
printf("[4] ortak alan (izgara, adim %.2f): %.4f birim^2, %d nokta\n", ...
       adim, alan, sum(icinde(:)));

%% Ozet
printf("\nOzet: uc daire (r = %g) cizildi; hepsi ciftler halinde kesisiyor ve\n", yaricap);
printf("      ortak alan yaklasik %.3f birim^2. Grafik assets/img/venn_diagrami.png.\n", alan);
