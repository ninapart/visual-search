# visual-search
Measuring and analyzing reaction times in a visual search experiment

Background

 The goal of this exercise is to collect and analyze reaction time data using
  MATLAB.
  
 We will focus on the visual search paradigm (see presentation).

  1. MATLAB functions tic and toc

  To measure reaction times (RT) we will use tic and toc. Try the following on the
  command line:
  >> tic
  >> toc
  
What is your elapsed time?
Check the MATLAB function pause:

>> tic; pause(0.5); toc

Run it several times and check the accuracy of MATLAB.

  2. Using handles

A handle typically pertains to an object or a figure, for our purposes.
Create a figure with the handle h by typing:

>> h = figure;

To set the background color to white and turn the menu bar off, type:
>> set(h, 'Color','w','MenuBar','none');
To change the name of the figure type:
>> set(h,'Name','Visual Search Experiment');
To see all properties that can be set, type:
>> set(h)

To see the value of a particular property, such as 'position', type:
Neural data-analysis Workshop Oren Shriki, Nir Friedman, Erez Wolfson

>> get(h,'position')

To see the values of all properties type:

>> get(h)

To plot a text on the figure use:

>> g = text (0.5, 0.5,'this is pretty cool');

Check the properties that can be set for a text object.
To turn of the axes use:

>> axis off

  3. Creating a visual search display
Our stimuli will contain o and x elements in the colors blue and red. Use the text command to create a figure with 7 red o's and a single red x. All letters should be randomly placed on the screen. This represents an example of a single-feature visual search display containing a target stimulus.
Create a display with 4 red x's, 3 blue o's and a single red o. This represents an example of a conjunction search.
To obtain the user input after presenting a stimulus with handle h, use:

>> pause; key = get(h,'CurrentCharacter');

The variable key should contain the character with which you overcame pause.
Alternatively, download the function getkey, which gives the ascii code of the key pressed.
Using the char function, you can retrieve the identity of the letter.
To compare the user's response with the correct response use the strcmp command.

  4. Constructing a visual search experiment

 The experiment should include two conditions: pop-out search vs. conjunction search.

 The experiment should include an opening screen with instructions, and the experiment
should start only after pressing a certain key.

 Through the entire experiment, there should be a single figure- it should not close and reopen between each trial\block.

 There should be a pause screen between each block. The experiment should continue
only after pressing a certain key.

 Use 4 levels in each condition: set size = 4, 8, 12, 16.

 Create a block for each condition and level (altogether 8 blocks). Blocks order should be random. You must use a function for this part.

 Randomness:
  o It is imperative to randomly interleave trials with and without target. There
  should be an equal number of trials with and without targets.
  o In feature search, use a single color (choose randomly between blue and red).
  o In conjunction search, use a different color (blue and red) for each type of
  distracter. Make sure that the number of blue and red stimuli is balanced.
  o Note- In the conjunction search, something has to give. We are balancing the
  shape, not the color. For example, a trial in this context will have:
         4 red X’s
         3 blue O’s
         1 red O
        
 Use only correct trials (user indicated no target present when no target was present or
indicated target present when it was present) for the analysis.

 Try to be as quick as possible while making sure to be right. It would be suboptimal if
you had a speed/accuracy trade-off in your data.

 The analysis should contain at least 20 correct trials per level and condition for a total of 160 trials (to be on the safe side use >30 trials in each level and condition). They should go quickly (about 1 second each).
 Pick two keys on the keyboard to indicate responses (say, 't' for target present and 'n' for target absent).
 Report and graph the mean reaction times for correct trials as a function of set size. Use a separate figure for trials where the target was present and trials where the target was absent. In each case, plot the results for pop-out search and for conjunction search on the same figure.

 Report the Pearson correlation coefficients between reaction time and set size and
indicate whether it is significant or not (for each condition). Use the function
corrcoef.

 Use polyfit (with a polynomial of order 1) to assess the slopes in the different
conditions. Use polyval to compute the fit and add it to the figure.

 Save the raw results of each experiment using the save command.

Hints:
 Start writing one trial and make sure it works properly.
Neural data-analysis Workshop Oren Shriki, Nir Friedman, Erez Wolfson
 Be aware that you effectively have an experimental design with three factors [Set size: 4 levels (4, 8, 12, 16), conjunction versus feature search: 2 levels, target present versus absent: 2 levels]. Use separate blocks for the first two factors and randomize the last one within each block.

 Be sure to place the targets and distracters randomly.

 Start by creating a figure.

 Each trial will essentially consist of newly presented, randomly placed text.

 Be sure to make the figure big enough to see it clearly.

 Make a function to create the display depending on the number of elements, the type of
search (feature or conjunction) and the presence or absence of a target.

 Make sure to make the text vanish before the beginning of the next trial.

 Determine RT by measuring time from appearance of target to user reaction.

 Elicit the key press and compare with the expected (correct) press to obtain a value for
right and wrong answers.

 Store the results in corresponding arrays and allocate memory in advance.

 Write a big loop that goes through trials. Do this at the very end, if individual trials work.

 You might want to have a start screen before the first trial, so as not to bias the times of the first few trials.

 You can divide the project to sub-goals and focus on a single sub-goal at a time.
Implement one function after the other. Start with two conditions.
