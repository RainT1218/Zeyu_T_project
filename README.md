# This experiment script is inspired by Rutman et al. (2010) study, it is not a 100% replication of the original study. 
	Full citation: 
	Rutman, A. M., Clapp, W. C., Chadick, J. Z., & Gazzaley, A. (2010). Early Top–Down 
		Control of Visual Processing Predicts Working Memory Performance. Journal of 
		Cognitive Neuroscience, 22(6), 1224–1234. https://doi.org/10.1162/jocn.2009.21257

# Before running the script, please make sure you have installed "Psychtoolbox-3" and it's required runtime for Matlab
   You can find full instruction from here: http://psychtoolbox.org/download.html

# Please make sure all supplement file (.mat & .png) are in the same folder of the main delay_recognition_working_memory_task.m file.
  direct to this folder before running the function.  

# In the 137th line of code: 
	[win, winRect] = Screen('OpenWindow', 1, [0 0 0]);
							  ^
	when running the whole function "delay_recognition_working_memory_task", if you encounter problems such as Matlab crashed 
	or black screen, please change the 1 （indicated above) to value 0， this statement represent which screen you are going
	to use. Normally, 0 is your main screen, it might be different for different computer especially if you have multiple monitors. 
	You can find their official help document for this function here: http://psychtoolbox.org/docs/Screen-OpenWindow


## This script still can be optimized. Some part of the code can be integrated to a function. 
## First half part of the script is stimuli design and second part of the script is for experiment. 
