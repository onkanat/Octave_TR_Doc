clear; clc; close all;
1;

%% 0. Hazirlik
warning("off", "all");

%% Yerel fonksiyonlar: parametreli yay denklemi ve cebirsel degisken
function sprime = spring(s, t, k)
  % s(1) = konum, s(2) = hiz; k yay sabiti parametredir
  x = s(1); v = s(2);
  sprime(1) = v;
  sprime(2) = -k * x;
end

function [sprime, y] = dspring(s, t)
  % Durum turevleri + turev olmayan cebirsel degisken y
  k = 1; tau = 1;
  x = s(1); v = s(2);
  y = x + v * tau;
  sprime(1) = v;
  sprime(2) = -k * y;
end

%% 1. Dize karakterleriyle kombinasyonlar (nchoosek)
dize = "Merhaba";
n = 4;
kombinasyonlar = char(nchoosek(uint8(dize), n));
printf("[1] \"%s\" icinden %d karakter: %d kombinasyon\n", dize, n, rows(kombinasyonlar));
for i = 1:3
  printf("[1]   %s\n", kombinasyonlar(i, :));
end

%% 2. Tekrarli permutasyonlar (ndgrid)
[x, y, z] = ndgrid([1, 2, 3]);
ucay = [x(:), y(:), z(:)];
printf("[2] ndgrid ile %d uclu (%dx%dx%d)\n", rows(ucay), 3, 3, 3);
printf("[2]   ilk 5: %s\n", mat2str(ucay(1:5, :)));
printf("[2]   son 2: %s\n", mat2str(ucay(end-1:end, :)));

%% 3. Tam sayi ve parite testleri
degerler = [4, 7, 3.5];
printf("[3] tam sayi testi fix(x) == x: %s\n", mat2str(fix(degerler) == degerler));
printf("[3] mod(x, 2) (tek -> 1):       %s\n", mat2str(mod(degerler, 2)));
printf("[3] any(mod(x,2)) = %d, all(mod(x,2)) = %d\n", ...
       any(mod(degerler, 2)), all(mod(degerler, 2)));
printf("[3] negatif sayida mod: mod(-3, 2) = %d (rem(-3, 2) = %d)\n", ...
       mod(-3, 2), rem(-3, 2));

%% 4. Parametreli fonksiyon ailesi: lsode ile iki yay sabiti
t = linspace(0, 10, 100);
for k = [1, 2]
  xk = lsode(@(s, tt) spring(s, tt, k), [1; 0], t)(:, 1);
  printf("[4] k = %d: x(0) = %.4f, x(10) = %+.4f, periyot 2*pi/sqrt(k) = %.4f s\n", ...
         k, xk(1), xk(end), 2*pi/sqrt(k));
end
printf("[4] ayni fonksiyon ailesi, iki parametre: tek tanim, iki cozum\n");

%% 5. Noktalar arasindaki mesafe (yayin ozelligi ile)
P = [0, 0; 3, 4; 6, 0];      % her satir bir nokta, her sutun bir bilesen
[m, nn] = size(P);
Dsq = zeros(m);
for i = 1:nn
  Dsq += (P(:, i) - P(:, i)').^2;
end
printf("[5] %d nokta, %d bilesen; kare mesafe matrisi:\n", m, nn);
disp(Dsq);
printf("[5] uzaklik matrisi:\n");
disp(sqrt(Dsq));

%% 6. ODE durum degiskenlerinden cebirsel degisken tablosu
x_tab = lsode(@dspring, [1; 0], t);
y_tab = zeros(length(t), 1);
for i = 1:length(t)
  [xtmp, y_tab(i, 1)] = dspring(x_tab(i, :), t(i));
end
printf("[6] cebirsel degisken y = x + v*tau, dspring'in 2. cikisi ile tablo:\n");
for i = [1, 25, 50, 75, 100]
  printf("[6]   t = %5.2f  x = %+.4f  v = %+.4f  y = %+.4f\n", ...
         t(i), x_tab(i,1), x_tab(i,2), y_tab(i));
end

%% Ozet
printf("\nOzet: %d kombinasyon, %d uclu permutasyon, iki parametreli yay cozumu,\n", ...
       rows(kombinasyonlar), rows(ucay));
printf("      %dx%d mesafe matrisi ve cebirsel degisken tablosu olculdu.\n", m, m);
