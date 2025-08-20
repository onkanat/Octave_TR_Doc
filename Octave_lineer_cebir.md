---
layout: default
title: "Octave'de Lineer Cebir"
---

# Octave'de Lineer Cebir

Octave, lineer cebir işlemleri için kapsamlı bir fonksiyon kütüphanesi sunar. Bu rehber, en yaygın kullanılan lineer cebir fonksiyonlarını ve faktörizasyon yöntemlerini tanıtır.

## Temel Lineer Cebir Fonksiyonları

### Temel İşlemler

* **`d = det(A)`** - Matris A'nın determinantını hesaplar.

```octave
A = [1 2; 3 4];
d = det(A)
% d = -2
```

* **`lambda = eig(A)`** - A matrisinin özdeğerlerini (eigenvalues) `lambda` vektöründe döndürür.

```octave
A = [4 -2; 1 1];
lambda = eig(A)
% lambda = 
%   3 + 1i
%   3 - 1i
```

* **`[V, lambda] = eig(A)`** - Hem özvektörleri (eigenvectors) `V` matrisinde hem de özdeğerleri köşegen `lambda` matrisinde döndürür. Bu ilişki geçerlidir: `A = V*lambda*inv(V)`.

```octave
A = [4 -2; 1 1];
[V, lambda] = eig(A);
% A matrisi özvektörler ve özdeğerler cinsinden temsil edilir
```

### Matris Ters İşlemleri

* **`inv(A)`** - Tekil olmayan (non-singular) A matrisinin tersini hesaplar.

**Not:** Tersini hesaplamak genellikle gerekli değildir. Aşağıdaki operatörleri örnekler olarak inceleyin. Teoride `A*inv(A)` birim matrisi döndürmelidir, ancak pratikte yuvarlama hataları nedeniyle sonuç tam olmayabilir.

```octave
A = [2 1; 1 1];
A_inv = inv(A);
% A_inv = 
%   1  -1
%  -1   2
```

* **`A / B`** - X'i şu şekilde hesaplar: `X*B = A`. Bu sağ bölme olarak adlandırılır ve B'nin tersini oluşturmadan yapılır.

* **`A \ B** - X'i şu şekilde hesaplar: `A*X = B`. Bu sol bölme olarak adlandırılır ve A'nın tersini oluşturmadan yapılır.

```octave
A = [2 1; 1 3];
B = [1; 2];
X = A \ B;  % A*X = B denklemini çözer
% X = 
%   0.2
%   0.6
```

### Norm ve Rank İşlemleri

* **`norm(A, p)`** - Matris (veya vektör) A'nın p-normunu hesaplar. İkinci argüman isteğe bağlıdır, varsayılan değer p=2'dir.

```octave
A = [3 4];
norm(A)      % 2-norm (Euclidean norm) = 5
norm(A, 1)   % 1-norm = 7
norm(A, inf) % Infinity norm = 4
```

* **`rank(A)`** - Bir matrisin (sayısal) rankını hesaplar.

```octave
A = [1 2 3; 4 5 6; 7 8 9];
r = rank(A)
% r = 2 (çünkü üçüncü satır diğer ikisinin lineer kombinasyonu)
```

### Diğer Temel Fonksiyonlar

* **`trace(A)`** - A matrisinin izini (köşegen elemanlarının toplamı) hesaplar.

```octave
A = [1 2 3; 4 5 6; 7 8 9];
tr = trace(A)
% tr = 15 (1 + 5 + 9)
```

* **`expm(A)`** - Kare matrisin matris üstelini hesaplar. Bu şu şekilde tanımlanır:

  ```text
  I + A + A²/2! + A³/3! + ...
  ```

```octave
A = [0 1; -1 0];
exp_A = expm(A);
% Rotasyon matrisi elde edilir
```

* **`logm(A)`** - Kare matrisin matris logaritmasını hesaplar.

* **`sqrtm(A)`** - Kare matrisin matris karekökünü hesaplar.

### Ek Lineer Cebir Fonksiyonları

Daha fazla bilgi için `help` komutunu kullanabilirsiniz:

* **`balance`** - Özdeğer dengeleme
* **`cond`** - Koşul sayısı
* **`dmult`** - `diag(x) * A`'yı verimli şekilde hesaplar
* **`dot`** - Nokta çarpım
* **`givens`** - Givens rotasyonu
* **`kron`** - Kronecker çarpımı
* **`null`** - Null uzayının ortonormal tabani
* **`orth`** - Menzil uzayının ortonormal tabani
* **`pinv`** - Sözde ters (pseudoinverse)
* **`syl`** - Sylvester denklemini çözer

## Faktörizasyonlar

### Temel Faktörizasyonlar

* **`R = chol(A)`** - Simetrik pozitif tanımlı A matrisinin Cholesky faktörizasyonunu hesaplar. Yani `R'*R = A` olacak şekilde üst üçgensel R matrisini bulur.

