# logging
flexible logging framework supporting various "adaptors" (used throughout core haxe libraries)

# basic usage

```haxe
LogManager.instance.addAdaptor(new ConsoleLogAdaptor({
    levels: [LogLevel.Info, LogLevel.Error], // will show all logs by default
    formatter: new MySuperFormatter(), // defaults "DefaultFormatter"
    packages: ["foo.bar"] // will show all packages by default
}));
```

(note that each log adaptor can have its own settings)

```haxe
var log = new Logger(SomeClass);
log.info("some string", someObject);
log.error("some string", someObject);
log.warn("some string", someObject);
log.debug("some string", someObject);
log.data("some string", someObject);
```
