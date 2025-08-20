---
layout: default
title: Octave'de Polinomlar
---

## Octave'de Polinomlar

Octave'de bir polinom, katsayıları ile temsil edilir (azalan sıraya göre düzenlenmiş). Örneğin, aşağıdaki vektör:

```octave
octave:1> p = [-2, -1, 0, 1, 2];
```

şu polinomu temsil eder:

-2x⁴ - x³ + x + 2

Bunu `polyout` fonksiyonu ile kontrol edebilirsiniz:

```octave
octave:2> polyout(p, 'x')
-2*x^4 - 1*x^3 + 0*x^2 + 1*x^1 + 2
```

Bu fonksiyon, polinomu belirtilen değişkende ('x' bu durumda) görüntüler. `^` işareti, tıpkı Octave operatörü gibi "üssü" anlamına gelir.

## Polinom Fonksiyonları

### 1. Polinom Değerlendirme

```octave
y = polyval(p, x)
```

Bu, p(x) değerini döndürür. Eğer x bir vektör veya matris ise, polinom x'in her bir elemanında değerlendirilir.

**Örnek:**

```octave
p = [1, -2, 1];  % x² - 2x + 1 polinomu
x = [0, 1, 2, 3];
y = polyval(p, x)
% Sonuç: y = [1, 0, 1, 4]
```

### 2. Polinom Çarpımı

```octave
r = conv(p, q)
```

Burada `p` ve `q` iki polinomun katsayılarını içeren vektörlerdir ve sonuç `r`, onların çarpımının katsayılarını içerir.

**Örnek:**

```octave
p = [1, 2];     % x + 2
q = [1, -1];    % x - 1
r = conv(p, q)  % (x + 2)(x - 1) = x² + x - 2
% Sonuç: r = [1, 1, -2]
```

*(Bu fonksiyonun `conv` olarak adlandırılmasının nedeni, polinom çarpımı için vektör konvolüsyonu kullanmamızdır.)*

### 3. Polinom Bölümü

```octave
[b, r] = deconv(y, a)
```

Bu, şu şekilde katsayıları döndürür:

y = a·b + r

Yani `b` bölümün katsayılarını, `r` ise y ve a'nın kalanının katsayılarını içerir.

**Örnek:**
```octave
y = [1, 0, -1];  % x² - 1
a = [1, -1];     % x - 1
[b, r] = deconv(y, a)
% b = [1, 1] (x + 1), r = [0] (kalan)
```

### 4. Kök Bulma

```octave
roots(p)
```

Bu, katsayıları `p` vektöründe verilen polinomun tüm köklerini içeren bir vektör döndürür.

**Örnek:**
```octave
p = [1, -5, 6];  % x² - 5x + 6
r = roots(p)
% Sonuç: r = [3; 2] (kökler x=3 ve x=2)
```

### 5. Türev

```octave
q = polyder(p)
```

Bu, katsayıları `p` vektörü ile verilen polinomun türevinin katsayılarını döndürür.

**Örnek:**
```octave
p = [1, 0, -3, 2];  % x³ - 3x + 2
q = polyder(p)
% Sonuç: q = [3, 0, -3] (3x² - 3)
```

### 6. İntegral

```octave
q = polyint(p)
```

Bu, katsayıları `p` vektörü ile temsil edilen polinomun integralinin katsayılarını döndürür. İntegrasyon sabiti 0 olarak ayarlanır.

**Örnek:**
```octave
p = [3, 0, -3];  % 3x² - 3
q = polyint(p)
% Sonuç: q = [1, 0, -3, 0] (x³ - 3x)
```

### 7. Veri Uydurma

```octave
p = polyfit(x, y, n)
```

Bu, en küçük kareler anlamında (xᵢ, yᵢ) verilerine en iyi uyan n dereceli p(x) polinomunun katsayılarını döndürür.

**Örnek:**
```octave
x = [0, 1, 2, 3, 4];
y = [1, 2, 5, 10, 17];
p = polyfit(x, y, 2)  % 2. derece polinom uydur
% Sonuç: yaklaşık olarak x² + 1 polinomu
```

