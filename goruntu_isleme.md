---
layout: default
title: "Octave'de Görüntü İşleme: Okuma, Manipülasyon, Kenar ve Histogram"
lang: tr
konu: muhendislik
seviye: orta
tur: ders
kod: goruntu_isleme.m
redirect_from: [/Octave_image_processing.html]
---

# Octave'de Görüntü İşleme: Okuma, Manipülasyon, Kenar ve Histogram

Görüntü işlemede bir görüntü aslında bir matristir: gri tonlamalı görüntü `Yükseklik x Genişlik`,
renkli görüntü `Yükseklik x Genişlik x 3` (RGB) boyutunda sayı dizisidir. Bu not; `image`
paketinin okuma/yazma/gösterme işlevlerini (`imread`, `imshow`, `imwrite`), manipülasyon
işlevlerini (`imresize`, `imrotate`, `imcrop`) ve analiz işlevlerini (`edge`, `imhist`) tek
betikte toplar. Sayfadaki çıktı bloğu betiğin **ölçülmüş** koşusundan alınmıştır.

## Ne öğreneceksiniz

- Bir görüntünün neden matris olduğunu ve `image` paketini `pkg load image` ile yüklemeyi
- `rgb2gray` ile üç kanalı tek kanala indirmeyi, `imread`/`imwrite` ile dosya okuma-yazmayı
- `imresize` (ölçek), `imrotate` (açı) ve `imcrop` (`[x y genişlik yükseklik]`) ile geometrik işlemleri
- `edge(gri, "sobel")` ile kenar tespitini ve kenar piksel oranını ölçmeyi
- `imhist` ile parlaklık dağılımını sayısal olarak okumayı (en kalabalık kutu, dolu kutu sayısı)

## Çalıştırma

```sh
octave --no-gui goruntu_isleme.m
```

Betik reponun kökünde ve tek başına koşar; `image` paketini yükler (bu makinede sürüm
**2.14.0**) ve görüntüyü **kendisi üretir** — dışarıdan bir resim dosyasına ihtiyaç duymaz
(gradyan zemin + iki renkli dikdörtgen + sabit tohumlu gürültü). Çıktı PNG'leri
`assets/img/` altına yazılır. Bu sayfadaki blok GNU Octave 11.3.0 ile `octave-cli`
üzerinden ölçüldü; bu makinede `octave --no-gui` Qt/cocoa eklentisi yüzünden betiği
yüklemeden düşüyor (EXIT=134).

## Kod

| İşlev | Kullanım | Ne yapar |
|---|---|---|
| `imread` | `img = imread("dosya.png")` | Görüntüyü matris olarak okur (renkli: `H x W x 3`) |
| `imshow` | `imshow(img)` | Matrisi grafik pencerede gösterir (etkileşimli oturum) |
| `imwrite` | `imwrite(uint8(round(255*img)), "yeni.png")` | Matrisi dosyaya yazar |
| `rgb2gray` | `gri = rgb2gray(img)` | Üç kanalı ağırlıklı ortalamayla tek kanala indirir |
| `imresize` | `imresize(img, 0.5)` | Ölçekle yeniden boyutlandırır |
| `imrotate` | `imrotate(img, 30)` | Açı kadar döndürür (tuval büyür) |
| `imcrop` | `imcrop(img, [x y w h])` | Dikdörtgen bölgeyi keser (sınırlar dahil) |
| `edge` | `edge(gri, "sobel")` | Kenarları mantıksal maske olarak verir |
| `imhist` | `[sayim, kutu] = imhist(gri)` | 256 kutuluk parlaklık histogramı |

Aşağıdaki betik dosyanın tamamıdır (`kod: goruntu_isleme.m`):

