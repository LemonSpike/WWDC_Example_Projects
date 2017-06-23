import UIKit

public class Grid {
    
    public var content: [[AnyObject]]
    
    public var rowRange: Range<Int> { return 0..<content.count }
    public var colRange: Range<Int> { return content.count > 0 ? 0..<content[0].count : 0..<0 }
    
    public var boardColors = BoardColors()
    public var playerPieces: [Piece] = []
    
    public init(_ content: [[AnyObject]]) {
        
        self.content = content
        
    }
    
    public func checker(rect: CGRect, highlights: [Square], selected: Square?) -> UIView {
        
        let view = UIView(frame: rect)
        
        let w = rect.width / content.count
        let h = rect.height / content.count
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        for (r,row) in content.enumerated() {
            
            for (c,item) in row.enumerated() {
                
                let label = HintLabel(frame: CGRect(x: c * w, y: r * h, width: w, height: h))
                var piece = "\(item)"
                
                label.backgroundColor = (c + r) % 2 == 0 ? boardColors.background : boardColors.foreground
                label.textColor = player(piece: piece) == 0 ? boardColors.player1 : boardColors.player2
                label.highlightColor = boardColors.highlight
                
                if player(piece: piece) == 1 {
                    
                    if let index = playerPieces[1].array().index(of: piece) { piece = playerPieces[0].array()[index] }
                    
                }
                
                if selected?.0 == r && selected?.1 == c { label.textColor = boardColors.selected }
                for highlight in highlights { label.highlight = label.highlight ? true : highlight.0 == r && highlight.1 == c }
                
                label.text = piece
                label.textAlignment = .center
                label.font = UIFont.init(name: "HelveticaNeue-Thin", size: (w + h) / 2 - 10)
                
                view.addSubview(label)
                
            }
            
        }
        
        return view
        
    }
    
    public func go(rect: CGRect) -> UIView {
        
        let view = GoView(frame: rect)
        
        view.p = 30
        view.backgroundColor = boardColors.background
        view.lineColor = boardColors.foreground
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        let p = 30
        let w = (rect.width - p * 2) / 8
        let h = (rect.height - p * 2) / 8
        
        for (r,row) in content.enumerated() {
            
            for (c,item) in row.enumerated() {
            
                let label = UILabel(frame: CGRect(x: c * w + p - w / 2, y: r * h + p - h / 2, width: w, height: h))
                var piece = "\(item)"
                
                label.textColor = player(piece: piece) == 0 ? boardColors.player1 : boardColors.player2
                
                if player(piece: piece) == 1 {
                    
                    if let index = playerPieces[1].array().index(of: piece) { piece = playerPieces[0].array()[index] }
                    
                }
                
                label.text = piece
                label.textAlignment = .center
                label.font = UIFont.init(name: "HelveticaNeue-Thin", size: (w + h) / 2)!
                
                view.addSubview(label)

                
            }
            
        }
        
        return view
        
    }
    
    public func matrix(rect: CGRect) -> UIView {
        
        let view = MatrixView(frame: rect)
        
        view.p = 15
        view.backgroundColor = boardColors.background
        view.lineColor = boardColors.foreground
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        let p = 20
        let w = (rect.width - p * 2) / content.count
        let h = (rect.height - p * 2) / content.count
        
        for (c,col) in content.enumerated() {
            
            for (r,item) in col.enumerated() {
                
                let label = UILabel(frame: CGRect(x: c * w + p, y: r * h + p, width: w, height: h))
                
                label.text = "\(item)"
                label.textAlignment = .center
                label.font = UIFont.init(name: "HelveticaNeue-Thin", size: (w + h) / 2 - 10)!
                
                view.addSubview(label)
                
            }
            
        }
        
        return view
        
    }
    
    public func mine(rect: CGRect) -> UIView {
        
        let view = UIView(frame: rect)
        
        view.backgroundColor = boardColors.background
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        let w = (rect.width - content.count + 1) / content.count
        let h = (rect.height - content.count + 1) / content.count
        
        for (r,row) in content.enumerated() {
            
            for (c,item) in row.enumerated() {
                
                let label = UILabel(frame: CGRect(x: c * w + c, y: r * h + r, width: w, height: h))
                let piece = "\(item)"
                
                label.text = piece
                label.textAlignment = .center
                label.font = UIFont.init(name: "HelveticaNeue", size: (w + h) / 2 - 5)!
                
                label.textColor = player(piece: piece) == 0 ? boardColors.player1 : boardColors.player2
                label.backgroundColor = player(piece: piece) == 1 ? boardColors.selected : boardColors.background
                
                if piece == "•" {
                    
                    label.textColor = boardColors.foreground
                    label.backgroundColor = boardColors.foreground
                
                }
                
                if let num = Int("\(item)"), num > 0 { label.textColor = boardColors.highlight }
                
                view.addSubview(label)
                
            }
            
        }
        
        return view
        
    }
    
    public func sudoku(rect: CGRect, highlights: [Square]) -> UIView {
        
        let view = SudokuView(frame: rect)
        
        view.backgroundColor = boardColors.background
        view.lineColor = boardColors.foreground
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        let w = rect.width / content.count
        let h = rect.height / content.count
        
        for (r,row) in content.enumerated() {
            
            for (c,item) in row.enumerated() {
                
                let label = UILabel(frame: CGRect(x: c * w, y: r * h, width: w, height: h))
                
                label.text = "\(item)"
                label.textAlignment = .center
                label.font = UIFont.init(name: "HelveticaNeue", size: (w + h) / 2 - 10)!
                label.textColor = boardColors.foreground
                
                for highlight in highlights {
                    
                    guard highlight.0 == r && highlight.1 == c else { continue }
                    label.textColor = boardColors.highlight
                    label.backgroundColor = boardColors.foreground
                    
                }
                
                view.addSubview(label)
                
            }
            
        }
        
        return view
        
    }
    
    public func ttt(rect: CGRect) -> UIView {
        
        let view = TicTacToeView(frame: rect)
        
        view.p = 20
        view.backgroundColor = boardColors.background
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        let p = 20
        let w = (rect.width - p * 2) / content.count
        let h = (rect.height - p * 2) / content.count
        
        for (r,row) in content.enumerated() {
            
            for (c,item) in row.enumerated() {
                
                let label = UILabel(frame: CGRect(x: c * w + p, y: r * h + p, width: w, height: h))
                let piece = "\(item)"
                
                label.text = piece
                label.textAlignment = .center
                label.font = UIFont.init(name: "HelveticaNeue-Thin", size: (w + h) / 2 - 10)
                label.textColor = player(piece: piece) == 0 ? boardColors.player1 : boardColors.player2
                
                view.addSubview(label)
                
            }
            
        }
        
        return view
        
    }
    
    public func onBoard(s1: Square, _ s2: Square) -> Bool {
        
        return s1.0.within(r: rowRange) && s1.1.within(r: colRange) && s2.0.within(r: rowRange) && s2.1.within(r: colRange)
        
    }
    
    public func onBoard(s1: Square) -> Bool {
        
        return s1.0.within(r: rowRange) && s1.1.within(r: colRange)
        
    }
    
    public subscript ( c: Int, r: Int) -> AnyObject {
        
        get { return content[c][r] }
        set { content[c][r] = newValue }
        
    }
    
    public subscript ( c: Int) -> [AnyObject] {
        
        get { return content[c] }
        set { content[c] = newValue }
        
    }
    
    func player(piece: Piece) -> Int {
        
        for (p,player) in playerPieces.enumerated() {
            
            if player.contains(piece) { return p }
            
        }
        
        return -1
        
    }
    
}
