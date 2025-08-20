---
layout: default
title: Octave'da Grafik Oluşturma
---
# Octave'da Grafik Oluşturma

Octave, matematiksel işlevleri ve verileri görselleştirmek için güçlü grafik oluşturma araçları sunar. Temel grafik işlevleri şunlardır:

**plot:** Temel çizgi grafiği oluşturmak için kullanılır.
**xlabel:** X ekseninin etiketini ekler.
**ylabel:** Y ekseninin etiketini ekler.
**title:** Grafik başlığı ekler.
**legend:** Birden fazla veri kümesi için efsane ekler.
**grid:** Grafiğe izgara ekler.
**subplot:** Birden fazla grafiği tek bir pencerede alt grafikler halinde oluşturur.

**Örnek:**

```octave
x = linspace(-2, 2, 100);
y = sin(x);

plot(x, y);
xlabel('X Ekseni');
ylabel('Y Ekseni');
title('Sinüs Fonksiyonu Grafiği');
```

Bu kod, -2 ile 2 arasındaki 100 noktadan oluşan bir `x` dizisi ve bu noktalardaki `sinüs` fonksiyonunun değerlerini içeren bir `y` dizisi oluşturur. Daha sonra `plot` fonksiyonu kullanılarak bu verilerden bir çizgi grafiği oluşturulur. `xlabel`, `ylabel` ve `title` fonksiyonları sırasıyla X ve Y eksenlerine etiketler ve grafiğe başlık ekler.

**Ek Grafik Özellikleri:**

* `linestyle` ve `linewidth`: Çizgi stili ve kalınlığını ayarlar.
* `marker` ve `markersize`: Veri noktalarının stilini ve boyutunu ayarlar.
* `color`: Çizginin ve veri noktalarının rengini ayarlar.
* `axis`: Eksen aralıklarını ve ölçeklerini ayarlar.
* `loglog`: Logaritmik ölçeklerde grafik oluşturur.
* `semilogx` ve `semilogy`: X veya Y ekseninde logaritmik ölçek, diğerinde doğrusal ölçek kullanarak grafik oluşturur.

**Birden Çok Grafik Oluşturma:**

`subplot` fonksiyonu, birden fazla grafiği tek bir pencerede alt grafikler halinde oluşturmak için kullanılır. Örneğin, aşağıdaki kod iki grafiği yan yana alt grafikler halinde oluşturur:

```octave
x1 = 0:0.1:pi;
y1 = sin(x1);

x2 = pi:0.1:2*pi;
y2 = cos(x2);

subplot(1, 2, 1);
plot(x1, y1);
xlabel('X1');
ylabel('Y1');
title('Sinüs Fonksiyonu');

subplot(1, 2, 2);
plot(x2, y2);
xlabel('X2');
ylabel('Y2');
title('Kosinüs Fonksiyonu');
```

Bu kod, `sinüs` ve `kosinüs` fonksiyonlarının grafiklerini yan yana alt grafikler halinde oluşturur. `subplot(1, 2, 1)` komutu ilk grafiğin 1 satır ve 2 sütundan oluşan alt grafiklerin ilkine yerleştirileceğini belirtir. `subplot(1, 2, 2)` komutu ise ikinci grafiğin 1 satır ve 2 sütundan oluşan alt grafiklerin ikincisine yerleştirileceğini belirtir.

**Daha Fazla Bilgi:**

Octave'in grafik oluşturma araçları hakkında daha fazla bilgi için resmi belgelere bakabilirsiniz: [https://sourceforge.net/projects/octave/](https://sourceforge.net/projects/octave/)

**Ek Örnekler:**

