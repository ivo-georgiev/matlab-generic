clear all
followerRadius = 0.4
Ymax = 11.0;
Xmax = 11.0;
Xf = [7 2 6 7];
Yf = [7 1 2 3];
Tt = pi/4;%heading angle
Xt = 4;
Yt = 3;
%lidar properties
lidarAngle = pi/6;
lidarPoints= 100
lidarRange = 8;

if(Tt < 0)
    turtleTheta = pi - Tt;
else
    turtleTheta = Tt;
end;

loAngle = turtleTheta - lidarAngle/2
hiAngle = turtleTheta + lidarAngle/2

lidarScanAngles = linspace(loAngle,hiAngle,lidarPoints)';
tmpIdx = find(lidarScanAngles < 0);
lidarScanAngles(tmpIdx) = 2*pi + lidarScanAngles(tmpIdx)

bias = Yt - Xt.*tan(lidarScanAngles);
slope = tan(lidarScanAngles);
rays = [slope bias];

xLidar = Xt + (lidarRange).*cos(lidarScanAngles);
yLidar = Yt + (lidarRange).*sin(lidarScanAngles);

tmpX=0
tmpY=0
k=1;
epi=pi/20000;
for k=1:length(rays)
    if ((lidarScanAngles(k) > -epi) && (lidarScanAngles(k) < epi))
        tmpX = Xmax;
        tmpY = Yt;
    elseif (lidarScanAngles(k) > (pi/2) -epi) && (lidarScanAngles(k) < (pi/2) + epi)
        tmpX = Xt;
        tmpY = Ymax;
    elseif (lidarScanAngles(k) > pi - epi) && (lidarScanAngles(k) < pi + epi)
        tmpX = 0;
        tmpY = Yt;
    elseif (lidarScanAngles(k) > (3*pi/2) -epi) && (lidarScanAngles(k) < (3*pi/2) + epi)
        tmpX = Xt;
        tmpY = 0;
    else
        if(lidarScanAngles(k) > 0 && lidarScanAngles(k) < pi)
            tmpX = (Ymax-rays(k,2))/rays(k,1);
            tmpY = Ymax;
        end
        
        if(lidarScanAngles(k) > pi && lidarScanAngles(k) < 2*pi)
            tmpX = -rays(k,2)/rays(k,1);
            tmpY = 0;
        end
    end
    
    if tmpX < 0
        tmpX = 0;
        tmpY = polyval(rays(k,:),tmpX);
    elseif tmpX > Xmax
        tmpX = Xmax;
        tmpY = polyval(rays(k,:),tmpX);
    else
    end
    
    tmpZ(k) = norm([Xt Yt]-[tmpX tmpY]);
    
    if(tmpZ(k) <= lidarRange)
        xLidar(k,1) = Xt + (tmpZ(k)).*cos(lidarScanAngles(k));
        yLidar(k,1) = Yt + (tmpZ(k)).*sin(lidarScanAngles(k));
    else
        tmpZ(k) = nan;
    end
end

targetAngle = atan2([Yf-Yt],[Xf-Xt])

tIdx=find(targetAngle < 0)
targetAngle(tIdx) = 2*pi + targetAngle(tIdx)

figure(1); clf; hold on;



for(followerIdx=1:length(targetAngle))
    targetDiff = lidarScanAngles -targetAngle(followerIdx);
    [val,idxClosestRay] = min(abs(targetDiff));
    
    followerCenter = [Xf(followerIdx) Yf(followerIdx)]
    followerCircle = [followerCenter followerRadius]
    
    for rayIdx=1:lidarPoints
        [xcross,ycross] = linecirc(rays(rayIdx,1),rays(rayIdx,2),followerCircle(1),followerCircle(2),followerCircle(3));
        
        intersect = 0;
        if(~isnan(xcross(1)))
            dist1 = norm([Xt Yt] - [xcross(1) ycross(1)])
            intersect = intersect + 1;
            %             cross1_angle = atan2([ycross1-Yt],[xcross1-Xt]);
        end
        
        if(~isnan(xcross(2)))
            dist2 = norm([Xt Yt] - [xcross(2) ycross(2)])
            intersect = intersect + 1;
            %             cross2_angle = atan2([ycross2-Yt],[xcross2-Xt]);
        end
        
        if intersect ~= 0
            if dist1 <= dist2
                xmin = xcross(1);
                ymin = ycross(1);
                distmin = dist1;
            else
                xmin = xcross(2);
                ymin = ycross(2);
                distmin = dist2;
            end
            crossAngle = atan2([ymin-Yt],[xmin-Xt]);
            tmpIdx = find(crossAngle < 0);
            crossAngle(tmpIdx) = 2*pi + crossAngle(tmpIdx)
            
            if (crossAngle  > lidarScanAngles(rayIdx)-pi/2000) && (crossAngle  < lidarScanAngles(rayIdx)+pi/2000)
                if distmin < lidarRange
                    xLidar(rayIdx,1) = Xt + (distmin).*cos(lidarScanAngles(rayIdx));
                    yLidar(rayIdx,1) = Yt + (distmin).*sin(lidarScanAngles(rayIdx));
                    tmpZ(rayIdx) = distmin;
                end
            end
        end
    end
    
    xFollower = Xf(followerIdx) + followerRadius*cos(0:pi/100:2*pi);
    yFollower = Yf(followerIdx) + followerRadius*sin(0:pi/100:2*pi);
    figure(1),plot(xFollower,yFollower,'.g')
end

lidarDistance = tmpZ';
lidarOut = [lidarScanAngles,lidarDistance]

nanIdx = find(isnan(tmpZ));
valIdx = find(~isnan(tmpZ));

plot(Xt,Yt,'o',xLidar(valIdx),yLidar(valIdx),'.m',xLidar(nanIdx),yLidar(nanIdx),'.g',Xf,Yf,'+m')
axis([0 11 0 11])
hold off
