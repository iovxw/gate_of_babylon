cut=1;
cube_width=11;

usb_c_width=11;
usb_c_height=18.5;

radius=20.5;
height=12;

$fn=200;
difference() {
    // 外轮廓
    union() {
        cylinder(h=height+1, r=radius+1);
        translate([(-cube_width-2)/2,radius-cut,0]) cube([usb_c_width+2,usb_c_height+1,13]);

        // 支架
        translate([(-cube_width-2)/2,0,-37]) rotate([45,0,0]) cube([usb_c_width+2,43,13]);
        // 底座
        translate([0,0,-40]) cylinder(h=5, r=40);
    }
    // 充电盘大小
    translate([0,0,1]) cylinder(h=height+cut, r=radius);
    // USB 头
    translate([-usb_c_width/2,radius-cut,3]) cube([usb_c_width,usb_c_height,height+1+cut]);
    // USB 线
    translate([-5/2,radius+1+cut,3]) cube([5,usb_c_height,height+cut]);
}