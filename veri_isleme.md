---
layout: default
title: "Octave'de Veri İşleme: Dosya, Arama, Sıralama"
lang: tr
konu: veri
seviye: orta
tur: ders
kod: veri_isleme.m
redirect_from: [/Octave_veri_isleme.html]
---

# Octave'de Veri İşleme: Dosya, Arama, Sıralama

Bu not, Octave'de veriyle çalışırken en sık başvurulan sekiz işlevi tek bir betikte
toplar: dosyadan okuma/yazma (`load`, `save`), çalışma alanı envanteri (`who`, `whos`),
arama ve sıralama (`find`, `sort`), mantıksal indeksleme ve tekrarları atma (`unique`).
Her işlev kendi bölümünde hem kullanım biçimi hem de çalışan bir örnekle gösterilir;
sayfadaki çıktı bloğu betiğin **ölçülmüş** koşusundan alınmıştır.

## Ne öğreneceksiniz

- `load`/`save` ile ASCII veri dosyasından matris okumayı ve dosyaya yazmayı
- `who` ve `whos` ile çalışma alanındaki değişkenlerin adını, boyutunu ve türünü görmeyi
- `find` ile bir koşulu sağlayan öğelerin satır/sütun konumunu ve doğrusal indeksini bulmayı
- `sort` ile hem sütun bazlı hem de tüm öğeler üzerinden sıralamayı
- Mantıksal indeksleme ile filtrelemeyi ve `unique` ile tekrarları atmaya

## Çalıştırma

```sh
octave --no-gui veri_isleme.m
```

Betik reponun kökünde ve tek başına koşar: örnek veriyi kendisi üretir, dosyaları repo
içine değil sistemin geçici dizinine yazar (çalışma sonunda okunacak iki küçük metin dosyası
orada kalır, silme işlemi yapılmaz). Ekran çıktısı dışında bir şey üretmez, grafik açmaz.
Grafik penceresi olmayan oturumlarda `octave-cli veri_isleme.m` aynı çıktıyı verir; bu
sayfadaki blok GNU Octave 11.3.0 ile `octave-cli` üzerinden ölçüldü (bu makinede
`octave --no-gui` Qt/cocoa eklentisi yüzünden betiği yüklemeden düşüyor, EXIT=134).

## Kod

Sekiz işlevin özeti — ayrıntılı kullanım betiğin içinde yorum satırlarıyla birlikte:

| İşlev | Kullanım | Ne yapar |
|---|---|---|
| `load` | `V = load("veri.txt")` | Dosyadaki sayısal veriyi değişkene alır |
| `save` | `save("-ascii", "kayit.txt", "D")` | Çalışma alanındaki değişkeni metin dosyasına yazar |
| `who` | `who` | Değişken adlarını listeler |
| `whos` | `whos` | Ad, boyut, bayt ve tür tablosunu verir |
| `find` | `[satir, sutun] = find(A == 5)` | Koşulu sağlayan öğelerin konumunu verir |
| `sort` | `sort(A)`, `sort(A(:))` | Sütun bazlı ya da tüm öğeler üzerinden sıralar |
| mantıksal indeks | `A(A > 5)` | Koşulu sağlayan öğeleri seçer |
| `unique` | `[b, i, j] = unique(T)` | Tekrarları atar; ilk görülme ve eşleme indekslerini verir |

Aşağıdaki betik dosyanın tamamıdır (`kod: veri_isleme.m`):

```octave
clear; clc; close all;

%% 0. Hazirlik: ornek veri dosyasi
% Notun konusu dosyadan okuma/yazma oldugu icin betik girdisini kendi uretir.
% Dosyalar repo icine degil, sistemin gecici dizinine yazilir.
gecici_dizin = tempdir();
girdi_dosyasi = fullfile(gecici_dizin, "ornek_veri.txt");
kayit_dosyasi = fullfile(gecici_dizin, "kayit_veri.txt");

M = [3 1 5; 9 2 6; 4 7 8];
save("-ascii", girdi_dosyasi, "M");
printf("Gecici dizine yazilan dosya : ornek_veri.txt (%d deger, %d sutun)\n", ...
       numel(M), columns(M));

%% 1. load: dosyadaki veriyi degiskene al
V = load(girdi_dosyasi);
printf("\n[load] okunan matris boyutu: %d x %d\n", rows(V), columns(V));
disp(V);

%% 2. save: calisma alanindaki degiskeni dosyaya yaz
D = V * 2;
save("-ascii", kayit_dosyasi, "D");
D_geri = load(kayit_dosyasi);
printf("[save] D = V*2 dosyaya yazildi ve geri okundu; ayni mi: %d\n", ...
       isequal(D, D_geri));

%% 3. who / whos: calisma alani envanteri
% Dosya adlari yol (path) tasidigi icin envanterden once temizlenir; boylece
% tablo makineye gore degismez.
clear gecici_dizin girdi_dosyasi kayit_dosyasi;
printf("\n[who] degisken adlari:\n");
who
printf("\n[whos] ad, boyut ve tur:\n");
whos

%% 4. find: kosulu saglayan ogelerin konumu
A = [1 2 3; 4 5 6; 7 8 9];
[satir, sutun] = find(A == 5);
printf("\n[find] A == 5 -> satir %d, sutun %d, dogrusal indeks %d\n", ...
       satir, sutun, find(A == 5));
[s1, s2] = find(A > 6);
printf("[find] A > 6  -> %d oge: satir [%s], sutun [%s]\n", ...
       numel(s1), num2str(s1'), num2str(s2'));

%% 5. sort: siralama
B = [3 1 5; 9 2 6; 4 7 8];
sutun_bazli = sort(B);
tum_ogeler  = sort(B(:))';
printf("\n[sort] sutun bazli artan:\n");
disp(sutun_bazli);
printf("[sort] tum ogeler artan: %s\n", num2str(tum_ogeler));
printf("[sort] azalan (descend): %s\n", num2str(sort(B(:), "descend")'));

%% 6. Mantiksal indeksleme: filtreleme
kosul  = A > 5;
secili = A(kosul);
printf("\n[filtr] A > 5 -> %s (%d oge)\n", num2str(secili'), numel(secili));
printf("[filtr] en buyuk oge A(A == max(A(:))) -> %s\n", ...
       num2str(A(A == max(A(:)))'));

%% 7. unique: tekrarlanan ogeleri at
T = [1 2 3 1 4 5 4 3];
[benzersiz, ilk_yer, esleme] = unique(T);
printf("\n[unique] girdi          : %s\n", num2str(T));
printf("[unique] benzersiz      : %s\n", num2str(benzersiz));
printf("[unique] ilk gorulme    : %s\n", num2str(ilk_yer'));
printf("[unique] esleme (j)     : %s\n", num2str(esleme'));
printf("[unique] tekrar sayisi  : %d\n", numel(T) - numel(benzersiz));

%% Ozet
printf("\nOzet: load/save (2 gecici dosya), who/whos, find, sort, mantiksal\n");
printf("      indeksleme ve unique ayni betikte olculdu.\n");
```

