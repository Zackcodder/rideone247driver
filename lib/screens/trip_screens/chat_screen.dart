import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:ride_on_driver/core/constants/assets.dart';
import 'package:ride_on_driver/core/extensions/build_context_extensions.dart';
import 'package:ride_on_driver/widgets/choice_chip.dart';
import 'package:ride_on_driver/widgets/spacing.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/colors.dart';
import '../../core/extensions/widget_extensions.dart';
import '../../widgets/borderless_textfield.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<types.Message> _messages = [];
  final _user = const types.User(
    id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
  );

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      if (message.uri.startsWith('http')) {
        try {
          final index = _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage = (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });
        } finally {
          final index = _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage = (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });
        }
      }
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);
  }

  void _loadMessages() async {
    final response = await rootBundle.loadString('assets/messages.json');
    final messages = (jsonDecode(response) as List)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList();

    setState(() {
      _messages = messages;
    });
  }

  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
              tileColor: AppColors.white,
              minLeadingWidth: 20.w,
              leading: Icon(
                Icons.arrow_back_ios_new_outlined,
                size: 20.w,
              ).onTap(context.pop),
              trailing: const Icon(Icons.call).onTap(() {
                try {
                  launchUrl(Uri.parse('tel: 1234567'));
                } catch (e) {
                  print(e);
                }
              }),
              title: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 20.r,
                  backgroundImage: const AssetImage(Assets.assetsImagesDriverProfile),
                ),
                title: Text('Shai Hulud', style: context.textTheme.bodyMedium),
                subtitle: Text(
                  'Today Corolla - FST245SA',
                  style: context.textTheme.bodySmall,
                ),
              ),
            ),
            Chat(
              theme: const DefaultChatTheme(
                primaryColor: AppColors.yellow,
                sentMessageBodyTextStyle: TextStyle(
                  color: AppColors.black,
                ),
              ),
              customBottomWidget: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Start Conversation With Shai Hulud',
                    style: context.textTheme.bodySmall,
                  ).padOnly(left: 20.w),
                  const VerticalSpacing(10),
                  ChoiceChipList(
                    options: const [
                      MyChoiceChip("I'm here"),
                      MyChoiceChip('Where are you?'),
                      MyChoiceChip("I'm on my way"),
                      MyChoiceChip('Hello there'),
                    ],
                    unSelectedChipColor: AppColors.grey.withOpacity(0.5),
                    selectedChipColor: AppColors.grey.withOpacity(0.5),
                  ).padOnly(left: 20.w),
                  const VerticalSpacing(10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: AppColors.grey.withOpacity(0.5),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: BorderlessTextfield(
                            hintText: 'Type your Message here',
                            controller: controller,
                          ),
                        ),
                        const HorizontalSpacing(10),
                        const Icon(
                          Icons.send,
                          color: AppColors.black,
                        ).onTap(() {
                          if (controller.text.isNotEmpty) {
                            _handleSendPressed(PartialText(text: controller.text));
                            controller.clear();
                          }
                        }),
                      ],
                    ),
                  ),
                ],
              ),
              messages: _messages,
              onAttachmentPressed: _handleAttachmentPressed,
              onMessageTap: _handleMessageTap,
              onPreviewDataFetched: _handlePreviewDataFetched,
              onSendPressed: _handleSendPressed,
              showUserAvatars: true,
              showUserNames: true,
              user: _user,
            ).expand(),
          ],
        ),
      ),
    );
  }
}
