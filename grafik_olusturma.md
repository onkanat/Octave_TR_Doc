---
layout: default
title: "Octave'de Grafik Oluşturma: 2B, 3B ve Animasyon"
lang: tr
konu: grafik
seviye: orta
tur: ders
kod: grafik_olusturma.m
redirect_from: [/Octave_grafik_olusturma.html]
---

# Octave'de Grafik Oluşturma: 2B, 3B ve Animasyon

Octave, matematiksel işlevleri ve verileri görselleştirmek için geniş bir grafik araç
kümesi sunar. Bu not; temel çizgi grafiğinden (`plot`, eksen etiketleri, `legend`, `grid`)
alt grafiklere (`subplot`), üç boyutlu yüzeylere (`surf`, `mesh`, `peaks`, `colorbar`) ve
döngü içinde `drawnow` ile animasyona kadar izleri tek betikte toplar. Betik grafikleri
**görünmez pencere** ile üretip PNG olarak `assets/img/` altına yazar; sayfadaki çıktı
bloğu bu koşunun ölçülmüş hâlidir.

## Ne öğreneceksiniz

- `plot`, `xlabel`, `ylabel`, `title`, `legend`, `grid` ile okunabilir bir 2B grafik kurmayı
- `subplot(1, 2, n)` ile iki grafiği tek pencerede alt grafik olarak yerleştirmeyi
- `meshgrid` + `peaks` ile ızgara kurup `surf` ve `mesh` ile 3B yüzey çizmeyi, `colorbar` eklemeyi
- `get`/`set` ve `gca` ile çizgi ile eksen özelliklerini okumayı ve değiştirmeyi
- `for` döngüsü + `drawnow` ile animasyon karesi üretmeyi ve `print -dpng` ile dosyaya yazmayı

## Çalıştırma

```sh
octave --no-gui grafik_olusturma.m
```

Betik reponun kökünde ve tek başına koşar; PNG dosyalarını `assets/img/` altına yazar
(dizin yoksa `mkdir` ile kurar). Grafik penceresi açmaz: `figure("visible", "off")` ve
`graphics_toolkit(f, "gnuplot")` kullanır. Bu makinede `octave --no-gui` Qt/cocoa eklentisi
yüzünden betiği yüklemeden düşüyor (EXIT=134), bu yüzden sayfadaki blok `octave-cli` ile
ölçüldü; grafikler de aynı yolla üretildi.

## Kod

