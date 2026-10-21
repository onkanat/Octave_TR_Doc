---
layout: default
title: "Octave'de Temel Matris İşlemleri"
lang: tr
konu: matris
seviye: baslangic
tur: ders
kod: temel_matris.m
redirect_from: [/Octave_temel_matris.html]
---

# Octave'de Temel Matris İşlemleri

Octave'in asıl gücü matrislerle çalışmasıdır: bir matrisi üretmek, boyutunu sorgulamak, parçalara
ayırmak ve lineer cebir işlemine sokmak tek satırlık işlerdir. Bu nottaki her örnek tek betikte
toplandı ve çıktısı ölçüldü.

## Ne öğreneceksiniz

- `zeros`, `ones`, `eye`, `magic` ile matris üretmeyi
- `size` ve `reshape` ile boyut/şekil işlemlerini
- `transpose`, `diag`, `tril`, `triu` ile matris parçalarını
- `inv`, `det`, `eig`, `svd` ile lineer cebir işlemlerini
- `A(i,j)`, mantıksal indeks ve `find` ile eleman seçmeyi, `A\b` ile denklem çözmeyi

## Çalıştırma

```sh
octave --no-gui temel_matris.m
```

Betik tek başına koşar. Başsız oturumda `octave --no-gui --no-window-system` ya da `octave-cli`
aynı çıktıyı verir; ölçüm GNU Octave 11.3.0 ile yapıldı.

## Kod

Eski notta `rand` ile üretilen örnek matrislerin değerleri metne sabit yazılmıştı; okurun koşusunda
bu değerler tutmuyordu. Burada betik `rand("seed", 42)` ile başlıyor, dolayısıyla ölçülen çıktı
yeniden üretilebilir.

```octave
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
```

## Beklenen Çıktı

Aşağıdaki blok, yukarıdaki betiğin `octave --no-gui` koşusundan **birebir** alınmıştır.

```text
zeros(3,2) : 3 x 2
ones(4,5)  : 4 x 5
eye(5)     : 5 x 5, iz = 5

size(magic(3))    : 3 3
   8   1   6
   3   5   7
   4   9   2
reshape(1:9,3,3) =
   1   4   7
   2   5   8
   3   6   9
F boyutu          : 2 x 3
transpose(F) boyutu: 3 x 2
diag([1 2 3 4 5]) izi: 15
tril(magic(5)) alt ucgensel mi : 1
triu(magic(5)) ust ucgensel mi : 1
tril + triu - diag = magic(5)  : 1

inv([1 2; 3 4]) =
  -2.0000   1.0000
   1.5000  -0.5000
det([1 2; 3 4])     : -2
eig: ozdegerler (kosegen) : [-0.3723 5.372]
     A*V - V*D artigi      : 4.44e-16
svd: tekil degerler        : [17.41 0.8752 0.1969]
     N - U*S*V' artigi     : 8.13e-15

P(2,3)        : 60
P(:, 1)       : [10 40 70]
P(1, :)       : [10 20 30]
P > 50 sayisi : 4
find(P > 50)  : [3 6 8 9]

inv(A)*b : [-4 5]
A \ b    : [-4 5]
A*x - b artigi: 0.00e+00

Ozet: 3 olusturma, 2 sekillendirme, 3 ucgensel/kosegen, 4 lineer cebir,
      4 indeksleme ve 1 denklem sistemi ornegi calistirildi.
```

## Öne Çıkan Noktalar

- `reshape(1:9, 3, 3)` matrisi **sütun sırasıyla** doldurur: ilk satır `1 4 7` olur (ölçüldü). Satır
  sırasıyla doldurmak için `reshape(...)'` ya da `reshape(1:9, 3, 3)'` gerekir.
- `tril(M) + triu(M) - diag(diag(M))` yeniden `M` verir; `magic(5)` üzerinde ölçüm `1` (doğru).
- `eig` özvektörleri normalize eder ama simetrik olmayan matriste bunlar dik değildir; bu yüzden
  `V'*V` birim matris çıkmaz. Doğru kontrol artıktır: `norm(A*V - V*D)` → `4.44e-16` (ölçüldü).
- `svd` üç çıktı verir (`U, S, V`); tekiller `diag(S)` ile okunur. Bu notta ilk sürümde `U` yanlışlıkla
  `S` sanıldığı için tekiller eksi görünmüştü — ölçüm bunu yakaladı.
- `inv(A)*b` ile `A\b` aynı çözümü verir (`[-4 5]`); artık `0.00e+00`, yani sistem tam tutarlı.

## Alıştırmalar

1. `hilb(5)` ile 5×5 Hilbert matrisi kurun; `det`, `cond`, `rank` değerlerini yazdırın ve kötü koşullanmayı yorumlayın.
2. `reshape(1:9, 3, 3)` ile `reshape(1:9, 3, 3)'` çıktılarını karşılaştırın; hangisinin "satır satır" olduğunu belirleyin.
3. `P(P > 50)` mantıksal indeksini `find(P > 50)` sonucuyla karşılaştırın; iki yolun verdiği eleman sayısını doğrulayın.
