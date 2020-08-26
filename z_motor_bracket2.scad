thickness=5;


// 8

screw=(42.3-31)/2;
padding=(23+1)-42.3/2;

difference() {
    hull() {
        cube([42.3+thickness*2, 42.3+20+padding, 20+thickness]);
        translate([0, 0, 20+thickness]) cube([42.3+thickness*2, 20, 10]);
    }
    translate([thickness, 20+padding, 0]) holes(20+thickness,10);
    
    translate([thickness+screw, 20/2, 20]) cylinder(d=5,h=thickness);
    translate([thickness+42.3-screw, 20/2, 20]) cylinder(d=5,h=thickness);
    translate([thickness+screw, 20/2, 20+thickness]) cylinder(d=8,h=10);
    translate([thickness+42.3-screw, 20/2, 20+thickness]) cylinder(d=8,h=10);
    
    cube([42.3+thickness*2, 20, 20]);
    translate([thickness, 20+padding, 0]) cube([42.3, 42.3, 20]);
    mirror([0, 0, 1]) rotate([0, 90, 0]) linear_extrude(height=42.3+thickness*2)
        polygon([[0, 20+padding], [20, 20+padding+42.3+0.0001], [0, 20+padding+42.3+0.0001]]);
}

/*
difference() {
    cube([20, 35, thickness]);
    translate([20/2, 24, 0]) cylinder(d=8.5, h=thickness);
}*/

module holes(h1, h2) {
    translate([42.3/2, (42.3)/2, 0]) cylinder(d=22, h=h1+h2);
    
    translate([screw, screw, 0]) cylinder(d=3,h=h1);
    translate([42.3-screw, 8, 0]) cylinder(d=3,h=h1);
    translate([screw, 42.3-screw, 0]) cylinder(d=3,h=h1);
    translate([42.3-screw, 42.3-screw, 0]) cylinder(d=3,h=h1);
    
    translate([screw, screw, h1]) cylinder(d=7,h=h2);
    translate([42.3-screw, 8, h1]) cylinder(d=7,h=h2);
    translate([screw, 42.3-screw, h1]) cylinder(d=7,h=h2);
    translate([42.3-screw, 42.3-screw, h1]) cylinder(d=7,h=h2);
}