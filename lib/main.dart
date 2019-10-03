// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
			statusBarColor: Colors.transparent,
			systemNavigationBarColor: Colors.transparent,
			systemNavigationBarDividerColor: Colors.grey,
//        statusBarBrightness: Brightness.light
		));
//    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
		return MaterialApp(
			title: 'Welcome to Flutter',
			theme: ThemeData(
				primaryColor: Colors.white,
			),
			home: RandomWords(),
//      home: Scaffold(
//        appBar: AppBar(
//          title: Text('Welcome to fiooo'),
//        ),
//        body: Center(
//          child: RandomWords(),
//        ),
//      ),
		);
	}
}

class RandomWordsState extends State<RandomWords> {
	final List<WordPair> _suggestions = <WordPair>[];
	final Set<WordPair> _saved = Set<WordPair>();
	final _biggerFont = const TextStyle(fontSize: 18.0);

	@override
	Widget build(BuildContext context) {
//    final wordPair = WordPair.random();
//    return Text(wordPair.asPascalCase);
		return Scaffold(
			extendBodyBehindAppBar: true,
			appBar: AppBar(
				backgroundColor: Colors.white.withOpacity(0.75),
				elevation: 0.0,
				title: Text('Startup Name Generator'),
				centerTitle: true,
				actions: <Widget>[
					IconButton(icon: Icon(Icons.beenhere), onPressed: _pushSaved)
				],
			),
			body: _buildSuggestions(),
		);
	}

	Widget _buildSuggestions() {
		return ListView.builder(
//      padding: const EdgeInsets.all(16.0),
			itemBuilder: (context, i) {
				if (i % 2 == 1) return Divider();

				final index = i ~/ 2;
				if (index >= _suggestions.length) {
					_suggestions.addAll(generateWordPairs().take(10));
				}
				return _buildRow(_suggestions[index]);
			},
		);
	}

	Widget _buildRow(WordPair pair) {
		final bool alreadySaved = _saved.contains(pair);
		return ListTile(
			title: Text(
				pair.asPascalCase,
				style: _biggerFont,
			),
			trailing: Icon(
				alreadySaved ? Icons.favorite : Icons.favorite_border,
				color: alreadySaved ? Colors.red : null,
			),
			onTap: () {
				setState(() {
					if (alreadySaved) {
						_saved.remove(pair);
					} else {
						_saved.add(pair);
					}
				});
			},
		);
	}

	void _pushSaved() {
		Navigator.of(context).push(
			MaterialPageRoute<void>(
				builder: (BuildContext context) {
					final Iterable<ListTile> tiles = _saved.map(
							(WordPair pair) {
							return ListTile(
								title: Text(
									pair.asPascalCase,
									style: _biggerFont,
								),
							);
						},
					);
					final List<Widget> divided = ListTile
						.divideTiles(
						tiles: tiles,
						context: context,
					)
						.toList();
					return Scaffold(
						appBar: AppBar(
							title: Text('Saved Suggestions'),
							centerTitle: true,
						),
						body: ListView(children: divided),
					);
				},
			),
		);
	}
}

class RandomWords extends StatefulWidget {
	@override
	RandomWordsState createState() => RandomWordsState();
}