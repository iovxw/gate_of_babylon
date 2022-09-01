outer = 56+0.5;
inner = 53;
shell_thickness = 0.8;
edge_d = 30;
edge_r = edge_d/2;
in_h = 10;
in_d = 14;
out_tube_r = 17 / 2 + 0.1;
out_tube_x_offset = 14 + 0.8;

in_port_w = 20;
in_port_thickness = 1;

inner_height = in_h + in_port_thickness;

$fn = 100;

//main();

part_x();

module part_x() {
    thickness = 5;
    port_d = in_d + 2*2;
    port_h = 10;
    
    length = 80;
    
    difference() {
        linear_extrude(height = outer) polygon([[0, 0], [length, 30/2], [0, 30]]);
        
        translate([thickness, 0, thickness]) cube([length-thickness*2, 30, outer-thickness*2]);

        translate([0, 30/2, outer / 2]) rotate([0, 90, 0])
                cylinder(d = port_d, h = port_h+thickness);
    }
}

module part_h() {
    thickness = 0.8;
    port_d = in_d + 2*2;
    port_h = 10;
    difference() {
        union() {
            translate([-thickness, -thickness, -thickness]) 
                cube([130, outer, 1]);
            cube([130, outer, 5] - [thickness*2, thickness*2, 0]);
        }
        translate([thickness, thickness, -thickness])
            cube([130, outer, 9.999] - [thickness*4, thickness*4, 0]);
    }
}

module part_g() {
    thickness = 0.8;
    port_d = in_d + 2*2;
    port_h = 10;
    cube([130, outer, in_d + 2*2 + 5] - [thickness*2+port_h, thickness*2, thickness]);
}

module part_f() {
    thickness = 0.8;
    port_d = in_d + 2*2;
    port_h = 10;
    
            translate([-thickness, -thickness, 0]) 
                cube([130, outer, 2]);
}

module part_e() {
    thickness = 0.8;
    port_d = in_d + 2*2;
    port_h = 10;
    
    difference() {
        union() {
            translate([-thickness, -thickness, 0]) 
                cube([130, outer, 5 + 3] + [thickness*2, thickness*2, thickness]);
        }
        cube([130, outer, 5+ 3]);
        translate([5, 5]) cube([130, outer, 5 + 3] + [-5*2, -5*2, thickness]);
    }
}

module part_d() {
    thickness = 0.8;
    port_d = in_d + 2*2;
    port_h = 10;
    module body() difference() {
        union() {
            translate([-thickness, -thickness, -thickness]) 
                cube([130, outer, in_d + 2*2 + 5]);
        }
        cube([130, outer, in_d + 2*2 + 5] - [thickness*2, thickness*2, thickness]);
    }
    
    difference() {
        union() {
            body();
            translate([0, outer / 2, port_d/2]) rotate([0, 90, 0])
                cylinder(d = port_d+thickness*2, h = port_h);
        }
        translate([-thickness, outer / 2, port_d/2]) rotate([0, 90, 0])
            cylinder(d = port_d, h = port_h+thickness);
    }
}

module part_c() {
    difference() {
        union() {
            translate([-in_port_w/2, -in_port_w/2]) cube([in_port_w, in_port_w, 1]);
            translate([0, 0, -1]) cylinder(d = in_port_w + 10, h = in_port_thickness);
            cylinder(d = in_d + 2*2, h = 10);
        }
        
        cylinder(d = in_d, h = 999, center = true);
    }
}

module part_b() {
    difference() {
        union() {
            translate([-in_port_w/2, -in_port_w/2]) cube([in_port_w, in_port_w, 1]);
            translate([0, 0, -1]) cylinder(d = in_port_w + 10, h = in_port_thickness);
            cylinder(d = in_d + 2*2, h = 10);
            
            linear_extrude(height = 100, twist = 360) difference() {
                circle(d = in_d + 2*2);
                square([6, 99], center = true);
                square([99, 6], center = true);
            }
        }
        
        cylinder(d = in_d, h = 999, center = true);
    }
    
    translate([0, 0, 100]) cylinder(d = in_d + 2*2, h = 2);
}

module main() {
    difference() {
        linear_extrude(height = inner_height) shell_2d();
        translate([out_tube_r - outer/2 + out_tube_x_offset, 0])
            rotate([-90, 0]) cylinder(h = 99, r = out_tube_r);
    }

    translate([0, 0, inner_height]) linear_extrude(height = 1) difference() {
        outer_2d();
        square(in_port_w, center = true);
    }

    snap();
}

module snap() {
    depth = 1.8+0.2;
    x_offset = 1.5;
    wide = 27;
    
    half();
    mirror([1, 0]) half();
    
    
    module half() difference() {
        translate([-(inner/2-0.5), -(wide+1.5*2)/2, -depth-1]) {
            cube([2, wide+1.5*2, 7+0.5]);
            translate([-1.5, 0, depth+1+0.5]) cube([1.5, wide+1.5*2, 7-depth-1]);
        }
        difference() {
            translate([-(inner/2), -wide/2, -depth]) {
                translate([0, 0, 0]) cube([9.9, wide, depth]);
            }
            cube([999, 15, 999], center = true);
        }
        cube([999, 15-1.5*2, 999], center = true);
    }
}

module snap_2() {
    depth = 7+4;
    a = [8, 1.5+1, inner_height + depth];
    
    one();
    mirror([1, 0]) one();
    mirror([0, 1]) one();
    mirror([1, 1]) one();
    
    module one() intersection() {
        rotate([0, 0, -45]) {
            translate([-a[0]/2, 50.5/2-1, -depth]) cube(a);
            translate([-1/2, 50.5/2, -5]) cube([1, 99, inner_height + 5]);
        }
        union () {
            translate([0, 0, -99]) linear_extrude(height = 999) inner_2d();
            linear_extrude(height = inner_height) 
                offset(delta = -shell_thickness) outer_2d();
        }
    }
}

module snap_old() {
    // 1.5
    depth = 1.5;
    x_offset = 1.5;
    wide = 27;
    
    half();
    mirror([1, 0]) half();
    
    
    module half() difference() {
        translate([-(inner/2 - x_offset), -wide/2, -depth]) {
            translate([-x_offset, 0, depth]) cube([1+x_offset, wide, 2]);
            cube([1, wide, depth]);
            translate([-1, 0, -1]) cube([2, wide, 1]);
        }
        cube([999, 14, 999], center = true);
    }
}

module shell_2d() {
    difference() {
        outer_2d();
        offset(delta = -shell_thickness) outer_2d();
    }
}

module inner_2d() offset(delta = -(outer-inner)/2) outer_2d();

module outer_2d() hull () {
    translate([-(outer/2-edge_r), -(outer/2-edge_r)]) circle(r=edge_r);
    translate([(outer/2-edge_r), -(outer/2-edge_r)]) circle(r=edge_r);
    translate([-(outer/2-edge_r), (outer/2-edge_r)]) circle(r=edge_r);
    translate([(outer/2-edge_r), (outer/2-edge_r)]) circle(r=edge_r);
}