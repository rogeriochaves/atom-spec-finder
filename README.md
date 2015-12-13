Spec Finder
===================

Spec Finder is a language-agnostic plugin for atom that lets you quickly jump between your source and spec files, by simple pressing <kbd>Ctrl</kbd>+<kbd>.</kbd> on atom editor.

It is based on the homonymous plugin for Sublime Text 2.

## How does it work? How does it find my specs? ##

The plugin gets your current filename, like `foo.js`, and adds the regex `/.?(spec|test)\./i` to it's end, so, it will try to match with files like this:

- `foo.spec.js`
- `fooSpec.js`
- `fooTest.js`
- `foo-test.js`
- `foo_spec.js`

And so on. When you are on the test, the process is the oposite. Underneath it uses the `fs-finder` to find files by regex.

## TODO ##

By default it ignores the folders `/.git`, `/node_modules` and `/dist`, but it would be much better if it just read the `.gitignore` file and ignores files listed there.

I'd also like to add the search regex as a config instead of hardcoded.
