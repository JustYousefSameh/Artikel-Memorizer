import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_app/bloc/theme_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomodoro_app/bloc/table_bloc.dart';
import 'package:pomodoro_app/custom_page_route.dart';
import 'package:pomodoro_app/deutsch_word.dart';
import '../words_database.dart';

class PickATable extends StatelessWidget {
  const PickATable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TableBloc, List<String>>(
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: Text('Artikel Memorizer'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                child: Icon(
                  Icons.dark_mode_outlined,
                  color: Theme.of(context).iconTheme.color,
                ),
                onTap: () {
                  //print(Theme.of(context).colorScheme.secondary);

                  context.read<ThemeBloc>().add(ThemeChanged());
                },
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              mainAxisExtent: 55,
              crossAxisSpacing: 20,
            ),
            itemCount: state.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(
                    CustomPageRoute(
                      builder: (newContext) => ArtikleWindow(
                        usedTableName: state[index],
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  child: Center(
                    child: AutoSizeText(
                      state[index],
                      maxLines: 1,
                      minFontSize: 18,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ArtikleButton extends StatefulWidget {
  final String buttonName;
  final Color backgroundColor;
  final VoidCallback callback;

  ArtikleButton({
    required this.buttonName,
    required this.backgroundColor,
    required this.callback,
  });

  @override
  ArtikleButtonState createState() => ArtikleButtonState();
}

class ArtikleButtonState extends State<ArtikleButton> {
  @override
  Widget build(BuildContext context) {
    Widget? buttonName = Align(
      alignment: Alignment.center,
      child: Text(
        widget.buttonName,
        style: GoogleFonts.ibmPlexSans(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
    return ElevatedButton(
      onPressed: () {
        widget.callback();
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: widget.backgroundColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          fixedSize: Size(80, 30)),
      child: buttonName,
    );
  }
}

//ignore: must_be_immutable
class ButtonsHolder extends StatefulWidget {
  String currentWordArtikle;
  Color derColor;
  Color dasColor;
  Color dieColor;
  ButtonsHolder({
    required this.derColor,
    required this.dasColor,
    required this.dieColor,
    required this.currentWordArtikle,
  });

  @override
  State<ButtonsHolder> createState() => _ButtonsHolderState();
}

class _ButtonsHolderState extends State<ButtonsHolder> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ArtikleButton(
              buttonName: "der",
              backgroundColor: widget.derColor,
              callback: showAnswer,
            ),
            ArtikleButton(
              buttonName: "das",
              backgroundColor: widget.dasColor,
              callback: showAnswer,
            ),
            ArtikleButton(
              buttonName: "die",
              backgroundColor: widget.dieColor,
              callback: showAnswer,
            ),
          ],
        ),
      ],
    );
  }

  showAnswer() {
    setState(() {});
    switch (widget.currentWordArtikle) {
      case "der":
        widget.derColor = Colors.green;
        widget.dasColor = Colors.red;
        widget.dieColor = Colors.red;
        break;

      case "das":
        widget.derColor = Colors.red;
        widget.dasColor = Colors.green;
        widget.dieColor = Colors.red;
        break;

      case "die":
        widget.derColor = Colors.red;
        widget.dasColor = Colors.red;
        widget.dieColor = Colors.green;
        break;
    }
  }
}

List<DeutschWord> words = [];

class ArtikleWindow extends StatefulWidget {
  final String usedTableName;

  const ArtikleWindow({super.key, required this.usedTableName});
  @override
  State<ArtikleWindow> createState() => _ArtikleWindowState();
}

class _ArtikleWindowState extends State<ArtikleWindow> {
  late final futureWords =
      WordsDataBase.instance.readAllWords(widget.usedTableName);
  var currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.usedTableName),
        elevation: 0,
      ),
      body: FutureBuilder(
        future: futureWords,
        builder: (
          BuildContext context,
          AsyncSnapshot<List<DeutschWord>> snapshot,
        ) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                WordPresenter(
                  word: snapshot.data![currentIndex].word,
                ),
                SizedBox(height: 65),
                Column(
                  children: [
                    ButtonsHolder(
                      derColor: Theme.of(context).colorScheme.secondary,
                      dasColor: Theme.of(context).colorScheme.secondary,
                      dieColor: Theme.of(context).colorScheme.secondary,
                      currentWordArtikle: snapshot.data![currentIndex].artikel,
                    ),
                    SizedBox(height: 65),
                    TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        fixedSize: const Size(100, 30),
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        setState(
                          () {
                            if (currentIndex == snapshot.data!.length - 1) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => Material(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        AutoSizeText(
                                          'No more words',
                                          minFontSize: 40,
                                        ),
                                        SizedBox(height: 40),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: Icon(
                                            Icons.arrow_back,
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                            size: 40,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                              return;
                            }
                            currentIndex++;
                          },
                        );
                      },
                      child: Center(
                        child: (Text(
                          "Next",
                          style: TextStyle(fontSize: 18),
                        )),
                      ),
                    )
                  ],
                ),
              ],
            );
          } else {
            return Center(
              child: Text(
                "Add words to start",
                style: TextStyle(fontSize: 30),
              ),
            );
          }
        },
      ),
    );
  }

  Widget noWordsWarning(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AutoSizeText(
            "Add words to start test",
            minFontSize: 30,
          ),
          SizedBox(height: 40),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 40,
            ),
          )
        ],
      ),
    );
  }
}

//ignore: must_be_immutable
class WordPresenter extends StatelessWidget {
  String word;
  WordPresenter({required this.word});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          word,
          style: TextStyle(
            fontSize: 50,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
