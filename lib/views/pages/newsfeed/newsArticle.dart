import 'package:flutter/material.dart';
import 'package:lipsum/lipsum.dart' as lipsum;
import 'package:talawa/services/Queries.dart';
import 'package:talawa/services/preferences.dart';
import 'package:talawa/utils/apiFuctions.dart';
import 'package:talawa/utils/uidata.dart';

class NewsArticle extends StatefulWidget {
  Map post;
  NewsArticle({Key key, @required this.post}) : super(key: key);

  @override
  _NewsArticleState createState() => _NewsArticleState();
}

class _NewsArticleState extends State<NewsArticle> {
  final commentController = TextEditingController();
  Preferences preferences = Preferences();
  ApiFunctions apiFunctions = ApiFunctions();
  initState() {
    super.initState();
    getPostComments();
  }

  getPostComments() async {
    String mutation = Queries().getPostsComments(widget.post['_id']);
    Map result = await apiFunctions.gqlmutation(mutation);
    print(result);
  }

  createComment() async {
    if (commentController.text.isNotEmpty) {
      String mutation =
          Queries().createComments(widget.post['_id'], commentController.text);
      Map result = await apiFunctions.gqlmutation(mutation);
      print(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(lipsum.createWord(numWords: 4).toString()),
              background: FittedBox(
                child: Image.asset(UIData.shoppingImage),
                fit: BoxFit.fill,
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(20),
            sliver: SliverToBoxAdapter(
              child: Text(widget.post['text'].toString()),
            ),
          ),
          SliverToBoxAdapter(
              child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.chat),
                title: Text('0 Comments'),
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(UIData.pkImage),
                ),
                title: TextField(
                  decoration: InputDecoration(
                      suffix: IconButton(
                        color: Colors.grey,
                        icon: Icon(Icons.send),
                        onPressed: () {
                          createComment();
                        },
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal)),
                      hintText: 'Leave a Comment'),
                  controller: commentController,
                ),
              )
            ],
          )),
        ],
      ),
    );
  }
}
