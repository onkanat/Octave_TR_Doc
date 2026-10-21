---
layout: default
title: "10 Dakikada Octave'a Hızlı Başlangıç"
lang: tr
konu: temel
seviye: baslangic
tur: ders
kod: hizli_baslangic.m
redirect_from: [/Octave_hizli_baslangic.html]
---

# 10 Dakikada Octave'a Hızlı Başlangıç

Bu not, Octave'ı ilk kez açan biri için on dakikalık bir turdur: aritmetik işlemlerden
matris çarpımına kadar her adım tek bir betikte toplandı. Betiğin ürettiği çıktı bu sayfada
**ölçülmüş** hâliyle yer alır; okurun kendi koşusu aynı satırları verir.

## Ne öğreneceksiniz

- Octave'i hesap makinesi gibi kullanmayı: `+`, `-`, `*`, `/`, `^`, `sqrt`
- Bir değeri değişkende saklayıp yeniden kullanmayı
- Satır ve sütun vektörü ile matris yazımını (`[1, 2, 3]` ve `[1; 2; 3]`)
- `zeros`, `ones`, `eye` ile hazır matris üretmeyi
- Toplama, matris çarpımı, transpoz, ters alma ve `help` ile belge okumayı

## Çalıştırma

```sh
octave --no-gui hizli_baslangic.m
```

Betik reponun kökünde ve tek başına koşar. Grafik penceresi olmayan (uzak/başsız) oturumlarda
`octave --no-gui --no-window-system hizli_baslangic.m` ya da doğrudan `octave-cli` aynı çıktıyı verir;
bu sayfadaki çıktı GNU Octave 11.3.0 ile ölçüldü.

## Kod

Aşağıdaki betik dosyanın tamamıdır (`kod: hizli_baslangic.m`). Her atama `;` ile kapatıldığı için
ekrana yalnız `printf`/`disp` satırları düşer; etkileşimli oturumda bu satırların değerleri
kendiliğinden görünür.

```octave
clear; clc; close all;

%% 1. Temel matematiksel işlemler
% Octave basit bir hesap makinesi gibi kullanılabilir.
toplama  = 2 + 3;
cikarma  = 8 - 4;
carpma   = 5 * 2;
bolme    = 10 / 2;
us_alma  = 2^3;
karekok  = sqrt(16);

printf("%-10s %s\n", "Islem", "Sonuc");
printf("%-10s %g\n", "2 + 3",  toplama);
printf("%-10s %g\n", "8 - 4",  cikarma);
printf("%-10s %g\n", "5 * 2",  carpma);
printf("%-10s %g\n", "10 / 2", bolme);
printf("%-10s %g\n", "2^3",    us_alma);
printf("%-10s %g\n", "sqrt(16)", karekok);

%% 2. Değişkenler
x = 10;
y = 5;
z = x * y;
printf("\nz = x * y = %d\n", z);

%% 3. Vektör ve matris oluşturma
satir_vektor  = [1, 2, 3, 4, 5];
sutun_vektor  = [1; 2; 3; 4; 5];
A = [1, 2, 3; 4, 5, 6];

printf("\nSatir vektor boyutu : %d x %d\n", rows(satir_vektor), columns(satir_vektor));
printf("Sutun vektor boyutu : %d x %d\n", rows(sutun_vektor), columns(sutun_vektor));
printf("A matrisi boyutu    : %d x %d\n", rows(A), columns(A));
disp(A)

%% 4. Özel matrisler
S = zeros(3, 2);
B = ones(4, 5);
I = eye(5);

printf("\nzeros(3,2) boyutu : %d x %d, tum elemanlar sifir mi: %d\n", ...
       rows(S), columns(S), all(S(:) == 0));
printf("ones(4,5)  boyutu : %d x %d, tum elemanlar bir mi : %d\n", ...
       rows(B), columns(B), all(B(:) == 1));
printf("eye(5)     izi    : %d (birim matrisin izi boyutuna esittir)\n", trace(I));

%% 5. Matris işlemleri
M1 = [1, 2; 3, 4];
M2 = [5, 6; 7, 8];

toplam   = M1 + M2;
carpim   = M1 * M2;
transpoz = M1';
ters     = inv(M1);

printf("\nM1 + M2 =\n");   disp(toplam)
printf("M1 * M2 =\n");      disp(carpim)
printf("M1'     =\n");      disp(transpoz)
printf("inv(M1) =\n");      disp(ters)
printf("inv(M1) * M1 birime yakin mi: %d\n", norm(ters * M1 - eye(2)) < 1e-12);

%% 6. Yardım
% Bir fonksiyonun belgesi help ile okunur (etkileşimli oturumda):
%   help inv
% Betik içinde belge metninin ilk satırı şöyle alınabilir:
bilgi = help("inv");
printf("\nhelp('inv') ilk satiri: %s\n", strtrim(strsplit(bilgi, "\n"){1}));

%% Özet
printf("\nOzet: 6 aritmetik islem, 3 degisken, 2 vektor, 1 matris, 3 ozel matris,\n");
printf("      4 matris islemi ve help ornegi tek betikte calistirildi.\n");
```

## Beklenen Çıktı

Aşağıdaki blok, yukarıdaki betiğin `octave --no-gui` koşusundan **birebir** alınmıştır.

```text
Islem      Sonuc
2 + 3      5
8 - 4      4
5 * 2      10
10 / 2     5
2^3        8
sqrt(16)   4

z = x * y = 50

Satir vektor boyutu : 1 x 5
Sutun vektor boyutu : 5 x 1
A matrisi boyutu    : 2 x 3
   1   2   3
   4   5   6

zeros(3,2) boyutu : 3 x 2, tum elemanlar sifir mi: 1
ones(4,5)  boyutu : 4 x 5, tum elemanlar bir mi : 1
eye(5)     izi    : 5 (birim matrisin izi boyutuna esittir)

M1 + M2 =
    6    8
   10   12
M1 * M2 =
   19   22
   43   50
M1'     =
   1   3
   2   4
inv(M1) =
  -2.0000   1.0000
   1.5000  -0.5000
inv(M1) * M1 birime yakin mi: 1

help('inv') ilk satiri: -- X = inv (A)

Ozet: 6 aritmetik islem, 3 degisken, 2 vektor, 1 matris, 3 ozel matris,
      4 matris islemi ve help ornegi tek betikte calistirildi.
```

## Öne Çıkan Noktalar

- `x = 10` gibi satırlar etkileşimli oturumda değeri hemen basar; betikte aynı etkiyi `printf` verir.
- `'` operatörü transpozdur. Karmaşık sayılarda eşlenik transpoz anlamına gelir; yalnız transpoz için `.'` kullanılır.
- Ters alıp çarpmak (`inv(A)*b`) yerine sol bölme (`A\b`) tercih edilir — ayrıntı `lineer_cebir` notunda.
- `help("inv")` betik içinde metni döndürür, etkileşimli oturumda sayfa açar.
- `zeros(3,2)` ve `ones(4,5)` boyutları `rows`/`columns` ile doğrulandı; `eye(5)` izi 5 çıkar.

## Alıştırmalar

1. `A = [1 2 3; 4 5 6]` matrisinin boyutunu hem `size` hem `rows`/`columns` ile yazdırın, sonuçları karşılaştırın.
2. 1'den 100'e kadar sayıların karelerinden `reshape` ile 10×10 bir matris kurun ve izini `trace` ile bulun.
3. `eye(5)` ile `ones(5)` arasındaki farkı `norm` ile ölçün; sonucun neden `sqrt(20)` olduğunu açıklayın.
