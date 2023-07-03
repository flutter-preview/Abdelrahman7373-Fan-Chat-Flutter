import 'package:flutter/material.dart';

class ChatTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;

  const ChatTextField({Key? key, required this.controller, required this.hintText});

  @override
  _ChatTextFieldState createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  final ScrollController _scrollController = ScrollController();
  bool _isTextFieldExpanded = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: _isTextFieldExpanded ? ClampingScrollPhysics() : NeverScrollableScrollPhysics(),
        child: TextField(
          controller: widget.controller,
          maxLines: _isTextFieldExpanded ? null : 5,
          minLines: 1,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            fillColor: Colors.grey[100],
            filled: true,
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: Colors.white,),
          ),
          onChanged: (value) {
            final lines = value.split('\n').length;
            setState(() {
              _isTextFieldExpanded = lines > 5;
              if (_isTextFieldExpanded) {
                _scrollToBottom();
              }
            });
          },
        ),
      ),
    );
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }
}
