use <threadlib/threadlib.scad>


specs = thread_specs("G1/2-ext");
P = specs[0]; Rrot = specs[1]; Dsupport = specs[2];
section_profile = specs[3];
difference() {
    union() {
        translate([0, 0, P/2]) bolt("G1/2", turns=5);

        translate([0, 0, -2])
            cylinder(h=2, d=Dsupport, $fn=120);
        translate([-25/2, -25/2, -2-10])
            chamfered([25, 25, 10]);
    }
    translate([0, 0, -2-10-1.5])
        cylinder(h=20, d=3, $fn=20);
}

module chamfered(size, d=1.5){
    hull(){
        translate([d, d, -d])cube(size-2*[d, d, 0]);
        translate([0, d, 0])cube(size-2*[0, d, 0]);
        translate([d, 0, 0])cube(size-2*[d, 0, 0]);
    }
}