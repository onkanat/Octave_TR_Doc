
---
layout: default
title: Octave'de Temel Matris İşlemleri
---
## Octave'de Temel Matris İşlemleri

Octave, matrislerle çalışmayı kolaylaştıran birçok fonksiyon sunar. Aşağıda, en sık kullanılan bazı fonksiyonlar ve örnek kullanımları yer almaktadır:

**Matris Oluşturma:**

* **zeros(m,n):** `m x n` boyutlarında sıfırlardan oluşan bir matris oluşturur.
```octave
A = zeros(3,2);
% A = 
% 0 0
% 0 0
% 0 0
```

* **ones(m,n):** `m x n` boyutlarında birlerden oluşan bir matris oluşturur.
```octave
B = ones(4,5);
% B = 
% 1 1 1 1 1
% 1 1 1 1 1
% 1 1 1 1 1
% 1 1 1 1 1
```

* **eye(n):** `n x n` boyutlarında bir birim matrisi oluşturur.
```octave
C = eye(5);
% C = 
% 1 0 0 0 0
% 0 1 0 0 0
% 0 0 1 0 0
% 0 0 0 1 0
% 0 0 0 0 1
```

**Matris Boyutu ve Şekillendirme:**

* **size(A):** Matris `A`'nın boyutlarını bir vektör olarak döndürür.
```octave
D = magic(3);
size(D)
% ans = [3 3]
```

* **reshape(A,m,n):** Matris `A`'yı `m x n` boyutlarına yeniden şekillendirir.
```octave
E = reshape([1:9],3,3);
% E = 
% 1 2 3
% 4 5 6
% 7 8 9
```

**Matris İşlemleri:**

* **transpose(A):** Matris `A`'nın transpozunu alır.
```octave
F = rand(2,3);
G = transpose(F);
% F = 
% 0.8006    0.4221    0.7312
% 0.6749    0.9750    0.8573
% G = 
% 0.8006    0.6749
% 0.4221    0.9750
% 0.7312    0.8573
```

* **diag(A):** Matris `A`'nın diyagonalini bir vektör olarak döndürür.
```octave
H = diag([1,2,3,4,5]);
% H = 
% 1
% 0
% 0
% 0
% 5
```

* **tril(A):** Matris `A`'nın alt üçgensel kısmını oluşturur.
```octave
I = tril(magic(5));
% I = 
% 2 0 0 0 0
% 3 2 0 0 0
% 4 3 3 0 0
% 5 4 3 4 0
% 0 5 4 3 5
```

* **triu(A):** Matris `A`'nın üst üçgensel kısmını oluşturur.
```octave
J = triu(magic(5));
% J = 
% 2 3 4 5 6
% 0 3 4 5 6
% 0 0 4 5 6
% 0 0 0 5 6
% 0 0 0 0 6
```

**Lineer Cebir İşlemleri:**

* **inv(A):** Matris `A`'nın tersini alır.
```octave
K = [1 2; 3 4];
inv(K)
% ans = 
% -2 1
% 1.5 -0.5
```

* **det(A):** Matris `A`'nın determinantını hesaplar.
```octave
L = rand(3,3);
det(L)
% ans = -1.7224
```

* **eig(A):** Matris `A`'nın özdeğerlerini ve özvektörlerini bir matris olarak döndürür.
```octave
M = [1 2; 3 4];
[V,D] = eig(M);
% V = 
% 0.7071    0.7071
% -0.7071    0.7071
% D = 
% 2.0000    0.0000
% 0.0000    4.0000
```

* **svd(A):** Matris `A`'nın tekil değer ayrışımını (SVD) U, S, V matrisleri olarak döndürür.
```octave
N = rand(4,5);
[U,S,V] = svd(N);
```

**Bunlara ek olarak:**

* Matrislerin toplama, çıkarma, çarpma ve bölme işlemleri standart matematiksel operatörler kullanılarak yapılabilir.
* Matrislerin elemanlarına `A(i,j)` şeklinde erişilebilir ve değiştirilebilir.
* Belirli koşullara uyan matris elemanlarını bulmak için `find` fonksiyonu kullanılabilir.
* Daha karmaşık matris işlemleri için Octave'de birçok dahili fonksiyon mevcuttur. ([https://github.com/gnu-octave/pkg](https://github.com/gnu-octave/pkg)) adresinden daha fazla bilgi edinebilirsiniz.

**Örnek Kullanım:**

Bir lineer denklem sistemini çözmek için Octave kullanılabilir. Aşağıdaki örnekte, iki bilinmeyenli bir denklem sistemi çözülmektedir:

```octave
A = [2 3; 4 5];
b = [7; 9];
x = inv(A)*b;
x
% ans = 
% 1
% 2
```

Bu kod, `A` matrisinin tersini kullanarak `b` vektörüne göre `x` vektörünü çözer.

Octave, matrislerle çalışmayı kolaylaştıran güçlü bir araçtır. Bu temel fonksiyonları öğrenerek, Octave'i birçok bilimsel ve mühendislik problemini çözmek için kullanabilirsiniz.

---
[Ana Sayfaya Dön](./)