---
layout: default
title: "Güç Kaynağı Filtresi Analizi (power_supply.m)"
lang: tr
konu: muhendislik
seviye: orta
tur: ders
kod: power_supply.m
redirect_from: [/Octave_power_supply.html]
---

# Güç Kaynağı Filtresi Analizi (`power_supply.m`)

Bu sayfa, `power_supply.m` dosyasındaki Octave kodunun ne yaptığını adım adım açıklar. Kod, bir
**RC alçak geçiren filtre** ile bir **LR alçak geçiren filtrenin** frekans cevabını birleştirip
toplam genlik ve faz tepkisini çizer. Sayfadaki çıktı bloğu betiğin ölçülmüş koşusudur
(GNU Octave 11.3.0): kesim frekansları, altı frekanstaki kazanç/faz ve −3 dB noktası ölçülmüştür.

## Ne öğreneceksiniz

- İki birinci dereceden filtrenin transfer fonksiyonunu (`H = 1/(1 + jωRC)`, `H = 1/(1 + jωL/R)`)
  tek satırda yazmayı
- `logspace` ile 10 Hz – 1 MHz arasında logaritmik frekans ekseni kurmayı
- Karmaşık kazancı `20*log10(abs(H))` ile dB'ye, `angle(H)*180/pi` ile dereceye çevirmeyi
- Seri iki filtrenin toplam cevabının **çarpım** olduğunu ve kesim frekanslarının nasıl
  hesaplandığını (`fc = 1/(2πRC)`, `fc = R/(2πL)`)
- Başsız oturumda iki panelli Bode benzeri grafiği `print -dpng` ile dosyaya yazmayı

## Çalıştırma

```sh
octave --no-gui power_supply.m
```

Betik reponun kökünde ve tek başına koşar; ek paket yüklemez (`abs`, `angle`, `logspace`,
`semilogx` çekirdektedir). Grafik `assets/img/power_supply-bode.png` dosyasına yazılır. Bu
makinede `octave --no-gui` Qt/cocoa eklentisi yüzünden betiği yüklemeden düşüyor
(**EXIT=134**); sayfadaki blok aynı çıktıyı veren `octave-cli` ile ölçüldü.

## Kod

### 1) Başlangıç ve ortam temizliği

Kodun başında `clear` ile çalışma alanındaki değişkenler temizlenir, `clc` ile komut penceresi
temizlenir, `close all` ile açık figürler kapatılır. Bu sayede analiz, önceki çalışmalardan
bağımsız ve temiz bir ortamda başlar.

### 2) Devre bileşenlerinin tanımı

Kodda şu parametreler tanımlanır:

- `R1 = 10` Ω: RC filtresindeki direnç
- `C1 = 1000e-6` F: RC filtresindeki kondansatör (1000 µF)
- `L1 = 100e-6` H: LR filtresindeki endüktans (100 µH)
- `R2 = 1` Ω: LR filtresindeki direnç

Bu değerler, filtrelerin kesim davranışını doğrudan belirler.

### 3) Frekans ekseninin oluşturulması

`f = logspace(1, 6, 1000);  % 10Hz to 1MHz`

- `logspace(1, 6, 1000)` ile 10¹ ile 10⁶ arasında (10 Hz – 1 MHz) logaritmik olarak dağılmış
  1000 nokta üretilir.
- Bode benzeri analizlerde logaritmik frekans ölçeği kullanmak standarttır.

### 4) RC filtrenin transfer fonksiyonu

`H_rc = 1 ./ (1 + 1i*2*pi*f*R1*C1);`

Bu ifade, bir RC alçak geçiren filtrenin frekans domenindeki transfer fonksiyonudur:

H_RC(jω) = 1 / (1 + jωR₁C₁)

Burada `ω = 2πf` ve `1i` karmaşık birim `j`'yi temsil eder.

### 5) LR filtrenin transfer fonksiyonu

`H_lr = 1 ./ (1 + 1i*2*pi*f*L1/R2);`

Bu ifade LR yapısının birinci dereceden alçak geçiren davranışını temsil eder:

H_LR(jω) = 1 / (1 + jωL₁/R₂)

Frekans arttıkça endüktif etki büyür ve kazanç düşmeye başlar.

### 6) Toplam sistem cevabı

`H_total = H_rc .* H_lr;`

- İki filtre seri düşünüldüğü için toplam transfer fonksiyonu çarpım ile bulunur.
- `.*` eleman bazlı çarpımdır; frekans vektöründeki her nokta için ayrı hesap yapılır.

### 7) Genlik cevabının çizimi (dB)

`semilogx(f, 20*log10(abs(H_total)));`

