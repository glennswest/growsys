
in = 25.4;
$fn=256;


tubing_id = 4.7625; // 3/16 

module tube(ra,th,tlen)
{
        difference(){
          translate([0,0,0])  cylinder(r=ra+th,h=tlen);
          translate([0,0,-2]) cylinder(r=ra,h=tlen+4);
        }
    
}

module sliced_circle(ra,th,tlen)
{
    difference(){
        tube(ra,th,tlen);
        for ( x = [0 : 4]){
          translate([sin(360*x/4) * 1 * in,
                     cos(360*x/4)*1*in, -1])
              cylinder(r=12, h=10);
         }
     }
    
}
module end_filter()
{
    difference(){
      cylinder(r=in*2.5/2-1,h=1.5);
      for ( x = [0 : 10]){
          translate([sin(360*x/10) * 1 * in,
                     cos(360*x/10)*1*in, -1])
              cylinder(r=5, h=10);
         }
      translate([0,0,-1]) cylinder(r=10,h=10);   
      }
}
 
module drip_filter()
{
    difference(){
      cylinder(r=in*2.5/2-1,h=1.5);
      for ( x = [0 : 30]){
          translate([sin(360*x/30) * 1 * in,
                     cos(360*x/30)*1*in, -1])
              cylinder(r=.75, h=10);
         }
      translate([0,0,-1]) cylinder(r=10,h=10);    
      }
}

module grow_body(){
  difference(){
   tube(in*2.5/2,2,in*3.4);
   //translate([0,0,(in*3)+1]) sliced_circle((in*2.5/2)-3,4,10);
   translate([0,0,(in*3)+1]) tube((in*2.5/2)-3,4,2);   
   translate([in*.6,0,in*1]) rotate([0,45,0]) translate([0,0,-4]) cylinder(r=in*2/2,h=in*4);      
   }
  difference(){
    translate([in*.6,0,in*1]) rotate([0,45,0])  translate([0,0,-8]) tube(in*2/2,1.5,in*2.5);
    translate([in*.6,0,in*1]) rotate([0,45,0]) translate([0,0,-10]) cylinder(r=in*2/2,h=in*4);
    cylinder(r=(in*2.5/2),h=in*4.2);  
    } 
 
}

module grow_end(){
  ;
  translate([0,0,-9]) tube((in*2.5/2)-2,2,8);
//  translate([0,0,-6]) sliced_circle((in*2.5/2)-3,4,2);  
  translate([0,0,-10]) end_filter();      
}


module grow_joiner()
{
    difference(){
        hull(){
          translate([0,0,0]) tube((in*2.5/2),1,.1)
          translate([0,0,-2]) tube((in*2.5/2)-1,1,.1);   
          }
       translate([0,0,-14]) cylinder(r=(in*2.5/2)-2,h=20);
       }   
}
module grow(){
      grow_body();
      grow_joiner();
      grow_end();   
}

module halfsphere(thesize)
{
        difference(){
           sphere(r=thesize);
           x2size = thesize*2;
           translate([0-thesize-1,0-thesize-1,0-x2size-2]) cube([x2size+2,x2size+2,x2size+2]);
           }
}

module dome(thesize,thickness)
{
    difference(){
      halfsphere(thesize);
      translate([0,0,0-thickness]) halfsphere(thesize-(thickness/2));
    }
}

module growtopshell()
{
  
    translate([0,0,16.84])  tube(tubing_id/2,1,30);
    translate([0,0,42]) tube((tubing_id/2)+.6,.5,2);
    translate([0,0,39]) tube((tubing_id/2)+.6,.5,2);
    translate([0,0,-1])  dome(in*2.5/2+2,2);
    translate([0,0,-1])  grow_joiner();
    translate([0,0,-9]) tube((in*2.5/2)-2,2,8);
    translate([0,0,-8]) dome(in*1.9/2,2);
    translate([0,0,-8]) dome(in*2.2/2,2);
    translate([0,0,-9]) drip_filter();
    
}

module growbotshell()
{
  
