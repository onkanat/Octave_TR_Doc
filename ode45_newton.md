---
layout: default
title: "Octave'de ODE45 ve Newton'un İkinci Yasası"
lang: tr
konu: muhendislik
seviye: orta
tur: ders
kod: ode45_newton.m
redirect_from: [/Octave_ODE45_Newton.html]
---

# Octave'de ODE45 ve Newton'un İkinci Yasası

Bu not, Newton'ın ikinci yasasını (F = m·a) ikinci dereceden bir diferansiyel denklem olarak
yazıp `ode45` ile çözer: sabit kuvvet altında hareket eden bir cismin konumu ve hızı zamanın
fonksiyonu olarak bulunur. Sayfadaki çıktı bloğu betiğin **ölçülmüş** koşusundan alınmıştır
(GNU Octave 11.3.0); sayısal çözüm kapalı çözümle karşılaştırıldığı için okur kendi koşusunda
aynı sapma büyüklüğünü görür.

## Ne öğreneceksiniz

- Newton'ın ikinci yasasından ivmeyi hesaplamayı: **a = F / m**, 10 N / 2 kg = 5 m/s²
- İkinci dereceden hareket denklemini iki birinci derece denkleme indirmeyi
  (`y(1)` = konum, `y(2)` = hız)
- `ode45` çağrısının üç girdisini: fonksiyon tutamacı, zaman vektörü, başlangıç koşulu
- Sayısal çözümü kapalı çözümle (`x = a·t²/2`, `v = a·t`) karşılaştırıp en büyük sapmayı ölçmeyi
- Başsız (headless) oturumda `figure("visible", "off")` + `print -dpng` ile grafiği dosyaya yazmayı

## Çalıştırma

```sh
octave --no-gui ode45_newton.m
```

Betik reponun kökünde ve tek başına koşar; ek paket yüklemez (`ode45` bu Octave sürümünün
çekirdeğinde `m/ode/ode45.m` olarak gelir). Bu makinede `octave --no-gui` Qt/cocoa eklentisi
yüzünden betiği yüklemeden düşüyor (`qt.qpa.plugin ... Abort trap: 6`, **EXIT=134**); aynı
çıktıyı veren başsız karşılığı `octave-cli` olduğu için sayfadaki blok **`octave-cli`** ile
ölçüldü. Grafik `assets/img/ode45_newton-hareket.png` dosyasına yazılır, ekran açılmaz.

## Kod

### Denklem: F = m · a

**Newton'ın İkinci Yasası**, bir cisim üzerinde uygulanan net kuvvetin, o cismin kütlesine ve
ivmesine eşit olduğunu belirtir. Bu yasayı matematiksel olarak ifade etmek için aşağıdaki
denklem kullanılır:

**F = m * a**

Burada:

* **F**: Cisim üzerinde uygulanan net kuvvet (N)
* **m**: Cismin kütlesi (kg)
* **a**: Cismin ivmesi (m/s²)

Bu denklem, bir cismin hareketini zamanla nasıl değiştirdiğini açıklamak için kullanılabilir.

**Örnek:** Bir cisim üzerinde 10 Newtonluk bir kuvvet uygulandığını ve cismin kütlesinin
2 kilogram olduğunu varsayalım. Bu durumda cismin ivmesi ne olacaktır? Newton'ın İkinci Yasasını
kullanarak ivmeyi hesaplayabiliriz: **a = F / m** → **a = 10 N / 2 kg** → **a = 5 m/s²**.
Görüldüğü gibi, 10 Newtonluk bir kuvvet 2 kilogram kütleli bir cismi 5 metre/saniyekarelik bir
ivmeyle hızlandırır. Betiğin `[1]` bölümü tam olarak bu hesabı yapar.

### ODE45 kullanarak hareketi çözme

Newton'ın ikinci yasası (`a = F/m`), ikinci dereceden bir diferansiyel denklemdir çünkü ivme,
konumun zamana göre ikinci türevidir (`a = d²x/dt²`). `ode45` gibi sayısal çözücüler, birinci
dereceden diferansiyel denklem sistemleriyle çalışır. Bu nedenle, ikinci dereceden denklemimizi
iki adet birinci dereceden denkleme dönüştürmemiz gerekir:

1. **Durum Değişkenlerini Tanımlama:**
   * `y(1)`: Cismin konumu (`x`)
   * `y(2)`: Cismin hızı (`v` veya `dx/dt`)
