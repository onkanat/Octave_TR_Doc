---
layout: default
title: "Octave'de Polinomlar"
lang: tr
konu: temel
seviye: orta
tur: ders
kod: polinomlar.m
redirect_from: [/Octave_polinomlar.html]
---

# Octave'de Polinomlar

Octave'de bir polinom, katsayılarının azalan sıradaki vektörüyle temsil edilir: `p = [-2, -1, 0, 1, 2]`
vektörü `-2x⁴ - x³ + x + 2` polinomudur. Bu not tüm polinom fonksiyonlarını, iki klasik tuzağı ve
üç uygulamayı tek betikte toplar; çıktı ölçülmüştür.

## Ne öğreneceksiniz

- `polyout` ile polinomu okunur biçimde yazdırmayı
- `polyval`, `conv`, `deconv` ile değerlendirme, çarpma ve bölme işlemlerini
- `roots`, `polyder`, `polyint` ile kök, türev ve integral almayı
- `polyfit` ile en küçük kareler anlamında veri uydurmayı
- Polinom toplama tuzağını ve aşırı uyum (overfitting) riskini ölçerek görmeyi

## Çalıştırma

```sh
octave --no-gui polinomlar.m
```

Betik tek başına koşar; `rand`/`randn` tohumları sabit olduğu için gürültülü veri her koşuda aynıdır.
Başsız oturumda `octave --no-gui --no-window-system` ya da `octave-cli` aynı çıktıyı verir; ölçüm
GNU Octave 11.3.0 ile yapıldı.

## Kod

Aşağıdaki betik dosyanın tamamıdır. Grafik üretmez: betiğin işi sayıları ölçmek, sayfa da ölçülen
sayıları göstermek. Grafik isteyen okur, "Grafikle görselleştirme" alt bölümündeki üç satırı betiğin
sonuna ekleyebilir.

```octave
clear; clc; close all;
rand("seed", 42);
randn("seed", 42);

%% 1. Polinomun katsayı vektörüyle gösterimi
p = [-2, -1, 0, 1, 2];
printf("p = [-2 -1 0 1 2] -> "); polyout(p, "x");

%% 2. Değerlendirme: polyval
p2 = [1, -2, 1];                 % x^2 - 2x + 1
xv = [0, 1, 2, 3];
yv = polyval(p2, xv);
printf("\npolyval([1 -2 1], 0:3)   : %s\n", mat2str(yv));

%% 3. Çarpım: conv
a = [1, 2];                      % x + 2
b = [1, -1];                     % x - 1
c = conv(a, b);
printf("conv([1 2], [1 -1])      : %s   (x^2 + x - 2)\n", mat2str(c));

%% 4. Bölüm: deconv
y = [1, 0, -1];                  % x^2 - 1
bolen = [1, -1];                 % x - 1
[bolum, kalan] = deconv(y, bolen);
printf("deconv([1 0 -1], [1 -1]) : bolum %s, kalan %s\n", mat2str(bolum), mat2str(kalan));

%% 5. Kökler: roots
pr = [1, -5, 6];                 % x^2 - 5x + 6
kokler = sort(roots(pr));
printf("roots([1 -5 6])          : %s\n", mat2str(kokler', 6));

%% 6. Türev ve integral: polyder / polyint
pt = [1, 0, -3, 2];              % x^3 - 3x + 2
turev = polyder(pt);
printf("polyder([1 0 -3 2])      : %s   (3x^2 - 3)\n", mat2str(turev));
integ = polyint(turev);
printf("polyint([3 0 -3])        : %s   (x^3 - 3x, sabit 0)\n", mat2str(integ));

%% 7. Veri uydurma: polyfit
xd = [0, 1, 2, 3, 4];
yd = [1, 2, 5, 10, 17];
pu = polyfit(xd, yd, 2);
printf("\npolyfit(0:4, [1 2 5 10 17], 2) : %s\n", mat2str(pu, 6));
printf("uydurma artigi max       : %.2e\n", max(abs(polyval(pu, xd) - yd)));

%% 8. Tuzak: polinom toplama
pa = [1, 0, -1];                % x^2 - 1
pb = [1, 1];                    % x + 1
try
  pa + pb;
catch err
  printf("\npa + pb hata verdi  : %s\n", err.message);
end
pb_uzat = [0, pb];              % basa sifir eklemek polinomu degistirmez
printf("pa + [0 pb]          : %s\n", mat2str(pa + pb_uzat));
printf("polyout sonucu       : "); polyout(pa + pb_uzat, "x");

%% 9. Uygulama: hareket denklemi (y = y0 + v0 t + 0.5 a t^2)
t = [0, 0.5, 1.0, 1.5, 2.0, 2.5];
ym = [10, 12.5, 14.0, 14.5, 14.0, 12.5];
ph = polyfit(t, ym, 2);
ivme = 2 * ph(1);
v0   = ph(2);
y0   = ph(3);
printf("\nUydurulan hareket: a = %.2f m/s^2, v0 = %.2f m/s, y0 = %.2f m\n", ivme, v0, y0);
printf("uydurma artigi max : %.2e m\n", max(abs(polyval(ph, t) - ym)));

%% 10. Aşırı uyum: 2. derece ile 9. derece karşılaştırması
x = -5:1:5;
y_gercek = 0.5 * x.^2 - 2 * x + 3;
y_gurultulu = y_gercek + 2.5 * randn(size(x));
p2d = polyfit(x, y_gurultulu, 2);
p9d = polyfit(x, y_gurultulu, 9);
rmse2 = sqrt(mean((polyval(p2d, x) - y_gurultulu).^2));
rmse9 = sqrt(mean((polyval(p9d, x) - y_gurultulu).^2));
printf("\n2. derece RMSE     : %.4f  (veriye uyum)\n", rmse2);
printf("9. derece RMSE     : %.4f  (egitim verisine neredeyse tam uyum)\n", rmse9);
x_test = -4.5:1:4.5;
rmse2t = sqrt(mean((polyval(p2d, x_test) - (0.5 * x_test.^2 - 2 * x_test + 3)).^2));
rmse9t = sqrt(mean((polyval(p9d, x_test) - (0.5 * x_test.^2 - 2 * x_test + 3)).^2));
printf("2. derece RMSE (yeni veri): %.4f\n", rmse2t);
printf("9. derece RMSE (yeni veri): %.4f  <- asiri uyum burada gorunur\n", rmse9t);

%% 11. Uygulama: ekonomik trend tahmini
yillar = 2015:1:2024;
fiyatlar = [50, 55, 62, 70, 80, 85, 95, 110, 130, 155];
p_trend = polyfit(yillar, fiyatlar, 2);
gelecek = 2025:1:2029;
tahmin = polyval(p_trend, gelecek);
printf("\nYil      Tahmini fiyat (TL)\n");
for i = 1:numel(gelecek)
  printf("%d     %8.2f\n", gelecek(i), tahmin(i));
end
printf("egri egilimi (2025->2029): %.2f TL/yil ortalama artis\n", ...
       (tahmin(end) - tahmin(1)) / (numel(gelecek) - 1));

%% Özet
printf("\nOzet: polyout, polyval, conv, deconv, roots, polyder, polyint, polyfit\n");
printf("      8 polinom fonksiyonu; 2 tuzak, 3 uygulama olculdu.\n");
```

