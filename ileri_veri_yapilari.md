---
layout: default
title: "Octave'de İleri Düzey Veri Yapıları: Hücre Dizileri ve Yapılar"
lang: tr
konu: veri
seviye: orta
tur: ders
kod: ileri_veri_yapilari.m
redirect_from: [/Octave_advanced_data_structures.html]
---

# Octave'de İleri Düzey Veri Yapıları: Hücre Dizileri ve Yapılar

Standart matrisler ve vektörler aynı türde sayı tutar; farklı türde ve boyutta verileri bir
arada saklamak için Octave iki esnek yapı sunar: **hücre dizileri** (`cell`) ve **yapılar**
(`struct`). Bu not iki yapıyı da kuruluş, içeriğe erişim ve genişletme adımlarıyla gösterir;
çıktı bloğu betiğin ölçülmüş koşusundan alınmıştır.

## Ne öğreneceksiniz

- `{}` ile hücre dizisi kurmayı; hücreye `C{i}` ile, hücre dizisinin parçasına `C(i)` ile erişmeyi
- Bir hücrenin içeriğini değiştirmeyi ve diziye yeni hücre (iç içe hücre dâhil) eklemeyi
- Alan atamasıyla (`ogrenci.adi = ...`) ve `struct(...)` fonksiyonuyla yapı kurmayı
- `fieldnames` ve `isfield` ile yapı alanlarını sorgulamayı
- Aynı alan kümesine sahip yapı dizisi (`struct` array) kurup `for` ile gezmeyi

## Çalıştırma

```sh
octave --no-gui ileri_veri_yapilari.m
```

Betik reponun kökünde ve tek başına koşar; dosya okumaz, dosya yazmaz, grafik açmaz.
Grafik penceresi olmayan oturumlarda `octave-cli ileri_veri_yapilari.m` aynı çıktıyı verir;
sayfadaki blok GNU Octave 11.3.0 ile `octave-cli` üzerinden ölçüldü (bu makinede
`octave --no-gui` Qt/cocoa eklentisi yüzünden betiği yüklemeden düşüyor, EXIT=134).

## Kod

```octave
clear; clc; close all;

%% 1. Hucre dizisi (cell array) olusturma ve icerige erisim
% Her hucre farkli turde veri tutabilir: matris, metin, sayi.
C = {[1 2; 3 4], "Bu bir metindir", 42};
printf("[1] hucre sayisi: %d, boyut: %d x %d\n", numel(C), rows(C), columns(C));
printf("[1] 1. hucre turu : %s (matris)\n", class(C{1}));
disp(C{1});
printf("[1] 2. hucre turu : %s, icerik: %s\n", class(C{2}), C{2});
printf("[1] 3. hucre turu : %s, icerik: %d\n", class(C{3}), C{3});

%% 2. Hucre icerigini degistirme ve diziye yeni hucre ekleme
C{3} = "Yeni deger";
C{4} = {"ic ice", "hucre dizisi"};
printf("\n[2] 3. hucre artik: %s\n", C{3});
printf("[2] hucre sayisi  : %d\n", numel(C));
printf("[2] 4. hucre turu : %s (%d alt hucre)\n", class(C{4}), numel(C{4}));
printf("[2] ic ice erisim : %s / %s\n", C{4}{1}, C{4}{2});

%% 3. () ile parcayi almak, {} ile icerige inmek
alt = C(1:2);
printf("\n[3] C(1:2) turu: %s, hucre sayisi: %d (parca alindi, icerik cikmadi)\n", ...
       class(alt), numel(alt));
printf("[3] C{1}(2,1) : %d (ilk hucredeki matrisin 2. satir, 1. sutunu)\n", C{1}(2,1));
printf("[3] C{2}(1:3): %s (metnin ilk uc harfi)\n", C{2}(1:3));

%% 4. Yapi (struct): alan atamasiyla olusturma
ogrenci.adi     = "Ahmet";
ogrenci.numarasi = 123;
ogrenci.notlari = [85 92 78];
ogrenci.bolumu  = "Muhendislik";
printf("\n[4] alanlar: %s\n", strjoin(sort(fieldnames(ogrenci))', ", "));
printf("[4] ad: %s, numara: %d, bolum: %s\n", ...
       ogrenci.adi, ogrenci.numarasi, ogrenci.bolumu);
printf("[4] notlar: %s, ortalama: %.2f\n", ...
       num2str(ogrenci.notlari), mean(ogrenci.notlari));

%% 5. Yapi: struct() fonksiyonu ve alan sorgulama
ogrenci2 = struct("adi", "Ayse", "numarasi", 456, "notlari", [95 88 100]);
printf("\n[5] ikinci ogrenci: %s (%d), ortalama: %.2f\n", ...
       ogrenci2.adi, ogrenci2.numarasi, mean(ogrenci2.notlari));
printf("[5] 'bolumu' alani var mi: %d\n", isfield(ogrenci2, "bolumu"));
printf("[5] 'adi' alani var mi   : %d\n", isfield(ogrenci2, "adi"));

%% 6. Yapi dizisi (array of structs)
% Alan kumeleri ayni olmak zorunda; bu yuzden dizi struct() ile kurulur.
ogrenciler = struct("adi", {"Ahmet", "Ayse", "Mehmet"}, ...
                    "numarasi", {123, 456, 789});
printf("\n[6] yapi dizisi boyutu: %d x %d\n", rows(ogrenciler), columns(ogrenciler));
for i = 1:numel(ogrenciler)
  printf("    - %s (%d)\n", ogrenciler(i).adi, ogrenciler(i).numarasi);
end
printf("[6] numaralar toplami: %d\n", sum([ogrenciler.numarasi]));

%% 7. Hucre ile yapi arasindaki fark, tek satirda
printf("\n[7] hucre C{2} : %s (hucre icerigi dogrudan kullanilir)\n", C{2});
printf("[7] yapi  ogrenci.adi: %s (alan adiyla erisilir)\n", ogrenci.adi);

%% Ozet
printf("\nOzet: 4 hucreli C dizisi, 4 alanli ogrenci yapisi, struct() ile kurulan\n");
printf("      ogrenci2 ve 3 elemanli ogrenciler yapi dizisi ayni betikte olculdu.\n");
```

