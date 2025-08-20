---
layout: default
title: "Octave'de Sinyal İşleme"
---

# Octave'de Sinyal İşleme

Octave, sinyal işleme için güçlü araçlar ve fonksiyonlar içeren `signal` paketini sunar. Bu paket, sinyallerin analizi, tasarımı ve filtrelenmesi için kapsamlı yetenekler sağlar.

**Not:** Bu bölümdeki fonksiyonları kullanmadan önce `signal` paketinin yüklenmesi gerekebilir. `pkg load signal` komutunu kullanarak paketi yükleyebilirsiniz.

## Fourier Dönüşümü (`fft`)

Fourier Dönüşümü, bir sinyali zaman domeninden frekans domenine taşır. Bu, bir sinyalin hangi frekans bileşenlerinden oluştuğunu analiz etmek için temel bir yöntemdir. `fft` (Fast Fourier Transform) fonksiyonu, bu dönüşümü verimli bir şekilde hesaplar.

**Örnek: Bir Ses Sinyalinin Frekans Analizi**

Birden fazla sinüs dalgasının birleşiminden oluşan bir sinyal oluşturalım ve `fft` ile frekanslarını tespit edelim.

```octave
pkg load signal;

% Sinyal parametreleri
Fs = 1000; % Örnekleme frekansı (Hz)
T = 1/Fs;  % Örnekleme periyodu
L = 1500;  % Sinyal uzunluğu
t = (0:L-1)*T; % Zaman vektörü

% İki farklı frekansta sinüs dalgasından oluşan bir sinyal
% f1 = 50 Hz, f2 = 120 Hz
S = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t);

% Sinyale gürültü ekleyelim
X = S + 2*randn(size(t));

% Zaman domenindeki sinyali çiz
subplot(2,1,1);
plot(1000*t(1:50), X(1:50));
title('Gürültülü Sinyal (Zaman Domeni)');
xlabel('t (ms)');
ylabel('X(t)');

% Fourier dönüşümünü uygula
Y = fft(X);

% Frekans spektrumunu hesapla (tek taraflı)
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(L/2))/L; % Frekans domeni

% Frekans domenindeki spektrumu çiz
subplot(2,1,2);
plot(f, P1);
title('Tek Taraflı Genlik Spektrumu');
xlabel('f (Hz)');
ylabel('|P1(f)|');
axis([0 200 0 1.2]); % Frekans aralığını odakla
```
Grafikte, 50 Hz ve 120 Hz'de belirgin zirveler görülür, bu da orijinal sinyalin frekans bileşenlerini doğru bir şekilde tespit ettiğimizi gösterir.

## Filtreleme (`filter`)

Filtreleme, bir sinyaldeki istenmeyen frekans bileşenlerini (genellikle gürültüyü) temizlemek veya belirli frekans aralıklarını izole etmek için kullanılır. `filter` fonksiyonu, dijital bir filtreyi bir sinyale uygular.

Filtre tasarımı için `butter`, `cheby1` gibi fonksiyonlar kullanılır. Aşağıda, bir alçak geçiren filtre (low-pass filter) tasarlayıp gürültülü sinyale uygulayacağız.

**Örnek: Gürültülü Sinyalden Gürültüyü Temizleme**

```octave
pkg load signal;

% Önceki örnekteki gürültülü sinyali kullanalım
Fs = 1000; L = 1500; t = (0:L-1)*(1/Fs);
S = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t);
X = S + 2*randn(size(t));

% Filtre tasarımı
% 200 Hz kesim frekanslı, 6. dereceden bir Butterworth alçak geçiren filtre
Fc = 200; % Kesim frekansı
order = 6;
[b, a] = butter(order, Fc/(Fs/2), 'low');

% Filtreyi sinyale uygula
filtrelenmis_X = filter(b, a, X);

% Orijinal, gürültülü ve filtrelenmiş sinyalleri çiz
figure;
plot(t, S, 'b', 'LineWidth', 1.5, 'DisplayName', 'Orijinal Sinyal');
hold on;
plot(t, X, 'r', 'DisplayName', 'Gürültülü Sinyal');
plot(t, filtrelenmis_X, 'g', 'LineWidth', 2, 'DisplayName', 'Filtrelenmis Sinyal');
hold off;

title('Alçak Geçiren Filtre Uygulaması');
xlabel('Zaman (s)');
ylabel('Genlik');
legend('show');
xlim([0 0.2]); % Grafiğin bir bölümünü yakınlaştır
```
Filtrelenmiş sinyalin, gürültüden arındırılarak orijinal sinyale ne kadar benzediğine dikkat edin.

---
[Ana Sayfaya Dön](./)