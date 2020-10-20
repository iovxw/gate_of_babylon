// 12.9
// 5.8

 translate([5, 43]) rotate([0, 0, -90]) micro_switch_frame();

translate([0, 0, 0.5]) x();

translate([-3, 0, -0.5]) cube([20, 45, 0.5]);

module x() {
    cube([3, 20, 10+2]);
    cube([15, 20, 2]);
    cube([3, 40, 2]);
    translate([3, 40-4]) cube([1, 4, 5]);
    translate([-3, 40-6]) cube([3, 0.6, 2]);
    translate([-3, 40-6, -0.5]) cube([1, 2, 2+0.5]);
}

module micro_switch_frame(thickness=1) {
    micro_switch=[12.9, 6.6, 5.8];
    micro_switch_foot_area=[11.5, 4, micro_switch[2]];
    micro_switch_button_offset=2;

    difference() {
        translate([-thickness, -thickness, 0]) cube(micro_switch+[thickness*2, thickness*2, 0]);
        cube(micro_switch);
        translate([(micro_switch[0]-micro_switch_foot_area[0])/2, micro_switch[1], 0])
            cube(micro_switch_foot_area);
        translate([micro_switch_button_offset, -2, 0]) cube(micro_switch[2]);
    }
}

/*module cap(hole_pos=[2, 2],
    hole_d=2, 
    min_thickness=1,
    trigger_width=4,
    trigger_thickness=2,
    height=7,
    width=20,
    length=30) {

    translate([0, 0, height]) rotate([0, 90, 0]) 
        linear_extrude(height=width)
            difference() {
                polygon([[0, 0], [0, length], [min_thickness, length], [height, 0]]);
                translate(hole_pos) circle(d=hole_d, $fn=20);
            }
    translate([(width-trigger_width)/2, -trigger_thickness, 0]) 
        cube([trigger_width, trigger_thickness, height]);
}*/