% ==========================================================================
%> @file logger.m
%> @brief MATLAB Logger
% ==========================================================================
% ==========================================================================
%
%> A matlab class to create objects that can be used to log various events during the
%> exectuion of a matlab script/function. This class is mainly a container class, with
%> some additional functionality builtin to operate on the stored data in generating
%> plots, applying functions etc.
% 
%> The main aim of this class is to consolidate and store all the outputs and
%> messages from a MATLAB script/function into a single object.  These objects
%> can be saved, and retrieved later, with all the information in one place
%> Several utility functions (mainly for plotting) make it easy to operate on
%> the stored data.
%
%> There are several ways in which you can use this class. You can either
%> (1) create a logger object, and start logging into the class
%> (2) user's class can be inherited from logger
%> (3) a global/persistent logger object can be created to log from various functions
%> (4) you can use matlab's event framework to log events by adding appropriate listeners.
% 
%> Simple Example usage:
%> 
%> 	l = logger;
%>
%> 	for i = 1:100,
%> 		my_output_1 = 10*rand;
%> 		height = 1.5*my_output_1 + 5*rand;
%> 	
%> 		l.logVal('weight', my_output_1);
%> 		l.logIt(height);
%> 	end
%> 	
%> 	l.setDesc('weight','Weight of Subjects');
%> 	l.setDesc('height','Height of Subjects');
%> 	l.setDefaultDesc('Subject ID');
%> 	
%> 	figure; l.plot2Vars('weight','height','LineWidth', 2, 'Color','r'); 
%> 	figure; l.plotVar('weight','LineWidth', 2, 'Color','r'); 
%> 	figure; l.plotVar('height','LineWidth', 2, 'Color','r'); 
%> 	figure; l.plotFofVar('height',@log, 'LineWidth', 2, 'Color','r'); 
%> 
%> Also see logger_demo.m for example usage.
%
% ==========================================================================
% Author: 	 Pavan Mallapragada 
% Organization:  Massachusetts Institute of Technology
% Contact:       <pavan_m@mit.edu>
% Created:       Oct 01, 2011 
% ==========================================================================

classdef logger < dynamicprops

properties (Access = public)
	%> A structure that stores the descriptions of the fields. These descriptions are used for labeling plots.
	d;
end
properties (Access = public)
	%> A cell array that stores all the fields that are being logged by the object currently, as strings.
	fields;
end
properties (Access = public)
	%> A string containing field name to perform default operations on.  Currently this is unused.
	defaultfield;
end
properties (Access = public)
	%> Cell array to store messages
	messages;
end
properties (Access = public)
	%> Cell array to store warnings
	warnings;
end
properties (Access = public)
	%> Cell array to store error messages
	errors; % Really? :)
end
properties (Access = public)
	%> Boolean value. If set to true, logger will not print any of its messages. It will still print the warnings/errors that the user specifies it to.
	silent;
end
properties (Access = public)
	%> The function handle used for plotting. Default is plot.
	plotfunc;
end
properties (Access = public)
	%> The function handle used for displaying interal messages of logger object. Default is set to warning.
	mesgfunc;
end
properties (Access = public)
	%> A string used for labeling the x-axis when plotting single variables.
	defaultDesc;
end

methods 
% ==========================================================================
%> @brief constructs an empty logger object.
%> 
%> Initializes basic plotting functions, verbosity and messaging options.
%> Initializes the structures used for storing messages/warnings/errors
%> etc.
%>
%> @retval obj object of the logger class. 
% ==========================================================================

	function [obj] = logger()
	
		obj.silent = false;

		obj.d = struct;

		obj.messages = {};
		obj.warnings = {};
		obj.errors   = {};
		
		obj.plotfunc = @plot;
		obj.mesgfunc = @warning;
		obj.silent   = true;

		obj.defaultDesc = '';
	end
end

