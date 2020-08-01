$fn=500;

body();
inner();

module inner() difference() {
    union(){
        for(i=[1:4]) {
            rotate([0, 0, 360/4*i]) translate([0, -3/2, 0]) cube([124/2-1, 3, 14+1]);
        }
        for(i=[1:4]) {
            rotate([0, 0, 360/4*i]) translate([0, 41, 0]) cylinder(d=3+3, h=14+1, $fn=20);
        }
        cylinder(d=12+4, h=40, $fn=100);
    }
    cylinder(d=12, h=50, $fn=100);
        for(i=[1:4]) {
            rotate([0, 0, 360/4*i]) translate([0, 41, 0]) cylinder(d=3, h=999, $fn=20);
        }
}

module body() {
    difference() {
        cylinder(d=124, h=14);
        cylinder(d=124-4, h=14);
        rotate([45, 90, 0]) cylinder(h=124, r=5);
    }
    translate([0, 0, 14]) difference() {
        cylinder(d=141, h=1);
        cylinder(d=124-4, h=1);
    }
    translate([0, 0, 14]) difference() {
        cylinder(d=141+4, h=10);
        cylinder(d=141, h=10);
    }
}
