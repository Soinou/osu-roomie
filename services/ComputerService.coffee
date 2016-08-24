

class ComputerService

    table: [4, 2, 1, 0]

    compute: (room) ->
        # User scores
        points = {}

        # Room blacklist
        blacklist = room.blacklist

        games = room.data.games.filter (game) -> not blacklist[game.game_id]

        # For each games not blacklisted
        for game in games

            # Sort the scores in descending order
            scores = game.scores.sort (left, right) ->
                return right.score - left.score

            # For each score
            count = 0
            for score in scores

                # Add points to the user based on the score table
                if count < @table.length
                    user_score = points[score.user_id]
                    if not user_score? then user_score = user: {}, score: 0
                    user_score.score += @table[count]
                    points[score.user_id] = user_score
                    count++

        return points

module.exports = new ComputerService
