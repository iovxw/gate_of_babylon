
main();

translate([0,0,80]) cover();



$fn=20;
d=0;

thickness=1.5;
X=0.1;

module main() {
    difference() {
    main_body();
    // USB Hole
    translate([11,-thickness-X,3.5]) cube([13,thickness+2*X,12]);
        
    //Arduino Mega mount holes
       translate([4.3,18.2,-2]) cylinder(h=10, r=1.5);  
       translate([53,100-0.5,-2]) cylinder(h=10, r=1.5); 
    }
    
    
    mount_hole();

// Fan Hole
translate([0,(114-80)/2,00]) rotate([0,-90,0]) fan();

difference(){
    union(){
       //Arduino Mega mount 
       translate([4.3,18.2,0]) cylinder(h=3, r1=4, r2=3);  
       translate([53,16.7+0.5,0]) cylinder(h=3, r1=4, r2=3); 
       translate([4.3,93.6-0.5,0]) cylinder(h=3, r1=4, r2=3); 
       translate([53,100-0.5,0]) cylinder(h=3, r1=4, r2=3);  
       
    }
    
    //Arduino Mega mount holes
       translate([4.3,18.2,0]) cylinder(h=10, r=1.5);  
       translate([53,100-0.5,0]) cylinder(h=10, r=1.5); 
}
       translate([4.3,93.6-0.5,0]) cylinder(h=5, r=1.5-0.1); 
       translate([53,16.7+0.5,0]) cylinder(h=5, r=1.5-0.1); 
}

module main_body() {
difference(){
    union(){
     //Box   
         translate([-thickness,-thickness,-thickness]) cube([65+thickness*2,114+thickness*2,60+thickness]); // height = 43
        
        // mount hole
         ////// translate([-12-thickness,102+thickness,-thickness]) cube([12,12,9]);

        
    }
    
    //Box holes
    cube([65,114,11111]);
    
    //translate([10,10,-5]) cube([37,100,11111]);
    //translate([20,25,-5]) cube([37,67,11111]);
    //translate([-10,-10,10]) cube([111111,1111111,111111]);
    

    // Power Hole
    translate([65/2,-thickness-X,13]) cube([30,thickness+2*X,10]);
    translate([65/2,-thickness-X,13]) cube([65/2-10,thickness+2*X,47+X]);
    
    
    //Left Side cooling holes
    /*for ( i = [10 : 7 : 109] ) {
          translate([0,0,10]) cooling_hole(i);
    }*/
        //Right Side cooling holes
    /*for ( i = [10 : 7 : 109] )
        if ( ((i-10)/7) >= 3 && ((i-10)/7) <= 4 ) {
        } else {
          translate([65,0,0]) cooling_hole(i);
        }
        */
        
    
    // Reset Button
    translate([65-X,36,18]) cube([20,5,42+X]);
    
    translate([65-X,10-X,23]) cube([20,114-10*2,42+X]);
    
    //Box Cover mount holes
    //translate([-thickness-X,10,60-2-1.8]) rotate([0,90,0]) cylinder(h=500, r=1.8);
    //translate([-thickness-X,114-10,60-2-1.8]) rotate([0,90,0]) cylinder(h=500, r=1.8);
    
    //LCD cable
     translate([(2+d+65-14-44),105,2+3+39]) cube([44,30,30]); 
     
    // Fan Hole
    translate([-thickness-X,(114-80)/2,-0]) cube([thickness+2*X,80,80]);
    
    
}


}

module cover() {
    difference() {
     union(){
     //Box   
         translate([-thickness,-thickness,0]) cube([65+thickness*2,114+thickness*2,60+thickness]); // height = 43
       translate([-thickness,(114-80)/2+80+thickness,60+thickness]) rotate([90,0,0]) linear_extrude(height=80+thickness*2) polygon(points=[[0,0],[65+thickness*2,0],[0,20]]);
        
    }
    //Box holes
    
    cube([65,114,60]);

    
    
       translate([-thickness,(114-80)/2+80,60]) rotate([90,0,0]) linear_extrude(height=80) polygon(points=[[0,0],[65+thickness*2,0],[0,20]]);
    
    main_body();
    
    // Air Flow Out
    translate([65-X,10-X,23-5]) cube([20,114-10*2,42]);
    
    // Power Cable
    translate([65/2,-thickness-X,13]) cube([65/2,thickness+2*X,10]);
    
    //LCD cable
     translate([(2+d+65-14-44),105,2+3+39]) cube([44,30,2]); 
   
    // Fan Hole
    translate([-thickness-X,(114-80)/2,-0]) cube([thickness+2*X,80,80]);
    }
    translate([0,0,60-10]) cube([5,5,10]);
    translate([65-5,0,60-10]) cube([5,5,10]);
    translate([0,114-5,60-10]) cube([5,5,10]);
    translate([65-5,114-5,60-10]) cube([5,5,10]);
    
    translate([0,(114-80)/2,60]) cube([5,5,10]);
    translate([0,(114-80)/2+80-5,60]) cube([5,5,10]);
    
    
    translate([(65/2)+(65/2-10)/2-5/2,0,13+10]) cube([5,5,47-10]);
}


module mount_hole() difference() {
    union() {
    translate([65+thickness,-thickness,-thickness]) cube([12,12,9]);
        translate([65+thickness,102+thickness,-thickness]) cube([12,12,9]);
    }
        
        
    translate([65+thickness+(12/2),102+thickness+(12/2),-thickness-X])
        cylinder(h=10, r=2.5);
    translate([65+thickness+(12/2),102+thickness+(12/2),-thickness+4])
        cylinder(h=100, r=4);
    translate([65+thickness+(12/2),-thickness+(12/2),-thickness-X])
        cylinder(h=10, r=2.5);
    translate([65+thickness+(12/2),-thickness+(12/2),-thickness+4])
        cylinder(h=100, r=4);
}

module fan() {
    hole_margin=(80-71.5)/2;
    module fan_part() difference() {
        cube([40,40,thickness]);
        translate([hole_margin,hole_margin,-0.01]) cylinder(r=2,h=10,$fn=6);
        translate([80/2,80/2,-0.01]) cylinder(r=39,h=10, $fn=300);
    }
    fan_part();
    translate([0,80,0]) rotate([0,0,-90]) fan_part();
    translate([80,0,0]) rotate([0,0,90]) fan_part();
    translate([80,80,0]) rotate([0,0,180]) fan_part();
    
    //translate([10,0,0]) cube([5,80,thickness]);
}
