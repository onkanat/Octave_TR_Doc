---
layout: default
title: "Octave'de Döngüler ve Koşullar"
lang: tr
konu: temel
seviye: baslangic
tur: ders
kod: donguler_kosullar.m
redirect_from: [/Octave_loops_conditions.html]
---

# Octave'de Döngüler ve Koşullar

Octave'de kod akışı `if`/`elseif`/`else` koşulları ve `for`, `while`, `do-until` döngüleriyle kurulur.
Bu not dört yapıyı, iki sayısal algoritmayı (Newton-Raphson, Monte Carlo) ve döngüyle gri tonlama
örneğini tek betikte toplar; çıktı ölçülmüştür.

## Ne öğreneceksiniz

- `if`/`elseif`/`else` ile koşullu dallanmayı
- `for`, `while` ve `do-until` döngülerinin farkını (gövde en az bir kez koşar mı?)
- `break` ile döngüden erken çıkmayı
- Newton-Raphson ile kök bulmayı ve Monte Carlo ile π tahminini
- Döngüyle piksel işlemeyi ve vektörleştirilmiş karşılığıyla aynı sonucu ürettiğini doğrulamayı

## Çalıştırma

```sh
octave --no-gui donguler_kosullar.m
```

Betik tek başına koşar; `rand("seed", 42)` sayesinde Monte Carlo tahmini her koşuda aynıdır. Başsız
oturumda `octave --no-gui --no-window-system` ya da `octave-cli` aynı çıktıyı verir; ölçüm GNU Octave
11.3.0 ile yapıldı.

## Kod

Gri tonlama örneği `image` paketine **bağlı değildir**: 100×100×3 yapay bir görüntü bellekte kurulur ve
ağırlıklı ortalama formülü (0.299 R + 0.587 G + 0.114 B) döngüyle uygulanır. Gerçek bir dosyayı işlemek
isteyen okur `pkg load image; img = imread("dosya.jpg")` satırıyla başlar ve isterse `imshow` ile
gösterir — gösterim grafik penceresi gerektirdiği için ölçüm bloğuna alınmadı.

```octave
clear; clc; close all;
rand("seed", 42);

%% 1. Koşullu ifade: if / elseif / else
x = 10;
if (x > 5)
  durum = "5'ten buyuk";
elseif (x < 5)
  durum = "5'ten kucuk";
else
  durum = "5'e esit";
end
printf("x = %d -> %s\n", x, durum);

%% 2. for döngüsü
toplam = 0;
for i = 1:10
  toplam = toplam + i;
end
printf("1..10 toplami            : %d\n", toplam);

%% 3. while döngüsü
n = 1;
son_kare = 0;
while (n^2 < 200)
  son_kare = n^2;
  n = n + 1;
end
printf("n^2 < 200 kosulunu bozan n: %d (n^2 = %d)\n", n, n^2);
printf("kosulu saglayan son n     : %d (n^2 = %d)\n", n - 1, son_kare);

%% 4. do-until döngüsü: gövde en az bir kez çalışır
sayac = 0;
do
  sayac = sayac + 1;
until (sayac >= 5)
printf("do-until sayaci           : %d (govde en az bir kez calisti)\n", sayac);

%% 5. Newton-Raphson ile kök bulma
f  = @(t) t.^2 - 2;
df = @(t) 2 * t;
x0 = 1.5;
tolerans = 1e-6;
max_iter = 100;

xk = x0;
for k = 1:max_iter
  fxk = f(xk);
  if abs(fxk) < tolerans
    break;
  end
  xk = xk - fxk / df(xk);
end
printf("\nNewton-Raphson iterasyon  : %d, kok = %.8f, |f| = %.2e\n", k, xk, abs(f(xk)));

%% 6. Monte Carlo ile pi tahmini (tohum sabit -> tekrarlanabilir)
N = 100000;
icerde = 0;
for i = 1:N
  xr = rand();
  yr = rand();
  if (xr^2 + yr^2) <= 1
    icerde = icerde + 1;
  end
end
pi_tahmini = 4 * icerde / N;
printf("Monte Carlo (N = %d)     : pi ~ %.6f, gercek %.6f, hata %.6f\n", ...
       N, pi_tahmini, pi, abs(pi_tahmini - pi));

%% 7. Döngüyle gri tonlama (görüntü paketi gerekmez)
% Gerçek bir görüntü için: pkg load image; img = imread("dosya.jpg");
img = uint8(zeros(100, 100, 3));
img(:, :, 1) = 10;
img(:, :, 2) = 50;
img(:, :, 3) = 200;
[yukseklik, genislik, kanal] = size(img);
gri_img = uint8(zeros(yukseklik, genislik));
for i = 1:yukseklik
  for j = 1:genislik
    R = double(img(i, j, 1));
    G = double(img(i, j, 2));
    B = double(img(i, j, 3));
    gri_img(i, j) = uint8(R * 0.299 + G * 0.587 + B * 0.114);
  end
end
beklenen = 10 * 0.299 + 50 * 0.587 + 200 * 0.114;
printf("\nGri tonlama: boyut %dx%dx%d -> %dx%d\n", yukseklik, genislik, kanal, ...
       rows(gri_img), columns(gri_img));
printf("Beklenen gri deger %.2f, olculen ortalama %.2f, min %d, max %d\n", ...
       beklenen, mean(gri_img(:)), min(gri_img(:)), max(gri_img(:)));

% Vektörleştirilmiş karşılığı aynı sonucu verir ve çok daha hızlıdır:
gri_vektor = uint8(0.299 * double(img(:, :, 1)) + 0.587 * double(img(:, :, 2)) + ...
                   0.114 * double(img(:, :, 3)));
printf("Vektorlestirilmis yontem ayni sonucu verdi mi: %d\n", isequal(gri_img, gri_vektor));

%% Özet
printf("\nOzet: if/for/while/do-until, Newton-Raphson (kok %.8f), Monte Carlo (pi ~ %.4f),\n", xk, pi_tahmini);
printf("      dongu ile gri tonlama (ortalama %.1f) ornekleri olculdu.\n", mean(gri_img(:)));
```

