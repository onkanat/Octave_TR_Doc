clear; clc; close all;
rand("seed", 42);

%% 1. Temel fonksiyonlar: det, eig, inv
A = [1, 2; 3, 4];
printf("det([1 2; 3 4])      : %g\n", det(A));

B = [4, -2; 1, 1];
lambda = eig(B);
printf("eig([4 -2; 1 1])     : %s  (karmasik eslenik cift)\n", mat2str(lambda', 4));

[V, L] = eig(B);
printf("A = V*L*inv(V) artigi: %.2e\n", norm(B - V * L * inv(V)));

C = [2, 1; 1, 1];
printf("inv([2 1; 1 1])      :\n"); disp(inv(C))

%% 2. Bölme operatörleri
% A\B -> A*X = B ; A/B -> X*B = A  (ters almadan, daha dogru ve hizli)
M = [2, 1; 1, 3];
b = [1; 2];
X = M \ b;
printf("M \\ b                : %s  (M*X = b)\n", mat2str(X', 6));
printf("artik norm(M*X - b)  : %.2e\n", norm(M * X - b));
Y = b' / M;
printf("b' / M               : %s  (Y*M = b')\n", mat2str(Y, 6));

%% 3. Norm, rank, iz
v = [3, 4];
printf("\nnorm([3 4])          : %g   (2-norm)\n", norm(v));
printf("norm([3 4], 1)       : %g   (1-norm)\n", norm(v, 1));
printf("norm([3 4], inf)     : %g   (infinity norm)\n", norm(v, inf));

T = [1, 2, 3; 4, 5, 6; 7, 8, 9];
printf("rank([1 2 3; 4 5 6; 7 8 9]) : %d  (3. satir ilk ikisinin kombinasyonu)\n", rank(T));
printf("trace ayni matris    : %d  (1 + 5 + 9)\n", trace(T));

%% 4. Matris fonksiyonları
R90 = [0, 1; -1, 0];
printf("\nexpm([0 1; -1 0])    :\n"); disp(expm(R90))
printf("logm(expm(R90)) artigi : %.2e\n", norm(logm(expm(R90)) - R90));
printf("sqrtm([4 0; 0 9])    :\n"); disp(sqrtm([4, 0; 0, 9]))

%% 5. Faktörizasyonlar
P = [4, 2; 2, 3];
R = chol(P);                     % R'*R = P
printf("\nchol: R'*R - P artigi : %.2e\n", norm(R' * R - P));

Q = [2, 1, 1; 4, 3, 3; 8, 7, 9];
[Llu, Ulu] = lu(Q);
printf("lu  : L*U - Q artigi  : %.2e\n", norm(Llu * Ulu - Q));

Z = [1, 2; 3, 4; 5, 6];
[Qqr, Rqr] = qr(Z);
printf("qr  : Q*R - Z artigi  : %.2e,  Q'*Q birime yakin: %.2e\n", ...
       norm(Qqr * Rqr - Z), norm(Qqr' * Qqr - eye(size(Qqr, 2))));

%% 6. Koşul sayısı ve tekil değerler
K = [1, 2, 3; 4, 5, 6; 7, 8, 9];
[Usvd, Ssvd, Vsvd] = svd(K);
printf("\ntekil degerler        : %s\n", mat2str(diag(Ssvd)', 4));
printf("koşul sayısı cond(K)  : %.2e  (buyuk = kotu kosullanmis)\n", cond(K));

%% 7. Uygulama: lineer denklem sistemi
As = [2, 1, -1; -3, -1, 2; -2, 1, 2];
bs = [8; -11; -3];
xs = As \ bs;
printf("\nAs*x = bs cozumu      : %s\n", mat2str(xs', 6));
printf("kontrol norm(As*x-bs) : %.2e\n", norm(As * xs - bs));

%% 8. Uygulama: özdeğer analizi (simetrik matris)
S = [6, 2, 1; 2, 3, 1; 1, 1, 1];
[Vs, Ls] = eig(S);
[d, ind] = sort(diag(Ls), "descend");
printf("\nen buyuk ozdeger      : %.4f\n", d(1));
printf("ozdegerler (buyukten) : %s\n", mat2str(d', 4));
printf("ozvektor Mat. kosegen : %d\n", isequal(size(Vs), [3, 3]));

%% 9. Uygulama: Kirchhoff (iki döngülü devre)
R1 = 2; R2 = 5; R3 = 3; Vk = 10;
Ak = [R1 + R2, -R2; -R2, R2 + R3];
bk = [Vk; 0];
I = Ak \ bk;
printf("\nDongu 1 akimi (I1)    : %.2f A\n", I(1));
printf("Dongu 2 akimi (I2)    : %.2f A\n", I(2));
printf("R2 uzerindeki gerilim : %.2f V\n", R2 * (I(1) - I(2)));

%% 10. Uygulama: kafes kiriş düğüm dengesi
At = [cosd(45), 1; sind(45), 0];
Ft = [0; 1000];
Tt = At \ Ft;
printf("\nCubuk 1 gerilmesi     : %.2f N\n", Tt(1));
printf("Cubuk 2 gerilmesi     : %.2f N\n", Tt(2));

%% 11. Uygulama: Markov zinciri (hava durumu)
Pm = [0.9, 0.5; 0.1, 0.5];
x0 = [1; 0];
x1 = Pm * x0;
printf("\n1 gun sonra gunesli   : %.2f\n", x1(1));
printf("1 gun sonra bulutlu   : %.2f\n", x1(2));
x7 = Pm^7 * x0;
printf("7 gun sonra gunesli   : %.2f\n", x7(1));
[Ve, Le] = eig(Pm);
[~, idx] = min(abs(diag(Le) - 1));
kararli = Ve(:, idx) / sum(Ve(:, idx));
printf("kararli durum gunesli : %.2f\n", kararli(1));
printf("kararli durum bulutlu : %.2f\n", kararli(2));

%% Özet
printf("\nOzet: 11 bolumde 20+ lineer cebir fonksiyonu ve 5 uygulama olculdu.\n");
printf("      En buyuk ozdeger %.4f, I1 = %.2f A, kararli gunesli = %.2f.\n", ...
       d(1), I(1), kararli(1));
