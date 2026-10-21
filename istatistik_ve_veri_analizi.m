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
