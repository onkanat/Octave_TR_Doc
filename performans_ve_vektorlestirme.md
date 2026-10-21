---
layout: default
title: "Octave'de Performans ve Vektörleştirme"
lang: tr
konu: ileri
seviye: ileri
tur: ders
kod: performans_ve_vektorlestirme.m
redirect_from: [/Octave_performance_vectorization.html]
---

# Octave'de Performans ve Vektörleştirme

Octave yorumlanan bir dil olduğu için `for` döngüsünün her adımı yorumlayıcıda ayrı ayrı
işlenir; buna karşılık `A*B` ya da `a.*b` gibi vektörleştirilmiş işlemler derlenmiş
BLAS/LAPACK katmanına tek çağrıyla iner. Bu not; eleman çarpımı, fonksiyon değerlendirme,
mantıksal indeksleme, kümülatif toplam, matris-vektör çarpımı ve ön bellek ayırma
örneklerinde **döngü ile vektör yolunun aynı sonucu verdiğini** ölçer. Sayfadaki çıktı
bloğu betiğin **ölçülmüş** koşusundan alınmıştır.

## Ne öğreneceksiniz

- `for` döngüsü ile `.*`, `sum`, `cumsum`, `A*x` gibi vektör işlemlerinin sonuçlarını
  `isequal` ile karşılaştırmayı
- `sin(x) .* exp(-0.1*x)` gibi ifadelerin vektör girdiyle doğrudan çalıştığını
- Mantıksal indeksleme (`v(v < 0) = 0`) ile koşullu işlemleri döngüsüz yazmayı
- Matris-vektör çarpımında iç içe döngü yerine `A*x` kullanmayı ve farkın yuvarlama
  hatasından (1e-14 mertebesi) ibaret olduğunu görmeyi
- Ön bellek ayırmanın (`zeros`) büyüyen diziye (`buyuyen(end+1)`) göre neden tercih
  edildiğini ve süre ölçümünün neden çıktıya yazılmadığını

## Çalıştırma

```sh
octave --no-gui performans_ve_vektorlestirme.m
```

Betik reponun kökünde ve tek başına koşar; paket yüklemez. Tohum `rand("state", 42)` ve
`randn("state", 42)` ile sabitlendiği için iki koşu birebir aynı çıktıyı verir. **Süreler
ölçülür ama ekrana yazılmaz:** işlem süresi makineye ve yüke göre değiştiği için sayfadaki
"Beklenen Çıktı" bloğu ancak böyle tekrar üretilebilir kalır. Bu blok GNU Octave 11.3.0
ile `octave-cli` üzerinden ölçüldü; bu makinede `octave --no-gui` Qt/cocoa eklentisi
yüzünden betiği yüklemeden düşüyor (EXIT=134).

## Kod

Altı örneğin özeti — tam betik aşağıda:

| # | Döngü | Vektör yolu | Doğrulama |
|---|---|---|---|
| 1 | `for i=1:n, c(i)=a(i)*b(i); end` | `c = a .* b` | `isequal` → 1 |
| 2 | `for i, y(i)=sin(x(i))*exp(-0.1*x(i))` | `y = sin(x).*exp(-0.1*x)` | en büyük fark 0 |
| 3 | `if v(i) < 0, v(i)=0; end` | `v(v < 0) = 0` | `isequal` → 1 |
| 4 | döngüyle kümülatif toplam | `cumsum(u)` | `isequal` → 1 |
| 5 | iç içe iki döngü | `A*xv` (BLAS) | fark 1,9e-14 |
| 6 | `dizi(end+1) = i` | `dizi = zeros(1,N)` | içerik aynı |

Aşağıdaki betik dosyanın tamamıdır (`kod: performans_ve_vektorlestirme.m`):

