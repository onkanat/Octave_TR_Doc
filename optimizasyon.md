---
layout: default
title: "Octave'de Optimizasyon: Minimizasyon, Eğri Uydurma, Denklem Çözme"
lang: tr
konu: ileri
seviye: ileri
tur: ders
kod: optimizasyon.m
redirect_from: [/Octave_optimization.html]
---

# Octave'de Optimizasyon: Minimizasyon, Eğri Uydurma, Denklem Çözme

Optimizasyon, bir fonksiyonun (kısıt varsa kısıtlar altında) en küçük ya da en büyük değerini
bulma işidir. Bu not; Rosenbrock fonksiyonuyla kısıtlamasız minimizasyonu, tek değişkenli
sınırlı aramayı (`fminbnd`), kimyasal bozunma verisine üstel model uydurmayı ve doğrusal
olmayan bir denklem sistemini (`fsolve`) tek betikte gösterir. Sayfadaki çıktı bloğu betiğin
**ölçülmüş** koşusundan alınmıştır.

## Ne öğreneceksiniz

- `fminsearch` (Nelder-Mead, türev gerektirmez) ile çok değişkenli minimizasyonu
- `optimset` ile durdurma ölçütlerini (`TolX`, `TolFun`, `MaxIter`) ve çıktı alanlarını
  (`iterations`, `funcCount`) ayarlamayı ve okumayı
- `fminbnd` ile bir aralıkta tek değişkenli minimizasyonu
- Üstel model `C(t) = C₀·exp(-k·t)` için doğrusal (log ile `polyfit`) ve doğrusal olmayan
  (kareler toplamını doğrudan azaltan) iki uydurma yolunu karşılaştırmayı
- `fsolve` ile doğrusal olmayan denklem sistemini çözmeyi ve kalıntıyı (residual) ölçmeyi

## Çalıştırma

```sh
octave --no-gui optimizasyon.m
```

Betik reponun kökünde ve tek başına koşar; **paket yüklemez**. `optim` paketindeki
`fminunc` ve `sqp` bu makinede kurulu değil (ölçüldü: `pkg list` çıktısında `optim` yok),
bu yüzden aynı işler çekirdek `fminsearch`, `fminbnd` ve `fsolve` ile yapıldı. Sayfadaki
blok GNU Octave 11.3.0 ile `octave-cli` üzerinden ölçüldü; bu makinede `octave --no-gui`
Qt/cocoa eklentisi yüzünden betiği yüklemeden düşüyor (EXIT=134).

## Kod

Paket işlevi ↔ bu betikteki karşılığı:

| `optim` paketi | Bu betikte | Not |
|---|---|---|
| `fminunc(f, x0, options)` | `fminsearch(f, x0, options)` | Gradyan tabanlı yerine türevsiz arama; ikisi de yerel minimum bulur |
| `optimset("Display","iter")` | `optimset("TolX",…, "TolFun",…, "MaxIter",…)` | `Display` her adımı yazar; burada yinelemeler `cikti.iterations` ile okunur |
| `sqp` (kısıtlı) | `fminbnd` (sınırlı, tek değişken) | Çok değişkenli kısıt için `sqp` gerekir; bu makinede yok |
| — | `fsolve` | Denklem sisteminde kök arar (çekirdekte var) |

Aşağıdaki betik dosyanın tamamıdır (`kod: optimizasyon.m`):

```octave
clear; clc; close all;

%% 0. Hazirlik: yalniz cekirdek islevler (optim paketi gerekmez)
% optim paketindeki fminunc/sqp bu makinede kurulu degil; ayni isi cekirdek
% fminsearch (Nelder-Mead, turev gerektirmez), fminbnd ve fsolve yapar.
printf("[0] surum: %s, fminsearch var mi: %d\n", version(), exist("fminsearch"));

%% 1. Rosenbrock: kisitlamasiz minimizasyon
rosenbrock = @(x) (1 - x(1))^2 + 100*(x(2) - x(1)^2)^2;
x0 = [-1.2, 2];
secenek = optimset("TolX", 1e-10, "TolFun", 1e-10, "MaxIter", 2000);
[x_min, fval, exitflag, cikti] = fminsearch(rosenbrock, x0, secenek);
printf("[1] Rosenbrock  : baslangic [%.1f %.1f], %d yineleme, %d fonksiyon cagrisi\n", ...
       x0(1), x0(2), cikti.iterations, cikti.funcCount);
printf("[1] minimum nokta: [%.6f %.6f], f = %.3e, exitflag = %d\n", ...
       x_min(1), x_min(2), fval, exitflag);

%% 2. Tek degiskenli minimizasyon: fminbnd ile sinirli arama
hedef1 = @(x) (x - 2).^2 + 1;
[xb, fb, bayrak] = fminbnd(hedef1, 0, 5);
printf("[2] fminbnd      : (x-2)^2 + 1 -> x = %.6f, f = %.6f, exitflag = %d\n", ...
       xb, fb, bayrak);

%% 3. Egri uydurma: ustel model C(t) = C0*exp(-k*t)
t_veri = [0, 1, 2, 3, 4, 5, 6];
C_veri = [1.0, 0.6, 0.35, 0.2, 0.1, 0.05, 0.02];
model  = @(p, t) p(1)*exp(-p(2)*t);
% 3a. Dogrusal en kucuk kareler: log(C) = log(C0) - k*t
katsayi = polyfit(t_veri, log(C_veri), 1);
k_dogrusal = -katsayi(1);
C0_dogrusal = exp(katsayi(2));
hata_dogrusal = sum((model([C0_dogrusal, k_dogrusal], t_veri) - C_veri).^2);
printf("[3] dogrusal fit : C0 = %.4f, k = %.4f, SSE = %.3e\n", ...
       C0_dogrusal, k_dogrusal, hata_dogrusal);
% 3b. Dogrusal olmayan en kucuk kareler: kareler toplamini dogrudan azalt
amac = @(p) sum((model(p, t_veri) - C_veri).^2);
[p_en, sse_en, bayrak_en] = fminsearch(amac, [1.0, 0.5], secenek);
printf("[3] dogrusal olmayan: C0 = %.4f, k = %.4f, SSE = %.6f, exitflag = %d\n", ...
       p_en(1), p_en(2), sse_en, bayrak_en);
printf("[3] karsilastirma: SSE %.3e -> %.6f (%.1f kat kucuk)\n", ...
       hata_dogrusal, sse_en, hata_dogrusal/sse_en);

%% 4. Cok degiskenli dogrusal sistem: fsolve
sistem = @(v) [v(1)^2 + v(2)^2 - 25; v(1) - v(2) - 1];
[v, fval_v, bilgi] = fsolve(sistem, [4, 3]);
printf("[4] fsolve        : x^2+y^2 = 25, x-y = 1 -> [%.6f %.6f]\n", v(1), v(2));
printf("[4] kalinti        : %.3e, bilgi = %d\n", norm(fval_v), bilgi);

%% 5. Baslangic noktasinin onemi: ayni rosenbrock, uzak baslangic
[x_uzak, f_uzak] = fminsearch(rosenbrock, [-3, -4], secenek);
printf("[5] uzak baslangic: [%.4f %.4f], f = %.3e\n", x_uzak(1), x_uzak(2), f_uzak);

%% Ozet
printf("\nOzet: fminsearch (Rosenbrock + egri uydurma), fminbnd ve fsolve ile 4\n");
printf("      optimizasyon problemi ayni betikte olculdu; en iyi ustel model\n");
printf("      C(t) = %.4f*exp(-%.4f*t), SSE = %.6f.\n", p_en(1), p_en(2), sse_en);
```

