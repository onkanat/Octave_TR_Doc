---
layout: default
title: "Octave'de Metin ve Dosya Çıktısı: disp, printf, fprintf"
lang: tr
konu: veri
seviye: orta
tur: ders
kod: metin_ve_dosya_ciktisi.m
redirect_from: [/Octave_metin_dosya_ciktisi.html]
---

# Octave'de Metin ve Dosya Çıktısı: disp, printf, fprintf

Bu not, bir sonucu ekrana ya da dosyaya yazmanın üç yolunu karşılaştırır: basit değer
gösterimi (`disp`), biçim denetimli çıktı (`printf`, `sprintf`, `fprintf`) ve dosya
işlemleri (`fopen`, `fdisp`, `fclose`). Genişlik/kesinlik ayarları, format türleri ve
matrislerin hangi sırada yazıldığı ölçülmüş çıktıyla birlikte gösterilir.

## Ne öğreneceksiniz

- `disp` ile bir değeri değişken adı ve `ans =` olmadan yazdırmayı; `format long` etkisini
- `disp` çağrısının döndürdüğü string'i değişkende saklamayı
- `fopen`/`fdisp`/`fclose` üçlüsüyle dosyaya yazmayı ve `fileread` ile geri okumayı
- `printf`, `sprintf`, `fprintf` arasındaki farkı (ekran / string / dosya)
- `%i`, `%f`, `%e`, `%%` türlerini, `%9.3f` gibi genişlik-kesinlik ayarlarını ve matris
  çıktısının sütun-major sırasını

## Çalıştırma

```sh
octave --no-gui metin_ve_dosya_ciktisi.m
```

Betik reponun kökünde ve tek başına koşar. Yazdığı dosya (`metin_cikti_ornek.txt`) repo
içine değil sistemin geçici dizinine gider; betik onu silmez, yerinde bırakır. Grafik açmaz.
Grafik penceresi olmayan oturumlarda `octave-cli metin_ve_dosya_ciktisi.m` aynı çıktıyı
verir; sayfadaki blok GNU Octave 11.3.0 ile `octave-cli` üzerinden ölçüldü (bu makinede
`octave --no-gui` Qt/cocoa eklentisi yüzünden betiği yüklemeden düşüyor, EXIT=134).

## Kod

```octave
clear; clc; close all;

%% 1. disp: degeri yazar, degisken adini yazmaz
x = [1 2 3];
printf("[1] x            : ");
disp(x);
printf("[1] log(10)      : ");
log(10)
printf("[1] disp(log(10)): ");
disp(log(10));

format long;
printf("[1] format long sonrasi disp(log(10)): ");
disp(log(10));
format short;

%% 2. disp ciktiyi string olarak dondurur
s = disp(log(10));
printf("\n[2] s turu: %s, karakter sayisi: %d, icerik: %s\n", class(s), numel(s), s);

%% 3. Dosyaya yazma: fopen / fdisp / fclose
% Dosya repo icine degil, sistemin gecici dizinine yazilir.
dosya = fullfile(tempdir(), "metin_cikti_ornek.txt");
fid = fopen(dosya, "w");
A = [1 2 3; 4 5 6];
fdisp(fid, A);
fdisp(fid, "Bu bir test metnidir");
durum = fclose(fid);
printf("\n[3] dosya kapatma durumu: %d (0 = basarili)\n", durum);

%% 4. Yazilan dosyayi geri okuma
icerik = fileread(dosya);
printf("[4] dosya icerigi (%d karakter):\n", numel(icerik));
disp(icerik);

%% 5. printf ailesi: ekran, string, dosya
printf("[5] printf  : ");
printf("Bir tam sayi: %i. Bir gercek sayi: %f. Bu bir %s.\n", 10.1, 5.5, "test");

metin = sprintf("Bir tam sayi: %i. Bir gercek sayi: %f.", 10.1, 5.5);
printf("[5] sprintf : %s (%d karakter)\n", metin, numel(metin));

fid = fopen(dosya, "a");
fprintf(fid, "%s\n", "fprintf ile eklendi");
fclose(fid);
printf("[5] fprintf : dosyanin sonuna eklendi, yeni boyut %d karakter\n", ...
       numel(fileread(dosya)));

%% 6. Format turleri: %i, %f, %e, %%
y = 10.34;
printf("\n[6] %%f -> %f, %%e -> %e (ayni deger)\n", y, y);
printf("[6] %%i -> %i (Octave double'i kirpmaz, degeri yazar)\n", y);
printf("[6] fix ile: %%i -> %i (tam sayiya cevrildi)\n", fix(y));
printf("[6] %%%% -> %i%% (tek yuzde isareti)\n", fix(y));

%% 7. Genislik ve kesinlik
printf("\n[7] %%9i   -> [%9i]\n", 10);
printf("[7] %%9f   -> [%9f]\n", pi);
printf("[7] %%9s   -> [%9s]\n", "test");
printf("[7] %%9.3f -> [%9.3f] (9 sutun, 3 ondalik, yuvarlanir)\n", pi);

%% 8. Matrisi ciktilama: degerler sutun-major sirada okunur
B = [1 2 3; 4 5 6; 7 8 9];
printf("\n[8] printf(\"%%i\\n\", B):\n");
printf("%i\n", B);
printf("[8] printf(\"[%%i, %%.1f, %%.2e]\\n\", B):\n");
printf("[%i, %.1f, %.2e]\n", B);

%% Ozet
printf("\nOzet: disp (format short/long), string donduren disp, fopen-fdisp-fclose\n");
printf("      uclusu, printf/sprintf/fprintf, %%i %%f %%e %%%% turleri, genislik ve\n");
printf("      kesinlik, matris ciktisi ayni betikte olculdu.\n");
```

