

class ComputerService

    getScore: (points, id) ->
        for score in points
            if score.id is id
                return score
        return null

    compute: (room) ->
        # User scores
        points = []

        # Room blacklist
        blacklist = room.blacklist

        # Filter the blacklisted games
        games = room.data.games.filter (game) -> not blacklist[game.game_id]

        # For each game
        for game in games

            # Sort the scores in descending order
            scores = game.scores.sort (left, right) ->
                # Left passed, right failed, left is better
                if left.pass is "1" and right.pass is "0"
                    return -1
                # Left failed, right passed, right is better
                else if left.pass is "0" and right.pass is "1"
                    return 1
                # Else, the two passed or the two failed, use the score
                else
                    return right.score - left.score

            # For each score
            count = 0
            for score in scores
                # Add points to the user based on the score table
                if count < room.settings.pointsTable.length
                    point = @getScore points, score.user_id
                    if not point?
                        point =
                            id: score.user_id
                            points: 0
                        points.push point
                    point.points += Number(room.settings.pointsTable[count])
                    count++

        points = points.sort (left, right) ->
            return right.points - left.points

        return points

module.exports = new ComputerService
