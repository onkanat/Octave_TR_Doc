---
layout: default
title: "Octave Mühendislik Alıştırmaları"
lang: tr
konu: muhendislik
seviye: ileri
tur: alistirma
kod: muhendislik_alistirmalari.m
redirect_from: [/Octave_muhendislik_alistirmalari.html]
---

# Octave Mühendislik Alıştırmaları

Bu bölüm, mühendislik hesaplamalarında modüler programlama (fonksiyonlar, alt programlar) ve
karar mekanizmalarının kullanımına odaklanan ileri düzey problemleri içerir. Beş problem tek
betikte toplanmıştır; sayfadaki çıktı bloğu betiğin ölçülmüş koşusudur (GNU Octave 11.3.0).

> **Önemli Not:** Python ve C++ gibi dillerin aksine, Octave (ve MATLAB) **1-tabanlı
> indisleme (1-based indexing)** kullanır. Yani bir dizinin ilk elemanına `dizi(0)` ile değil,
> `dizi(1)` ile erişilir. Bu fark özellikle döngüler ve matris işlemlerinde kritik öneme
> sahiptir.

## Ne öğreneceksiniz

- Betik içinde **yerel fonksiyon** tanımlamayı (`hesapla_gerilme`, `direnc_hesapla`) ve
  bunları ana akıştan çağırmayı
- `if / elseif / else` ile üç bantlı sınıflandırma yapmayı (Reynolds sayısında akış rejimi)
- `strcmp` ile metin parametre alan fonksiyon yazmayı (seri/paralel direnç)
- `rand` + `round` ile 10 bitlik ADC dönüşümünü simüle etmeyi ve sonuçları 1-tabanlı diziye yazmayı
- Newton-Raphson yinelemesini `for` + `break` ile kurup yakınsamayı `|h| < tol` ile ölçmeyi

## Çalıştırma

```sh
octave --no-gui muhendislik_alistirmalari.m
```

Betik reponun kökünde ve tek başına koşar; ek paket yüklemez, dosya yazmaz, grafik çizmez.
`rand("seed", 42)` sabitlendiği için ADC örnekleri iki koşuda **birebir aynıdır**. Bu makinede
`octave --no-gui` Qt/cocoa eklentisi yüzünden betiği yüklemeden düşüyor (**EXIT=134**);
sayfadaki blok aynı çıktıyı veren `octave-cli` ile ölçüldü.

## Kod

### Fonksiyonlar neden `clear` satırından sonra?

Octave bir betiği `function` sözcüğüyle başlatırsanız dosyayı **fonksiyon dosyası** sayar ve
içindeki komutları çalıştırmaz. Bu yüzden betik `clear; clc; close all; 1;` ile başlar,
fonksiyonlar ondan sonra gelir ve kullanımdan **önce** tanımlanır. Aynı desen
`fonksiyon_ornekleri` notunda da kullanıldı.

### 11. Maksimum Eğilme Gerilmesi (Basit)

**Problem:** Bir kirişe etki eden moment (`M`) ve atalet momenti (`I`) değerlerini alarak,
maksimum eğilme gerilmesini (`σ = M·c/I`) hesaplayan bir `function` yazınız. Çözüm `[11]`
bölümünde; `M = 12 kNm, c = 0,15 m, I = 8,5e-6 m⁴` için `σ = 211,76 MPa`.

### 12. Reynolds Sayısı ve Akış Rejimi (Orta)

**Problem:** Bir boru hattındaki akışın Reynolds sayısını (`Re = ρvD/μ`) hesaplayan ve akışın
"Laminer", "Geçiş" veya "Türbülanslı" olduğunu `if-else` blokları ile belirten programı yazınız.
`[12]` bölümü üç hızı sırayla dener (`Re = 1000 / 2500 / 60000`) ve üç rejimi de gösterir:
`Re < 2300` laminer, `2300 ≤ Re ≤ 4000` geçiş, üstü türbülanslı.

