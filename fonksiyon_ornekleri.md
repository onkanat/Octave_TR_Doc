---
layout: default
title: "Octave'de Fonksiyon Yazımı ve Mühendislik Uygulaması"
lang: tr
konu: muhendislik
seviye: orta
tur: ders
kod: fonksiyon_ornekleri.m
redirect_from: [/Octave_functions_example.html]
---

# Octave'de Fonksiyon Yazımı ve Mühendislik Uygulaması

Bu not, Octave'de fonksiyonun nasıl tanımlandığını ve bir mühendislik problemine nasıl
uygulandığını gösterir: üç noktası bilinen bir dairenin merkezi ile yarıçapı, iki noktası
bilinen bir doğru ve bu ikisinin kesişip kesişmediği. Dört ayrı fonksiyon tek betikte
tanımlanır; her adımın çıktısı ölçülmüş hâliyle sayfadadır.

## Ne öğreneceksiniz

- `function [cikti1, cikti2] = ad(girdi1, girdi2) ... end` yapısını ve dosya adı = fonksiyon adı kuralını
- Fonksiyonun ilk yorum bloğunun `help <ad>` ile belge olarak okunduğunu
- Üç noktadan geçen dairenin merkezini (çevrel merkez) determinant formülüyle hesaplamayı
- İki noktadan geçen doğruyu `a·x + b·y = c` biçiminde normalize edip noktadan uzaklığı ölçmeyi
- Uzaklığı yarıçapla karşılaştırıp **kesişiyor / teğet / kesişmiyor** hükmünü kuran bir fonksiyon yazmayı

## Çalıştırma

```sh
octave --no-gui fonksiyon_ornekleri.m
```

Betik reponun kökünde ve tek başına koşar: fonksiyonlar **aynı dosya içinde** yerel fonksiyon
olarak tanımlıdır, başka bir `.m` dosyasına bağımlılığı yoktur. Grafik çıktısını
`assets/img/fonksiyon_ornekleri-kesisim.png` olarak yazar (görünmez pencere, gnuplot).
Bu makinede `octave --no-gui` Qt/cocoa eklentisi yüzünden betiği yüklemeden düşüyor
(EXIT=134), bu yüzden sayfadaki blok `octave-cli` ile ölçüldü.

## Kod

```octave
clear; clc; close all;
1;

%% Yerel fonksiyonlar (Octave: betik icinde tanimli, kullanimdan once gelir)
function dogru = two_point_line(p1, p2)
  % Iki noktadan gecen dogruyu a*x + b*y = c biciminde dondurur.
  a = p2(2) - p1(2);
  b = p1(1) - p2(1);
  c = a * p1(1) + b * p1(2);
  n = hypot(a, b);
  dogru = [a/n, b/n, c/n];
end

function [merkez, yaricap] = circle_center(p1, p2, p3)
  % Uc noktadan gecen dairenin merkezini (cevrel merkez) ve yaricapini bulur.
  D = 2 * (p1(1)*(p2(2) - p3(2)) + p2(1)*(p3(2) - p1(2)) + p3(1)*(p1(2) - p2(2)));
  if abs(D) < 1e-12
    error("Noktalar dogrusal: cevrel merkez yok.");
  end
  s1 = p1(1)^2 + p1(2)^2;
  s2 = p2(1)^2 + p2(2)^2;
  s3 = p3(1)^2 + p3(2)^2;
  ux = (s1*(p2(2) - p3(2)) + s2*(p3(2) - p1(2)) + s3*(p1(2) - p2(2))) / D;
  uy = (s1*(p3(1) - p2(1)) + s2*(p1(1) - p3(1)) + s3*(p2(1) - p1(1))) / D;
  merkez  = [ux, uy];
  yaricap = norm(p1 - merkez);
end

function [durum, mesafe] = check_intersection(merkez, yaricap, p1, p2)
  % Merkezin dogruya dik uzakligini yaric Rapla karsilastirir.
  dogru  = two_point_line(p1, p2);
  mesafe = abs(dogru(1)*merkez(1) + dogru(2)*merkez(2) - dogru(3));
  if mesafe < yaricap
    durum = "kesisiyor (2 nokta)";
  elseif abs(mesafe - yaricap) < 1e-9
    durum = "teget (1 nokta)";
  else
    durum = "kesismiyor";
  end
end

%% 1. Girdi noktalari
p1 = [0 0];
p2 = [4 0];
p3 = [2 3];
printf("[1] daire noktalari : (%.1f,%.1f) (%.1f,%.1f) (%.1f,%.1f)\n", ...
       p1, p2, p3);

%% 2. Daire merkezi ve yaricapi
[merkez, yaricap] = circle_center(p1, p2, p3);
printf("[2] cevrel merkez  : (%.4f, %.4f)\n", merkez(1), merkez(2));
printf("[2] yaricap         : %.4f\n", yaricap);
printf("[2] uc noktaya uzaklik (esit olmali): %.4f %.4f %.4f\n", ...
       norm(p1 - merkez), norm(p2 - merkez), norm(p3 - merkez));

%% 3. Iki noktadan gecen dogru
L1 = [0 1];
L2 = [4 1];
dogru = two_point_line(L1, L2);
printf("[3] dogru katsayilari: %.4f x + %.4f y = %.4f\n", dogru(1), dogru(2), dogru(3));

%% 4. Kesisim kontrolu: uc ayri dogru ile uc durum
testler = {[0 1], [4 1]; [0 3.25], [4 3.25]; [0 3], [4 3]};
for k = 1:rows(testler)
  [durum, mesafe] = check_intersection(merkez, yaricap, testler{k,1}, testler{k,2});
  printf("[4] dogru y=%.4f : mesafe %.4f -> %s\n", ...
         testler{k,1}(2), mesafe, durum);
end

%% 5. Grafik: daire, merkez, noktalar ve uc dogru
warning("off", "Octave:gnuplot-graphics");
warning("off", "Octave:fltk-graphics");
betik_dizini = fileparts(mfilename("fullpath"));
if isempty(betik_dizini)
  betik_dizini = pwd();
end
img_dizini = fullfile(betik_dizini, "assets", "img");
if ~exist(img_dizini, "dir")
  mkdir(img_dizini);
end

t = linspace(0, 2*pi, 200);
f = figure("visible", "off");
graphics_toolkit(f, "gnuplot");
plot(merkez(1) + yaricap*cos(t), merkez(2) + yaricap*sin(t), "b-", "LineWidth", 2);
hold on;
plot([L1(1) L2(1)], [L1(2) L2(2)], "r--", "LineWidth", 2);
plot([testler{2,1}(1) testler{2,2}(1)], [testler{2,1}(2) testler{2,2}(2)], "k:", "LineWidth", 2);
plot([testler{3,1}(1) testler{3,2}(1)], [testler{3,1}(2) testler{3,2}(2)], "m-.", "LineWidth", 2);
plot([p1(1) p2(1) p3(1) merkez(1)], [p1(2) p2(2) p3(2) merkez(2)], "ko", "MarkerSize", 6);
hold off;
xlim([-2 6]);
ylim([-2.5 3.5]);
grid on;
title("Daire, dogrular ve cevrel merkez");
xlabel("x"); ylabel("y");
legend("daire", "y = 1 (kesisen)", "y = 3.25 (kesismeyen)", "y = 3 (teget)", ...
       "noktalar", "location", "northwest");
dosya = fullfile(img_dizini, "fonksiyon_ornekleri-kesisim.png");
print(f, dosya, "-dpng", "-r120");
printf("\n[5] grafik          : %s (%d bayt)\n", "fonksiyon_ornekleri-kesisim.png", dir(dosya).bytes);

%% Ozet
printf("\nOzet: uc yerel fonksiyon (two_point_line, circle_center, check_intersection)\n");
printf("      tek betikte tanimlandi ve 3 dogru uzerinde olculdu.\n");
printf("      Fonksiyon adi rakamla baslayamaz: src/2point_line.m -> two_point_line.m\n");
```

