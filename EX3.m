% Main script running the visual search Experiment 
%% Constants defining
blocks = cell(8,1); levels = [4,8,12,16]; colors = ["blue","red"];
% Condition IDs: 1 = Pop out, 2 = conjunction. *run_trial function relies
% on these IDs, so do not change (or change on both)
conditions = [1,2]; 
trials_per_block = 30; 

TARGET_ABSENCE_KEY = "n";
TARGET_PRESENCE_KEY = "t";
instructions = {"Welcome to the visual search Experiment.","", ...
    "In this experiment you are asked to detect the presence or absence of target: ", ...
    "a single feature that differs from the others.", ...
    "In presence of target press key- "+TARGET_PRESENCE_KEY+" . if there is no target press key- "+TARGET_ABSENCE_KEY, ...
    "","Press any key to begin... Good Luck!"};
block_break = "Press any key to start the next trial...";
end_of_exp = "That's it! Thank you for participating";
results_filename = "EX3_data.mat";
figure_filename = "EX3_graphs.fig";

%% Blocks settings and randomization
% Create a matrix of the blocks (all combinations of levelsXconditions)
% using some temp variables, so we're not giving meaningful names (A,B)
[A,B] = meshgrid(levels,conditions); block_perm=cat(2,A',B'); 
block_perm = reshape(block_perm,[],2);

%Create struct that include for each block its condition, size, results,
%means and randomized order of trials
for i=1:length(blocks)
    block.level = block_perm(i,1);
    block.cond = block_perm(i,2);
    block.results = zeros(1,30);
    block.target_mean = 0;
    block.no_target_mean = 0;
    
    % Randomize trials by presence and color of target: 1/2 no target, 
    % 1/4 1st color, 1/4 2nd colors.
    trials = [zeros(1,trials_per_block/2),ones(1,floor(trials_per_block/4)), ...
        ones(1,ceil(trials_per_block/4))+1];
    randomized_trials = trials(randperm(trials_per_block));
    block.trials = randomized_trials;
    
    blocks{i}= block;
end
% Randomize blocks order
blocks = blocks(randperm(length(blocks)),:);


%% Run experiment
h=figure('Name','Visual Search Experiment');
set(h, 'Color','w','MenuBar','none');
g = text (0, 0.7, instructions);
axis off;


% Initialize means matrices. Each row will hold a different condition data
% (1-popout, 2-conj), each column represents different level
means_t = zeros(2,4);
means_n = zeros(2,4);

% Run all blocks
for i = 1:length(blocks)
    pause; clf; axis off;
    block = blocks{i};
    % Count the amount of successful trials with and without target, for
    % later mean calculations
    t_counter = 0;
    n_counter = 0;
    for j = 1:length(block.trials)
        % Get target and distractors colors
        target_presence = block.trials(j)~=0;
        if target_presence
            t_color = colors(block.trials(j));
        else % Draw random color
            t_color = colors(randi([1 2],1,1));
        end
        d_color = colors(colors~=t_color);
        
        % Run the trial and retrieve the pressed key, and response time
        [key,time] = run_trial(block.cond, block.level, target_presence, t_color, d_color);
        clf; axis off; 
        
        % Validate correct response and save the answer and reaction times
        if (~target_presence && strcmp(key,TARGET_ABSENCE_KEY))  
            block.results(j) = time;
            block.no_target_mean = block.no_target_mean + time;
            n_counter = n_counter + 1;
        elseif (target_presence && strcmp(key, TARGET_PRESENCE_KEY))
            block.results(j) = time;
            block.target_mean = block.target_mean + time;
            t_counter = t_counter + 1;
        else % Answer is wrong
            block.results(j)= NaN;
        end
    end
    
    % Calculate means
    block.no_target_mean = block.no_target_mean/n_counter;
    block.target_mean = block.target_mean/t_counter;
    % Update the mean's vectors
    means_t(block.cond, levels==block.level) = block.target_mean;
    means_n(block.cond, levels==block.level) = block.no_target_mean;
    
    blocks{i}=block;
    text(0.2,0.5,block_break);
end
clf; axis off;
text(0.2,0.5,end_of_exp); pause; 

%% Analyze data
% Define structures for convenient use (and beautiful results)
pop.target.means = means_t(1,:);
conj.target.means = means_t(2,:);
pop.no_target.means = means_n(1,:);
conj.no_target.means = means_n(2,:);

% Plot the present target graphs
subplot(2,1,1);
plot(levels, pop.target.means, 'Color', 'b'); hold on;
plot(levels, conj.target.means, 'Color', 'r');
xlabel('Set Size'); ylabel('Mean Reaction Time (sec)');
title('Correctly Identified the Presence of Target');
% Add the fitted slopes
pop.target.polyfit = polyfit(levels, pop.target.means, 1);
conj.target.polyfit = polyfit(levels, conj.target.means, 1);
plot(levels, polyval(pop.target.polyfit, levels), '--')
plot(levels, polyval(conj.target.polyfit ,levels), '--')

% Calculate Pearson coefficients and p value
[r, p] = corrcoef(levels,pop.target.means);
pop.target.pearson.r = r(1,2); pop.target.pearson.p = p(1,2);
[r, p] = corrcoef(levels,conj.target.means);
conj.target.pearson.r = r(1,2); conj.target.pearson.p = p(1,2);

% Check and mark significance
if pop.target.pearson.p<0.05 
    popt_p_text=", p<0.05";
else
    popt_p_text=", *not significant";
end
if conj.target.pearson.p<0.05
    conjt_p_text=", p<0.05";
else
    conjt_p_text=", *not significant";
end

legend("Pop Out.      r="+pop.target.pearson.r + popt_p_text,...
    "Conjunction. r="+conj.target.pearson.r+conjt_p_text, ...
    "Pop Out slope","Conjunction slope",'Location','northwest');


% Plot the absent target graphs
subplot(2,1,2);
plot(levels,pop.no_target.means,'Color', 'b'); hold on;
plot(levels,conj.no_target.means,'Color', 'r');
xlabel('Set Size'); ylabel('Mean Reaction Time (sec)');
title('Correctly Identified the Absence of Target');
% Add the fitted slopes
pop.no_target.polyfit = polyfit(levels, pop.no_target.means, 1);
plot(levels, polyval(pop.no_target.polyfit, levels), '--')
conj.no_target.polyfit = polyfit(levels, conj.no_target.means, 1);
plot(levels, polyval(conj.no_target.polyfit,levels), '--')

% Calculate Pearson coefficients and p value
[r, p] = corrcoef(levels, pop.no_target.means);
pop.no_target.pearson.r = r(1,2); pop.no_target.pearson.p = p(1,2);
[r, p] = corrcoef(levels, conj.no_target.means);
conj.no_target.pearson.r = r(1,2); conj.no_target.pearson.p = p(1,2);

if pop.no_target.pearson.p<0.05
    pop_p_text=", p<0.05";
else
    pop_p_text=", *not significant";
end
if conj.no_target.pearson.p<0.05
    conj_p_text=", p<0.05";
else
    conj_p_text=", *not significant";
end

legend("Pop Out.      r="+pop.no_target.pearson.r + pop_p_text,...
    "Conjunction. r="+conj.no_target.pearson.r + conj_p_text, ...
    "Pop Out slope", "Conjunction slope", 'Location', 'northwest');

% Save the data into results
results.pop=pop;
results.conj=conj;

save(results_filename, 'blocks', 'results');
savefig(figure_filename);
