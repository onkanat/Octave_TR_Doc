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

* **`A \ B`** - X'i şu şekilde hesaplar: `A*X = B`. Bu sol bölme olarak adlandırılır ve A'nın tersini oluşturmadan yapılır.

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

---

[Ana Sayfaya Dön](./)
