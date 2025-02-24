% Three Body Distance
% This code refers to https://wwi.lanzoui.com/i9Gowwglv8d

clc, clear all, close all


G = 6.67e-11; % the gravitational constant
m1 = 1/G;     % the first star
m2 = m1;    % the second star
m3 = m1;    % the third star

%% solve the ode system
% the initial condition
u1 = [0.1 -0.06 0.02];
u2 = [1 0 4];
u3 = [-0.1 -0.06 0.01];
u4 = [0 2 0];

u5 = ([0 0 0]-m1*u1-m2*u3)/m3;
u6 = ([0 0 0]-m1*u2-m2*u4)/m3;

x0 = [u1 u2 u3 u4 u5 u6];

% time step
tspan = 0:0.000001:10;
% solve the ode by calling ode45
[t,x] = ode45(@(t,x) track(t,x,m1,m2,m3),tspan,x0);


%% calculate the distance of each star's position to center of mass

first_star_com = zeros(1,1);
second_star_com = zeros(1,1);
third_star_com = zeros(1,1);

for k = 1:length(t)
    
    temp = x(k,:);

    u1 = temp(1:3);
    u3 = temp(7:9);
    u5 = temp(13:15);
    
    com = (m1*u1+m2*u3+m3*u5)/(m1+m2+m3);

    first_star_com(k,1) = norm(u1-com);
    second_star_com(k,1) = norm(u3-com);
    third_star_com(k,1) = norm(u5-com);

end

%% plot the distance of each star's position to center of mass

x = t;
 
y1 = first_star_com;
p1 = plot(x,y1,'r','DisplayName','Star 1');
p1.LineWidth = 1.3; 
hold on;

y2 = second_star_com;
p2 = plot(x,y2,'g','DisplayName','Star 2');
p2.LineWidth = 1.3; 
hold on;

y3 = third_star_com;
p3 = plot(x,y3,'b','DisplayName','Star 3');
p3.LineWidth = 1.3; 
hold on;

ylabel("Distance")
xlabel("Time")
ax = gca;
ax.FontSize = 20;
legend

%% show the animation

figure('Color','k','Units','normalized','Position',[0.1 0.1 0.8 0.8])
% show the three stars
movep1 = scatter3(u1(1),u1(2),u1(3),'SizeData',400,'MarkerFaceColor','r','MarkerEdgeColor','none');
hold on
movep2 = scatter3(u3(1),u3(2),u3(3),'SizeData',400,'MarkerFaceColor','g','MarkerEdgeColor','none');
movep3 = scatter3(u5(1),u5(2),u5(3),'SizeData',400,'MarkerFaceColor','b','MarkerEdgeColor','none');

% add the trajectory
h1 = animatedline('MaximumNumPoints',fix(length(tspan)),'Color','r','LineWidth',1.5);
h2 = animatedline('MaximumNumPoints',fix(length(tspan)),'Color','g','LineWidth',1.5);
h3 = animatedline('MaximumNumPoints',fix(length(tspan)),'Color','b','LineWidth',1.5);

ax = h1.Parent;
ax.Color = 'none';
ax.XAxis.Color = 'y';
ax.XAxis.FontName = 'times';
ax.YAxis.Color = 'y';
ax.ZAxis.Color = 'y';
ax.View = [22 33];

axis equal
axis off
 
for k = 1:length(t)
    if k<10
        pause(0.1)
    end
    
    addpoints(h1,x(k,1),x(k,2),x(k,3));
    movep1.XData = x(k,1);
    movep1.YData = x(k,2);
    movep1.ZData = x(k,3);

    addpoints(h2,x(k,7),x(k,8),x(k,9));
    movep2.XData = x(k,7);
    movep2.YData = x(k,8);
    movep2.ZData = x(k,9);
    
    addpoints(h3,x(k,13),x(k,14),x(k,15));
    movep3.XData = x(k,13);
    movep3.YData = x(k,14);
    movep3.ZData = x(k,15);

    drawnow limitrate
end


%% the function for setting the ode system
function dx = track(t,x,m1,m2,m3)
% the three body ode system
G = 6.67e-11; % the gravitational constant

dx=zeros(18,1);

u1 = x(1:3); % position of star 1
u2 = x(4:6); % velocity of star 1
u3 = x(7:9); % position of star 2
u4 = x(10:12); % velocity of star 2
u5 = x(13:15); % position of star 3
u6 = x(16:18); % velocity of star 3

u1x = u2;
u2x = G*(m2*(u3-u1)/(norm(u3-u1))^3+m3*(u5-u1)/(norm(u5-u1))^3);
u3x = u4;
u4x = G*(m3*(u5-u3)/(norm(u5-u3))^3+m1*(u1-u3)/(norm(u1-u3))^3);
u5x = u6;
u6x = G*(m1*(u1-u5)/(norm(u1-u5))^3+m2*(u3-u5)/(norm(u3-u5))^3);

dx = [u1x;u2x;u3x;u4x;u5x;u6x];

end

