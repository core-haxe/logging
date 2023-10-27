package logging.formatters;

using StringTools;

typedef Colors = {
	level: String,
	className: String,
	reset: String
}

class PrettyANSIFormatter implements ILogLineFormatter {
    var colors: Colors;

	public function new() {
		colors = {
			level: "",
			className: "\033[33m",
			reset: "\033[0m"
		};
	}

    public function format(data:LogData, buffer:StringBuf) {
		colors.level = switch (data.level) {
			case Info: "\033[34m";
			case Debug: "\033[32m";
			case Error: "\033[31m";
			case Warning: "\033[33m";
			case Data: "\033[35m";
			case Performance: "\033[36m";
		}

		buffer.add(colors.level);
        buffer.add(cast(data.level, String).toUpperCase());
        buffer.add(colors.reset + " ");

        if (data.ref != null) {
			buffer.add(colors.className + "[");
            buffer.add(data.ref);
            buffer.add("] " + colors.reset);
        }
		
		if (data.message != null) {
			buffer.add(data.message + " ");
        }

		#if !js
		if (data.data != null) {
			buffer.add("".lpad(" ", 4) + formatObject(data.data));
		}
		#end
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
