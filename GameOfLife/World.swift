//
//  World.swift
//  GameOfLife
//
//  Created by Hongze Xia on 2/5/20.
//  Copyright © 2020 Hongze Xia. All rights reserved.
//
import Foundation

class World {
    private var cells = [[Bool]]()
    private var ended = false
    private let neighbours = [
        (-1, 0), (0, -1), (1, 0), (0, 1),
        (1, 1), (-1, -1), (1, -1), (-1, 1)
    ]
    private let rows: Int
    private let cols: Int
    
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
        cells[i][j] = !cells[i][j]
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
        cells.indices.forEach { i in
            (0..<cols).forEach { j in
                cells[i][j] = Float.random(in: 0 ..< 1) < frac
            }
        }
    }

    func printWorld() {
        cells.forEach { row in
            let transformed = row.map { $0 ? "*" : "o" }
            print(transformed.joined(separator: " "))
        }
    }

    func step() {
        var newCells = Array(repeating: Array(repeating: false, count: rows), count: rows)
        var same = true
        for i in 0..<rows {
            for j in 0..<rows {
                newCells[i][j] = willLive(i: i, j: j)
                same = (newCells[i][j] == cells[i][j]) && same
            }
        }
        cells = newCells
        if same {
            ended = true
        }
    }

    func willLive(i: Int, j: Int) -> Bool {
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
    
    func hasEnded() -> Bool {
        return ended
    }
}
