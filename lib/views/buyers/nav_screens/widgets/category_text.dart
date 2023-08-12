import 'package:flutter/material.dart';

class CategoryText extends StatelessWidget {
  CategoryText({super.key});

  final List<String> _categorylabel = [
    'Indoor',
    'Outdoor',
    'Succulents',
    'Pots',
    'test',
    'test',
    'test',
    'test',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Categories',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          Container(
            height: 40,
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _categorylabel.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: ((context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        child: ActionChip(
                          onPressed: () {},
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          backgroundColor: Colors.green[900],
                          label: Text(
                            _categorylabel[index],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.arrow_forward_ios),
                  iconSize: 20,
                  highlightColor: Colors.transparent,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
