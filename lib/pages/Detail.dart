import 'package:flutter/material.dart';
import 'package:wordpress/Widget/appbar.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_html_renderer/flutter_html_renderer.dart';

class Detail extends StatefulWidget {
  final String id;
  Detail(this.id);

  @override
  _DetailState createState() => _DetailState(id);
}

class _DetailState extends State<Detail> {
  final String ids;
  _DetailState(this.ids);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:  AppiBar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(
          Icons.favorite,
        ),
      ),
      body: Query(
        options: QueryOptions(
          document: """
                            {
                    post(id:"${ids}"){
                      title
                      author{
                        name
                      }
                      featuredImage{
                        sourceUrl
                      }
                      content
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

          String title = result.data['post']['title'];
          String author = result.data['post']['author']['name'];
          String images = result.data['post']['featuredImage'] == null
              ? "https://cdn.dribbble.com/users/1040983/screenshots/5807325/man-02_2x.png"
              : result.data['post']['featuredImage']['sourceUrl'];
          String content = result.data['post']['content'];
            // print(title);
            // print(author);
            // print(images);
            // print(content);
          return new ListViewQ(author: author, images: images, title: title,content: content);
        },
      ),
    );
  }
}

class ListViewQ extends StatelessWidget {
  const ListViewQ({
    Key key,
    @required this.author,
    @required this.images,
    @required this.title,
    @required this.content,
  }) : super(key: key);

  final String author;
  final String images;
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        new Cover(author,images),
        SizedBox(
          height: 20,
        ),
        Container(
          margin: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  "FEATURED",
                  style: TextStyle(
                      fontFamily: "Libre Baskerville",
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.grey),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Text(
                  title,
                  style: TextStyle(
                      fontFamily: "Libre Baskerville",
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child:
                 HtmlRenderer(
                          initialHtmlString: content,
                      ),
                  
              ),
            ],
          ),
        )
      ],
    );
  }
}

class Cover extends StatelessWidget {
  
  final String author;
  final String image;

  Cover(this.author,this.image);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        new Positioned(
          child: Container(
            margin: EdgeInsets.only(bottom: 17),
            child: Image(
              height: 300.0,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              image: NetworkImage(
                  image),
            ),
          ),
        ),
        new Positioned(
          child: Container(
            margin: EdgeInsets.only(bottom: 17),
            child: Image(
              height: 300.0,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,
              image: NetworkImage("https://i.stack.imgur.com/ksnId.png"),
            ),
          ),
        ),
        new Positioned(
          bottom: 3,
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              children: <Widget>[
                Container(
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(48.0),
                      boxShadow: [
                        new BoxShadow(
                            offset: Offset(
                              0, // horizontal, move right 10
                              10.0, // vertical, move down 10
                            ),
                            color: Colors.black,
                            blurRadius: 20.0)
                      ]),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: new NetworkImage(
                        "https://fiverr-res.cloudinary.com/images/t_main1,q_auto,f_auto/gigs/98381915/original/9a98da91fcc1709763e92016d13756af640abcb7/design-minimalist-flat-line-vector-avatar-of-you.jpg"),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'By '+this.author,
                  style: TextStyle(
                      fontFamily: "Libre Baskerville",
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.white),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