- `abs(H_total)` karmaşık transfer fonksiyonunun büyüklüğünü alır.
- `20*log10(...)` lineer kazancı dB ölçeğine çevirir.
- `semilogx` ile x-ekseni logaritmik, y-ekseni lineer çizilir.
- Ek ayarlar: `grid on` ızgara, `xlabel`/`ylabel`/`title` eksen ve başlık metinleri,
  `xlim([10, 1e6])` frekans aralığı, `ylim([-100, 0])` kazanç aralığı.

### 8) Faz cevabının çizimi (derece)

`semilogx(f, angle(H_total)*180/pi);`

- `angle(H_total)` fazı radyan cinsinden verir; `*180/pi` ile dereceye çevrilir.
- Sınırlar `xlim([10, 1e6])` ve `ylim([-180, 0])`: iki birinci dereceden filtrenin toplam faz
  gecikmesinin yaklaşık −180°'ye yaklaşmasını görselleştirmek için uygundur.

### 9) Kodun pratik çıktısı

Bu betik çalıştırıldığında tek figürde iki panel oluşur: **genlik (dB)** ve **faz (derece)**.
Böylece güç kaynağı filtre yapısının yüksek frekansları ne kadar bastırdığı ve faz gecikmesi
tek bakışta görülebilir. Sürüm 21.10.2026'da iki ayrı `figure` yerine tek figürde `subplot(2,1,…)`
kullanır ve `visible` kapalıdır (başsız oturum).

### Betik

Aşağıdaki betik dosyanın tamamıdır (`kod: power_supply.m`).

```octave
clear; clc; close all;

%% 0. Hazirlik
warning("off", "all");
graphics_toolkit("gnuplot");
betik_dizini = fileparts(mfilename("fullpath"));
if isempty(betik_dizini); betik_dizini = pwd(); end
img_dizini = fullfile(betik_dizini, "assets", "img");
if ~exist(img_dizini, "dir"); mkdir(img_dizini); end

%% 1. Devre bilesenleri
R1 = 10;          % RC filtre direnci (ohm)
C1 = 1000e-6;     % RC filtre kondansatoru (F) = 1000 uF
L1 = 100e-6;      % LR filtre enduktansi (H) = 100 uH
R2 = 1;           % LR filtre direnci (ohm)
printf("[1] R1 = %g ohm, C1 = %g F, L1 = %g H, R2 = %g ohm\n", R1, C1, L1, R2);

%% 2. Frekans ekseni ve iki filtrenin transfer fonksiyonlari
f = logspace(1, 6, 1000);                     % 10 Hz - 1 MHz
H_rc = 1 ./ (1 + 1i*2*pi*f*R1*C1);            % H_RC = 1/(1 + j*w*R1*C1)
H_lr = 1 ./ (1 + 1i*2*pi*f*L1/R2);            % H_LR = 1/(1 + j*w*L1/R2)
H_total = H_rc .* H_lr;                       % seri iki filtre: carpim
printf("[2] %d frekans noktasi: %.0f Hz - %.0f Hz\n", numel(f), f(1), f(end));

%% 3. Kesim frekanslari (kose frekanslari)
fc_rc = 1 / (2*pi*R1*C1);
fc_lr = R2 / (2*pi*L1);
printf("[3] RC kesim frekansi: %.3f Hz\n", fc_rc);
printf("[3] LR kesim frekansi: %.3f Hz\n", fc_lr);

%% 4. Onemli frekanslarda olculen genlik ve faz
printf("[4] f (Hz)      |H| (dB)    faz (derece)\n");
for fq = [10, 100, 1000, 10000, 100000, 1000000]
  [~, idx] = min(abs(f - fq));
  printf("[4] %8.0f   %9.2f   %10.1f\n", f(idx), ...
         20*log10(abs(H_total(idx))), angle(H_total(idx))*180/pi);
end

%% 5. Toplam filtrenin -3 dB noktasi (genlik 1/sqrt(2) altina ilk dusus)
genlik_db = 20*log10(abs(H_total));
idx3 = find(genlik_db <= -3, 1, "first");
printf("[5] -3 dB noktasi: %.1f Hz (kazanc %.2f dB)\n", f(idx3), genlik_db(idx3));
printf("[5] DC kazanci: %.4f dB, 1 MHz kazanci: %.1f dB\n", ...
       genlik_db(1), genlik_db(end));

%% 6. Genlik ve faz cevabini tek figurde iki panele yaz
fig = figure("visible", "off"); graphics_toolkit(fig, "gnuplot");
subplot(2, 1, 1);
semilogx(f, genlik_db, "b-", "LineWidth", 1.5); grid on;
xlabel("Frekans (Hz)"); ylabel("Kazanc (dB)");
title("Guc kaynagi filtresi: genlik cevabi");
xlim([10, 1e6]); ylim([-100, 5]);
subplot(2, 1, 2);
semilogx(f, angle(H_total)*180/pi, "r-", "LineWidth", 1.5); grid on;
xlabel("Frekans (Hz)"); ylabel("Faz (derece)");
title("Guc kaynagi filtresi: faz cevabi");
xlim([10, 1e6]); ylim([-180, 0]);
dosya = fullfile(img_dizini, "power_supply-bode.png");
print(fig, dosya, "-dpng", "-r110");
printf("[6] grafik: %s (%d bayt)\n", "power_supply-bode.png", dir(dosya).bytes);

%% Ozet
printf("\nOzet: RC (%.1f Hz) ve LR (%.1f Hz) alcak geciren filtrelerin carpimi\n", fc_rc, fc_lr);
printf("      %.1f Hz uzerinde -3 dB'nin altina iniyor; 1 MHz'de faz %.0f derece.\n", ...
       f(idx3), angle(H_total(end))*180/pi);
```

