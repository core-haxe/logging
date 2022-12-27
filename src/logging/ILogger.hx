package logging;

interface ILogger {
    function info(message:String, data:Any = null):Void;
    function debug(message:String, data:Any = null):Void;
    function error(message:String, data:Any = null):Void;
    function warn(message:String, data:Any = null):Void;
    function data(message:String, data:Any = null):Void;
}