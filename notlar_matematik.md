---
layout: default
title: "Octave Çalışma Notları: Kombinatorik, Matematik ve ODE"
lang: tr
konu: temel
seviye: ileri
tur: ders
kod: notlar_matematik.m
redirect_from: [/Octave_Calisma_Notlari_Matematik.html]
---

# Octave Çalışma Notları: Kombinatorik, Matematik ve ODE

Bu belge, "Çalışma Notları"nın matematik kolunu toplar: dize kombinasyonlarından tekrarlı
permütasyonlara, tam sayı/parite testlerinden parametreli fonksiyon ailelerine ve ODE
çözümünden cebirsel değişken tablosuna kadar yedi tarif. Sayfadaki çıktı bloğu, tariflerin
`notlar_matematik.m` içinde birleştirilmiş hâlinin **ölçülmüş** koşusudur (GNU Octave 11.3.0).

## Ne öğreneceksiniz

- `nchoosek` sayısal giriş beklediği için dizeyi `uint8`'e çevirip sonucu `char` ile geri almayı
- `ndgrid` ile tekrarlı permütasyon üretmeyi ve `nthargout` ile değişken sayıda çıktı toplamayı
- Tam sayı testini (`fix(x) == x`) ve parite testini (`mod`) negatif sayı / `NaN` sınırlarında
  yorumlamayı
- Parametreli fonksiyon ailesini anonim fonksiyonla `lsode`'a vermeyi (`k` kapsamdan "donar")
- Noktalar arası mesafe matrisini yayın (broadcasting) özelliğiyle, döngüyü bileşen sayısı
  üzerinde tutarak hesaplamayı
- ODE çözücüsünün ikinci çıktısını kullanarak türev olmayan (cebirsel) değişkeni tablolamayı

## Çalıştırma

```sh
octave --no-gui notlar_matematik.m
```

Betik reponun kökünde ve tek başına koşar; ek paket yüklemez, dosya yazmaz, grafik çizmez.
`lsode` çekirdektedir, `ode45` gerekmez. Bu makinede `octave --no-gui` Qt/cocoa eklentisi
yüzünden betiği yüklemeden düşüyor (**EXIT=134**); sayfadaki blok aynı çıktıyı veren
`octave-cli` ile ölçüldü.

## Kod

### Dize Karakterleriyle Kombinasyonlar

**Sorun:** Farklı harflerin tüm kombinasyonlarını almak istiyorsunuz ancak `nchoosek` yalnızca
sayısal girişi kabul ediyor.

**Çözüm:** Dizenizi önce sayılara, sonra tekrar karakterlere dönüştürün.

```octave
string = "Merhaba";
n = 4;
char(nchoosek(uint8(string), n))
```

**Tartışma:** Octave'deki bir dize, yalnızca bir karakter matrisidir ve sayısal biçime kolayca
dönüştürülebilir. Her karakterin ilişkili bir numarası vardır (`ascii` paketinin `table`
işlevi, güzel biçimlendirilmiş bir dönüştürme tablosu görüntüler). Betiğin `[1]` bölümü
`"Merhaba"` için `35` kombinasyon üretir ve ilk üçünü yazdırır.

### Tekrarlı Permütasyonlar

**Sorun:** Tekrarlı bir vektörün tüm olası permütasyonlarını üretmek istiyorsunuz.

**Çözüm:** `ndgrid` kullanın:

```octave
[x, y, z] = ndgrid([1, 2, 3, 4, 5]);
[x(:), y(:), z(:)]
```

**Tartışma:** Yukarıdaki kodu genişletip herhangi bir uzunluktaki permütasyonlar için
çalışmasını sağlamak mümkündür.

```octave
sepet = nthargout([1:n], @ndgrid, vector);
combs = cell2mat(cellfun(@(c) c(:), sepet, "UniformOutput", false));
```

Betik ölçüm için `ndgrid([1, 2, 3])` kullanır: `27` üçlü üretir, `ndgrid` çıktısının ilk boyutu
en yavaş değişen boyuttur (`[1 1 1; 2 1 1; 3 1 1; …]`).

### Bir Sayının Tam Sayı Olup Olmadığını Test Edin

En basit yöntem muhtemelen `fix` kullanmaktır:

```octave
fix(x) == x
```

### Bir Sayının Çift/Tek Olup Olmadığını Bulun

**Sorun:** Elinizde bir sayı, dizi veya matris var ve bunlardan herhangi birinin tek veya çift
sayı olup olmadığını, yani paritelerini bilmek istiyorsunuz.

