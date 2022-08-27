class PlayersMutations {
  static String insertPlayer() => '''
  insert into "player" 
    (
      "user_id",
      "match_id",
      "status"
    )
  values
    (
      ?,
      ?,
      ?
    );
  ''';

  static String updatePlayer() => '''
  update player 
  set 
    user_id = ?,
    match_id = ?,
    status = ?
  where 
    id = ?;
  ''';

  static String deletePlayer() => '''
  delete from player 
  where
    id = ?;
  ''';
}
