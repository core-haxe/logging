package logging;

interface ILogLineFormatter {
    function format(data:LogData, buffer:StringBuf):Void;
    function formatObject(obj:Any):String;
}