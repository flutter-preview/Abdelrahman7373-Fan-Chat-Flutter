import 'package:flutter/material.dart';

class ChatBubble extends StatefulWidget {
  final String message;
  final bool isCurrentUser;

  const ChatBubble({Key? key, required this.message, this.isCurrentUser = false,}) : super(key: key);

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.isCurrentUser ? Colors.blue[300] : Colors.white;
    final textColor = widget.isCurrentUser ? Colors.white : Colors.black;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: backgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: _isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: Text(widget.message,style: TextStyle(fontSize: 16, color: textColor),),
            secondChild: Text(widget.message,maxLines: 20,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 16, color: textColor),),
          ),
          if (widget.message.length > 20 * 25)
            GestureDetector(
              onTap: () {setState(() {_isExpanded = !_isExpanded;});},
              child: Text(_isExpanded ? 'Read Less' : 'Read More',style: TextStyle(color: Colors.blue),),
            ),
        ],
      ),
    );
  }
}
