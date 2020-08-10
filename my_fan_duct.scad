fan_degree = 30;
    fan_size = 40;
cube_x = 60;

m_c = 9-1;
m_beta = fan_degree;
m_alpha=180-90-m_beta;
m_a = cos(m_beta)*m_c;
m_b = sin(m_beta)*m_c;

difference() {
    body();
    translate([0, 0, 14]) rotate([-90, 0, 0]) cylinder(h=50, d=24);
}

module body() {
    body_half();
    mirror([1, 0, 0]) body_half();
}

module body_half() {
    translate([cube_x/2-cos(m_alpha)*fan_size, 0, 0]) rotate([0, fan_degree, 0]) 40mm_fan_frame();
    //translate([0, 5, cos(m_beta)*fan_size-m_a]) cube([cube_x/2, fan_size, 20]);

    translate([0, 1, 0]) rotate([90, 0, 0]) linear_extrude(height=1)
        polygon(points=[
            [0,0],
            [0, cos(m_beta)*fan_size-m_a],
            [cube_x/2-m_b,cos(m_beta)*fan_size-m_a],
            [cube_x/2-cos(m_alpha)*fan_size,0]
        ]);
}

module 40mm_fan_frame() difference() {
    screw = (fan_size-32)/2;
    cube([1, fan_size, fan_size]);
    translate([0, fan_size/2, fan_size/2]) rotate([0, 90, 0]) cylinder(h=1, d=fan_size-1*2);
    translate([0, screw, screw]) rotate([0, 90, 0]) cylinder(h=1, d=3);
    translate([0, fan_size-screw, screw]) rotate([0, 90, 0]) cylinder(h=1, d=3);
    translate([0, screw, fan_size-screw]) rotate([0, 90, 0]) cylinder(h=1, d=3);
    translate([0, fan_size-screw, fan_size-screw]) rotate([0, 90, 0]) cylinder(h=1, d=3);
}