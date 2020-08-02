module x() minkowski() {
    $fn=50;
    difference() {
        cylinder(d=18, h=50);
        translate([-6, 0, 0]) cylinder(d=28,h=50);
    }
    cylinder(d=1,h=1);
}

n=30;
mirror([0, 1, 0]) for(i=[0:n]) {
    rotate([0, 0, 360/n*i]) translate([0, 30, 0]) rotate([0, 0, 30]) x();
}

difference() {
    $fn=200;
    cylinder(d=80, h=2);
    cylinder(d=56, h=2);
}
translate([0, 0, 50]) difference() {
    $fn=200;
    cylinder(d=80, h=1);
    cylinder(d=56, h=1);
}


for(i=[0:5]) {
    rotate([0, 0, 360/5*i]) cube([56/2, 10, 2]);
}

difference() {
    cylinder(h=20, d=8+2*2);
    cylinder(h=20, d=8);
    translate([0, 0, 7]) rotate([0, 90, 0]) cylinder(h=20, d=3);
}