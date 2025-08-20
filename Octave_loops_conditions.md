---
layout: default
title: "Octave'de Döngüler ve Koşullar"
---

# Octave'de Döngüler ve Koşullar

Octave, diğer programlama dillerinde olduğu gibi, kod akışını kontrol etmek için koşullu ifadeler (`if`, `else`, `elseif`) ve döngüler (`for`, `while`, `do-until`) sunar. Bu yapılar, tekrarlayan görevleri otomatikleştirmek ve belirli koşullara göre farklı kod bloklarını çalıştırmak için temel araçlardır.

## Temel Kontrol Yapıları

### `if` Koşullu İfadesi

`if` yapısı, bir koşulun doğru olup olmadığını kontrol eder ve buna göre bir kod bloğunu çalıştırır.

```octave
x = 10;
if (x > 5)
  disp('x, 5' ve 'den büyüktür.');
elsif (x < 5)
  disp('x, 5' ve 'den küçüktür.');
else
  disp('x, 5'e eşittir.');
end
```

### `for` Döngüsü

`for` döngüsü, belirli bir sayıda tekrar eden işlemler için kullanılır. Genellikle bir vektörün veya aralığın elemanları üzerinde gezinmek için kullanılır.

```octave
toplam = 0;
for i = 1:10  % i, 1'den 10'a kadar değerler alır
  toplam = toplam + i;
end
fprintf('1'den 10'a kadar olan sayıların toplamı: %d\n', toplam);
```

### `while` Döngüsü

`while` döngüsü, belirli bir koşul doğru olduğu sürece bir kod bloğunu tekrar tekrar çalıştırır.

```octave
n = 1;
while (n^2 < 200)
  fprintf('n = %d, n^2 = %d\n', n, n^2);
  n = n + 1;
end
```

## İleri Düzey Uygulama Örnekleri

Döngüler ve koşullar, karmaşık sayısal algoritmaları ve simülasyonları uygulamak için bir araya getirilebilir.

### Newton-Raphson Metodu ile Kök Bulma

Newton-Raphson metodu, bir fonksiyonun kökünü (yani `f(x) = 0` yapan `x` değerini) iteratif olarak bulmak için kullanılan güçlü bir sayısal tekniktir. Algoritma, bir başlangıç tahmininden başlar ve `x_yeni = x_eski - f(x_eski) / f'(x_eski)` formülünü kullanarak daha iyi tahminlere yakınsar. `while` döngüsü, istenen hassasiyete ulaşılana kadar bu işlemi tekrarlamak için idealdir.

```octave
% Kökünü bulmak istediğimiz fonksiyon: f(x) = x^2 - 2
f = @(x) x.^2 - 2;
% Fonksiyonun türevi: f'(x) = 2x
df = @(x) 2*x;

% Başlangıç tahmini
x0 = 1.5;
% İstenen tolerans (hata payı)
tolerans = 1e-6;
% Maksimum iterasyon sayısı (sonsuz döngüyü önlemek için)
max_iter = 100;

x = x0;
fprintf('Iterasyon   x            f(x)\n');
fprintf('----------------------------------\n');

for i = 1:max_iter
    fx = f(x);
    fprintf('%-10d %-12.6f %-12.6f\n', i, x, fx);
    
    % Eğer köke yeterince yakınsak döngüden çık
    if abs(fx) < tolerans
        fprintf('Kök, %d iterasyonda bulundu.\n', i);
        break;
    end
    
    % Newton-Raphson formülü
    x = x - fx / df(x);
end

if i == max_iter
    fprintf('Maksimum iterasyon sayısına ulaşıldı. Kök bulunamadı.\n');
end

fprintf('\nTahmini kök: %.8f\n', x);
```

### Monte Carlo Simülasyonu ile Pi Sayısını Tahmin Etme

Monte Carlo yöntemleri, rastgele sayılar kullanarak problemleri çözmeye dayanan bir hesaplama tekniğidir. Pi (π) sayısını tahmin etmek için popüler bir Monte Carlo simülasyonu, birim kare içine rastgele noktalar atmak ve bu noktalardan kaçının merkezdeki birim çeyrek dairenin içine düştüğünü saymaktır. Alanların oranı (`(daire alanı) / (kare alanı) = (πr²) / (2r)² = π/4`) kullanılarak π tahmin edilebilir.

```octave
% Toplam deneme sayısı
N = 100000;

% Daire içine düşen noktaların sayacı
icerde_kalan_nokta_sayisi = 0;

% Döngü ile rastgele noktalar üret ve kontrol et
for i = 1:N
    % [0, 1] aralığında rastgele x ve y koordinatları üret
    x = rand();
    y = rand();
    
    % Noktanın orijine olan uzaklığını hesapla (d = sqrt(x^2 + y^2))
    % Eğer d < 1 ise, nokta dairenin içindedir.
    if (x^2 + y^2) <= 1
        icerde_kalan_nokta_sayisi = icerde_kalan_nokta_sayisi + 1;
    end
end

% Pi sayısını tahmin et
pi_tahmini = 4 * (icerde_kalan_nokta_sayisi / N);

fprintf('%d deneme sonucunda Pi'nin tahmini değeri: %.6f\n', N, pi_tahmini);
fprintf('Gerçek Pi değeri: %.6f\n', pi);
```

### Basit Görüntü İşleme

`for` döngüleri, bir görüntünün pikselleri üzerinde gezinerek parlaklık ayarlama, gri tonlamaya çevirme veya basit filtreler uygulama gibi temel görüntü işleme görevleri için kullanılabilir.

**Not:** Bu örnek için `image` paketi gerekebilir. `pkg load image` komutu ile yükleyebilirsiniz. Octave'de döngülerle piksel işleme yavaş olabilir; daha hızlı işlemler için genellikle vektörleştirilmiş fonksiyonlar tercih edilir. Ancak bu örnek, döngülerin konseptini göstermek için kullanışlıdır.

```octave
% Image paketini yükle
pkg load image;

% Örnek bir renkli resim oluştur (veya imread('dosya.jpg') ile oku)
img = uint8(cat(3, 10*ones(100,100), 50*ones(100,100), 200*ones(100,100)));

% Resmin boyutlarını al
[yukseklik, genislik, kanallar] = size(img);

% Yeni (gri tonlamalı) resim için boş bir matris oluştur
gri_img = uint8(zeros(yukseklik, genislik));

% Pikseller üzerinde döngü ile gezin
for i = 1:yukseklik
    for j = 1:genislik
        % Renkli pikselin R, G, B değerlerini al
        R = double(img(i, j, 1));
        G = double(img(i, j, 2));
        B = double(img(i, j, 3));
        
        % Gri tonlama için ortalama değer formülü
        gri_deger = (R * 0.299) + (G * 0.587) + (B * 0.114);
        
        % Yeni resme ata
        gri_img(i, j) = uint8(gri_deger);
    end
end

% Orijinal ve yeni resmi göster
figure;
subplot(1, 2, 1);
imshow(img);
title('Orijinal Resim');

subplot(1, 2, 2);
imshow(gri_img);
title('Gri Tonlamalı Resim');
```

---
[Ana Sayfaya Dön](./)