* [https://octplot.sourceforge.net/quiver.html](https://octplot.sourceforge.net/quiver.html)
* [https://sourceforge.net/projects/octave/](https://sourceforge.net/projects/octave/)
* [https://stackoverflow.com/questions/13507700/how-to-plot-two-functions-on-one-graph](https://stackoverflow.com/questions/13507700/how-to-plot-two-functions-on-one-graph)

## İleri Düzey Grafik Uygulamaları

Octave, 2D grafiklerin yanı sıra verileri üç boyutta görselleştirmek ve dinamik grafikler oluşturmak için de güçlü yeteneklere sahiptir.

### 3D Grafikler: `plot3`, `surf` ve `mesh`

Octave, üç boyutlu verileri görselleştirmek için çeşitli fonksiyonlar sunar.

*   **`plot3`**: 3D uzayda çizgiler ve noktalar çizmek için kullanılır.
*   **`mesh`**: 3D yüzeyleri bir tel kafes (wireframe) olarak çizer.
*   **`surf`**: 3D yüzeyleri dolu renklerle çizer.

**Örnek: Bir Dağın Topografik Haritası**

`peaks` fonksiyonu, iki değişkenli bir normal dağılım karışımından oluşan ve genellikle 3D grafik çizimlerini test etmek için kullanılan bir yüzey oluşturur.

```octave
% 50x50'lik bir grid oluştur
[x, y] = meshgrid(-3:0.125:3);

% Z değerlerini (yükseklikleri) hesapla
z = peaks(x, y);

figure; % Yeni bir grafik penceresi aç

% surf ile yüzey grafiği
subplot(1, 2, 1);
surf(x, y, z);
title('surf ile Yüzey Grafiği');
xlabel('X Ekseni');
ylabel('Y Ekseni');
zlabel('Yükseklik');
colorbar; % Renk skalası ekle

% mesh ile tel kafes grafiği
subplot(1, 2, 2);
mesh(x, y, z);
title('mesh ile Tel Kafes Grafiği');
xlabel('X Ekseni');
ylabel('Y Ekseni');
zlabel('Yükseklik');
```

### Döngü ile Animasyon Oluşturma

Bir `for` döngüsü içinde grafiği sürekli güncelleyerek basit animasyonlar oluşturulabilir. `drawnow` komutu, her döngü adımında grafiğin yeniden çizilmesini sağlar.

**Örnek: İlerleyen Bir Sinüs Dalgası Animasyonu**

```octave
x = 0:0.1:2*pi;
figure; % Animasyon için yeni pencere

for t = 0:0.1:10
    % Zamanla değişen sinüs dalgası
    y = sin(x - t);

    % Grafiği çiz
    plot(x, y, 'LineWidth', 2);
    
    % Eksenleri sabit tut
    axis([0, 2*pi, -1.2, 1.2]);
    
    title(['İlerleyen Dalga (Zaman = ', num2str(t, '%.1f'), 's)']);
    xlabel('Konum');
    ylabel('Genlik');
    
    % Grafiği güncelle
    drawnow;
    
    % Animasyonu yavaşlatmak için kısa bir duraklama
    pause(0.05);
end
```

### Grafik Özelliklerini `get` ve `set` ile Değiştirme

Octave'de oluşturulan her grafik bir nesnedir ve bu nesnenin özellikleri (rengi, çizgi kalınlığı, yazı tipi boyutu vb.) `get` ve `set` komutları ile dinamik olarak sorgulanabilir ve değiştirilebilir.

`gca` (get current axes) ve `gcf` (get current figure) komutları sırasıyla mevcut eksen ve şekil nesnelerine bir "handle" (tanıtıcı) döndürür.

**Örnek: Grafik Özelliklerini Dinamik Olarak Ayarlama**

```octave
x = linspace(0, 2*pi, 100);
y = sin(x);

% Grafiği çiz ve çizgiye bir handle ata
h_plot = plot(x, y);

% Mevcut eksenlere bir handle ata
h_axes = gca;

% 'get' ile çizginin mevcut rengini öğren
original_color = get(h_plot, 'Color');
fprintf('Orijinal çizgi rengi: [%.1f, %.1f, %.1f]\n', original_color);

% 'set' ile çizgi ve eksen özelliklerini değiştir
set(h_plot, 'LineWidth', 4, 'Color', 'red', 'LineStyle', '--');
set(h_axes, 'FontSize', 14, 'FontWeight', 'bold', 'GridColor', 'blue');

title('set ile Değiştirilmiş Grafik');
xlabel('X Ekseni');
ylabel('Y Ekseni');
grid on;
```

---
[Ana Sayfaya Dön](./)