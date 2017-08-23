for i = 1:24
    imshow(IsTr{i});
    imsave
end
filenames = strings(1,24);
boxes = {};
for i = 1:24
    %filenames(i) = strcat('/Users/HannahLeou/Desktop/hands/hand_',int2str(i),'.bmp');
    boxes(i) = {bboxesTr(i,:)};
end
boxes

hands = table( filenames, boxes);
acfDetector = trainACFObjectDetector(hands,'NumStages',3);

for i = 1:29
    img = IsT{i};
    [bboxes,scores] = detect(acfDetector, img);
    for j = 1:length(scores)
        annotation = sprintf('Confidence = %.1f',scores(j));
        img = insertObjectAnnotation(img,'rectangle',bboxes(j,:),annotation);
    end
    figure
    imshow(img)
    while(waitforbuttonpress~=0)
    end
end