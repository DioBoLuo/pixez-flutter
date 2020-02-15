import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixez/component/painter_avatar.dart';
import 'package:pixez/component/pixiv_image.dart';
import 'package:pixez/models/novel_recom_response.dart';
import 'package:pixez/models/novel_text_response.dart';
import 'package:pixez/network/api_client.dart';
import 'package:pixez/page/novel/component/novel_bookmark_button.dart';
import 'package:pixez/page/novel/viewer/bloc.dart';

class NovelViewerPage extends StatefulWidget {
  final int id;
  final Novel novel;

  const NovelViewerPage({Key key, @required this.id, @required this.novel})
      : super(key: key);

  @override
  _NovelViewerPageState createState() => _NovelViewerPageState();
}

class _NovelViewerPageState extends State<NovelViewerPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<NovelTextBloc>(
      child:
          BlocBuilder<NovelTextBloc, NovelTextState>(builder: (context, state) {
        if (state is DataNovelState) {
          var seriesNext = state.novelTextResponse.seriesNext;
          var seriesPrev = state.novelTextResponse.seriesPrev;
          return Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              actions: <Widget>[
                NovelBookmarkButton(
                  novel: widget.novel,
                )
              ],
            ),
            extendBodyBehindAppBar: true,
            body: ListView(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).padding.top,
                ),
                Center(child: Container(
                  height: 160,
                    child: PixivImage(widget.novel.imageUrls.medium))),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SelectableText(state.novelTextResponse.novelText,scrollPhysics: NeverScrollableScrollPhysics(),),
                ),
                Container(
                  child: ListTile(subtitle:Text(widget.novel.user.name),title:Text(widget.novel.title??""),leading: PainterAvatar(url: widget.novel.user.profileImageUrls.medium,id: widget.novel.user.id,onTap: (){},),),
                ),
                buildListTile(seriesPrev),
                buildListTile(seriesNext),

                Container(
                  height: MediaQuery.of(context).padding.bottom,
                )
              ],
            ),
          );
        }
        return Scaffold();
      }),
      create: (BuildContext context) => NovelTextBloc(
          RepositoryProvider.of<ApiClient>(context),
          id: widget.id)
        ..add(FetchEvent()),
    );
  }

  Widget buildListTile(Novel series) {
    return ListTile(
      title: Text(series.title ?? ""),
      onTap: () {
        Navigator.of(context, rootNavigator: true)
            .pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => NovelViewerPage(
                      id: series.id,
                  novel: series,
                    )));
      },
    );
  }
}
