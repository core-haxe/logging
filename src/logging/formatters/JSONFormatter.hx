package logging.formatters;

class JSONFormatter implements ILogLineFormatter {
    public function new() {
    }

    public function format(data:LogData, buffer:StringBuf) {
        buffer.add(haxe.Json.stringify(data));
    }

    public function formatObject(obj:Any):String {
        if (obj == null) {
            return "";
        }
        switch (Type.typeof(obj)) {
            case TClass(haxe.ds.StringMap):
                var o:Dynamic = {};
                var sm = cast(obj, haxe.ds.StringMap<Dynamic>);
                for (key in sm.keys()) {
                    Reflect.setField(o, key, sm.get(key));
                }
                return haxe.Json.stringify(o);
            case _:
        }
        return Std.string(obj);
    }
}
