 clc
  clear
  clf
  x=linspace(0,6,100);
  y1=sin(x);
  y2=cos(x);
  y3=0.5-sin(x).^2;
  y4=0.5-cos(x).^2;
  subplot(2,2,1)
  plot(x,y1, ’r-’)
  xlabel("x")
  ylabel("sin(x)")
  title("plot1")
  subplot(2,2,2)
  plot(x,y2, ’g-’)
  xlabel("x")
  ylabel("cos(x)")
  title("plot2")
  subplot(2,2,3)
  plot(x,y3, ’r-’)
  xlabel("x")
  ylabel("0.5-sin(x).^2")
  title("plot3")
  subplot(2,2,4)
  plot(x,y4, ’b-’)
  xlabel(’x’)
 ylabel("0.5-cos(x).^2")
 title("plot4")