## Beklenen Çıktı

```
[1] x            :    1   2   3
[1] log(10)      : ans = 2.3026
[1] disp(log(10)): 2.3026
[1] format long sonrasi disp(log(10)): 2.302585092994046

[2] s turu: char, karakter sayisi: 7, icerik: 2.3026


[3] dosya kapatma durumu: 0 (0 = basarili)
[4] dosya icerigi (47 karakter):
   1   2   3
   4   5   6
Bu bir test metnidir

[5] printf  : Bir tam sayi: 10.1. Bir gercek sayi: 5.500000. Bu bir test.
[5] sprintf : Bir tam sayi: 10.1. Bir gercek sayi: 5.500000. (46 karakter)
[5] fprintf : dosyanin sonuna eklendi, yeni boyut 67 karakter

[6] %f -> 10.340000, %e -> 1.034000e+01 (ayni deger)
[6] %i -> 10.34 (Octave double'i kirpmaz, degeri yazar)
[6] fix ile: %i -> 10 (tam sayiya cevrildi)
[6] %% -> 10% (tek yuzde isareti)

[7] %9i   -> [       10]
[7] %9f   -> [ 3.141593]
[7] %9s   -> [     test]
[7] %9.3f -> [    3.142] (9 sutun, 3 ondalik, yuvarlanir)

[8] printf("%i\n", B):
1
4
7
2
5
8
3
6
9
[8] printf("[%i, %.1f, %.2e]\n", B):
[1, 4.0, 7.00e+00]
[2, 5.0, 8.00e+00]
[3, 6.0, 9.00e+00]

Ozet: disp (format short/long), string donduren disp, fopen-fdisp-fclose
      uclusu, printf/sprintf/fprintf, %i %f %e %% turleri, genislik ve
      kesinlik, matris ciktisi ayni betikte olculdu.
```

## Öne Çıkan Noktalar

- `disp(x)` değeri yazar, `ans =` etiketi koymaz; satır sonunda noktalı virgül **yoksa**
  sonucu Octave `ans = ...` biçiminde basar. Çıktının ilk iki satırı bu farkı gösterir.
- `format long` yalnız görüntüleme biçimini değiştirir, değeri değiştirmez: `disp(log(10))`
  `2.3026` yerine `2.302585092994046` yazar. `format short` ile eski hâle dönülür.
- `s = disp(log(10))` çıktıyı **string olarak da** döndürür (`char`, 7 karakter); yani
  `disp` hem yazar hem döndürür. Dosyaya yazmak için `fdisp(fid, değer)` kullanılır.
- `fopen(dosya, mod)` modları: `"r"` okuma, `"w"` yazma (dosya varsa **içeriği silinir**),
  `"a"` sonuna ekleme. Bu yüzden `fprintf` ile ekleme yaparken `"a"` seçildi; `fclose`
  `0` döndürürse kapatma başarılıdır.
- **Ölçülen davranış (belgede sık yanlış yazılır):** Octave'de `printf("%i", 10.34)` değeri
  `10` diye kırpmaz, `10.34` yazar — `%i`/`%d` double argümanı C'deki gibi tam sayıya
  çevirmez. Tam sayı çıktısı için önce `fix()`/`round()` uygulanmalıdır; betikte iki hâli
  de ölçülmüştür. `%f` ve `%e` ise beklendiği gibi çalışır.
- Bir matris `printf`'e tek argüman olarak verilirse değerler **sütun-major** sırada
  yazılır: 3×3 matriste önce 1. sütun (`1 4 7`), sonra 2. ve 3. sütun gelir. Format
  string'inde birden fazla belirleyici varsa aralarında döner.

## Alıştırmalar

1. `A = [1.5 2.25; 3.75 4.5]` matrisini `%8.2f` ile yazdırın; sütun hizasını ve ondalık
   yuvarlamayı kontrol edin.
2. Aynı matrisi `sprintf` ile bir string'e alıp `numel` ile karakter sayısını ölçün, sonra
   `fprintf` ile geçici bir dosyaya yazıp `fileread` ile geri okuyun.
3. `fopen(..., "w")` ile yazdığınız bir dosyayı `fopen(..., "a")` ile açıp ikinci bir satır
   ekleyin; `"w"` seçilseydi ne olurdu, ölçerek gösterin.