    translate([0,0,16.84+14])  tube(tubing_id/2,1,20);
    translate([0,0,42]) tube((tubing_id/2)+.6,.5,2);
    translate([0,0,39]) tube((tubing_id/2)+.6,.5,2);
    translate([0,0,-1])  dome(in*2.5/2+2,2);
    translate([0,0,-9]) tube((in*2.5/2),2,8);
}

module growtop(){
    difference(){
        growtopshell();
        translate([0,0,16.85]) cylinder(r=(tubing_id/2),h=40);
    }
}

module growbottom(){
    difference(){
        growbotshell();
        translate([0,0,16.85]) cylinder(r=(tubing_id/2),h=40);
    }
}

module grow_mount()
{
  difference(){
      translate([0,0,0])  dome(in*2.5/2+4,2);  
      cylinder(r=(in*1),h=100);
      }
  halfsize = in * 4 / 2;
  difference(){    
     translate([0-halfsize,0-halfsize,0]) cube([in*4,in*4,2]);
     translate([0,0,-10]) cylinder(r=halfsize-15,h=20);
     translate([-35,-35,-10]) cylinder(r=10,h=20);
     translate([-35, 35,-10]) cylinder(r=10,h=20); 
     translate([35,-35,-10]) cylinder(r=10,h=20);
     translate([35, 35,-10]) cylinder(r=10,h=20);  
     }    
  difference(){   
    translate([0-halfsize,0-halfsize,0]) cube([2,in*4,30]);
    translate([-55,0,20]) rotate([0,90,0]) cylinder(r=in*1.4,h=10);  
    translate([-55,-45,20]) rotate([0,90,0]) cylinder(r=1.5,h=10);
    translate([-55, 45,20]) rotate([0,90,0]) cylinder(r=1.5,h=10); 
    }
   difference(){ 
    translate([halfsize,0-halfsize,0]) cube([2,in*4,29]);   
    translate([45,0,20]) rotate([0,90,0]) cylinder(r=in*1.4,h=10);    
    translate([45,-45,20]) rotate([0,90,0]) cylinder(r=1.5,h=10);
    translate([45, 45,20]) rotate([0,90,0]) cylinder(r=1.5,h=10);    
    } 
}

module growwall_mount()
{
    difference(){
      translate([0,0,0])  dome(in*2.5/2+4,2);  
      cylinder(r=(in*1),h=100);
      }
  halfsize = in * 4 / 2;
  difference(){    
     translate([0-halfsize,0-halfsize,0]) cube([in*4,in*4,2]);
     translate([0,0,-10]) cylinder(r=halfsize-15,h=20);
     translate([-35,-35,-10]) cylinder(r=10,h=20);
     translate([-35, 35,-10]) cylinder(r=10,h=20); 
     translate([35,-35,-10]) cylinder(r=10,h=20);
     translate([35, 35,-10]) cylinder(r=10,h=20);  
     }    
     
  difference(){   
    translate([halfsize-4,0-halfsize,0]) cube([6,in*4+2,50]);
    translate([halfsize-5,0-halfsize+10,12]) rotate([0,90,0]) cylinder(r=2.5,h=10);
    translate([halfsize-5,halfsize-10,12]) rotate([0,90,0]) cylinder(r=2.5,h=10);
    translate([halfsize-5,0-halfsize+10,38]) rotate([0,90,0]) cylinder(r=2.5,h=10);
    translate([halfsize-5,halfsize-10,38]) rotate([0,90,0]) cylinder(r=2.5,h=10); 
    translate([halfsize-2,15,10]) rotate([90,0,-90]) linear_extrude(3)  text("NCC") ;
    }
  hull(){
    translate([0-halfsize+(3.9*in)+1,0-halfsize+4,0]) rotate([0,0,-90]) cube([4,in*.1,50]);  
    translate([0-halfsize,0-halfsize+4,0]) rotate([0,0,-90]) cube([4,in*.5,5]);
    }  
  hull(){
    translate([0-halfsize+(3.9*in)+1,halfsize+2,0]) rotate([0,0,-90]) cube([4,in*.1,50]);  
    translate([0-halfsize,halfsize+2,0]) rotate([0,0,-90]) cube([4,in*.5,5]);
    }    
}

growwall_mount();
//translate([100,100,0]) grow();