```octave
clear; clc; close all;

%% 0. Hazirlik: sabit tohum, olcum icin ornek boyu
% Sure olcumu yapilir ama EKRANA YAZILMAZ: islem suresi makineye gore
% degistigi icin "Beklenen Cikti" blogu ancak boyle tekrar uretilebilir kalir.
rand("seed", 42);    % sozdizimi sozlesmesi (Octave 11'de tek basina yetmez)
rand("state", 42);   % ureteci durumu: iki kosuda ayni diziyi veren ayar
randn("state", 42);
n = 200000;
printf("[0] surum: %s, ornek uzunlugu n = %d\n", version(), n);

%% 1. Eleman eleman carpma: for dongusu ile .* karsilastirmasi
a = rand(1, n);
b = rand(1, n);
tic;
c_dongu = zeros(1, n);
for i = 1:n
  c_dongu(i) = a(i) * b(i);
end
t_dongu = toc;
tic;
c_vektor = a .* b;          % BLAS/vektor yolu: tek cagri
t_vektor = toc;
printf("[1] eleman carpma : dongu ve .* ayni sonuc mu: %d\n", ...
       isequal(c_dongu, c_vektor));
printf("[1] kontrol toplami: %.6f\n", sum(c_vektor));
printf("[1] sure           : olculdu, ekrana yazilmadi (makineye gore degisir)\n");

%% 2. Fonksiyon degerlendirme: dongu ile vektorlestirilmis cagri
x = 0:0.001:10;
y_dongu = zeros(size(x));
for i = 1:numel(x)
  y_dongu(i) = sin(x(i)) * exp(-0.1*x(i));
end
y_vektor = sin(x) .* exp(-0.1*x);
printf("[2] fonksiyon     : %d nokta, en buyuk fark %.3e\n", ...
       numel(x), max(abs(y_dongu - y_vektor)));

%% 3. Kosullu islem: mantiksal indeksleme
v = randn(1, 10);
v_dongu = v;
for i = 1:numel(v)
  if v_dongu(i) < 0
    v_dongu(i) = 0;
  end
end
v_vektor = v; v_vektor(v_vektor < 0) = 0;
printf("[3] kosullu       : negatif sayisi %d, iki yontem ayni mi: %d\n", ...
       nnz(v < 0), isequal(v_dongu, v_vektor));

%% 4. Kumulatif toplam: dongu ile cumsum
u = 1:5;
k_dongu = zeros(size(u));
k_dongu(1) = u(1);
for i = 2:numel(u)
  k_dongu(i) = k_dongu(i-1) + u(i);
end
k_vektor = cumsum(u);
printf("[4] cumsum        : dongu %s | cumsum %s | ayni mi: %d\n", ...
       mat2str(k_dongu), mat2str(k_vektor), isequal(k_dongu, k_vektor));

%% 5. Matris-vektor carpimi: uc ic ice dongu yerine tek operator
m = 300;
A = randn(m, m);
xv = randn(m, 1);
tic;
y_dongu2 = zeros(m, 1);
for i = 1:m
  toplam = 0;
  for j = 1:m
    toplam = toplam + A(i, j)*xv(j);
  end
  y_dongu2(i) = toplam;
end
t_matris_dongu = toc;
tic;
y_blas = A*xv;
t_matris = toc;
printf("[5] A*x           : %d x %d, en buyuk fark %.3e\n", ...
       rows(A), columns(A), max(abs(y_dongu2 - y_blas)));
printf("[5] sure          : olculdu, ekrana yazilmadi\n");

%% 6. On bellek ayirma: buyuyen dizi yerine zeros
tic;
buyuyen = [];
for i = 1:20000
  buyuyen(end+1) = i;
end
t_buyuyen = toc;
tic;
on_bellek = zeros(1, 20000);
for i = 1:20000
  on_bellek(i) = i;
end
t_onbellek = toc;
printf("[6] on bellek     : 20000 oge, icerik ayni mi: %d, eleman sayisi %d\n", ...
       isequal(buyuyen, on_bellek), numel(on_bellek));
printf("[6] sure          : olculdu, ekrana yazilmadi\n");

%% Ozet
printf("\nOzet: 6 vektorlestirme ornegi olculdu; tum karsilastirmalarda dongu ile\n");
printf("      vektor yolu AYNI sonucu verdi; sureler olculdu ama yazilmadi.\n");
```

