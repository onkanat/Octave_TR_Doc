
% Ana program akışı:
##moment = input('Momenti giriniz (Nm): ');
##mesafe = input('Tarafsız eksene mesafeyi giriniz (m): ');
##atalet = input('Atalet momentini giriniz (m^4): ');
##
##max_gerilme = hesapla_gerilme(moment, mesafe, atalet);
##fprintf('Maksimum Eğilme Gerilmesi: %.2f Pascal\n', max_gerilme);

p1 = [1 0];  % First point
p2 = [0 1];  % Second point
p3 = [0 -1];  % Third point
center = circle_center(p1, p2, p3);
disp(center);  % Output: [2 1.5]

start_point = [0 0];
end_point = [1 1];
line = 2point_line(start_point,end_point);
disp(line);
