---
layout: default
title: "Octave'de İleri Düzey Veri Yapıları"
---

# Octave'de İleri Düzey Veri Yapıları

Octave, standart matrislerin ve vektörlerin yanı sıra, farklı türde ve boyutta verileri bir arada tutmak için daha esnek veri yapıları sunar. Bunlardan en önemlileri Hücre Dizileri (Cell Arrays) ve Yapılar'dır (Structs).

## Hücre Dizileri (Cell Arrays)

Hücre dizileri, her bir elemanının (hücresinin) farklı türde bir veri (sayı, metin, matris, hatta başka bir hücre dizisi) içerebildiği özel bir matris türüdür. Bu, ilişkili ancak farklı yapıda olan verileri bir arada gruplamak için onları son derece kullanışlı hale getirir.

Hücre dizileri, `{}` (küme parantezleri) kullanılarak oluşturulur.

**Örnek: Bir Hücre Dizisi Oluşturma ve Elemanlarına Erişme**

```octave
% 1x3 boyutunda bir hücre dizisi oluşturalım
C = { [1, 2; 3, 4], "Bu bir metindir", 42 };

% Hücre dizisini görüntüle
disp(C);

% Birinci hücrenin içeriğine erişim (içerik bir matristir)
matris_eleman = C{1};
fprintf('\nBirinci hücrenin içeriği (bir matris):\n');
disp(matris_eleman);

% İkinci hücrenin içeriğine erişim (içerik bir metindir)
metin_eleman = C{2};
fprintf('İkinci hücrenin içeriği: %s\n', metin_eleman);

% Üçüncü hücrenin içeriğini değiştirme
C{3} = "Yeni değer";
fprintf('Değiştirilmiş üçüncü hücrenin içeriği: %s\n', C{3});

% Hücre dizisine yeni bir eleman ekleme
C{4} = { "iç içe", "hücre dizisi" };
disp('Genişletilmiş Hücre Dizisi:');
disp(C);
```

## Yapılar (Structs)

Yapılar (structs), verileri "alan" (field) adları altında gruplamanıza olanak tanır. Bu, bir nesnenin veya kaydın birden çok özelliğini tek bir değişkende saklamak için idealdir. Örneğin, bir öğrencinin bilgilerini (adı, numarası, notları) bir yapıda toplayabilirsiniz.

Yapılar, `struct` fonksiyonuyla veya doğrudan alan atamasıyla oluşturulur.

**Örnek: Bir Öğrenci Kaydı için Yapı Oluşturma**

```octave
% 1. Yöntem: Doğrudan alan ataması
ogrenci.adi = "Ahmet";
ogrenci.numarasi = 123;
ogrenci.notlari = [85, 92, 78];
ogrenci.bolumu = "Mühendislik";

fprintf('Öğrencinin Adı: %s\n', ogrenci.adi);
fprintf('Öğrencinin Numarası: %d\n', ogrenci.numarasi);

% Yapının bir alanına erişim (notlar bir vektördür)
ilk_not = ogrenci.notlari(1);
fprintf('Öğrencinin ilk notu: %d\n', ilk_not);

% 2. Yöntem: struct() fonksiyonu
ogrenci2 = struct('adi', "Ayşe", 'numarasi', 456, 'notlari', [95, 88, 100]);
fprintf('\nİkinci Öğrencinin Adı: %s\n', ogrenci2.adi);

% Yapı Dizileri (Array of Structs)
% Birden fazla öğrenciyi bir dizide saklayabiliriz
ogrenciler(1).adi = "Ahmet";
ogrenciler(1).numarasi = 123;
ogrenciler(2).adi = "Ayşe";
ogrenciler(2).numarasi = 456;

fprintf('\nTüm öğrencilerin adları:\n');
for i = 1:length(ogrenciler)
    fprintf('- %s\n', ogrenciler(i).adi);
end
```

---
[Ana Sayfaya Dön](./)