### 13. Eşdeğer Direnç Hesaplama (Orta)

**Problem:** Bir elektrik devresindeki seri veya paralel bağlı dirençlerin eşdeğerini hesaplayan
bir yapı tasarlayınız. `[13]` bölümü `direnc_hesapla(direncler, tip)` fonksiyonunu kullanır:
seri için `sum`, paralel için `1/sum(1./direncler)`. Nottaki `Reş` ve `direnç_hesapla` adları
Türkçe karakter taşıdığı için ASCII karşılıklarıyla (`R_es`, `direnc_hesapla`) yazıldı —
tanımlayıcıda Türkçe harf kullanmak taşınabilir değildir.

### 14. ADC Simülasyonu ve Dizi Yönetimi (İleri)

**Problem:** Bir ADC (Analog-Digital Converter) simülasyonu yapın. 0-5 V arası gelen voltajı
10-bitlik (0-1023) bir tamsayıya dönüştüren ve bu işlemi 10 farklı örneklem için diziye
kaydeden programı yazınız. `[14]` bölümü `round((V/5)*1023)` dönüşümünü kullanır ve dizinin
ilk elemanına `adc_sonuclari(1)` ile erişir (1-tabanlı indeks).

### 15. Newton-Raphson ile Sürtünme Faktörü (İleri)

**Problem:** Newton-Raphson yöntemini kullanarak, lineer olmayan bir denklemin (örneğin
Colebrook denklemi temelli bir basitleştirilmiş sürtünme faktörü) kökünü bulunuz. Örnek model
olarak `f(x) = x³ - 5x + 1` alınmıştır; türevi `f'(x) = 3x² - 5`. `[15]` bölümü her yinelemeyi
yazdırır ve `|h| < 1e-6` sağlandığında `break` ile durur.

### Betik

Aşağıdaki betik dosyanın tamamıdır (`kod: muhendislik_alistirmalari.m`).

