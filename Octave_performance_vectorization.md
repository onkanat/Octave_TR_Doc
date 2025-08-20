---
layout: default
title: "Octave'de Performans ve Vektörleştirme"
---

# Octave'de Performans ve Vektörleştirme

Octave, yorumlanan bir dil olduğu için, `for` döngüleri gibi yapılar C veya Fortran gibi derlenen dillere göre daha yavaş çalışabilir. Ancak Octave, matris ve vektör operasyonlarını son derece verimli bir şekilde gerçekleştirecek şekilde tasarlanmıştır. Bu nedenle, performansı artırmanın anahtarı **vektörleştirme**dir.

Vektörleştirme, `for` döngüleri yerine matris ve vektör operasyonlarını kullanarak kod yazma pratiğidir.

## Neden Vektörleştirme?

Octave'de bir `for` döngüsü çalıştığında, her bir döngü adımı yorumlayıcı tarafından ayrı ayrı işlenir. Bu, önemli bir ek yük (overhead) oluşturur. Buna karşılık, `A * B` gibi bir vektörleştirilmiş işlem, Octave'in temelindeki optimize edilmiş, derlenmiş (genellikle BLAS/LAPACK gibi) kütüphanelere tek bir çağrı ile gerçekleştirilir. Bu, binlerce kat daha hızlı olabilir.

**Örnek: Döngü ve Vektörleştirme Arasındaki Performans Farkı**

İki büyük vektörün elemanlarını tek tek çarpan bir `for` döngüsü ile, aynı işlemi `.*` operatörü ile yapan vektörleştirilmiş bir yaklaşımı karşılaştıralım.

```octave
% Büyük vektörler oluşturalım
n = 1000000;
a = rand(1, n);
b = rand(1, n);

% Yöntem 1: for döngüsü
tic; % Zamanlayıcıyı başlat
c_dongu = zeros(1, n);
for i = 1:n
    c_dongu(i) = a(i) * b(i);
end
t_dongu = toc; % Geçen süreyi al
fprintf('For döngüsü ile geçen süre: %.4f saniye\n', t_dongu);

% Yöntem 2: Vektörleştirme
tic; % Zamanlayıcıyı başlat
c_vektor = a .* b; % Eleman eleman çarpma
t_vektor = toc; % Geçen süreyi al
fprintf('Vektörleştirme ile geçen süre: %.4f saniye\n', t_vektor);

fprintf('\nHızlanma faktörü: %.2f kat\n', t_dongu / t_vektor);
```
Sonuçlar, vektörleştirilmiş yaklaşımın `for` döngüsünden ne kadar daha hızlı olduğunu açıkça gösterecektir.

## Pratik Vektörleştirme Örnekleri

Yaygın olarak kullanılan döngü tabanlı kodların nasıl vektörize edileceğini görelim.

### Örnek 1: Bir Fonksiyonu Bir Vektör Üzerinde Değerlendirme

**Döngü ile:**
```octave
x = 0:0.1:10;
y = zeros(size(x));
for i = 1:length(x)
    y(i) = sin(x(i)) * exp(-0.1*x(i));
end
```

**Vektörleştirilmiş:**
```octave
x = 0:0.1:10;
y_vektor = sin(x) .* exp(-0.1*x);
```
Octave'in matematiksel fonksiyonları (`sin`, `cos`, `exp` vb.) doğal olarak vektörleri girdi olarak kabul eder ve eleman eleman işlem yapar.

### Örnek 2: Koşullu İşlemler

Bir vektördeki negatif elemanları sıfır yapmak istediğimizi varsayalım.

**Döngü ile:**
```octave
a = randn(1, 10);
for i = 1:length(a)
    if a(i) < 0
        a(i) = 0;
    end
end
```

**Vektörleştirilmiş (Mantıksal İndeksleme ile):**
```octave
a = randn(1, 10);
a(a < 0) = 0;
```
`a < 0` ifadesi, `a` ile aynı boyutta bir mantıksal (boolean) vektör döndürür. Bu mantıksal vektör, `a`'nın hangi elemanlarının değiştirileceğini belirtmek için bir indeks olarak kullanılır. Bu, Octave'deki en güçlü vektörleştirme tekniklerinden biridir.

### Örnek 3: Kümülatif Toplam

**Döngü ile:**
```octave
x = 1:5;
kumulatif = zeros(size(x));
kumulatif(1) = x(1);
for i = 2:length(x)
    kumulatif(i) = kumulatif(i-1) + x(i);
end
```

**Vektörleştirilmiş (Dahili Fonksiyon ile):**
```octave
x = 1:5;
kumulatif_vektor = cumsum(x);
```
Octave, `cumsum` (kümülatif toplam), `cumprod` (kümülatif çarpım), `sum`, `prod` gibi birçok işlemi gerçekleştiren yerleşik, optimize edilmiş fonksiyonlara sahiptir.

**Genel Kural:** Bir işlemi bir döngü kullanarak yapmayı düşünüyorsanız, önce Octave'in bu işi yapan yerleşik bir fonksiyonu olup olmadığını kontrol edin. Varsa, neredeyse her zaman daha hızlı olacaktır.

---
[Ana Sayfaya Dön](./)
