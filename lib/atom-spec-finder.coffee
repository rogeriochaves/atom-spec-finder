Finder = require 'fs-finder'
Path = require 'path'

specRegex = '.?(spec|test)\\.'

createRegex = (pattern) ->
  new RegExp(pattern, 'i')

createSpecRegex = -> createRegex(specRegex)

isSpec = (filename) ->
  filename.match(createSpecRegex())

findSource = (rootPath, filePath) ->
  current = Path.basename(filePath)
  goal = current.replace(createSpecRegex(), '.').replace(/\./g, '\\.')
  findMostSimilarFile(rootPath, filePath, goal)

findSpec = (rootPath, filePath) ->
  current = Path.basename(filePath)
  goal = current.replace('.', specRegex)
  findMostSimilarFile(rootPath, filePath, goal)

findMostSimilarFile = (rootPath, filePath, goal) ->
  Finder.from(rootPath).findFirst().findFiles("<#{goal}>")

module.exports =
  findSpecOrSource: (rootPath, filePath) ->
    (if isSpec(Path.basename(filePath)) then findSource else findSpec)(rootPath, filePath)

  activate: (state) ->
    atom.commands.add 'atom-text-editor',
      'atom-spec-finder:toggle': (event) => @toggle()

  toggle: ->
    editor = atom.workspace.getActiveTextEditor()
    root = atom.project.getPaths()[0]
    file = @findSpecOrSource(root, editor.getPath())
    atom.workspace.open(file) if file?
