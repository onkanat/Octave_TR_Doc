---
layout: default
title: "Octave Matematik Alıştırmaları"
lang: tr
konu: temel
seviye: baslangic
tur: alistirma
kod: matematik_alistirmalari.m
redirect_from: [/Octave_matematik_alistirmalari.html]
---

# Octave Matematik Alıştırmaları

Bu bölüm, Octave'ın temel aritmetik operatörlerini, yerleşik (intrinsic) fonksiyonlarını ve
döngü yapılarını pekiştirmek için tasarlanmış matematik problemlerini ve çözümlerini içerir.
Beş problem tek betikte toplanmıştır ve **sabit örnek girdilerle** koşar; sayfadaki çıktı bloğu
betiğin ölçülmüş koşusudur (GNU Octave 11.3.0).

## Ne öğreneceksiniz

- `for` döngüsüyle faktöriyel yazmayı ve sonucu `factorial` ile doğrulamayı
- Diskriminanttan (`Δ = b² - 4ac`) köklerin gerçek/karmaşık olduğunu ayırmayı
- `do ... until` döngüsünün Octave'de nasıl yazıldığını ve durdurucu değerle nasıl bitirildiğini
- Taylor serisiyle `e^x` yaklaşımını hesaplayıp `exp` ile karşılaştırmayı (bağıl hata)
- İç içe üç döngüyle matris çarpımını yazıp `A * B` operatörüyle birebir karşılaştırmayı

## Çalıştırma

```sh
octave --no-gui matematik_alistirmalari.m
```

Betik reponun kökünde ve tek başına koşar; ek paket yüklemez, dosya yazmaz, grafik çizmez.
Bu makinede `octave --no-gui` Qt/cocoa eklentisi yüzünden betiği yüklemeden düşüyor
(**EXIT=134**); sayfadaki blok aynı çıktıyı veren `octave-cli` ile ölçüldü.

## Kod

### Örnek girdiler betiğin içinde

Nottaki ilk sürüm her problemde `input()` ile değer istiyordu (özellikle 3. problemde
"0 girene kadar" döngüsü). Etkileşimli betik tek başına koşmadığı ve çıktısı kişiye göre
değiştiği için üçüncü problemde girdi akışı bir vektörle modellendi: `girisler = [4, 8, 15,
16, 23, 42, 0]`. `do ... until` yapısı korunmuştur; yalnız `input()` satırının yerini
`sayi = girisler(k);` aldı.

### 1. Faktöriyel Hesaplama (Basit)

**Problem:** Kullanıcıdan alınan bir sayının faktöriyelini hesaplayan programı yazınız.
Çözüm `[1]` bölümünde: negatif kontrolü, `for` döngüsü ve `factorial` ile karşılaştırma.

### 2. İkinci Derece Denklem Kökleri (Basit)

**Problem:** Bir `ax² + bx + c = 0` ikinci derece denkleminde, kullanıcıdan `a, b, c`
değerlerini alarak diskriminant (`Δ = b² - 4ac`) hesabı yapan ve köklerin reel olup olmadığını
belirten programı yazınız. Çözüm `[2]` bölümünde; nottaki sürüm yalnız köklerin türünü
yazdırıyordu, bu sürüm köklerin kendisini de verir (`x1 = 2`, `x2 = 1`).

### 3. Aritmetik Ortalama (Orta)

**Problem:** `do-until` döngüsü kullanarak, kullanıcı 0 girene kadar sayı alan ve bu sayıların
aritmetik ortalamasını ekrana basan programı yazınız. `[3]` bölümü `do ... until (sayi == 0)`
yapısını aynen korur; sayaç sıfır kalırsa "hiç sayı girilmedi" dalı da yerinde durur.

### 4. Taylor Serisi ile Üstel Fonksiyon (Orta)

**Problem:** `e^x` fonksiyonunun Taylor serisi açılımını (`e^x = Σ xⁿ/n!`) kullanarak,
kullanıcıdan alınan bir `x` değeri için ilk 10 terim üzerinden hesaplama yapan programı yazınız.
`[4]` bölümü `x = 1.5` için 10 terim toplar ve `exp(1.5)` ile bağıl hatayı yazdırır.

