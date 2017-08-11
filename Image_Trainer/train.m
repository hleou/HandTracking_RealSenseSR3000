clc; clear;
vidDepth = imaq.VideoDevice('winvideo', 2, 'INVI16_640x480');
depthVideo = vision.VideoPlayer;
disp('Successful Connection with RealSense SR3000')

n_samples = input('Number of Samples: ')
n_points = 29

phisTr = zeros(n_samples, n_points*3);
bboxesTr = zeros(n_samples, 4);
IsTr = cell(n_samples,1);

for m = 1:n_samples
    %__________Adding Image to IsTr__________%load
    disp('Click when ready for another frame capture')
    while(waitforbuttonpress ~= 0)
    end
    capture = double(objectFrame);
    imshow(capture);
    keep_capture = input('Keep this frame? Y/N');
    if (keep_capture == 'y' || keep_capture == 'Y')
        IsTr(m) = {capture};
    else
        m = m-1;
    end
    
end

for n = 1:n_samples
    imshow(IsTr{n});
    %_________Adding Points to phisTr_________%
    global pst_x = zeros(1,n_points);
    global pst_y = zeros(1,n_points);
    occluded = zeros(1,n_points);
    disp('Select 1 point in the middle of each finger (Begin at pinky finger)');
    point_collect((1:5), TRUE);
    disp('Select 1 point on each fingertip (Begin at pinky finger)');
    point_collect((11:15), FALSE);
    disp('Select 1 point on each edge (median height) of the hand (Left/Right)');
    point_collect((16:17), FALSE);
    disp('Select the joint between the (1)Pinky/Ring Fingers and (2)Thumb/Index Fingers');
    point_collect((18:19), TRUE);
    disp('Select the outside (1)Pinky base and (2)Thumb base');
    point_collect((22:23), TRUE);
    disp('Select 3 landmarks on the wrist (Left, Center, Right)');
    point_collect((26:28), FALSE);
    disp('Select 1 landmarks in the center of the palm');
    point_collect((29:29), FALSE);
    
    disp('Done Collecting Landmarks');
    phisTr = vertcat(phisTr, [pst_x, pst_y, occluded];
    
    %____Adding ROI(Rectangle) to bboxesTr____%
    disp('Select a Rectangular ROI');
    rect = getrect;
    bboxesTr = vertcat(bboxesTr, rect);
end
    save('DATA_T.mat', 'IsT', 'phisT', 'bboxesT')
    save('DATA_Tr.mat', 'IsTr', 'phisTr', 'bboxesTr')

function point_collect(range, double_record)
for i=range
    [x, y] = getpts(1);
    disp('Point Selected: (' + x(1) + ',' + y(1) + ')');
    if(double_record)
        pst_x(point_index) = x(1);pst_x(point_index+1) = x(1);
        pst_y(point_index) = y(1);pst_y(point_index+1) = y(1);
    else
        pst_x(point_index) = x(1);pst_y(point_index) = y(1);
    end
end
end
