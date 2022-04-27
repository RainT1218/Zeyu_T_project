function delay_recognition_working_memory_task
load('stim_mat_gray.mat', 'im_mat_gray')
Face_matrix = im_mat_gray(:,:,1:60);
[row, col] = size(Face_matrix, 1, 2);

order = randperm(60);
random_face_order = order(1:12);

Face_all = NaN(row, col, 12);
for x = 1:12
    Face_all(:,:,x) = Face_matrix(:,:,(random_face_order(x)));
end

%Face_all = im2uint8(Face_all/255);


% Landscape image convertion    loading and assign to a matrix   
Landscape_matrix = NaN(172,115,12);

land1 = imread('land1.png');
land1 = rgb2gray(land1);
Landscape_matrix(:, :, 1) = land1;

land2 = imread('land2.png');
land2 = rgb2gray(land2);
Landscape_matrix(:, :, 2) = land2;

land3 = imread('land3.png');
land3 = rgb2gray(land3);
Landscape_matrix(:, :, 3) = land3;

land4 = imread('land4.png');
land4 = rgb2gray(land4);
Landscape_matrix(:, : , 4) = land4;

land5 = imread('land5.png');
land5 = rgb2gray(land5);
Landscape_matrix(:, : , 5) = land5;

land6 = imread('land6.png');
land6 = rgb2gray(land6);
Landscape_matrix(:, : , 6) = land6;

land7 = imread('land7.png');
land7 = rgb2gray(land7);
Landscape_matrix(:, : , 7) = land7;

land8 = imread('land8.png');
land8 = rgb2gray(land8);
Landscape_matrix(:, : , 8) = land8;

land9 = imread('land9.png');
land9 = rgb2gray(land9);
Landscape_matrix(:, : , 9) = land9;

land10 = imread('land10.png');
land10 = rgb2gray(land10);
Landscape_matrix(:, : , 10) = land10;

land11 = imread('land11.png');
land11 = rgb2gray(land11);
Landscape_matrix(:, : , 11) = land11;

land12 = imread('land12.png');
land12 = rgb2gray(land12);
Landscape_matrix(:, : , 12) = land12;

% Normalizing Landscape_matrix and face matrix
mn = 0;
Std = 0;
for x = 1:12
    mn1 = mean(Landscape_matrix(:, :, x),'all');
    mn2 = mean(Face_all(:,:,x),'all');
    std1 = std(Landscape_matrix(:,:,x), 1,'all');
    std2 = std(Face_all(:,:,x), 1,'all');
    mn = mn+mn1+mn2;
    Std = Std+std1+std2;
    if x == 12
       mn_average = mn/(2*x);
       Std_Average = Std/(2*x);
    end
end

Landscape_nor_matrix = NaN(172,115,12);
Face_nor_matrix = NaN(172,115,12);
for x = 1:12
    mn1 = mean(Landscape_matrix(:,:,x), 'all');
    mn2 = mean(Face_all(:,:,x), 'all');
    Std1 = std(Landscape_matrix(:,:,x),1,'all');
    Std2 = std(Face_all(:,:,x),1,'all');
    land = ((Landscape_matrix(:,:,x)) - mn1)/Std1;
    land = (land*Std_Average)+mn_average;
    Face = ((Face_all(:,:,x)) - mn2)/Std2;
    Face = (Face*Std_Average)+mn_average;
    Landscape_nor_matrix(:,:,x) = land;
    Face_nor_matrix(:,:,x) = Face;
end

% convert display range to 255
Landscape_nor_matrix = uint8(Landscape_nor_matrix);
Face_nor_matrix = uint8(Face_nor_matrix);

% imtool(Landscape_nor_matrix(:,:,1))

% Creating for stimuli sets: face only, scene only, face_scene overlay,
% scene_face overlay

Face_only_stimulus = Face_nor_matrix(:,:,1:6);      %face only sets
Scene_only_stimulus = Landscape_nor_matrix(:,:,1:6);     %scene only sets

%face scene overlap set
Face_scene_overlap = cell(1,6);                                     % create 1x6 cell array for six differnt face with different scene
single_face_to_scenes = NaN(172,115,6);
for x = 1:6
    for y = 1:6
        Morph_sti = Face_only_stimulus(:,:,x)/2 + Scene_only_stimulus(:,:,y)/2;
        single_face_to_scenes(:,:,y) = Morph_sti;
    end
    Face_scene_overlap{x} = single_face_to_scenes;
    Face_scene_overlap{x} = uint8(Face_scene_overlap{x});   %double to uint8
