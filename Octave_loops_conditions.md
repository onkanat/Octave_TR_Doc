---
layout: default
title: "Octave'de Döngüler ve Koşullar"
---

# Octave'de Döngüler ve Koşullar

Döngüler, bir kod bloğunu bilinen veya bilinmeyen sayıda tekrarlamak için kullanılır ve döngü türüne bağlıdır. Döngüleri kullanarak, fraktalların ve rastgele noktalarla çizilen şekillerin güzel resimlerini çizeceksiniz.

## `for` Döngüsü

Bilinen değerler listesi için bir kod bloğunu tekrarlamak için `for` döngülerini kullanırız. Örnek olarak, bir değerler listesinin ortalamasını hesaplayacağız. Ortalama şu formülden hesaplanır:

x̄ = (1/n) ∑(i=1 to n) xi

Bazı değerlere sahip bir vektör oluşturuyoruz:

```octave
octave:1> x = [1.2, 6.3, 7.8, 3.6];
```

ve ortalamayı şu şekilde hesaplıyoruz:

```octave
octave:2> sum = 0;
octave:3> for entry = x,
octave:4>   sum = sum + entry;
octave:5> end;
octave:6> x_mean = sum / length(x)
```

**Açıklama:**
- **Satır 2:** sum'u 0'a eşitle.
- **Satır 3:** x'teki her değer için, onu entry'ye ata.
- **Satır 4:** sum'u entry kadar artır.
- **Satır 5:** x'in daha fazla üyesi olmadığında for döngüsünü sonlandır.
- **Satır 6:** sum'un son değerini x'in uzunluğuna bölerek x_mean'e ata.

Genel olarak, bir `for` döngüsünü şu şekilde yazarız:

```octave
for variable = vector
  ...
end
```

`...` vektörün içindeki her değer için tam olarak bir kez çalıştırılan kod bloğunu temsil eder.

### Örnek: Sierpinski Üçgeni

Sierpinski üçgeni, çok basit bir algoritma ile üretilebilen bir fraktaldır.

1. Eşkenar üçgenin bir köşesinde başla.
2. Rastgele bir üçgen köşesi seç.
3. Şu anda bulunduğun yer ile seçilen köşe arasındaki yarı noktaya git.
4. 2. adımdan tekrarla.

Bu prosedürü takip ederek ziyaret ettiğin noktaları çizerek aşağıdaki resmi oluşturur.

Bu fraktalı üreten kod aşağıda gösterilmiştir. Bu kodun fraktalı üretmek için çok basit bir for döngüsü kullandığını unutmayın (for i = 1:N ; ... ; end):

```octave
axis ([-1, 1, -0.75, 1.25], "square");
figure(1, "visible", "off");             % çizim penceresi yok
hold on;

% eşkenar üçgenin köşelerini tanımla (y eksenine simetrik)
V = [ 0, 1;                                           % üst köşe
     cos( (pi/2)+(2*pi/3) ), sin( (pi/2)+(2*pi/3) );  % sol köşe
     cos( (pi/2)-(2*pi/3) ), sin( (pi/2)-(2*pi/3) )   % sağ köşe
     ];

r = floor(3*rand(1)+0.9999999999);                    % [1:3] aralığında tam sayı rastgele sayı
x = [ V(r,1), V(r,2) ];                               % x'i rastgele köşede başlat

for i = 1:1000 % !!! 100000 => zaman=130m57.343s
  r = floor(3*rand(1)+0.9999999999);                  % [1:3] aralığında tam sayı rastgele sayı
  x = ( x+V(r,[1:2]) )./2;                            % yarı yol, mevcut konumdan rastgele köşeye
  plot(x(1),x(2), ".");
endfor

print -dpng "sierpinski_m.png";
```

#### Bir Uyarı

Performans nedenleriyle, 'for' döngüleri içinde mümkün olduğunca az görev gerçekleştirmek en iyisidir ve plot gibi grafik işlemleri mümkün olduğunda döngülerin dışına taşınmalıdır. Aşağıda gösterildiği gibi tüm x değerlerini bir matriste saklayıp sonra çizerek, 100.000 eleman üzerinde iterasyon yaptığında bile bu figürü üretmek için kod çalışma süresi birkaç saniyeye düşer:

```octave
axis ([-1, 1, -0.75, 1.25], "square");
figure(1, "visible", "off");                          % çizim penceresi yok
hold on;

% eşkenar üçgenin köşelerini tanımla (y eksenine simetrik)
V = [ 0, 1;                                           % üst köşe
     cos( (pi/2)+(2*pi/3) ), sin( (pi/2)+(2*pi/3) );  % sol köşe
     cos( (pi/2)-(2*pi/3) ), sin( (pi/2)-(2*pi/3) )   % sağ köşe
     ];

r = floor(3*rand(1)+0.9999999999);                    % [1:3] aralığında tam sayı rastgele sayı
x(1,:) = [ V(r,1), V(r,2) ];                         % bu sefer x'i matris olarak başlat.

for i = 2:100000 % Artık güvenli: 100000 => zaman=7.85346s
  r = floor(3*rand(1)+0.9999999999);                  % [1:3] aralığında tam sayı rastgele sayı
  x(i,:) = ( x(i-1,:)+V(r,[1:2]) )./2;                % Her yeni hesaplanan x değerini matrise ekle
endfor

plot(x(:,1),x(:,2), ".");                             % tüm matrisi sadece bir kez çiz
print -dpng "sierpinski_m.png";
```