Betik, eskiden `src/` altında dört ayrı dosyaya dağılmış aynı işi (`two_point_line.m`,
`circle_center.m`, `check_intersection.m`, `visualize_intersection.m`) tek bir çalıştırılabilir
betiğe toplar. `src/` altındaki dosyalar tarihsel olarak yerinde durur; bu betik onlara
bağımlı değildir.

## Beklenen Çıktı

```
[1] daire noktalari : (0.0,0.0) (4.0,0.0) (2.0,3.0)
[2] cevrel merkez  : (2.0000, 0.8333)
[2] yaricap         : 2.1667
[2] uc noktaya uzaklik (esit olmali): 2.1667 2.1667 2.1667
[3] dogru katsayilari: 0.0000 x + -1.0000 y = -1.0000
[4] dogru y=1.0000 : mesafe 0.1667 -> kesisiyor (2 nokta)
[4] dogru y=3.2500 : mesafe 2.4167 -> kesismiyor
[4] dogru y=3.0000 : mesafe 2.1667 -> teget (1 nokta)

[5] grafik          : fonksiyon_ornekleri-kesisim.png (9611 bayt)

Ozet: uc yerel fonksiyon (two_point_line, circle_center, check_intersection)
      tek betikte tanimlandi ve 3 dogru uzerinde olculdu.
      Fonksiyon adi rakamla baslayamaz: src/2point_line.m -> two_point_line.m
```

## Öne Çıkan Noktalar

- **Fonksiyon adı rakamla başlayamaz:** iki noktayı temsil eden dosya bu yüzden `2point_line.m`
  değil `two_point_line.m` adını taşır.
- `D = 2·(x1(y2−y3) + x2(y3−y1) + x3(y1−y2))` determinantı sıfıra çok yakınsa noktalar
  doğrusaldır ve çevrel merkez yoktur; betik bu durumda `error(...)` ile durur.
- Üç noktanın merkeze uzaklığı yarıçapa **eşit** çıkar (çıktıda üç kez `2.1667`); bu,
  çevrel merkez formülünün doğrulamasıdır.
- Doğruyu normalize etmek (`[a b c] / hypot(a,b)`) uzaklık hesabını tek satıra indirir:
  `|a·x0 + b·y0 − c|`. Normalize edilmezse `hypot(a,b)` ile bölmek gerekir.
- `teget` durumu `abs(mesafe - yaricap) < 1e-9` ile ayrılır; kayan nokta karşılaştırmasında
  `==` kullanmak yanıltıcıdır. Çıktıda üç durum da (kesişiyor / kesişmiyor / teğet) ölçülmüştür.

## Alıştırmalar

1. `p3` noktasını `[3 1]` yapın; yeni çevrel merkez ve yarıçapı ölçün, üç uzaklığın yine eşit
   çıktığını doğrulayın.
2. `check_intersection` fonksiyonunu iki kesişim noktasının **koordinatlarını** da döndürecek
   şekilde genişletin (ipucu: doğru–daire denklem sistemini çözün).
3. Fonksiyonların ilk yorum bloklarını `help` biçimine uygun yazıp `help two_point_line`
   çıktısını betik içinden `help("two_point_line")` ile okunur hâle getirin.
