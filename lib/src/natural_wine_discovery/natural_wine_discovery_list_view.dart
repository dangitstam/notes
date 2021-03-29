import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class NaturalWineDiscoveryListViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
            child: Container(
              color: Colors.black38,
              height: 0.20,
            ),
            preferredSize: Size.fromHeight(0.5)),
        centerTitle: false,
        elevation: 0,
        title: Text(
          'Notes'.toUpperCase(),
          style: Theme.of(context).textTheme.overline.copyWith(fontSize: 24),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: GestureDetector(
                  onTap: () {
                    // TODO: Filter implementation.
                  },
                  child: Row(children: [Text('Filter', style: Theme.of(context).textTheme.caption)]))),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: GestureDetector(
                  onTap: () {
                    // TODO: Filter implementation.
                  },
                  child: Row(children: [Text('Sort', style: Theme.of(context).textTheme.caption)]))),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: GestureDetector(
                  onTap: () {
                    // TODO: Filter implementation.
                  },
                  child: Row(children: [
                    Icon(CupertinoIcons.search, color: Colors.black, size: 20),
                    SizedBox(width: 5),
                    Text('Search', style: Theme.of(context).textTheme.caption)
                  ]))),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet<void>(
                  context: context,
                  backgroundColor: Theme.of(context).colorScheme.background,
                  builder: (BuildContext context) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40.0),
                      child: Column(
                        children: <Widget>[
                          Text('What are we tasting?'.toUpperCase(), style: Theme.of(context).textTheme.headline6),
                          const SizedBox(height: 40),
                          TextButton(
                            style: Theme.of(context).outlinedButtonTheme.style,
                            child: Text('Coffee'.toUpperCase()),
                            onPressed: () {
                              // Dismiss the modal before navigating.
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/new-coffee-tasting');
                            },
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            style: Theme.of(context).outlinedButtonTheme.style,
                            child: Text('Wine'.toUpperCase()),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/new-wine-tasting');
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Icon(CupertinoIcons.plus_app, color: Colors.black, size: 35),
            ),
          ),
        ],
      ),
      body: NaturalWineDiscoveryListViewWidget(),
    );
  }
}

class NaturalWineDiscoveryListViewWidget extends StatelessWidget {
  NaturalWineDiscoveryListViewWidget({Key key}) : super(key: key);

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    String formattedVinification = '';
    List<String> vinificationFacts = [];
    if (document['is_biodynamic']) {
      vinificationFacts.add('Biodynamic');
    }
    if (document['is_organic_farming']) {
      vinificationFacts.add('Organic Farming');
    }
    if (document['is_unfined_unfiltered']) {
      vinificationFacts.add('Unfined & Unfiltered');
    }
    if (document['is_wild_yeast']) {
      vinificationFacts.add('Wild Yeast');
    }
    if (document['is_no_added_sulfites']) {
      vinificationFacts.add('No Added S02');
    }
    if (document['is_ethically_made']) {
      vinificationFacts.add('Ethically Made');
    }
    if (vinificationFacts.isNotEmpty) {
      formattedVinification = vinificationFacts.join(' · ');
    }

    return ListTile(
      contentPadding: EdgeInsets.all(17),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                document['winemaker'].toUpperCase(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
          Row(
            children: [
              Text(
                document['name'].toUpperCase(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headline5,
              ),
            ],
          ),
          ReadMoreText(
            document['story'],
            trimLines: 3,
            trimMode: TrimMode.Line,
            colorClickableText: Theme.of(context).colorScheme.primary,
            trimCollapsedText: 'Expand',
            trimExpandedText: 'Collapse',
            delimiter: ' ..',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          formattedVinification.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 24,
                        child: Image.asset(
                          'assets/images/np_vinification.png',
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          '${formattedVinification}',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('naturalwinediscover').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');

        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) => _buildListItem(context, snapshot.data.documents[index]),
        );
      },
    );
  }
}