## Beklenen Çıktı

```
[0] surum: 11.3.0, fminsearch var mi: 2
[1] Rosenbrock  : baslangic [-1.2 2.0], 113 yineleme, 225 fonksiyon cagrisi
[1] minimum nokta: [1.000000 1.000000], f = 6.827e-22, exitflag = 1
[2] fminbnd      : (x-2)^2 + 1 -> x = 2.000000, f = 1.000000, exitflag = 1
[3] dogrusal fit : C0 = 1.1683, k = 0.6414, SSE = 3.022e-02
[3] dogrusal olmayan: C0 = 1.0086, k = 0.5436, SSE = 0.001223, exitflag = 1
[3] karsilastirma: SSE 3.022e-02 -> 0.001223 (24.7 kat kucuk)
[4] fsolve        : x^2+y^2 = 25, x-y = 1 -> [4.000000 3.000000]
[4] kalinti        : 0.000e+00, bilgi = 1
[5] uzak baslangic: [1.0000 1.0000], f = 1.435e-21

Ozet: fminsearch (Rosenbrock + egri uydurma), fminbnd ve fsolve ile 4
      optimizasyon problemi ayni betikte olculdu; en iyi ustel model
      C(t) = 1.0086*exp(-0.5436*t), SSE = 0.001223.
```

## Öne Çıkan Noktalar

- Rosenbrock fonksiyonu `(1-x)² + 100(y-x²)²` optimizasyon algoritmalarının standart testidir:
  dar ve kıvrımlı bir vadi boyunca `(1, 1)` noktasına iner. Betikte 113 yineleme ve 225
  fonksiyon çağrısı ile `f = 6,8e-22` bulundu; `exitflag = 1` yakınsadı demektir.
- `fminsearch` **yerel** minimum bulur. Uzak bir başlangıç `[-3, -4]` de aynı noktaya
  (`[1, 1]`) vardı, çünkü Rosenbrock'un bu bölgede tek çukuru vardır; çok çukurlu
  fonksiyonlarda başlangıç noktası sonucu değiştirir.
- Eğri uydurmada iki yol aynı veriye farklı sonuç verir: `log` alıp `polyfit` yapmak
  **log-uzayındaki** hatayı en küçükler (SSE 3,0e-2), kareler toplamını doğrudan azaltmak
  **veri uzayındaki** hatayı en küçükler (SSE 1,2e-3) — 24,7 kat daha iyi. Kimyasal hız
  sabiti gibi parametrelerde doğrusal olmayan uydurma tercih edilir.
- `fsolve` bir denklem sisteminde **kök** arar, minimizasyon yapmaz: `x²+y² = 25` çemberi ile
  `x-y = 1` doğrusunun kesişimi `[4, 3]` olarak kalıntı 0 ile bulundu.
- `optimset` çıktısı `cikti.iterations` ve `cikti.funcCount` alanlarıyla algoritmanın
  maliyetini ölçmeyi sağlar; `Display="iter"` her adımı ekrana yazar (bu betikte çıktı
  kısa kalsın diye kapalı).

## Alıştırmalar

1. Rosenbrock için başlangıcı `[0, 0]` yapın; yineleme ve fonksiyon çağrısı sayısı nasıl
   değişiyor? `TolX` değerini `1e-4` yapıp yakınsama kalitesini karşılaştırın.
2. Üstel modele aykırı (outlier) bir nokta ekleyin (`C_veri(4) = 0.5`): doğrusal ve doğrusal
   olmayan uydurma bu noktadan ne kadar etkileniyor? Hangi yöntem daha dayanıklı?
3. `fminbnd` ile `sin(x)` fonksiyonunun `[0, 2π]` aralığındaki minimumunu bulun; sonucun
   `3π/2` olduğunu analitik olarak doğrulayın. Aralığı `[0, π]` yapınca ne değişir?
