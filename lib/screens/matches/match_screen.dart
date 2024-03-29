import 'package:five_on_four/features/matches/constants/player_match_status.dart';
import 'package:five_on_four/features/matches/domain/index.dart';
import 'package:five_on_four/features/matches/domain/models/player.dart';
import 'package:five_on_four/features/matches/presentation/controllers/matches_controller.dart';
import 'package:five_on_four/features/users/domain/models/user.dart';
import 'package:five_on_four/features/users/presentation/controllers/users_controller.dart';
import 'package:five_on_four/navigation/extensions.dart';
import 'package:five_on_four/services/dev/dev_service.dart';
import 'package:five_on_four/widgets/app_bar_popup_menu/app_bar_popup_menu.dart';
import 'package:five_on_four/widgets/centered_message.dart';
import 'package:five_on_four/widgets/loading_indicator.dart';
import 'package:five_on_four/widgets/text_with_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class MatchScreen extends StatefulWidget {
  final int matchId;

  MatchScreen(this.matchId, {Key? key}) : super(key: key);

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  List<User> _users = [];

  final MatchesController _matchesController = MatchesController();

  final UsersController _usersController = UsersController();

  @override
  Widget build(BuildContext context) {
// TODO this all might need to be turned into a stateful widget
// and then just create

    return Scaffold(
      appBar: AppBar(
        title: const Text("View match"),
        centerTitle: true,
        actions: <Widget>[
          AppBarPopupMenu(),
        ],
      ),
      body: FutureBuilder(
        future: _handleLoadMatch(context),
        builder: (context, AsyncSnapshot<Match?> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingIndicator();
          }

// TODO test this to see how it looks like
          if (snapshot.hasError) {
            return CenteredMessage(
                message: "There was an issue fetchig the match");
          }

          final match = snapshot.data;

          if (match == null) {
            return CenteredMessage(message: "There is no such match");
          }

          return _renderLoadedMatchData(context, match);
        },
      ),
    );
  }

  Padding _renderLoadedMatchData(BuildContext context, Match match) {
    // devService.log("${match.players}");
    // devService.log(match); --> this throws error
    return Padding(
      padding: const EdgeInsets.all(10),
      // TODO not sure if this is good for all
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              key: Key("match-name"),
              match.name,
              style: Theme.of(context).textTheme.headline3,
            ),
            // TODO this text button needs styling
            // TODO this will eventually also need to to fetch info about user if they joined
            // or, we can get the user, and check against the joined users
            TextButton(onPressed: () {}, child: Text("joined".toUpperCase())),
            Column(
              key: Key("match-info"),
              children: <Widget>[
                // TODO probably should create some compount widget for text with icon or some such
                TextWithIcon(
                  text: "Match info",
                  icon: Icons.info,
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                TextWithIcon(
                  text: match.datetime,
                  icon: Icons.calendar_month,
                ),
                TextWithIcon(
                  text: match.datetime,
                  icon: Icons.access_time_outlined,
                ),
                TextWithIcon(
                  text: match.location,
                  icon: Icons.location_on,
                ),
                TextWithIcon(
                  text: "${match.maxPlayers} players limit",
                  icon: Icons.people,
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Column(
              key: Key("match-description"),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // TODO probably should create some compount widget for text with icon or some such
                TextWithIcon(
                  text: "Match description",
                  icon: Icons.bookmark,
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                Text(match.description)
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              key: Key("match-organizer-contact"),
              children: <Widget>[
                // TODO probably should create some compount widget for text with icon or some such
                TextWithIcon(
                  text: "Organizer's phone number",
                  icon: Icons.phone,
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                Text(match.organizerPhoneNumber)
              ],
            ),
            SizedBox(
              height: 30,
            ),
            _renderTabbableStatusedPlayers(match.players),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   key: Key("match-players-joined"),
            //   children: <Widget>[
            //     // TODO probably should create some compount widget for text with icon or some such
            //     TextWithIcon(
            //       text: "Joined players",
            //       icon: Icons.people,
            //       textStyle: Theme.of(context).textTheme.labelLarge,
            //     ),
            //     // TODO here rendered players
            //     // for (Player player in match.players)
            //     //   Row(
            //     //     children: <Widget>[
            //     //       Text(player.nickname),
            //     //     ],
            //     //   ),

            //     ..._renderPlayers(match.players, PlayerMatchStatus.joined)
            //   ],
            // ),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   key: Key("match-players-invited"),
            //   children: <Widget>[
            //     // TODO probably should create some compount widget for text with icon or some such
            //     TextWithIcon(
            //       text: "Invited players",
            //       icon: Icons.people,
            //       textStyle: Theme.of(context).textTheme.labelLarge,
            //     ),
            //     // TODO here rendered players
            //     // for (Player player in match.players)
            //     //   Row(
            //     //     children: <Widget>[
            //     //       Text(player.nickname),
            //     //     ],
            //     //   ),

            //     ..._renderPlayers(match.players, PlayerMatchStatus.invited)
            //   ],
            // )
          ],
        ),
      ),
    );
  }

  // TODO test
  Widget _renderTabbableStatusedPlayers(List<Player> players) {
    final test = double.maxFinite;
    devService.log("WHAQT IS MAX FINITE: $test");
    return DefaultTabController(
      length: 2,
      child: Column(
        children: <Widget>[
          TabBar(
            tabs: [
              Tab(
                text: "Joined players",
              ),
              Tab(
                text: "Invited players",
              )
            ],
          ),
          SizedBox(
            // TODO this does not seem correct - need to have some way to expand the size dynamically
            height: 100,
            child: TabBarView(children: <Widget>[
              Column(
                children: _renderPlayers(players, PlayerMatchStatus.joined),
              ),
              Column(
                children: _renderPlayers(players, PlayerMatchStatus.invited),
              ),
            ]),
          ),
          // TabBarView(children: <Widget>[
          //   Column(
          //     children: _renderPlayers(players, PlayerMatchStatus.joined),
          //   ),
          //   Column(
          //     children: _renderPlayers(players, PlayerMatchStatus.invited),
          //   ),
          // ]),
        ],
      ),
    );
  }

  List<Widget> _renderPlayers(List<Player> players, String playerMatchStatus) {
    final playerRows = players
        .where((p) => p.matchStatus == playerMatchStatus)
        .map<Widget>((p) {
      // TODO probablys not the best approach, since no key assign to any row
      return Row(
        children: <Widget>[
          Text(p.nickname),
        ],
      );
    }).toList();

    return playerRows;
  }

  Future<Match?> _handleLoadMatch(BuildContext context) async {
    // TODO later, erros should be just propagated from here
    // int? matchId = context.getRouteArgument<int>();
    // devService.log("gere");

    // devService.log("match id: $matchId");/*  */

    final matchId = widget.matchId;

    devService.log("up to here: $matchId");
    if (matchId == null) {
      // in this case, we would also probably return some error later
      // this would work with just returning null too
      return Future.value(null);
      // return null;
    }

    try {
      final match = await _matchesController.loadMatch(matchId);
      return match;
    } catch (e) {
      // devService.log(e);
      // TODO i would not want to handle stuff here - i there is error, should it be handled in the controller isntead
      devService.log(e);
      return null;
    }
  }

  // TODO test
  // Future<List<User>> _handleSearchUsersByNickname(String nickname) async {
  //   try {
  //     final users = await _usersController.searchUsersByNickname(nickname);
  //   } catch (e) {
  //     devService.log("this is errror: $e");
  //   }
  // }
}