**Çözüm:** İkiye bölme işleminin kalanını kontrol edin. Kalan sıfırsa, sayı çifttir.

```octave
mod(değer, 2)   ## Tek ise 1, çift ise sıfır
```

`mod` bir matris kabul ettiğinden aşağıdakiler yapılabilir:

```octave
any(mod(değerler, 2))   ## değerlerdeki en az bir sayı tekse doğru
all(mod(değerler, 2))   ## değerlerdeki tüm sayılar tekse doğru

any(!logical(mod(değerler, 2)))   ## değerlerdeki en az bir sayı çift ise doğru
all(!logical(mod(değerler, 2)))   ## değerlerdeki tüm sayılar çift ise doğru
```

**Tartışma:** Bir bölme işleminin kalanını kontrol ettiğimiz için ilk tercih `rem` kullanmak
olacaktır. Ancak, negatif sayılar söz konusu olduğunda `mod` yine de pozitif bir sayı
döndüreceğinden karşılaştırmaları kolaylaştırır. Diğer bir alternatif ise `bitand(X, 1)` veya `bitget(X, 1)` kullanmaktır, ancak bunlar biraz daha yavaştır.

Ölçüm: `mod(-3, 2) = 1`, `rem(-3, 2) = -1` — negatif sayıda `mod` pozitif kalır.

Bu çözümün yalnızca tam sayılar için geçerli olduğunu unutmayın. `0.5` veya `4.20` gibi tam sayı
olmayanlar ne çift ne de tektir. Sayıların kaynağı bilinmiyorsa (örneğin kullanıcı girişi), tam sayı olmayan değerler, `NaN`, `Inf` için bir tür kontrol uygulanmalıdır. Ölçüm: `mod(3.5, 2) = 1.5` — ne çift ne tek.

### Parametreli Fonksiyonlar

**Sorun:** Bazen bir dizi parametreye bağlı olarak bir fonksiyon ailesi tanımlamanız gerekir, örneğin:

$f(x,y,z;a,b,c)$

Neresi $x,y,z$ fonksiyonun üzerinde çalıştığı değişkenleri belirtir ve $a,b,c$ fonksiyon ailesinin belirli bir elemanını seçmek için kullanılan parametrelerdir.

Örneğin, yay sabitinin ($k$) farklı değerleri için bir yaydaki uzamanın zaman içindeki evrimini
hesaplamamız gerektiğini varsayalım.

**Çözüm:** Yay sabitinin farklı değerleri için yay denklemini çözmek amacıyla aşağıdaki kodu
kullanarak problemi çözebiliriz:

```octave
t = linspace(0, 10, 100);

function sprime = spring(s, t, k)
  x = s(1);
  v = s(2);
  sprime(1) = v;
  sprime(2) = -k * x;
endfunction

k = 1;
x1 = lsode(@(x, t) spring(x, t, k), [1; 0], t)(:, 1);
k = 2;
x2 = lsode(@(x, t) spring(x, t, k), [1; 0], t)(:, 1);

plot(t, x1, t, x2)
legend('x1', 'x2')
```

**Tartışma:** Yukarıdaki örnekte, `sprime` fonksiyonu $x,t$ değişkenlerinin bir fonksiyon ailesini temsil eder ve $k$ parametresi ile parametrelendirilmiştir. Anonim fonksiyon `@(x, t) sprime(x, t, k)` sadece $x,t$ değişkenlerinin bir fonksiyonudur, burada $k$ parametresi mevcut kapsamdaki değerine "dondurulmuştur".

Ölçüm (`[4]`): `k = 1` için periyot `6,2832 s`, `k = 2` için `4,4429 s` (`2π/√k`).

