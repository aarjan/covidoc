import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:covidoc/utils/const/const.dart';

class QuestionTags extends StatefulWidget {
  final void Function(String) onAdd;
  final List<String> tags;
  final void Function(String) onRemove;

  const QuestionTags({Key key, this.onAdd, this.onRemove, this.tags})
      : super(key: key);

  @override
  _QuestionTagsState createState() => _QuestionTagsState();
}

class _QuestionTagsState extends State<QuestionTags> {
  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
  final List<String> _itemlist = [];

  @override
  void initState() {
    super.initState();
    _itemlist.addAll(widget.tags);
  }

  @override
  Widget build(BuildContext context) {
    return Tags(
      alignment: WrapAlignment.start,
      key: _tagStateKey,
      runSpacing: 0,
      textField: TagsTextField(
        autofocus: false,
        textStyle: AppFonts.REGULAR_BLACK3_14,
        constraintSuggestion: false,
        width: 100,
        onSubmitted: (String str) {
          // Add item to the data source.
          setState(() {
            // required
            _itemlist.add(str);
          });
          widget.onAdd(str);
        },
      ),
      itemCount: _itemlist.length, // required
      itemBuilder: (int index) {
        final title = _itemlist[index];

        return Padding(
          padding: const EdgeInsets.only(top: 6, bottom: 10, left: 6),
          child: ItemTags(
            alignment: MainAxisAlignment.start,
            textColor: AppColors.BLACK3,
            textActiveColor: AppColors.BLACK3,
            activeColor: AppColors.WHITE5,
            borderRadius: BorderRadius.circular(10),
            elevation: 0,
            key: Key(index.toString()),
            index: index, // required
            title: title,
            textStyle: AppFonts.REGULAR_BLACK3_14,
            combine: ItemTagsCombine.withTextBefore, // OR null,
            removeButton: ItemTagsRemoveButton(
              icon: Icons.close,
              color: AppColors.BLACK3,
              size: 11,
              borderRadius: BorderRadius.circular(0),
              backgroundColor: Colors.transparent,
              onRemoved: () {
                // Remove the item from the data source.
                setState(() {
                  // required
                  _itemlist.removeAt(index);
                });

                widget.onRemove(title);
                return true;
              },
            ), // OR null,
            onPressed: (item) {
              setState(() {
                _itemlist.removeAt(index);
              });
              widget.onRemove(item.title);
            },
          ),
        );
      },
    );
  }
}