```octave
A = [4 2; 2 3];
R = chol(A);
% R = 
%   2.0000   1.0000
%   0        1.4142
```

* **`[L, U] = lu(A)`** - A'nın LU ayrışımını hesaplar. L alt üçgensel, U üst üçgensel ve `A = L*U`.

```octave
A = [2 1 1; 4 3 3; 8 7 9];
[L, U] = lu(A);
% L alt üçgensel, U üst üçgensel matrisler
```

* **`[Q, R] = qr(A)`** - A'nın QR ayrışımını hesaplar. Q ortogonal, R üst üçgensel ve `A = Q*R`.

```octave
A = [1 2; 3 4; 5 6];
[Q, R] = qr(A);
% Q ortogonal matris, R üst üçgensel matris
```

### Ek Faktörizasyonlar

Daha fazla bilgi için `help` komutunu kullanabilirsiniz:

* **`qz`** - Genelleştirilmiş özdeğer problemi: QZ ayrışımı
* **`qzhess`** - Hessenberg-üçgensel ayrışım
* **`schur`** - Schur ayrışımı
* **`svd`** - Tekil değer ayrışımı (Singular Value Decomposition)
* **`housh`** - Householder yansımaları
* **`krylov`** - Blok Krylov alt uzayının ortogonal tabani

## Pratik Örnekler

### Lineer Denklem Sistemi Çözme

```octave
% Ax = b denklem sistemini çözelim
A = [2 1 -1; -3 -1 2; -2 1 2];
b = [8; -11; -3];

% Sol bölme kullanarak çözelim (önerilen yöntem)
x = A \ b;

% Sonucu kontrol edelim
kontrol = A * x - b;  % Sıfıra yakın olmalı
```

### Özdeğer ve Özvektör Analizi

```octave
% Simetrik matris için özdeğer analizi
A = [6 2 1; 2 3 1; 1 1 1];

% Özdeğerler ve özvektörler
[V, lambda] = eig(A);

% Özdeğerleri büyükten küçüğe sırala
[d, ind] = sort(diag(lambda), 'descend');
V_sorted = V(:, ind);

fprintf('En büyük özdeğer: %.4f\n', d(1));
```

### SVD ile Matris Analizi

```octave
% Tekil değer ayrışımı örneği
A = [1 2 3; 4 5 6; 7 8 9; 10 11 12];

[U, S, V] = svd(A);

% Rank ve koşul sayısı
r = rank(A);
cond_num = cond(A);

fprintf('Matris ranki: %d\n', r);
fprintf('Koşul sayısı: %.2e\n', cond_num);
```

## Performans İpuçları

1. **Matris tersini hesaplamaktan kaçının**: `inv(A)*b` yerine `A\b` kullanın.
2. **Uygun faktörizasyon seçin**: Büyük sparse matrisler için uygun yöntemleri kullanın.
3. **Koşul sayısını kontrol edin**: Kötü koşullanmış matrislerle dikkatli olun.

```octave
% İyi pratik örneği
A = rand(1000);
b = rand(1000, 1);

% Yavaş yöntem: x = inv(A) * b;
% Hızlı yöntem:
x = A \ b;
```

## İleri Düzey Uygulama Örnekleri

Bu bölümde, lineer cebirin gerçek dünya problemlerine nasıl uygulandığını gösteren daha karmaşık örnekler sunulmaktadır.

### Elektrik Devresi Analizi (Kirchhoff Yasaları)

Kirchhoff'un akım ve gerilim yasaları, lineer denklem sistemleri kurarak elektrik devrelerini analiz etmek için kullanılır. Kirchhoff'un Gerilim Yasası (KVL) ile iki döngülü bir devrenin denklemleri aşağıdaki gibi oluşturulabilir:

- **Döngü 1:** `V_kaynak = (R1+R2)*I1 - R2*I2`
- **Döngü 2:** `0 = -R2*I1 + (R2+R3)*I2`

Bu denklemler matris formunda `A*x = b` olarak ifade edilebilir, burada `x` akım vektörü `[I1; I2]`'dir.