### 5. Matris Çarpımı (İleri)

**Problem:** İki adet 3 × 3 boyutundaki matrisi çarpan ve sonucu ekrana yazdıran bir Octave
programı yazınız (iç içe döngüler kullanarak). `[5]` bölümü hem döngü sonucunu hem `A * B`
operatörünü basar; aradaki farkın `0` çıkması döngünün doğruluğunu kanıtlar.

### Betik

Aşağıdaki betik dosyanın tamamıdır (`kod: matematik_alistirmalari.m`).

```octave
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
```

## Beklenen Çıktı

```
[1] 7! = 5040 (dongu), factorial(7) = 5040, esitlik: 1
[2] denklem: 1x^2 + (-3)x + (2) = 0, diskriminant = 1.00
[2] iki farkli reel kok vardir: x1 = 2.0000, x2 = 1.0000
[3] 6 sayinin ortalamasi: 18.0000 (toplam 108)
[4] e^1.50 (10 terim) = 4.481671
[4] exp(1.50)         = 4.481689
[4] bagil hata        = 4.098e-06
[5] A * B (dongu ile):
    30    24    18
    84    69    54
   138   114    90
[5] A * B (operator) :
    30    24    18
    84    69    54
   138   114    90
[5] iki sonuc arasindaki en buyuk fark: 0

Ozet: faktoriyel 7!, diskriminant 1.00, ortalama 18.0000, e^1.50 ~ 4.481671,
      dongu ile matris carpimi operator sonucuyla birebir ayni.
```

## Öne Çıkan Noktalar

- **Döngü ile yerleşik fonksiyon aynı sonucu verir:** `7! = 5040` hem `for` döngüsünde hem
  `factorial(7)`'de; betik eşitliği `==` ile yazdırır. Faktöriyel hızla büyüdüğü için
  `170!`'den sonra `Inf` olur (çift duyarlı tavan).
- **Diskriminant üç dal:** `Δ > 0` iki farklı reel kök, `Δ == 0` çakışık kök, `Δ < 0` karmaşık
  kök. `Δ == 0` karşılaştırması kayan noktalı sayılarda hassastır; gerçek problemlerde
  `abs(delta) < 1e-12` yazmak daha güvenlidir.
- **`do ... until` Octave'e özgüdür:** MATLAB'da `do-until` yoktur, `while` ile yazılır.
  Koşul döngünün **sonunda** sınandığı için gövde en az bir kez çalışır — durdurucu değer bu
  yüzden ilk turda da okunur.
- **Taylor yakınsaması:** 10 terimle `e^1.5` için `4,481671` bulunur, gerçek değer `4,481689`;
  bağıl hata `4,1e-06`. Terim sayısı 15'e çıkarıldığında hata `1e-10` mertebesine iner.
- **Üç döngülü çarpım `O(n³)`:** 3 × 3 için önemsiz, 1000 × 1000 için `1e9` çarpma demektir;
  Octave'de `A * B` altındaki BLAS kütüphanesini kullanır ve döngüden yüzlerce kat hızlıdır.
  Bu yüzden "vektörleştirme" konusu ayrı bir not olarak duruyor.

## Alıştırmalar

1. `n = 170` ve `n = 171` için faktöriyeli hesaplayın: ikincisi neden `Inf` oluyor?
   `intmax("uint64")` sınırıyla karşılaştırın.
2. İkinci derece denklemde `a = 1, b = 2, c = 5` verin (`Δ = -16`): betik hangi dalı yazdırıyor?
   Kökleri karmaşık olarak (`roots([1 2 5])`) hesaplayıp gerçek/ sanal kısımlarını yazdırın.
3. Taylor serisinde terim sayısını 10'dan 20'ye çıkarın: bağıl hata kaç mertebe düşüyor?
   `x = 5` için aynı terim sayısı yeterli mi, neden?
4. Matris çarpımını `10 × 10` rastgele matrislerle tekrarlayın (`rand("seed", 42)`), döngü ile
   `A * B` arasındaki en büyük farkı ve iki yöntemin süresini (`tic`/`toc`) karşılaştırın.
