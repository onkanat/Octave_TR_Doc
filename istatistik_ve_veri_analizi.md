---
layout: default
title: "Octave'de İstatistik ve Veri Analizi: Dağılımlar, t-Testi, CSV"
lang: tr
konu: veri
seviye: orta
tur: ders
kod: istatistik_ve_veri_analizi.m
redirect_from: [/Octave_statistics_data_analysis.html]
---

# Octave'de İstatistik ve Veri Analizi: Dağılımlar, t-Testi, CSV

Bu not; normal dağılımdan örneklem üretmeyi, yoğunluk (PDF) ve birikimli dağılım (CDF)
fonksiyonlarını, iki örneklemli t-testini ve CSV dosyasından okunan verinin sütun
istatistiklerini tek betikte toplar. Sayfadaki çıktı bloğu betiğin **ölçülmüş** koşusundan
alınmıştır; p değeri `betainc` ile hesaplanır, `ttest2` paketine ihtiyaç yoktur.

## Ne öğreneceksiniz

- `randn` ile normal dağılımdan örneklem üretmeyi ve `mean`/`std` ile betimsel istatistiği
- `normpdf`/`normcdf` karşılığını çekirdek işlevlerle yazmayı (`exp`, `erf`)
- İki örneklemli t-testini (havuzlanmış varyans) kurmayı ve iki yönlü p değerini `betainc`
  ile hesaplamayı; kararı anlamlılık düzeyi `α = 0,05` ile vermeyi
- `csvwrite`/`csvread` ile CSV dosyasına yazıp geri okumayı, `mean`/`std`/`median` ve
  `polyfit`/`corr` ile sütun analizini
- Anlamlı ve anlamsız iki karşılaştırmayı yan yana görüp p değerinin nasıl okunacağını

## Çalıştırma

```sh
octave --no-gui istatistik_ve_veri_analizi.m
```

Betik reponun kökünde ve tek başına koşar; **paket yüklemez**. `statistics` paketindeki
`normrnd`, `normpdf`, `normcdf` ve `ttest2` bu makinede kurulu değil (ölçüldü:
`which("ttest2")` boş), bu yüzden aynı sonuçlar çekirdek `randn`, `erf` ve `betainc` ile
üretildi. CSV dosyası repo içine değil sistemin geçici dizinine yazılır (`tempdir()`).
Sayfadaki blok GNU Octave 11.3.0 ile `octave-cli` üzerinden ölçüldü; bu makinede
`octave --no-gui` Qt/cocoa eklentisi yüzünden betiği yüklemeden düşüyor (EXIT=134).

## Kod

`statistics` paketi işlevi ↔ bu betikteki karşılığı:

| Paket işlevi | Bu betikte | Not |
|---|---|---|
| `normrnd(mu, sigma, [1 n])` | `mu + sigma*randn(1, n)` | Aynı dağılım; tohum `randn("state", 42)` ile sabit |
| `normpdf(x, mu, sigma)` | `exp(-(x-mu).^2/(2*sigma^2))/(sigma*sqrt(2*pi))` | Kapalı biçim |
| `normcdf(x, mu, sigma)` | `0.5*(1 + erf((x-mu)/(sigma*sqrt(2))))` | `erf` çekirdekte var |
| `ttest2(A, B)` | havuzlanmış varyans + `betainc` | `p = betainc(df/(df+t^2), df/2, 1/2)` |
| `poissrnd/poisspdf/binornd/binopdf` | — | Poisson/binom için `statistics` paketi gerekir |

Aşağıdaki betik dosyanın tamamıdır (`kod: istatistik_ve_veri_analizi.m`):

