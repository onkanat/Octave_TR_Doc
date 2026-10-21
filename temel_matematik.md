---
layout: default
title: "Octave'de Temel Matematiksel İşlemler"
lang: tr
konu: temel
seviye: baslangic
tur: ders
kod: temel_matematik.m
redirect_from: [/Octave_temel_matematik.html]
---

# Octave'de Temel Matematiksel İşlemler

Octave, matematiksel işlemler için geniş bir yerleşik fonksiyon kümesi sunar. Bu notta en sık
kullanılanlar kategorilere ayrıldı ve tek bir betikte ölçüldü: aritmetik, karmaşık sayılar,
üstel/logaritmik işlemler, yuvarlama ve yardımcı fonksiyonlar.

## Ne öğreneceksiniz

- Aritmetik operatörleri ve `sqrt` ile temel hesapları
- Karmaşık sayılarda `abs`, `conj` ve kutupsal ↔ kartezyen dönüşümü
- `exp`, `log`, `log2`, `log10` arasındaki taban farkını
- `floor`, `ceil`, `round` ile yuvarlamayı ve Octave'de `round`un tek argüman aldığını
- `factorial` ve `rand`; `rand("seed", 42)` ile çıktıyı tekrarlanabilir kılmayı

## Çalıştırma

```sh
octave --no-gui temel_matematik.m
```

Betik tek başına koşar ve aynı çıktıyı üretir. Başsız oturumda `octave --no-gui --no-window-system`
ya da `octave-cli` ile aynı sonuç alınır; ölçüm GNU Octave 11.3.0 ile yapıldı.

## Kod

Karmaşık sayının kutupsal gösterimi `cart2pol` ile alınır; geri dönüş `cos`/`sin` ile kuruldu, böylece
betik farklı dağıtımlarda da koşar. `rand` çağrısından **önce** tohum sabitlendiği için rastgele
değerler her koşuda aynıdır.

```octave
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
```

## Beklenen Çıktı

Aşağıdaki blok, yukarıdaki betiğin `octave --no-gui` koşusundan **birebir** alınmıştır.

```text
Islem                  Sonuc
2 + 3                  5
8 - 4                  4
5 * 2                  10
10 / 2                 5
2 ^ 3                  8
sqrt(9)                3

z            : 3+4i
abs(z)       : 5
conj(z)      : 3-4i
polar(z)     : aci = 0.9273 rad, yaricap = 5
rect(th,r)   : 3.000000+4.000000i

exp(1)       : 2.718282
log(exp(1))  : 1.000000  (dogal logaritma, taban e)
log2(8)      : 3.000000
log10(100)   : 2.000000

floor(3.14)     : 3
ceil(3.14)      : 4
round(1.567*10)/10 : 1.6  (bir ondalik basamak)
round(1.567)    : 2

sqrt(9)      : 3
factorial(5) : 120
rand (seed=42): 0.3120 0.1036 0.5635
rand araligi  : [0, 1) -> min 0.1036, max 0.5635

Ozet: aritmetik (6), karmasik sayi (4), ustel/logaritma (4),
      yuvarlama (4), diger (3) fonksiyon ornegi olculdu.
```

## Öne Çıkan Noktalar

- `log` doğal logaritmadır (taban e); `log10(100) = 2`, `log2(8) = 3` ölçüldü.
- `round(1.567, 1)` Octave 11.3.0'da **geçersizdir** (`invalid call to round`). Ondalık basamak için
  ölçekleme şarttır: `round(1.567 * 10) / 10 = 1.6` (ölçüldü). Eski sürümlerden kalan iki argümanlı
  kullanım bu yüzden kaldırıldı.
- Karmaşık sayıda `abs(3+4i) = 5`; `conj` sanal kısmın işaretini çevirir.
- Tohumlanmamış `rand` her koşuda farklı değer üretir → "Beklenen Çıktı" karşılaştırılamaz hâle gelir.
- `factorial(5) = 120`; `sqrt` ve `factorial` vektörle de çağrılabilir.

## Alıştırmalar

1. `log2(1024)`, `log(exp(3))`, `log10(0.001)` değerlerini tek `printf` çağrısıyla yazdırın.
2. `z = 1 + 1i` için kutupsal gösterimi hesaplayın; `cart2pol` sonucunu `atan2(imag(z), real(z))` ile doğrulayın.
3. Tohumu 42 yerine 7 yapın ve `donguler_kosullar` notundaki Monte Carlo π tahmininin nasıl değiştiğini ölçün.
