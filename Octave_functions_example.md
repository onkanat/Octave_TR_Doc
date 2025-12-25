---
layout: default
title: "Octave Fonksiyon Yazımı ve Örnek Uygulama"
---

# Octave Fonksiyon Yazımı ve Örnek Uygulama

Bu doküman, GNU Octave'de (veya MATLAB'da) fonksiyonların nasıl oluşturulacağını, çağrılacağını ve bir mühendislik problemi üzerinde nasıl uygulanacağını anlatır.

## 1. Octave'de Fonksiyon Yazımı

Octave'de fonksiyonlar genellikle kendi isimleriyle kaydedilen `.m` dosyaları içinde tanımlanır.

**Genel Yapı:**

```octave
function [cikti1, cikti2] = fonksiyon_adi(girdi1, girdi2)
    % AÇIKLAMA: Fonksiyonun ne yaptığını buraya yazın.
    % KULLANIM: [c1, c2] = fonksiyon_adi(a, b)
    
    % İşlemler
    cikti1 = girdi1 + girdi2; 
    cikti2 = girdi1 * girdi2;
end
```

**Dikkat Edilmesi Gerekenler:**

* **Dosya Adı:** Dosya adı, fonksiyon adı ile aynı olmalıdır (örneğin `fonksiyon_adi.m`).
* **Girdiler ve Çıktılar:** Birden fazla girdi ve çıktı tanımlanabilir.
* **Yorum Satırları:** `%` ile başlayan satırlar yorumdur. İlk yorum bloğu `help fonksiyon_adi` komutu ile görüntülenebilir.

## 2. Örnek Uygulama: Daire ve Çizgi Kesişimi

Bu örnekte, üç noktası bilinen bir dairenin merkezini bulacak, iki noktası bilinen bir doğru oluşturacak ve bu ikisinin kesişip kesişmediğini kontrol edeceğiz.

### Dosyalar

Proje `src/` klasörü altında aşağıdaki dosyaları içerir:

1. **`two_point_line.m`**: İki noktadan geçen doğruyu tanımlar.
2. **`circle_center.m`**: Üç noktadan geçen dairenin merkezini ve yarıçapını hesaplar.
3. **`check_intersection.m`**: Daire ve doğrunun kesişim durumunu kontrol eder.
4. **`visualize_intersection.m`**: Tüm bu işlemleri yapan ve sonucu grafiğe döken ana script.

### Kod Analizi

#### 1. Daire Merkezi ve Yarıçapı (`circle_center.m`)

Bu fonksiyon, verilen üç noktanın (`p1`, `p2`, `p3`) oluşturduğu üçgenin çevrel çemberinin merkezini (circumcenter) formüllerle hesaplar. Ayrıca yarıçapı da döndürür.

```octave
[center, radius] = circle_center(p1, p2, p3);
```

#### 2. Doğru Tanımlama (`two_point_line.m`)

İki nokta (`start_point`, `end_point`) alarak doğruyu temsil eden bir vektör döndürür.

```octave
line = two_point_line(start_point, end_point);
```

#### 3. Kesişim Kontrolü (`check_intersection.m`)

Dairenin merkezi ile doğru arasındaki dik uzaklığı hesaplar (`distance`).

* `distance < radius`: Kesişiyor (2 nokta).
* `distance == radius`: Teğet (1 nokta).
* `distance > radius`: Kesişmiyor.

```octave
status = check_intersection(center, radius, line_coords);
```

#### 4. Görselleştirme (`visualize_intersection.m`)

Bu script, tüm parçaları birleştirir:

1. Noktaları tanımlar.
2. Fonksiyonları çağırarak hesaplamaları yapar.
3. `plot` komutları ile daireyi, merkezi, noktaları ve doğruyu çizer.
4. Sonucu ekrana ve grafiğin başlığına yazar.

## 3. Nasıl Çalıştırılır?

Octave komut satırında veya editöründe `src` klasörüne gidin ve `visualize_intersection` komutunu çalıştırın:

```octave
cd src
visualize_intersection
```

Ekrana hesaplanan değerler basılacak ve bir grafik penceresi açılarak geometrik durum gösterilecektir.

---
**Not:** Fonksiyon isimleri rakamla başlayamaz, bu yüzden `2point_line.m` dosyası `two_point_line.m` olarak adlandırılmıştır.
