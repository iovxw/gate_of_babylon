e3d_d=22.7-0.7;
e3d_h=26-1;

$fn=200;

difference() {
    union() {
        wall();
        clip();
    }
    translate([-100/2, -10-6, 0]) cube([100, 10, 100]);
}


module wall() difference() {
    hull() {
        cylinder(d=e3d_d+1*2, h=e3d_h);

        translate([-40/2, e3d_d/2, 0.1]) 
            rotate([-30, 0, 0])
            cube([40, 0.1, 40]);
    }
    
    // inner
    difference() {
        hull() {
            difference() {
                cylinder(d=e3d_d, h=e3d_h);
                translate([-100/2, -e3d_d+5, 0]) cube([100, e3d_d, 100]);
            }
            translate([-(40-2)/2, e3d_d/2, 0]) 
                rotate([-30, 0, 0])
                cube([(40-2), 1, (40-2)]);
        }
        translate([-100/2, -100/2, 0]) cube([100, 100, 1]);
        translate([-100/2, -100/2, e3d_h-1]) cube([100, 100, 100]);
    }
    cylinder(d=e3d_d, h=e3d_h);
    
    // limit height
    translate([-100/2, -100/2, e3d_h]) cube([100, 100, 100]);
    
}

module clip() difference() {
    cylinder(d=e3d_d+1*2, h=e3d_h);
    cylinder(d=e3d_d, h=e3d_h-1.5-0.5);
    translate([0, 0, e3d_h-0.5]) cylinder(d=e3d_d, h=e3d_h);
    cylinder(d=e3d_d-1.5*2, h=e3d_h);
    translate([-100/2, 5, 0]) cube([100, 100, 100]);
}

/*
translate([0, e3d_d/2, (40-1*2)/2])
    rotate([-35, 0, 0])
    translate([0, 10, 0])
    rotate([90, 0, 0])
    cylinder(d=40-1*2, h=10);
    */