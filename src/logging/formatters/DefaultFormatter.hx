package logging.formatters;

using StringTools;

class DefaultFormatter implements ILogLineFormatter {
    public function new() {
    }

    public function format(data:LogData, buffer:StringBuf) {
        buffer.add(data.timestamp);
        buffer.add(" > ");

        buffer.add(data.level.getName().toUpperCase().rpad(" ", 7));
        buffer.add(" > ");

        if (data.ref != null) {
            buffer.add(data.ref);
            buffer.add(" > ");
        }

        if (data.instanceId != null) {
            buffer.add(data.instanceId);
            buffer.add(" > ");
        }

        if (data.message != null) {
            buffer.add(data.message);
        }
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