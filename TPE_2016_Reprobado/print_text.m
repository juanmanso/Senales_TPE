% Print text in MATLAB


% Create the figure
mFigure = figure()

% Create a uicontrol of type "text"
mTextBox = uicontrol('style','text')
set(mTextBox,'String','Hello World')

% To move the the Text Box around you can set and get the position of Text
Box itself
mTextBoxPosition = get(mTextBox,'Position')
% The array mTextBoxPosition has four elements
% [x y length height]

% Something that I find useful is to set the Position Units to Characters,
the default is pixels
set(mTextBox,'Units','characters')
% This means a Text Box with 3 lines of text will have a height of 3