end

%scene face overlap sets
Scene_Face_overlap = cell(1,6);                               % create 1x6 cell array for six differnt scene with different faces
single_scene_to_faces = NaN(172,115,6);
for x = 1:6
    for y = 1:6
        Morph_sti = Scene_only_stimulus(:,:,x)/2 + Face_only_stimulus(:,:,y)/2;
        single_scene_to_faces(:,:,y) = Morph_sti;
    end
    Scene_Face_overlap{x} = single_scene_to_faces;
    Scene_Face_overlap{x} = uint8(Scene_Face_overlap{x});   %double to uint8
end

% Experiment part
Screen('preference', 'SkipSyncTests', 1)
[win, winRect] = Screen('OpenWindow', 1, [0 0 0]); %create screen
HideCursor;

Screen(win, 'Fillrect', WhiteIndex(win)); % white background
Screen('Flip',win)

key1 = KbName('y'); 
key2 = KbName('n');     % Two key involved in this experiment, for varification use

[x0, y0] = RectCenter(winRect);   % get the central point position, in order to make fixiation point

%Instruction part
inst_horzpos=800;             %text position         
top_vertpos=400;
inst_vertpos=30;             
color=30;                     % text color

Screen(win,'FillRect', WhiteIndex(win));
Screen('TextFont',win, 'Arial');
Screen('TextSize',win, 24);
Screen('TextStyle', win, 1);  %text style information

Screen('DrawText', win, 'In this part of study, you will first see a text instruction, it will either required to focus on', inst_horzpos, top_vertpos+inst_vertpos, color);

Screen('DrawText', win, 'face or landscape. After the text instruction, you will see the first image and after a short ', inst_horzpos, top_vertpos+inst_vertpos*2, color);

Screen('DrawText', win, 'period of time, you will see the second image. Based on the text instruction, you need to remember', inst_horzpos, top_vertpos+inst_vertpos*3, color);

Screen('DrawText', win, 'either face or landscape in both images. After a few second, you will be presented another image.', inst_horzpos, top_vertpos+inst_vertpos*4, color);

Screen('DrawText', win, 'Your task is to determain whether this images match one of the first two images. Press "y" if you', inst_horzpos, top_vertpos+inst_vertpos*5, color);

Screen('DrawText', win, 'think it matched first two images. Press "n" if it does not match. After you make response, next trail', inst_horzpos, top_vertpos+inst_vertpos*6, color);

Screen('DrawText', win, 'will automatically start in 5 second. Please press"y" to start the trail.', inst_horzpos, top_vertpos+inst_vertpos*7, color);

Screen('flip', win)   % instruction text and display

correctkey = key1;
while true
    [~, ~, keyCode] = KbCheck();         %check if 'y; key pressed or not, in order to start the experiment
    if keyCode(correctkey) ~= 0
        break
    end
end

Screen('TextSize',win, 40);   %increase the text size 24-> 40
Screen('DrawLine', win, [1 1 1],x0-20, y0, x0+20, y0, [10]);
Screen('DrawLine', win, [1 1 1],x0, y0-20, x0, y0+20, [10]);   %fixation point design and display
Screen('flip', win)
WaitSecs(3)
Screen('flip', win)

trial_number = 8;      % 8 trails in total
trail_sequence = randperm(trial_number);    % randomize the trial sequence
hit = 0;                                 % cumulate hit
FA = 0;                                  % cumulate false alarm 
reaction_time = 0;                        % cumulate reaction time

