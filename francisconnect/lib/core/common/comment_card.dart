import 'package:flutter/material.dart';
import 'package:francisconnect/models/comment_model.dart';
import 'package:francisconnect/theme/palette.dart';

class CommentCard extends StatelessWidget {
  final Comment comment;
  final bool isReply;
  final bool isAboutToReply;
  final VoidCallback? onReply;

  const CommentCard({
    super.key,
    required this.comment,
    this.isReply = false,
    this.isAboutToReply = false,
    this.onReply
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: isReply? 32: 12,
        right: 12,
        top: 8,
        bottom: 4
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: comment.pfp.isNotEmpty
                  ? NetworkImage(comment.pfp)
                  :null,
                child: comment.pfp.isEmpty
                  ? const Icon(Icons.person, 
                    color: Palette.whiteColor,
                    size: 18)
                  : null,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comment.nombreCompleto,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14
                    ),
                  ),
                  Text(
                    isReply ? 'Respuesta' : comment.carrera,
                    style: TextStyle(
                      fontSize: 12,
                      color: isReply
                          ? Colors.grey[500]
                          : Colors.grey[600],
                      fontStyle: isReply
                          ? FontStyle.italic
                          : FontStyle.normal
                    ),
                  )
                ],
              )
            ],
          ),
          const SizedBox(height: 6),

          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Text(comment.text, style: TextStyle(fontSize: 14))
          ),
          const SizedBox(height: 6),

          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Row(
              children: [
                const Icon(Icons.favorite_border,
                  color: Colors.grey,
                  size: 18
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Text(
                      isReply
                        ? 'Responder a ${comment.nombreCompleto.split(' ').first}'
                        : 'Sé parte de la conversación',
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey[600]),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onReply,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isAboutToReply
                        ? Palette.accent6
                        : Palette.accent2,
                      borderRadius: BorderRadius.circular(6)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Image.asset('assets/images/comment_icon.png', color: Palette.whiteColor),
                    ),
                  ),
                )
              ],
            ),
          ),
          const Divider(height: 16
          )
        ],
      ),
    );
  }
}