### Grafikle görselleştirme

Ölçüm bloğu grafik içermez (grafik çıktısı platforma göre değişir ve metinle karşılaştırılamaz). Görsel
özet isteyen okur, betiğin sonuna şu üç satırı ekleyebilir — dosyaya yazdığı için masaüstü gerekmez:

```octave
x_plot = linspace(0, 4, 100);
plot(xd, yd, "o", x_plot, polyval(pu, x_plot), "-");
xlabel("x"); ylabel("y"); title("Polinom uydurma"); grid on;
print("-dpng", "polinom_uydurma.png");
```

Grafik araç takımı olmayan (başsız) oturumlarda `print` çağrısı hata verir; sayısal bölüm etkilenmez.

Aşırı uyum karşılaştırmasının görsel hâli (2. derece mavi, 9. derece kırmızı):

```octave
x_plot = -5:0.1:5;
plot(x, y_gurultulu, "ko", "DisplayName", "Gurultulu Veri"); hold on;
plot(x_plot, polyval(p2d, x_plot), "b-", "LineWidth", 2, "DisplayName", "2. Derece (uygun)");
plot(x_plot, polyval(p9d, x_plot), "r-", "LineWidth", 2, "DisplayName", "9. Derece (asiri uyum)");
hold off; ylim([-5, 30]); legend("show", "Location", "north");
title("Asiri Uyum Ornegi"); xlabel("x"); ylabel("y"); grid on;
print("-dpng", "polinom_asiri_uyum.png");
```

Ekonomik trend tahmininin grafiği:

```octave
plot(yillar, fiyatlar, "o-", "DisplayName", "Gecmis Veriler"); hold on;
plot(gelecek, tahmin, "r*--", "DisplayName", "Tahminler"); hold off;
xlabel("Yil"); ylabel("Fiyat (TL)");
title("Ekonomik Trend Modellemesi ve Tahmin"); legend("show"); grid on;
print("-dpng", "polinom_trend.png");
```