![Parametreli Fonksiyon Çözümü](https://wiki.octave.org/images/2/26/Solparfun.png)

### Noktalar Arasındaki Mesafe

**Sorun:** Uzayda belirli bir nokta kümesi verildiğinde, bu noktaların arasındaki mesafeyi hesaplamak istiyoruz. Her nokta, bileşenleriyle $(x_i, y_i, \ldots)$ tanımlanıyor. Noktaların, satırları (her nokta için bir tane) ve sütunları (her bileşen için bir tane) olan bir $m \times n$ matrisinde (`P`) kaydedildiğini varsayalım.

**Çözüm:** Bir yol, GNU Octave'deki operatörlerin yayın özelliklerini kullanmaktır. Noktalar
arasındaki kare mesafe şu kodla hesaplanabilir:

```octave
[m, n] = size(P);
Dsq = zeros(m);
for i = 1:n
  Dsq += (P(:, i) - P(:, i)').^2;
endfor
```

Bu matris, köşegeni sıfır olan simetrik bir matristir. Benzer şekilde bir noktadan diğerine
işaret eden vektörler:

```octave
R = zeros(m, m, n);
for i = 1:n
  R(:,:,i) = P(:, i) - P(:, i)';
endfor
```

`Dsq` ve `R` arasındaki ilişki: `Dsq = sumsq(R, 3);`

**Tartışma:** Hesaplama, `cellfun` gibi fonksiyonlar kullanılarak gerçekleştirilebilir; böylece
noktaların bileşenleri üzerinde döngü oluşması önlenir. Ancak çoğu durumda, bileşenlerden daha
fazla noktamız olur ve iyileştirme, varsa, minimum düzeyde olur.

Bir diğer gözlem ise `Dsq` matrisinin simetrik olması ve yalnızca alt veya üst üçgensel kısmı
saklayabilmemizdir. Bu optimizasyonu pratik bir şekilde kullanmak için `vech` ve `unvech`
fonksiyonlarının yardımına bakın (bu, Forge paketinin genel versiyonunda bulunur). Henüz gün
yüzüne çıkmamış iki fonksiyon, `sub2ind_tril` ve `ind2sub_tril`'dir (şu anda Forge paketinin
mekaniklerinde özel fonksiyonlar). Bunlar, `vech` fonksiyonuyla oluşturulmuş bir vektörün
elemanlarını indekslemek için kullanışlıdır. `R` çok boyutlu dizisinin her sayfası (üçüncü
indeks) antisimetrik bir matristir ve üçgensel alt matrislerden yalnızca birini saklayarak
bellekten tasarruf edebiliriz. Çok daha fazla mesafe fonksiyonu (noktalar, doğrular, çokgenler,
vb.) için **Geometri** paketini kontrol edin.

### ODE Durum Değişkenlerinden Cebirsel Değişkenleri Bulun

**Sorun:** Bir dizi ODE'de zaman `t`'nin bir fonksiyonu olarak durum değişkenleri `x`'i bulmak
için `lsode` veya başka bir ODE çözücüsü kullanıldığında, türevler dışında durum değişkenleri
`x` ve zaman `t`'nin bir fonksiyonu olan cebirsel değişkenler `y`'yi döndürmenin ve tablolaştırmanın
basit bir yolu yok gibi görünüyor.

Yukarıda "Parametreli Fonksiyonlar" bölümünde tanımlanan yay fonksiyonunun değiştirilmiş bir
versiyonunu ele alalım:

```octave
function sprime = dspring(s, t)
  k = 1;
  tau = 1;
  x = s(1);
  v = s(2);
  y = x + v * tau;
  sprime(1) = v;
  sprime(2) = -k * y;
endfunction
```

Bu fonksiyonu ve `lsode`'u yalnızca `x` ve `sprime` elemanlarını değil, aynı zamanda (diyelim ki)
`y`'yi zamanın bir fonksiyonu olarak tablolaştırmak için kullanmanın bir yolu ne olabilir?

**Çözüm:** `sprime` fonksiyonunu ikinci argüman olarak `y`'yi döndürecek şekilde değiştirin:

```octave
function [sprime, y] = dspring(s, t)
  k = 1;
  tau = 1;
  x = s(1);
  v = s(2);
  y = x + v * tau;
  sprime(1) = v;
  sprime(2) = -k * y;
endfunction
```

`lsode` ikinci dönüş argümanı `y`'yi memnuniyetle göz ardı edecektir, ancak `x` tablo haline
getirildikten sonra, `y`, bir `for` döngüsünde yay fonksiyonunun ikinci dönüş argümanı
kullanılarak tablo haline getirilebilir, örneğin:

```octave
t = linspace(0, 10, 100);
x = lsode('dspring', [1; 0], t);
y = zeros(length(t), 1);
for i = 1:length(t)
  [xtmp, y(i, 1)] = dspring(x(i, :), t(i));
endfor
```

**Tartışma:** Bu, tek cebirsel değişkenli basit bir örnektir. `y` dizisinin ikinci boyutunu
genişleterek başka değişkenler de eklenebilir. Betik çözücüyü ad yerine tutamaçla
(`lsode(@dspring, …)`) çağırır — betik içinde tanımlı yerel fonksiyonlar adla çözülmeyebilir.

