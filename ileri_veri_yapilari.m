clear; clc; close all;

%% 1. Hucre dizisi (cell array) olusturma ve icerige erisim
% Her hucre farkli turde veri tutabilir: matris, metin, sayi.
C = {[1 2; 3 4], "Bu bir metindir", 42};
printf("[1] hucre sayisi: %d, boyut: %d x %d\n", numel(C), rows(C), columns(C));
printf("[1] 1. hucre turu : %s (matris)\n", class(C{1}));
disp(C{1});
printf("[1] 2. hucre turu : %s, icerik: %s\n", class(C{2}), C{2});
printf("[1] 3. hucre turu : %s, icerik: %d\n", class(C{3}), C{3});

%% 2. Hucre icerigini degistirme ve diziye yeni hucre ekleme
C{3} = "Yeni deger";
C{4} = {"ic ice", "hucre dizisi"};
printf("\n[2] 3. hucre artik: %s\n", C{3});
printf("[2] hucre sayisi  : %d\n", numel(C));
printf("[2] 4. hucre turu : %s (%d alt hucre)\n", class(C{4}), numel(C{4}));
printf("[2] ic ice erisim : %s / %s\n", C{4}{1}, C{4}{2});

%% 3. () ile parcayi almak, {} ile icerige inmek
alt = C(1:2);
printf("\n[3] C(1:2) turu: %s, hucre sayisi: %d (parca alindi, icerik cikmadi)\n", ...
       class(alt), numel(alt));
printf("[3] C{1}(2,1) : %d (ilk hucredeki matrisin 2. satir, 1. sutunu)\n", C{1}(2,1));
printf("[3] C{2}(1:3): %s (metnin ilk uc harfi)\n", C{2}(1:3));

%% 4. Yapi (struct): alan atamasiyla olusturma
ogrenci.adi     = "Ahmet";
ogrenci.numarasi = 123;
ogrenci.notlari = [85 92 78];
ogrenci.bolumu  = "Muhendislik";
printf("\n[4] alanlar: %s\n", strjoin(sort(fieldnames(ogrenci))', ", "));
printf("[4] ad: %s, numara: %d, bolum: %s\n", ...
       ogrenci.adi, ogrenci.numarasi, ogrenci.bolumu);
printf("[4] notlar: %s, ortalama: %.2f\n", ...
       num2str(ogrenci.notlari), mean(ogrenci.notlari));

%% 5. Yapi: struct() fonksiyonu ve alan sorgulama
ogrenci2 = struct("adi", "Ayse", "numarasi", 456, "notlari", [95 88 100]);
printf("\n[5] ikinci ogrenci: %s (%d), ortalama: %.2f\n", ...
       ogrenci2.adi, ogrenci2.numarasi, mean(ogrenci2.notlari));
printf("[5] 'bolumu' alani var mi: %d\n", isfield(ogrenci2, "bolumu"));
printf("[5] 'adi' alani var mi   : %d\n", isfield(ogrenci2, "adi"));

%% 6. Yapi dizisi (array of structs)
% Alan kumeleri ayni olmak zorunda; bu yuzden dizi struct() ile kurulur.
ogrenciler = struct("adi", {"Ahmet", "Ayse", "Mehmet"}, ...
                    "numarasi", {123, 456, 789});
printf("\n[6] yapi dizisi boyutu: %d x %d\n", rows(ogrenciler), columns(ogrenciler));
for i = 1:numel(ogrenciler)
  printf("    - %s (%d)\n", ogrenciler(i).adi, ogrenciler(i).numarasi);
end
printf("[6] numaralar toplami: %d\n", sum([ogrenciler.numarasi]));

%% 7. Hucre ile yapi arasindaki fark, tek satirda
printf("\n[7] hucre C{2} : %s (hucre icerigi dogrudan kullanilir)\n", C{2});
printf("[7] yapi  ogrenci.adi: %s (alan adiyla erisilir)\n", ogrenci.adi);

%% Ozet
printf("\nOzet: 4 hucreli C dizisi, 4 alanli ogrenci yapisi, struct() ile kurulan\n");
printf("      ogrenci2 ve 3 elemanli ogrenciler yapi dizisi ayni betikte olculdu.\n");
