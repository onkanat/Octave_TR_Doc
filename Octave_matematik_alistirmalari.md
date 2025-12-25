---
layout: default
title: "Octave Matematik Alıştırmaları"
---

# Octave Matematik Alıştırmaları

Bu bölüm, Octave'ın temel aritmetik operatörlerini, yerleşik (intrinsic) fonksiyonlarını ve döngü yapılarını pekiştirmek için tasarlanmış matematik problemlerini ve çözümlerini içerir.

---

## 1. Faktöriyel Hesaplama (Basit)
**Problem:** Kullanıcıdan alınan bir sayının faktöriyelini hesaplayan programı yazınız.

```octave
% Kullanıcıdan girdi al
n = input('Faktöriyeli hesaplanacak sayıyı giriniz: ');

if n < 0
    disp('Negatif sayıların faktöriyeli tanımlı değildir.');
else
    faktoriyel = 1;
    for i = 1:n
        faktoriyel = faktoriyel * i;
    end
    fprintf('%d! = %d\n', n, faktoriyel);
end
```

---

## 2. İkinci Derece Denklem Kökleri (Basit)
**Problem:** Bir $ax^2 + bx + c = 0$ ikinci derece denkleminde, kullanıcıdan $a, b, c$ değerlerini alarak diskriminant ($\Delta = b^2 - 4ac$) hesabı yapan ve köklerin reel olup olmadığını belirten programı yazınız.

```octave
a = input('a değerini giriniz: ');
b = input('b değerini giriniz: ');
c = input('c değerini giriniz: ');

delta = b^2 - 4*a*c;

fprintf('Diskriminant (Delta): %.2f\n', delta);

if delta > 0
    disp('İki farklı reel kök vardır.');
elseif delta == 0
    disp('Çakışık (tek) reel kök vardır.');
else
    disp('Reel kök yoktur (kökler karmaşıktır).');
end
```

---

## 3. Aritmetik Ortalama (Orta)
**Problem:** `do-until` döngüsü kullanarak, kullanıcı 0 girene kadar sayı alan ve bu sayıların aritmetik ortalamasını ekrana basan programı yazınız.

```octave
toplam = 0;
sayac = 0;

do
    sayi = input('Bir sayı giriniz (Çıkmak için 0): ');
    if sayi ~= 0
        toplam = toplam + sayi;
        sayac = sayac + 1;
    end
until (sayi == 0)

if sayac > 0
    ortalama = toplam / sayac;
    fprintf('Girilen %d sayının ortalaması: %.2f\n', sayac, ortalama);
else
    disp('Hiç sayı girilmedi.');
end
```

---

## 4. Taylor Serisi ile Üstel Fonksiyon (Orta)
**Problem:** $e^x$ fonksiyonunun Taylor serisi açılımını ($e^x = \sum_{n=0}^{\infty} \frac{x^n}{n!}$) kullanarak, kullanıcıdan alınan bir $x$ değeri için ilk 10 terim üzerinden hesaplama yapan programı yazınız.

```octave
x = input('x değerini giriniz: ');
yaklasik_e = 0;

for n = 0:9
    terim = (x^n) / factorial(n);
    yaklasik_e = yaklasik_e + terim;
end

fprintf('Taylor serisi ile e^%.2f (10 terim): %.6f\n', x, yaklasik_e);
fprintf('Octave exp() fonksiyonu sonucu: %.6f\n', exp(x));
```

---

## 5. Matris Çarpımı (İleri)
**Problem:** İki adet $3 \times 3$ boyutundaki matrisi çarpan ve sonucu ekrana yazdıran bir Octave programı yazınız. (İç içe döngüler kullanarak).

```octave
% Örnek matrisler
A = [1, 2, 3; 4, 5, 6; 7, 8, 9];
B = [9, 8, 7; 6, 5, 4; 3, 2, 1];
C = zeros(3, 3); % Sonuç matrisi

% Matris çarpımı algoritması (Satır x Sütun)
for i = 1:3
    for j = 1:3
        for k = 1:3
            C(i,j) = C(i,j) + A(i,k) * B(k,j);
        end
    end
end

disp('A Matrisi:'); disp(A);
disp('B Matrisi:'); disp(B);
disp('A * B (Döngü ile Sonuç):'); disp(C);
disp('A * B (Doğrudan Operatör):'); disp(A * B);
```

---
[Ana Sayfaya Dön](./)
