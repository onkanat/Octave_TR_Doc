# Octave Çalışma Notları

Bu belge, Octave ile örnek çalışma programları ve notları içermektedir.

## Programlar, Kütüphaneler ve Paketler

Octave program ve kütüphane geliştiricileri için tarifler. Bir Octave programcısının başkaları için kod yazarken bilmesi gereken şeyler.

### Octave Yapılandırmasını Bulun

Octave birçok farklı konfigürasyonla oluşturulabildiğinden, programlar ihtiyaç duydukları özelliklerden yoksun bir makinede çalışabilir. Geliştiriciler, bir Octave kurulumunun tüm özelliklere sahip olmasını asla beklememelidir. Ayrıca, programlar gerekli özelliklerin mevcut olup olmadığını tespit etmelidir.

Özellikleri kontrol etmek için kullanılabilecek olası testlerin listesi şu şekildedir:

**64-bit indeksleme desteği:**
```octave
sizemax() > intmax("int32")


**Java desteğiyle oluşturulma:**

usejava("jvm")


**Tif dosyaları desteğiyle görüntü G/Ç:**

any(cellfun(@(x) ismember("tif", x), {imformats.ext}))


**Png dosyaları desteğiyle görüntü G/Ç:**

any(cellfun(@(x) ismember("png", x), {imformats.ext}))
```

### Bir Paketin Yüklü Olup Olmadığını Bulun

**Sorun:**
Belirli paketlerin kullanılabilirliğine bağlı olarak farklı işlevler kullanan veya farklı davranan bir programınız var.

**Çözüm:**
`pkg("list", "pkg-name")` şu şekilde kullanın:

```octave
if (! isempty(pkg("list", "foo")))
  ## foo paketindeki fonksiyonları kullanın, tercih edilen yol
elseif (! isempty(pkg("list", "bar")))
  ## bar paketindeki fonksiyonları kullanın, çok da iyi değil
else
  ## varsayılan durum
endif
```

**Tartışma:**
Tek amacı paketin yokluğunda başarısız olmaksa, bunu kullanmanız önerilmez. Bu durumda, paketi yüklemeyi deneyin; Octave yeterince bilgilendirici bir hata mesajı verecektir.

Bunu kontrol etmenin tek amacı, bir paket eksikse yapılacak farklı bir şey olup olmadığını kontrol etmektir. Aynı şey, bir hatayı yakalamak için de geçerlidir `pkg load`. Bir hatayı yalnızca yakalayıp tekrar fırlatmak için kullanıyorsanız, en baştan hiç yakalamamanız daha iyi olur.

```octave
## Bu düzenek hiçbir şey eklemez. 'pkg load' başarısız olursa,
## kullanıcıya zaten bir hata mesajı verecektir.
try
  pkg load foo;
catch
  error("foo yüklenemedi: %s", lasterr());
end_try_catch

## Yine hiçbir şey eklemiyor. 'pkg load' başarısızlığı yeterlidir
if (isempty(pkg("list", "foo")))
  error("program: package foo is not installed");
endif
```
Yüklü bir paketin, bir işlevin her zaman kullanılabilir olacağının garantisi olmadığını unutmayın. Bazı paketler derleme sırasında işlevleri devre dışı bırakabilir veya belirli işlevlerin belirli çalışma zamanı gereksinimleri olabilir.

### Octave'deki Tüm İşlevleri Listele

Aşağıdaki betiği kullanın (dosya adı `list_func.m`):

```octave
## Tüm yerleşik (C++) fonksiyonların ve m-dosya fonksiyonlarının listesi
funcs = vertcat(__builtins__(), __list_functions__());

## Listeyi dosyaya yaz
fid = fopen("all_funcs.tmp", "w");
if (fid == -1)
  error("Geçici dosya all_funcs.tmp açılamıyor. İptal ediliyor...\n");
endif
fprintf(fid, "%s\n", funcs{:});
fclose(fid);
```

Ve komut satırından şu şekilde yürütün:
```sh
run-octave -f list_func.m
```

## Yapılar (Structs)

### Bir Yapı Dizisindeki Tüm Girdilerden Bir Alan Değeri Alın

**Sorun:**
Birden fazla alana sahip bir yapı diziniz var ve belirli bir alandaki değere tüm öğelerden erişmek istiyorsunuz. Örneğin, aşağıdaki durumda tüm hastaların yaşını döndürmek istiyorsunuz:

