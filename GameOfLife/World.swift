//
//  World.swift
//  GameOfLife
//
//  Created by Hongze Xia on 2/5/20.
//  Copyright © 2020 Hongze Xia. All rights reserved.
//
import Foundation

struct Point: Hashable {
    let x: Int
    let y: Int

    init(_ i: Int, _ j: Int) {
        x = i
        y = j
    }

    static func == (lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }

    func asTuple() -> (Int, Int) {
        return (x, y)
    }
}


class World {
    private var cells = [[Bool]]()
    private var liveCells: Set<Point> = []
    private let neighbours = [
        (-1, 0), (0, -1), (1, 0), (0, 1),
        (1, 1), (-1, -1), (1, -1), (-1, 1)
    ]
    private let rows: Int
    private let cols: Int
    
    func getLiveCells() -> [(Int, Int)] {
        return liveCells.map {$0.asTuple()}
    }

    func getState(_ i: Int, _ j: Int) -> Bool {
        guard i < rows && j < cols else {
            preconditionFailure("index of out bound, (\(i), \(j)) vs (\(rows), \(cols))")
        }
        return cells[i][j]
    }

    func setState(_ i: Int, _ j: Int, _ state: Bool) {
        // set a cell to alive
        cells[i][j] = state
    }
    
    func flipState(_ i: Int, _ j: Int) {
        flipState(i, j, alterLiveCells: false)
    }

    func flipState(_ i: Int, _ j: Int, alterLiveCells: Bool) {
        cells[i][j] = !cells[i][j]
        if alterLiveCells {
            if cells[i][j] {
                liveCells.insert(Point(i, j))
            } else {
                liveCells.remove(Point(i, j))
            }
        }
    }

    func flipState(at positions: [(Int, Int)]) {
        positions.forEach(flipState)
    }

    init(_ nrows: Int, _ ncols: Int) { // empty world
        (rows, cols) = (nrows, ncols)
        cells = Array(repeating: Array(repeating: false, count: ncols), count: nrows)
    }

    convenience init(nrows: Int, ncols: Int, frac: Float) { // random world
        self.init(nrows, ncols)
        randomize(frac)
    }

    func randomize(_ frac: Float) {
        liveCells = []
        cells.indices.forEach { i in
            (0..<cols).forEach { j in
                let state = Float.random(in: 0 ..< 1) < frac
                if state {
                    cells[i][j] = true
                    liveCells.insert(Point(i, j))
                } else {
                    cells[i][j] = false
                }
            }
        }
    }

    func printWorld() {
        cells.forEach { row in
            let transformed = row.map { $0 ? "*" : "o" }
            print(transformed.joined(separator: " "))
        }
    }

    func step() -> [(Int, Int)] {
        // return list of cells that should be flipped
        var diff = [(Int, Int)]()
        for i in 0..<rows {
            for j in 0..<cols {
                if willLive(i, j) != cells[i][j] {
                    diff.append((i, j))
                }
            }
        }
        return diff
    }

    func stepNew() -> [(Int, Int)] {
        var diff = [(Int, Int)]()
        var visited = Set<Point>()
        var nextLiveCells = Set<Point>()
        while !liveCells.isEmpty {
            let p = liveCells.popFirst()!
            if !visited.contains(p) {
                visited.insert(p)
            } else {
                // important
                continue
            }

            let nextState = willLive(p.x, p.y)
            let thisState = cells[p.x][p.y]
            if nextState != thisState {
                diff.append(p.asTuple())
            }
            
            if nextState {
                nextLiveCells.insert(p)
            }

            if thisState {
                let validNeighbours = neighbours.map { (x, y) in
                    (x + p.x, y + p.y)
                }.filter(self.filterXY).map {Point($0, $1)}
                validNeighbours.forEach {liveCells.insert($0)}
            }
        }
        liveCells = nextLiveCells
        return diff
    }

    func willLive(_ i: Int, _ j: Int) -> Bool {
        /**
           1. Any live cell with two or three live neighbors survives.
           2. Any dead cell with three live neighbors becomes a live cell.
           3. All other live cells die in the next generation. Similarly, all other dead cells stay dead.
         */
        let liveNeighbourCount = neighbours.map { (x, y) in
            (x + i, y + j)
        }.filter(self.filterXY).filter { (x, y) in
            cells[x][y]
        }.count

        switch liveNeighbourCount {
        case 2:
            return cells[i][j] // a live cell with 2 live neighbours lives
        case 3:
            // a dead cell with 3 live neighbours lives
            // a live cell with 3 live neighbours lives
            return true
        default:
            return false
        }
    }

    func filterXY(x: Int, y: Int) -> Bool {
        return x >= 0 && y >= 0 && x < rows && y < cols
    }
}
