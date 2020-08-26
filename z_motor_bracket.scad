difference() {
    translate([-5, 0, -20]) cube([42.3+5*2, 42.3+20, 60]);
    translate([0, 0, -40]) motor(h=100);
    translate([-5, 0, 5]) rotate([20, 0, 0]) cube([42.3+5*2, 42.3+20, 30]);
    translate([-5, 0, 0]) mirror([0, 0, 1])
        rotate([asin(20/(sqrt(pow(20, 2)+pow(42.3, 2)))), 0, 0]) 
        cube([42.3+5*2, 42.3+20, 30]);

    //translate([0, 42.3+20, 5]) mirror([0, 1, 0]) rotate([45, 0, 0]) cube([42.3, 42.3+20, 30]);
    translate([-5, 0, tan(20)*42.3+5]) cube([42.3+5*2, 42.3+20, 30]);
    translate([-5, 42.3, -30]) cube([42.3+5*2, 42.3+20, 30]);
    translate([3, 3, 5]) cube([42.3-3*2, 42.3-3*2, 30]);
}



module motor(motor_width = 42.3, motor_height = 40, h=10) {
    screw_spacing = 31;
    screw = (motor_width-screw_spacing)/2;
    cube([motor_width, motor_width, motor_height]);
    translate([screw,screw,motor_height]) cylinder(h=h,r=1.5);
    translate([screw+screw_spacing,screw,motor_height]) cylinder(h=h,r=1.5);
    translate([screw,screw+screw_spacing,motor_height]) cylinder(h=h,r=1.5);
    translate([screw+screw_spacing,screw+screw_spacing,motor_height]) cylinder(h=h,r=1.5);
    translate([motor_width/2,motor_width/2,motor_height]) cylinder(h=h,r=11);
}