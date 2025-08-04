---
layout: default
title: "Octave'de Metin ve Dosya Çıktısı"
---

Bu belge, Octave'de metin çıktısı oluşturma ve dosyalara veri yazma işlemlerini detaylı olarak açıklar.

## `disp` Fonksiyonu

`disp` fonksiyonu, bir değişkenin değerini (skaler, vektör, matris, string vb.) ekrana yazdırır. Bu, değişken adını yazarak değerini görüntülemeye benzer, ancak değişken adı görüntülenmez.

**Örnek:**

```octave
octave:1> x = [1, 2, 3]
x =
  1  2  3

octave:2> disp(x)
  1  2  3
```

Ayrıca bir hesaplama sonucunu normal olarak önünde görünen `ans =` ifadesi olmadan görüntüleyebilirsiniz:

```octave
octave:3> log(10)
ans = 2.3026

octave:4> disp(log(10))
2.3026
```

`disp` çıktısı `format` komutuyla etkilenir:

```octave
octave:5> format long
octave:6> disp(log(10))
2.30258509299405
```

Görüntülenen değer ekrana yazdırılabilir, bir string'de saklanabilir veya `fdisp` kullanılarak dosyaya kaydedilebilir:

```octave
octave:7> s = disp(log(10))
s = 2.30258509299405
```

Burada `s`, yukarıda gösterilen karakterleri içeren bir string'dir.

## Dosya Çıktısı

`fdisp` fonksiyonu değerleri bir dosyaya kaydetmek için kullanılabilir. Bunun için önce bir dosya açmamız gerekir. Bu işlem `fopen` komutuyla yapılır.

### Dosya Açma ve Kapatma

* **`fopen(dosya_adi, mod)`** - Bir dosya açar ve onun için bir tanımlayıcı döndürür.
  * `dosya_adi` argümanı bir string'dir ve mevcut dizindeki yeni veya mevcut herhangi bir dosyanın adı olabilir.
  * `mod` argümanı dosyanın hangi amaçla açıldığını belirten bir string'dir:
    * okuma (`'r'`)
    * yazma (`'w'`)
    * ekleme (`'a'`)

Bir dosya yazma için açıldığında, içeriği silinir ve yeni verilerle değiştirilir. Mevcut verileri korumak ve dosyanın sonuna eklemek için ekleme modunu kullanın.

```octave
octave:10> file_id = fopen('verilerim.txt', 'w');
```

Burada `file_id`, Octave'e hangi dosyaya yazacağını söylemek için kullandığımız bir değişken adıdır.

* **`fdisp(file_id, deger)`** - `deger`'i `file_id` tarafından tanımlanan dosyaya yazar.

Dosyaya yazılan çıktı, `disp` komutunun çıktısıyla tamamen aynı görünecektir.

Tüm veriler yazıldıktan sonra dosyayı kapatmak önemlidir. Dosyayı kapatmak, Octave'e henüz beklemede olabilecek çıktıları sonlandırmasını söyler ve dosyayı diğer kullanıcılar veya programlar tarafından açılabilmesi için serbest bırakır.

* **`fclose(file_id)`** - `file_id` tarafından tanımlanan dosyayı kapatır.

**Örnek:**

```octave
% Dosya açma
file_id = fopen('sonuclar.txt', 'w');

% Veri yazma
x = [1 2 3; 4 5 6];
fdisp(file_id, x);
fdisp(file_id, 'Bu bir test metnidir');

% Dosyayı kapatma
fclose(file_id);
```

## `printf` Fonksiyonu

`printf` fonksiyonu `disp`'ten çok daha güçlüdür ve dolayısıyla kullanımı biraz daha karmaşıktır. `printf` ile bir değerin çıktısının tam olarak nasıl görünmesi gerektiğini tanımlayabilirsiniz. Bu şunları belirlemeyi içerir:

* Görüntülenecek anlamlı basamak sayısı
* Sayının formatı (tam sayı, gerçek sayı, bilimsel gösterim vb.)
* Değerden önce veya sonra görüntülenecek diğer çıktılar

### Ekrana, String'e veya Dosyaya Çıktı Verme

`printf` fonksiyonu çıktısını ekrana gösterir. Sonucu bir string'de almak için `sprintf`, dosyaya yazmak için `fprintf` kullanın. `fprintf`'in dosya tanımlayıcısını belirtmek için ek bir parametreye ihtiyacı olduğunu unutmayın.

* `printf(format, deger, ...)`
* `sprintf(format, deger, ...)`
* `fprintf(fid, format, deger, ...)`

Bu fonksiyonların aynı anda birden fazla değer çıktılayabileceğini unutmayın.

### Format String'i

Bir örneğe bakalım:

```octave
octave:18> x = 10.1;
octave:19> y = 5.5;
octave:20> z = 'test';
octave:21> printf('Bir tam sayı: %i. Bir gerçek sayı: %f. Bu bir %s.\n', x, y, z);
Bir tam sayı: 10. Bir gerçek sayı: 5.500000. Bu bir test.
```

