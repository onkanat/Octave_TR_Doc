

1;  # script
function h = venn_circle (x, y, r, c)
d = 2 * r;
h = rectangle (...
  "Position", [x - r, y - r, d, d], ...
  "Curvature", [1,1], ...
  "FaceColor", c, ...
  "FaceAlpha", 0.5);
daspect ([1,1,1]);
endfunction

venn_circle (0, 0, 2, "r");
venn_circle (2, 0, 2, "g");
venn_circle (1, 1, 2, "b");
text (0, 0, " community ", ...
  "FontSize", 26, ...
  "Color", "w");
axis off;

print -dpng /Users/hakankilicaslan/Prompts/Octave_TR_Doc/assets/img/venn_diagram.png