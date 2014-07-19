# lodash clone
find = (arr, fn) ->
  for i in arr
    return i if fn(i)

findIndex = (arr, fn) ->
  for i, index in arr
    return index if fn(i)

compact = (arr) -> arr.filter (i) -> i?

{pow} = Math

dump = (hitmap) ->
  for row in hitmap
    console.log row.map((v) -> if v then '**' else '  ').join('')

# type Point = (x, y)
# type Node = (x, y, cost, parent?)

# searchList :: [Point] 
searchDirections = [
           [ 0, -1]
 [-1,  0],           [+1,  0]
           [ 0,  1]
]

# passable :: Any -> Boolean
passable = (v) -> v is 0

# searchPassableNodes :: [[Int]] -> Point -> [Node]
searchPassableNodes = (hitmap, [cx, cy], goal) ->
  compact searchDirections.map ([dx, dy]) ->
    if passable hitmap[cx+dx][cy+dy]
      [cx+dx, cy+dy, estimate([cx+dx, cy+dy], goal)]
    else
      null

# isGoal :: Point -> Point -> Boolean
isGoal = (current, goal) -> estimate(current, goal) is 0

# shiftMinCostNode :: [Node] -> Node
shiftMinCostNode = (nodes) ->
  return null if nodes.length is 0
  [minCost, minIndex] = nodes.reduce (([minCost, minIndex], [x, y, cost], index) ->
    if minCost < cost then [minCost, minIndex] else [cost, index]
  ), Infinity
  [p] = nodes.splice(minIndex, 1)
  p

# resolvePath :: Node -> [Point]
resolvePath = (node) ->
  [x, y, cost, parent] = node
  path = [[x, y]]
  while node = node[3]
    [nx, ny] = node
    path.push [nx, ny]
  path.reverse()

# searchPath :: [[Int]] -> Point -> Point -> Int? -> [Point]?
searchPath = (hitmap, start, goal, maxDepth = Infinity) ->
  currentCost = estimate start, goal
  if currentCost is 0 then return []

  [currentX, currentY] = start
  openNodes  = [[currentX, currentY, currentCost]] # [Node]
  closeNodes = [] # [Node]

  cnt = 0
  while node = shiftMinCostNode(openNodes)
    return null if ++cnt >= maxDepth

    [currentX, currentY, currentCost, currentParent] = node
    if currentCost is 0
      return resolvePath node

    closeNodes.push node
    nextNodes = searchPassableNodes hitmap, [currentX, currentY], goal

    for next in nextNodes
      [x, y, cost] = next

      if (index = findIndex(openNodes, ([ox, oy]) -> x is ox and y is oy)) > -1
        [ox, oy, oCost] = openNodes[index]
        if oCost > cost
          openNodes[index] = [x, y, cost, node]

      else if (index = findIndex(closeNodes, ([cx, cy]) -> x is cx and y is cy)) > -1
        [cx, cy, cCost] = closeNodes[index]
        if cCost > cost
          closeNodes.splice index, 1
          openNodes.push [cx, cy, cost, node]
      else
        openNodes.push [x, y, cost, node]

# estimate :: Point -> Point -> Float 
estimate = ([x1, y1], [x2, y2]) ->
  pow(x1-x2, 2)+pow(y1-y2, 2)
    
class PathFinder
  constructor: (options = {}) ->
    # TODO: options are not activated yet
    @estimate = options.estimate ? estimate
    @maxDepth = options.maxDepth ? Infinity
    @passable = options.passable ? passable
    @searchDirections = options.searchDirections ? searchDirections

  @dumpHitmap: (hitmap) ->
    dump hitmap

  searchPath: (hitmap, from, to) ->
    searchPath.call @, hitmap, from, to, @maxDepth

if module?.exports
  module.exports = PathFinder
else
  window.PathFinder = PathFinder

# sample_hitmap = [
  # [1, 1, 1, 1, 1, 1, 1]
  # [1, 0, 0, 0, 0, 0, 1]
  # [1, 0, 1, 0, 1, 0, 1]
  # [1, 0, 1, 0, 1, 0, 1]
  # [1, 0, 1, 0, 1, 1, 1]
  # [1, 0, 1, 0, 0, 0, 1]
  # [1, 0, 0, 1, 1, 0, 1]
  # [1, 1, 1, 1, 1, 1, 1]
# ]

# PathFinder.dumpHitmap sample_hitmap
# finder = new PathFinder
# start = [6, 1]
# goal = [3, 5]
# console.log 'result', finder.searchPath sample_hitmap, start, goal