## Beklenen Çıktı

Aşağıdaki blok, yukarıdaki betiğin `octave --no-gui` koşusundan **birebir** alınmıştır.

```text
x = 10 -> 5'ten buyuk
1..10 toplami            : 55
n^2 < 200 kosulunu bozan n: 15 (n^2 = 225)
kosulu saglayan son n     : 14 (n^2 = 196)
do-until sayaci           : 5 (govde en az bir kez calisti)

Newton-Raphson iterasyon  : 4, kok = 1.41421356, |f| = 4.51e-12
Monte Carlo (N = 100000)     : pi ~ 3.137320, gercek 3.141593, hata 0.004273

Gri tonlama: boyut 100x100x3 -> 100x100
Beklenen gri deger 55.14, olculen ortalama 55.00, min 55, max 55
Vektorlestirilmis yontem ayni sonucu verdi mi: 1

Ozet: if/for/while/do-until, Newton-Raphson (kok 1.41421356), Monte Carlo (pi ~ 3.1373),
      dongu ile gri tonlama (ortalama 55.0) ornekleri olculdu.
```

## Öne Çıkan Noktalar

- `while` koşulu sağlanmadığında hiç koşmayabilir; `do-until` gövdesi en az bir kez çalışır. Ölçümde
  sayaç 5'te durdu.
- Newton-Raphson `x² - 2` için 1.5 başlangıcından **4 iterasyonda** `1.41421356` verdi; `|f| = 4.51e-12`.
- Monte Carlo `N = 100000` ile `π ≈ 3.137320`, hata `0.004273`. Tohum sabit olduğu için bu sayı tekrarlanabilir;
  tohum değişirse çıktı da değişir.
- Döngüyle gri tonlama beklenen değer `55.14` yerine `uint8` yuvarlamasıyla `55` üretti; vektörleştirilmiş
  sürüm birebir aynı matrisi verdi (`isequal = 1`).
- Gerçek görüntülerde iç içe döngü yavaştır; aynı işlem vektörleştirilmiş tek satırla yapılır — bu notta
  iki yolun aynı sonucu verdiği ölçüldü.

## Alıştırmalar

1. `do-until` sayacını `until (sayac >= 0)` yapın; gövdenin kaç kez koştuğunu açıklayın.
2. Newton-Raphson'da başlangıç tahminini `x0 = 100` yapın; iterasyon sayısını ve yakınsamayı karşılaştırın.
3. Monte Carlo denemesini `N = 1000` ve `N = 1000000` için koşturun; hata mertebesinin `1/sqrt(N)` ile nasıl değiştiğini ölçün.