```octave
clear; clc; close all;

%% 0. Hazirlik: image paketi, tekrar uretilebilir sentetik goruntu
pkg load image;
rand("seed", 42);
randn("state", 42);

betik_dizini = fileparts(mfilename("fullpath"));
if isempty(betik_dizini); betik_dizini = pwd(); end
img_dizini = fullfile(betik_dizini, "assets", "img");
if ~exist(img_dizini, "dir"); mkdir(img_dizini); end

%% 1. Sentetik RGB goruntu: gradyan zemin + iki renkli dikdortgen + gurultu
H = 120; W = 160;
gradyan = repmat(linspace(0.15, 0.85, W), H, 1);
R = gradyan; G = gradyan; B = 0.9*gradyan;
R(20:60,  20:70) = 0.90; G(20:60,  20:70) = 0.20; B(20:60,  20:70) = 0.15;
R(70:105, 95:140) = 0.15; G(70:105, 95:140) = 0.75; B(70:105, 95:140) = 0.85;
img = cat(3, R, G, B);
img = min(max(img + 0.03*randn(H, W, 3), 0), 1);
printf("[1] goruntu: %d x %d x %d, tur %s\n", rows(img), columns(img), ...
       size(img, 3), class(img));

%% 2. Gri tonlama ve temel istatistik
gri = rgb2gray(img);
printf("[2] gri: %d x %d, en kucuk %.3f, en buyuk %.3f, ortalama %.3f\n", ...
       rows(gri), columns(gri), min(gri(:)), max(gri(:)), mean(gri(:)));

%% 3. Manipulasyon: yeniden boyutlandirma, dondurme, kirpma
kucuk    = imresize(img, 0.5);
dondur   = imrotate(img, 30);
kirp     = imcrop(img, [20, 20, 80, 60]);   % [x, y, genislik, yukseklik]
printf("[3] imresize 0.5 : %d x %d\n", rows(kucuk), columns(kucuk));
printf("[3] imrotate 30  : %d x %d\n", rows(dondur), columns(dondur));
printf("[3] imcrop       : %d x %d\n", rows(kirp), columns(kirp));

%% 4. Kenar tespiti ve histogram
kenar = edge(gri, "sobel");
printf("[4] sobel kenar  : %d piksel (%.1f%%)\n", nnz(kenar), ...
       100*nnz(kenar)/numel(gri));
[sayim, kutu] = imhist(gri);
[en_cok, yer] = max(sayim);
printf("[4] histogram    : %d kutu, en kalabalik kutu %.3f (parlaklik), %d piksel\n", ...
       numel(sayim), kutu(yer), en_cok);
printf("[4] histogram    : dolu kutu %d/%d, agirlik merkezi %.3f\n", ...
       nnz(sayim), numel(sayim), sum(kutu(:).*sayim(:))/sum(sayim));

%% 5. Dosyaya yaz, geri oku ve ayni mi diye dogrula
girdi_png = fullfile(img_dizini, "goruntu_isleme-girdi.png");
gri_png   = fullfile(img_dizini, "goruntu_isleme-gri.png");
kenar_png = fullfile(img_dizini, "goruntu_isleme-kenar.png");
% double goruntu [0,1] araliginda; PNG'ye 8 bit yazmak icin uint8'e cevrilir
imwrite(uint8(round(255*img)), girdi_png);
imwrite(uint8(round(255*gri)), gri_png);
imwrite(uint8(255*kenar), kenar_png);
geri = imread(girdi_png);
% PNG 8 bit saklar: double goruntu yazilirken 1/255 adimina yuvarlanir,
% bu yuzden birebir esitlik degil, en buyuk yuvarlama hatasi olculur.
fark = abs(double(geri)/255 - img);
printf("[5] goruntu_isleme-girdi.png : %d bayt, en buyuk 8-bit yuvarlama hatasi %.5f\n", ...
       dir(girdi_png).bytes, max(fark(:)));
printf("[5] goruntu_isleme-gri.png   : %d bayt\n", dir(gri_png).bytes);
printf("[5] goruntu_isleme-kenar.png : %d bayt\n", dir(kenar_png).bytes);

%% Ozet
printf("\nOzet: %d x %d RGB goruntu uzerinde rgb2gray, imresize, imrotate, imcrop,\n", H, W);
printf("      edge(sobel) ve imhist olculdu; 3 PNG dosyasi assets/img/ altina yazildi.\n");
```