methods
% ==========================================================================
%> @brief generic logger function without a specific name for the logged-object.
%> 
%> This function accepts any matlab variable as input, and starts logging it
%> with the same name.  This is useful when you do not want to give a different
%> name to the logged object than its own variable name. This function
%> determines if the variable is a numeric scalar or an object, and calls the
%> appropriate named-logger function.
%> 
%> @param obj An object of the logger class.
%> @param variable any variable from your workspace.
% ==========================================================================

	function [] = logIt(obj, variable)

		varname = inputname(2);
	
		if isnumeric(variable) && isscalar(variable)
			obj.logVal(varname, variable);
		else
			obj.logObj(varname, variable);
		end
	end
end

methods 
% ==========================================================================
%> @brief logs the given message in the error category. 
%>
%> Logs the error messages. This can be used for failed assertions or any other errors.
%> This is useful when a logger object is declared persistent or global and mutliple
%> functions are communicating with the same logger object.
%>
%> @param obj An object of the logger class.
%> @param mesg : a string containing your error message. If you are sure you will never set show to true, this can be any object. Although it is not recommended.
%> @param show : true/false specifying whether to print the message on the command window.
% ==========================================================================

	function [] = logErr(obj, mesg, show)
		obj.errors{end+1} = mesg;
		if nargin > 2 && show
			fprintf('(e): %s\n',mesg);
		end
	end
end

methods 
% ==========================================================================
%> @brief logs the given message in the warning category. 
%>
%> Logs the warning messages. 
%>
%> @param obj An object of the logger class.
%> @param mesg : a string containing your warning message. If you are sure you will never set show to true, this can be any object. Although it is not recommended.
%> @param show : true/false specifying whether to print the message on the command window.
% ==========================================================================
	function [] = logWarn(obj, mesg, show)
		obj.warnings{end+1} = mesg;
		if nargin > 2 && show
			fprintf('(w): %s\n',mesg);
		end
	end
end

methods 
% ==========================================================================
%> @brief logs the given message in the information category. 
%>
%> Logs any information messages given. 
%>
%> @param obj An object of the logger class.
%> @param mesg : a string containing your warning message. If you are sure you will never set show to true, this can be any object. Although it is not recommended.
%> @param show : true/false specifying whether to print the message on the command window.
% ==========================================================================

	function [] = logMesg(obj, mesg, show)
		obj.messages{end+1} = mesg;
		if nargin > 2 && show
			fprintf('(i): %s\n',mesg);
		end
	end
end

methods
% ==========================================================================
%> @brief This function logs the non-numeric objects, and stores them in a field as a cell array.
%>
%> This is useful for storing arrays, structures, etc that are non-scalar and non-numeric. These fields cannot be used for
%> plotting at this point. More functionality on this would be added in the newer versions. At this point
%> The class is only a container for these objects. 
%> 
%> @param obj An object of the logger class.
%> @param field The field name you are logging.
%> @param val   The value any matlab object.
% ==========================================================================
	function [] = logObj(obj, field, val)
		try
			obj.(field){end+1} = val;
		catch
			obj.addprop(field);
			if ~obj.silent
				fprintf(['Logger: new field added to the logger object: ', field,'\n']);
			end
			obj.fields{end+1} = field;
			obj.(field) = {};
			obj.(field){end+1} = val;
		end

	end
end

methods 
% ==========================================================================
%> @brief This function sets the default message function for the logger object.
%>
%> If you want logger to not quit your process, because of an error it
%> encounters, you can set it to @warning (it is default). If you want to be
%> strict, and debut errors in logger function calls, you can set it to @error.
%> 
%> @param obj An object of the logger class.
%> @param mf function handle you would like to use for displaying logger's internal error/warning messages.
% ==========================================================================
	function [] = setMesgFunc(obj, mf) 
		obj.mesgfunc  = mf; 
	end 
end

methods
% ==========================================================================
%> @brief Default description which is used for labeling the x-axis.
%> 
%> This is useful while plotting single-variables (fields).
% ==========================================================================
	function [] = setDefaultDesc(obj, str)
		obj.defaultDesc = str;
	end
end

