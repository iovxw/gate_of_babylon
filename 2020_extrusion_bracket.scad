width=6.4;

module x() 
    translate([-10/2, 0, 0])
    rotate([90, 0, 90])
    linear_extrude(height=10)
    polygon(points=[
        [0, 3/2-0.5],
        [0, width/2-1], 
        [1.55, width/2-1],
        [1.55, width/2],
        [5, width/2],
        [5, 0+0.07],
        [5-4, 0+0.07]
    ]);

x();
mirror([0, 0, 1]) x();


difference() {
    union() {
        difference() {
            translate([0, -3/2, 0]) cube([10, 3, 20], center=true);
            translate([0, 6-1, 0]) rotate([90, 0, 0]) m3_screw();
        }
    }
    
        translate([0, 1.55/2, 0]) cube([10, 1.55, 3], center=true);
}


module m3_screw() {
    $fn=100;
    cylinder(h=6, d=3);
    translate([0, 0, 6]) cylinder(h=10, d=6);
}
