# PathFinder

Simple A\* path finder.

```coffee
PathFinder = require 'path-finder'
sample_hitmap = [
  [1, 1, 1, 1, 1, 1, 1]
  [1, 0, 0, 0, 0, 0, 1]
  [1, 0, 1, 0, 1, 0, 1]
  [1, 0, 1, 0, 1, 0, 1]
  [1, 0, 1, 0, 1, 1, 1]
  [1, 0, 1, 0, 0, 0, 1]
  [1, 0, 0, 1, 1, 0, 1]
  [1, 1, 1, 1, 1, 1, 1]
]

PathFinder.dumpHitmap sample_hitmap
finder = new PathFinder
start = [6, 1]
goal = [3, 5]
console.log 'result', finder.searchPath sample_hitmap, start, goal
```

Result

```
**************
**          **
**  **  **  **
**  **  **  **
**  **  ******
**  **      **
**    ****  **
**************
result [ [ 6, 1 ],
  [ 5, 1 ],
  [ 4, 1 ],
  [ 3, 1 ],
  [ 2, 1 ],
  [ 1, 1 ],
  [ 1, 2 ],
  [ 1, 3 ],
  [ 1, 4 ],
  [ 1, 5 ],
  [ 2, 5 ],
  [ 3, 5 ] ]
```
