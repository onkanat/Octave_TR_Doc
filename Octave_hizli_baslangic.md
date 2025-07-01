---
layout: default
title: "10 Dakikada Octave'a Hızlı Başlangıç"
---

## 10 Dakikada Octave'a Hızlı Başlangıç

Bu rehber, Octave'a hızlı bir başlangıç yapmak için temel bilgileri içerir.

### 1. Temel Matematiksel İşlemler

Octave'i basit bir hesap makinesi gibi kullanabilirsiniz.

```octave
# Toplama
2 + 3   # Sonuç: 5

# Çıkarma
8 - 4   # Sonuç: 4

# Çarpma
5 * 2   # Sonuç: 10

# Bölme
10 / 2  # Sonuç: 5

# Üs alma
2^3     # Sonuç: 8

# Karekök
sqrt(16) # Sonuç: 4
```

### 2. Değişkenler

Değerleri daha sonra kullanmak için değişkenlerde saklayabilirsiniz.

```octave
x = 10
y = 5
z = x * y  # z'nin değeri 50 olacaktır
```

### 3. Matris ve Vektör Oluşturma

Octave'in en güçlü yanı matrislerle çalışabilmesidir.

#### Vektörler

```octave
# Satır vektörü
v = [1, 2, 3, 4, 5]

# Sütun vektörü
u = [1; 2; 3; 4; 5]
```

#### Matrisler

```octave
# 2x3'lük bir matris
A = [1, 2, 3; 4, 5, 6]
```

### 4. Özel Matrisler Oluşturma

Sık kullanılan matrisleri kolayca oluşturabilirsiniz.

```octave
# 3x2'lik sıfır matrisi
S = zeros(3, 2)

# 4x5'lik birler matrisi
B = ones(4, 5)

# 5x5'lik birim matris
I = eye(5)
```

### 5. Matris İşlemleri

```octave
A = [1, 2; 3, 4]
B = [5, 6; 7, 8]

# Toplama
C = A + B

# Çarpma (Matris çarpımı)
D = A * B

# Transpoz
A_transpoz = A'  # veya transpose(A)

# Tersini alma
A_tersi = inv(A)
```

### 6. Yardım Alma

Bir fonksiyon hakkında bilgi almak için `help` komutunu kullanabilirsiniz.

```octave
help inv
```

Bu temel bilgilerle Octave'i kullanmaya başlayabilirsiniz. Daha karmaşık işlemler ve fonksiyonlar için Octave dokümantasyonunu inceleyebilirsiniz.

---

[Ana Sayfaya Dön](./)
