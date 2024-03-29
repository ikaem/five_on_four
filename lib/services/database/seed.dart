class Seed {
  static String deleteAllMatches() => '''
  delete from "match";
  ''';
  static String deleteAllPlayers() => '''
  delete from "player";
  ''';

  static String getAllPlayers() => '''
    select 
      id,
      user_id,
      status,
      match_id
    from player p;
  ''';

  static String getAllUsers() => '''
    select 
      id,
      nickname
    from user u;
''';

  static String getAllMatches() => '''
    select 
      m.id,
      m."datetime",
      m."duration",
      m."name",
      m."location",
      m.max_players,
      m.description,
      m.phone_number,
      m.organizer_id
    from "match" m;
  ''';
  static String getAllMatchesWithPlayers() => '''
    select 
      m.id,
      m."datetime",
      m."duration",
      m."name",
      m."location",
      m.max_players,
      m.description,
      m.phone_number,
      p.id,
      p.user_id as "player_user_id",
      p.status,
      p.match_id as "player_match_id",
	    u.nickname
    from "match" m 
    left join player p on p.match_id = m.id 
	left join user u on u.id = p.user_id
    group by 
      m.id,
      m."datetime",
      m."duration",
      m."name",
      m."location",
      m.max_players,
      m.description,
      m.phone_number,
      p.id,
      p.user_id,
      p.status,
      p.match_id
    order by 
      p.match_id;
  ''';

  static String insertUsers() => '''
    insert into user 
    (
      nickname
    )
    values
    (
      'Zidane'
    ),
    (
      'Pele'
    ),
    (
      'Ronaldo'
    ),
    (
      'Zico'
    ),
    (
      'Totti'
    ),
    (
      'Raul'
    );
  ''';

  static String insertMatchPlayer(int matchId, int userId) => '''
    insert into player 
    (
      user_id,
      match_id, 
      status
    )
    values 
    (
      $userId,
      $matchId,
      'joined'
    );
  ''';

  static String insertMatchPlayers(int matchId) => '''
    insert into player 
    (
      nickname,
      status,
      match_id 
    )
    values 
    (
      'Pele',
      'joined',
      $matchId
    ),
    (
      'Maradona',
      'joined',
      $matchId
    ),
    (
      'Beckham',
      'joined',
      $matchId
    ),
    (
      'Ronaldo',
      'joined',
      $matchId
    ),
    (
      'Zidane',
      'joined',
      $matchId
    ),
    (
      'Kaka',
      'joined',
      $matchId
    );
  ''';

  static String insertMatch(int matchOrganizer) => '''
    insert into "match" 
    (
      "datetime",
      "duration",
      "name",
      "location",
      max_players,
      description,
      phone_number,
      organizer_id
    )
    values
    (
      '2022-08-09T05:59:00.000',
      3600000,
      'Random match name',
      'Lacabamba',
      12,
      'Lorem description',
      '+123456789',
      $matchOrganizer
    );
  ''';

// TODO might be obsolete
  static String insertMatches() => '''
    insert into "match" 
    (
      "datetime",
      "duration",
      "name",
      "location",
      max_players,
      description,
      phone_number
    )
    values
    (
      '2022-08-09T05:59:00.000',
      3600000,
      'Random match name',
      'Lacabamba',
      12,
      'Lorem description',
      '+123456789'
    ),
    (
      '2022-08-09T05:59:00.000',
      3600000,
      'Random match name',
      'Lacabamba',
      12,
      'Lorem description',
      '+123456789'
    ),
    (
      '2022-08-09T05:59:00.000',
      3600000,
      'Random match name',
      'Lacabamba',
      12,
      'Lorem description',
      '+123456789'
    ),
    (
      '2022-08-09T05:59:00.000',
      3600000,
      'Random match name',
      'Lacabamba',
      12,
      'Lorem description',
      '+123456789'
    ),
    (
      '2022-08-09T05:59:00.000',
      3600000,
      'Random match name',
      'Lacabamba',
      12,
      'Lorem description',
      '+123456789'
    ),
    (
      '2022-08-09T05:59:00.000',
      3600000,
      'Random match name',
      'Lacabamba',
      12,
      'Lorem description',
      '+123456789'
    ),
    (
      '2022-08-09T05:59:00.000',
      3600000,
      'Random match name',
      'Lacabamba',
      12,
      'Lorem description',
      '+123456789'
    ),
    (
      '2022-08-09T05:59:00.000',
      3600000,
      'Random match name',
      'Lacabamba',
      12,
      'Lorem description',
      '+123456789'
    ),
    (
      '2022-08-09T05:59:00.000',
      3600000,
      'Random match name',
      'Lacabamba',
      12,
      'Lorem description',
      '+123456789'
    );
    ''';
}
