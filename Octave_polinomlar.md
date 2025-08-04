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

---
[Ana Sayfaya Dön](./)
