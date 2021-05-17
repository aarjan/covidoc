import 'package:flutter/material.dart';
import 'package:covidoc/utils/const/const.dart';

class AddQuestionView extends StatelessWidget {
  const AddQuestionView({
    Key? key,
    this.onAdd,
  }) : super(key: key);

  final void Function()? onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.WHITE5),
        borderRadius: BorderRadius.circular(10),
      ),
      constraints: const BoxConstraints(maxHeight: 110),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/forum/add_img.png'),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add a new question',
                  style: AppFonts.MEDIUM_BLACK3_16,
                ),
                const SizedBox(height: 5),
                Text(
                  'Lorem ipsum dolor sit amet, '
                  'consectetur adipisg elit. In in nisi sed odio',
                  softWrap: true,
                  maxLines: 3,
                  style: AppFonts.REGULAR_BLACK3_10,
                )
              ],
            ),
          ),
          const SizedBox(width: 15),
          InkWell(
            onTap: onAdd,
            child: Container(
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
          ),
        ],
      ),
    );
  }
}
