difference() {
    //cube([50, 5, 10]);
}
module base() polygon([[0,0], [0, 10+1], [20, 20], [20, 20-1], [5+1*2, 13], [5+1*2, 0],
         [5+1, 0], [5+1, 10], [1, 10], [1, 0]]);

h = 50;
n = 20;
difference() {
linear_extrude(height = h) base();
    for (i=[0:n-1]) {
        translate([0, 10, h/n*i+(h/n-1)/2]) cube([19, 99, 1]);
    }
}