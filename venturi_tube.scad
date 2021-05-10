$fn = 100;

thickness = 0.8;

h = 11;
d1 = 17.5;
d2 = 8;

holes = 13;

// connector();
tube();

module tube() difference() {
    difference() {
        translate([0, 0, -5]) cylinder(h = h+5, d = d1);
        cylinder(h = 999, d = d2, center = true);
        translate([0, 0, 3/2]) cylinder(h = h-3/2, d1 = d2, d2 = d1);
        translate([0, 0, -5-3/2]) cylinder(h = 5, d1 = d1, d2 = d2);
    }
    translate([0,0, 0]) rotate([90, 0]) cylinder(h = 99, d = 3);
}

module connector() {
    ring(h = 5+5, d1 = 3, d2 = 3-0.8*2, $fn = 50);
    ring(h = 5, d1 = 6, d2 = 3-0.8*2, $fn = 50);
}


module ring(h, d1, d2) difference() {
    cylinder(h = h, d = d1);
    cylinder(h = h, d = d2);
}