clear; clc; close all;

%% 0. Hazirlik: ornek girdiler betigin icinde (input() yok)
warning("off", "all");

%% 1. Faktoriyel: dongu ile ve yerlesik fonksiyonla
n = 7;
faktoriyel = 1;
for i = 1:n
  faktoriyel = faktoriyel * i;
end
printf("[1] %d! = %d (dongu), factorial(%d) = %d, esitlik: %d\n", ...
       n, faktoriyel, n, factorial(n), faktoriyel == factorial(n));

%% 2. Ikinci derece denklem: a*x^2 + b*x + c = 0
a = 1; b = -3; c = 2;
delta = b^2 - 4*a*c;
printf("[2] denklem: %gx^2 + (%g)x + (%g) = 0, diskriminant = %.2f\n", a, b, c, delta);
if delta > 0
  printf("[2] iki farkli reel kok vardir: x1 = %.4f, x2 = %.4f\n", ...
         (-b + sqrt(delta))/(2*a), (-b - sqrt(delta))/(2*a));
elseif delta == 0
  printf("[2] cakisik (tek) reel kok vardir: x = %.4f\n", -b/(2*a));
else
  printf("[2] reel kok yoktur (karmasik kokler)\n");
end

%% 3. Aritmetik ortalama: 0 gelene kadar sayan do-until dongusu
% Etkilesimli surumde her turda input() okunur; burada ayni akis bir
% vektor uzerinden surulur, dongu yapisi degismeden kalir.
girisler = [4, 8, 15, 16, 23, 42, 0];   % 0 = durdurucu
toplam = 0;
sayac = 0;
k = 0;
do
  k = k + 1;
  sayi = girisler(k);
  if sayi ~= 0
    toplam = toplam + sayi;
    sayac = sayac + 1;
  end
until (sayi == 0)
if sayac > 0
  ortalama = toplam / sayac;
  printf("[3] %d sayinin ortalamasi: %.4f (toplam %d)\n", sayac, ortalama, toplam);
else
  printf("[3] hic sayi girilmedi\n");
end

%% 4. Taylor serisi ile e^x (ilk 10 terim)
x = 1.5;
yaklasik_e = 0;
for m = 0:9
  terim = (x^m) / factorial(m);
  yaklasik_e = yaklasik_e + terim;
end
printf("[4] e^%.2f (10 terim) = %.6f\n", x, yaklasik_e);
printf("[4] exp(%.2f)         = %.6f\n", x, exp(x));
printf("[4] bagil hata        = %.3e\n", abs(yaklasik_e - exp(x))/exp(x));

%% 5. Matris carpimi: ic ice dongu ile ve operator ile
A = [1, 2, 3; 4, 5, 6; 7, 8, 9];
B = [9, 8, 7; 6, 5, 4; 3, 2, 1];
C = zeros(3, 3);
for i = 1:3
  for j = 1:3
    for kk = 1:3
      C(i,j) = C(i,j) + A(i,kk) * B(kk,j);
    end
  end
end
printf("[5] A * B (dongu ile):\n");
disp(C);
printf("[5] A * B (operator) :\n");
disp(A * B);
printf("[5] iki sonuc arasindaki en buyuk fark: %g\n", max(max(abs(C - A*B))));

%% Ozet
printf("\nOzet: faktoriyel %d!, diskriminant %.2f, ortalama %.4f, e^%.2f ~ %.6f,\n", ...
       n, delta, ortalama, x, yaklasik_e);
printf("      dongu ile matris carpimi operator sonucuyla birebir ayni.\n");
