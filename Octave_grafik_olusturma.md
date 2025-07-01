
---
layout: default
title: Octave'da Grafik Oluşturma
---
# Octave'da Grafik Oluşturma

Octave, matematiksel işlevleri ve verileri görselleştirmek için güçlü bir grafik oluşturma araçlarına sahiptir. Temel grafik işlevleri şunlardır:

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

Octave'ın grafik oluşturma araçları hakkında daha fazla bilgi için resmi belgelere bakabilirsiniz: [https://sourceforge.net/projects/octave/](https://sourceforge.net/projects/octave/)

**Ek Örnekler:**

* [https://octplot.sourceforge.net/quiver.html](https://octplot.sourceforge.net/quiver.html)
* [https://sourceforge.net/projects/octave/](https://sourceforge.net/projects/octave/)
* [https://stackoverflow.com/questions/13507700/how-to-plot-two-functions-on-one-graph](https://stackoverflow.com/questions/13507700/how-to-plot-two-functions-on-one-graph)