### Eski nottaki etkileşimli oturum çıktıları

Bu sayfanın önceki sürümünde örnekler `octave:1> p = [-2, -1, 0, 1, 2];` biçiminde, yani etkileşimli
oturum dan istendiği gibi aktarılıyordu. Aynı satırlar artık betik içinde koşuyor; `polyout` çıktısı
(`-2*x^4 - 1*x^3 + 0*x^2 + 1*x^1 + 2`) ölçülen blokta birebir görülebilir. Etkileşimli oturumda
komut sonundaki noktalı virgül değeri basmaz; betikte aynı işi `printf` yapar.


## Beklenen Çıktı

Aşağıdaki blok, yukarıdaki betiğin `octave --no-gui` koşusundan **birebir** alınmıştır.

```text
p = [-2 -1 0 1 2] -> -2*x^4 - 1*x^3 + 0*x^2 + 1*x^1 + 2

polyval([1 -2 1], 0:3)   : [1 0 1 4]
conv([1 2], [1 -1])      : [1 1 -2]   (x^2 + x - 2)
deconv([1 0 -1], [1 -1]) : bolum [1 1], kalan [0 0 0]
roots([1 -5 6])          : [2 3]
polyder([1 0 -3 2])      : [3 0 -3]   (3x^2 - 3)
polyint([3 0 -3])        : [1 0 -3 0]   (x^3 - 3x, sabit 0)

polyfit(0:4, [1 2 5 10 17], 2) : [1 -2.66109e-15 1]
uydurma artigi max       : 3.77e-15

pa + pb hata verdi  : operator +: nonconformant arguments (op1 is 1x3, op2 is 1x2)
pa + [0 pb]          : [1 1 0]
polyout sonucu       : 1*x^2 + 1*x^1 + 0

Uydurulan hareket: a = -4.00 m/s^2, v0 = 6.00 m/s, y0 = 10.00 m
uydurma artigi max : 1.78e-15 m

2. derece RMSE     : 2.0900  (veriye uyum)
9. derece RMSE     : 1.8153  (egitim verisine neredeyse tam uyum)
2. derece RMSE (yeni veri): 0.9926
9. derece RMSE (yeni veri): 2.7972  <- asiri uyum burada gorunur

Yil      Tahmini fiyat (TL)
2025       171.62
2026       194.87
2027       220.20
2028       247.59
2029       277.06
egri egilimi (2025->2029): 26.36 TL/yil ortalama artis

Ozet: polyout, polyval, conv, deconv, roots, polyder, polyint, polyfit
      8 polinom fonksiyonu; 2 tuzak, 3 uygulama olculdu.
```

## Öne Çıkan Noktalar

- **Toplama tuzağı:** `p = [1 0 -1]` (x²−1) ile `q = [1 1]` (x+1) doğrudan toplanamaz; Octave
  `nonconformant arguments (op1 is 1x3, op2 is 1x2)` hatası verir (ölçüldü). Çözüm, kısa vektörün başına
  sıfır eklemek: `p + [0 q] = [1 1 0]`, yani `x² + x`.
- `deconv` kalanı tam bölmede `[0 0 0]` gibi uzun döner; sıfır olup olmadığına `any(kalan)` ile bakılır.
- `polyfit` katsayıları en küçük kareler anlamındadır; `[1 -2.66e-15 1]` çıktısı, veri tam kuadratik
  olduğu için `x² + 1` polinomunu verir (sabit terim yuvarlama artığıdır).
- **Aşırı uyum:** 9. derece polinom eğitim verisinde daha iyi (`RMSE 1.82` vs `2.09`) ama yeni veride
  belirgin biçimde kötüdür (`2.80` vs `0.99`, ölçüldü). Derece seçimi veri sayısıyla sınırlıdır.
- Hareket denklemi uydurması fiziksel olarak tutarlı: `a = -4.00 m/s²`, `v0 = 6.00 m/s`, `y0 = 10.00 m`
  (serbest düşme için beklenen işaret ve büyüklük).

## Alıştırmalar

1. `p = [1 0 -1]` polinomunu `[0 1 1]` ile toplayın; sonucu `polyout` ile yazdırıp `x² + x` olduğunu doğrulayın.
2. `roots([1 -6 11 -6])` ile kökleri bulun; `poly` fonksiyonuyla katsayılara geri dönüp artığı ölçün.
3. Ekonomik trend örneğinde dereceyi 1 ve 3 yapın; 2030 tahminlerini karşılaştırıp hangi modelin daha savunulabilir olduğunu gerekçelendirin.
