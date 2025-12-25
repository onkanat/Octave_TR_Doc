---
layout: default
title: "Octave Mühendislik Alıştırmaları"
---

# Octave Mühendislik Alıştırmaları

Bu bölüm, mühendislik hesaplamalarında modüler programlama (fonksiyonlar, alt programlar) ve karar mekanizmalarının kullanımına odaklanan ileri düzey problemleri içerir.

> [!IMPORTANT]
> **Önemli Not:** Python ve C++ gibi dillerin aksine, Octave (ve MATLAB) **1-tabanlı indisleme (1-based indexing)** kullanır. Yani bir dizinin ilk elemanına `dizi(0)` ile değil, `dizi(1)` ile erişilir. Bu fark özellikle döngüler ve matris işlemlerinde kritik öneme sahiptir.

---

## 11. Maksimum Eğilme Gerilmesi (Basit)
**Problem:** Bir kirişe etki eden moment ($M$) ve atalet momenti ($I$) değerlerini alarak, maksimum eğilme gerilmesini ($\sigma = \frac{M \cdot c}{I}$) hesaplayan bir `function` yazınız.

```octave
function sigma = hesapla_gerilme(M, c, I)
    % sigma = M * c / I
    sigma = (M * c) / I;
end

% Ana program akışı:
moment = input('Momenti giriniz (Nm): ');
mesafe = input('Tarafsız eksene mesafeyi giriniz (m): ');
atalet = input('Atalet momentini giriniz (m^4): ');

max_gerilme = hesapla_gerilme(moment, mesafe, atalet);
fprintf('Maksimum Eğilme Gerilmesi: %.2f Pascal\n', max_gerilme);
```

---

## 12. Reynolds Sayısı ve Akış Rejimi (Orta)
**Problem:** Bir boru hattındaki akışın Reynolds sayısını ($Re = \frac{\rho v D}{\mu}$) hesaplayan ve akışın "Laminer", "Geçiş" veya "Türbülanslı" olduğunu `if-else` blokları ile belirten programı yazınız.

```octave
% Akışkan özellikleri (örneğin su)
rho = 1000; % kg/m^3
mu = 0.001;  % Pa.s

v = input('Akış hızı (m/s): ');
D = input('Boru çapı (m): ');

Re = (rho * v * D) / mu;

fprintf('Reynolds Sayısı: %.2f\n', Re);

if Re < 2300
    disp('Akış Rejimi: LAMINER');
elseif Re >= 2300 && Re <= 4000
    disp('Akış Rejimi: GEÇİŞ BÖLGESİ');
else
    disp('Akış Rejimi: TÜRBÜLANSLI');
end
```

---

## 13. Eşdeğer Direnç Hesaplama (Orta)
**Problem:** Bir elektrik devresindeki seri veya paralel bağlı dirençlerin eşdeğerini hesaplayan bir yapı tasarlayınız.

```octave
function Reş = direnç_hesapla(direncler, tip)
    % direncler: direnç değerlerini içeren bir vektör
    % tip: 'seri' veya 'paralel'
    
    if strcmp(tip, 'seri')
        Reş = sum(direncler);
    elseif strcmp(tip, 'paralel')
        Reş = 1 / sum(1 ./ direncler);
    else
        error('Hatalı tip! "seri" veya "paralel" giriniz.');
    end
end

% Örnek kullanım:
R_liste = [100, 220, 330]; % Ohm
fprintf('Seri Eşdeğer: %.2f Ohm\n', direnç_hesapla(R_liste, 'seri'));
fprintf('Paralel Eşdeğer: %.2f Ohm\n', direnç_hesapla(R_liste, 'paralel'));
```

---

## 14. ADC Simülasyonu ve Dizi Yönetimi (İleri)
**Problem:** Bir ADC (Analog-Digital Converter) simülasyonu yapın. 0-5V arası gelen voltajı 10-bitlik (0-1023) bir tamsayıya dönüştüren ve bu işlemi 10 farklı örneklem için diziye kaydeden programı yazınız.

```octave
ornek_sayisi = 10;
adc_sonuclari = zeros(1, ornek_sayisi); % 1-tabanlı dizi başlangıcı

for i = 1:ornek_sayisi
    % 0-5V arası rastgele analog voltaj üretimi
    analog_V = rand() * 5; 
    
    % 10-bit dönüşüm: (V / 5) * 1023
    dijital_deger = round((analog_V / 5) * 1023);
    
    % Diziye kaydet (ÖNEMLİ: indis 1'den başlar)
    adc_sonuclari(i) = dijital_deger;
    
    fprintf('Örnek %d: Analog = %.2f V, Dijital = %d\n', i, analog_V, dijital_deger);
end

disp('Kaydedilen Tüm ADC Değerleri:');
disp(adc_sonuclari);
```

---

## 15. Newton-Raphson ile Sürtünme Faktörü (İleri)
**Problem:** Newton-Raphson yöntemini kullanarak, lineer olmayan bir denklemin (örneğin Colebrook denklemi temelli bir basitleştirilmiş sürtünme faktörü) kökünü bulunuz.

```octave
% f(x) = x^3 - 5x + 1  denkleminin kökünü bulalım (Örnek mühendislik modeli)
f = @(x) x^3 - 5*x + 1;
df = @(x) 3*x^2 - 5;

x = 2.0; % Başlangıç tahmini
tol = 1e-6;
max_iter = 20;

for i = 1:max_iter
    h = f(x) / df(x);
    x = x - h;
    
    if abs(h) < tol
        break;
    end
end

fprintf('Bulunan kök: %.6f (%d iterasyonda)\n', x, i);
```

---
[Ana Sayfaya Dön](./)