## Beklenen Çıktı

```
[1] hucre sayisi: 3, boyut: 1 x 3
[1] 1. hucre turu : double (matris)
   1   2
   3   4
[1] 2. hucre turu : char, icerik: Bu bir metindir
[1] 3. hucre turu : double, icerik: 42

[2] 3. hucre artik: Yeni deger
[2] hucre sayisi  : 4
[2] 4. hucre turu : cell (2 alt hucre)
[2] ic ice erisim : ic ice / hucre dizisi

[3] C(1:2) turu: cell, hucre sayisi: 2 (parca alindi, icerik cikmadi)
[3] C{1}(2,1) : 3 (ilk hucredeki matrisin 2. satir, 1. sutunu)
[3] C{2}(1:3): Bu  (metnin ilk uc harfi)

[4] alanlar: adi, bolumu, notlari, numarasi
[4] ad: Ahmet, numara: 123, bolum: Muhendislik
[4] notlar: 85  92  78, ortalama: 85.00

[5] ikinci ogrenci: Ayse (456), ortalama: 94.33
[5] 'bolumu' alani var mi: 0
[5] 'adi' alani var mi   : 1

[6] yapi dizisi boyutu: 1 x 3
    - Ahmet (123)
    - Ayse (456)
    - Mehmet (789)
[6] numaralar toplami: 1368

[7] hucre C{2} : Bu bir metindir (hucre icerigi dogrudan kullanilir)
[7] yapi  ogrenci.adi: Ahmet (alan adiyla erisilir)

Ozet: 4 hucreli C dizisi, 4 alanli ogrenci yapisi, struct() ile kurulan
      ogrenci2 ve 3 elemanli ogrenciler yapi dizisi ayni betikte olculdu.
```

## Öne Çıkan Noktalar

- `C{i}` hücrenin **içeriğini** verir (burada bir matris, bir metin, bir sayı); `C(i)`
  ise hücre dizisinin bir parçasını verir ve sonuç yine `cell` türündedir. Çıktıda
  `[3]` satırı bu farkı gösterir.
- Aynı hücre dizisi farklı türleri bir arada tutabilir: 1. hücre `double` matris,
  2. hücre `char`, 4. hücre yine `cell`. `class(C{i})` her hücrenin türünü verir.
- Yapılar alan adıyla okunur (`ogrenci.adi`); `struct("adi", "Ayse", ...)` ile kurulan yapı
  ile alan atamasıyla kurulan yapı aynı türdür. `isfield` alanın varlığını `0/1` olarak söyler.
- Yapı **dizisi** kurarken tüm elemanların alan kümesi aynı olmak zorundadır; bu yüzden
  `struct("adi", {"Ahmet", "Ayse", "Mehmet"}, ...)` biçimi kullanıldı. Tek tek
  `ogrenciler(2).adi = ...` yazmak, alan kümeleri uyuşmazsa hata verir.
- `[ogrenciler.numarasi]` yapı dizisinin bir alanını tek vektöre açar; `sum` gibi
  işlevler doğrudan bu vektörle çalışır.

## Alıştırmalar

1. `C{4}` içindeki iç içe hücreye bir eleman daha ekleyin (`C{4}{3} = 7`) ve `numel(C{4})`
   ile sayın.
2. `ogrenci` yapısına `sinif` alanı ekleyip `fieldnames` çıktısını yeniden yazdırın.
3. Üç öğrencinin not ortalamasını yapı dizisi üzerinde `for` ile hesaplayıp bir vektörde
   toplayın; sonucu `cellfun` ile tek satırda yazmanın yolunu arayın.
