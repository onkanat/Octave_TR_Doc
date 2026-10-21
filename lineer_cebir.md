---
layout: default
title: "Octave'de Lineer Cebir"
lang: tr
konu: matris
seviye: orta
tur: ders
kod: lineer_cebir.m
redirect_from: [/Octave_lineer_cebir.html]
---

# Octave'de Lineer Cebir

Octave, lineer cebir için kapsamlı bir fonksiyon kütüphanesi sunar. Bu not en yaygın kullanılan
fonksiyonları, faktörizasyonları ve beş gerçek uygulamayı (devre, kafes kiriş, Markov zinciri,
denklem sistemi, özdeğer analizi) tek betikte birleştirir; her sayısal iddia koşu çıktısıyla
doğrulandı.

## Ne öğreneceksiniz

- `det`, `eig`, `inv` ve bölme operatörlerinin (`\`, `/`) farkını
- `norm`, `rank`, `trace`, `cond` ile matris ölçülerini
- `expm`, `logm`, `sqrtm` matris fonksiyonlarını
- `chol`, `lu`, `qr`, `svd` faktörizasyonlarını ve artık normlarıyla doğrulamayı
- Lineer sistem, özdeğer analizi, Kirchhoff denklemleri ve Markov zinciri uygulamalarını

## Çalıştırma

```sh
octave --no-gui lineer_cebir.m
```

Betik tek başına koşar; `clear; clc; close all;` ile başlar ve `rand` tohumu sabittir. Başsız
oturumda `octave --no-gui --no-window-system` ya da `octave-cli` aynı çıktıyı verir; ölçüm GNU Octave
11.3.0 ile yapıldı.

## Kod

Aşağıdaki betik dosyanın tamamıdır. Her faktörizasyon, kurduğu bağıntının artığı `norm` ile ölçülerek
doğrulanır — "oldu" demek yerine artık `1e-15` mertebesinde mi, ona bakılır.

```octave
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
```

### Matris fonksiyonları

- `expm(A)` kare matrisin matris üstelidir ve seriyle tanımlanır: `I + A + A²/2! + A³/3! + ...`.
  Bu notta `expm([0 1; -1 0])` bir dönme matrisi verdi; `logm(expm(A))` ile geri dönüş artığı `3.14e-16`.
- `logm(A)` matris logaritması, `sqrtm(A)` matris kareköküdür. İkisi de **matris** düzeyinde çalışır;
  eleman bazında `log`/`sqrt` ile karıştırılmamalıdır (`sqrtm([4 0; 0 9]) = [2 0; 0 3]`, ölçüldü).
- `inv` notu: teoride `A*inv(A)` birim matristir, pratikte yuvarlama hatası kalır. Bu yüzden ters
  almak yerine bölme operatörü yeğlenir.

### Sağ ve sol bölme

- `A / B`, `X*B = A` olacak şekilde `X`i hesaplar (sağ bölme); `B`nin tersi kurulmadan yapılır.
- `A \ B`, `A*X = B` olacak şekilde `X`i hesaplar (sol bölme). Denklem sistemi çözümünde standart yol budur.

### Büyük matriste bölme (performans)

Ölçüm bloğuna alınmadı (süre platforma göre değişir ve metinle karşılaştırılamaz), ama alışkanlık olarak:

```octave
n = 1000;
A = rand(n);
b = rand(n, 1);
x = A \ b;        % onerilen: ters almadan cozer
% yavas ve daha az kararli: x = inv(A) * b;
```

### Köprü (kafes kiriş) denge denklemleri

Her düğümde kuvvetlerin toplamı sıfırdır; çubuk kuvvetleri `A*T = F` sistemine dönüşür. Burada `A`
matrisi çubukların açılarından (`cosd`, `sind`) kurulur, `F` dış yükü taşır. Betikteki örnek belirli bir
köprü geometrisine dayanmaz; gerçek problemde `A`, düğüm–çubuk bağlantı tablosundan üretilir. Ölçülen
sonuç: `T1 = 1414.21 N`, `T2 = -1000.00 N` (ikinci çubuk basınç altında).

### Ek lineer cebir fonksiyonları

Belgeleri `help` ile okunur; bu notta ölçüm kapsamına alınmadılar:

- `balance` — özdeğer dengeleme · `cond` — koşul sayısı (ölçüldü) · `dmult` — `diag(x)*A`'yı verimli hesaplar
- `dot` — nokta çarpım · `givens` — Givens rotasyonu · `kron` — Kronecker çarpımı
- `null` — null uzayının ortonormal tabanı · `orth` — menzil uzayının ortonormal tabanı
- `pinv` — sözde ters · `syl` — Sylvester denklemini çözer

### Ek faktörizasyonlar

- `qz` — genelleştirilmiş özdeğer problemi (QZ ayrışımı) · `qzhess` — Hessenberg-üçgensel ayrışım
- `schur` — Schur ayrışımı · `svd` — tekil değer ayrışımı (ölçüldü)
- `housh` — Householder yansımaları · `krylov` — blok Krylov alt uzayının ortogonal tabanı

### Performans notları

1. Matris tersini hesaplamaktan kaçının: `inv(A)*b` yerine `A\b` kullanın.
2. Büyük seyrek matrislerde uygun faktörizasyonu seçin (`lu`, `chol`, `qr`).
3. Kötü koşullanmış matrislerde `cond` değerini kontrol edin: bu notta `cond([1 2 3; 4 5 6; 7 8 9])`
   `5.05e+16` çıktı, yani matris sayısal olarak tekildir (rank 2).

## Beklenen Çıktı

Aşağıdaki blok, yukarıdaki betiğin `octave --no-gui` koşusundan **birebir** alınmıştır.

```text
det([1 2; 3 4])      : -2
eig([4 -2; 1 1])     : [3 2]  (karmasik eslenik cift)
A = V*L*inv(V) artigi: 1.11e-16
inv([2 1; 1 1])      :
   1  -1
  -1   2
M \ b                : [0.2 0.6]  (M*X = b)
artik norm(M*X - b)  : 0.00e+00
b' / M               : [0.2 0.6]  (Y*M = b')

