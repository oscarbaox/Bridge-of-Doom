%define your parameters
vl=left_vel_eq;
vr=right_vel_eq;
drivetime=32; %s
encoder_data=zeros(drivetime*20,3);

%Connect to your Neato or the Simulator - choose one or the other
%[sensors,vels]=neatoSim(); %uncomment for simulator
[sensors,vels] = neato('192.168.16.109') %uncomment for physical neato
fig = gcf;
disp('press enter to continue');
pause;

tic %%start your timer in Matlab
t=toc; %initiate t as the time since you started
iter = 1;
while t<drivetime
    t=toc; %t update t
    if iter<=drivetime*20
        encoder_data(iter,:)=[t,sensors.encoders(1),sensors.encoders(2)];
    end
    iter = iter + 1;
    temp_l = subs(vl,u,t);
    temp_r = subs(vr,u,t);
    vels.lrWheelVelocitiesInMetersPerSecond=[temp_l(3),temp_r(3)]; 
    pause(.05); %you can add a short delay so we aren't constantly changing the velocities. 
end

vels.lrWheelVelocitiesInMetersPerSecond=[0,0];
pause(1);
close(fig);

figure;
scatter(encoder_data(:,1),encoder_data(:,2:3));
set(gca,'FontSize',24);
xlabel("Time (s)")
ylabel("Linear Travel (m)")
legend('Left Wheel','Right Wheel','Location','northwest');
