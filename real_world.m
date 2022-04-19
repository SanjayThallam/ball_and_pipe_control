% A MATLAB script to control Rowans Systems & Control Floating Ball 
% Apparatus designed by Mario Leone, Karl Dyer and Michelle Frolio. 
% The current control system is a PID controller.
%
% Created by Kyle Naddeo, Mon Jan 3 11:19:49 EST 
% Modified by Sanjay THallam AND 2/8/2022

%% Start fresh
close all; clc; clear device;

%% Connect to device
% device = open serial communication in the proper COM port
s = serialport('COM4',19200);
%% Parameters
target      = 0.5;   % Desired height of the ball [m]
sample_rate = 0.25;  % Amount of time between controll actions [s]

%% Give an initial burst to lift ball and keep in air
set_pwm(s, 4000); % Initial burst to pick up ball
pause(0.1) % Wait 0.1 seconds
%set_pwm(s, 0); % Set to lesser value to level out somewhere in
% the pipe

%% Initialize variables
action      = 3500; % Same value of last set_pwm   
error       = 0;
error_sum   = 0;

%% Feedback loop

% temp_pwm = 4000;
while true
    %% Read current height
     [distance,pwm,target,deadpan] = read_data(s);
     y = ir2y(distance); % Convert from IR reading to distance from bottom [m]
     [A,B] = findab(pwm);
     Q = [1000,100];
     Q = diag(Q);
     R = 1;
     k = lqr(A, B, Q, R);

     pwm = -k*pwm + 2727.0447;

     set_pwm(s, pwm)

    %% Calculate errors for PID controller
%     error_prev = error;             % D
%     error      = target - y;        % P
%     error_sum  = error + error_sum; % I
    
    %% Control
    %prev_action = action;
    %action = % Come up with a scheme no answer is right but do something
    %set_pwm(add_proper_args); % Implement action
        
    % Wait for next sample
    pause(sample_rate)
end