```octave
ornekler = struct("hasta",   {"Bob", "Kevin", "Bob", "Andrew"},
                  "yaş",     {45,    52,      45,    23},
                  "protein", {"H2B", "CDK2", "CDK2", "Tip60"},
                  "tüp",     {3,     5,       2,     18}
                 );
```

**Çözüm:**
Yapının indekslenmesi virgülle ayrılmış bir liste döndürür, bu yüzden bunları bir matris oluşturmak için kullanın.

```octave
[ornekler(:).yaş]
```

Ancak bu, verilerin orijinal yapısını korumaz, bunun yerine tüm değerleri tek bir sütunda döndürür. Bunu düzeltmek için `reshape()` kullanın.

```octave
reshape([ornekler(:).yaş], size(ornekler))
```

**Tartışma:**
Tüm değerleri virgülle ayrılmış listeler halinde döndürmek, bunlardan istediğinizi oluşturmanıza olanak tanır. Sayılar bekleniyorsa, bunları köşeli parantez `[]` içine alarak bir matris oluşturun. Ancak dizeler bekleniyorsa, süslü parantezler `{}` kullanarak kolayca bir hücre dizisi de oluşturulabilir.

```octave
{ornekler(:).hasta}
```

Ayrıca tüm elemanları döndürmekle sınırlı değilsiniz, diğer alanlardan mantıksal indekslemeyi kullanarak diğerlerinden değer alabilirsiniz:

```octave
[samples([samples(:).age] > 34).tube]                  ## 34 yaşından büyük hastalardan alınan tüm örneklerin tüp numaralarını döndür
[samples(strcmp({samples(:).protein}, "CDK2")).tube]   ## protein CDK2 için tüm tüp numaralarını döndür
```

## Dizi Manipülasyonu

### n-Boyutlu Diziden Bir Dilim Seçin

**Sorun:**
Rastgele sayıda boyuta sahip bir `A` dizisi için, örneğin ilk sütunu seçin. Bu, 2 boyutluysa `A(:, 1)`, 3 boyutluysa `A(:, 1, :)` vb. olacaktır.

**Çözüm:**
Bir olasılık, dinamik olarak oluşturulan `subsref` girdisiyle doğru sayıda boyuta sahip olmaktır. Bu, bir fonksiyon olarak yazılabilir:

```octave
function [B] = array_slice(A, k, d)
  # A'nın k'ıncı dilimini (satır, sütun...) döndür, d dilimlenecek boyutu belirtiyor
  idx.type = "()";
  idx.subs = repelems({':'}, [1; ndims(A)]);
  idx.subs(d) = k;
  B = subsref(A, idx);
endfunction

# Test Durumları
%!shared A
%! A = rand(2, 3);
%!assert(array_slice(A, 1, 2), A(:, 1))
%! A = rand(2, 3, 4);
%!assert(array_slice(A, 2, 1), A(2, :, :))
%! A = rand(2, 3, 4, 5);
%!assert(array_slice(A, 1, 2), A(:, 1, :, :))
%! A = rand(2, 3, 4, 5, 6);
%!assert(array_slice(A, 2, 3), A(:, :, 2, :, :))
```

Sonuçtan tekil boyutu kaldırmak için `B` üzerinde şunu kullanın:
```octave
B = reshape(B, [size(B)([1:d-1 d+1:end])]);
```

## Giriş/Çıkış

### Farklı Dizilerden Eşleşen Öğeleri Görüntüle

**Sorun:**
Eşleştirilmiş öğelerden oluşan iki veya daha fazla diziniz var ve bunlar hakkında bir dize yazdırmak istiyorsunuz. Örneğin:

```octave
anahtarlar = {"insan", "fare", "tavuk"};
degerler = [64, 72, 70];
```

ve şunu görüntülemek istiyorsunuz:
```
Hesaplanan insan genomu GC içeriği %64'tür
Hesaplanan fare genomu GC içeriği %72'dir
Hesaplanan tavuk genomu GC içeriği %70'tir
```

**Çözüm:**
Her eşleştirilmiş verinin bir sütunda olduğu iki satırlık bir hücre dizisi oluşturun ve `printf` fonksiyonuna bir CS (comma-separated) listesi sağlayın.