### Betik

Aşağıdaki betik dosyanın tamamıdır (`kod: notlar_matematik.m`).

```octave
clear; clc; close all;
1;

%% 0. Hazirlik
warning("off", "all");

%% Yerel fonksiyonlar: parametreli yay denklemi ve cebirsel degisken
function sprime = spring(s, t, k)
  % s(1) = konum, s(2) = hiz; k yay sabiti parametredir
  x = s(1); v = s(2);
  sprime(1) = v;
  sprime(2) = -k * x;
end

function [sprime, y] = dspring(s, t)
  % Durum turevleri + turev olmayan cebirsel degisken y
  k = 1; tau = 1;
  x = s(1); v = s(2);
  y = x + v * tau;
  sprime(1) = v;
  sprime(2) = -k * y;
end

%% 1. Dize karakterleriyle kombinasyonlar (nchoosek)
dize = "Merhaba";
n = 4;
kombinasyonlar = char(nchoosek(uint8(dize), n));
printf("[1] \"%s\" icinden %d karakter: %d kombinasyon\n", dize, n, rows(kombinasyonlar));
for i = 1:3
  printf("[1]   %s\n", kombinasyonlar(i, :));
end

%% 2. Tekrarli permutasyonlar (ndgrid)
[x, y, z] = ndgrid([1, 2, 3]);
ucay = [x(:), y(:), z(:)];
printf("[2] ndgrid ile %d uclu (%dx%dx%d)\n", rows(ucay), 3, 3, 3);
printf("[2]   ilk 5: %s\n", mat2str(ucay(1:5, :)));
printf("[2]   son 2: %s\n", mat2str(ucay(end-1:end, :)));

%% 3. Tam sayi ve parite testleri
degerler = [4, 7, 3.5];
printf("[3] tam sayi testi fix(x) == x: %s\n", mat2str(fix(degerler) == degerler));
printf("[3] mod(x, 2) (tek -> 1):       %s\n", mat2str(mod(degerler, 2)));
printf("[3] any(mod(x,2)) = %d, all(mod(x,2)) = %d\n", ...
       any(mod(degerler, 2)), all(mod(degerler, 2)));
printf("[3] negatif sayida mod: mod(-3, 2) = %d (rem(-3, 2) = %d)\n", ...
       mod(-3, 2), rem(-3, 2));

%% 4. Parametreli fonksiyon ailesi: lsode ile iki yay sabiti
t = linspace(0, 10, 100);
for k = [1, 2]
  xk = lsode(@(s, tt) spring(s, tt, k), [1; 0], t)(:, 1);
  printf("[4] k = %d: x(0) = %.4f, x(10) = %+.4f, periyot 2*pi/sqrt(k) = %.4f s\n", ...
         k, xk(1), xk(end), 2*pi/sqrt(k));
end
printf("[4] ayni fonksiyon ailesi, iki parametre: tek tanim, iki cozum\n");

%% 5. Noktalar arasindaki mesafe (yayin ozelligi ile)
P = [0, 0; 3, 4; 6, 0];      % her satir bir nokta, her sutun bir bilesen
[m, nn] = size(P);
Dsq = zeros(m);
for i = 1:nn
  Dsq += (P(:, i) - P(:, i)').^2;
end
printf("[5] %d nokta, %d bilesen; kare mesafe matrisi:\n", m, nn);
disp(Dsq);
printf("[5] uzaklik matrisi:\n");
disp(sqrt(Dsq));

%% 6. ODE durum degiskenlerinden cebirsel degisken tablosu
x_tab = lsode(@dspring, [1; 0], t);
y_tab = zeros(length(t), 1);
for i = 1:length(t)
  [xtmp, y_tab(i, 1)] = dspring(x_tab(i, :), t(i));
end
printf("[6] cebirsel degisken y = x + v*tau, dspring'in 2. cikisi ile tablo:\n");
for i = [1, 25, 50, 75, 100]
  printf("[6]   t = %5.2f  x = %+.4f  v = %+.4f  y = %+.4f\n", ...
         t(i), x_tab(i,1), x_tab(i,2), y_tab(i));
end

%% Ozet
printf("\nOzet: %d kombinasyon, %d uclu permutasyon, iki parametreli yay cozumu,\n", ...
       rows(kombinasyonlar), rows(ucay));
printf("      %dx%d mesafe matrisi ve cebirsel degisken tablosu olculdu.\n", m, m);
```

## Beklenen Çıktı