```octave
clear; clc; close all;

%% 0. Hazirlik: basi bos (headless) cizim
% Bu makinede Qt/cocoa eklentisi yok; `octave --no-gui` betigi yuklemeden duser.
% Betik `octave-cli` ile kosar ve grafikleri gorunmez pencere + gnuplot ile uretir.
warning("off", "Octave:gnuplot-graphics");
warning("off", "Octave:fltk-graphics");

betik_dizini = fileparts(mfilename("fullpath"));
if isempty(betik_dizini); betik_dizini = pwd(); end
img_dizini = fullfile(betik_dizini, "assets", "img");
if ~exist(img_dizini, "dir")
  mkdir(img_dizini);
end

%% 1. Temel cizgi grafigi: plot + xlabel/ylabel/title + grid + legend
x  = linspace(-2, 2, 200);
y1 = sin(x);
y2 = cos(x);

f1 = figure("visible", "off"); graphics_toolkit(f1, "gnuplot");
plot(x, y1, "b-", "LineWidth", 2);
hold on;
plot(x, y2, "r--", "LineWidth", 1.5);
hold off;
xlabel("X ekseni");
ylabel("Y ekseni");
title("sin(x) ve cos(x), x in [-2, 2]");
legend("sin(x)", "cos(x)", "location", "northeast");
grid on;
dosya1 = fullfile(img_dizini, "grafik_olusturma-sinus.png");
print(f1, dosya1, "-dpng", "-r120");
printf("[1] temel grafik    : %s (%d bayt)\n", "grafik_olusturma-sinus.png", dir(dosya1).bytes);

%% 2. subplot: iki grafigi tek pencerede alt grafik olarak
f2 = figure("visible", "off"); graphics_toolkit(f2, "gnuplot");

x1 = 0:0.1:pi;
subplot(1, 2, 1);
plot(x1, sin(x1), "r-", "LineWidth", 2);
xlabel("X1"); ylabel("Y1"); title("sin, [0, pi]"); grid on;

x2 = pi:0.1:2*pi;
subplot(1, 2, 2);
plot(x2, cos(x2), "k--", "LineWidth", 2);
xlabel("X2"); ylabel("Y2"); title("cos, [pi, 2pi]"); grid on;

dosya2 = fullfile(img_dizini, "grafik_olusturma-subplot.png");
print(f2, dosya2, "-dpng", "-r120");
printf("[2] subplot (1x2)   : %s (%d bayt)\n", "grafik_olusturma-subplot.png", dir(dosya2).bytes);

%% 3. Uc boyutlu yuzey: surf ve mesh
[xg, yg] = meshgrid(-3:0.25:3);
zg = peaks(xg, yg);

f3 = figure("visible", "off"); graphics_toolkit(f3, "gnuplot");
surf(xg, yg, zg);
title("surf: dolu yuzey");
xlabel("X"); ylabel("Y"); zlabel("Yukseklik");
colorbar;
dosya3 = fullfile(img_dizini, "grafik_olusturma-surf.png");
print(f3, dosya3, "-dpng", "-r120");
printf("[3] surf + colorbar : %s (%d bayt)\n", "grafik_olusturma-surf.png", dir(dosya3).bytes);

f4 = figure("visible", "off"); graphics_toolkit(f4, "gnuplot");
mesh(xg, yg, zg);
title("mesh: tel kafes");
xlabel("X"); ylabel("Y"); zlabel("Yukseklik");
dosya4 = fullfile(img_dizini, "grafik_olusturma-mesh.png");
print(f4, dosya4, "-dpng", "-r120");
printf("[3] mesh            : %s (%d bayt)\n", "grafik_olusturma-mesh.png", dir(dosya4).bytes);
printf("     peaks izgara   : %d x %d nokta, z araligi [%.3f, %.3f]\n", ...
       rows(zg), columns(zg), min(zg(:)), max(zg(:)));

%% 4. get / set ile grafik ozelligini okuma ve degistirme
f5 = figure("visible", "off"); graphics_toolkit(f5, "gnuplot");
h_cizgi = plot(x, y1, "LineWidth", 1);
h_eksen  = gca;

ilk_renk   = get(h_cizgi, "Color");
ilk_kalin  = get(h_cizgi, "LineWidth");
printf("[4] once: renk [%s] kalinlik %g\n", ...
       num2str(ilk_renk, "%.2f "), ilk_kalin);

set(h_cizgi, "LineWidth", 4, "Color", [0.85 0.33 0.10], "LineStyle", "--");
set(h_eksen, "FontSize", 14, "FontWeight", "bold");
set(h_eksen, "GridColor", [0.60 0.66 0.70]);
grid on;
title("set ile degistirilmis grafik");

yeni_renk  = get(h_cizgi, "Color");
yeni_kalin = get(h_cizgi, "LineWidth");
yeni_yazi  = get(h_eksen, "FontSize");
printf("[4] sonra: renk [%s] kalinlik %g, eksen yazi boyu %g\n", ...
       num2str(yeni_renk, "%.2f "), yeni_kalin, yeni_yazi);

dosya5 = fullfile(img_dizini, "grafik_olusturma-set.png");
print(f5, dosya5, "-dpng", "-r120");
printf("[4] set/get grafigi : %s (%d bayt)\n", "grafik_olusturma-set.png", dir(dosya5).bytes);

%% 5. Dongu ile animasyon: her adimda grafigi yeniden ciz
% Etkilesimli oturumda drawnow kareyi pencerede gosterir; burada kare sayisi
% ve son kare olculur (pause kullanilmaz, betik beklemeden biter).
xa = 0:0.2:2*pi;
f6 = figure("visible", "off"); graphics_toolkit(f6, "gnuplot");
kare = 0;
for t = 0:0.5:2
  kare = kare + 1;
  plot(xa, sin(xa - t), "LineWidth", 2);
  axis([0 2*pi -1.2 1.2]);
  title(sprintf("Ilerleyen dalga, t = %.1f s", t));
  xlabel("Konum"); ylabel("Genlik");
  drawnow;
end
dosya6 = fullfile(img_dizini, "grafik_olusturma-animasyon.png");
print(f6, dosya6, "-dpng", "-r120");
printf("[5] animasyon        : %d kare, son kare %s (%d bayt)\n", ...
       kare, "grafik_olusturma-animasyon.png", dir(dosya6).bytes);

%% Ozet
printf("\nOzet: 6 PNG dosyasi assets/img/ altina yazildi (gorunmez pencere, gnuplot).\n");
printf("      plot/xlabel/ylabel/title/legend/grid, subplot, surf/mesh, set/get ve\n");
printf("      dongu icinde drawnow ile animasyon\n");
printf("      ayni betikte olculdu.\n");
```

