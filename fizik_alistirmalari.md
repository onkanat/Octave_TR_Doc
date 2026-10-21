---
layout: default
title: "Octave Fizik Alıştırmaları"
lang: tr
konu: muhendislik
seviye: baslangic
tur: alistirma
kod: fizik_alistirmalari.m
redirect_from: [/Octave_fizik_alistirmalari.html]
---

# Octave Fizik Alıştırmaları

Bu bölüm, fizik problemlerinin Octave üzerinde nasıl modelleneceğini ve çözüleceğini gösteren
örnekler içerir: değişken tanımlama, sabitler ve formül uygulama üzerine odaklanılmıştır.
Beş problemin tamamı tek bir betikte, **sabit örnek girdilerle** (etkileşimsiz) toplanmıştır;
sayfadaki çıktı bloğu betiğin ölçülmüş koşusudur (GNU Octave 11.3.0).

## Ne öğreneceksiniz

- Yerçekimi ivmesi, gaz sabiti ve Coulomb sabiti gibi **fiziksel sabitleri** büyük harfli
  değişkenlerde tutmayı (`G_IVME = 9.81`)
- Serbest düşme, eğik atış ve Coulomb yasası formüllerini doğrudan kodlamayı
- İdeal gaz yasasında (`PV = nRT`) üç bilinmeyenden herhangi birini çözmeyi
- Bir döngüde üretilen değerleri `fopen` / `fprintf` / `fclose` üçlüsüyle **dosyaya** yazmayı
- Etkileşimli `input()` yerine sabit örnek girdi kullanarak betiği tekrar üretilebilir kılmayı

## Çalıştırma

```sh
octave --no-gui fizik_alistirmalari.m
```

Betik reponun kökünde ve tek başına koşar; ek paket yüklemez. `[10]` bölümü
`assets/veri/sarkac.txt` dosyasını yazar (klasör yoksa betik kendisi oluşturur), grafik çizmez.
Bu makinede `octave --no-gui` Qt/cocoa eklentisi yüzünden betiği yüklemeden düşüyor
(**EXIT=134**); sayfadaki blok aynı çıktıyı veren `octave-cli` ile ölçüldü.

## Kod

### Altı yapısal fark: neden `input()` yok?

Nottaki ilk sürüm her problemde `input()` ile kullanıcıdan değer istiyordu. Böyle bir betik
tek başına koşmaz (girdi bekler) ve çıktısı kişiye göre değişir — "Beklenen Çıktı" yazılamaz.
Bu sürümde her problem **sabit örnek girdiyle** yazıldı; `input()` çağrılarının yerini tek
satırlık atamalar aldı (`t = 3.5;`, `v0 = 45;`, `derece = 40;`). Döngü, formül ve yazdırma
yapısı korunmuştur; okur aynı satırı değiştirerek kendi değerini deneyebilir.

### 6. Serbest Düşme (Basit)

**Problem:** Serbest düşmeye bırakılan bir cismin, kullanıcıdan alınan `t` süresi sonunda
ulaştığı hızı ve kat ettiği mesafeyi hesaplayınız. (`g = 9.81` m/s² sabitini `constant`
benzeri bir şekilde tanımlayınız.) Çözüm `[6]` bölümünde: `v = G_IVME*t`, `h = 0.5*G_IVME*t^2`.

### 7. İdeal Gaz Yasası (Basit)

**Problem:** Bir ideal gaz için `PV = nRT` formülünü kullanarak; basınç, hacim ve sıcaklık
değerlerinden bilinmeyeni hesaplayan bir program yazınız (örneğin `n = 1` mol için).
Nottaki sürüm `input()` ile 1/2/3 seçimi alıyordu; burada aynı üç hesap sırayla yapılır
(`[7]`): `P = nRT/V`, ardından ters yönde `V` ve `T` geri hesaplanır — üçünün de tutarlı
çıkması formülün kendi kendini doğrulamasıdır.

### 8. Eğik Atış Menzil Hesabı (Orta)

**Problem:** Belirli bir ilk hız (`v0`) ve açıyla (`θ`) fırlatılan bir merminin menzilini ve
maksimum yüksekliğini hesaplayan programı yazınız. (Radyan dönüşümü için `pi` veya `acos(-1.0)`
kullanınız.) `[8]` bölümü: `menzil = v0^2*sin(2θ)/g`, `max_h = v0^2*sin(θ)^2/(2g)`.

### 9. Coulomb Yasası (Orta)

