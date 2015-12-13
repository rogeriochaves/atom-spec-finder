specFinder = require '../lib/atom-spec-finder'
Path = require 'path'
{Workspace} = require 'atom'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe 'SpecFinder', ->
  [workspaceElement, activationPromise] = []
  rootPath = Path.join __dirname, 'fixtures'

  currentPath = ->
    editor = atom.workspace.getActivePaneItem()
    file = editor?.buffer
    file?.getPath()

  toggleFile = (file) ->
    openFilePromise = atom.workspace.open file
    waitsForPromise ->
      openFilePromise
    runs ->
      editor = atom.workspace.getActiveTextEditor()
      atom.commands.dispatch atom.views.getView(editor), 'atom-spec-finder:toggle'
      waitsForPromise ->
        activationPromise

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('atom-spec-finder')

  describe 'when the atom-spec-finder:toggle event is triggered', ->
    it 'swtiches to spec file', ->
      toggleFile Path.join(rootPath, 'src/foo.js')

      runs ->
        expect(currentPath()).toBe Path.join(rootPath, 'spec/foo.spec.js')

  describe 'toggleSpecFile', ->
    foo = Path.join rootPath, 'src/foo.js'
    fooSpec = Path.join rootPath, 'spec/foo.spec.js'
    bar = Path.join rootPath, 'src/a/b/bar.js'
    barSpec = Path.join rootPath, 'spec/a/b/bar.spec.js'

    it 'returns spec file for source file', ->
      expect(specFinder.findSpecOrSource(rootPath, foo)).toBe fooSpec
      expect(specFinder.findSpecOrSource(rootPath, bar)).toBe barSpec

    it 'returns source file for spec file', ->
      expect(specFinder.findSpecOrSource(rootPath, fooSpec)).toBe foo
      expect(specFinder.findSpecOrSource(rootPath, barSpec)).toBe bar
