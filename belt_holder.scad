height=8-0.3;
bottom=1.2-0.3;
width=11;

difference() {
    translate([0,20/2-9/2,height/2]) cube([width,20,height], true);
    translate([0,0,-0.1]) cylinder(r=2,h=height+bottom, $fn=6);
    translate([0,7,bottom]) belt();
}

module belt() {
    difference() {
        $fn=100;
        cylinder(r=2+1.5,h=height);
        translate([0,0,-0.1]) cylinder(r=2,h=height+bottom);
        linear_extrude(height = 100, center = true)
            polygon(points=[[-1.73,1],[1.73,1],[0,4]]);
    }
    rotate([0,0,30]) translate([2,0,0]) cube([1.5,5,height]);
    rotate([0,0,-30]) translate([-2-1.5,0,0]) cube([1.5,5,height]);
    
    translate([-2/2,5,0]) cube([2,10,height]);
    
    curve();
    mirror([1,0,0]) curve();
}

module curve() {
     difference() {
        translate([0,4,0]) cube([2,3,height]);
        translate([6.29,6.7,-0.1]) cylinder(r=5.3,h=height+bottom,$fn=100);
    }
}
