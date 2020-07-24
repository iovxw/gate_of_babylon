thikness = 2;

deg = 45;
motor_width = 42.3;
motor_height = 40;

base_length = 100;
base_width = 20;
base_height = 4;

rotate([0, 0, deg]) motor_box();
difference() {
    translate([-50,cos(deg)*motor_width-base_width/2,0]) base();
    rotate([0, 0, deg]) motor();
}

module motor_box() {
    translate([0,0,thikness]) difference() {
        translate([0,0,-thikness]) cube([motor_width+thikness,motor_width+thikness,motor_height+thikness*2]);
        motor();
    }
}

module motor() {
    screw_spacing = 31;
    screw = (motor_width-screw_spacing)/2;
    cube([motor_width, motor_width, motor_height]);
    translate([screw,screw,motor_height]) cylinder(h=10,r=1.5);
    translate([screw+screw_spacing,screw,motor_height]) cylinder(h=10,r=1.5);
    translate([screw,screw+screw_spacing,motor_height]) cylinder(h=10,r=1.5);
    translate([screw+screw_spacing,screw+screw_spacing,motor_height]) cylinder(h=10,r=1.5);
    translate([motor_width/2,motor_width/2,motor_height]) cylinder(h=10,r=11);
}

module base() {
    cube([base_length,base_width,base_height]);
}