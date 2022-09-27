module spool(){
    //R - radius
    //W - width
    //D - deept
    //H - height
    
    spoolR = 71.5/2;
    lineW = 11.5; //spool deept for line volume
    spoolH = 29;  //spool height
    chamferH = 5; 
    sideW = 1.5; // side thikness/width
    botW = 2.2; // bottom
    extraH = 4.5;
    extraR = 5;
    color("green")
    difference() {
         rotate_extrude($fn = 80)
            polygon( points=[[spoolR,0],
                             [spoolR - lineW + 1.5    ,0],
                             [spoolR - lineW          ,chamferH],
                             [spoolR - lineW          ,spoolH - chamferH],
                             [spoolR - lineW + 1.5    ,spoolH + extraH],
                             [spoolR - extraR         ,spoolH + extraH],
                             [spoolR + extraR         ,spoolH + extraH],
                             [spoolR + extraR         ,spoolH - sideW],
                             [spoolR + extraR - sideW ,spoolH - sideW],
                             [spoolR + extraR - sideW ,spoolH + extraR - sideW],
                             [spoolR                  ,spoolH + extraR - sideW],
                             [spoolR                  ,spoolH - sideW],
                             [spoolR - 8.4            ,spoolH - sideW],
                             [spoolR - lineW + botW   ,spoolH - chamferH ],
                             [spoolR - lineW + botW   ,chamferH ],
                             [spoolR - 8.4, sideW],
                             [spoolR, sideW]]);
        absR = spoolR - (lineW/2) + 1.0; 
        for (fi=[0:18:360-18]) {
            dx = absR*cos(fi);
            dy = absR*sin(fi);
            holeR = (fi > 10) ? 3.5:1.5;
            translate([dx,dy,0])
                cylinder(h = 100,r = holeR, center=true);
        }
        //extend hole only for one spool side 
        translate([absR,0,0])
            cylinder(h = 50,r = 3.5, center=true);
    }
}
spool()

echo(version=version());