x'i önceden tam son boyutta bir matris olarak başlatarak, bu işleme süresi modern donanımda sadece 1 veya 2 saniyeye kadar daha da azaltılabilir. Genel olarak, bir döngü vektörleştirme ile değiştirilebiliyorsa, değiştirilmelidir.

**Performans İpuçları:**

- Döngü içinde mümkün olduğunca az grafik işlemi yapın
- Vektörleştirme kullanmayı tercih edin
- Matrisleri önceden uygun boyutlarda başlatın
- `plot` gibi işlemleri döngü dışına taşıyın

### Alıştırmalar: For Döngüsü

1. İlk N tam sayının toplamını hesaplayan bir script yazın. Sonucunuzu ½N(N+1) formülü ile kontrol edebilirsiniz.
2. `linspace` fonksiyonu ile aynı şeyi yapan bir script yazın. `xstart` değerinden başlamalı, `xstop`'ta durmalı ve `xstart`'tan `xstop`'a kadar eşit aralıklarla N değer içeren bir vektör oluşturmalıdır. Doğru boyutta sıfırlarla doldurulmuş bir vektör oluşturmak için `zeros` fonksiyonunu kullanabilirsiniz. Fonksiyonun nasıl çalıştığını öğrenmek için `help zeros` kullanın.

## `while` Döngüsü

while döngüsü de bir kod bloğunu birden fazla kez çalıştırır ancak mantıksal bir koşula dayalı olarak durur. Örneğin:

```octave
x = 1.0;
while x < 1000
   disp(x);
   x = x*2;
endwhile
```

`x`'i değeri 1000'i aşana kadar 2 ile çarpacaktır. Burada, `x < 1000` döngünün koşuludur. Koşul doğru olduğu sürece döngü çalışmaya devam edecektir. Yanlış olur olmaz, döngü sonlanır ve döngüden sonraki ilk talimat çalıştırılır.

While döngüsünün genel formu:

```octave
while condition
  ...
endwhile
```

### Alıştırma: While Döngüsü

a^n ≥ b olacak şekilde en küçük pozitif tam sayı n'yi hesaplayan bir script yazın (bazı gerçek sayılar a ve b için). (Yani, en azından b olan a'nın en küçük kuvvetini bulun.) `log` fonksiyonunu kullanmak hile sayılır.

### Örnek: Mandelbrot Fraktalı

Mandelbrot kümesi başka bir fraktaldır ve bir karmaşık sayının büyümesinin ne kadar sürdüğünü kontrol ederek üretilir. Her karmaşık sayı c için:

1. z₀ = 0 ile başla.
2. zi = zi-1² + c, ∀i = 1,2,... olsun
3. |zi| > 2 olan ilk i'yi bul.

Tüm bu i değerlerini kaydederiz ve her birine bir renk atarız. Bu, böyle bir görüntü oluşturmak için kullanılır.

Bu fraktalı üreten kod içinde (bazı for döngüleri içinde) karmaşık sayı z'nin modülünün 2'den küçük olup olmadığını test eden bir while döngüsü var:

```octave
while (count < maxcount) & (abs(z) < 2)
  ...
endwhile
```

While döngüsündeki ilk koşul çok fazla iterasyon yapmadığımızı kontrol eder. c'nin bazı değerleri için izin verirsek iterasyon sonsuza kadar devam edecektir.

## `do...until` İfadesi

Bu döngüler, verilen bir koşulun doğru veya yanlış olmasına göre çalışmaya devam etmeleri açısından while döngülerine çok benzer. Ancak `while` ve `do...until` döngüleri arasında bazı önemli farklar vardır:

1. `while` döngüleri koşullarını döngünün başında tutar; `do...until` döngüleri koşullarını sonunda tutar.
2. `while` döngüleri koşul doğru olduğu sürece tekrarlar; `do...until` döngüleri koşul yanlış olduğu sürece devam eder.
3. `while` 0 veya daha fazla kez çalışacaktır (çünkü koşul başta); `do...until` döngüleri 1 veya daha fazla kez çalışacaktır (koşul sonda olduğu için).

`do...until` döngüsünün genel formu:

```octave
do
  ...
until condition
```

### Alıştırma: EBOB Hesaplayın

İki pozitif tam sayının en büyük ortak bölenini (EBOB) hesaplayan bir script yazın. Bunu Öklid algoritmasını kullanarak yapabilirsiniz.

### Meydan Okuma: Uniform Dağılmış Rastgele Sayılar

Aşağıdaki şekilde uniform olarak dağılmış rastgele sayı çiftleri (a, b) üreten bir script yazın:

1. {(x,y)|x² + y² ≤ 1} diski üzerinde;
2. Belirli bir geometrik şekil üzerinde uniform dağılım.

Bu tür problemler genellikle Monte Carlo yöntemleri için kullanılır.

## `break` ve `continue` İfadeleri

Bazen bir döngüyü çalışmasının ortasında bir yerde durdurmak veya mevcut değer için döngü kodunun geri kalanını çalıştırmadan for döngüsündeki bir sonraki değere geçmek gerekir. İşte burada `break` ve `continue` ifadeleri kullanışlıdır.

Aşağıdaki kod break ifadesinin nasıl çalıştığını gösterir:

```octave
total = 0;
while true
   x = input('Eklenecek değer (durdurmak için 0 girin): ');
   if x == 0
      break;
   endif
   total = total+x;
   disp(['Toplam: ', num2str(total)]);
endwhile
```

`break` ifadesi olmadan, döngü sonsuza kadar çalışmaya devam ederdi çünkü `while` döngüsünün koşulu her zaman doğrudur. `break`, döngünün sonunu atlayıp geçmenizi sağlar (endwhile'dan sonraki ifadeye).

`break` ifadesi herhangi bir döngüde kullanılabilir: `for`, `while` veya `do...until`.

Continue ifadesi de döngünün içinden atlar ancak döngünün sonuna gitmek yerine döngünün başına döner. Bir:

1. `for` döngüsünde, vektörün içindeki bir sonraki değer for değişkenine atanacaktır (eğer kalan varsa) ve döngü o değerle yeniden başlatılacaktır;
2. `while` döngüsünde, döngünün başındaki koşul yeniden test edilecek ve hala doğruysa döngü devam edecektir;
3. `do...until` döngüsünde, döngünün sonundaki koşul test edilecek ve hala yanlışsa döngü baştan devam edecektir.

Örnek olarak, aşağıdaki kod kare bir matrisin alt üçgensel kısmını 1'lerle, geri kalanını 0'larla dolduracaktır:

```octave
N = 5;
A = zeros(N); % 0'larla doldurulmuş N x N matris oluştur

for row = 1:N
  for column = 1:N
      if column > row
         continue;
      endif
      A(row, column) = 1;
   endfor
endfor

disp(A);
```

İç `for`'un, sütun indeksi satır indeksinden büyük olduğunda A'nın bir girişine 1 atayan kodu atladığını (devam ettiğini) unutmayın.

## `if` İfadesi

`if` ifadesinin genel formu:

```octave
if condition1
  ...
elseif condition2
  ...
else
  ...
endif
```

`condition1` doğru olarak değerlendirilirse, `if`'ten hemen sonraki blokdaki ifadeler çalıştırılır. `condition1` yanlışsa, bir sonraki koşul (`elseif`'teki `condition2`) kontrol edilir ve doğruysa ifadeleri çalıştırılır. İstediğiniz kadar `elseif` ifadesi olabilir. `else`'den sonraki son ifade kümesi, tüm koşullar yanlış olarak değerlendirilirse çalıştırılır. `if` ifadesinin `elseif` ve `else` kısımlarının isteğe bağlı olduğunu unutmayın.

Aşağıdakiler geçerli `if` ifadeleridir:

```octave
% x'in mutlak değerinin logaritmasını al
if x > 0
   y = log(x);
elseif x < 0
   y = log(-x);
else
   disp("Sıfırın logaritması alınamaz.");
endif

x = input("Bir değer girin: ");
if x > 0
   disp("Sayı pozitif");
endif

if x < 0
   disp("Sayı negatif");
endif

if x == 0
   disp("Sayı sıfır");
endif
```

### Örnek: Fraktal Eğrelti Otu

Bu algoritma tam olarak tamamlanmamıştır. [MathWorks File Exchange'teki .m dosyasına](http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=4372&objectType=file) göz atın.

Sağdaki görüntü aşağıdaki algoritma ile üretilebilir:

1. x₁ ve y₁'in 0 ile 1 arasında rastgele değerler olmasını sağla.
2. (xi, yi)'den (xi+1, yi+1)'i hesaplamak için aşağıdaki doğrusal dönüşümlerden birini seç:
   1. xi+1 = 0, yi+1 = 0.16yi
   2. xi+1 = 0.20xi − 0.26yi, yi+1 = 0.23xi + 0.22yi + 1.6
   3. xi+1 = −0.15xi + 0.28yi, yi+1 = 0.26xi + 0.24yi + 0.44
   4. xi+1 = 0.85xi + 0.04yi, yi+1 = −0.04xi + 0.85yi + 1.6

   İlk dönüşüm 0.01 olasılıkla, ikinci ve üçüncü her biri 0.07 olasılıkla ve dördüncü 0.85 olasılıkla seçilir.

3. Bu değerleri i için en az 10.000'e kadar hesapla.

Bu fraktalı üreten kodu fracfern.m olarak indirebilirsiniz (şu anda devre dışı).

---

[Ana Sayfaya Dön](./)
