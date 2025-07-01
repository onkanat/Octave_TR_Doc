
---
layout: default
title: Octave'de Veri İşleme
---
# Octave'de Veri İşleme:

Aşağıda, Octave'de veri işleme için kullanılan bazı temel işlevlerin detaylı örnekleri verilmiştir:

**1. load:**

**Amaç:** Dosyadaki verileri Octave çalışma alanına yüklemek.

**Kullanım:**

```octave
load dosya_adı
```

**Örnek:**

```octave
# "data.txt" adında bir dosyada bulunan verileri "x" değişkenine yükleyelim.
load data.txt
```

**2. save:**

**Amaç:** Çalışma alanındaki verileri bir dosyaya kaydetmek.

**Kullanım:**

```octave
save dosya_adı değişken_adı
```

**Örnek:**

```octave
# "x" değişkenindeki verileri "saved_data.txt" adında bir dosyaya kaydetmek için:
save saved_data.txt x
```

**3. who:**

**Amaç:** Çalışma alanındaki tüm değişkenleri ve türlerini listelemek.

**Kullanım:**

```octave
who
```

**Örnek:**

```octave
# Çalışma alanındaki değişkenleri ve türlerini listelemek için:
who
```

**4. whos:**

**Amaç:** Çalışma alanındaki tüm değişkenleri, boyutlarını ve türlerini listelemek.

**Kullanım:**

```octave
whos
```

**Örnek:**

```octave
# Çalışma alanındaki değişkenleri, boyutlarını ve türlerini listelemek için:
whos
```

**5. find:**

**Amaç:** Bir matriste belirli bir değerin tüm yerlerini bulmak.

**Kullanım:**

```octave
[satir_konum, sutun_konum] = find(matris, aranan_deger)
```

**Örnek:**

```octave
# Aşağıdaki matriste 5 sayısını bulalım:
A = [1 2 3; 4 5 6; 7 8 9];
[satir_konum, sutun_konum] = find(A, 5);
disp(satir_konum);
disp(sutun_konum);
```

**Çıktı:**

```
2
2
```

**6. sort:**

**Amaç:** Bir matrisi sıralamak.

**Kullanım:**

```octave
sirali_matris = sort(matris, siralama_sirasi)
```

**Örnek:**

```octave
# Aşağıdaki matrisi sıralama sırasına göre sıralayalım:
A = [3 1 5; 9 2 6; 4 7 8];
sirali_matris = sort(A);
disp(sirali_matris);
```

**Çıktı:**

```
1 2 3
4 5 6
7 8 9
```

**7. filter:**

**Amaç:** Bir matristen belirli koşullara uyan öğeleri filtrelemek.

**Kullanım:**

```octave
filtrelenmis_matris = filter(matris, kosul)
```

**Örnek:**

```octave
# Aşağıdaki matristen 5'ten büyük olan tüm öğeleri filtreleyelim:
A = [1 2 3; 4 5 6; 7 8 9];
kosul = A > 5;
filtrelenmis_matris = filter(A, kosul);
disp(filtrelenmis_matris);
```

**Çıktı:**

```
6
7
8
9
```

**8. unique:**

**Amaç:** Bir matristen tekrarlanan öğeleri silmek.

**Kullanım:**

```octave
benzersiz_degerler = unique(matris)
```

**Örnek:**

```octave
# Aşağıdaki matristen tekrarlanan öğeleri silelim:
A = [1 2 3 1 4 5 4 3];
benzersiz_degerler = unique(A);
disp(benzersiz_degerler);
```

**Çıktı:**

```
1
2
3
4
5
```

**Not:** Bu sadece Octave'de veri işleme için kullanılan bazı temel işlevlerin örnekleridir. Daha 
fazla bilgi için Octave belgelerine bakabilirsiniz: 

---
[Ana Sayfaya Dön](./)
