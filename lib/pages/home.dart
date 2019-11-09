import 'package:flutter/material.dart';
import 'package:wordpress/Widget/appbar.dart';
import 'package:wordpress/pages/Detail.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:html_unescape/html_unescape.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppiBar(),
      body: ListView(
        children: <Widget>[new Cover(), new BlogList()],
      ),
    );
  }
}

class BlogList extends StatelessWidget {
  const BlogList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      child: buildQuery(),
    );
  }

  Query buildQuery() {
    return Query(
      options: QueryOptions(
        document: """
           {
              posts(first : 20){
                nodes{
                  id
                  title
                  author{
                    name
                  }
                  date
                  excerpt
                  featuredImage{
                    sourceUrl
                  }
                }
              }
            }
                """, // this is the query string you just created
        variables: {
          'nRepositories': 50,
        },
        pollInterval: 10,
      ),
      // Just like in apollo refetch() could be used to manually trigger a refetch
      // while fetchMore() can be used for pagination purpose
      builder: (QueryResult result,
          {VoidCallback refetch, FetchMore fetchMore}) {
        if (result.errors != null) {
          return Text(result.errors.toString());
        }

        if (result.loading) {
          return Text('');
        }

        // it can be either Map or List
        List repositories = result.data['posts']['nodes'];
        print(repositories.length);
        List<Widget> list = new List<Widget>();

        for (var i = 0; i < repositories.length; i++) {
          String images = repositories[i]['featuredImage'] == null
              ? "https://cdn.dribbble.com/users/1040983/screenshots/5807325/man-02_2x.png"
              : repositories[i]['featuredImage']['sourceUrl'];
          String dates = repositories[i]['date'];
          String titles = repositories[i]['title'] == ""
              ? "Unknown Title"
              : repositories[i]['title'];
          String names = repositories[i]['author']['name'];
          String cont = repositories[i]['excerpt'];
          String id = repositories[i]['id'];

          list.add(new ListItem(images, names, titles, dates, cont,id));
        }

        return new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(
              "Blog.",
              style: TextStyle(
                fontSize: 25,
                fontFamily: "Libre Baskerville",
              ),
            ),
            ...list
          ],
        );
      },
    );
  }
}

class ListItem extends StatelessWidget {
  final String img;
  final String auth;
  final String title;
  final String date;
  final String con;
  final String id;

  ListItem(this.img, this.auth, this.title, this.date, this.con,this.id);
  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '');
  }

  var unescape = new HtmlUnescape();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Detail(this.id)),
            ),
        child: Container(
          padding: EdgeInsets.only(top: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image(
                height: 100,
                width: 100,
                fit: BoxFit.cover,
                image: NetworkImage(img),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 9,
                          fontFamily: "Libre Baskerville",
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        title.substring(
                                0, title.length < 50 ? title.length : 50) +
                            "...",
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Libre Baskerville",
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        unescape
                            .convert(removeAllHtmlTags(con))
                            .substring(0, unescape
                            .convert(removeAllHtmlTags(con)).length < 100 ? unescape
                            .convert(removeAllHtmlTags(con)).length : 100 ),
                        style: TextStyle(
                          fontSize: 10,
                          fontFamily: "Libre Baskerville",
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      new Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 20,
                            width: 20,
                            child: CircleAvatar(
                              backgroundImage: new NetworkImage(
                                  "https://fiverr-res.cloudinary.com/images/t_main1,q_auto,f_auto/gigs/98381915/original/9a98da91fcc1709763e92016d13756af640abcb7/design-minimalist-flat-line-vector-avatar-of-you.jpg"),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            padding: EdgeInsets.all(4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(
                                  auth,
                                  style: TextStyle(
                                    fontFamily: "Libre Baskerville",
                                    fontWeight: FontWeight.w100,
                                    fontSize: 9,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(
                                  "❤",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontFamily: "Libre Baskerville",
                                    fontWeight: FontWeight.w100,
                                    fontSize: 9,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

class Cover extends StatelessWidget {
  const Cover({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: """
                        {
                    posts(first:2,where:{orderby:{field: DATE,order: DESC }}){
                      nodes{
                        title
                        author{
                          name
                        }
                        featuredImage{
                          sourceUrl
                        }
                      }
                    }
                  }
                  """, // this is the query string you just created
        variables: {
          'nRepositories': 50,
        },
        pollInterval: 10,
      ),
      // Just like in apollo refetch() could be used to manually trigger a refetch
      // while fetchMore() can be used for pagination purpose
      builder: (QueryResult result,
          {VoidCallback refetch, FetchMore fetchMore}) {
        if (result.errors != null) {
          return Text(result.errors.toString());
        }

        if (result.loading) {
          return Text('');
        }
        List repositories = result.data['posts']['nodes'];

        return Stack(
          children: <Widget>[
            new Positioned(
              child: Image(
                height: 200.0,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
                image: NetworkImage(repositories[0]["featuredImage"] == null
                    ? "https://img.freepik.com/free-vector/illustration-people-autumn-park_52683-19762.jpg?size=626&ext=jpg"
                    : repositories[0]["featuredImage"]["sourceUrl"]),
              ),
            ),
            new Positioned(
              child: new Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.30),
                ),
              ),
            ),
            new Positioned(
              top: 20,
              left: 20,
              child: new Text(
                "FEATURED",
                style: TextStyle(
                    fontFamily: "Libre Baskerville",
                    fontWeight: FontWeight.w100,
                    fontSize: 10,
                    color: Colors.white),
              ),
            ),
            new Positioned(
              top: 40,
              child: Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.only(right: 20),
                width: MediaQuery.of(context).size.width,
                child: new Text(
                  repositories[0]["title"].substring(0, 40),
                  style: TextStyle(
                      fontFamily: "Libre Baskerville",
                      fontWeight: FontWeight.w100,
                      fontSize: 30,
                      color: Colors.white),
                ),
              ),
            ),
            new Positioned(
              bottom: 20,
              left: 20,
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: CircleAvatar(
                      backgroundImage: new NetworkImage(
                          "https://fiverr-res.cloudinary.com/images/t_main1,q_auto,f_auto/gigs/98381915/original/9a98da91fcc1709763e92016d13756af640abcb7/design-minimalist-flat-line-vector-avatar-of-you.jpg"),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          repositories[0]["author"]["name"],
                          style: TextStyle(
                              fontFamily: "Libre Baskerville",
                              fontWeight: FontWeight.w100,
                              fontSize: 13,
                              color: Colors.white),
                        ),
                        new Text(
                          "Software Developer 💘",
                          style: TextStyle(
                              fontFamily: "Libre Baskerville",
                              fontWeight: FontWeight.w100,
                              fontSize: 9,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
