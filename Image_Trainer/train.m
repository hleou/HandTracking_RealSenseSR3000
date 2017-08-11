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
    for i = 1:5
        disp('Select 1 point in the middle of each finger (Begin at pinky finger)')
        [x, y] = getpts(1);
        disp('Point Selected: (' + x(1) + ',' + y(1) + ')');
        pst_x(i) = x(1); pst_y(i) = y(1);
        pst_x(i+1) = x(1); pst_y(i+1) = y(1);
    end
    for i = 1:5
        disp('Select 1 point on each fingertip (Begin at pinky finger)');
        [x, y] = getpts(1);
        disp('Point Selected: (' + x(1) + ',' + y(1) + ')');
        pst_x(i) = x(1); pst_y(i) = y(1);
        pst_x(i+1) = x(1); pst_y(i+1) = y(1);
    end
end

function point_collect(double_record)
    [x, y] = getpts(1);
    disp('Point Selected: (' + x(1) + ',' + y(1) + ')');
    if(double_record)
        
    end 
        
        
end 

    
    
    
    phis_el = [pst_x, pst_y, occluded];
    phisTr = vertcat(phisTr, phis_el);
    
    %____Adding ROI(Rectangle) to bboxesTr____%
    disp("rectangle")
    rect = getrect;
    bboxesTr = vertcat(bboxesTr, rect);
end

IsT = IsTr;
phisT = phisTr;
bboxesT = bboxesTr;

save('DATA_T.mat', 'IsT', 'phisT', 'bboxesT')
% save('DATA_Tr.mat', 'IsTr', 'phisTr', 'bboxesTr')