## Beklenen Çıktı

```
[0] surum: 11.3.0, ornek uzunlugu n = 200000
[1] eleman carpma : dongu ve .* ayni sonuc mu: 1
[1] kontrol toplami: 50114.042270
[1] sure           : olculdu, ekrana yazilmadi (makineye gore degisir)
[2] fonksiyon     : 10001 nokta, en buyuk fark 0.000e+00
[3] kosullu       : negatif sayisi 6, iki yontem ayni mi: 1
[4] cumsum        : dongu [1 3 6 10 15] | cumsum [1 3 6 10 15] | ayni mi: 1
[5] A*x           : 300 x 300, en buyuk fark 1.865e-14
[5] sure          : olculdu, ekrana yazilmadi
[6] on bellek     : 20000 oge, icerik ayni mi: 1, eleman sayisi 20000
[6] sure          : olculdu, ekrana yazilmadi

Ozet: 6 vektorlestirme ornegi olculdu; tum karsilastirmalarda dongu ile
      vektor yolu AYNI sonucu verdi; sureler olculdu ama yazilmadi.
```

## Öne Çıkan Noktalar

- Vektörleştirme **sonucu değiştirmez, maliyeti değiştirir**: altı örnekte de iki yol aynı
  sonucu verdi — [1], [3], [4], [6] için `isequal` birebir 1, [2] için en büyük fark 0,
  [5] için 1,9e-14 (yuvarlama). Bu yüzden vektörleştirme güvenli bir dönüşümdür.
- Tek istisna kayan nokta sırasıdır: `A*xv` ile iki iç içe döngü 1,865e-14 fark verdi.
  BLAS toplama sırasını farklı yaptığı için bu beklenen yuvarlama farkıdır; `isequal`
  yerine tolerans (`max(abs(...)) < 1e-12`) kullanılır.
- Mantıksal indeksleme en güçlü tekniktir: `v(v < 0) = 0` tek satırda hem koşulu kurar
  hem seçimi yapar. `a < 0` ifadesi `a` ile aynı boyutta mantıksal vektör döndürür.
- Hazır işlev varsa döngü yazılmaz: `cumsum`, `cumprod`, `sum`, `prod` gibi işlevler
  derlenmiş döngülerdir. Kural: bir işlemi döngüyle yazmayı düşünüyorsanız önce Octave'in
  o işi yapan yerleşik işlevi olup olmadığına bakın.
- Ölçüm disiplini: süreler `tic`/`toc` ile ölçüldü ama **yazılmadı**. Süre yazılsaydı
  sayfadaki çıktı her koşuda değişir, "beklenen çıktı" karşılaştırması anlamsızlaşırdı.
  Hız farkını kendi makinenizde `tic/toc` ekleyerek ölçebilirsiniz.

## Alıştırmalar

1. Birinci örnekteki `n` değerini `2e6` yapın ve iki yolun süresini kendiniz ölçün
   (`tic/toc`). Oran makinenize göre kaç kat çıkıyor? Sonuç yine `isequal` mi?
2. `A*xv` yerine `xv'*A'` yazın; aynı vektörü verip vermediğini `max(abs(...))` ile
   kontrol edin. Transpoze işleminin maliyeti sonucu değiştirir mi?
3. Ön bellek örneğinde `buyuyen` dizisini `zeros` ile 20000 öğe ayırıp **yine de**
   `end+1` ile büyütün; bellek yeniden tahsisinin kaç kez yapıldığını `numel` ve süre
   ölçümüyle kabaca gözlemleyin. Neden `zeros` daha hızlı?