## Beklenen Çıktı

```
Gecici dizine yazilan dosya : ornek_veri.txt (9 deger, 3 sutun)

[load] okunan matris boyutu: 3 x 3
   3   1   5
   9   2   6
   4   7   8
[save] D = V*2 dosyaya yazildi ve geri okundu; ayni mi: 1

[who] degisken adlari:
Variables visible from the current scope:

D       D_geri  M       V


[whos] ad, boyut ve tur:
Variables visible from the current scope:

variables in scope: top scope

  Attr   Name        Size                     Bytes  Class
  ====   ====        ====                     =====  ===== 
         D           3x3                         72  double
         D_geri      3x3                         72  double
         M           3x3                         72  double
         V           3x3                         72  double

Total is 36 elements using 288 bytes


[find] A == 5 -> satir 2, sutun 2, dogrusal indeks 5
[find] A > 6  -> 3 oge: satir [3  3  3], sutun [1  2  3]

[sort] sutun bazli artan:
   3   1   5
   4   2   6
   9   7   8
[sort] tum ogeler artan: 1  2  3  4  5  6  7  8  9
[sort] azalan (descend): 9  8  7  6  5  4  3  2  1

[filtr] A > 5 -> 7  8  6  9 (4 oge)
[filtr] en buyuk oge A(A == max(A(:))) -> 9

[unique] girdi          : 1  2  3  1  4  5  4  3
[unique] benzersiz      : 1  2  3  4  5
[unique] ilk gorulme    : 1  2  3  5  6
[unique] esleme (j)     : 1  2  3  1  4  5  4  3
[unique] tekrar sayisi  : 3

Ozet: load/save (2 gecici dosya), who/whos, find, sort, mantiksal
      indeksleme ve unique ayni betikte olculdu.
```

## Öne Çıkan Noktalar

- ASCII veri dosyasında `V = load(dosya)` **doğrudan matris** döndürür; `.mat` dosyasındaki
  gibi alan adlarına sahip bir yapı dönmez. Dosya adı değişken adı olarak kullanılmaz.
- `save("-ascii", dosya, "D")` değişkeni okunabilir metin olarak yazar; `load` ile geri
  okunan değer `isequal` ile birebir aynı çıkar (çıktıda `1`).
- `who`/`whos` tablosuna yol (path) taşıyan metin değişkenleri girseydi çıktı makineye göre
  değişirdi; bu yüzden envanterden önce `clear` ile çıkarıldılar — sayfadaki tablo bu hâliyle
  her makinede aynı çıkar.
- `find` iki çıktıyla satır/sütun, tek çıktıyla **doğrusal indeks** verir; doğrusal indeks
  sütun-major sayar (`A = [1 2 3; 4 5 6; 7 8 9]` içinde `5` → satır 2, sütun 2, indeks 5).
- `sort(A)` her sütunu kendi içinde sıralar; tüm öğeleri tek vektör gibi sıralamak için
  `sort(A(:))` gerekir. Mantıksal indekslemenin sonucu da sütun-major sırada gelir
  (`7 8 6 9`), satır sırasında değil.

## Alıştırmalar

1. `A = magic(4)` matrisinde `find` ile 10'dan büyük öğelerin satır/sütun konumlarını yazdırın;
   `A(A > 10)` çıktısıyla aynı öğe kümesini verdiğini doğrulayın.
2. Geçici dizine kendi `veri.txt` dosyanızı `save -ascii` ile yazın, `load` ile geri okuyup
   `whos` çıktısında boyutunu kontrol edin.
3. `T = [4 1 4 2 1]` vektörü için `unique` üç çıktısını (`b`, `i`, `j`) yorumlayın:
   `T(j)` neden `T` ile aynı olur?
