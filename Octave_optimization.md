---
layout: default
title: "Octave'de Optimizasyon"
---

# Octave'de Optimizasyon

Optimizasyon, belirli kısıtlamalar altında bir fonksiyonun minimum veya maksimum değerini bulma sürecidir. Octave, `optim` paketi aracılığıyla çeşitli optimizasyon problemlerini çözmek için güçlü fonksiyonlar sunar.

**Not:** Bu bölümdeki fonksiyonları kullanmadan önce `optim` paketinin yüklenmesi gerekebilir. `pkg load optim` komutunu kullanarak paketi yükleyebilirsiniz.

## Fonksiyon Minimizasyonu

Octave'de bir fonksiyonun minimumunu bulmak için en yaygın kullanılan fonksiyonlardan bazıları şunlardır:

- **`fminunc`**: Kısıtlamasız (unconstrained) optimizasyon için kullanılır. Bir başlangıç noktasından başlayarak bir fonksiyonun yerel minimumunu bulmaya çalışır.
- **`sqp`**: Kısıtlamalı (constrained) optimizasyon için kullanılan daha genel bir fonksiyondur. SQP (Sequential Quadratic Programming) algoritmasını kullanır.

### `fminunc` ile Kısıtlamasız Optimizasyon

`fminunc`, bir fonksiyonun minimumunu bulmak için gradyan tabanlı yöntemler kullanır. Bu nedenle, genellikle türevlenebilir fonksiyonlar için daha etkilidir.

**Örnek: Rosenbrock Fonksiyonunun Minimumunu Bulma**

Rosenbrock fonksiyonu, optimizasyon algoritmalarını test etmek için sıkça kullanılan bir fonksiyondur. Global minimumu `(1, 1)` noktasındadır.

`f(x, y) = (1-x)² + 100(y - x²)²`

```octave
pkg load optim;

% Rosenbrock fonksiyonunu tanımla
rosenbrock = @(x) (1-x(1))^2 + 100*(x(2) - x(1)^2)^2;

% Başlangıç noktası
x0 = [-1, 2];

% Optimizasyon seçenekleri (isteğe bağlı)
options = optimset('Display', 'iter', 'TolX', 1e-6);

% fminunc ile minimumu bul
[x_min, fval, exitflag, output] = fminunc(rosenbrock, x0, options);

fprintf('\nMinimumun bulunduğu nokta: [%.4f, %.4f]\n', x_min(1), x_min(2));
fprintf('Fonksiyonun minimum değeri: %.4e\n', fval);
fprintf('Çıkış durumu (1 ise başarılı): %d\n', exitflag);
```
`Display`, 'iter' seçeneği, optimizasyon sürecinin her adımını ekrana yazdırır, bu da algoritmanın nasıl çalıştığını görmek için faydalıdır.

## Uygulama: Model Parametrelerini Optimize Etme

Optimizasyonun en pratik uygulamalarından biri, bir modelin parametrelerini, modelin çıktısı ile gerçek veriler arasındaki hatayı minimize edecek şekilde ayarlamaktır. Bu, "eğri uydurma" (curve fitting) probleminin bir başka şeklidir.

**Örnek: Kimyasal Reaksiyon Hız Sabitini Bulma**

Bir kimyasal reaksiyonun konsantrasyonunun zamanla değişimini gösteren bir modelimiz olduğunu varsayalım: `C(t) = C₀ * exp(-k*t)`. Amacımız, deneysel verileri kullanarak `C₀` (başlangıç konsantrasyonu) ve `k` (hız sabiti) parametrelerini en iyi şekilde tahmin etmektir.

Bunun için, modelin tahmini ile gerçek veri arasındaki "kareler toplamı hatasını" (sum of squared errors) minimize eden bir amaç fonksiyonu tanımlayacağız.

```octave
pkg load optim;

% Deneysel veriler (zaman ve konsantrasyon)
t_data = [0, 1, 2, 3, 4, 5, 6];
C_data = [1.0, 0.6, 0.35, 0.2, 0.1, 0.05, 0.02];

% Model fonksiyonu
model = @(p, t) p(1) * exp(-p(2) * t); % p(1)=C₀, p(2)=k

% Amaç fonksiyonu (hata kareler toplamı)
amac_fonksiyonu = @(p) sum((model(p, t_data) - C_data).^2);

% Parametreler için başlangıç tahmini [C₀, k]
p0 = [1.0, 0.5];

% Optimizasyon ile en iyi parametreleri bul
options = optimset('TolX', 1e-6);
[p_best, hata] = fminunc(amac_fonksiyonu, p0, options);

C0_best = p_best(1);
k_best = p_best(2);

fprintf('Optimize edilmiş parametreler:\n');
fprintf('  C₀ = %.4f\n', C0_best);
fprintf('  k  = %.4f\n', k_best);
fprintf('Minimum hata kareler toplamı: %.4f\n', hata);

% Sonuçları görselleştir
figure;
plot(t_data, C_data, 'ko', 'DisplayName', 'Deneysel Veri');
hold on;
t_fit = linspace(0, 6, 100);
C_fit = model(p_best, t_fit);
plot(t_fit, C_fit, 'b-', 'LineWidth', 2, 'DisplayName', 'Optimize Edilmiş Model');
legend('show');
xlabel('Zaman (s)');
ylabel('Konsantrasyon');
title('Model Optimizasyonu');
grid on;
```

---
[Ana Sayfaya Dön](./)
