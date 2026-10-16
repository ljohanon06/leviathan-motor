function pplot(x,y,s)
    polarplot(atan2(y,x),sqrt(x^2+y^2),s, 'MarkerSize', 60);
end

function test_forward(i1, i2, angle, id, iq, test) 
   adc1 = 2^13 * (i1+1); 
   adc2 = 2^13 * (i2+1);
   angle_in = angle/360*2^13;

   fprintf('Adc_1: %d, Adc_2: %d, Angle_in: %d\n', floor(adc1),floor(adc2),floor(angle_in));

   i3 = -(i1+i2);

   iab = 1/sqrt(3)*[1 -1/2 -1/2; 0 sqrt(3)/2 -sqrt(3)/2] * [i1;i2;i3];
   idq = [cosd(angle) sind(angle); -sind(angle) cosd(angle)] * iab;

   fprintf('Direct Current: %d, Quadrature Current: %d\n', floor(2^16*idq(1)),floor(2^16*idq(2)));

   if(test) 
       figure;
       a = 0:0.01:1;
       b = repelem(angle*pi/180,101);
       polarplot(b,a, 'b-', 'LineWidth', 10);
       hold on;
       pplot(iab(1),iab(2),'.');
       pplot(idq(1),idq(2),'.');
       pplot(id/2^16,iq/2^16,'o');
       polarplot(0,i1,'k.','MarkerSize',60);
       polarplot(2*pi/3,i2,'k.','MarkerSize',60);
       polarplot(4*pi/3,i3,'k.','MarkerSize',60);
       legend('Rotor Angle','Space','Actual','FPGA','Phase');
       set(gca,'FontSize',30);
   end
end

function test_inverse(vd, vq, angle, v1, v2, v3, test) 
   angle_in = angle/360*2^13;
   vab = [cosd(angle) -sind(angle); sind(angle) cosd(angle)] * [vd; vq];
   vx = sqrt(3)*[2/3 0; -1/3 1/sqrt(3); -1/3 -1/sqrt(3)] * vab;
   
   fprintf('Vd: %d, Vq: %d, Angle_in: %d\n', floor(2^16*vd),floor(2^16*vq), floor(angle_in));
   fprintf('V1: %d, V2: %d, V3: %d\n', floor(2^15*vx(1)),floor(2^15*vx(2)),floor(2^15*vx(3)));

   if(test) 
       figure;
       a = 0:0.01:1;
       b = repelem(angle*pi/180,101);
       polarplot(b,a, 'b-', 'LineWidth', 10);
       hold on;
       pplot(vab(1),vab(2),'.');
       pplot(vd,vq,'.');
       polarplot(0,v1/2^15,'b.','MarkerSize',60);
       polarplot(0,vx(1),'ko','MarkerSize',60);
       polarplot(2*pi/3,v2/2^15,'b.','MarkerSize',60);
       polarplot(4*pi/3,v3/2^15,'b.','MarkerSize',60);
       polarplot(2*pi/3,vx(2),'ko','MarkerSize',60);
       polarplot(4*pi/3,vx(3),'ko','MarkerSize',60);
       legend('Rotor Angle','Space','DQ','FPGA','Actual');
       set(gca,'FontSize',30);
   end
end

function test_pwm(v1,v2,v3)
    fprintf('V1: %d, V2: %d, V3: %d\n', floor(2^16*v1), floor(2^16*v2), floor(2^16*v3));

     v1_high = floor((v1 + 1)*2^9);
    if( v1_high > 934)
         v1_high = 934; end
     v2_high = floor((v2 + 1)*2^9);
    if( v2_high > 934)
         v2_high = 934; end
     v3_high = floor((v3 + 1)*2^9);
    if( v3_high > 934)
         v3_high = 934; end
    v1_low = 1023 - v1_high;
    v2_low = 1023 - v2_high;
    v3_low = 1023 - v3_high;

    fprintf('A low: %d, A high: %d\n', v1_low, v1_high);
    fprintf('B low: %d, B high: %d\n', v2_low, v2_high);
    fprintf('C low: %d, C high: %d\n', v3_low, v3_high);
end

%test_forward(-0.8,0.3,160,40420,21701,true);
%test_forward(-1,0.99,270,-32153 ,-56733,true);
%test_inverse(1,0,0,37836,-18919,-18919,true);
%test_inverse(0.3,-0.5,93,18297,1525,-19824,true);
test_pwm(0.5, 0.2, -0.7);