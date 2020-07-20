thikness = 0.8;
fix = 0.0001;
x = 139;
y = 70;
z = 4.5;
r = 13;
$fn=400;

translate([x/2, 0, z]) linear_extrude(height = 0.8, scale=[0.994, 0.994])
    translate([-x/2, 0, 0]) projection(cut = true) translate([0, 0, -thikness]) cover();
cover();

module cover() difference() {
    linear_extrude(height = z) offset(delta = thikness) union() {
        round_it(r) square([x, y]);
        square([x, r]);
    }
    translate([0, 0, thikness]) linear_extrude(height = z) union() {
         round_it(r) square([x, y]);
         square([x, r]);
    }
    translate([-thikness-fix, -thikness-fix, 0]) cube([x+(thikness+fix)*2, thikness+fix, z]);
}


module round_it(r) {
    offset(r = r) offset(delta = -r) children();
}