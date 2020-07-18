half();
mirror([1,0,0]) half();

module f() {
    translate([0,0,-3]) rotate([57,0,0]) cube([80,15,15]);
}

module half() {
    difference() {
        union() {
            f();
            mirror([0,0,1]) f();
        }
        translate([-10.1,0,-15]) cube([100, 10, 20.1]);
        translate([-10.1,-1,5]) cube([100, 15, 20]);
        
        translate([70,-5,-5]) rotate([0,270,90]) {
            $fn=100;
            cylinder(h=20, r=4, center=false);
            cylinder(h=50, r=2.5, center=true);
        }
    }
}
