import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/view_models/Posts%20View%20Model/create_post_view_model.dart';
import 'package:home_workout_app/views/Posts%20View/post_view_widgets.dart';
import 'package:provider/provider.dart';

class CreatePostView extends StatefulWidget {
  const CreatePostView({Key? key}) : super(key: key);

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero).then((value) {
      Provider.of<CreatePostViewModel>(context, listen: false).resetPicked();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Add a post',
          style: theme.textTheme.bodyMedium,
        ).tr(),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Consumer<CreatePostViewModel>(
                  builder: (context, post, child) => SingleChildScrollView(
                    child: SingleChildScrollView(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Post Type: ',
                              style: theme.textTheme.bodySmall,
                            ).tr(),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                post.setSelectedPostType(PostTypes.Normal);
                              },
                              child: TypeContainer(
                                title: 'Text/Media',
                                backgroundColor:
                                    post.getSelectedPostType == PostTypes.Normal
                                        ? blueColor
                                        : Colors.white,
                                textColor:
                                    post.getSelectedPostType == PostTypes.Normal
                                        ? Colors.white
                                        : blueColor,
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                post.setSelectedPostType(PostTypes.NormalPoll);
                              },
                              child: TypeContainer(
                                title: 'Custom poll',
                                backgroundColor: post.getSelectedPostType ==
                                        PostTypes.NormalPoll
                                    ? blueColor
                                    : Colors.white,
                                textColor: post.getSelectedPostType ==
                                        PostTypes.NormalPoll
                                    ? Colors.white
                                    : blueColor,
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                post.setSelectedPostType(PostTypes.TipPoll);
                              },
                              child: TypeContainer(
                                title: 'Tip poll',
                                backgroundColor: post.getSelectedPostType ==
                                        PostTypes.TipPoll
                                    ? blueColor
                                    : Colors.white,
                                textColor: post.getSelectedPostType ==
                                        PostTypes.TipPoll
                                    ? Colors.white
                                    : blueColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (Provider.of<CreatePostViewModel>(context, listen: true)
                      .getSelectedPostType ==
                  PostTypes.Normal)
                CreateNormalPostSpace(),
              if (Provider.of<CreatePostViewModel>(context, listen: true)
                      .getSelectedPostType ==
                  PostTypes.NormalPoll)
                CreateNormalPollSpace(),
              if (Provider.of<CreatePostViewModel>(context, listen: true)
                      .getSelectedPostType ==
                  PostTypes.TipPoll)
                CreateTipPollSpace(),
            ],
          ),
        ),
      ),
    );
  }
}