## Dikkat: Polinom Toplama

Polinomlar katsayılarının vektörleri ile temsil edildiğinden, Octave'de polinom toplama işlemi basit değildir. Örneğin, p(x) = x² - 1 ve q(x) = x + 1 polinomlarını tanımlayalım:

```octave
octave:1> p = [1, 0, -1];
octave:2> q = [1, 1];
```

Bunları toplamaya çalışırsak şu hatayı alırız:

```octave
octave:3> p + q
error: operator +: nonconformant arguments (op1 is 1x3, op2 is 1x2)
```

Bu hata oluşur çünkü Octave farklı uzunluklardaki iki vektörü (`p` ve `q`) toplamaya çalışır. Bu işlem tanımlı değildir. Bunu çözmek için `q`'ya başta bazı sıfırlar eklemeniz gerekir:

```octave
octave:4> q = [0, 1, 1];
```

Başta sıfır eklemenin polinomu değiştirmediğini unutmayın. Şimdi toplama işlemini gerçekleştirebiliriz:

```octave
octave:5> p + q
ans =
  1  1  0

octave:6> polyout(ans, 'x')
1*x^2 + 1*x^1 + 0
```

## Örnek Uygulamalar

### Örnek 1: Polinom İşlemleri
```octave
% İki polinom tanımla
p1 = [1, -2, 1];    % x² - 2x + 1
p2 = [1, 1];        % x + 1

% Çarpım
carpim = conv(p1, p2);
fprintf('Çarpım: ');
polyout(carpim, 'x')

% Bölüm
[bolum, kalan] = deconv(p1, [1, -1]);  % (x² - 2x + 1) ÷ (x - 1)
fprintf('Bölüm: ');
polyout(bolum, 'x')
fprintf('Kalan: ');
polyout(kalan, 'x')
```

### Örnek 2: Veri Uydurma
```octave
% Deneysel veri
x_data = [0, 1, 2, 3, 4, 5];
y_data = [1, 1.5, 4.2, 8.8, 16.1, 25.2];

% 2. derece polinom uydur
p = polyfit(x_data, y_data, 2);

% Sonuçları görselleştir
x_plot = 0:0.1:5;
y_fit = polyval(p, x_plot);

plot(x_data, y_data, 'o', x_plot, y_fit, '-');
legend('Veriler', 'Uydurma', 'Location', 'northwest');
xlabel('x');
ylabel('y');
title('Polinom Uydurma Örneği');
```

## Veri Uydurma (`polyfit`) İçin İleri Düzey Örnekler

`polyfit` fonksiyonu sadece basit veri setlerine değil, aynı zamanda gerçek dünya problemlerinden elde edilen verileri modellemek için de güçlü bir araçtır.

### Gerçek Dünya Verisi ile Hareket Denklemi Tahmini

Bir cismin belirli zamanlardaki konum verisini kullanarak, `polyfit` ile hareket denklemini (genellikle ikinci dereceden bir polinom) tahmin edebiliriz. Yerçekimi altındaki bir cismin konumu `y(t) = y₀ + v₀t + 0.5at²` formülü ile verilir. Bu, ikinci dereceden bir polinomdur.

```octave
% Zaman (s) ve konum (m) verileri
t = [0, 0.5, 1.0, 1.5, 2.0, 2.5]; % Zaman
y = [10, 12.5, 14.0, 14.5, 14.0, 12.5]; % Ölçülen konum

% Verilere 2. dereceden bir polinom uydur
% p(1) = 0.5*a, p(2) = v₀, p(3) = y₀
p = polyfit(t, y, 2);

% Polinom katsayılarından hareket parametrelerini tahmin et
a = 2 * p(1); % İvme
v0 = p(2);    % Başlangıç hızı
y0 = p(3);    % Başlangıç konumu

fprintf('Tahmin edilen ivme (a): %.2f m/s²
', a);
fprintf('Tahmin edilen başlangıç hızı (v₀): %.2f m/s
', v0);
fprintf('Tahmin edilen başlangıç konumu (y₀): %.2f m
', y0);

% Sonuçları görselleştir
t_fit = linspace(min(t), max(t), 100);
y_fit = polyval(p, t_fit);

plot(t, y, 'o', 'DisplayName', 'Ölçülen Veri');
hold on;
plot(t_fit, y_fit, '-', 'DisplayName', 'Uydurulan Model');
hold off;
xlabel('Zaman (s)');
ylabel('Konum (m)');
title('Hareket Denklemi Tahmini');
legend('show');
grid on;
```