methods 
% ==========================================================================
%> @brief This function is not used yet. This is written here for possible future use.
% ==========================================================================
	function [] = setDefaultField(obj,field)
		obj.defaultField =  field;
	end
end

methods
% ==========================================================================
%> @brief Overriden disp function for the logger class.
%>
%> Displays the logger object with all its fields and their sizes.
% ==========================================================================

	function [] = disp(obj)
		fprintf('Logger Object\n\n');
		fprintf('User Fields:\n');

		for i = 1:numel(obj.fields)
			fprintf('%12s : %d log entries\n', obj.fields{i}, length(obj.(obj.fields{i})));
		end

		fprintf('OTHERS:\n');

		fprintf('    messages : %d log entries\n', length(obj.messages));
		fprintf('    warnings : %d log entries\n', length(obj.warnings));
		fprintf('      errors : %d log entries\n', length(obj.errors));
	end
end

methods 
% ==========================================================================
%> @brief set the description for a field to be used for x-y labels in plotting. 
%> 
%> The arguments could be two cell arrays, with fieldname
%> and descritpion corresponding to each other, or two strings. 
%>
%> @param obj An object of the logger class
%> @param f   A string or a cell array of strings containing the field names 
%> @param desc   A string or a cell array of strings containing descriptions of corresponding fields
%>
% ==========================================================================

	function [obj] = setDesc(obj, f, desc)

		if ischar(f) && ischar(desc)
			obj.d.(f) = desc;
		end

		if iscell(f) && iscell(desc)
			for i = 1:numel(f)
				obj.d.(f{i}) = desc{i};
			end
		end
	end
end

methods 
% ==========================================================================
%> @brief Sets the plotting function to be used. 
%> 
%> Sets the plot function. Its default vaule is plot. You can make it semilogx, semilogy, etc.
%>
%> @param pf_handle Plot function handle.
% ==========================================================================

	function [obj] = setPlotFunc(obj, pf_handle)
		obj.plotfunc = pf_handle;
	end
end

methods
% ==========================================================================
%> @brief given a string specifying a numeric scalar field, and a funtion handle,
%> the function is first applied to the field, and then it is plotted.
%>  
%> For example, if a user logs a fields 'height', the log(heights) can be plotted as
%> logger.plotFofVar('height',@log). The parameters to
%> the plot can be provided after the fields, and all
%> those arguments go to the plot function.  For example,
%> logger.plotFofVar('height','@log','LineWidth',2,'Color','r'); will pass the
%> last four arguments to plot.
%>
%> @param obj logger object
%> @param field   a string specifying the name of logged field.
%> @param func   a function handle that is to be evaluated on the field.
%> @param varargin  any arguments that are to be sent to the plotting function.
%> 
%> @retval h A handle to the plot generated. Useful for formatting by the user.
% ==========================================================================


	function [h] = plotFofVar(obj, field, func, varargin)

		if ~ischar(field), 	 mesgfunc([field 'must be a string specifying field that are already added to the logger object.']); return; end
		if ~isnumeric(obj.(field)) mesgfunc(['Plotting only numeric values is supported at this point. Not generating the plot for' field]); return; end
		if ~isa(func, 'function_handle') mesgfunc(['third argument func must be a function handle']); return; end

		plotvals = func(obj.(field));

		h = obj.plotfunc(obj.(field), varargin{:});

		hold on;

		ylabel([func2str(func) ' (' obj.d.(field) ')'], 'FontSize', 16);
		if ~isempty(obj.defaultDesc)
			xlabel(obj.defaultDesc,'FontSize',16);
		end

		set(gca,'FontSize',16);

		hold off;
	end
end