Betiğin ürettiği dosyalar: `assets/img/goruntu_isleme-girdi.png`,
`assets/img/goruntu_isleme-gri.png`, `assets/img/goruntu_isleme-kenar.png`.

## Beklenen Çıktı

```
[1] goruntu: 120 x 160 x 3, tur double
[2] gri: 120 x 160, en kucuk 0.089, en buyuk 0.899, ortalama 0.495
[3] imresize 0.5 : 60 x 80
[3] imrotate 30  : 184 x 198
[3] imcrop       : 61 x 81
[4] sobel kenar  : 259 piksel (1.3%)
[4] histogram    : 256 kutu, en kalabalik kutu 0.404 (parlaklik), 254 piksel
[4] histogram    : dolu kutu 204/256, agirlik merkezi 0.495
[5] goruntu_isleme-girdi.png : 39058 bayt, en buyuk 8-bit yuvarlama hatasi 0.00196
[5] goruntu_isleme-gri.png   : 11671 bayt
[5] goruntu_isleme-kenar.png : 309 bayt

Ozet: 120 x 160 RGB goruntu uzerinde rgb2gray, imresize, imrotate, imcrop,
      edge(sobel) ve imhist olculdu; 3 PNG dosyasi assets/img/ altina yazildi.
```

## Öne Çıkan Noktalar

- Görüntü matristir: `img(20:60, 20:70, 1) = 0.90` yazarak kırmızı kanalda bir dikdörtgen
  boyanabilir. Betik görüntüyü dosyadan okumak yerine bu yolla üretir; böylece örnek dış
  bir dosyaya bağımlı olmaz ve iki koşu aynı sonucu verir.
- `imrotate` tuvali büyütür: 120×160 görüntü 30° dönünce 184×198 olur. `imcrop` sınırları
  **dahil** aldığı için `[20 20 80 60]` istenen 80×60 yerine 81×61 döner — bu bir hata
  değil, işlevin tanımıdır.
- `edge(gri, "sobel")` mantıksal maske döndürür; kenar pikseli sayısı `nnz` ile bulunur.
  Bu görüntüde 259 piksel (%1,3) kenar çıkar. `canny` yöntemi daha ince kenar verir ama
  eşik parametreleri ister.
- `imhist` çizim yerine **iki çıktıyla** çağrıldığında sayı döndürür; sayfa bu sayıları
  ölçer. En kalabalık kutu 0,404 parlaklıkta 254 pikseldir, ağırlık merkezi 0,495 ile
  görüntünün ortalama parlaklığı örtüşür.
- `imshow` etkileşimli pencere ister; başsız koşuda çağrılmaz. PNG yazımı 8 bite
  yuvarladığı için geri okunan görüntü birebir eşit değildir: en büyük fark 0,00196
  (yarım kuantalama adımı) — uydurma değil, ölçülmüş sınırdır.

## Alıştırmalar

1. Görüntüye üçüncü bir dikdörtgen ekleyin ve `edge` çıktısındaki kenar piksel sayısının
   kaç arttığını ölçün. Sobel ile `canny` sonuçlarını aynı görüntüde karşılaştırın.
2. `imresize(img, 2)` ile büyütüp sonra `imresize(..., 0.5)` ile küçültün; `img` ile
   arasındaki en büyük farkı (`max(abs(...))`) hesaplayın. Kayıp nereden geliyor?
3. Gürültü genliğini `0.03` yerine `0.20` yapın: en kalabalık histogram kutusu ve dolu kutu
   sayısı nasıl değişiyor? `edge` eşiğini değiştirmeden kenar sayısı neden artıyor?
