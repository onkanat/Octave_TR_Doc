---
layout: default
title: "Octave Sık Kullanılan Fonksiyonlar Listesi"
lang: tr
konu: temel
seviye: baslangic
tur: basvuru
redirect_from: [/Octave_fonksiyon_listesi.html]
---

# Octave Sık Kullanılan Fonksiyonlar Listesi

Octave'de çok sayıda yerleşik fonksiyon bulunur; bu not en sık başvurulanları dört grupta
toplar ve hangi fonksiyonun hangi işi yaptığını tek sayfada verir. Bu bir **başvuru notudur**
(`tur: basvuru`): eşlik eden bir `.m` betiği yoktur, çünkü anlatılan kod değil katalogdur.
Sayfadaki doğrulama çıktısı, listedeki her adın bu Octave sürümünde gerçekten bulunduğunu
ölçer.

## Ne öğreneceksiniz

- Temel matematik, matris, veri işleme ve grafik gruplarındaki yerleşik fonksiyonları
- `help`, `doc` ve `lookfor` ile bir fonksiyonun belgesine nasıl ulaşılacağını
- Listelenen adların kurulu Octave'de var olup olmadığını tek betikle nasıl doğrulayacağınızı
- Hangi işlevin hangi gruba girdiğini (arama yaparken doğru ada gitmek için)
- Resmî belge bağlantısını ve sürüm notlarını nerede bulacağınızı

## Çalıştırma

Bu notta çalıştırılacak bir `.m` betiği yok. Belge okumak için etkileşimli oturumda:

```sh
octave --no-gui --eval "help sqrt"
octave --no-gui --eval "lookfor matrix"
```

Aşağıdaki doğrulama betiğini `kontrol.m` olarak kaydedip `octave-cli kontrol.m` ile
koşabilirsiniz; sayfadaki çıktı tam olarak bu betiğin ölçülmüş sonucudur.

## Kod

```octave
kategoriler = {
  "Temel matematik", {"sqrt","abs","exp","log","floor","ceil","round"};
  "Matris islemleri", {"zeros","ones","eye","size","reshape","transpose","diag","tril","triu","inv","det","eig","svd"};
  "Veri isleme",      {"load","save","who","whos","find","sort","filter","unique"};
  "Grafik",           {"plot","xlabel","ylabel","title","legend","grid","subplot"}};
toplam = 0; eksik = 0;
for k = 1:rows(kategoriler)
  adlar = kategoriler{k,2};
  var = cellfun(@(a) exist(a) > 0, adlar);
  toplam = toplam + numel(adlar); eksik = eksik + sum(~var);
  printf("%-18s %d/%d var", kategoriler{k,1}, sum(var), numel(adlar));
  if any(~var)
    printf("  eksik: %s", strjoin(adlar(~var), ", "));
  end
  printf("\n");
end
printf("Toplam: %d islev, %d eksik\n", toplam, eksik);
```

## Beklenen Çıktı

```
Temel matematik    7/7 var
Matris islemleri   13/13 var
Veri isleme        8/8 var
Grafik             7/7 var
Toplam: 35 islev, 0 eksik
```

## Öne Çıkan Noktalar

### Temel matematiksel işlemler

- `+` toplama, `-` çıkarma, `*` çarpma, `/` bölme, `^` üs alma
- `sqrt` karekök, `abs` mutlak değer, `exp` üstel, `log` logaritma
- `floor` alt tam sayıya, `ceil` üst tam sayıya, `round` en yakın tam sayıya yuvarlar

### Matris işlemleri

- `zeros` sıfır, `ones` birler, `eye` birim matrisi kurar
- `size` boyut verir, `reshape` boyut değiştirir, `transpose` transpoz alır
- `diag` köşegeni alır/kurar, `tril` alt üçgensel, `triu` üst üçgensel parçayı verir
- `inv` ters, `det` determinant, `eig` özdeğer/özvektör, `svd` tekil değer ayrışımı

### Veri işleme

- `load` dosyadan okur, `save` dosyaya yazar
- `who` değişken adlarını, `whos` ad-boyut-tür tablosunu listeler
- `find` koşulu sağlayan öğelerin konumunu, `sort` sıralamayı verir
- `filter` süzgeç uygular, `unique` tekrarları atar

### Grafik

- `plot` çizgi grafiği, `subplot` alt grafik yerleşimi
- `xlabel`, `ylabel`, `title` eksen ve grafik etiketleri
- `legend` efsane, `grid` ızgara ekler

### Belge okuma yolları

- `help <ad>`: fonksiyonun kısa belgesi
- `doc <ad>`: tarayıcıda ayrıntılı belge
- `lookfor <kelime>`: anahtar kelimeyle ilgili fonksiyonları arar
- Resmî belgeler: [docs.octave.org/latest](https://docs.octave.org/latest/)

## Alıştırmalar

1. Doğrulama betiğine `interp1`, `polyfit`, `ode45` adlarını ekleyip hangi gruba girdiklerini
   kendiniz karar verin; çıktıda eksik çıkıyorlarsa `pkg list` ile paket durumunu kontrol edin.
2. `lookfor` ile "matrix" kelimesini aratın; dönen adlardan üçünü seçip `help` çıktısının ilk
   satırını yazdırın.
3. `exist("sqrt")` ile `exist("benim_fonksiyonum")` çıktılarını karşılaştırın: var olan bir
   ad için hangi sayı, olmayan için hangi sayı dönüyor?
