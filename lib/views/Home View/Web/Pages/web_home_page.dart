import 'package:flutter/material.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/view_models/Home%20View%20Model/web_home_view_model.dart';
import 'package:home_workout_app/views/Home%20View/Web/web_home_view_widgets.dart';
import 'package:provider/provider.dart';

class WebHomePage extends StatelessWidget {
  const WebHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<WebHomeViewModel>(
      builder: (context, value, child) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Category: '),
              DropdownButton(
                autofocus: true,
                elevation: 0,
                underline: const SizedBox(),
                focusColor: Colors.transparent,
                iconEnabledColor: blueColor,
                iconDisabledColor: blueColor,
                borderRadius: BorderRadius.circular(15),
                value: value.selectedCategorie,
                items: value.categories.entries
                    .map(
                      (e) => DropdownMenuItem(
                        value: e.key,
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                              color: blueColor,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              e.key,
                              style: theme.textTheme.bodySmall!.copyWith(
                                  color: Colors.white,
                                  fontSize: e.value ? 15 : 10),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (String? newCategorie) {
                  value.changeSelectedCategorie(newCategorie ?? 'Recommended');
                },
              ),
            ],
          ),
          Expanded(
            child: GridView(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 500,
              ),
              children: value
                  .getWorkouts()
                  .where(
                      (element) => element.categorie == value.selectedCategorie)
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: webWorkoutCard(
                        publisherName: e.publisherName,
                        imageUrl: e.imageUrl,
                        exercisesNum: e.excersises,
                        min: e.excpectedTime,
                        publisherImageUrl: e.imageUrl,
                        workoutName: e.name,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