methods
% ==========================================================================
%> @brief given a string specifying a numeric scalar field, it is plotted.
%>  
%> For example, if a user logs a fields 'height', using
%> logger.plotVar('height') will plot height. The parameters to
%> the plot can be provided after the fields, and all
%> those arguments go to the plot function.  For example,
%> logger.plotVar('height','LineWidth',2,'Color','r'); will pass the
%> last four arguments to plot.
%>
%> @param obj logger object
%> @param field   a string specifying the name of logged field 1.
%> @param varargin  any arguments that are to be sent to the plotting function.
%> 
%> @retval h A handle to the plot generated. Useful for formatting by the user.
% ==========================================================================


	function [h] = plotVar(obj, field, varargin)

		if ~ischar(field), 	 mesgfunc([field 'must be a string specifying field that are already added to the logger object.']); return; end
		if ~isnumeric(obj.(field)) mesgfunc(['Plotting only numeric values is supported at this point. Not generating the plot for' field]); return; end


		h = obj.plotfunc(obj.(field), varargin{:});

		hold on;
	
		ylabel(obj.d.(field), 'FontSize', 16);

		if ~isempty(obj.defaultDesc)
			xlabel(obj.defaultDesc,'FontSize',16);
		end

		set(gca,'FontSize',16);
	end
end

methods
% ==========================================================================
%> @brief given two numeric scalar fields, they are plotted one against another. 
%>  
%>  
%> For example, if a user logs two fields 'height' and 'weight', giving
%> logger.plotvars('height','weight') will plot height vs. weight. The parameters to
%> the plot can be provided after the fields, and all
%> those arguments go to the plot function.  For example,
%> logger.plotvars('height','weight','LineWidth',2,'Color','r'); will pass the
%> last four arguments to plot.
%>
%> @param obj logger object
%> @param f1   a string specifying the name of logged field 1.
%> @param f2   a string specifying the name of logged field 1.
%> @param varargin  any arguments that are to be sent to the plotting function.
%> 
%> @retval h A handle to the plot generated. Useful for formatting by the user.
% ==========================================================================

	function [h] = plot2Vars(obj, f1, f2, varargin)

		if ~ischar(f1) || ~ischar(f2) 
			mesgfunc([f1 ' and ' f2 'must be strings specifying fields that are already added to the logger object.']);
		end


		if ~isnumeric(obj.(f1)) || ~isnumeric(obj.(f2))
			mesgfunc(['Plotting only numeric values is supported at this point. Not generating the plot' f1 'vs' f2]);
		end

		h = obj.plotfunc(obj.(f1), obj.(f2),varargin{:});

		hold on;
		
		desc1 = obj.d.(f1);
		desc2 = obj.d.(f2);

		xlabel(desc1, 'FontSize', 16);
		ylabel(desc2, 'FontSize', 16);
		set(gca,'FontSize',16);
	end
end

methods
% ==========================================================================
%> @brief A function that logs a value at the end of a MATLAB arrayr, specified by its name.
%>
%> If a field exists, the element is added to the end of that field.
%> Otherwise, the field is created in the current object, and then logging starts by adding the 'val' as the first value.
%> if 'silent' is true, this addition is not informed. otherwise, a message is printed.
%> 
%> @param obj An object of the logger class.
%> @param field the name of the field to store the logged values in.
%> @param value : scalar numeric value to be logged.
% ==========================================================================

	function [] = logVal(obj, field, val)
		try
			obj.(field)(end+1) = val;
		catch
			obj.addprop(field);
			obj.d.(field) = field;
			if ~obj.silent
				fprintf(['Logger: new field added to the logger object: ', field,'\n']);
			end
			obj.fields{end+1} = field;
			obj.(field) = [];
			obj.(field)(end+1) = val;
		end
	end
end


methods
% ==========================================================================
%> @brief To set true or false for 'silent' behavior; No messages from the logger class.
%>
%> This function sets the silent variable true or false. If true, then the internal error messages
%> of the logger class are not printed out. Whatever the user specifies by setting the show variable
%> in the logWarn, logMesg functions are still printed out to the command window.
%>
%> @param obj An object of the logger class.
%> bool : true or false specifying the silent behavior of the class.
% ==========================================================================
	function [] = setSilent(obj, bool)
		obj.silent = bool;
	end
end


end % of class.
