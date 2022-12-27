package logging;

typedef LogData = {
    var timestamp:String;
    var level:LogLevel;
    var message:String;
    var ?data:Any;
    var ?ref:String;
    var ?instanceId:String;
}