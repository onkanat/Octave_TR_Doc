
---
layout: default
title: Octave'de Temel Matematiksel İşlemler
---
## Octave'de Temel Matematiksel İşlemler

Octave, matematiksel işlemleri gerçekleştirmek için geniş bir yelpazede yerleşik fonksiyona sahiptir. En yaygın kullanılanlardan bazılarını kategorilere ayırarak aşağıda listeledim:

**Aritmetik İşlemler:**

* `+`: Toplama
* `-`: Çıkarma
* `*`: Çarpma
* `/`: Bölme
* `^`: Üs alma

**Karmaşık Sayılar:**

* `abs`: Mutlak değer
* `conj`: Karmaşık sayının eşleniğini alma
* `polar`: Kartezyen koordinatları polar koordinatlara dönüştürme
* `rect`: Polar koordinatları Kartezyen koordinatlara dönüştürme

**Üstel ve Logaritmik İşlemler:**

* `exp`: Üstel fonksiyon
* `log`: Logaritma fonksiyonu (temel varsayılan olarak e)
* `log2`: Logaritma fonksiyonu (temel 2)
* `log10`: Logaritma fonksiyonu (temel 10)

**Yuvarlama İşlemleri:**

* `floor`: En yakın alt tam sayıya yuvarlama
* `ceil`: En yakın üst tam sayıya yuvarlama
* `round`: Yakınsamaya göre yuvarlama

**Diğer:**

* `sqrt`: Karekök alma
* `rand`: Rastgele sayı üretme
* `factorial`: Faktöriyel hesaplama

**Örnek Kullanım:**

```octave
# Toplama
2 + 3
# Çıkarma
8 - 4
# Çarpma
5 * 2
# Bölme
10 / 2
# Üs alma
2 ^ 3
# Karekök alma
sqrt(9)
# Mutlak değer
abs(-5)
# Üstel fonksiyon
exp(1)
# Logaritma (temel 10)
log10(100)
# En yakın alt tam sayıya yuvarlama
floor(3.14)
# En yakın üst tam sayıya yuvarlama
ceil(3.14)
# Yakınsamaya göre yuvarlama (bir ondalık basamak)
round(1.567, 1)
```

Bu listedeki fonksiyonlar Octave'de temel matematiksel işlemleri gerçekleştirmek için kullanılan en yaygın fonksiyonlardan sadece birkaçıdır. Daha fazla bilgi için Octave dokümantasyonuna bakabilirsiniz: [https://github.com/gnu-octave/pkg](https://github.com/gnu-octave/pkg)
