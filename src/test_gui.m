%test_gui.m
% GUI test.m dosyasını açar. çalıştırır. ve sonuçları ekrana çizer.

load('test.m');
gui_main;

plot(circle_center(p1, p2, p3));
plot(2point_line(start_point,end_point));

