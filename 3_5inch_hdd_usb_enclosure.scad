// From: SFF-8301 3.5" Form Factor Drive Dimensions
// https://members.snia.org/document/dl/25861
// https://support.wdc.com/images/kb/2579-771970-A03.pdf
// a[1] = 17.8 or 26.1 or 42
$hdd__a = [0, 26.1,  147,   101.6, 95.25, 3.18,
              44.45, 41.28, 28.5,  101.6, 6.35,
              0.25,  0.5,   76.2];
$hdd__de_facto_side_hole = 41.61;
$hdd__width = $hdd__a[3];
$hdd__length = $hdd__a[2];
$hdd__height = $hdd__a[1];

$jms578__z_offset = -0.5;
$jms578__sata = [43, 2, 5 + 0.1];
$jms578__sata_x_margin = 0.9;
$jms578__pcb = [56, 20-2, 1];
$jms578__cable_ext = 2;
$jms578__cable_y = 7;
$jms578__cable_d = 6 + 0.1;

thickness = 1.00001;
height = 20;
jms578_x_margin = 8.5 - $jms578__sata_x_margin;
x_size = jms578_x_margin + $jms578__pcb[0] + $jms578__cable_ext;
y_thickness = 5 - ($jms578__cable_y - 7.1/2);
y_size = $jms578__pcb[1] + $jms578__sata[1] + y_thickness;
power_hole_d = 8;

/****** ******/
//part_a();
//part_b();
part_c();
/****** ******/

module part_a() adapter_box("top");
module part_b() adapter_box("bottom");
module part_c() {
    hdd_mount();
}

module adapter_box(piece = "top") {
    z_offset = $jms578__z_offset;
    pcb = $jms578__pcb;
    sata = $jms578__sata;

    translate([0, 0, sata[2]/2 + z_offset])
    intersection() {
        if (piece == "top")  {
            translate([-100, -100]) cube([200, 200, 200]);
        } else if (piece == "bottom") {
            mirror([0, 0, 1]) translate([-100, -100]) cube([200, 200, 200]);
        } else if (piece == "void") {
        } else {
            echo(piece = piece);
            assert(false, "piece must be top or bottom");
        }
        if (piece == "void") {
            hull() adapter_box_raw();
        } else {
            adapter_box_raw();
        }
    }
}

module adapter_box_raw() {
    z_offset = $jms578__z_offset;
    pcb = $jms578__pcb;
    sata = $jms578__sata;

    screw_length = 20;
    screw_mount_height = -z_offset + height - screw_length + 5;
    
    module jms578_mount_void() difference() {
        hull() jms578_mount_raw();
        jms578_mount_raw();
    }

    module screw() cylinder(d = 3, h = sata[2]/2+thickness, $fn = 6);
    module screw_top() cylinder(d = 3.1, h = height, $fn = 20);

    translate([0, 0, 0]) difference() {
        translate([0, 0, -sata[2]/2-thickness]) linear_extrude(height = height) {
            square([x_size, y_size]);
                
            translate([jms578_x_margin + pcb[0], 0]) {
                square([5, 5]);
                translate([0, y_size - 5]) square([5, 5]);
            }
        }
        translate([jms578_x_margin, y_thickness]) {
            jms578_mount_void();
             difference() {
                translate([-4, 0]) cube([pcb[0], pcb[1], height - (sata[2]/2 + thickness) - thickness]);
                translate([28, 13, 0]) {
                    cylinder(d = 2, h = 99, $fn = 20);
                    translate([-4/2, -4/2]) cube([4, 99, 99]);
                }
                //translate([pcb[0]-4, $jms578__cable_y]) translate([0, -9/2]) cube([99, 9, 99]);
            }
            translate([28, 13, 0]) {
                cylinder(d = 2, h = 99, $fn = 20);
                translate([-2/2, -2/2]) cube([2, 2, height-sata[2]/2-thickness*2]);
            }
        }
        translate([0, 0, -sata[2]/2-thickness]) {
            translate([5/2, y_size - 5/2, 0]) screw();
            translate([5/2, 5/2]) screw();
            translate([jms578_x_margin + pcb[0] + 5/2, y_size - 5/2, 0]) screw();
            translate([jms578_x_margin + pcb[0] + 5/2, 5/2]) screw();
        }
        translate([0, 0, 0]) {
            translate([5/2, y_size - 5/2, 0]) screw_top();
            translate([5/2, 5/2]) screw_top();
            translate([jms578_x_margin + pcb[0] + 5/2, y_size - 5/2, 0]) screw_top();
            translate([jms578_x_margin + pcb[0] + 5/2, 5/2]) screw_top();
        }
        // power hole
        translate([10, pcb[1], (height-sata[2]/2-thickness)/2]) rotate([90, 0]) cylinder(d = power_hole_d, h = 99, $fn = 100);
    }
}