2. **Denklem Sistemini Yazma:**
   * Konumun türevi hızdır: `dy(1)/dt = y(2)`
   * Hızın türevi ivmedir: `dy(2)/dt = F/m`

Bu sistem, `ode45` fonksiyonuna verilecek olan diferansiyel denklem fonksiyonunu tanımlar.
Fonksiyon, `t` (zaman) ve `y` (durum vektörü: `[konum; hız]`) girdilerini alıp, bu durumların
türevlerinden oluşan bir vektör (`[hız; ivme]`) döndürmelidir. Betikte bu, tek satırlık bir
anonim fonksiyondur: `newton_ode = @(t, y) [y(2); F/m];`

### Betik

Aşağıdaki betik dosyanın tamamıdır (`kod: ode45_newton.m`). `[1]` ivmeyi, `[2]` sistem
tanımını, `[3]` `ode45` çağrısını, `[4]` kapalı çözümle karşılaştırmayı, `[5]` grafiği yazar.

```octave
clear; clc; close all;

%% 0. Hazirlik: basi bos uyarilar kapali, cizim dosyaya
warning("off", "all");
graphics_toolkit("gnuplot");
betik_dizini = fileparts(mfilename("fullpath"));
if isempty(betik_dizini); betik_dizini = pwd(); end
img_dizini = fullfile(betik_dizini, "assets", "img");
if ~exist(img_dizini, "dir"); mkdir(img_dizini); end

%% 1. Newton'un ikinci yasasi: F = m * a
m = 2;          % kutle (kg)
F = 10;         % net kuvvet (N)
a = F / m;      % ivme (m/s^2)
printf("[1] Newton II: F = %g N, m = %g kg -> a = F/m = %g m/s^2\n", F, m, a);

%% 2. Ikinci dereceden denklemi birinci derece sisteme cevir
% y(1) = konum x (m), y(2) = hiz v (m/s)
% dy(1)/dt = y(2)        (konumun turevi hizdir)
% dy(2)/dt = F/m         (hizin turevi ivmedir)
newton_ode = @(t, y) [y(2); F/m];
y0 = [0; 0];                 % [konum; hiz] baslangic kosulu
t_eval = 0:0.1:10;          % zaman vektoru (s)
printf("[2] durum vektoru y = [konum; hiz], y0 = [%g; %g], t = 0..%.0f s (%d nokta)\n", ...
       y0(1), y0(2), t_eval(end), numel(t_eval));

%% 3. ode45 ile sayisal cozum
[t, y] = ode45(newton_ode, t_eval, y0);
printf("[3] ode45: %d zaman noktasi dondurdu, adim %.2f s\n", numel(t), t(2) - t(1));

%% 4. Kapali cozumle karsilastir: x = a*t^2/2, v = a*t
konum_kapali = 0.5 * a * t.^2;
hiz_kapali   = a * t;
printf("[4] t (s)   konum (m)   hiz (m/s)   kapali konum   fark (m)\n");
for k = 1:20:numel(t)
  printf("    %5.1f   %9.4f   %9.4f   %12.4f   %.2e\n", ...
         t(k), y(k,1), y(k,2), konum_kapali(k), abs(y(k,1) - konum_kapali(k)));
end
printf("[4] en buyuk sapma: konum %.2e m, hiz %.2e m/s\n", ...
       max(abs(y(:,1) - konum_kapali)), max(abs(y(:,2) - hiz_kapali)));

%% 5. Konum ve hizi tek figurde iki panele yaz (basasiz: dosyaya)
f = figure("visible", "off"); graphics_toolkit(f, "gnuplot");
subplot(2, 1, 1);
plot(t, y(:,1), "b-", "LineWidth", 2); grid on;
xlabel("Zaman (s)"); ylabel("Konum (m)");
title("Newton'in ikinci yasasi: konum (ode45)");
subplot(2, 1, 2);
plot(t, y(:,2), "r--", "LineWidth", 2); grid on;
xlabel("Zaman (s)"); ylabel("Hiz (m/s)");
title("Newton'in ikinci yasasi: hiz (ode45)");
dosya = fullfile(img_dizini, "ode45_newton-hareket.png");
print(f, dosya, "-dpng", "-r110");
printf("[5] grafik: %s (%d bayt)\n", "ode45_newton-hareket.png", dir(dosya).bytes);

%% Ozet
printf("\nOzet: a = F/m = %g m/s^2 sabit ivme ile 10 s sonunda konum %.2f m,\n", a, y(end,1));
printf("      hiz %.2f m/s; ode45 cozumu kapali cozumle %.1e m icinde ortusuyor.\n", ...
       y(end,2), max(abs(y(:,1) - konum_kapali)));
```