```octave
clear; clc; close all;

%% 0. Hazirlik: cekirdek islevler, tekrar uretilebilir orneklem
% statistics paketindeki normrnd/normpdf/normcdf/ttest2 bu makinede kurulu degil;
% ayni sonuclar cekirdek randn, erf ve betainc ile hesaplanir.
rand("seed", 42);
randn("state", 42);
printf("[0] surum: %s, ttest2 paketle mi geliyor: %d\n", version(), ...
       ~isempty(which("ttest2")));

%% 1. Normal dagilimdan orneklem ve betimsel istatistik
mu = 0; sigma = 1; n = 1000;
ornek = mu + sigma*randn(1, n);
printf("[1] orneklem      : n = %d, ortalama = %.4f, std = %.4f\n", ...
       n, mean(ornek), std(ornek));
printf("[1] kuramsal      : ortalama = %.1f, std = %.1f (orneklem hatasi ~%.4f)\n", ...
       mu, sigma, sigma/sqrt(n));

%% 2. PDF ve CDF: normpdf/normcdf karsiligi
normal_pdf = @(x) exp(-(x - mu).^2/(2*sigma^2)) / (sigma*sqrt(2*pi));
normal_cdf = @(x) 0.5*(1 + erf((x - mu)/(sigma*sqrt(2))));
printf("[2] pdf(0)        : %.6f (kuramsal %.6f)\n", normal_pdf(0), 1/sqrt(2*pi));
printf("[2] pdf(1)        : %.6f\n", normal_pdf(1));
printf("[2] cdf(0)        : %.6f\n", normal_cdf(0));
printf("[2] cdf(1.96)     : %.6f (kuramsal 0.975)\n", normal_cdf(1.96));
printf("[2] orneklem payi : |x| < 1 icinde %.1f%% (kuramsal 68.3%%)\n", ...
       100*mean(abs(ornek) < 1));

%% 3. Iki orneklemli t-testi: ttest2 karsiligi (havuzlanmis varyans)
grup_A = [82, 88, 75, 91, 85, 79, 94];
grup_B = [76, 82, 70, 78, 80, 85, 73];
nA = numel(grup_A); nB = numel(grup_B);
ortA = mean(grup_A); ortB = mean(grup_B);
varA = var(grup_A);  varB = var(grup_B);
df = nA + nB - 2;
havuz_var = ((nA-1)*varA + (nB-1)*varB) / df;
t_ist = (ortA - ortB) / sqrt(havuz_var*(1/nA + 1/nB));
% Iki yonlu p degeri: t dagiliminin kuyrugu (betainc ile, tcdf karsiligi)
p_deger = betainc(df/(df + t_ist^2), df/2, 0.5);
printf("[3] grup A        : ortalama %.4f, varyans %.4f (n = %d)\n", ortA, varA, nA);
printf("[3] grup B        : ortalama %.4f, varyans %.4f (n = %d)\n", ortB, varB, nB);
printf("[3] t = %.4f, df = %d, p = %.6f\n", t_ist, df, p_deger);
if p_deger < 0.05
  printf("[3] karar         : H0 reddedildi (p < 0.05) - ortalamalar farkli\n");
else
  printf("[3] karar         : H0 reddedilemedi (p >= 0.05)\n");
end

%% 4. CSV dosyasindan veri okuma ve sutun istatistikleri
gecici = tempdir();
csv_yolu = fullfile(gecici, "veri.csv");
veri_matris = [1.2, 5.5; 2.1, 6.1; 3.0, 7.2; 4.5, 8.9; 5.8, 10.5];
csvwrite(csv_yolu, veri_matris);
veri = csvread(csv_yolu);
x = veri(:, 1); y = veri(:, 2);
printf("[4] CSV           : %d satir, %d sutun (%s)\n", ...
       rows(veri), columns(veri), "tempdir/veri.csv");
printf("[4] y sutunu      : ortalama %.4f, std %.4f, medyan %.2f\n", ...
       mean(y), std(y), median(y));
katsayi = polyfit(x, y, 1);
printf("[4] dogrusal uyum : y = %.4f*x + %.4f, r = %.4f\n", ...
       katsayi(1), katsayi(2), corr(x, y));

%% 5. Ikinci orneklemle karsilastirma: fark yoksa p buyuk cikar
grup_C = [80, 84, 78, 86, 82, 83, 81];   % A'ya yakin ama farkli bir grup
t_C = (mean(grup_A) - mean(grup_C)) / ...
      sqrt(((nA-1)*var(grup_A) + (nB-1)*var(grup_C))/df * (1/nA + 1/nB));
p_C = betainc(df/(df + t_C^2), df/2, 0.5);
printf("[5] A vs C        : ortalama farki %.2f, t = %.4f, p = %.6f\n", ...
       mean(grup_A) - mean(grup_C), t_C, p_C);
if p_C < 0.05
  printf("[5] karar         : H0 reddedildi\n");
else
  printf("[5] karar         : H0 reddedilemedi - anlamli fark yok\n");
end

%% Ozet
printf("\nOzet: orneklem/PDF/CDF, iki orneklemli t-testi (betainc ile p) ve CSV\n");
printf("      sutun istatistikleri ayni betikte olculdu; A vs B p = %.4f.\n", p_deger);
```

