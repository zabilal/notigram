import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_login/theme.dart';
import 'package:flutter_login/widgets.dart';
import 'package:notigram/assets.dart';
import 'package:notigram/backbone/AppEngine.dart';
import 'transition_route_observer.dart';
import 'widgets/fade_in.dart';
import 'constants.dart';
import 'widgets/animated_numeric_text.dart';
import 'widgets/round_button.dart';
import '../bottombar/fab_with_icons.dart';
import '../bottombar/fab_bottom_app_bar.dart';
import '../bottombar/layout.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin, TransitionRouteAware {
  String _lastSelected = 'TAB: 0';

  void _selectedTab(int index) {
    print('Tab selected : $index');
    setState(() {
      _lastSelected = 'TAB: $index';
    });
  }

  void _selectedFab(int index) {
    setState(() {
      _lastSelected = 'FAB: $index';
    });
  }

  Future<bool> _goToLogin(BuildContext context) {
    return Navigator.of(context)
        .pushReplacementNamed('/')
        // we dont want to pop the screen, just replace it completely
        .then((_) => false);
  }

  final routeObserver = TransitionRouteObserver<PageRoute>();
  static const headerAniInterval =
      const Interval(.1, .3, curve: Curves.easeOut);
  Animation<double> _headerScaleAnimation;
  AnimationController _loadingController;

  @override
  void initState() {
    super.initState();

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1250),
    );

    _headerScaleAnimation =
        Tween<double>(begin: .6, end: 1).animate(CurvedAnimation(
      parent: _loadingController,
      curve: headerAniInterval,
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _loadingController.dispose();
    super.dispose();
  }

  @override
  void didPushAfterTransition() => _loadingController.forward();

  AppBar _buildAppBar(ThemeData theme) {
    final menuBtn = IconButton(
      color: white, //theme.accentColor,
      icon: const Icon(FontAwesomeIcons.bars),
      onPressed: () {},
    );
    final signOutBtn = IconButton(
      icon: const Icon(FontAwesomeIcons.signOutAlt),
      color: white, //theme.accentColor,
      onPressed: () => _goToLogin(context),
    );
    final title = Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Hero(
              tag: '',
              // tag: Constants.logoTag,
              child: Image.asset(
                notigram,
                // '',
                filterQuality: FilterQuality.high,
                height: 30,
              ),
            ),
          ),
          HeroText(
            '', // Constants.appName,
            tag: Constants.titleTag,
            viewState: ViewState.shrunk,
            style: LoginThemeHelper.loginTextStyle,
          ),
          SizedBox(width: 20),
        ],
      ),
    );

    return AppBar(
      leading: FadeIn(
        child: menuBtn,
        controller: _loadingController,
        offset: .3,
        curve: headerAniInterval,
        fadeDirection: FadeDirection.startToEnd,
      ),
      actions: <Widget>[
        FadeIn(
          child: signOutBtn,
          controller: _loadingController,
          offset: .3,
          curve: headerAniInterval,
          fadeDirection: FadeDirection.endToStart,
        ),
      ],
      title: title,
      backgroundColor: theme.primaryColor,
      elevation: 0,
      textTheme: theme.accentTextTheme,
      iconTheme: theme.accentIconTheme,
    );
  }

  Widget _buildFab(BuildContext context) {
    final icons = [Icons.sms, Icons.mail, Icons.phone];
    return AnchoredOverlay(
      showOverlay: true,
      overlayBuilder: (context, offset) {
        return CenterAbout(
          position: Offset(offset.dx, offset.dy - icons.length * 35.0),
          child: FabWithIcons(
            icons: icons,
            onIconTapped: _selectedFab,
          ),
        );
      },
      child: FloatingActionButton(
        foregroundColor: red1,
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.edit),
        elevation: 2.0,
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    final primaryColor =
        Colors.primaries.where((c) => c == theme.primaryColor).first;
    final accentColor =
        Colors.primaries.where((c) => c == theme.accentColor).first;
    final linearGradient = LinearGradient(colors: [
      primaryColor.shade800,
      primaryColor.shade200,
    ]).createShader(Rect.fromLTWH(0.0, 0.0, 418.0, 78.0));

    return ScaleTransition(
      scale: _headerScaleAnimation,
      child: FadeIn(
        controller: _loadingController,
        curve: headerAniInterval,
        fadeDirection: FadeDirection.bottomToTop,
        offset: .5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '\$',
                  style: theme.textTheme.display2.copyWith(
                    fontWeight: FontWeight.w300,
                    color: accentColor.shade400,
                  ),
                ),
                SizedBox(width: 5),
                AnimatedNumericText(
                  initialValue: 14,
                  targetValue: 3467.87,
                  curve: Interval(0, .5, curve: Curves.easeOut),
                  controller: _loadingController,
                  style: theme.textTheme.display2.copyWith(
                    foreground: Paint()..shader = linearGradient,
                  ),
                ),
              ],
            ),
            Text('Account Balance', style: theme.textTheme.caption),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({Widget icon, String label, Interval interval}) {
    return RoundButton(
      icon: icon,
      label: label,
      loadingController: _loadingController,
      interval: Interval(
        interval.begin,
        interval.end,
        curve: ElasticOutCurve(0.42),
      ),
      onPressed: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () => _goToLogin(context),
      child: SafeArea(
        child: Scaffold(
            appBar: _buildAppBar(theme),
            bottomNavigationBar: FABBottomAppBar(
              centerItemText: 'A',
              color: Colors.grey,
              selectedColor: Colors.red,
              notchedShape: CircularNotchedRectangle(),
              onTabSelected: _selectedTab,
              items: [
                FABBottomAppBarItem(iconData: Icons.home, text: 'Home'),
                FABBottomAppBarItem(iconData: Icons.layers, text: 'Boards'),
                FABBottomAppBarItem(iconData: Icons.email, text: 'Inbox'),
                FABBottomAppBarItem(iconData: Icons.alarm, text: 'Notice'),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: _buildFab(context), // This trailing comma makes auto-formatting nicer for build methods.
            body: Column(
              children: <Widget>[
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[addSpace(20), postNote()],
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }

  postNote() {
    for (int i = 0; i < 8; i++) {
      return Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Image.asset(
                notigram,
                width: 50,
                height: 50,
              ),
            ),
            Column(
              children: <Widget>[
                addSpace(20),
                Center(
                  child: Text(
                    "POST TITLE POST TITLE ",
                    style: textStyle(true, 15, black),
                  ),
                ),
                addSpace(10),
                // addLine(1, red1, 0, 0, 0, 0),
                addSpace(10),
                Center(child: Text("data")),
                addSpace(20),
                Center(child: Text("data")),
                addSpace(20),
                Center(child: Text("data")),
                addSpace(20)
              ],
            )
          ],
        ),
      );
    }
  }

}
