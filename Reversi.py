class Reversi:
    def __init__(self):
        self.board = [
            [' ', ' ', ' ', ' ', ' ', ' ', ' '],
            [' ', ' ', ' ', ' ', ' ', ' ', ' '],
            [' ', ' ', ' ', ' ', ' ', ' ', ' '],
            [' ', ' ', ' ', 'B', 'W', ' ', ' '],
            [' ', ' ', ' ', 'W', 'B', ' ', ' '],
            [' ', ' ', ' ', ' ', ' ', ' ', ' '],
            [' ', ' ', ' ', ' ', ' ', ' ', ' '],
        ]
        self.turn = 'B'
        self.num_black = 2
        self.num_white = 2

    def check_valid_move(self, row, col):
        # check if the selected space is within the board and empty
        if not self.is_valid_space(row, col):
            return False

        # check if there is any possible move for the player
        if self.is_opponent_move_available(row, col):
            return True

        # check if there is any move available for the current player
        if not self.is_current_player_move_available(row, col):
            return False

        return True

    def is_valid_space(self, row, col):
        if row < 0 or row >= len(self.board) or col < 0 or col >= len(self.board[0]):
            return False
        return self.board[row][col] == ' '

    def is_opponent_move_available(self, row, col):
        directions = [(0, 1), (0, -1), (1, 0), (-1, 0), (1, 1), (1, -1), (-1, 1), (-1, -1)]
        for dr, dc in directions:
            r, c = row + dr, col + dc
            while self.is_valid_space(r, c):
                if self.board[r][c] == self.turn:
                    return True
               