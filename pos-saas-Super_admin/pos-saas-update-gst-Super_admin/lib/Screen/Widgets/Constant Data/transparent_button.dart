import 'package:flutter/material.dart';

import 'constant.dart';

class GlobalTransparentButton extends StatelessWidget {
  const GlobalTransparentButton({super.key, required this.buttonText, required this.onpressed});
  final String buttonText;
  final VoidCallback onpressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: kMainColor600)
        ),
        // decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: kBlueTextColor),
        child: Row(
          children: [
            Container(
                alignment: Alignment.center,
                height: 20,
                width: 20,
                // padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: kMainColor600),
                ),
                child: const Icon(Icons.add,color: kMainColor,size: 18,)),
            const SizedBox(width: 5,),
            Text(
              buttonText,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: kMainColor600,fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

///--------------------wihtout icon transparent button----------------------

class GlobalTransparentWithoutIconButton extends StatelessWidget {
  const GlobalTransparentWithoutIconButton({super.key, required this.buttonText, required this.onpressed});
  final String buttonText;
  final VoidCallback onpressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressed,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: kErrorColor)
        ),
        // decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: kBlueTextColor),
        child: Text(
          buttonText,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: kErrorColor,fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