Betiğin ürettiği dosyalar (hepsi `assets/img/` altında):
`grafik_olusturma-sinus.png`, `grafik_olusturma-subplot.png`, `grafik_olusturma-surf.png`,
`grafik_olusturma-mesh.png`, `grafik_olusturma-set.png`, `grafik_olusturma-animasyon.png`.

## Beklenen Çıktı

```
[1] temel grafik    : grafik_olusturma-sinus.png (11485 bayt)
[2] subplot (1x2)   : grafik_olusturma-subplot.png (12677 bayt)

multiplot> set style increment default;
                               ^
           line 0: warning: deprecated command
[3] surf + colorbar : grafik_olusturma-surf.png (39935 bayt)

multiplot> set style increment default;
                               ^
           line 0: warning: deprecated command
[3] mesh            : grafik_olusturma-mesh.png (32893 bayt)
     peaks izgara   : 25 x 25 nokta, z araligi [-6.327, 7.997]
[4] once: renk [0.00 0.45 0.74] kalinlik 1
[4] sonra: renk [0.85 0.33 0.10] kalinlik 4, eksen yazi boyu 14
[4] set/get grafigi : grafik_olusturma-set.png (8873 bayt)
[5] animasyon        : 5 kare, son kare grafik_olusturma-animasyon.png (10692 bayt)

Ozet: 6 PNG dosyasi assets/img/ altina yazildi (gorunmez pencere, gnuplot).
      plot/xlabel/ylabel/title/legend/grid, subplot, surf/mesh, set/get ve
      dongu icinde drawnow ile animasyon
      ayni betikte olculdu.
```

Blokta görülen `multiplot> ... deprecated command` satırları gnuplot arka ucunun kendi
uyarısıdır (3B çizimde çıkar); hata değildir, EXIT kodu 0'dır.

## Öne Çıkan Noktalar

- Grafik nesneleri birer değişkendir: `get(h, "LineWidth")` özelliği okur, `set(h, ...)`
  değiştirir. `gca` mevcut eksenin tanıtıcısını verir; `set(gca, "FontSize", 14)` tüm
  etiketleri birden büyütür.
- `subplot(1, 2, 1)` ve `subplot(1, 2, 2)` tek satır, iki sütunlu yerleşimde sırasıyla sol
  ve sağ paneli seçer; çizim komutlarından **önce** çağrılmalıdır.
- `peaks` iki değişkenli bir normal dağılım karışımıdır ve 3B çizim denemelerinde standart
  test yüzeyidir; `meshgrid(-3:0.25:3)` ile 25×25 ızgara kuruldu.
- Başsız oturumda `figure("visible", "off")` şarttır: görünmez pencere + `gnuplot` arka ucu
  PNG'yi diske yazar, ekran açmaz. `pause` kullanılmadı; animasyon kareleri `drawnow` ile
  üretilip son kare dosyaya alındı.
- **Ölçülen sınır (gnuplot arka ucu):** `legend` kutusu ve `LineWidth` ayarı PNG çıktısına
  yansımıyor (etkileşimli oturumda/qt ile görünür). Bu yüzden görsellerde efsane kutusu yok;
  sayfadaki metin ile betik arasındaki fark budur, çıktı uydurulmadı.

## Alıştırmalar

1. `loglog`, `semilogx` ve `semilogy` ile aynı `sin(x)` verisini üç ayrı ölçekte çizin;
   eksen etiketlerinin okunabilirliğini karşılaştırın.
2. `subplot(2, 2, n)` ile dört panelli tek pencere kurun: `plot`, `semilogy`, `surf`, `mesh`.
3. Animasyon döngüsündeki adımı `0.5` yerine `0.1` yapın; kare sayısı ve son kare arasındaki
   farkı ölçün (`kare` değişkeni kaç olur?).
