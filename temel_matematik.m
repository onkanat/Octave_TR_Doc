clear; clc; close all;

%% 1. Aritmetik işlemler
printf("%-22s %s\n", "Islem", "Sonuc");
printf("%-22s %g\n", "2 + 3",   2 + 3);
printf("%-22s %g\n", "8 - 4",   8 - 4);
printf("%-22s %g\n", "5 * 2",   5 * 2);
printf("%-22s %g\n", "10 / 2",  10 / 2);
printf("%-22s %g\n", "2 ^ 3",   2 ^ 3);
printf("%-22s %g\n", "sqrt(9)", sqrt(9));

%% 2. Karmaşık sayılar
z = 3 + 4i;
printf("\nz            : %s\n", num2str(z));
printf("abs(z)       : %g\n", abs(z));
printf("conj(z)      : %s\n", num2str(conj(z)));

[kutup, yaricap] = cart2pol(real(z), imag(z));   % polar(): [theta, r]
printf("polar(z)     : aci = %.4f rad, yaricap = %g\n", kutup, yaricap);

geri = yaricap * (cos(kutup) + 1i * sin(kutup));  % rect(): polar -> kartezyen
printf("rect(th,r)   : %s\n", num2str(geri, "%.6f"));

%% 3. Üstel ve logaritmik işlemler
printf("\nexp(1)       : %.6f\n", exp(1));
printf("log(exp(1))  : %.6f  (dogal logaritma, taban e)\n", log(exp(1)));
printf("log2(8)      : %.6f\n", log2(8));
printf("log10(100)   : %.6f\n", log10(100));

%% 4. Yuvarlama işlemleri
printf("\nfloor(3.14)     : %g\n", floor(3.14));
printf("ceil(3.14)      : %g\n", ceil(3.14));
% Octave'un round'u tek argüman alır; ondalık basamak için ölçekleme yapılır.
printf("round(1.567*10)/10 : %g  (bir ondalik basamak)\n", round(1.567 * 10) / 10);
printf("round(1.567)    : %g\n", round(1.567));

%% 5. Diğer yardımcılar
printf("\nsqrt(9)      : %g\n", sqrt(9));
printf("factorial(5) : %g\n", factorial(5));

% rand: rastgele sayı üretimi. Tekrarlanabilir çıktı için tohum sabitlenir.
rand("seed", 42);
rastgele = rand(1, 3);
printf("rand (seed=42): %.4f %.4f %.4f\n", rastgele(1), rastgele(2), rastgele(3));
printf("rand araligi  : [0, 1) -> min %.4f, max %.4f\n", min(rastgele), max(rastgele));

%% Özet
printf("\nOzet: aritmetik (6), karmasik sayi (4), ustel/logaritma (4),\n");
printf("      yuvarlama (4), diger (3) fonksiyon ornegi olculdu.\n");