## Beklenen Çıktı

```
[1] R1 = 10 ohm, C1 = 0.001 F, L1 = 0.0001 H, R2 = 1 ohm
[2] 1000 frekans noktasi: 10 Hz - 1000000 Hz
[3] RC kesim frekansi: 15.915 Hz
[3] LR kesim frekansi: 1591.549 Hz
[4] f (Hz)      |H| (dB)    faz (derece)
[4]       10       -1.45        -32.5
[4]      100      -16.11        -84.6
[4]     1005      -37.46       -121.4
[4]     9954      -71.96       -170.8
[4]    99770     -111.89       -179.1
[4]  1000000     -151.93       -179.9
[5] -3 dB noktasi: 16.0 Hz (kazanc -3.04 dB)
[5] DC kazanci: -1.4452 dB, 1 MHz kazanci: -151.9 dB
[6] grafik: power_supply-bode.png (19345 bayt)

Ozet: RC (15.9 Hz) ve LR (1591.5 Hz) alcak geciren filtrelerin carpimi
      16.0 Hz uzerinde -3 dB'nin altina iniyor; 1 MHz'de faz -180 derece.
```

## Öne Çıkan Noktalar

- **İki kesim frekansı ölçüldü:** RC kolu `15,915 Hz`, LR kolu `1591,549 Hz`. Toplam filtrenin
  −3 dB noktası `16,0 Hz` — yani davranışı RC kolu belirliyor; LR kolu ancak 1,6 kHz'den sonra
  ikinci bir eğim ekliyor (1 MHz'de `−151,9 dB`).
- **DC kazancı tam 1 değil:** ölçülen `−1,4452 dB` (10 Hz'de). Sebep, 10 Hz'in RC kesim
  frekansına (`15,9 Hz`) yakın olması: o noktada kol çoktan `−1,45 dB` düşürmüş durumda.
  Gerçek DC kazanç `f → 0` limitinde `0 dB`'dir.
- **Faz toplamı −180°'ye yaklaşır:** her birinci derece filtre yüksek frekansta −90° katar;
  iki kol birlikte `−179,9°`'ye oturur (1 MHz). Faz ölçümü sarmalama (wrapping) yapmadığı için
  burada tek anlamlıdır.
- **`1i` yazımı:** Octave'de `i` ve `j` değişken olarak gölgelenebilir; `1i` sabiti her zaman
  sanal birimdir. Döngü değişkeni olarak `i` kullandıktan sonra `1i` yazmak bu yüzden güvenlidir.
- **`.*` ve `/` vektörde:** `H_lr` ifadesindeki `/R2` skaler bölmedir; `./` yazmak da aynı
  sonucu verir. Vektör/vektör bölmesi gerekirse `./` zorunludur — karıştırılırsa boyut hatası
  ya da yanlış sonuç çıkar.

## Alıştırmalar

1. `C1` değerini `100e-6` F (100 µF) yapın: RC kesim frekansı kaç Hz olur, −3 dB noktası nasıl
   kayar? Ölçülen `fc = 1/(2πR1C1)` formülüyle doğrulayın.
2. `R2 = 0,5` Ω yapın (LR kolunun kesim frekansı iki katına çıkar): 1 kHz'de kazanç kaç dB
   değişiyor? Faz eğrisinin ikinci kırılma noktasını grafikten okuyun.
3. İki kolu **paralel** bağlayın (`H_total = H_rc + H_lr` yerine `H_rc .* H_lr`): toplam cevap
   nasıl değişiyor, hangi frekans bandında kazanç 0 dB'nin üstüne çıkıyor?
4. `linspace` ile lineer frekans ekseni kullanıp `plot` ile çizin: Bode grafiğinin neden
   logaritmik eksende okunması gerektiğini iki grafiği karşılaştırarak açıklayın.