Önemli kısım, 21. satırdaki `printf` fonksiyonunun ilk argümanıdır. Bu, `printf`'in çıktısının nasıl görünmesi gerektiğini belirtir. Temel olarak, yüzde işareti (`%`) o konuma bir değerin yerleştirileceğini gösterir.

Format string'inde:

```text
'Bir tam sayı: %i. Bir gerçek sayı: %f. Bu bir %s.\n'
```

* `%i` bir tam sayı ile değiştirilir
* `%f` bir gerçek sayı (f = floating point) ile değiştirilir
* `%s` bir string ile değiştirilir

Tam sayı, gerçek sayı ve string değerleri, format string'inden sonra `printf`'e argüman olarak verilir. Yukarıdaki örnekte `x` değeri 10.1'e eşittir, ancak görüntülenen değer 10'dur çünkü `printf`'in bir tam sayı görüntülemesini belirttik. Son olarak, string'in sonundaki `\n` Octave'e yeni bir satıra geçmesini söyler.

### Format Türleri

Aşağıdaki türleri destekler:

* **Tam sayı (`%i`)**
* **Gerçek sayı (`%f`)**
* **Bilimsel gösterim (`%e`)**
* **Yüzde simgesi (`%%`)**

```octave
octave:22> x = 10.34;
octave:23> printf("x gerçek bir sayıdır: %f (bilimsel gösterimde %e).\n", x, x);
x gerçek bir sayıdır: 10.340000 (bilimsel gösterimde 1.034000e+01).
octave:24> printf("Yüzdeleri %i%% şeklinde yazın.\n", x);
Yüzdeleri 10% şeklinde yazın.
```

**Notlar:**

* `%e` formatı değeri a×10^b formunda çıktılar, burada 1≤a<10 ve b bir tam sayıdır
* Satır 23'te `x` değişkeni `printf`'e iki kez verilir çünkü onu iki kez (farklı formatlarda) çıktılamak istiyoruz
* Satır 24'teki çifte yüzde (`%%`) tek bir yüzde simgesi çıktılar

### Genişlik ve Kesinlik

Çıktının şu özelliklerini belirleyerek değerlerin çıktısını daha da özelleştirebiliriz:

* **Çıktının genişliği**
* **Çıktının kesinliği**

Genişlik sayıları sağa hizalamanıza olanak tanır ve yüzde ile format belirleyici arasında belirtilir:

```octave
octave:36> x = 10;
octave:37> y = pi;
octave:38> z = 'test';
octave:39> printf("%9i\n%9f\n%9s\n", x, y, z);
       10
 3.141593
     test
```

`printf`'teki her format belirleyicisinin bir tam sayı (9) içerdiğine dikkat edin. Bu, `printf`'e tam sayı, gerçek sayı ve string'i çıktılamak için 9 sütun kullanmasını söyler.

Kesinlik parametresinin etkisi çıktı türüne bağlıdır. En belirgin kullanımı, gerçek bir sayının ondalık noktasından sonra görüntülenecek basamak sayısını belirtmektir. Kesinlik, genişlikten sonra belirtilir ve bir nokta (`.`) ile başlar:

```octave
octave:40> printf("%9.3f\n", pi);
    3.142
```

Bu π'yi 9 sütun kullanarak ve ondalık noktasından sonra 3 basamakla görüntüler. Sayının yuvarlandığını unutmayın.

### Matrisleri Çıktılama

`printf` fonksiyonuna verilen değer bir matris veya vektör olduğunda, içindeki tüm değerler yazdırılır. Format string'inde yalnızca bir format belirleyici varsa, matristeki her değer için kullanılır:

```octave
octave:51> A = [1, 2, 3; 4, 5, 6; 7, 8, 9];
octave:52> printf("%i\n", A)
1
4
7
2
5
8
3
6
9
```

Değerlerin matrisin sütun-major sırasında okunduğuna dikkat edin, yani önce ilk sütundaki tüm değerler görüntülenir, sonra ikinci sütun, vb.

Format string'inde birden fazla format belirleyici varsa, `printf` bunlar arasında döngü yapar:

```octave
octave:57> printf("[%i, %.1f, %.2e]\n", A)
[1, 4.0, 7.00e+00]
[2, 5.0, 8.00e+00]
[3, 6.0, 9.00e+00]
```

Değerler hala sütun-major sırasında okunur.

## Özet

Bu belge Octave'de metin ve dosya çıktısının temellerini kapsar:

1. **`disp`** - Basit değer görüntüleme
2. **Dosya işlemleri** - `fopen`, `fdisp`, `fclose` ile dosyaya yazma
3. **`printf` ailesi** - Gelişmiş format kontrolü ile çıktı oluşturma

Bu fonksiyonlar, Octave'de veri sonuçlarını düzenli ve okunabilir bir şekilde sunmak için temel araçlardır.

---
[Ana Sayfaya Dön](./)
