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
  foundFiles = Finder.from(rootPath).exclude(['/.git', '/node_modules', '/dist']).findFiles("<#{goal}>")
  foundFiles.map((file) ->
    {path: file, diff: arrayDiff(file.split('/'), filePath.split('/')).length}
  ).sort((a, b) ->
    return -1 if a.diff < b.diff
    return 1 if a.diff > b.diff
    return 0
  )[0]?.path

arrayDiff = (x, y) ->
  x.filter((z) -> y.indexOf(z) == -1).concat(
    y.filter((z) -> x.indexOf(z) == -1))

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