## Beklenen Çıktı

```
[0] surum: 11.3.0, ttest2 paketle mi geliyor: 0
[1] orneklem      : n = 1000, ortalama = 0.0044, std = 0.9702
[1] kuramsal      : ortalama = 0.0, std = 1.0 (orneklem hatasi ~0.0316)
[2] pdf(0)        : 0.398942 (kuramsal 0.398942)
[2] pdf(1)        : 0.241971
[2] cdf(0)        : 0.500000
[2] cdf(1.96)     : 0.975002 (kuramsal 0.975)
[2] orneklem payi : |x| < 1 icinde 70.3% (kuramsal 68.3%)
[3] grup A        : ortalama 84.8571, varyans 45.1429 (n = 7)
[3] grup B        : ortalama 77.7143, varyans 26.9048 (n = 7)
[3] t = 2.2264, df = 12, p = 0.045904
[3] karar         : H0 reddedildi (p < 0.05) - ortalamalar farkli
[4] CSV           : 5 satir, 2 sutun (tempdir/veri.csv)
[4] y sutunu      : ortalama 7.6400, std 2.0562, medyan 7.20
[4] dogrusal uyum : y = 1.1107*x + 3.9526, r = 0.9970
[5] A vs C        : ortalama farki 2.86, t = 1.0468, p = 0.315798
[5] karar         : H0 reddedilemedi - anlamli fark yok

Ozet: orneklem/PDF/CDF, iki orneklemli t-testi (betainc ile p) ve CSV
      sutun istatistikleri ayni betikte olculdu; A vs B p = 0.0459.
```

## Öne Çıkan Noktalar

- PDF ve CDF kapalı biçimde yazılabilir: `pdf(0) = 1/√(2π) = 0,398942` çıktıda birebir
  tuttu, `cdf(1,96) = 0,975002` ile kuramsal %95 güven sınırı doğrulandı. `erf` bu yüzden
  `normcdf` yerine yeter.
- Örneklem hatası `σ/√n = 1/√1000 ≈ 0,0316`; 1000 örnekle bulunan ortalama 0,0044 ve
  standart sapma 0,9702 bu bant içinde. Örneklem payı %70,3 (kuramsal %68,3) da aynı
  büyüklük mertebesindedir — tek örneklemde %2 sapma normaldir.
- t-testinde p değeri iki yönlüdür: `p = betainc(df/(df+t²), df/2, 1/2)`. A ile B
  gruplarında `t = 2,2264`, `df = 12`, `p = 0,0459` → `p < 0,05`, H0 reddedilir. A ile C
  gruplarında `t = 1,0468`, `p = 0,3158` → fark anlamlı değil. Aynı betik iki kararı yan
  yana gösterir.
- Varyanslar eşit kabul edilmiştir (havuzlanmış). Varyansların belirgin farklı olduğu
  durumda Welch düzeltmesi (serbestlik derecesi Satterthwaite ile) gerekir; `ttest2`
  bunu `Vartype` seçeneğiyle yapar.
- `csvwrite` sayıları varsayılan duyarlıkla yazar; `csvread` geri okurken tam sayı
  biçimini korur. `polyfit` + `corr` ile `r = 0,9970` çıktı: beş nokta neredeyse tam
  doğrusal, dolayısıyla korelasyon tek başına nedensellik kanıtı değildir.

## Alıştırmalar

1. Örneklem sayısını `n = 100` ve `n = 10000` yapın: ortalama, standart sapma ve
   `|x| < 1` payı kuramsal değerlere yaklaşıyor mu? `σ/√n` ile karşılaştırın.
2. A grubuna bir aykırı not ekleyin (`grup_A(end+1) = 100`): t ve p nasıl değişiyor?
   Aykırı değer **varyansı** nasıl büyütüyor?
3. Aynı veriye `p = 2*(1 - tcdf(...))` yazmayı deneyin; `tcdf` yoksa p değerini
   `betainc(df/(df+t^2), df/2, 1/2)` ile üretip iki formülün aynı sonucu verdiğini
   gösterin. `df = 1` özel durumunda p değeri neden `2*atan` biçimine indirgenir?
