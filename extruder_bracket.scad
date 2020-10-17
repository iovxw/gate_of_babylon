thickness = 5;

deg = 45;
motor = [42.3, 42.3, 40];

m3_square_nut=[5.4, 5.4, 2.4];

extra=5;

$fn=50;

main();
extra_infill();

module extra_infill() {
    n=0.8;
    translate([0, 0, motor[2]]) {
        motor_holes(thickness);
        translate([motor[0]/2, motor[0]/2, 0]) rotate([0, 0, 45]) translate([-motor[0]/2, -motor[0]/2, 0]) extruder_holes(thickness);
    }
    module motor_holes(h) {
        screw=(motor[0]-31)/2;
        screw_head_h=2;
        
        translate([screw, screw, 0]) hole();
        translate([motor[0]-screw, screw, 0]) hole();
        translate([screw, motor[0]-screw, 0]) hole();
        translate([motor[0]-screw, motor[0]-screw, 0]) hole();

        module hole() difference() {
            cylinder(d=7+n*2,h=h-screw_head_h);
            cylinder(d=3,h=h,$fn=20);
        }
    }

    module extruder_holes(h) {
        screw=(motor[0]-31)/2;

        translate([screw, screw, 0]) nut_hole();
        translate([motor[0]-screw, screw, 0]) nut_hole();
        translate([screw, motor[0]-screw, 0]) nut_hole();
        translate([motor[0]-screw, motor[0]-screw, 0]) nut_hole();
        
        module nut_hole() difference() {
            rotate([0, 0, 45]) translate([-m3_square_nut[0]/2-n, -m3_square_nut[0]/2-n, m3_square_nut[2]])
                cube([m3_square_nut[0]+n*2, m3_square_nut[1]+n*2, h-m3_square_nut[2]]);
            cylinder(d=3,h=h,$fn=20);
        }
    }
}

module main() {
    difference() {
        hull() {
            translate([-extra, -extra, motor[2]]) cube([motor[0]+extra*2, motor[0]+extra, thickness]);
            translate([-extra, motor[0], 20]) hull() {
                cube([motor[0]+extra*2,20,thickness]);
                cube([motor[0]+extra*2,thickness,20+thickness]);
            }
        }
        translate([0, 0, motor[2]]) {
            motor_holes(thickness);
            translate([motor[0]/2, motor[0]/2, 0]) rotate([0, 0, 45]) translate([-motor[0]/2, -motor[0]/2, 0]) extruder_holes(thickness);
        }
        translate([5, motor[0]+20/2, 20]) {
            cylinder(d=5, h=motor[2]-20+thickness, $fn=30);
            translate([0, 0, thickness]) cylinder(d=8.5, h=motor[2]-20, $fn=50);
            translate([-8.5/2, -8.5/2, thickness]) cube([8.5, 8.5, motor[2]-20]);
            translate([-8.5/2, -8.5/2, thickness+5]) cube([8.5, 8.5+99, motor[2]-20]);
        }
        translate([motor[0]-5, motor[0]+20/2, 20]) {
            cylinder(d=5, h=motor[2]-20+thickness, $fn=30);
            translate([0, 0, thickness]) cylinder(d=8.5, h=motor[2]-20, $fn=50);
            translate([-8.5/2, -8.5/2, thickness]) cube([8.5, 8.5, motor[2]-20]);
            translate([-8.5/2, -8.5/2, thickness+5]) cube([8.5, 8.5+99, motor[2]-20]);
        }
    }
}

module motor_holes(h) {
    screw=(motor[0]-31)/2;
    screw_head_h=2;
    translate([motor[0]/2, motor[0]/2, 0]) cylinder(d=22, h=h, $fn=100);
    
    translate([screw, screw, 0]) hole();
    translate([motor[0]-screw, screw, 0]) hole();
    translate([screw, motor[0]-screw, 0]) hole();
    translate([motor[0]-screw, motor[0]-screw, 0]) hole();

    module hole() {
        cylinder(d=3,h=h,$fn=20);
        translate([0, 0, h-screw_head_h]) cylinder(d=7,h=screw_head_h);
    }
    
    translate([0, 0, -motor[2]]) cube(motor);
}

module extruder_holes(h) {
    screw=(motor[0]-31)/2;

    translate([screw, screw, 0]) nut_hole();
    translate([motor[0]-screw, screw, 0]) nut_hole();
    translate([screw, motor[0]-screw, 0]) nut_hole();
    translate([motor[0]-screw, motor[0]-screw, 0]) nut_hole();
    
    module nut_hole() {
        rotate([0, 0, 45]) translate([-m3_square_nut[0]/2, -m3_square_nut[0]/2, 0]) cube(m3_square_nut);
        cylinder(d=3,h=h,$fn=20);
        rotate([0, 0, 45]) translate([-m3_square_nut[0]/2, -m3_square_nut[0]/2, -m3_square_nut[2]]) cube(m3_square_nut);
    }
}