Bu kod, cismin konumunu ve hızını zamanla gösteren iki grafik oluşturur (tek figürde iki panel
olarak dosyaya yazılır: `assets/img/ode45_newton-hareket.png`).

## Beklenen Çıktı

```
[1] Newton II: F = 10 N, m = 2 kg -> a = F/m = 5 m/s^2
[2] durum vektoru y = [konum; hiz], y0 = [0; 0], t = 0..10 s (101 nokta)
[3] ode45: 101 zaman noktasi dondurdu, adim 0.10 s
[4] t (s)   konum (m)   hiz (m/s)   kapali konum   fark (m)
      0.0      0.0000      0.0000         0.0000   0.00e+00
      2.0     10.0000     10.0000        10.0000   1.78e-15
      4.0     40.0000     20.0000        40.0000   1.42e-14
      6.0     90.0000     30.0000        90.0000   2.84e-14
      8.0    160.0000     40.0000       160.0000   5.68e-14
     10.0    250.0000     50.0000       250.0000   2.84e-14
[4] en buyuk sapma: konum 2.27e-13 m, hiz 3.55e-14 m/s
[5] grafik: ode45_newton-hareket.png (19275 bayt)

Ozet: a = F/m = 5 m/s^2 sabit ivme ile 10 s sonunda konum 250.00 m,
      hiz 50.00 m/s; ode45 cozumu kapali cozumle 2.3e-13 m icinde ortusuyor.
```

## Öne Çıkan Noktalar

- **ODE45**, birinci dereceden ODE'leri çözmek için kullanılan bir fonksiyondur; `y` ve
  `dy/dt`'nin fonksiyonlarını ve başlangıç koşullarını girdi olarak alır, zamanla `y`'nin nasıl
  değiştiğini gösteren bir çözüm verir. Newton'ın İkinci Yasası gibi hareket problemlerini
  çözmek için kullanılabilir.
- **`ode45` bu sürümde çekirdekte:** `which ode45` → `.../share/octave/11.3.0/m/ode/ode45.m`.
  Ek paket kurmak gerekmedi; MATLAB'da da aynı adla çağrılır.
- **Sabit kuvvetin kapalı çözümü vardır:** `x = a·t²/2`. Betik bu yüzden iki çözümü yan yana
  koyabiliyor: 10 s sonunda ikisi de 250,0000 m verir, en büyük sapma `2.27e-13 m` — çözücünün
  yuvarlama hatası düzeyinde. Sapmanın sıfır değil `1e-13` mertebesinde olması normaldir
  (kayan noktalı aritmetik), hata değil.
- **Zaman vektörü çözümü belirler:** `0:0.1:10` verildiğinde `ode45` tam 101 nokta döndürür ve
  adım `0,10 s` olur; yalnız `[0 10]` verilseydi çözücü kendi (değişken) adımlarını seçer,
  "Beklenen Çıktı" satırları tutmazdı.
- **Notlar:** Bu sadece basit bir örnektir; `ode45`'i daha karmaşık problemlerde de
  kullanabilirsiniz. Ayrıntılı belge için Octave belgelerine bakabilirsiniz:
  <https://www.gnu.org/software/octave/doc/interpreter/Ordinary-Differential-Equations.html>

## Alıştırmalar

1. Kuvveti zamana bağlı yapın: `newton_ode = @(t, y) [y(2); F/m - 0.1*y(2)];` (hava sürtünmesi).
   Kapalı çözüm artık geçerli değil; 10 s sonunda hız kaç m/s oluyor ve neden `50 m/s`'nin
   altında kalıyor?
2. Başlangıç koşulunu `y0 = [0; 5]` (5 m/s ilk hız) yapın; `[4]` tablosundaki konumlar nasıl
   kayıyor? `ode45` çıktısı ile `x = 5t + a·t²/2` kapalı çözümünü karşılaştırın.
3. Kütleyi `m = 10` yapıp ivmeyi `1 m/s²`'ye düşürün; hem son konumu hem grafikteki eğimin
   dikliğini yorumlayın. `ode45` çağrısında zaman vektörünü çıkarıp `[t, y] = ode45(f, [0 10], y0)`
   yazdığınızda `t` kaç nokta döndürüyor?
