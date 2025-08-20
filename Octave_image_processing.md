---
layout: default
title: "Octave'de Görüntü İşleme"
---

# Octave'de Görüntü İşleme

Octave, `image` paketi aracılığıyla kapsamlı görüntü işleme yetenekleri sunar. Bu paket, görüntüleri okuma, yazma, gösterme, manipüle etme ve analiz etme gibi birçok temel ve ileri düzey işlemi destekler.

**Not:** Bu bölümdeki fonksiyonları kullanmadan önce `image` paketinin yüklenmesi gerekebilir. `pkg load image` komutunu kullanarak paketi yükleyebilirsiniz.

## Temel İşlemler: Okuma, Yazma ve Gösterme

En temel görüntü işleme adımları bir görüntüyü dosyadan okumak, ekranda göstermek ve işlenmiş görüntüyü dosyaya kaydetmektir.

- **`imread('dosya_adi')`**: Bir görüntü dosyasını okur ve bir matris olarak döndürür. Renkli resimler için bu matris Yükseklik x Genişlik x 3 (RGB) boyutunda olur.
- **`imshow(img_matrisi)`**: Bir görüntü matrisini bir grafik penceresinde gösterir.
- **`imwrite(img_matrisi, 'yeni_dosya_adi')`**: Bir görüntü matrisini dosyaya yazar.

**Örnek:**

```octave
pkg load image;

% Octave ile gelen standart bir test görüntüsünü yükleyelim
img = imread(fullfile(OCTAVE_HOME, '..', 'share', 'octave', '6.2.0', 'imagelib', 'peppers.png'));

% Görüntüyü göster
figure;
subplot(1, 2, 1);
imshow(img);
title('Orijinal Resim');

% Görüntüyü gri tonlamaya çevir
gri_img = rgb2gray(img);

% Gri tonlamalı görüntüyü göster
subplot(1, 2, 2);
imshow(gri_img);
title('Gri Tonlamalı Resim');

% Yeni görüntüyü kaydet
imwrite(gri_img, 'peppers_gri.png');
```

## Görüntü Manipülasyonu

Görüntüleri yeniden boyutlandırma, döndürme ve kesme gibi işlemler sıkça kullanılır.

- **`imresize(img, scale)`**: Görüntüyü `scale` oranında yeniden boyutlandırır.
- **`imrotate(img, angle)`**: Görüntüyü `angle` açısı kadar döndürür.
- **`imcrop(img, [xmin ymin width height])`**: Görüntünün belirtilen dikdörtgen alanını keser.

**Örnek:**

```octave
pkg load image;
img = imread(fullfile(OCTAVE_HOME, '..', 'share', 'octave', '6.2.0', 'imagelib', 'peppers.png'));

% Görüntüyü yarı boyutuna küçült
kucuk_img = imresize(img, 0.5);

% Görüntüyü 30 derece döndür
dondurulmus_img = imrotate(img, 30);

% Görüntünün bir bölümünü kes
kesilmis_img = imcrop(img, [150, 60, 200, 180]); % [x, y, genişlik, yükseklik]

figure;
subplot(2,2,1); imshow(img); title('Orijinal');
subplot(2,2,2); imshow(kucuk_img); title('Yeniden Boyutlandırılmış');
subplot(2,2,3); imshow(dondurulmus_img); title('Döndürülmüş');
subplot(2,2,4); imshow(kesilmis_img); title('Kesilmiş');
```

## Görüntü Analizi

Görüntü analizi, bir görüntüden anlamlı bilgiler çıkarmayı içerir. Kenar tespiti ve histogram analizi yaygın analiz teknikleridir.

- **`edge(img, 'sobel')`**: Görüntüdeki kenarları (yoğunluk değişimlerinin olduğu yerler) tespit eder. `sobel`, `canny` gibi farklı algoritmalar kullanılabilir.
- **`imhist(img)`**: Görüntünün yoğunluk (parlaklık) dağılımını gösteren bir histogram çizer.

**Örnek:**

```octave
pkg load image;
img = imread(fullfile(OCTAVE_HOME, '..', 'share', 'octave', '6.2.0', 'imagelib', 'peppers.png'));
gri_img = rgb2gray(img);

% Kenar tespiti
kenarlar = edge(gri_img, 'sobel');

% Histogram analizi
figure;
subplot(2, 2, 1);
imshow(gri_img);
title('Gri Tonlamalı Resim');

subplot(2, 2, 2);
imhist(gri_img);
title('Histogram');

subplot(2, 2, 3);
imshow(kenarlar);
title('Kenar Tespiti (Sobel)');
```
Histogram, görüntüdeki piksel parlaklık seviyelerinin dağılımını gösterir. Bu, görüntünün kontrastı ve parlaklığı hakkında bilgi verir.

---
[Ana Sayfaya Dön](./)