**Problem:** Coulomb Yasası'nı kullanarak, aralarındaki mesafe ve yük miktarları verilen iki
parçacık arasındaki elektriksel kuvveti hesaplayınız (`F = k·|q1·q2|/r²`). `[9]` bölümü
`k = 8.99e9` ile çalışır ve kuvvetin yönünü (itme/çekme) yüklerin işaretinden okur.

### 10. Basit Harmonik Hareket ve Dosyaya Yazma (İleri)

**Problem:** Basit harmonik hareket yapan bir sarkaç için, zamanın fonksiyonu olarak konumu
(`x(t) = A·cos(ωt)`) bir döngü içinde hesaplayıp bir dosyaya (`sarkac.txt`) yazdıran programı
yazınız. `[10]` bölümü dosyayı `assets/veri/sarkac.txt` altına yazar (kök temiz kalır), 101
veri satırı üretir ve ilk/son örneği ekrana basar.

### Betik

Aşağıdaki betik dosyanın tamamıdır (`kod: fizik_alistirmalari.m`).

```octave
clear; clc; close all;

%% 0. Hazirlik: ornek girdiler betigin icinde (input() yok)
warning("off", "all");
graphics_toolkit("gnuplot");
betik_dizini = fileparts(mfilename("fullpath"));
if isempty(betik_dizini); betik_dizini = pwd(); end
veri_dizini = fullfile(betik_dizini, "assets", "veri");
if ~exist(veri_dizini, "dir"); mkdir(veri_dizini); end

%% 6. Serbest dusme: v = g*t, h = g*t^2/2
G_IVME = 9.81;          % yercekimi ivmesi (m/s^2), sabit
t = 3.5;                % dusus suresi (s) -- ornek girdi
v = G_IVME * t;
h = 0.5 * G_IVME * t^2;
printf("[6] serbest dusme: t = %.2f s\n", t);
printf("[6]   hiz            : %.2f m/s\n", v);
printf("[6]   dusus mesafesi : %.2f m\n", h);

%% 7. Ideal gaz yasasi: P*V = n*R*T (uclu yon de hesaplanir)
R = 0.0821;             % gaz sabiti (L*atm / mol*K)
n = 1;                  % mol
V = 22.4;               % L
T = 273.15;             % K
P = (n * R * T) / V;
printf("[7] ideal gaz: n = %g mol, V = %.1f L, T = %.2f K\n", n, V, T);
printf("[7]   P = nRT/V = %.4f atm\n", P);
printf("[7]   ters yon  : V = nRT/P = %.4f L, T = PV/(nR) = %.4f K\n", ...
       (n*R*T)/P, (P*V)/(n*R));

%% 8. Egik atis: menzil ve maksimum yukseklik
v0 = 45;                % ilk hiz (m/s)
derece = 40;            % firlatma acisi (derece)
radyan = derece * (pi / 180);
g = 9.81;
menzil = (v0^2 * sin(2*radyan)) / g;
max_h  = (v0^2 * sin(radyan)^2) / (2*g);
printf("[8] egik atis: v0 = %g m/s, aci = %g derece (%.4f rad)\n", v0, derece, radyan);
printf("[8]   menzil            : %.2f m\n", menzil);
printf("[8]   maksimum yukseklik: %.2f m\n", max_h);

%% 9. Coulomb yasasi: F = k*|q1*q2|/r^2
k = 8.99e9;             % Coulomb sabiti (N*m^2/C^2)
q1 = 2e-6;              % C
q2 = 3e-6;              % C
r  = 0.35;              % m
F_coulomb = k * (abs(q1 * q2) / r^2);
printf("[9] Coulomb: q1 = %.1e C, q2 = %.1e C, r = %.2f m\n", q1, q2, r);
printf("[9]   F = %.4e N (%s)\n", F_coulomb, ...
       merge(abs(q1*q2) > 0 && q1*q2 > 0, "itme", "cekim"));

%% 10. Basit harmonik hareket: x(t) = A*cos(omega*t) dongu ile dosyaya
A = 0.5;                % genlik (m)
omega = 2.0;            % acisal hiz (rad/s)
t_son = 10;             % bitis suresi (s)
dt = 0.1;               % zaman adimi
dosya = fullfile(veri_dizini, "sarkac.txt");
fid = fopen(dosya, "w");
if (fid == -1); error("sarkac.txt yazilamadi"); end
fprintf(fid, "Zaman(s)   Konum(m)\n");
fprintf(fid, "------------------\n");
satir = 0;
for tt = 0:dt:t_son
  x = A * cos(omega * tt);
  fprintf(fid, "%-10.2f %-10.4f\n", tt, x);
  satir = satir + 1;
end
fclose(fid);
printf("[10] harmonik hareket: A = %.2f m, omega = %.2f rad/s, periyot = %.4f s\n", ...
       A, omega, 2*pi/omega);
printf("[10]   %s: %d veri satiri yazildi (basliklar dahil %d satir)\n", ...
       "assets/veri/sarkac.txt", satir, satir + 2);
printf("[10]   ilk ornek t = 0.00 -> x = %.4f m, son ornek t = %.2f -> x = %.4f m\n", ...
       A*cos(omega*0), t_son, A*cos(omega*t_son));

%% Ozet
printf("\nOzet: bes fizik problemi (serbest dusme, ideal gaz, egik atis, Coulomb,\n");
printf("      harmonik hareket) sabit ornek girdilerle olculdu; hicbiri input() beklemez.\n");
```