### Aşırı Uyum (Overfitting) Problemi

`polyfit` kullanırken polinomun derecesini (`n`) çok yüksek seçmek, modelin verideki gürültüyü de öğrenmesine neden olabilir. Bu duruma "aşırı uyum" (overfitting) denir. Model, mevcut veriye mükemmel uyar ancak yeni verileri tahmin etmede başarısız olur.

Aşağıdaki örnekte, basit bir kuadratik ilişkiye sahip veriye hem 2. dereceden (doğru model) hem de 9. dereceden (aşırı uyum) bir polinom uyduracağız.

```octave
% Gerçek ilişki: y = 0.5x² - 2x + 3 + gürültü
x = -5:1:5;
y_gercek = 0.5*x.^2 - 2*x + 3;
y_gurultulu = y_gercek + 2.5 * randn(size(x)); % Gürültü ekle

% 2. dereceden polinom uydur (uygun model)
p2 = polyfit(x, y_gurultulu, 2);

% 9. dereceden polinom uydur (aşırı uyum)
p9 = polyfit(x, y_gurultulu, 9);

% Sonuçları görselleştirmek için daha yoğun bir x aralığı oluştur
x_plot = -5:0.1:5;
y_fit2 = polyval(p2, x_plot);
y_fit9 = polyval(p9, x_plot);

plot(x, y_gurultulu, 'ko', 'DisplayName', 'Gürültülü Veri');
hold on;
plot(x_plot, y_fit2, 'b-', 'LineWidth', 2, 'DisplayName', '2. Derece (Uygun)');
plot(x_plot, y_fit9, 'r-', 'LineWidth', 2, 'DisplayName', '9. Derece (Aşırı Uyum)');
hold off;
ylim([-5, 30]);
legend('show', 'Location', 'north');
title('Aşırı Uyum (Overfitting) Örneği');
xlabel('x');
ylabel('y');
grid on;
```
Görüldüğü gibi, 9. dereceden polinom veri noktalarından geçmek için aşırı salınımlar yaparken, 2. dereceden polinom verinin genel trendini daha iyi yakalamaktadır.

### Ekonomik Trend Modellemesi

Polinomsal regresyon, zaman içindeki ekonomik verileri (örneğin, bir ürünün fiyatı, GSYİH, vb.) modellemek ve gelecekteki eğilimleri tahmin etmek için kullanılabilir.

Aşağıda, bir ürünün son 10 yıldaki fiyat verilerini modelleyen bir örnek bulunmaktadır.

```octave
% Yıllar ve Fiyat verileri
yillar = 2015:1:2024;
fiyatlar = [50, 55, 62, 70, 80, 85, 95, 110, 130, 155];

% Verilere 2. dereceden bir polinom uydurarak trendi modelle
p_trend = polyfit(yillar, fiyatlar, 2);

% Gelecek 5 yıl için tahmin yap
gelecek_yillar = 2025:1:2029;
tahmini_fiyatlar = polyval(p_trend, gelecek_yillar);

fprintf('Gelecek yıllar için fiyat tahminleri:
');
for i = 1:length(gelecek_yillar)
    fprintf('%d yılı: %.2f TL
', gelecek_yillar(i), tahmini_fiyatlar(i));
end

% Modeli ve tahminleri görselleştir
plot(yillar, fiyatlar, 'o-', 'DisplayName', 'Geçmiş Veriler');
hold on;
plot(gelecek_yillar, tahmini_fiyatlar, 'r*--', 'DisplayName', 'Tahminler');
hold off;
xlabel('Yıl');
ylabel('Fiyat (TL)');
title('Ekonomik Trend Modellemesi ve Tahmin');
legend('show');
grid on;
```

---
[Ana Sayfaya Dön](./)