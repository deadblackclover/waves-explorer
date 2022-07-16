# waves-explorer
Waves explorer made using Elm

## Development Build

[Install Elm](https://guide.elm-lang.org/install.html) (e.g. with `npm install --global elm` or `make install`), then from the root project directory, run this:

```
$ elm make src/Main.elm --output elm.js
```

If you want to include the time-traveling debugger, add `--debug` like so:

```
$ elm make src/Main.elm --output elm.js --debug
```

## Production Build

(Make sure you have [Uglify](http://lisperator.net/uglifyjs/) installed first, e.g. with `npm install --global uglify-js` or `make install`)

```
make build
```