```octave
% Direnç değerleri
R1 = 2; % Ohm
R2 = 5; % Ohm
R3 = 3; % Ohm
V_kaynak = 10; % Volt

% KVL denklemlerinden A matrisi ve b vektörü
A = [R1+R2, -R2; -R2, R2+R3];
b = [V_kaynak; 0];

% Akımları (I1, I2) çözmek için sol bölme kullanılır
I = A \ b;

fprintf('Döngü 1 Akımı (I1): %.2f A\n', I(1));
fprintf('Döngü 2 Akımı (I2): %.2f A\n', I(2));

% Devredeki diğer değerler de hesaplanabilir
% Örneğin R2 üzerindeki gerilim:
V_R2 = R2 * (I(1) - I(2));
fprintf('R2 üzerindeki gerilim: %.2f V\n', V_R2);
```

### Köprü Denge Denklemleri

Basit bir kafes kiriş (truss) köprünün denge denklemleri, her bir düğümdeki kuvvetlerin toplamının sıfır olması prensibine dayanır. Bu, lineer denklem sistemleri ile modellenebilir.

Örneğin, her bir çubuktaki gerilme kuvvetlerini (T) bulmak için her düğümdeki x ve y yönündeki kuvvetleri dengeleyen denklemler yazılır. Bu denklemler `A*T = F` şeklinde bir matris denklemine dönüştürülür, burada `F` dış kuvvetleri temsil eder.

```octave
% Bu örnek semboliktir ve belirli bir köprü geometrisine dayanmaz.
% Gerçek bir problemde A matrisi, çubukların açılarına ve
% düğümlere nasıl bağlandığına göre oluşturulur.

% 2 düğüm ve 3 çubuklu basit bir sistem varsayalım
% A matrisi geometriye göre belirlenir
A = [cosd(45), 1; sind(45), 0];
% F vektörü dış kuvvetleri temsil eder (örneğin 1000N dikey yük)
F = [0; 1000];

% Çubuklardaki gerilme kuvvetlerini (T1, T2) hesapla
T = A \ F;

fprintf('Çubuk 1''deki gerilme kuvveti: %.2f N\n', T(1));
fprintf('Çubuk 2''deki gerilme kuvveti: %.2f N\n', T(2));
```

### Markov Zincirleri ile Hava Durumu Tahmini

Markov zincirleri, bir durumdan diğerine geçiş olasılıklarını modellemek için kullanılır. Örneğin, bir günün "Güneşli" veya "Bulutlu" olma olasılığını, bir önceki günün hava durumuna göre tahmin edebiliriz.

Geçiş Matrisi `P`, bir durumdan diğerine geçiş olasılıklarını içerir. `P(i, j)`, durum `j`'den durum `i`'ye geçme olasılığıdır.

Diyelim ki geçiş matrisimiz şöyle olsun:
- Güneşli -> Güneşli: 0.9
- Güneşli -> Bulutlu: 0.1
- Bulutlu -> Güneşli: 0.5
- Bulutlu -> Bulutlu: 0.5

```octave
% Geçiş Matrisi P (sütunlar bugünü, satırlar yarını temsil eder)
% Sütun 1: Bugün Güneşli ise... Satır 1: Yarın Güneşli, Satır 2: Yarın Bulutlu
% Sütun 2: Bugün Bulutlu ise... Satır 1: Yarın Güneşli, Satır 2: Yarın Bulutlu
P = [0.9, 0.5;
     0.1, 0.5];

% Başlangıç durumu: Bugün Güneşli (%100 olasılık)
% Durum vektörü: [Güneşli; Bulutlu]
x0 = [1; 0];

% 1 gün sonraki hava durumu olasılığı
x1 = P * x0;
fprintf('1 gün sonra Güneşli olma olasılığı: %.2f\n', x1(1));
fprintf('1 gün sonra Bulutlu olma olasılığı: %.2f\n', x1(2));

% 7 gün sonraki hava durumu olasılığı
x7 = P^7 * x0;
fprintf('7 gün sonra Güneşli olma olasılığı: %.2f\n', x7(1));
fprintf('7 gün sonra Bulutlu olma olasılığı: %.2f\n', x7(2));

% Kararlı durum (steady state) dağılımını bulma
% Bu, P'nin 1'e eşit olan özdeğerine karşılık gelen özvektördür.
[V, lambda] = eig(P);
% Özdeğerlerin 1'e en yakın olduğu sütunu bul
[~, idx] = min(abs(diag(lambda) - 1));
steady_state_vector = V(:, idx);
% Olasılıkların toplamı 1 olacak şekilde normalize et
steady_state_vector = steady_state_vector / sum(steady_state_vector);

fprintf('\nUzun vadede (kararlı durumda):\n');
fprintf('Güneşli bir gün olma olasılığı: %.2f\n', steady_state_vector(1));
fprintf('Bulutlu bir gün olma olasılığı: %.2f\n', steady_state_vector(2));
```

---

[Ana Sayfaya Dön](./)