```octave
değerler = num2cell(degerler);
yeni = {anahtarlar{:}; degerler{:}};
printf("Hesaplanan %s genom GC içeriği %i%%\n", yeni{:})
```

veya tek bir satırda:
```octave
printf("Hesaplanan %s genom GC içeriği %i%%\n", {keys{:}; num2cell(values){:}}{:})
```

**Tartışma:**
`printf` ve ailesi hücre dizilerini değer olarak kabul etmez. Ancak, devam etmek için yeterli argümana sahip olduğu sürece verilen şablonu tekrarlamaya devam ederler. Bu nedenle, işin püf noktası, bir hücre dizisi kullanarak ve onu `{}` ile indeksleyerek yapılabilecek bir elemanlar listesi sağlamaktır.

Değerler sütun bazında sıralandığından, eşleştirilmiş değerlerin aynı sütunda olması gerekir. Daha sonra yeni bir veri satırı eklenebilir.

```octave
yeni(end+1, :) = {"Andrew", "Bob", "Kevin"};
```
Artık indeksleme için normal parantezlerin kullanıldığını unutmayın.

### Takas Değerleri

İki değişken arasındaki değeri, geçici bir değişken oluşturmadan değiştirmek istiyorsanız, şunu yapabilirsiniz:
```octave
[b, a] = deal(a, b);
```

### Bir Fonksiyonun Tüm Çıktı Argümanlarını Topla

