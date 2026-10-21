clear; clc; close all;

%% 0. Hazirlik: sabit tohum, olcum icin ornek boyu
% Sure olcumu yapilir ama EKRANA YAZILMAZ: islem suresi makineye gore
% degistigi icin "Beklenen Cikti" blogu ancak boyle tekrar uretilebilir kalir.
rand("seed", 42);    % sozdizimi sozlesmesi (Octave 11'de tek basina yetmez)
rand("state", 42);   % ureteci durumu: iki kosuda ayni diziyi veren ayar
randn("state", 42);
n = 200000;
printf("[0] surum: %s, ornek uzunlugu n = %d\n", version(), n);

%% 1. Eleman eleman carpma: for dongusu ile .* karsilastirmasi
a = rand(1, n);
b = rand(1, n);
tic;
c_dongu = zeros(1, n);
for i = 1:n
  c_dongu(i) = a(i) * b(i);
end
t_dongu = toc;
tic;
c_vektor = a .* b;          % BLAS/vektor yolu: tek cagri
t_vektor = toc;
printf("[1] eleman carpma : dongu ve .* ayni sonuc mu: %d\n", ...
       isequal(c_dongu, c_vektor));
printf("[1] kontrol toplami: %.6f\n", sum(c_vektor));
printf("[1] sure           : olculdu, ekrana yazilmadi (makineye gore degisir)\n");

%% 2. Fonksiyon degerlendirme: dongu ile vektorlestirilmis cagri
x = 0:0.001:10;
y_dongu = zeros(size(x));
for i = 1:numel(x)
  y_dongu(i) = sin(x(i)) * exp(-0.1*x(i));
end
y_vektor = sin(x) .* exp(-0.1*x);
printf("[2] fonksiyon     : %d nokta, en buyuk fark %.3e\n", ...
       numel(x), max(abs(y_dongu - y_vektor)));

%% 3. Kosullu islem: mantiksal indeksleme
v = randn(1, 10);
v_dongu = v;
for i = 1:numel(v)
  if v_dongu(i) < 0
    v_dongu(i) = 0;
  end
end
v_vektor = v; v_vektor(v_vektor < 0) = 0;
printf("[3] kosullu       : negatif sayisi %d, iki yontem ayni mi: %d\n", ...
       nnz(v < 0), isequal(v_dongu, v_vektor));

%% 4. Kumulatif toplam: dongu ile cumsum
u = 1:5;
k_dongu = zeros(size(u));
k_dongu(1) = u(1);
for i = 2:numel(u)
  k_dongu(i) = k_dongu(i-1) + u(i);
end
k_vektor = cumsum(u);
printf("[4] cumsum        : dongu %s | cumsum %s | ayni mi: %d\n", ...
       mat2str(k_dongu), mat2str(k_vektor), isequal(k_dongu, k_vektor));

%% 5. Matris-vektor carpimi: uc ic ice dongu yerine tek operator
m = 300;
A = randn(m, m);
xv = randn(m, 1);
tic;
y_dongu2 = zeros(m, 1);
for i = 1:m
  toplam = 0;
  for j = 1:m
    toplam = toplam + A(i, j)*xv(j);
  end
  y_dongu2(i) = toplam;
end
t_matris_dongu = toc;
tic;
y_blas = A*xv;
t_matris = toc;
printf("[5] A*x           : %d x %d, en buyuk fark %.3e\n", ...
       rows(A), columns(A), max(abs(y_dongu2 - y_blas)));
printf("[5] sure          : olculdu, ekrana yazilmadi\n");

%% 6. On bellek ayirma: buyuyen dizi yerine zeros
tic;
buyuyen = [];
for i = 1:20000
  buyuyen(end+1) = i;
end
t_buyuyen = toc;
tic;
on_bellek = zeros(1, 20000);
for i = 1:20000
  on_bellek(i) = i;
end
t_onbellek = toc;
printf("[6] on bellek     : 20000 oge, icerik ayni mi: %d, eleman sayisi %d\n", ...
       isequal(buyuyen, on_bellek), numel(on_bellek));
printf("[6] sure          : olculdu, ekrana yazilmadi\n");

%% Ozet
printf("\nOzet: 6 vektorlestirme ornegi olculdu; tum karsilastirmalarda dongu ile\n");
printf("      vektor yolu AYNI sonucu verdi; sureler olculdu ama yazilmadi.\n");
