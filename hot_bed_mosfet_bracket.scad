// 38
// 48
$fn=20;

module mount() {
    translate([(50+2)/2, (60+2)/2]) {
        difference() {
            translate([0, 0, 10/2]) cube([50+2, 60+2, 10], center=true);
            translate([0, 0, 10/2+1/2]) cube([50, 60, 10-1], center=true);
            translate([0, -0.5, 10/2+1/2]) cube([40, 61, 10-1], center=true);
            //cube([50-4, 60-5, 2], center=true);
            hole();
            mirror([1, 0, 0]) hole();
            mirror([0, 1, 0]) hole();
            mirror([1, 0, 0]) mirror([0, 1, 0]) hole();
        }

        x();
        mirror([1, 0, 0]) x();
        mirror([0, 1, 0]) x();
        mirror([1, 0, 0]) mirror([0, 1, 0]) x();
    }
    
    module x() translate([50/2-2.5-3/2, 60/2-2.6-3/2, 1]) difference() {
        cylinder(d=3+2, h=3);
        cylinder(d=3, h=3);
    }

    module hole() translate([50/2-2.5-3/2, 60/2-2.6-3/2, 0]) 
        cylinder(d=3, h=3);
}

mount();
translate([50+2, 0, 0]) difference() {
    cube([20,60+2, 4]);
    //translate([20/2, (60+2)/2, 0]) cylinder(d=5, h=4);
    translate([20/2, (60+2)-10, 0]) cylinder(d=5, h=4);
    translate([20/2, 10, 0]) cylinder(d=5, h=4);
}
    
