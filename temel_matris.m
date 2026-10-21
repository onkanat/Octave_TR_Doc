clear; clc; close all;
rand("seed", 42);   % rand ile üretilen örnekler tekrarlanabilir olsun

%% 1. Matris oluşturma
A = zeros(3, 2);
B = ones(4, 5);
C = eye(5);

printf("zeros(3,2) : %d x %d\n", rows(A), columns(A));
printf("ones(4,5)  : %d x %d\n", rows(B), columns(B));
printf("eye(5)     : %d x %d, iz = %d\n", rows(C), columns(C), trace(C));

%% 2. Matris boyutu ve şekillendirme
D = magic(3);
printf("\nsize(magic(3))    : %d %d\n", size(D, 1), size(D, 2));
disp(D)

E = reshape(1:9, 3, 3);
printf("reshape(1:9,3,3) =\n"); disp(E)

%% 3. Transpoz, köşegen, üçgensel parçalar
F = [1, 2, 3; 4, 5, 6];
printf("F boyutu          : %d x %d\n", rows(F), columns(F));
printf("transpose(F) boyutu: %d x %d\n", rows(F'), columns(F'));

H = diag([1, 2, 3, 4, 5]);
printf("diag([1 2 3 4 5]) izi: %d\n", trace(H));

M = magic(5);
L = tril(M);
U = triu(M);
printf("tril(magic(5)) alt ucgensel mi : %d\n", all(all(L == tril(L))));
printf("triu(magic(5)) ust ucgensel mi : %d\n", all(all(U == triu(U))));
printf("tril + triu - diag = magic(5)  : %d\n", isequal(L + U - diag(diag(M)), M));

%% 4. Lineer cebir işlemleri
K = [1, 2; 3, 4];
printf("\ninv([1 2; 3 4]) =\n"); disp(inv(K))
printf("det([1 2; 3 4])     : %g\n", det(K));

Mx = [1, 2; 3, 4];
[V, Dd] = eig(Mx);
printf("eig: ozdegerler (kosegen) : %s\n", mat2str(diag(Dd)', 4));
printf("     A*V - V*D artigi      : %.2e\n", norm(Mx * V - V * Dd));

N = [1, 2, 3; 4, 5, 6; 7, 8, 10];
[Usvd, Ssvd, Vsvd] = svd(N);
printf("svd: tekil degerler        : %s\n", mat2str(diag(Ssvd)', 4));
printf("     N - U*S*V' artigi     : %.2e\n", norm(N - Usvd * Ssvd * Vsvd'));

%% 5. Eleman erişimi, mantıksal indeksleme, find
P = [10, 20, 30; 40, 50, 60; 70, 80, 90];
printf("\nP(2,3)        : %d\n", P(2, 3));
printf("P(:, 1)       : %s\n", mat2str(P(:, 1)'));
printf("P(1, :)       : %s\n", mat2str(P(1, :)));
printf("P > 50 sayisi : %d\n", numel(find(P > 50)));
printf("find(P > 50)  : %s\n", mat2str(find(P > 50)'));

%% 6. Lineer denklem sistemi
% A*x = b sistemini ters almadan çözmek tercih edilir.
A2 = [2, 3; 4, 5];
b2 = [7; 9];
x_ters  = inv(A2) * b2;
x_bolme = A2 \ b2;
printf("\ninv(A)*b : %s\n", mat2str(x_ters', 6));
printf("A \\ b    : %s\n", mat2str(x_bolme', 6));
printf("A*x - b artigi: %.2e\n", norm(A2 * x_bolme - b2));

%% Özet
printf("\nOzet: 3 olusturma, 2 sekillendirme, 3 ucgensel/kosegen, 4 lineer cebir,\n");
printf("      4 indeksleme ve 1 denklem sistemi ornegi calistirildi.\n");
