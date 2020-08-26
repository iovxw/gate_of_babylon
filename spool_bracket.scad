$fn = 200;

main();
//cap();

module main() {
    difference() {
        cylinder(r = 11-0.3, h = 100+3+8, $fn = 200);
        translate([0, 0, 100+3+8-35]) cylinder(r = 1.5, h = 35);
    }
    base(h = 8);
}

module cap(height=6) {
    difference() {
        cylinder(r = 7/2+1, h = height);
        translate([0,0,1]) cylinder(r = 7/2, h = height);
        cylinder(r = 3/2, h = height);
    }
    module stopper() translate([8/2-1,0,0]) difference() {
        cylinder(r = 6.5+1, h = height);
        translate([0,0,0]) cylinder(r = 6.5, h = height);
        translate([-10,0,0]) cube([15,10,height]);
    }
    stopper();
    //mirror([0,1,0]) mirror([1,0,0]) stopper();
}

module base(h) {
    module half() {
        module chamfered_half(size, d=1){
           hull(){
             translate([d, 0, 0])cube(size-2*[d, d/2, 0]);
             translate([0, 0, 0])cube(size-2*[0, d/2, d/2]);
             translate([d, 0, 0])cube(size-2*[d, 0, d/2]);
           }
        }

        difference() {
            translate([-10, 0, 0]) chamfered_half([20, 30, h], d = 2);
            translate([0, 20, h-4]) cylinder(r = 4, h = h-4);
            translate([0, 20, 0]) cylinder(r = 2.5, h = 4);
        }
    }

    half();
    mirror([0, 1, 0]) half();
}