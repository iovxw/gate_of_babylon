plate_thickness=1.5; // From official Cherry MX spec
switch_width=14;
height=9;
switch_extra_space=[5, 0.5, 1.2];

thickness=0.9;
gap=25; // 5;

bluepill=[53, 21, 1.65];

c=bluepill[1]+thickness*2;

bluepill_z_offset=3;
bluepill_y_offset=cos(10)*(bluepill[1]+thickness*2);

main();
//bottom();

module bottom() {
    difference() {
        translate([0, -bluepill_y_offset, 0])
            cube([thickness*2+gap+switch_width*2,  thickness*2 +switch_width + bluepill_y_offset, thickness]);
        translate([thickness*2+switch_width, thickness, 0])
            cube([gap-thickness*2, switch_width+thickness, thickness]);
    }

    translate([0, 0, thickness]) {
        translate([thickness, thickness]) xxcube([switch_width, switch_width, 2]);
        translate([thickness+switch_width+gap, thickness]) xxcube([switch_width, switch_width, 2]);
        translate([thickness, -bluepill_y_offset+thickness, 0]) xxcube([bluepill[0], bluepill[1], 2]);
    }
}

module xxcube(s) difference() {
    cube(s);
    translate([thickness, thickness]) cube(s-[thickness*2, thickness*2, 0]);
    translate([thickness*2*2, 0]) cube(s-[thickness*4*2, 0, 0]);
    translate([0, thickness*2*2]) cube(s-[0, thickness*4*2, 0]);
}

module main() difference() {
    union() {
        intersection() {
            translate([0, -bluepill_y_offset, bluepill_z_offset]) rotate([10, 0, 0]) {
                bluepill_case();
                translate([0, 0, -10]) difference() {
                    cube(bluepill+[thickness*2, thickness*2, -bluepill[2]+10]);
                    translate([thickness, thickness]) cube(bluepill+[0, 0, -bluepill[2]+10]);
                }
            }
            translate([0, -99, 0]) cube(999);
        }

        cube([thickness*2+switch_width, thickness*2+switch_width, height]);
        translate([bluepill[0]-switch_width, 0]) cube([thickness*2+switch_width, thickness*2+switch_width, height]);
    }
    
    
    translate([thickness, thickness, 0]) switch_void();
    translate([bluepill[0]-switch_width+thickness, thickness, 0]) switch_void();
    
    
    // wire hole
    translate([thickness+switch_width/2, 0, 1]) rotate([90, 0])
        cylinder(h=thickness*2+0.00001, d=3, center=true, $fn=30);
    translate([thickness+switch_width*1.5+gap, 0, 1]) rotate([90, 0])
        cylinder(h=thickness*2+0.00001, d=3, center=true, $fn=30);
}


module bluepill_case() {
    x=2;
    space=0.5;
    difference() {
        cube(bluepill+[thickness*2, thickness*2, thickness]);
        translate([thickness, thickness, thickness]) cube(bluepill);
        translate([thickness+1.5, thickness+1.5, 0])
            cube([bluepill[0]-1.5*2, bluepill[1]-1.5*2, thickness]);
        translate([bluepill[0]/2-10/2-space, 0, thickness]) cube([space, thickness, bluepill[2]]);
        translate([bluepill[0]/2+10/2, 0, thickness]) cube([space, thickness, bluepill[2]]);
    }
    translate([bluepill[0]/2-10/2, 0, thickness+bluepill[2]])
        hull() {
            cube([10, thickness, thickness]);
            translate([1, 0, 0]) cube([8, thickness+1, thickness]);
        }
    translate([0, thickness+bluepill[1]-x, thickness+bluepill[2]])
       hull() {
           cube([thickness, thickness+x, thickness]);
           translate([0, x, 0]) cube([x+thickness, thickness, thickness]);
       }
    translate([bluepill[0]+thickness-x, thickness+bluepill[1]-x, thickness+bluepill[2]])
       hull() {
           translate([x, 0, 0]) cube([thickness, thickness+x, thickness]);
           translate([0, x, 0]) cube([x+thickness, thickness, thickness]);
       }
}

module switch_void() {
        clip_spec=[1.7, 3.5, 3.7];
        clip=[[0, height],
              [clip_spec[0], height-clip_spec[2]],
              [0, height-clip_spec[2]]];
        difference() {
            cube([switch_width, switch_width, height]);
            translate([0, (switch_width+clip_spec[1])/2]) rotate([90, 0]) linear_extrude(height=clip_spec[1])
                polygon(clip);
            translate([switch_width, (switch_width+clip_spec[1])/2]) mirror([1, 0]) rotate([90, 0]) linear_extrude(height=clip_spec[1])
                polygon(clip);
        }
        translate([(switch_width-switch_extra_space[0])/2, -switch_extra_space[1], height-plate_thickness-switch_extra_space[2]])
            cube(switch_extra_space);
        translate([(switch_width-switch_extra_space[0])/2, switch_width, height-plate_thickness-switch_extra_space[2]])
            cube(switch_extra_space);
}