```
[1] "Merhaba" icinden 4 karakter: 35 kombinasyon
[1]   Merh
[1]   Mera
[1]   Merb
[2] ndgrid ile 27 uclu (3x3x3)
[2]   ilk 5: [1 1 1;2 1 1;3 1 1;1 2 1;2 2 1]
[2]   son 2: [2 3 3;3 3 3]
[3] tam sayi testi fix(x) == x: [true true false]
[3] mod(x, 2) (tek -> 1):       [0 1 1.5]
[3] any(mod(x,2)) = 1, all(mod(x,2)) = 0
[3] negatif sayida mod: mod(-3, 2) = 1 (rem(-3, 2) = -1)
[4] k = 1: x(0) = 1.0000, x(10) = -0.8391, periyot 2*pi/sqrt(k) = 6.2832 s
[4] k = 2: x(0) = 1.0000, x(10) = -0.0050, periyot 2*pi/sqrt(k) = 4.4429 s
[4] ayni fonksiyon ailesi, iki parametre: tek tanim, iki cozum
[5] 3 nokta, 2 bilesen; kare mesafe matrisi:
    0   25   36
   25    0   25
   36   25    0
[5] uzaklik matrisi:
   0   5   6
   5   0   5
   6   5   0
[6] cebirsel degisken y = x + v*tau, dspring'in 2. cikisi ile tablo:
[6]   t =  0.00  x = +1.0000  v = +0.0000  y = +1.0000
[6]   t =  2.42  x = -0.0017  v = -0.2967  y = -0.2984
[6]   t =  4.95  x = -0.0790  v = +0.0885  y = +0.0095
[6]   t =  7.47  x = +0.0260  v = -0.0052  y = +0.0208
[6]   t = 10.00  x = -0.0022  v = -0.0054  y = -0.0076

Ozet: 35 kombinasyon, 27 uclu permutasyon, iki parametreli yay cozumu,
      3x3 mesafe matrisi ve cebirsel degisken tablosu olculdu.
```

## Öne Çıkan Noktalar

- **`nchoosek` sayı ister:** `"Merhaba"` (7 karakter) içinden 4'lü seçim `35` kombinasyon verir
  (`C(7,4) = 35`). Sonuç `uint8` matrisidir, `char(...)` ile okunur hâle gelir.
- **`ndgrid` sırası:** ilk boyut en yavaş değişir; `[1 1 1]`, sonra `[2 1 1]`, `[3 1 1]`,
  `[1 2 1]`… Bu sıra, `meshgrid` ile karıştırıldığında permütasyon tablosunun sütunları yer
  değiştirir.
- **`mod` ile `rem` farkı ölçüldü:** `mod(-3,2) = 1`, `rem(-3,2) = -1`. Parite testinde `mod`
  tercih edilir çünkü sonuç her zaman `0/1`'dir; `rem` negatif sayıda `-1` verir.
- **Tam sayı olmayan ne çift ne tek:** `mod(3.5,2) = 1.5` — "tek" demek yanlış olur. `fix(x)==x`
  testi bu yüzden önce uygulanmalı; `NaN` için `fix(NaN)==NaN` yanlış döner (hata değil).
- **Cebirsel değişken tablosu:** `[6]` bölümü `y = x + v·τ` değerini beş zaman noktasında
  yazdırır; `t = 0`'da `y = 1,0000`, `t ≈ 2,42`'de `y = -0,2984`. İkinci çıktı argümanı
  sayesinde türev üretmeyen bir nicelik de tablolanabiliyor.

## Alıştırmalar

1. `nchoosek("Merhaba", 5)` yerine `char(nchoosek(uint8("Merhaba"), 5))` çalıştırın: kaç
   kombinasyon çıkıyor (`C(7,5)`)? Sonuç matrisinin boyutu ne?
2. `ndgrid([1 2 3 4 5])` üçlüsünü dörde çıkarın (`w` değişkeni): satır sayısı `625` oluyor mu?
   `nthargout([1:4], @ndgrid, 1:5)` ile aynı sonucu üretin.
3. `P = [0 0; 3 4; 6 0; 6 8]` için `Dsq` matrisini hesaplayın; `sumsq(R,3)` ile aynı çıkıyor mu?
   `sqrt(Dsq)` matrisinin köşegeni neden tam sıfır?
4. `dspring` fonksiyonunda `tau = 0,5` yapın: `y` tablosu nasıl değişiyor? `y = x` (τ=0) hâlinde
   tablonun `x` ile aynı olması gerektiğini ölçerek doğrulayın.