Örneğin, birden fazla değer döndüren bir fonksiyonunuz varsa:
```octave
function [a, b, c] = myfunc()
  [a, b, c] = deal(1, 2, 3);
endfunction
```
ve bunların hepsini tek bir hücrede toplamak istiyorsanız (Python'un `zip()` fonksiyonuna benzer şekilde) şunu yapabilirsiniz:
```octave
outargs = nthargout(1:3, @myfunc)
```

### `fprintf` ile Bir Metin Tablosu Oluşturun

15 karakter genişliğinde ve her biri sağa dayalı 2 sütundan oluşan bir metin tablosu oluşturmak istediğinizi düşünün. Bunu `fprintf` ile nasıl yapabilirsiniz?

Çok kolay:
`Metin` değişkeni, iki sütun ve belirli sayıda satırdan oluşan bir dize hücre dizisi (uzunluğu < 15) ise, `Metin` değişkeninin k. satırı için yazmanız yeterlidir:
```octave
fprintf('%15.15s | %15.15s\n', Metin{k, 1}, Metin{k, 2});
```
`%<n>.<m>s` sözdizimi, `n` karakterlik yer ayırır ve görüntülenecek dizenin ilk `m` karakterini görüntüler.

**Örnek:**
```octave
Metin = {"Merhaba", "Dünya"};
fprintf('%15.15s | %15.15s\n', Metin{1, 1}, Metin{1, 2})
```
Çıktı:
```
         Merhaba |           Dünya
```

### Virgülle Ayrılmış Değerler (`*.csv`) Dosyalarını Yükleyin

`textread` fonksiyonunu kullanarak tek sütunlu bir hücre dizisi elde edebilirsiniz. `reshape` fonksiyonunu kullanarak orijinal boyuta geri dönebilirsiniz.
```octave
A = textread("dosya.csv", "%d", "delimiter", ",");
B = textread("dosya.csv", "%s", "delimiter", ",");
inds = isnan(A);
B(!inds) = num2cell(A(!inds))
```
Bir diğer seçenek ise `csvread` fonksiyonunu kullanmaktır. Ancak bu fonksiyon sayısal olmayan verileri işleyemez.

Muhtemelen en iyi seçenek, IO paketindeki `csv2cell` işlevini kullanmaktır. Bu işlev, karışık türdeki (sayısal ve metin) `.csv` dosyalarını okuyabilir, virgül ve diğer metin koruma karakterleri (varsayılan: çift tırnak) dışında alan ayırıcıları belirtmenize olanak tanır ve başlık satırlarını atlayabilir. IO paketini yüklediyseniz ve yüklediyseniz, daha fazla bilgi için Octave komut istemine `"help csv2cell"` yazın.

### XML Dosyalarını Yükle

XML'i Octave olarak okumak, Java kütüphanesi Apache Xerces kullanılarak yapılabilir.

Görünüşe göre Matlab `xmlread`, Apache Xerces kütüphanesini çevreleyen ince bir sargıdan ibarettir. Ancak, Java fonksiyonlarının Octave başladığında çalışma dizininin çalışma dizinine ayarlandığını ve çalışma dizininin bir `cd` komutu tarafından değiştirilmediğini unutmamak gerekir. Matlab da aynı davranışı sergiler, çünkü Java geçerli çalışma dizinini değiştirmenin bir yolunu sunmaz. Herhangi bir sorun yaşamamak için XML dosyasının mutlak yolunu kullanmak daha iyidir.

Örneğin, `https://xerces.apache.org/mirrors.cgi#binary` adresinden `xercesImpl.jar` ve `xml-apis.jar` dosyalarına ihtiyacınız var (en son sürümü kontrol edin). Şu dosyaları eklemek için `javaaddpath` kullanın:
```octave
javaaddpath("/path/to/xerces-2_11_0/xercesImpl.jar");
javaaddpath("/path/to/xerces-2_11_0/xml-apis.jar");
```

**Örnek:**
```octave
filename = "sample.xml";

## Bu üç satır Matlab'da xDoc = xmlread(filename) ile eşdeğerdir
parser = javaObject("org.apache.xerces.parsers.DOMParser");
parser.parse(filename);
xDoc = parser.getDocument();

elem = xDoc.getElementsByTagName("data").item(0);  ## ilk veri öğesini al
data = elem.getFirstChild.getTextContent();        ## çocuktan metin al
att  = elem.getAttribute("attribute");             ## 'att' isimli özelliği al
```

**Dosya: `sample.xml`**
```xml
<root>
  <data att="1">merhaba</data>
</root>
```

### Komutlarda Değişken Dizeleri Kullanma

Örneğin, bir dize değişkenini gösterge olarak kullanarak veriyi çizmek için:

**Statik dizeyi efsane olarak (en basiti):**
```octave
x = linspace(-1, 3, 100);
y = sin(x);
legend = "-1;Verilerim;";
plot(x, y, legend);
```

**Değişken dizesi efsane olarak (orta):**
```octave
x = linspace(-1, 3, 100);
y = sin(x);
dataName = "Verilerim";
plot(x, y, sprintf("-1;%s;", dataName));
```

**Değişken dizesini efsane olarak kullanmak (`eval` ile - çok da temiz değil):**
```octave
legend = "Verilerim";
plot_command = ["plot(x, y, '-1;", legend, ";')"];
eval(plot_command);
```
Aynı numaralar benzersiz isimlere sahip veri dosyalarını okumak ve yazmak için de faydalıdır.

## Kombinatorik

### Dize Karakterleriyle Kombinasyonlar

**Sorun:**
Farklı harflerin tüm kombinasyonlarını almak istiyorsunuz ancak `nchoosek` yalnızca sayısal girişi kabul ediyor.

**Çözüm:**
Dizenizi önce sayılara, sonra tekrar karakterlere dönüştürün.
```octave
string = "Merhaba";
n = 4;
char(nchoosek(uint8(string), n))
```

**Tartışma:**
Octave'deki bir dize, yalnızca bir karakter matrisidir ve sayısal biçime kolayca dönüştürülebilir. Her karakterin ilişkili bir numarası vardır (`ascii` paketin `table` işlevi, güzel biçimlendirilmiş bir dönüştürme tablosu görüntüler).

### Tekrarlı Permütasyonlar

**Sorun:**
Tekrarlı bir vektörün tüm olası permütasyonlarını üretmek istiyorsunuz.

**Çözüm:**
`ndgrid` kullanın:
```octave
[x, y, z] = ndgrid([1, 2, 3, 4, 5]);
[x(:), y(:), z(:)]
```

**Tartışma:**
Yukarıdaki kodu genişletip herhangi bir uzunluktaki permütasyonlar için çalışmasını sağlamak mümkündür.
```octave
sepet = nthargout([1:n], @ndgrid, vector);
combs = cell2mat(cellfun(@(c) c(:), sepet, "UniformOutput", false));
```

## Matematik

### Bir Sayının Tam Sayı Olup Olmadığını Test Edin

En basit yöntem muhtemelen `fix` kullanmaktır:
```octave
fix(x) == x
```

### Bir Sayının Çift/Tek Olup Olmadığını Bulun

**Sorun:**
Elinizde bir sayı, dizi veya matris var ve bunlardan herhangi birinin tek veya çift sayı olup olmadığını, yani paritelerini bilmek istiyorsunuz.

**Çözüm:**
İkiye bölme işleminin kalanını kontrol edin. Kalan sıfırsa, sayı çifttir.
```octave
mod(değer, 2)   ## Tek ise 1, çift ise sıfır
```
`mod` bir matris kabul ettiğinden aşağıdakiler yapılabilir:
```octave
any(mod(değerler, 2))   ## değerlerdeki en az bir sayı tekse doğru
all(mod(değerler, 2))   ## değerlerdeki tüm sayılar tekse doğru

any(!logical(mod(değerler, 2)))   ## değerlerdeki en az bir sayı çift ise doğru
all(!logical(mod(değerler, 2)))   ## değerlerdeki tüm sayılar çift ise doğru
```

**Tartışma:**
Bir bölme işleminin kalanını kontrol ettiğimiz için ilk tercih `rem` kullanmak olacaktır. Ancak, negatif sayılar söz konusu olduğunda `mod` yine de pozitif bir sayı döndüreceğinden karşılaştırmaları kolaylaştırır. Diğer bir alternatif ise `bitand(X, 1)` veya `bitget(X, 1)` kullanmaktır, ancak bunlar biraz daha yavaştır.

Bu çözümün yalnızca tam sayılar için geçerli olduğunu unutmayın. `0.5` veya `4.20` gibi tam sayı olmayanlar ne çift ne de tektir. Sayıların kaynağı bilinmiyorsa (örneğin kullanıcı girişi), tam sayı olmayan değerler, `NaN`, `Inf` için bir tür kontrol uygulanmalıdır.

### Parametreli Fonksiyonlar

**Sorun:**
Bazen bir dizi parametreye bağlı olarak bir fonksiyon ailesi tanımlamanız gerekir, örneğin:
$f(x,y,z;a,b,c)$
Neresi $x,y,z$ fonksiyonun üzerinde çalıştığı değişkenleri belirtir ve $a,b,c$ fonksiyon ailesinin belirli bir elemanını seçmek için kullanılan parametrelerdir.

Örneğin, yay sabitinin ($k$) farklı değerleri için bir yaydaki uzamanın zaman içindeki evrimini hesaplamamız gerektiğini varsayalım.

**Çözüm:**
Yay sabitinin farklı değerleri için yay denklemini çözmek amacıyla aşağıdaki kodu kullanarak problemi çözebiliriz:
```octave
t = linspace(0, 10, 100);

function sprime = spring(s, t, k)
  x = s(1);
  v = s(2);
  sprime(1) = v;
  sprime(2) = -k * x;
endfunction

k = 1;
x1 = lsode(@(x, t) spring(x, t, k), [1; 0], t)(:, 1);
k = 2;
x2 = lsode(@(x, t) spring(x, t, k), [1; 0], t)(:, 1);

plot(t, x1, t, x2)
legend('x1', 'x2')
```
![Parametreli Fonksiyon Çözümü](https://wiki.octave.org/images/2/26/Solparfun.png)

**Tartışma:**
Yukarıdaki örnekte, `sprime` fonksiyonu $x,t$ değişkenlerinin bir fonksiyon ailesini temsil eder ve $k$ parametresi ile parametrelendirilmiştir.

Anonim fonksiyon `@(x, t) sprime(x, t, k)` sadece $x,t$ değişkenlerinin bir fonksiyonudur, burada $k$ parametresi mevcut kapsamdaki değerine "dondurulmuştur".

### Noktalar Arasındaki Mesafe

**Sorun:**
Uzayda belirli bir nokta kümesi verildiğinde, bu noktaların arasındaki mesafeyi hesaplamak istiyoruz. Her nokta, bileşenleriyle $(x_i, y_i, \ldots)$ tanımlanıyor. Noktaların, satırları (her nokta için bir tane) ve sütunları (her bileşen için bir tane) olan bir $m \times n$ matrisinde (`P`) kaydedildiğini varsayalım.

**Çözüm:**
Bir yol, GNU Octave'deki operatörlerin yayın özelliklerini kullanmaktır. Noktalar arasındaki kare mesafe şu kodla hesaplanabilir:
```octave
[m, n] = size(P);
Dsq = zeros(m);
for i = 1:n
  Dsq += (P(:, i) - P(:, i)').^2;
endfor
```
Bu matris, köşegeni sıfır olan simetrik bir matristir.

Benzer şekilde bir noktadan diğerine işaret eden vektörler:
```octave
R = zeros(m, m, n);
for i = 1:n
  R(:,:,i) = P(:, i) - P(:, i)';
endfor
```

`Dsq` ve `R` arasındaki ilişki:
```octave
Dsq = sumsq(R, 3);
```

**Tartışma:**
Hesaplama, `cellfun` gibi fonksiyonlar kullanılarak gerçekleştirilebilir; böylece noktaların bileşenleri üzerinde döngü oluşması önlenir. Ancak çoğu durumda, bileşenlerden daha fazla noktamız olur ve iyileştirme, varsa, minimum düzeyde olur.

Bir diğer gözlem ise `Dsq` matrisinin simetrik olması ve yalnızca alt veya üst üçgensel kısmı saklayabilmemizdir. Bu optimizasyonu pratik bir şekilde kullanmak için `vech` ve `unvech` fonksiyonlarının yardımına bakın (bu, Forge paketinin genel versiyonunda bulunur). Henüz gün yüzüne çıkmamış iki fonksiyon, `sub2ind_tril` ve `ind2sub_tril`'dir (şu anda Forge paketinin mekaniklerinde özel fonksiyonlar). Bunlar, `vech` fonksiyonuyla oluşturulmuş bir vektörün elemanlarını indekslemek için kullanışlıdır. `R` çok boyutlu dizisinin her sayfası (üçüncü indeks) antisimetrik bir matristir ve üçgensel alt matrislerden yalnızca birini saklayarak bellekten tasarruf edebiliriz.

Çok daha fazla mesafe fonksiyonu (noktalar, doğrular, çokgenler, vb.) için **Geometri** paketini kontrol edin.

### ODE Durum Değişkenlerinden Cebirsel Değişkenleri Bulun

**Sorun:**
Bir dizi ODE'de zaman `t`'nin bir fonksiyonu olarak durum değişkenleri `x`'i bulmak için `lsode` veya başka bir ODE çözücüsü kullanıldığında, türevler dışında durum değişkenleri `x` ve zaman `t`'nin bir fonksiyonu olan cebirsel değişkenler `y`'yi döndürmenin ve tablolaştırmanın basit bir yolu yok gibi görünüyor.

Yukarıda "Parametreli Fonksiyonlar" bölümünde tanımlanan yay fonksiyonunun değiştirilmiş bir versiyonunu ele alalım:
```octave
function sprime = dspring(s, t)
  k = 1;
  tau = 1;
  x = s(1);
  v = s(2);
  y = x + v * tau;
  sprime(1) = v;
  sprime(2) = -k * y;
endfunction
```
Bu fonksiyonu ve `lsode`'u yalnızca `x` ve `sprime` elemanlarını değil, aynı zamanda (diyelim ki) `y`'yi zamanın bir fonksiyonu olarak tablolaştırmak için kullanmanın bir yolu ne olabilir?

**Çözüm:**
`sprime` fonksiyonunu ikinci argüman olarak `y`'yi döndürecek şekilde değiştirin:
```octave
function [sprime, y] = dspring(s, t)
  k = 1;
  tau = 1;
  x = s(1);
  v = s(2);
  y = x + v * tau;
  sprime(1) = v;
  sprime(2) = -k * y;
endfunction
```
`lsode` ikinci dönüş argümanı `y`'yi memnuniyetle göz ardı edecektir, ancak `x` tablo haline getirildikten sonra, `y`, bir `for` döngüsünde yay fonksiyonunun ikinci dönüş argümanı kullanılarak tablo haline getirilebilir, örneğin:
```octave
t = linspace(0, 10, 100);
x = lsode('dspring', [1; 0], t);
y = zeros(length(t), 1);
for i = 1:length(t)
  [xtmp, y(i, 1)] = dspring(x(i, :), t(i));
endfor
```

**Tartışma:**
Bu, tek cebirsel değişkenli basit bir örnektir. `y` dizisinin ikinci boyutunu genişleterek başka değişkenler de eklenebilir.

[Anasayfaya dön](index.md)