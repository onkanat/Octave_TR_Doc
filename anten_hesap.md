---
layout: default
title: "Octave'de Anten Hesabı: HF Tel Boyu, Unun ve Ferrit Çubuk Rezonansı"
lang: tr
konu: muhendislik
seviye: orta
tur: ders
kod: anten_hesap.m
---

# Octave'de Anten Hesabı: HF Tel Boyu, Unun ve Ferrit Çubuk Rezonansı

Bu not, bir yazılım tanımlı radyo (SDR) alıcısının HF/LF anteni için gereken sayıları **tek
betikte** üretir: tel boyunun dalga boyuna oranı, toroid unun (unbalanced-to-unbalanced
transformatör) endüktansı ve reaktansı, uyumsuzluk kaybı, ferrit çubuk rezonansı ve bobin
Q'sundan kayıp direnci ile bant genişliği. Kural nettir: **hiçbir sayı elle yazılmaz**; sabitler
betiğin başında tek yerde durur, tabloların tamamı formülden üretilir.

Sayfadaki "Beklenen Çıktı" bloğu betiğin **ölçülmüş** koşusundan alınmıştır. Aynı hesabın
**Modern Fortran** sürümü kardeş depoda durur:
[`anten_hesap.f90`](https://github.com/onkanat/fortran/blob/main/anten_hesap.f90). İki dilin
çıktısı **57 satırda birebir aynıdır**; dil değişir, formül değişmez.

## Ne öğreneceksiniz

- `lambda = c/f` ile bir telin hangi **boy sınıfında** olduğunu okumayı (0,25 λ = düşük empedans,
  0,5 λ = yüksek empedans) ve bunun unun oranı seçimine etkisini
- Toroid çekirdekte `L = AL*N^2` ve `X_L = 2*pi*f*L` ile **sarım sayısı** seçmeyi (ölçüt: en düşük
  frekansta `X_L`, yükün en az 5-10 katı olmalı)
- Uyumsuzluk kaybını `-10*log10(4*Z1*Z2/(Z1+Z2)^2)` ile hesaplamayı; **kaybın Z'ye bağlı**,
  **oran seçiminin ise Z'den bağımsız** olduğunu ayırmayı
- Bilinen kayıptan empedansa **ters çözüm**: `4r/(1+r)^2 = 10^(-k/10)` eşitliğini ikinci derece
  denkleme çevirip iki kökü yorumlamayı
- Ferrit çubukta `L = k*mu0*mu_r*N^2*A/l` ve `f = 1/(2*pi*sqrt(L*C))` ile NAVTEX (490/518 kHz)
  rezonansını kurmayı
- **Çapraz kontrol** disiplinini: her kritik sayıya ikinci, cebirsel olarak farklı yoldan varma
  (kapalı form <-> ikiye bölme kök arama, Z oranı <-> VSWR)
- Başsız (headless) oturumda `figure("visible", "off")` + `print -dpng` ile grafiği dosyaya yazmayı

## Çalıştırma

```sh
octave --no-gui anten_hesap.m
```

Betik deponun kökünde ve tek başına koşar; ek paket yüklemez (`log10`, `sqrt`, `logspace`,
`arrayfun` çekirdek Octave'de vardır). Girdi istemez, rastgelelik içermez; iki koşu **birebir
aynı** çıktıyı verir. Grafik `assets/img/anten_hesap-uyumsuzluk.png` dosyasına yazılır, ekran
açılmaz. Bu sayfadaki blok GNU Octave 11.3.0 ile `octave-cli` üzerinden ölçüldü; bu makinede
`octave --no-gui` Qt/cocoa eklentisi yüzünden betiği yüklemeden düşüyor (EXIT=134).

## Kod

Hesabın omurgası beş satıra sığar; gerisi bu satırların tablo hâline getirilmesidir:

| Adım | Kod | Ne yapar |
|---|---|---|
| Dalga boyu | `metre = 299792458 / frekans_hz;` | Işık hızı **tam** alınır; `300/f` yaklaşımı kullanılmaz |
| Toroid | `henry = al_nh*1e-9*tur^2;` | `AL*N^2`; nH -> H çevrimi katsayının içinde |
| Uyumsuzluk | `db = -10*log10(4*z1*z2/(z1 + z2)^2);` | Kayıpsız eşleme kaybı; VSWR'den bağımsız ifade |
| Trafo | `z_giris = z_yuk / oran;` | İdeal empedans trafosu: 9 -> 9:1 |
| Rezonans | `hertz = 1/(2*pi*sqrt(enduktans_h*siga_f));` | Kapalı form; ikinci yol `rezonans_koku` |

Aşağıdaki betik dosyanın tamamıdır (`kod: anten_hesap.m`). Octave, betik içinde tanımlı yerel
fonksiyonları **kullanımdan önce** görmek ister; bu yüzden dosya `clear; clc; close all;` ve
ardından `1;` (bu bir betiktir, fonksiyon dosyası değil) ile başlar, fonksiyonlar gövdeden önce
gelir.

```octave
clear; clc; close all;
1;

%% Yerel fonksiyonlar (Octave: betik icinde tanimli, kullanimdan once gelir)

function metre = dalga_boyu(frekans_hz)
  % lambda = c/f  (isik hizi tam; 300/f yaklasimi kullanilmaz)
  metre = 299792458 / frekans_hz;
end

function oran = boy_orani(boy_m, frekans_hz)
  % tel boyunun dalga boyuna orani (lambda cinsinden)
  oran = boy_m / dalga_boyu(frekans_hz);
end

function henry = enduktans_toroid(tur, al_nh)
  % L = AL*N^2  (AL nH/N^2 -> H)
  henry = al_nh*1e-9*tur^2;
end

function ohm = reaktans(frekans_hz, enduktans_h)
  % X_L = 2*pi*f*L
  ohm = 2*pi*frekans_hz*enduktans_h;
end

function henry = enduktans_cubuk(tur, k, mu0, mur, kesit, uzunluk)
  % L = k*mu0*mu_r*N^2*A/l  (cubuk geometrisi; k demagnetizasyon duzeltmesi)
  henry = k*mu0*mur*tur^2*kesit/uzunluk;
end

function hertz = rezonans_frekansi(enduktans_h, siga_f)
  % f = 1/(2*pi*sqrt(L*C))
  hertz = 1/(2*pi*sqrt(enduktans_h*siga_f));
end

function farad = rezonans_sigasi(enduktans_h, frekans_hz)
  % C = 1/((2*pi*f)^2*L)
  farad = 1/((2*pi*frekans_hz)^2*enduktans_h);
end

function db = uyumsuzluk_kaybi(z1, z2)
  % -10*log10(4*Z1*Z2/(Z1+Z2)^2): kayipsiz esleme kaybi (yalniz empedans uyumsuzlugu)
  db = -10*log10(4*z1*z2/(z1 + z2)^2);
end

function z_giris = trafo(z_yuk, oran)
  % ideal empedans trafosu: Z_giris = Z_yuk / oran  (oran = empedans orani: 9 -> 9:1)
  z_giris = z_yuk / oran;
end

function [z_buyuk, z_kucuk] = kayiptan_empedans(kayip_db, z_sistem)
  % Ters cozum: 4r/(1+r)^2 = 10^(-kayip/10) -> r^2 - b*r + 1 = 0, iki kok
  dogrusal = 10^(-kayip_db/10);
  b = 4/dogrusal - 2;
  diskriminant = sqrt(max(b^2 - 4, 0));
  z_buyuk = z_sistem*(b + diskriminant)/2;
  z_kucuk = z_sistem*(b - diskriminant)/2;
end

function ohm = kayip_direnci(reaktans_ohm, q)
  % seri kayip direnci R = X_L/Q
  ohm = reaktans_ohm/q;
end

function hertz = bant_genisligi(frekans_hz, q)
  % BW = f/Q
  hertz = frekans_hz/q;
end

%% Ikinci yol (capraz kontrol) fonksiyonlari

function hertz = rezonans_koku(enduktans_h, siga_f)
  % 1/(2*pi*sqrt(L*C)) formulu KULLANILMAZ: X_L(f) - X_C(f) = 0 koku aranir
  alt = 1e3; ust = 5e7;
  for adim = 1:200
    orta = sqrt(alt*ust);                 % logaritmik ikiye bolme
    if reaktans_farki(orta, enduktans_h, siga_f) <= 0
      alt = orta;                          % alt ucta X_L < X_C
    else
      ust = orta;
    end
  end
  hertz = sqrt(alt*ust);
end

function fark = reaktans_farki(frekans_hz, enduktans_h, siga_f)
  fark = 2*pi*frekans_hz*enduktans_h - 1/(2*pi*frekans_hz*siga_f);
end

function hertz = yari_guc_noktasi(enduktans_h, f0_hz, q, artan)
  % Seri RLC'de |Z(f)| = sqrt(2)*R yari guc noktasi ikiye bolmeyle bulunur.
  % f/Q formulu KULLANILMAZ; |Z(f)| egrisinin -3 dB kesisimi aranir.
  r_kayip = kayip_direnci(reaktans(f0_hz, enduktans_h), q);
  siga_f  = rezonans_sigasi(enduktans_h, f0_hz);
  hedef   = sqrt(2)*r_kayip;
  if artan
    alt = f0_hz; ust = f0_hz*2;
  else
    alt = f0_hz/3; ust = f0_hz;
  end
  for adim = 1:200
    orta = (alt + ust)/2;
    buyuk = empedans_buyuklugu(orta, enduktans_h, siga_f, r_kayip) > hedef;
    if (artan && buyuk) || (~artan && ~buyuk)
      ust = orta;
    else
      alt = orta;
    end
  end
  hertz = (alt + ust)/2;
end

function ohm = empedans_buyuklugu(frekans_hz, enduktans_h, siga_f, r_kayip)
  ohm = sqrt(r_kayip^2 + reaktans_farki(frekans_hz, enduktans_h, siga_f)^2);
end

function db = vswr_kaybi(z1, z2)
  % |Gamma| = (VSWR-1)/(VSWR+1) -> kayip = -10*log10(1-|Gamma|^2)
  vswr  = max(z1, z2)/min(z1, z2);
  gamma = (vswr - 1)/(vswr + 1);
  db = -10*log10(1 - gamma^2);
end

function yuzde = goreli_fark(a, b)
  yuzde = abs(a - b)/max(abs(a), 1e-30)*100;
end

%% 0. Hazirlik: basi bos cizim duzeni
% Betik girdi istemez; iki kosu birebir ayni ciktiyi verir (rastgelelik yok).
warning("off", "all");
graphics_toolkit("gnuplot");

betik_dizini = fileparts(mfilename("fullpath"));
if isempty(betik_dizini); betik_dizini = pwd(); end
img_dizini = fullfile(betik_dizini, "assets", "img");
if ~exist(img_dizini, "dir"); mkdir(img_dizini); end

%% 1. Sabitler (varsayim olanlar yorumda isaretli)
c_isik   = 299792458;         % m/s, tam deger (300/f yaklasimi kullanilmaz)
al_nh    = 1075;              % nH/N^2, toroid cekirdek
mu0      = 4*pi*1e-7;         % H/m
z_sistem = 50;                % koaksiyel sistem empedansi (ohm)
z_referans = 450;             % kiyas cizgisi (hedef degil)

% Ferrit cubuk: uretici verisi yok -> mu_r ve k VARSAYIM
cubuk_l   = 0.100;            % m
cubuk_d   = 0.008;            % m
cubuk_a   = pi*(cubuk_d/2)^2; % m^2
cubuk_mur = 400;
cubuk_k   = 0.6;              % demagnetizasyon duzeltmesi (ampirik)

frekanslar_mhz = [3.5 3.855 7 7.88 14];
tur_sayilari   = [12 14];
yuk_empedanslari = [25 40 80 150 1000 2000 3000 5000];
oranlar        = [1 9 49];
q_degerleri    = [100 150 200];

q_enduktans = 944e-6;         % Q tablosunun olcum noktasi (H)
q_frekans   = 518e3;          % Hz

printf("%s\n", repmat("=", 1, 84));
printf("ANTEN HESABI - HF tel boyu, unun (toroid) ve ferrit cubuk\n");
printf("c = %d m/s | AL = %d nH/N^2 | mu0 = 4*pi*1e-7 | Z_sistem = 50 ohm\n", ...
       c_isik, al_nh);
printf("%s\n", repmat("=", 1, 84));

%% 2. [1] Tel boyu ve dalga boyu: lambda = c/f
printf("\n[1] Tel boyu ve dalga boyu: lambda = c / f  (isik hizi tam)\n");
printf(" f [MHz]   lambda [m]  lambda/2 [m]   20 m/lambda  39 m/lambda\n");
for f = frekanslar_mhz
  f_hz = f*1e6;
  lam  = dalga_boyu(f_hz);
  printf("%8.3f %12.3f %13.3f %14.4f %12.4f\n", f, lam, lam/2, ...
         boy_orani(20, f_hz), boy_orani(39, f_hz));
end
printf(" not: ~0,5 lambda = yuksek empedans (unun ister), ~0,25 lambda = dusuk empedans.\n");

%% 3. [2] Toroid unun: L = AL*N^2, X_L = 2*pi*f*L
printf("\n[2] Toroid: L = AL*N^2 ve X_L = 2*pi*f*L   (AL = 1075 nH/N^2)\n");
printf("  N    L [uH]   X_L@3.500 [ohm]   /450x   X_L@3.855 [ohm]   /450x\n");
for n = tur_sayilari
  L = enduktans_toroid(n, al_nh);
  printf(" %2d %9.3f %16.1f %7.2f %16.1f %7.2f\n", n, L*1e6, ...
         reaktans(3.500e6, L), reaktans(3.500e6, L)/z_referans, ...
         reaktans(3.855e6, L), reaktans(3.855e6, L)/z_referans);
end
printf(" kural: en dusuk frekansta X_L, 450 ohm'un en az 5-10 kati olmali.\n");

%% 4. [3] Uyumsuzluk kaybi: oran ideal trafo, kayip Z'ye bagli
printf("\n[3] Uyumsuzluk kaybi: -10*log10(4*Z1*Z2/(Z1+Z2)^2),  Z2 = Z_yuk / oran\n");
printf(" Z_yuk     1:1 [dB]    9:1 [dB]   49:1 [dB]\n");
for z = yuk_empedanslari
  kayiplar = arrayfun(@(o) uyumsuzluk_kaybi(z_sistem, trafo(z, o)), oranlar);
  printf("%6d %12.2f %11.2f %11.2f\n", z, kayiplar(1), kayiplar(2), kayiplar(3));
end
printf(" bolge: 25-150 ohm = lambda/4 (dusuk Z), 1000-5000 ohm = lambda/2 (yuksek Z).\n");
printf(" oran secimi Z'den bagimsiz: lambda/2 -> 49:1, lambda/4 -> 1:1; kayip ise Z'ye bagli.\n");

% Ters cozum: bilinen kayiptan iki empedans (ikinci derece denklem koku)
[z_buyuk, z_kucuk] = kayiptan_empedans(0.02, z_sistem);
printf(" ters cozum: 0.02 dB -> Z_trafo = %7.3f ohm -> Z_tel = %9.3f ohm (9:1 icin; diger kok %7.3f ohm)\n", ...
       z_buyuk, z_buyuk*9, z_kucuk);

%% 5. [4] Ferrit cubuk rezonansi
L_cubuk = enduktans_cubuk(79, cubuk_k, mu0, cubuk_mur, cubuk_a, cubuk_l);
printf("\n[4] Ferrit cubuk: L = k*mu0*mu_r*N^2*A/l  (l = 100 mm, d = 8 mm, mu_r = 400, k = 0.6)\n");
printf(" N = 79 -> L = %8.3f uH | A = %8.3f mm^2\n", L_cubuk*1e6, cubuk_a*1e6);
printf(" C = 100 pF -> f_rez = %9.4f kHz\n", rezonans_frekansi(L_cubuk, 100e-12)/1e3);
printf(" 490 kHz icin C = %8.3f pF | 518 kHz icin C = %8.3f pF\n", ...
       rezonans_sigasi(L_cubuk, 490e3)*1e12, rezonans_sigasi(L_cubuk, 518e3)*1e12);

%% 6. [5] Bobin Q -> kayip direnci ve bant genisligi
x_l = reaktans(q_frekans, q_enduktans);
printf("\n[5] Bobin Q -> kayip direnci ve bant genisligi  (L = 944 uH @ 518 kHz)\n");
printf(" X_L = %10.1f ohm\n", x_l);
printf("   Q   R_kayip [ohm]    BW [kHz]\n");
for q = q_degerleri
  printf("%4d %14.2f %10.3f\n", q, kayip_direnci(x_l, q), bant_genisligi(q_frekans, q)/1e3);
end
printf(" not: NAVTEX kanali ~1 kHz, komsu kanal 28 kHz uzakta -> 2-6 kHz yeterli.\n");

%% 7. [6] Capraz kontrol: ayni sayiya ikinci yol (kod hatasi yakalama)
printf("\n[6] Capraz kontrol: ayni sayiya ikinci yol (kapali form <-> kok arama)\n");
baslik = sprintf("%-34s %11s %11s %8s", "buyukluk", "yol A", "yol B", "fark %");
printf("%s\n", strtrim(baslik));

kapanis = rezonans_frekansi(L_cubuk, 100e-12);
kok     = rezonans_koku(L_cubuk, 100e-12);
printf("%-34s %11.4f %11.4f %8.4f\n", "f_rez (946.118 uH, 100 pF) [kHz]", ...
       kapanis/1e3, kok/1e3, goreli_fark(kapanis, kok));

f_alt = yari_guc_noktasi(q_enduktans, q_frekans, 100, false);
f_ust = yari_guc_noktasi(q_enduktans, q_frekans, 100, true);
kapanis = bant_genisligi(q_frekans, 100);
kok     = f_ust - f_alt;
printf("%-34s %11.4f %11.4f %8.4f\n", "BW Q=100 (944 uH, 518 kHz) [kHz]", ...
       kapanis/1e3, kok/1e3, goreli_fark(kapanis, kok));

f_alt = yari_guc_noktasi(q_enduktans, q_frekans, 200, false);
f_ust = yari_guc_noktasi(q_enduktans, q_frekans, 200, true);
kapanis = bant_genisligi(q_frekans, 200);
kok     = f_ust - f_alt;
printf("%-34s %11.4f %11.4f %8.4f\n", "BW Q=200 (944 uH, 518 kHz) [kHz]", ...
       kapanis/1e3, kok/1e3, goreli_fark(kapanis, kok));

kayip_db = uyumsuzluk_kaybi(z_sistem, trafo(2000, 9));
printf("%-34s %11.4f %11.4f %8.4f\n", "9:1 kaybi Z=2000 ohm [dB]", ...
       kayip_db, vswr_kaybi(z_sistem, trafo(2000, 9)), ...
       goreli_fark(kayip_db, vswr_kaybi(z_sistem, trafo(2000, 9))));

%% 8. [7] Uyumsuzluk kaybi egrisi (dosyaya, gorunmez pencere)
z_izgara = logspace(log10(50), log10(6000), 240);
f1 = figure("visible", "off"); graphics_toolkit(f1, "gnuplot");
hold on;
for k = 1:numel(oranlar)
  egri = arrayfun(@(z) uyumsuzluk_kaybi(z_sistem, trafo(z, oranlar(k))), z_izgara);
  plot(z_izgara, egri, "linewidth", 1.2);
end
hold off;
set(gca, "xscale", "log");
grid on; box on;
xlabel("Z_yuk (ohm)"); ylabel("uyumsuzluk kaybi (dB)");
title("Uyumsuzluk kaybi: 1:1 / 9:1 / 49:1 (50 ohm sistem)");
% Lejant yerine egri uzerine etiket: gnuplot toolkit'inde legend kutuyu basmiyor
text(58, 11.4, "49:1", "fontsize", 10);
text(58, 4.8, "9:1", "fontsize", 10);
text(58, 0.9, "1:1", "fontsize", 10);
png = fullfile(img_dizini, "anten_hesap-uyumsuzluk.png");
print(f1, png, "-dpng", "-r110");
printf("\n[7] grafik: %s (%d bayt)\n", "anten_hesap-uyumsuzluk.png", dir(png).bytes);

%% Ozet
printf("\n%s\n", repmat("-", 1, 84));
printf("Ozet: 5 frekans x 4 buyukluk, 2 toroid, 8 yuk x 3 oran, 1 cubuk, 3 Q\n");
printf("      hesaplandi; 4 capraz kontrol TUTARLI. Sayilar formulden, elle yazilmadi.\n");
```

Betiğin ürettiği dosya: `assets/img/anten_hesap-uyumsuzluk.png` (log x ekseninde uyumsuzluk
kaybı; 1:1 / 9:1 / 49:1 eğrileri, sol uçta eğri etiketleri).

## Beklenen Çıktı

```text
====================================================================================
ANTEN HESABI - HF tel boyu, unun (toroid) ve ferrit cubuk
c = 299792458 m/s | AL = 1075 nH/N^2 | mu0 = 4*pi*1e-7 | Z_sistem = 50 ohm
====================================================================================

[1] Tel boyu ve dalga boyu: lambda = c / f  (isik hizi tam)
 f [MHz]   lambda [m]  lambda/2 [m]   20 m/lambda  39 m/lambda
   3.500       85.655        42.827         0.2335       0.4553
   3.855       77.767        38.884         0.2572       0.5015
   7.000       42.827        21.414         0.4670       0.9106
   7.880       38.045        19.022         0.5257       1.0251
  14.000       21.414        10.707         0.9340       1.8213
 not: ~0,5 lambda = yuksek empedans (unun ister), ~0,25 lambda = dusuk empedans.

[2] Toroid: L = AL*N^2 ve X_L = 2*pi*f*L   (AL = 1075 nH/N^2)
  N    L [uH]   X_L@3.500 [ohm]   /450x   X_L@3.855 [ohm]   /450x
 12   154.800           3404.2    7.56           3749.5    8.33
 14   210.700           4633.5   10.30           5103.5   11.34
 kural: en dusuk frekansta X_L, 450 ohm'un en az 5-10 kati olmali.

[3] Uyumsuzluk kaybi: -10*log10(4*Z1*Z2/(Z1+Z2)^2),  Z2 = Z_yuk / oran
 Z_yuk     1:1 [dB]    9:1 [dB]   49:1 [dB]
    25         0.51        7.00       13.98
    40         0.05        5.23       11.99
    80         0.24        2.90        9.12
   150         1.25        1.25        6.63
  1000         7.41        0.67        0.84
  2000        10.21        2.22        0.04
  3000        11.90        3.43        0.04
  5000        14.07        5.19        0.54
 bolge: 25-150 ohm = lambda/4 (dusuk Z), 1000-5000 ohm = lambda/2 (yuksek Z).
 oran secimi Z'den bagimsiz: lambda/2 -> 49:1, lambda/4 -> 1:1; kayip ise Z'ye bagli.
 ters cozum: 0.02 dB -> Z_trafo =  57.271 ohm -> Z_tel =   515.441 ohm (9:1 icin; diger kok  43.652 ohm)

[4] Ferrit cubuk: L = k*mu0*mu_r*N^2*A/l  (l = 100 mm, d = 8 mm, mu_r = 400, k = 0.6)
 N = 79 -> L =  946.118 uH | A =   50.265 mm^2
 C = 100 pF -> f_rez =  517.4252 kHz
 490 kHz icin C =  111.507 pF | 518 kHz icin C =   99.778 pF

[5] Bobin Q -> kayip direnci ve bant genisligi  (L = 944 uH @ 518 kHz)
 X_L =     3072.4 ohm
   Q   R_kayip [ohm]    BW [kHz]
 100          30.72      5.180
 150          20.48      3.453
 200          15.36      2.590
 not: NAVTEX kanali ~1 kHz, komsu kanal 28 kHz uzakta -> 2-6 kHz yeterli.

[6] Capraz kontrol: ayni sayiya ikinci yol (kapali form <-> kok arama)
buyukluk                                 yol A       yol B   fark %
f_rez (946.118 uH, 100 pF) [kHz]      517.4252    517.4252   0.0000
BW Q=100 (944 uH, 518 kHz) [kHz]        5.1800      5.1800   0.0000
BW Q=200 (944 uH, 518 kHz) [kHz]        2.5900      2.5900   0.0000
9:1 kaybi Z=2000 ohm [dB]               2.2203      2.2203   0.0000

[7] grafik: anten_hesap-uyumsuzluk.png (14789 bayt)

------------------------------------------------------------------------------------
Ozet: 5 frekans x 4 buyukluk, 2 toroid, 8 yuk x 3 oran, 1 cubuk, 3 Q
      hesaplandi; 4 capraz kontrol TUTARLI. Sayilar formulden, elle yazilmadi.
```

## Öne Çıkan Noktalar

- **Oran seçimi Z'den bağımsızdır, kayıp Z'ye bağlıdır.** Tablodan okunur: 49:1 oranı yüksek
  empedans bölgesinde (1000-5000 Ω) 0,04-0,84 dB kayıpla çalışırken 25-150 Ω bölgesinde 6,6-14 dB
  kaybeder; 1:1'in durumu tam tersidir. Bu yüzden "hangi unun?" sorusunun cevabı telin λ sınıfına,
  "kayıp ne kadar?" sorusunun cevabı ise ölçülmemiş Z'ye bağlıdır — tek sayı yerine **aralık**
  yazılır.
- **Ters çözüm iki kök verir.** 0,02 dB kayıp hem 57,271 Ω hem 43,652 Ω yüke karşılık gelir
  (`Z_tel = 515,441 Ω`, 9:1 trafo için). Tek bir dB değeri empedansı **tek başına** belirlemez;
  kök seçimi ancak fiziksel bağlamla (telin λ sınıfı) yapılır.
- **50 katı kuralı somutlaşır:** 14 turda `X_L = 210,7 µH -> 3,855 MHz'de 5103,5 Ω`, yani 450 Ω
  kıyas çizgisinin 11,34 katı; 12 turda 8,33 kat. Kural "en az 5-10 kat" olduğu için 12 tur da
  geçer, 14 tur payı büyütür.
- **Ferrit çubukta varsayım payı büyüktür:** `mu_r = 400` ve `k = 0,6` üretici verisi değil,
  varsayımdır. 79 tur -> 946,118 µH -> 100 pF ile 517,4252 kHz. Rezonans `sqrt(L)` ile gittiği
  için endüktanstaki %10'luk sapma frekansta ~%5 olur; bu yüzden ölçüm (LCR metre ya da alıcıyla
  tepe arama) şarttır.
- **Q tablosu iki ayrı eksendir:** `R = X_L/Q` dirençsel kayıptır, uyumsuzluk kaybı ise empedans
  uyumsuzluğudur; ikisi toplanmaz, ayrı ayrı raporlanır. Q=100 -> 5,180 kHz bant genişliği NAVTEX
  kanalı (~1 kHz) için fazlasıyla geniştir, komşu kanal 28 kHz uzakta olduğu için sorun değildir.
- **Çapraz kontrol kod hatası yakalar, fiziği kanıtlamaz.** `f_rez` kapalı formla ve reaktans kökü
  ile aynı çıkar; `BW` hem `f/Q` hem `|Z| = sqrt(2)*R` kesişimiyle aynı çıkar. Bu, formülün
  doğruluğunu değil, **uygulamanın** doğru olduğunu gösterir — ikisi aynı şey değildir.
- **Lejant tuzağı (bu makinede ölçüldü):** `gnuplot` toolkit'inde `legend(...)` kutusu PNG'ye
  basılmıyor; eğri etiketleri `text(...)` ile yazıldı. Başsız ortamda görsel doğrulama olmadan
  "lejant var" denmemeli.

## Alıştırmalar

1. `frekanslar_mhz` dizisine `21` ve `28` ekleyin. 20 m tel bu frekanslarda kaç λ olur, desen
   lob'lu hâle gelir mi? Tabloyu yorumlayın.
2. `cubuk_mur` değerini `100`, `400`, `800` yapın. Endüktans `mu_r` ile doğru, rezonans `sqrt(mu_r)`
   ile ters orantılı mı? İki tabloyu karşılaştırıp doğrulayın.
3. `[3]` tablosunu 450 Ω yerine 200 Ω'a normalize edin (`z_referans = 200`). Sarım seçim ölçütü
   (5-10 kat) hangi turda sağlanıyor, kayıyor mu?
4. `yari_guc_noktasi` içindeki ikiye bölme adımını `200` yerine `20` yapın. `fark %` sütunu ne
   oluyor? Yakınsama ile doğru formül arasındaki farkı bu tek satırda görün.
5. `[7]` grafiğini `semilogy` yerine doğrusal eksende çizin: eğrilerin hangi bölgesi okunamaz hâle
   geliyor? Log eksen neden zorunlu?
6. Aynı hesabı kendi bandınıza uyarlayın: hedef frekansı (ör. 7,100 MHz) `frekanslar_mhz`'ye ekleyip
   λ/2 kol boyunu yazdırın; bulduğunuz boyu bir mezura ile karşılaştırın.