```octave
clear; clc; close all;
1;

%% 0. Hazirlik: yerel fonksiyonlar kullanimdan once tanimlanir
% Octave (ve MATLAB) 1-tabanli indeksleme kullanir: ilk eleman dizi(1).
warning("off", "all");

%% Yerel fonksiyonlar
function sigma = hesapla_gerilme(M, c, I)
  % Egilme gerilmesi: sigma = M * c / I  (Pa)
  sigma = (M * c) / I;
end

function R_es = direnc_hesapla(direncler, tip)
  % Seri: toplam, paralel: harmonik toplam
  if strcmp(tip, "seri")
    R_es = sum(direncler);
  elseif strcmp(tip, "paralel")
    R_es = 1 / sum(1 ./ direncler);
  else
    error("Hatali tip: \"seri\" veya \"paralel\" giriniz.");
  end
end

%% 11. Maksimum egilme gerilmesi
moment = 12e3;      % N*m
mesafe = 0.15;      % m (tarafsiz eksene uzaklik)
atalet = 8.5e-6;    % m^4
max_gerilme = hesapla_gerilme(moment, mesafe, atalet);
printf("[11] egilme gerilmesi: M = %g Nm, c = %g m, I = %g m^4\n", moment, mesafe, atalet);
printf("[11]   sigma = M*c/I = %.2f Pa = %.2f MPa\n", max_gerilme, max_gerilme/1e6);

%% 12. Reynolds sayisi ve akis rejimi
rho = 1000;     % kg/m^3 (su)
mu = 0.001;     % Pa.s
D = 0.05;       % m (boru capi)
printf("[12] Reynolds: rho = %g kg/m^3, mu = %g Pa.s, D = %g m\n", rho, mu, D);
for v = [0.02, 0.05, 1.2]
  Re = (rho * v * D) / mu;
  if Re < 2300
    rejim = "LAMINER";
  elseif Re >= 2300 && Re <= 4000
    rejim = "GECIS BOLGESI";
  else
    rejim = "TURBULANSLI";
  end
  printf("[12]   v = %.2f m/s -> Re = %8.1f -> %s\n", v, Re, rejim);
end

%% 13. Esdeger direnc: seri ve paralel
R_liste = [100, 220, 330];     % ohm
printf("[13] direncler: %s ohm\n", mat2str(R_liste));
printf("[13]   seri esdeger   : %.2f ohm\n", direnc_hesapla(R_liste, "seri"));
printf("[13]   paralel esdeger: %.2f ohm\n", direnc_hesapla(R_liste, "paralel"));

%% 14. ADC simulasyonu: 0-5 V -> 10 bit (0-1023)
rand("seed", 42);
ornek_sayisi = 10;
adc_sonuclari = zeros(1, ornek_sayisi);
printf("[14] ADC: %d ornek, 0-5 V -> 0-1023 (10 bit)\n", ornek_sayisi);
for i = 1:ornek_sayisi
  analog_V = rand() * 5;
  dijital_deger = round((analog_V / 5) * 1023);
  adc_sonuclari(i) = dijital_deger;
  printf("[14]   ornek %2d: analog = %.4f V, dijital = %4d\n", i, analog_V, dijital_deger);
end
printf("[14]   min = %d, max = %d, ortalama = %.1f (1 tabanli dizi: adc(1) = %d)\n", ...
       min(adc_sonuclari), max(adc_sonuclari), mean(adc_sonuclari), adc_sonuclari(1));

%% 15. Newton-Raphson: x^3 - 5x + 1 = 0
f  = @(x) x^3 - 5*x + 1;
df = @(x) 3*x^2 - 5;
x = 2.0;
tol = 1e-6;
max_iter = 20;
printf("[15] Newton-Raphson: f(x) = x^3 - 5x + 1, x0 = %.1f, tol = %g\n", x, tol);
for i = 1:max_iter
  h = f(x) / df(x);
  x = x - h;
  printf("[15]   iterasyon %2d: x = %.10f, |h| = %.2e\n", i, x, abs(h));
  if abs(h) < tol
    break;
  end
end
printf("[15]   bulunan kok: %.10f (%d iterasyonda), f(x) = %.2e\n", x, i, f(x));

%% Ozet
printf("\nOzet: sigma = %.2f MPa, Re = %.0f (v = 1.2 m/s), R_seri = %.1f ohm,\n", ...
       max_gerilme/1e6, (rho*1.2*D)/mu, direnc_hesapla(R_liste, "seri"));
printf("      %d ADC ornegi ve x^3 - 5x + 1 denkleminin koku %.10f olculdu.\n", ...
       ornek_sayisi, x);
```

## Beklenen Çıktı

```
[11] egilme gerilmesi: M = 12000 Nm, c = 0.15 m, I = 8.5e-06 m^4
[11]   sigma = M*c/I = 211764705.88 Pa = 211.76 MPa
[12] Reynolds: rho = 1000 kg/m^3, mu = 0.001 Pa.s, D = 0.05 m
[12]   v = 0.02 m/s -> Re =   1000.0 -> LAMINER
[12]   v = 0.05 m/s -> Re =   2500.0 -> GECIS BOLGESI
[12]   v = 1.20 m/s -> Re =  60000.0 -> TURBULANSLI
[13] direncler: [100 220 330] ohm
[13]   seri esdeger   : 650.00 ohm
[13]   paralel esdeger: 56.90 ohm
[14] ADC: 10 ornek, 0-5 V -> 0-1023 (10 bit)
[14]   ornek  1: analog = 1.5599 V, dijital =  319
[14]   ornek  2: analog = 0.5179 V, dijital =  106
[14]   ornek  3: analog = 2.8173 V, dijital =  576
[14]   ornek  4: analog = 1.1304 V, dijital =  231
[14]   ornek  5: analog = 2.4711 V, dijital =  506
[14]   ornek  6: analog = 4.7250 V, dijital =  967
[14]   ornek  7: analog = 1.8594 V, dijital =  380
[14]   ornek  8: analog = 4.1525 V, dijital =  850
[14]   ornek  9: analog = 0.4542 V, dijital =   93
[14]   ornek 10: analog = 3.4041 V, dijital =  696
[14]   min = 93, max = 967, ortalama = 472.4 (1 tabanli dizi: adc(1) = 319)
[15] Newton-Raphson: f(x) = x^3 - 5x + 1, x0 = 2.0, tol = 1e-06
[15]   iterasyon  1: x = 2.1428571429, |h| = 1.43e-01
[15]   iterasyon  2: x = 2.1285714286, |h| = 1.43e-02
[15]   iterasyon  3: x = 2.1284190811, |h| = 1.52e-04
[15]   iterasyon  4: x = 2.1284190638, |h| = 1.73e-08
[15]   bulunan kok: 2.1284190638 (4 iterasyonda), f(x) = 1.78e-15

Ozet: sigma = 211.76 MPa, Re = 60000 (v = 1.2 m/s), R_seri = 650.0 ohm,
      10 ADC ornegi ve x^3 - 5x + 1 denkleminin koku 2.1284190638 olculdu.
```

