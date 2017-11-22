%Import the data
% -	tyres type 1: 245/40 R19
% -	tyres type 2: 245/45 R18
% -	Wheelbase: 2.8498 m
% -	Wheel track: 1.6002 m
% -	Steering ratio: ~16:1
%
%         #####               #####--
%           |                   |   ^
%           |                   |   |
%           |-------------------|   1.6002 m   
%           |                   |   |
%           |                   |   |
%         #####               #####--
%           |<-----2.8498 m---->|  
%
%
wheel_base = 2.8498; %
wheel_track = 1.6002;
steering_ratio = 16;

[~, ~, raw] = xlsread('D:\UKF\RadEstimator-20171121T122033Z-001\RadEstimator\drive.xlsx','drive','A2:W80327');;%xlsread('D:\ivo\RadEstimator\drive.xlsx','drive','A2:W80327');
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};

% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells

% Create output variable
drive_data = reshape([raw{:}],size(raw));

% Clear temporary variables
clearvars raw R;

[~, ~, drive_label] = xlsread('D:\UKF\RadEstimator-20171121T122033Z-001\RadEstimator\drive.xlsx','drive','A1:W1');%xlsread('D:\ivo\RadEstimator\drive.xlsx','drive','A1:W1');
drive_label(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),drive_label)) = {''};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% # Integrated GPS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
idx = find(~isnan(drive_data(:,3)));%not nan idx in 3-th column
time_stamp = drive_data(idx, 1) + drive_data(idx, 2)*1e-9;%sec+nsec for not nan idx
time_stamp = time_stamp - drive_data(1, 1);%remove sec offset
integrated_gps = [time_stamp, drive_data(idx, 3:5)];
int_lat_idx = 1; % {deg}
int_lon_idx = 2; % {deg}
int_alt = 3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% # Novatel GPS (cm accuracy)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
idx = find(~isnan(drive_data(:,6)));
time_stamp = drive_data(idx, 1)+drive_data(idx, 2)*1e-9;
time_stamp = time_stamp - drive_data(1, 1);
novatel_gps = [time_stamp, drive_data(idx, 6:8)];
lat_idx = 1; % {deg}
lon_idx = 2; % {deg}
alt = 3;     %  {m}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              # Odometry
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
idx = find(~isnan(drive_data(:,9)));
time_stamp = drive_data(idx, 1)+drive_data(idx, 2)*1e-9;
time_stamp = time_stamp - drive_data(1, 1);
odometry_table_range = 9:17;
odometry = [time_stamp, drive_data(idx, odometry_table_range)];
x_idx = 1;
y_idx = 2;
z_idx = 3;
roll_idx = 4;
pitch_idx = 5;
yaw_idx = 6;
lin_x_idx = 7;
lin_y_idx = 8;
lin_z_idx = 9;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% # Wheel speeds
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
idx = find(~isnan(drive_data(:,18)));
time_stamp = drive_data(idx, 1)+drive_data(idx, 2)*1e-9;
time_stamp = time_stamp - drive_data(1, 1);
wheel_speed_table_range = 18:21;
wheel_speed = [time_stamp, drive_data(idx, wheel_speed_table_range)];
front_left_idx = 1;
front_right_idx = 2;
rear_left_idx = 3;
rear_right_idx = 4;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% # Vehicle steering and speed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
idx = find(~isnan(drive_data(:,22)));
time_stamp = drive_data(idx, 1)+drive_data(idx, 2)*1e-9;
time_stamp = time_stamp - drive_data(1, 1);
steering_speed = [time_stamp, drive_data(idx, 22:23)];
steering_wheel_angle_idx = 1;
speed = 2;

%
delta_x = diff(odometry(:,2));
delta_y = diff(odometry(:,3));
delta_z = diff(odometry(:,4));
delta_xy = sqrt(delta_x.^2+delta_y.^2);
delta_xyz = sqrt(delta_x.^2+delta_y.^2 + delta_z.^2);
xy = cumsum(delta_xy);
xyz = cumsum(delta_xyz);
xy = [odometry(1:end-1,1),xy];
xyz = [odometry(1:end-1,1),xyz];


