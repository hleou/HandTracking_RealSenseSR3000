% clc; clear;
% vidDepth = imaq.VideoDevice('winvideo', 2, 'INVI16_640x480');
% depthVideo = vision.VideoPlayer;
% disp('Successful Connection with RealSense SR3000')

global pst_x
global pst_y

n_samples = input('Number of Samples: ')
n_points = 29

phisT = zeros(n_samples, n_points*3);
bboxesT = zeros(n_samples, 4);
% IsTr = cell(n_samples,1);
% 
% for m = 1:n_samples
%     %__________Adding Image to IsTr__________%load
%     disp('Click when ready for another frame capture')
%     while(waitforbuttonpress ~= 0)
%     end
%     capture = double(objectFrame);
%     imshow(capture);
%     keep_capture = input('Keep this frame? Y/N');
%     if (keep_capture == 'y' || keep_capture == 'Y')
%         IsTr(m) = {capture};
%     else
%         m = m-1;
%     end
%     
% end

for n = 1:n_samples
    imshow(IsT{n});
    %_________Adding Points to phisTr_________%
    pst_x = zeros(1,n_points);
    pst_y = zeros(1,n_points);
    occluded = zeros(1,n_points);
    disp('Select 1 point in the middle of each finger (Begin at pinky finger)');
    point_collect((1:5), true);
    disp('Select 1 point on each fingertip (Begin at pinky finger)');
    point_collect((11:15), false);
    disp('Select 1 point on each edge (median height) of the hand (Left/Right)');
    point_collect((16:17), false);
    disp('Select the joint between the (1)Pinky/Ring Fingers and (2)Thumb/Index Fingers');
    point_collect((18:19), true);
    disp('Select the outside (1)Pinky base and (2)Thumb base');
    point_collect((22:23), true);
    disp('Select 3 landmarks on the wrist (Left, Center, Right)');
    point_collect((26:28), false);
    disp('Select 1 landmarks in the center of the palm');
    point_collect((29:29), false);
    
    disp('Done Collecting Landmarks');
    phisTr = vertcat(phisTr, [pst_x, pst_y, occluded]);
    
    %____Adding ROI(Rectangle) to bboxesTr____%
    disp('Select a Rectangular ROI');
    bboxesTr = vertcat(bboxesTr, [0, 0, 640, 480]);
end
    file_name = input('Name of File: ')
    save(file_name, 'IsT', 'phisT', 'bboxesT')

function point_collect(range, double_record)
global pst_x;
global pst_y;
for i=range
    [x,y] = getpts;
    x
    y
    if(double_record)
        pst_x(i) = x(1);pst_x(i+1) = x(1);
        pst_y(i) = y(1);pst_y(i+1) = y(1);
    else
        pst_x(i) = x(1);pst_y(i) = y(1);
    end
end
end
