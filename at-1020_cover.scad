thickness = 0.8;

d = 21.8+0.1;

//part_a();
//part_b();
//part_c();
part_d();

module part_d() {
    $fn = 100;
    d=50+0.2;
    difference() {
        cylinder(d=d+thickness*2, h=5);
        translate([0, 0, thickness]) cylinder(d=d, h=5);
        cylinder(d=d-5, h=5);
    }
}

module part_c() {
    $fn = 100;
    translate([0, (20+thickness*2)/2]) difference() {
        cylinder(d=20+thickness*2, h = 10);
        cylinder(d=20, h=10);
        for(i=[0:7]) {
            if (i != 0) {
                rotate([0, 0, 360/8*i])
                    translate([0, 0, 10/2])
                    rotate([90, 0])
                    cylinder(h=99.99, d = 6, $fn = 30);
            }
        }
    }
    difference() {
        translate([0, (50)/2]) cylinder(d=50, h=10);
        translate([0, (50)/2, thickness]) cylinder(d=50-thickness*2, h=10);
        translate([0, (20+thickness*2)/2]) cylinder(d=20, h = 10);
    }
    /*difference() {
        hull() {
            translate([0, (20+thickness*2)/2]) cylinder(d=20+thickness*2, h=10);
            translate([0, (50+thickness*2)/2, 10]) cylinder(d=50+thickness*2, h=5);
        }
        hull() {
            translate([0, (20+thickness*2)/2]) cylinder(d=20, h=10);
            translate([0, (50+thickness*2)/2, 10]) cylinder(d=50, h=5);
        }
    }*/
}

module part_b() {
    $fn = 100;
    base();
    difference() {
        cylinder(d=20, h=10);
        cylinder(d=20-thickness*2, h = 10);
        for(i=[0:7]) {
            rotate([0, 0, 360/8*i])
                translate([0, 0, 10/2])
                rotate([90, 0])
                cylinder(h=99.99, d = 6, $fn = 30);
        }
    }
}

module part_a() {
    base();
    translate([0, 0, -6]) linear_extrude(height = 6) difference() {
        circle(d=d, $fn=100);
        circle(d=d-thickness*2, $fn=100);
        translate([-8/2, 0]) square([8, 99]);
    }
}

module base() difference() {
    translate([-d/2-10, -d/2-2.5]) cube([d+2+10, d+2.5+0.8, 0.6]);
    cylinder(d=7.5, h = 9.9, $fn = 50);
}