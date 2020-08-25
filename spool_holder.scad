use <threadlib/threadlib.scad>

// spool height = 70

$fn = 200;

spool_bolt();
// spool_nut();

module spool_nut(nut_height = 70) {
    specs = thread_specs("G1 1/4-int");
    P = specs[0]; Rrot = specs[1]; Dsupport = specs[2];
    section_profile = specs[3];
    difference() {
        cylinder(h=nut_height, d=53);
        cylinder(h=nut_height, d=Dsupport);
    }
    translate([0, 0, P/2]) nut("G1 1/4", turns=(nut_height-P)/P);
}

module spool_bolt() {
    specs = thread_specs("G1 1/4-ext");
    P = specs[0]; Rrot = specs[1]; Dsupport = specs[2];
    section_profile = specs[3];
    echo(Dsupport);
    
    difference() {
        union() {
            translate([0, 0, P/2]) bolt("G1 1/4", turns=2.5);
            
            intersection() {
                translate([0, 0, -5]) cylinder(h=5, d=53+10, $fn=6);
                translate([0, 0, 25]) sphere(d=53+10+20);
            }
        }
        cylinder(d=Dsupport-2, h=100, center=true);
    }

}