module jms578_mount_raw() {
    z_offset = $jms578__z_offset;
    sata = $jms578__sata;
    sata_x_margin = $jms578__sata_x_margin;
    pcb = $jms578__pcb;
    cable_ext = $jms578__cable_ext;
    cable_y = $jms578__cable_y;
    cable_d = $jms578__cable_d;
    
    screw_h = (sata[2] - pcb[2])/2 + thickness;
    screw_d = 2.3;
    screw_mount_offset = pcb[2] / 2;
    // 8 2 6

    module screw_hole() cylinder(d = screw_d, h = screw_h);
    
    module screw_mount() difference() {
        cylinder(d = screw_d + 1*2, h = screw_h, $fn = 20);
        cylinder(d = screw_d, h = screw_h);
    }

    difference() {
        translate([0, 0, -thickness - sata[2]/2])
            cube([pcb[0]+cable_ext, pcb[1]+sata[1], thickness*2 + sata[2]]);
        translate([pcb[0], cable_y, 0]) rotate([0, 90]) cylinder(d = cable_d, h = cable_ext, $fn = 30);
        translate([0, 0, -sata[2]/2]) cube([pcb[0], pcb[1], sata[2]]);
        //translate([0, 0, screw_h + pcb[2]/2]) cube([pcb[0] + 2, pcb[1], 1]);
        translate([sata_x_margin, pcb[1], -sata[2]/2]) cube(sata);
        mirror([0, 0, 1]) translate([0, 0, screw_mount_offset]) {
            translate([3, 7]) screw_hole();
            translate([48, 13]) screw_hole();
        }
        
        // LED hole
        translate([28, 13, 0]) cylinder(d = 2, h = 99, $fn = 20);
    }
    
    mirror([0, 0, 1]) translate([0, 0, screw_mount_offset]) {
        translate([3, 7]) screw_mount();
        translate([48, 13]) screw_mount();
    }
}

module hdd_void() {
    a = $hdd__a;
    de_facto_side_hole = $hdd__de_facto_side_hole;
    width = $hdd__width;
    length = $hdd__length;
    height = $hdd__height;
    
    screw_d = 3.5;
    screw_h = 1;
    screw_head_d = 6.8;
    screw_head_h = 10;
    cube([a[3], a[2], a[1]]);
    
    module screw() {
        cylinder(d = screw_d, h = screw_h, $fn = 20);
        translate([0, 0, screw_h]) cylinder(d = screw_head_d, h = screw_head_h, $fn = 50);
    }
    module bottom_screw() rotate([180, 0, 0]) screw();
    translate([a[5], a[7]]) bottom_screw();
    translate([a[5], a[7] + a[6]]) bottom_screw();
    translate([a[5], a[7] + a[13]]) bottom_screw();
    translate([a[5] + a[4], a[7]]) bottom_screw();
    translate([a[5] + a[4], a[7] + a[6]]) bottom_screw();
    translate([a[5] + a[4], a[7] + a[13]]) bottom_screw();
    
    module left_screw() translate([0, 0, a[10]]) rotate([0, -90, 0]) screw();
    translate([0, a[8], 0]) left_screw();
    translate([0, a[8] + de_facto_side_hole, 0]) left_screw();
    translate([0, a[8] + a[9], 0]) left_screw();
    module right_screw() translate([width, 0, a[10]]) rotate([0, 90, 0]) screw();
    translate([0, a[8], 0]) right_screw();
    translate([0, a[8] + de_facto_side_hole, 0]) right_screw();
    translate([0, a[8] + a[9], 0]) right_screw();
}

module hdd_mount() {
    a = $hdd__a;
    width = $hdd__width;
    length = $hdd__length;
    height = $hdd__height;
    
    x_thickness = 3;
    y_thickness = 3;
    locator_thickness = 1;
    rubber_feet_d = 8 + 0.2;
    rubber_feet_h = 0.7;

    module foot() translate([10/2-x_thickness, 0, 0]) difference() {
        hull() {
            translate([10/2, 0, a[10]]) rotate([0, -90, 0]) cylinder(d = 10, h = 10, $fn = 80);
            translate([0, 0, -y_thickness]) cylinder(d = 10, h = 1, $fn = 100);
        }
        translate([0, 0, -y_thickness]) cylinder(d = rubber_feet_d, h = rubber_feet_h, $fn = 50);
    }

    difference() {
        union() {
            /*translate([-locator_thickness, -locator_thickness, -y_thickness])
                cube([5, 5, 1 + 5]);
            translate([0, 0, -y_thickness]) cube([5 - locator_thickness, y_size + a[8] -10/2, 5]);
            */
            translate([0, y_size]) translate([0, a[8], 0]) foot();
            //translate([0, y_size]) translate([0, a[8] + a[9], 0]) foot();
            //translate([0, y_size]) translate([width, a[8], 0]) mirror([1, 0]) foot();
        }
        #translate([0, y_size]) hdd_void();
        #hull() adapter_box("bottom");
    }
}