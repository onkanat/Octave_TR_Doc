---
layout: default
title: "Octave'de İstatistik ve Veri Analizi"
---

# Octave'de İstatistik ve Veri Analizi

Octave, `statistics` paketi ile istatistiksel analiz ve veri işleme için zengin bir fonksiyon seti sunar. Bu paket, olasılık dağılımları, hipotez testleri ve temel istatistiksel ölçümler gibi birçok konuyu kapsar.

**Not:** Bu bölümdeki fonksiyonları kullanmadan önce `statistics` paketinin yüklenmesi gerekebilir. `pkg load statistics` komutunu kullanarak paketi yükleyebilirsiniz.

## Olasılık Dağılımları

Octave, çeşitli olasılık dağılımları için rastgele sayılar üretme (random number generation), olasılık yoğunluk fonksiyonunu (PDF) ve kümülatif dağılım fonksiyonunu (CDF) hesaplama yeteneklerine sahiptir.

- **Normal Dağılım:** `normrnd`, `normpdf`, `normcdf`
- **Poisson Dağılımı:** `poissrnd`, `poisspdf`, `poisscdf`
- **Binom Dağılımı:** `binornd`, `binopdf`, `binocdf`

**Örnek: Normal Dağılımı Görselleştirme**

```octave
pkg load statistics;

% Ortalama (mu) = 0, Standart sapma (sigma) = 1 olan standart normal dağılım
mu = 0;
sigma = 1;

% 1. Rastgele sayılar üretme
rasgele_sayilar = normrnd(mu, sigma, [1, 1000]); % 1000 adet rastgele sayı

% 2. Olasılık Yoğunluk Fonksiyonunu (PDF) çizme
x = -4:0.1:4;
y_pdf = normpdf(x, mu, sigma);

figure;
subplot(1, 2, 1);
hist(rasgele_sayilar, 20);
title('Normal Dağılımdan Rastgele Sayılar');

subplot(1, 2, 2);
plot(x, y_pdf, 'b-', 'LineWidth', 2);
title('Normal Dağılım PDF');
xlabel('x');
ylabel('Yoğunluk');
grid on;
```

## Hipotez Testleri

Hipotez testleri, bir veri örneğinden yola çıkarak bir popülasyon hakkındaki bir iddiayı (hipotezi) değerlendirmek için kullanılır. `t-testi` (t-test), iki grubun ortalamalarının istatistiksel olarak anlamlı bir şekilde farklı olup olmadığını test etmek için yaygın olarak kullanılır.

**Örnek: İki Örneklemli t-Testi**

İki farklı öğrenci grubunun sınav notlarının ortalamaları arasında anlamlı bir fark olup olmadığını test edelim.

```octave
pkg load statistics;

% Grup A ve Grup B'nin sınav notları
grup_A = [82, 88, 75, 91, 85, 79, 94];
grup_B = [76, 82, 70, 78, 80, 85, 73];

% İki örneklemli t-testi uygula
% H0: Ortalamalar arasında fark yoktur.
% H1: Ortalamalar arasında fark vardır.
[h, pval, ci, stats] = ttest2(grup_A, grup_B);

fprintf('Hipotez Testi Sonuçları:\n');
fprintf('------------------------\n');
fprintf('p-değeri (p-value): %.4f\n', pval);

alpha = 0.05; % Anlamlılık düzeyi
if h == 1
    fprintf('H0 hipotezi reddedildi (p < %.2f).\n', alpha);
    fprintf('Grupların ortalamaları arasında istatistiksel olarak anlamlı bir fark vardır.\n');
else
    fprintf('H0 hipotezi reddedilemedi (p >= %.2f).\n', alpha);
    fprintf('Grupların ortalamaları arasında anlamlı bir fark bulunamamıştır.\n');
endif

fprintf('t-istatistiği: %.4f\n', stats.tstat);
```

## Veri Seti Analizi

Octave, dış dosyalardan (örneğin CSV) veri okuyabilir ve bu veriler üzerinde temel istatistiksel analizler yapabilir.

- **`csvread`**: Virgülle ayrılmış değerler (CSV) dosyasını okur.
- **`mean`, `std`, `median`, `min`, `max`**: Temel istatistiksel ölçümleri hesaplar.

**Örnek: Bir CSV Dosyasındaki Veriyi Analiz Etme**

`veri.csv` adında bir dosyamız olduğunu varsayalım:
```csv
1.2,5.5
2.1,6.1
3.0,7.2
4.5,8.9
5.8,10.5
```

```octave
pkg load statistics;

% Örnek bir CSV dosyası oluştur
data_matrix = [1.2, 5.5; 2.1, 6.1; 3.0, 7.2; 4.5, 8.9; 5.8, 10.5];
csvwrite('veri.csv', data_matrix);

% CSV dosyasını oku
veri = csvread('veri.csv');

x = veri(:, 1); % Birinci sütun
y = veri(:, 2); % İkinci sütun

% Temel istatistikleri hesapla
ortalama_y = mean(y);
standart_sapma_y = std(y);
medyan_y = median(y);

fprintf('Veri Seti Analizi (Y Sütunu):\n');
fprintf('  Ortalama: %.2f\n', ortalama_y);
fprintf('  Standart Sapma: %.2f\n', standart_sapma_y);
fprintf('  Medyan: %.2f\n', medyan_y);

% Veriyi görselleştir
figure;
plot(x, y, 'o-');
title('Veri Seti Görselleştirmesi');
xlabel('X Değerleri');
ylabel('Y Değerleri');
grid on;
```

---
[Ana Sayfaya Dön](./)

```