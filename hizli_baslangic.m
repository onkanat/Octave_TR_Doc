clear; clc; close all;

%% 1. Temel matematiksel işlemler
% Octave basit bir hesap makinesi gibi kullanılabilir.
toplama  = 2 + 3;
cikarma  = 8 - 4;
carpma   = 5 * 2;
bolme    = 10 / 2;
us_alma  = 2^3;
karekok  = sqrt(16);

printf("%-10s %s\n", "Islem", "Sonuc");
printf("%-10s %g\n", "2 + 3",  toplama);
printf("%-10s %g\n", "8 - 4",  cikarma);
printf("%-10s %g\n", "5 * 2",  carpma);
printf("%-10s %g\n", "10 / 2", bolme);
printf("%-10s %g\n", "2^3",    us_alma);
printf("%-10s %g\n", "sqrt(16)", karekok);

%% 2. Değişkenler
x = 10;
y = 5;
z = x * y;
printf("\nz = x * y = %d\n", z);

%% 3. Vektör ve matris oluşturma
satir_vektor  = [1, 2, 3, 4, 5];
sutun_vektor  = [1; 2; 3; 4; 5];
A = [1, 2, 3; 4, 5, 6];

printf("\nSatir vektor boyutu : %d x %d\n", rows(satir_vektor), columns(satir_vektor));
printf("Sutun vektor boyutu : %d x %d\n", rows(sutun_vektor), columns(sutun_vektor));
printf("A matrisi boyutu    : %d x %d\n", rows(A), columns(A));
disp(A)

%% 4. Özel matrisler
S = zeros(3, 2);
B = ones(4, 5);
I = eye(5);

printf("\nzeros(3,2) boyutu : %d x %d, tum elemanlar sifir mi: %d\n", ...
       rows(S), columns(S), all(S(:) == 0));
printf("ones(4,5)  boyutu : %d x %d, tum elemanlar bir mi : %d\n", ...
       rows(B), columns(B), all(B(:) == 1));
printf("eye(5)     izi    : %d (birim matrisin izi boyutuna esittir)\n", trace(I));

%% 5. Matris işlemleri
M1 = [1, 2; 3, 4];
M2 = [5, 6; 7, 8];

toplam   = M1 + M2;
carpim   = M1 * M2;
transpoz = M1';
ters     = inv(M1);

printf("\nM1 + M2 =\n");   disp(toplam)
printf("M1 * M2 =\n");      disp(carpim)
printf("M1'     =\n");      disp(transpoz)
printf("inv(M1) =\n");      disp(ters)
printf("inv(M1) * M1 birime yakin mi: %d\n", norm(ters * M1 - eye(2)) < 1e-12);

%% 6. Yardım
% Bir fonksiyonun belgesi help ile okunur (etkileşimli oturumda):
%   help inv
% Betik içinde belge metninin ilk satırı şöyle alınabilir:
bilgi = help("inv");
printf("\nhelp('inv') ilk satiri: %s\n", strtrim(strsplit(bilgi, "\n"){1}));

%% Özet
printf("\nOzet: 6 aritmetik islem, 3 degisken, 2 vektor, 1 matris, 3 ozel matris,\n");
printf("      4 matris islemi ve help ornegi tek betikte calistirildi.\n");