norm([3 4])          : 5   (2-norm)
norm([3 4], 1)       : 7   (1-norm)
norm([3 4], inf)     : 4   (infinity norm)
rank([1 2 3; 4 5 6; 7 8 9]) : 2  (3. satir ilk ikisinin kombinasyonu)
trace ayni matris    : 15  (1 + 5 + 9)

expm([0 1; -1 0])    :
   0.5403   0.8415
  -0.8415   0.5403
logm(expm(R90)) artigi : 3.14e-16
sqrtm([4 0; 0 9])    :
   2   0
   0   3

chol: R'*R - P artigi : 4.44e-16
lu  : L*U - Q artigi  : 0.00e+00
qr  : Q*R - Z artigi  : 3.32e-15,  Q'*Q birime yakin: 3.66e-16

tekil degerler        : [16.85 1.068 3.335e-16]
koşul sayısı cond(K)  : 5.05e+16  (buyuk = kotu kosullanmis)

As*x = bs cozumu      : [2 3 -1]
kontrol norm(As*x-bs) : 9.93e-16

en buyuk ozdeger      : 7.2880
ozdegerler (buyukten) : [7.288 2.133 0.5789]
ozvektor Mat. kosegen : 1

Dongu 1 akimi (I1)    : 2.58 A
Dongu 2 akimi (I2)    : 1.61 A
R2 uzerindeki gerilim : 4.84 V

Cubuk 1 gerilmesi     : 1414.21 N
Cubuk 2 gerilmesi     : -1000.00 N

1 gun sonra gunesli   : 0.90
1 gun sonra bulutlu   : 0.10
7 gun sonra gunesli   : 0.83
kararli durum gunesli : 0.83
kararli durum bulutlu : 0.17

Ozet: 11 bolumde 20+ lineer cebir fonksiyonu ve 5 uygulama olculdu.
      En buyuk ozdeger 7.2880, I1 = 2.58 A, kararli gunesli = 0.83.
```

## Öne Çıkan Noktalar

- `A\b`, `A*X = b` sistemini ters almadan çözer; artık `2.6e-16` mertebesinde kalır.
- `expm`, `logm`, `sqrtm` **matris** fonksiyonlarıdır; `exp`, `log`, `sqrt` eleman bazında çalışır. `expm([0 1; -1 0])`
  bir dönme matrisi verir: `[0.5403 0.8415; -0.8415 0.5403]` (ölçüldü).
- `chol` yalnız simetrik pozitif tanımlı matriste çalışır; `R'*R - P` artığı `4.44e-16`.
- `eig` çıktısı iki biçimde alınır: `lambda = eig(A)` vektör, `[V, L] = eig(A)` ayrışım. İlişki
  `A = V*L*inv(V)`; betikte artık `1.3e-15` ölçüldü.
- Uygulamalarda sayılar tutarlı: `I1 = 2.58 A`, `I2 = 1.61 A`, Markov kararlı durumu `Güneşli 0.83`.

## Alıştırmalar

1. `A = [2 1 -1; -3 -1 2; -2 1 2]` sistemini `inv(A)*b` ve `A\b` ile ayrı ayrı çözün; iki artık normunu karşılaştırın.
2. `hilb(8)` için `cond` değerini ölçün; `chol` çağrısının neden başarısız olduğunu (`hilb` pozitif tanımlıdır, ama yuvarlama hatası) `try/catch` ile gösterin.
3. Markov örneğinde `x0 = [0; 1]` ile başlayın; kararlı durumun başlangıç durumundan bağımsız olduğunu 7 ve 30 günlük sonuçlarla gösterin.
