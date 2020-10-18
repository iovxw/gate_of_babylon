fan_degree = 30;
fan_size = 40;
cube_x = 60;
cube_y = 40;

nozzle_height = 6; //3-1;
screw_y_offset = 5.0;

m_c = 9-1;
m_beta = fan_degree;
m_alpha=180-90-m_beta;
m_a = cos(m_beta)*m_c;
m_b = sin(m_beta)*m_c;

a();
//a(false);
//b();

module b() {
    translate([0, 0, -(40-(cos(m_beta)*fan_size-m_a))]) {
        air_nozzle();
    }
}

module a(left=true) {
    if(left) {
        a_half(true);
    } else {
        mirror([0, 1]) a_half();
    }
}

module a_half(cable_void) {
    difference () {
        union() {
            //rotate_fan() cube([1, cube_y, fan_size]);
            mirror([1, 0, 0]) rotate_fan() cube([3, 8.5, fan_size]);
            infill();
            fan_mount();
        }
        translate([0, (cube_y-fan_size)/2]) {
            rotate_fan() translate([1, 0]) mirror([1, 0]) 40mm_fan_void();
            mirror([1, 0, 0]) rotate_fan() mount_screw_void();
            air_void();
        }
        
        if(cable_void) {
            mirror([1, 0]) hull() {
                translate([5, 3]) cube([15, (fan_size-25)/2, 0.00000001]);
                translate([30, 3, cos(m_beta)*fan_size-m_a]) cube([15, (fan_size-25)/2, 0.0000001]);
            }
        }
        
        // cut bottom
        d = cube_y-3*2;
        h = (cos(m_beta)*fan_size-m_a)-25;
        translate([0, cube_y/2]) hull() {
            cylinder(d = d, h = h);
            translate([-d, -d/2, -99]) cube([d, d, h+99]);
        }
        translate([0, cube_y/2, -h]) hull() {
            cylinder(d = d+20, h = h);
        }
    }
}


module fan_mount() {
    difference() {
        translate([-fan_size/2, 0, -(40-(cos(m_beta)*fan_size-m_a))]) {
            40mm_blower_fan_mount();
        }
        rotate_fan() translate([0, 0]) cube([10, cube_y, fan_size]);
        //mirror([1, 0, 0]) rotate_fan() translate([1, 0]) cube([99, cube_y, fan_size]);
    }
}

module rotate_fan() {
    translate([cube_x/2-cos(m_alpha)*fan_size, 0, 0]) rotate([0, fan_degree, 0])
    children();
    //translate([0, 5, cos(m_beta)*fan_size-m_a]) cube([cube_x/2, fan_size, 20]);
}

module infill() {
    side();
    side(h=cube_y/2);
}

module side(h=1) {
    translate([0, h, 0]) rotate([90, 0, 0]) linear_extrude(height=h)
        polygon(points=[
            [-(cube_x/2-cos(m_alpha)*fan_size), 0],
            [-(cube_x/2-m_b), cos(m_beta)*fan_size-m_a],
            [cube_x/2-m_b, cos(m_beta)*fan_size-m_a],
            [cube_x/2-cos(m_alpha)*fan_size, 0]
        ]);
}

module air_void() {
    hull() {
        translate([cube_x/2-cos(m_alpha)*fan_size, 0, 0]) rotate([0, fan_degree, 0]) {
            translate([0, fan_size/2, fan_size/2]) rotate([0, 90, 0])
                mirror([0, 0, 1]) cylinder(h=0.0000000001, d=fan_size-1*2);
        }
        translate([0, (fan_size-23)/2, (cos(m_beta)*fan_size-m_a)-25]) cube([0.00000001, 23, 25]);
    }
    translate([-100, (fan_size-23)/2, 0]) cube([100, 23, (cos(m_beta)*fan_size-m_a)]);
    
    
}

module 40mm_fan_void() {
    screw = (fan_size-32)/2;
    screw_depth = 5;
    translate([0, fan_size/2, fan_size/2]) rotate([0, 90, 0]) cylinder(h=1, d=fan_size-1*2);
    
    translate([0, screw, screw]) rotate([0, 90, 0]) cylinder(h=screw_depth, d=3, $fn=6);
    translate([0, fan_size-screw, screw]) rotate([0, 90, 0]) cylinder(h=screw_depth, d=3, $fn=6);
    translate([0, screw, fan_size-screw]) rotate([0, 90, 0]) cylinder(h=screw_depth, d=3, $fn=6);
    translate([0, fan_size-screw, fan_size-screw]) rotate([0, 90, 0]) cylinder(h=screw_depth, d=3, $fn=6);
}

module mount_screw_void() {
    screw = (fan_size-32)/2;
    screw_depth = 3;
    $fn = 20;
    d = 3.1;
    translate([0, screw, fan_size-screw]) rotate([0, 90, 0]) cylinder(h=screw_depth, d=d);
    translate([0, fan_size-screw, fan_size-screw]) rotate([0, 90, 0]) cylinder(h=screw_depth, d=d);
}