for k = 1:trial_number
    switch trail_sequence(k)      % randomized trial, number 1 - 8 represent differnet type of trail
        case 1                    % type 1: face only, Probe match at least one stimuli
            x = randperm(6,1); y = randperm(6,1); z = [x,y];
            idx = randperm(length(z),1);                %% p will be randomly generated but is only able to equal to either x or y
            p = z(idx);                                     % randomly choose face from stimuli 3D matrix, also ensure probe is same as one of the two stimuli
            img1 = Face_only_stimulus(:,:,x);
            img2 = Face_only_stimulus(:,:,y);
            img3 = Face_only_stimulus(:,:,p);               %prepare 3 stimuli
            
            Screen('DrawText', win, '                                     Face', inst_horzpos, top_vertpos+inst_vertpos*10, color);  % text instruction about what to focus on
            Screen('flip', win)
            WaitSecs(2)
           
            [hit, FA, reaction_time] = present_stimuli_same(img1, img2, img3, x0, y0, win, hit, FA, reaction_time, key1, key2); % provide input to the subfunction, which responsible for display stimuli and judge correctness
        case 2                                       % type 2: face only, probe does not match two stimuli
            x = randperm(6,1); y = randperm(6,1);
            z = setdiff(1:6, [x, y]);
            p = z(randi(numel(z)));          % p will be randomly generated but will not equal to either x or y

            img1 = Face_only_stimulus(:,:,x);
            img2 = Face_only_stimulus(:,:,y);
            img3 = Face_only_stimulus(:,:,p);
            
            Screen('DrawText', win, '                                     Face', inst_horzpos, top_vertpos+inst_vertpos*10, color); %instruction
            Screen('flip', win)
            WaitSecs(2)
           
            [hit, FA, reaction_time] = present_stimuli_diff(img1, img2, img3, x0, y0, win, hit, FA, reaction_time, key1, key2);
        case 3                                      %type 3 scene only, probe match at least one stimuli
            x = randperm(6,1); y = randperm(6,1); z = [x,y];
            idx = randperm(length(z),1);
            p = z(idx);                     % p will be randomly generated but is only possible to equal either x or y
            img1 = Scene_only_stimulus(:,:,x);
            img2 = Scene_only_stimulus(:,:,y);
            img3 = Scene_only_stimulus(:,:,p);
            
            Screen('DrawText', win, '                                     scene', inst_horzpos, top_vertpos+inst_vertpos*10, color); %instruction
            Screen('flip', win)
            WaitSecs(2)
           
            [hit, FA, reaction_time] = present_stimuli_same(img1, img2, img3, x0, y0, win, hit, FA, reaction_time, key1, key2);
        case 4                                      % scene only, probe does not match both stimuli
            x = randperm(6,1); y = randperm(6,1);
            z = setdiff(1:6, [x, y]);
            p = z(randi(numel(z)));     % p will be randomly generated but will not equal to either x or y

            img1 = Scene_only_stimulus(:,:,x);
            img2 = Scene_only_stimulus(:,:,y);
            img3 = Scene_only_stimulus(:,:,p);
            
            Screen('DrawText', win, '                                     scene', inst_horzpos, top_vertpos+inst_vertpos*10, color);%instruction
            Screen('flip', win)
            WaitSecs(2)
           
            Screen('DrawLine', win, [1 1 1],x0-20, y0, x0+20, y0, [10]);
            Screen('DrawLine', win, [1 1 1],x0, y0-20, x0, y0+20, [10]);   %fixation point
            Screen('flip', win)
            WaitSecs(2)
            
            [hit, FA, reaction_time] = present_stimuli_diff(img1, img2, img3, x0, y0, win, hit, FA, reaction_time, key1, key2);
        case 5
            x = randperm(6,1); y = randperm(6,1); 
            a = randperm(6,1); b = randperm(6,1); % generate 4 random number
            z = [x,y];
            idx = randperm(length(z),1);
            p = z(idx);                     % p equal to either x or y
            set1 = Face_scene_overlap{x}; set2 = Face_scene_overlap{y}; % randomly choose one face with different scene from the cell array
            set3 = Face_scene_overlap{p};
            c = randperm(6,1);
            
            img1 = set1(:,:,a);
            img2 = set2(:,:,b);
            img3 = set3(:,:,c);
            
            Screen('DrawText', win, '                                     Face', inst_horzpos, top_vertpos+inst_vertpos*10, color); %instruction
            Screen('flip', win)
            WaitSecs(2)
            
            [hit, FA, reaction_time] = present_stimuli_same(img1, img2, img3, x0, y0, win, hit, FA, reaction_time, key1, key2);
        case 6
            x = randperm(6,1); y = randperm(6,1);
            a = randperm(6,1); b = randperm(6,1); % generate 4 random number
            z = setdiff(1:6, [x, y]);
            p = z(randi(numel(z)));  %p could equal to any value ffrom 1-6 except same as x or y
            set1 = Face_scene_overlap{x}; set2 = Face_scene_overlap{y}; 
            set3 = Face_scene_overlap{p};
            c = randperm(6,1);
            
            img1 = set1(:,:,a);
            img2 = set2(:,:,b);
            img3 = set3(:,:,c);
            
            Screen('DrawText', win, '                                     Face', inst_horzpos, top_vertpos+inst_vertpos*10, color);%instruction
            Screen('flip', win)
            WaitSecs(2)
            
            [hit, FA, reaction_time] = present_stimuli_diff(img1, img2, img3, x0, y0, win, hit, FA, reaction_time, key1, key2);
        case 7
            x = randperm(6,1); y = randperm(6,1);
            a = randperm(6,1); b = randperm(6,1);
            z = [x,y];
            idx = randperm(length(z),1);                                        % same idea
            p = z(idx);
            set1 = Scene_Face_overlap{x}; set2 = Scene_Face_overlap{y}; 
            set3 = Scene_Face_overlap{p};
            c = randperm(6,1);
            
            img1 = set1(:,:,a);
            img2 = set2(:,:,b);
            img3 = set3(:,:,c);
            
            Screen('DrawText', win, '                                     Scene', inst_horzpos, top_vertpos+inst_vertpos*10, color);%instruction
            Screen('flip', win)
            WaitSecs(2)
            
            [hit, FA, reaction_time] = present_stimuli_same(img1, img2, img3, x0, y0, win, hit, FA, reaction_time, key1, key2);
        case 8
            x = randperm(6,1); y = randperm(6,1);
            a = randperm(6,1); b = randperm(6,1);
            z = setdiff(1:6, [x, y]);
            p = z(randi(numel(z)));
            set1 = Scene_Face_overlap{x}; set2 = Scene_Face_overlap{y};             % same idea
            set3 = Scene_Face_overlap{p};
            c = randperm(6,1);
            
            img1 = set1(:,:,a);
            img2 = set2(:,:,b);
            img3 = set3(:,:,c);
            
            Screen('DrawText', win, '                                     Scene', inst_horzpos, top_vertpos+inst_vertpos*10, color);%instruction
            Screen('flip', win)
            WaitSecs(2)
            
            [hit, FA, reaction_time] = present_stimuli_diff(img1, img2, img3, x0, y0, win, hit, FA, reaction_time, key1, key2);
    end
