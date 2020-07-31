$fn=500;

difference() {
    body();
    rotate([0, 0, 45/2]) translate([0, -3/2, 0]) cube([1000, 3.5, 10]);
    translate([0, 0, 7]) rotate([0, 90, 45/2]) cylinder(d=7, h=1000);
}

difference() {
    union(){
        for(i=[1:6]) {
            rotate([0, 0, 360/6*i]) cube([141/2, 1, 35]);
        }
        cylinder(d=12+4, h=50);
    }
    cylinder(d=12, h=50);
}



module body() {
    difference() {
        hull() {
            cylinder(d=141+4, h=35+10, $fn=40);
            cylinder(d=141+4+20, h=1, $fn=8);
        }
        cylinder(d=141, h=35+10);
    }
    difference() {
        cylinder(d=141, h=35);
        cylinder(d1=141, d2=141-10, h=35);
    }
}
