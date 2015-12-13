Spec Finder
===================

Spec Finder lets you quickly jump between your source and spec files, by simple pressing <kbd>Ctrl</kbd>+<kbd>.</kbd> on atom editor.

It is based on the homonymous plugin for Sublime Text 2.

## How does it work? How does it find my specs? ##

The plugin gets your current filename, like `foo.js`, and adds the regex `/.?(spec|test)\./i` to it's end, so, it will try to match with files like this:

- `foo.spec.js`
- `fooSpec.js`
- `fooTest.js`
- `foo-test.js`
- `foo_spec.js`

And so on. When you are on the test, the process is the oposite.

## TODO ##

This is the first version of this plugin, there is a problem that is still not solved, when two files have the same name Spec Finder picks the first one, which in a lot of cases is the wrong one, we have to check the path to see which one is the most simillar.