end

Screen('DrawText', win, '                            End of experiment', inst_horzpos, top_vertpos+inst_vertpos*12, color); % end instruction
Screen('flip', win)
WaitSecs(2)
Screen('CloseAll')  %close screen

report % report function report hit rate average RT
end
%%
function [hit, FA, reaction_time] = present_stimuli_same(img1, img2, img3, x0, y0, win, hit, FA, reaction_time, key1, key2)
            stimuli = Screen('MakeTexture', win, img1);
            Screen('DrawTexture', win, stimuli)
            Screen('Flip', win)
            WaitSecs(0.8)                 % first stimuli 800ms
            
            Screen('DrawLine', win, [1 1 1],x0-20, y0, x0+20, y0, [10]);
            Screen('DrawLine', win, [1 1 1],x0, y0-20, x0, y0+20, [10]);   %fixation point
            Screen('flip', win)
            WaitSecs(0.2)                 %fixation point 200ms
            
            stimuli = Screen('MakeTexture', win, img2);
            Screen('DrawTexture', win, stimuli)
            Screen('Flip', win)
            WaitSecs(0.8)                   % second stimuli 800ms
            
            Screen('DrawLine', win, [1 1 1],x0-20, y0, x0+20, y0, [10]);
            Screen('DrawLine', win, [1 1 1],x0, y0-20, x0, y0+20, [10]);   %fixation point
            Screen('flip', win)
            WaitSecs(4)                     %4000ms interval 
            
            stimuli = Screen('MakeTexture', win, img3);
            Screen('DrawTexture', win, stimuli)
            Screen('Flip', win)
            WaitSecs(0.5)               %probe stimuli for 500ms
            
            Screen('DrawLine', win, [1 1 1],x0-20, y0, x0+20, y0, [10]);
            Screen('DrawLine', win, [1 1 1],x0, y0-20, x0, y0+20, [10]);   %fixation point
            Screen('flip', win)

            response_start = GetSecs();
            while true
                [~, ~, keyCode] = KbCheck();                      %determine key pressing
                timelimit = GetSecs() - response_start;
                switch true
                    case keyCode(key1)==1 && timelimit <= 4                     % IN match setting,  press'y' is correct answer, thus hit+1
                        hit = hit + 1; save('result.mat','hit', 'reaction_time')     % if no respond in 4s, break the while loop continu to next trial. 
                        reaction_time = timelimit + reaction_time;
                        save('result.mat','hit', 'FA', 'reaction_time')
                        break 
                    case keyCode(key2)==1 && timelimit <= 4                     % 'n' incorrect in this setting FA+1
                        FA = FA + 1;
                        reaction_time = reaction_time + timelimit;
                        save('result.mat','hit', 'FA', 'reaction_time')          % REACTION TIME SAVED TO mat file
                        break
                    case timelimit > 4
                        FA = FA + 1;
                        reaction_time = reaction_time + 4;
                        save('result.mat','hit', 'FA', 'reaction_time')
                        break
                end
            end
            Screen('DrawLine', win, [1 1 1],x0-20, y0, x0+20, y0, [10]);
            Screen('DrawLine', win, [1 1 1],x0, y0-20, x0, y0+20, [10]);   %fixation point
            Screen('flip', win)
            WaitSecs(2)
