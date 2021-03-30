thickness = 1;
h = 15;

linear_extrude(height=2) difference() {
    offset(r = thickness) base();
    base();
}


linear_extrude(height=0.5) x();


translate([0, 0, -15]) {
    difference() {
        linear_extrude(height=h) x();
        translate([0, 0, -0.2]) rotate([6.08, 0]) translate([-999/2, -999/2, -99+h]) cube([999, 999, 99]);
    }
}

module x() {
    difference() {
        offset(r = thickness) base();
        offset(delta = -5) base();
    }
    
    difference() {
        base();
        translate([-80/2, -999]) square([80, 999]);
    }
    difference() {
        base();
        translate([-999/2, -120]) square([999, 120]);
    }
}


module base() {
    half();
    mirror([1, 0]) half();

    module half() 
        translate([0, -297])
        import("half.svg", convexity=3);
}