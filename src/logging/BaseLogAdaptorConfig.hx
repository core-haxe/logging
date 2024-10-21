package logging;

import logging.LogLevel;

typedef BaseLogAdaptorConfig = {
    var ?disabled:Bool;
    var ?formatter:ILogLineFormatter;
    var ?levels:Array<LogLevel>;
    var ?packages:Array<String>;
    var ?exclusions:Array<String>;
}