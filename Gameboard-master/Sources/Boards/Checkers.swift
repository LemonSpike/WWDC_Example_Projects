import UIKit

public struct Checkers {
    
    public enum PieceType: String {
        
        case None = ""
        case Checker1 = "●"
        case Checker2 = "○"
        
        case King1 = "◉"
        case King2 = "◎"
        
    }
    
    public static var board: Grid {
        
        let grid = Grid(8 ✕ (8 ✕ ("" as AnyObject)))
        
        grid[0] = 8 ✕ (("" as AnyObject) %% ("●" as AnyObject))
        grid[1] = 8 ✕ (("●" as AnyObject) %% ("" as AnyObject))
        grid[2] = 8 ✕ (("" as AnyObject) %% ("●" as AnyObject))
        grid[5] = 8 ✕ (("○" as AnyObject) %% ("" as AnyObject))
        grid[6] = 8 ✕ (("" as AnyObject) %% ("○" as AnyObject))
        grid[7] = 8 ✕ (("○" as AnyObject) %% ("" as AnyObject))
        
        return grid
        
    }
    
    public static let playerPieces = ["●◉","○◎"]
    
    public static func validateJump(s1: Square, s2: Square, p1: Piece, p2: Piece, grid: Grid, hint: Bool = false) -> Bool {
        
        let m1 = s2.0 - s1.0
        let m2 = s2.1 - s1.1
        
        let e1 = s1.0 + m1 / 2
        let e2 = s1.1 + m2 / 2
        
        
        switch PieceType(rawValue: p1) ?? .None {
            
        case .Checker1:
            
            guard m1 == 2 && abs(m2) == 2 else { return false }
            
        case .Checker2:
            
            guard m1 == -2 && abs(m2) == 2 else { return false }
            
        case .King1, .King2:
            
            guard abs(m1) == 2 && abs(m2) == 2 else { return false }
            
        case .None: return false
            
        }
        
        guard let piece1 = grid[s1.0,s1.1] as? String else { return false }
        guard let piece2 = grid[e1,e2] as? String else { return false }
        guard piece2 != "" && piece1 != piece2 else { return false }
        
        guard !hint else { return true }
        
        grid[e1,e2] = "" as AnyObject // remove other player piece
        
        return true
        
    }
    
    public static func validateMove(s1: Square, s2: Square, p1: Piece, p2: Piece, grid: Grid, hint: Bool = false) throws -> Piece? {
        
        let m1 = s2.0 - s1.0
        let m2 = s2.1 - s1.1
        
        guard p2 == "" else { throw MoveError.InvalidMove }
        
        switch PieceType(rawValue: p1) ?? .None {
         
        case .Checker1:
            
            guard (m1 == 1 && abs(m2) == 1) || validateJump(s1: s1, s2: s2, p1: p1, p2: p2, grid: grid, hint: hint) else { throw MoveError.InvalidMove }
            
        case .Checker2:
            
            guard (m1 == -1 && abs(m2) == 1) || validateJump(s1: s1, s2: s2, p1: p1, p2: p2, grid: grid, hint: hint) else { throw MoveError.InvalidMove }
            
        case .King1, .King2:
            
            guard (abs(m1) == 1 && abs(m2) == 1) || validateJump(s1: s1, s2: s2, p1: p1, p2: p2, grid: grid, hint: hint) else { throw MoveError.InvalidMove }
            
        case .None: throw MoveError.IncorrectPiece

        }
        
        guard !hint else { return nil }
        
        let piece = grid[s2.0,s2.1]
        
        grid[s2.0,s2.1] = p1 as AnyObject // place my piece in target square
        grid[s1.0,s1.1] = "" as AnyObject // remove my piece from original square
        
        return piece as? Piece
        
    }
    
}
