function [key, time] =  run_trial(cond, level, target, t_color, d_color)
%RUN_TRIAL - run trial by input properties

shapes=["o","x"];
% Initialize a matrix containing the areas of figures already on screen, in
% order to avoid overlapping
bounds = [[NaN] ; [NaN]];

% Set target and distracters shapes randomly
t_shape = shapes(randi([1 2],1,1)); 
d_shape = shapes(shapes~=t_shape);

if cond==1 % Pop-out
    if target
        bounds = show_shapes(t_shape,t_color,1,bounds);
    else % -> No-target trial: all shapes are distracters
        bounds = show_shapes(d_shape,t_color,1,bounds);
    end
    % Show distracters
    bounds = show_shapes(d_shape,t_color,(level-1),bounds);
    
else % Conjunction
    if ~target
        bounds = show_shapes(t_shape,t_color,(level/2),bounds);
        bounds = show_shapes(d_shape,d_color,(level/2),bounds);
    else
        bounds = show_shapes(t_shape,t_color,1,bounds);
        % Distracters
        bounds = show_shapes(t_shape,d_color,(level/2 - 1),bounds);
        bounds = show_shapes(d_shape,t_color,(level/2),bounds);
    end
end

[key,time] = getkey(1,'non-ascii');