end

function [hit, FA, reaction_time] = present_stimuli_diff(img1, img2, img3, x0, y0, win, hit, FA, reaction_time, key1, key2)
            stimuli = Screen('MakeTexture', win, img1);
            Screen('DrawTexture', win, stimuli)                    % similar to previous function
            Screen('Flip', win)
            WaitSecs(0.8)
            
            Screen('DrawLine', win, [1 1 1],x0-20, y0, x0+20, y0, [10]);
            Screen('DrawLine', win, [1 1 1],x0, y0-20, x0, y0+20, [10]);   %fixation point
            Screen('flip', win)
            WaitSecs(0.2)
            
            stimuli = Screen('MakeTexture', win, img2);
            Screen('DrawTexture', win, stimuli)
            Screen('Flip', win)
            WaitSecs(0.8)
            
            Screen('DrawLine', win, [1 1 1],x0-20, y0, x0+20, y0, [10]);
            Screen('DrawLine', win, [1 1 1],x0, y0-20, x0, y0+20, [10]);   %fixation point
            Screen('flip', win)
            WaitSecs(4)
            
            stimuli = Screen('MakeTexture', win, img3);
            Screen('DrawTexture', win, stimuli)
            Screen('Flip', win)
            WaitSecs(0.5)
            
            Screen('DrawLine', win, [1 1 1],x0-20, y0, x0+20, y0, [10]);
            Screen('DrawLine', win, [1 1 1],x0, y0-20, x0, y0+20, [10]);   %fixation point
            Screen('flip', win)

            response_start = GetSecs();
            while true
                [~, ~, keyCode] = KbCheck();
                timelimit = GetSecs() - response_start;
                switch true
                    case keyCode(key1)==1 && timelimit <= 4                         % this time mismatched settings, 'y' incorrect thus press it FA+1
                        reaction_time = timelimit + reaction_time;
                        save('result.mat','hit', 'FA', 'reaction_time')
                        break 
                    case keyCode(key2)==1 && timelimit <= 4                        % 'n' is correct, press it Hit +1
                        hit = hit + 1;
                        reaction_time = reaction_time + timelimit;
                        save('result.mat','hit', 'FA', 'reaction_time')
                        break
                    case timelimit > 4
                        FA = FA + 1;
                        reaction_time = 4 + reaction_time;
                        save('result.mat','hit', 'FA', 'reaction_time')
                        break
                end
            end
            Screen('DrawLine', win, [1 1 1],x0-20, y0, x0+20, y0, [10]);
            Screen('DrawLine', win, [1 1 1],x0, y0-20, x0, y0+20, [10]);   %fixation point
            Screen('flip', win)
            WaitSecs(2)
end

function report
load('result.mat','hit');
Hit = hit;
load('result.mat','FA');                  %Calculation
Fa = FA;
load('result.mat','reaction_time');
RT = reaction_time;

Hit_rate = Hit/(Hit+Fa);
Average_reaction_time = RT/8;
end