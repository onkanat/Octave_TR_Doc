---
layout: default
title: "Octave Fizik Alıştırmaları"
---

# Octave Fizik Alıştırmaları

Bu bölüm, fizik problemlerinin Octave üzerinde nasıl modelleneceğini ve çözüleceğini gösteren örnekler içerir. Değişken tanımlama, sabitler ve formül uygulama üzerine odaklanılmıştır.

---

## 6. Serbest Düşme (Basit)
**Problem:** Serbest düşmeye bırakılan bir cismin, kullanıcıdan alınan $t$ süresi sonunda ulaştığı hızı ve kat ettiği mesafeyi hesaplayınız. ($g = 9.81$ m/s² sabitini `constant` benzeri bir şekilde tanımlayınız).

```octave
% Yerçekimi ivmesi (Sabit)
G_IVME = 9.81; 

t = input('Düşüş süresini saniye cinsinden giriniz: ');

v = G_IVME * t;
h = 0.5 * G_IVME * t^2;

fprintf('%.2f saniye sonunda:\n', t);
fprintf('Hız: %.2f m/s\n', v);
fprintf('Düşüş Mesafesi: %.2f metre\n', h);
```

---

## 7. İdeal Gaz Yasası (Basit)
**Problem:** Bir ideal gaz için $PV = nRT$ formülünü kullanarak; basınç, hacim ve sıcaklık değerlerinden bilinmeyeni hesaplayan bir program yazınız. (Örneğin $n=1$ mol için).

```octave
R = 0.0821; % Gaz sabiti (L*atm / mol*K)
n = 1;      % 1 mol için

choice = input('Hesaplamak istediğiniz değişkeni seçin (1: P, 2: V, 3: T): ');

if choice == 1
    V = input('Hacim (L): ');
    T = input('Sıcaklık (K): ');
    P = (n * R * T) / V;
    fprintf('Basınç: %.4f atm\n', P);
elseif choice == 2
    P = input('Basınç (atm): ');
    T = input('Sıcaklık (K): ');
    V = (n * R * T) / P;
    fprintf('Hacim: %.4f L\n', V);
elseif choice == 3
    P = input('Basınç (atm): ');
    V = input('Hacim (L): ');
    T = (P * V) / (n * R);
    fprintf('Sıcaklık: %.4f K\n', T);
else
    disp('Geçersiz seçim.');
end
```

---

## 8. Eğik Atış Menzil Hesabı (Orta)
**Problem:** Belirli bir ilk hız ($v_0$) ve açıyla ($\theta$) fırlatılan bir merminin, menzilini ve maksimum yüksekliğini hesaplayan programı yazınız. (Radyan dönüşümü için `pi` veya `acos(-1.0)` kullanınız).

```octave
v0 = input('İlk hızı giriniz (m/s): ');
derece = input('Fırlatma açısını giriniz (derece): ');

% Dereceyi radyana çevirme
radyan = derece * (pi / 180);
g = 9.81;

% Menzil (Range): R = (v0^2 * sin(2*theta)) / g
menzil = (v0^2 * sin(2 * radyan)) / g;

% Maksimum Yükseklik: H = (v0^2 * sin(theta)^2) / (2*g)
max_h = (v0^2 * (sin(radyan)^2)) / (2 * g);

fprintf('Menzil: %.2f metre\n', menzil);
fprintf('Maksimum Yükseklik: %.2f metre\n', max_h);
```

---

## 9. Coulomb Yasası (Orta)
**Problem:** Coulomb Yasası'nı kullanarak, aralarındaki mesafe ve yük miktarları verilen iki parçacık arasındaki elektriksel kuvveti hesaplayınız. ($F = k \cdot \frac{|q_1 \cdot q_2|}{r^2}$)

```octave
k = 8.99e9; % Coulomb sabiti (N*m^2/C^2)

q1 = input('1. yükü giriniz (Coulomb): ');
q2 = input('2. yükü giriniz (Coulomb): ');
r = input('Aralarındaki mesafeyi giriniz (metre): ');

F = k * (abs(q1 * q2) / r^2);

fprintf('Parçacıklar arasındaki elektriksel kuvvet: %.2e Newton\n', F);
```

---

## 10. Basit Harmonik Hareket ve Dosyaya Yazma (İleri)
**Problem:** Basit harmonik hareket yapan bir sarkaç için, zamanın fonksiyonu olarak konumu ($x(t) = A \cdot \cos(\omega t)$) bir döngü içinde hesaplayıp bir dosyaya (`sarkac.txt`) yazdıran programı yazınız.

```octave
A = 0.5;      % Genlik (metre)
omega = 2.0;  % Açısal hız (rad/s)
t_son = 10;   % Bitiş süresi (s)
dt = 0.1;     % Zaman adımı

% Dosyayı yazma modunda aç
fid = fopen('sarkac.txt', 'w');
fprintf(fid, 'Zaman(s)   Konum(m)\n');
fprintf(fid, '------------------\n');

for t = 0:dt:t_son
    x = A * cos(omega * t);
    fprintf(fid, '%-10.2f %-10.4f\n', t, x);
end

fclose(fid);
disp('Veriler "sarkac.txt" dosyasına başarıyla yazıldı.');
```

---
[Ana Sayfaya Dön](./)
