import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SearchInputWidget extends StatelessWidget {
  const SearchInputWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: TextField(
          decoration: InputDecoration(
              fillColor: Color.fromARGB(255, 236, 240, 40),
              filled: true,
              hintText: 'search....',
              contentPadding: EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 10,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(14.0),
                child: SvgPicture.asset(
                  'assets/icons/search.svg',
                  width: 10,
                ),
              )),
        ),
      ),
    );
  }
}
