import 'package:cached_network_image/cached_network_image.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ForumScreen extends StatelessWidget {
  static const ROUTE_NAME = '/forum';

  const ForumScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discuss', style: AppFonts.SEMIBOLD_BLACK3_16),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: ForumView(),
    );
  }
}

class ForumView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          AddQuestionView(onAdd: () {}),
          const SizedBox(height: 20),
          const FilterView(),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return QuestionView();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FilterView extends StatelessWidget {
  const FilterView();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
            child: Filter(
          title: 'Category',
          onPressed: () {},
        )),
        const SizedBox(width: 10),
        Flexible(
            child: Filter(
          title: 'Sort by',
          onPressed: () {},
        )),
      ],
    );
  }
}

class Filter extends StatelessWidget {
  const Filter({
    Key key,
    this.title,
    this.onPressed,
  }) : super(key: key);

  final String title;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.WHITE2,
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            Expanded(child: Text(title, style: AppFonts.MEDIUM_BLACK3_14)),
            const Icon(Icons.keyboard_arrow_down_sharp),
          ],
        ),
      ),
    );
  }
}

class AddQuestionView extends StatelessWidget {
  const AddQuestionView({
    Key key,
    this.onAdd,
  }) : super(key: key);

  final void Function() onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.WHITE3),
        borderRadius: BorderRadius.circular(10),
      ),
      constraints: const BoxConstraints(maxHeight: 110),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/forum/add_img.png'),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add a new question',
                  style: AppFonts.SEMIBOLD_BLACK3_16,
                ),
                const SizedBox(height: 5),
                Text(
                  'Lorem ipsum dolor sit amet, '
                  'consectetur adipisg elit. In in nisi sed odio',
                  softWrap: true,
                  maxLines: 3,
                  style: AppFonts.REGULAR_BLACK3_9,
                )
              ],
            ),
          ),
          const SizedBox(height: 50),
          Container(
            decoration: const BoxDecoration(
              color: AppColors.DEFAULT,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(15),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class QuestionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      margin: const EdgeInsets.only(top: 10),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.WHITE4))),
      child: Column(
        children: [
          const Text(
            'The commonest cause of UGI Bleeding in children is'
            ' a) variceal b) polyb c) duodenal ulcer',
            maxLines: 2,
            softWrap: true,
          ),
          Row(
            children: [
              const Icon(Icons.calendar_today_rounded),
              const SizedBox(width: 6),
              Text(
                'June 12, 1 hour ago',
                style: AppFonts.MEDIUM_WHITE3_12,
              ),
              const SizedBox(width: 20),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColors.WHITE4,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('ENT', style: AppFonts.REGULAR_WHITE3_10),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundImage: CachedNetworkImageProvider(
                    'https://lh6.googleusercontent.com/-OIwJt2XA8EM/AAAAAAAAAAI/AAAAAAAAAAA/AMZuuck3gBspRFThmeOhR1_yvhtInFcfFg/s96-c/photo.jpg'),
              ),
              const SizedBox(width: 6),
              const Text('Anne'),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(5),
                color: AppColors.GREEN1,
                child: SvgPicture.asset('assets/forum/pin.svg'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