module 40mm_blower_fan_mount() {
    screw = (fan_size-35)/2;
    base_thickness = 0;

    translate([0, 0, screw_y_offset]) cube([fan_size, base_thickness, fan_size-screw_y_offset]);
    /*
    translate([screw, 0, screw]) rotate([90, 0]) cylinder(h=1, d=2);
    translate([fan_size-screw, 0, screw]) rotate([90, 0]) cylinder(h=1, d=2);
    translate([screw, 0, fan_size-screw]) rotate([90, 0]) cylinder(h=1, d=2);
    translate([fan_size-screw, 0, fan_size-screw]) rotate([90, 0]) cylinder(h=1, d=2);
    */

    h = fan_size-screw_y_offset;
    translate([fan_size-3, -10, fan_size-screw_y_offset]) cube([3, 10-3.5, screw_y_offset]);
    translate([0, -10, fan_size-screw_y_offset]) cube([3, 10-3.5, screw_y_offset]);
    difference() {
        thickness = 7;
        translate([0, -10, screw_y_offset]) {
            translate([fan_size, 0, 0]) cube([thickness, 10+base_thickness, h]);
            //translate([fan_size-4, -3, screw_y_offset]) cube([4+thickness, 3, 6]);
            
            translate([-thickness, 0, 0]) cube([thickness, 10+base_thickness, h]);
            //translate([-thickness, -3, screw_y_offset]) cube([4+thickness, 3, 6]);
        }
        /*translate([0, (-10)/2, fan_size-screw_y_offset]) {
            translate([-3/2-bottom_thickness, 0]) m3_screw();
            translate([fan_size+3/2+bottom_thickness, 0]) m3_screw();
        }*/
        translate([0, (-10)/2, screw_y_offset]) rotate([180, 0]) {
            translate([-3/2-1, 0]) m3_screw();
            translate([fan_size+3/2+1, 0]) m3_screw();
        }
    }
}

module m3_screw(x) {
    if(x) {
        translate([0, 0, -7]) cylinder(h=7, d=3.1, $fn=20);
    } else {
        translate([0, 0, -7]) cylinder(h=7, d=3, $fn=6);
    }
    cylinder(h=99, d=7, $fn=50);
}

module air_nozzle() {
    length = 10;
    thickness=7;
    min_thickness=3;
    width1 = 28;
    width2 = 10;
    bottom_thickness=0.3;
    
    difference() {
        body();
        
        mount_hole();
        mirror([1, 0]) mount_hole();
    }
    //nozzle();
    
    module nozzle() translate([0, 0, -nozzle_height]) difference() {
        t = 1;
        d = 1;
        union() {
            hull() {
                translate([-width1/2-t, 0]) cube([width1+2*t, 0.0000001, 2+t]);
                translate([-width1/2, 1]) cube([width1, 0.0000001, 2+t]);
                translate([-width2/2-t, length-2]) cube([width2+2*t, 0.0000001, 2+t]);
            }
            hull() {
                translate([-width2/2-t, length-2]) cube([width2+2*t, 0.0000001, 2+t]);
                translate([-width2/2-t, length, -d]) cube([width2+2*t, 0.0000001, 2+t]);
            }
        }

        translate([0, 0, bottom_thickness]) {
            hull() {
                translate([-width1/2, 0]) cube([width1, 0.0000001, 2-bottom_thickness]);
                translate([-width2/2, length-2]) cube([width2, 0.0000001, 2-bottom_thickness]);
            }
            hull() {
                translate([-width2/2, length-2, -bottom_thickness]) cube([width2, 0.0000001, 2]);
                translate([-width2/2, length, -d]) cube([width2, 0.0000001, 2-bottom_thickness]);
            }
        }
        
        translate([-99/2, -99/2, -99]) cube(99);
    }
        
    module body() {
        translate([-fan_size/2, 0]) difference() {
            union() {
                translate([0, -10-1, -nozzle_height]) cube([fan_size, 10+1*2, nozzle_height+screw_y_offset]);
            }
            translate([0, -10, 0]) cube([fan_size, 10, screw_y_offset]);

            translate([(fan_size-28)/2, -10, 0]) {
                translate([0, nozzle_height-bottom_thickness, -nozzle_height+bottom_thickness])
                    cube([28, 10-(nozzle_height-bottom_thickness), nozzle_height-bottom_thickness]);
                translate([0, 10, -nozzle_height])
                    cube([28, 1, 2]);
                translate([0, nozzle_height-bottom_thickness]) intersection() {
                    translate([0, -nozzle_height+bottom_thickness, -nozzle_height+bottom_thickness]) cube([28, 10, nozzle_height-bottom_thickness]);
                    rotate([0, 90]) cylinder(r=nozzle_height-bottom_thickness, h=28, $fn=30);
                }
            }
        }
    
        mount();
        mirror([1, 0]) mount();
    }
    
    module mount() {
        translate([-fan_size/2-thickness, -10-1, -nozzle_height]) cube([thickness, 10+2, screw_y_offset+nozzle_height]);
        translate([-fan_size/2, -10, 0]) cube([3, 10-3.5, screw_y_offset]);
   }
        
    module mount_hole() difference() {
        translate([-fan_size/2, (-10)/2, screw_y_offset-2]) rotate([180, 0]) {
            translate([-3/2-1, 0]) m3_screw(true);
        }
    }
    module p() polygon([[-28/2, 0], [-5, length], [5, length], [28/2, 0]]);
}