## Beklenen Çıktı

```
[6] serbest dusme: t = 3.50 s
[6]   hiz            : 34.34 m/s
[6]   dusus mesafesi : 60.09 m
[7] ideal gaz: n = 1 mol, V = 22.4 L, T = 273.15 K
[7]   P = nRT/V = 1.0011 atm
[7]   ters yon  : V = nRT/P = 22.4000 L, T = PV/(nR) = 273.1500 K
[8] egik atis: v0 = 45 m/s, aci = 40 derece (0.6981 rad)
[8]   menzil            : 203.29 m
[8]   maksimum yukseklik: 42.64 m
[9] Coulomb: q1 = 2.0e-06 C, q2 = 3.0e-06 C, r = 0.35 m
[9]   F = 4.4033e-01 N (itme)
[10] harmonik hareket: A = 0.50 m, omega = 2.00 rad/s, periyot = 3.1416 s
[10]   assets/veri/sarkac.txt: 101 veri satiri yazildi (basliklar dahil 103 satir)
[10]   ilk ornek t = 0.00 -> x = 0.5000 m, son ornek t = 10.00 -> x = 0.2040 m

Ozet: bes fizik problemi (serbest dusme, ideal gaz, egik atis, Coulomb,
      harmonik hareket) sabit ornek girdilerle olculdu; hicbiri input() beklemez.
```

## Öne Çıkan Noktalar

- **Sabitler büyük harfle:** `G_IVME`, `R`, `k` gibi adlar formülün içinde göze çarpar ve
  yanlışlıkla değiştirilme riski azalır; "constant benzeri tanımlama" istemi budur.
- **Birimler yorumda:** `0.0821` katsayısı `L·atm/(mol·K)` olduğu için hacim litre, basınç atm
  çıkar. SI birimleriyle (`8.314 J/(mol·K)`, `V` m³) çalışılsaydı basınç Pa olurdu.
- **Derece → radyan:** `sin` ve `cos` radyan bekler; `derece*(pi/180)` dönüşümü olmadan 40°
  yerine 40 radyan hesaplanır ve menzil saçmalar (40 rad ≈ 6,37 tur).
- **`fopen` dönüş değeri denetlenir:** `fid == -1` ise dosya açılamamıştır; betik `error` ile
  durur. Yazma döngüsünden sonra `fclose(fid)` çağrılmazsa dosya tamponu boşalmayabilir.
- **Etkileşimsiz tekrar:** `input()` yok → aynı betik iki kez koşulduğunda **birebir** aynı
  çıktı ve aynı `sarkac.txt` içeriği üretilir; ölçüm bu yüzden karşılaştırılabilir.

## Alıştırmalar

1. Serbest düşmede `t = 10` yapın; `h` kaç metre oluyor? Hava direnci ihmal edildiği için
   gerçek düşüşten büyük çıkar — farkı bir cümleyle açıklayın.
2. Eğik atışta açıyı `45°` yapın: menzil neden en büyük değerine çıkıyor? `v0 = 45` için
   `θ = 30°` ve `θ = 60°` menzillerini karşılaştırın (aynı çıkmalı — neden?).
3. Coulomb'da `q1` işaretini negatife çevirin (`q1 = -2e-6`): kuvvetin büyüklüğü değişiyor mu,
   `[9]` satırındaki itme/çekme etiketi ne oluyor? `merge` çağrısını inceleyin.
4. Harmonik harekette `dt = 0.01` yapın: `sarkac.txt` kaç satır olur, ilk ve son örnek
   değişir mi? `omega = 2` iken periyot kaç saniye ve dosyada bir periyot kaç satıra düşüyor?
