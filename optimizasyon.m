clear; clc; close all;

%% 0. Hazirlik: yalniz cekirdek islevler (optim paketi gerekmez)
% optim paketindeki fminunc/sqp bu makinede kurulu degil; ayni isi cekirdek
% fminsearch (Nelder-Mead, turev gerektirmez), fminbnd ve fsolve yapar.
printf("[0] surum: %s, fminsearch var mi: %d\n", version(), exist("fminsearch"));

%% 1. Rosenbrock: kisitlamasiz minimizasyon
rosenbrock = @(x) (1 - x(1))^2 + 100*(x(2) - x(1)^2)^2;
x0 = [-1.2, 2];
secenek = optimset("TolX", 1e-10, "TolFun", 1e-10, "MaxIter", 2000);
[x_min, fval, exitflag, cikti] = fminsearch(rosenbrock, x0, secenek);
printf("[1] Rosenbrock  : baslangic [%.1f %.1f], %d yineleme, %d fonksiyon cagrisi\n", ...
       x0(1), x0(2), cikti.iterations, cikti.funcCount);
printf("[1] minimum nokta: [%.6f %.6f], f = %.3e, exitflag = %d\n", ...
       x_min(1), x_min(2), fval, exitflag);

%% 2. Tek degiskenli minimizasyon: fminbnd ile sinirli arama
hedef1 = @(x) (x - 2).^2 + 1;
[xb, fb, bayrak] = fminbnd(hedef1, 0, 5);
printf("[2] fminbnd      : (x-2)^2 + 1 -> x = %.6f, f = %.6f, exitflag = %d\n", ...
       xb, fb, bayrak);

%% 3. Egri uydurma: ustel model C(t) = C0*exp(-k*t)
t_veri = [0, 1, 2, 3, 4, 5, 6];
C_veri = [1.0, 0.6, 0.35, 0.2, 0.1, 0.05, 0.02];
model  = @(p, t) p(1)*exp(-p(2)*t);
% 3a. Dogrusal en kucuk kareler: log(C) = log(C0) - k*t
katsayi = polyfit(t_veri, log(C_veri), 1);
k_dogrusal = -katsayi(1);
C0_dogrusal = exp(katsayi(2));
hata_dogrusal = sum((model([C0_dogrusal, k_dogrusal], t_veri) - C_veri).^2);
printf("[3] dogrusal fit : C0 = %.4f, k = %.4f, SSE = %.3e\n", ...
       C0_dogrusal, k_dogrusal, hata_dogrusal);
% 3b. Dogrusal olmayan en kucuk kareler: kareler toplamini dogrudan azalt
amac = @(p) sum((model(p, t_veri) - C_veri).^2);
[p_en, sse_en, bayrak_en] = fminsearch(amac, [1.0, 0.5], secenek);
printf("[3] dogrusal olmayan: C0 = %.4f, k = %.4f, SSE = %.6f, exitflag = %d\n", ...
       p_en(1), p_en(2), sse_en, bayrak_en);
printf("[3] karsilastirma: SSE %.3e -> %.6f (%.1f kat kucuk)\n", ...
       hata_dogrusal, sse_en, hata_dogrusal/sse_en);

%% 4. Cok degiskenli dogrusal sistem: fsolve
sistem = @(v) [v(1)^2 + v(2)^2 - 25; v(1) - v(2) - 1];
[v, fval_v, bilgi] = fsolve(sistem, [4, 3]);
printf("[4] fsolve        : x^2+y^2 = 25, x-y = 1 -> [%.6f %.6f]\n", v(1), v(2));
printf("[4] kalinti        : %.3e, bilgi = %d\n", norm(fval_v), bilgi);

%% 5. Baslangic noktasinin onemi: ayni rosenbrock, uzak baslangic
[x_uzak, f_uzak] = fminsearch(rosenbrock, [-3, -4], secenek);
printf("[5] uzak baslangic: [%.4f %.4f], f = %.3e\n", x_uzak(1), x_uzak(2), f_uzak);

%% Ozet
printf("\nOzet: fminsearch (Rosenbrock + egri uydurma), fminbnd ve fsolve ile 4\n");
printf("      optimizasyon problemi ayni betikte olculdu; en iyi ustel model\n");
printf("      C(t) = %.4f*exp(-%.4f*t), SSE = %.6f.\n", p_en(1), p_en(2), sse_en);