## Öne Çıkan Noktalar

- **1-tabanlı indeks ölçüldü:** ADC dizisinin ilk değeri `adc_sonuclari(1) = 319`;
  `adc_sonuclari(0)` yazılsaydı `error: subscript indices must be integers` alınırdı.
- **Newton-Raphson dört adımda yakınsıyor:** `x0 = 2`'den `2,1284190638`'e 4 yinelemede iniyor,
  `f(x)` değeri `1,78e-15`'e düşüyor (makine duyarlılığı). Yineleme sayısı başlangıç tahminine
  duyarlıdır: `x0 = 0` seçilirse türev sıfıra yakın olduğu için yöntem ıraksar.
- **Dirençte paralel kol:** üç direnç (`100, 220, 330 Ω`) seride `650 Ω`, paralelde `56,90 Ω`.
  `1/sum(1./R)` biçimi direnç sayısından bağımsızdır; `R1*R2/(R1+R2)` yalnız iki direnç içindir.
- **ADC'de ölçek:** 1023 böleni 1024 değil — 10 bit 0..1023 aralığı verir. `round` yerine
  `floor` kullanılsaydı 5,0 V tam ölçekte 1024 değil 1023 verirdi; `round` ile 5 V → 1023.
- **Reynolds bantları:** `1000` laminer, `2500` geçiş, `60000` türbülanslı. Bant sınırları
  `&&` ile yazıldı; `2300 <= Re <= 4000` yerine `Re >= 2300 && Re <= 4000` Octave'de de
  çalışır ama zincir karşılaştırma (`2300 <= Re <= 4000`) MATLAB/Octave'de yanlış sonuç verir.

## Alıştırmalar

1. `hesapla_gerilme` fonksiyonuna dördüncü bir çıktı ekleyin (`[sigma, birim]`) ve gerilme
   `> 235 MPa` ise "akma sınırı aşıldı" uyarısı yazdırın (S235 çeliği).
2. Reynolds hesabını bir fonksiyona taşıyın: `[Re, rejim] = reynolds(rho, v, D, mu)`. Üç bant
   için test tablosu üretin ve sınır değerlerinde (`Re = 2300`, `Re = 4000`) hangi rejimin
   seçildiğini yazdırın.
3. ADC'de çözünürlüğü 12 bite çıkarın (`0-4095`) ve aynı 10 örneği yeniden üretin: en küçük
   ölçülebilir gerilim adımı (`5/4096`) kaç mV oluyor?
4. Newton-Raphson'da `max_iter = 3` yapın: kök ne kadar kayıyor? Başlangıç tahminini `x0 = 1`
   ve `x0 = 2,5` ile deneyip yakınsama hızını karşılaştırın.
