thickness = 1;

translate([0, 0, -thickness-3]) cube([40, 40, thickness]);
translate([0, 0, -3]) difference() {
    translate([0, 0, 0]) cube([40, 40, 3]);
    translate([0.5, 0.5, 0]) cube([40-0.5*2, 40-0.5*2, 3]);
}

translate([(40-20)/2, 40, -thickness-3]) cube([20, thickness, 10+3+thickness]);

translate([(40-20)/2, -thickness, -thickness-3]) cube([20, thickness, 10+1+3+thickness]);
translate([(40-20)/2, -thickness, 10+1]) cube([20, thickness+1, thickness]);
