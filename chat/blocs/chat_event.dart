part of 'chat_bloc.dart';

class ChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class HandleToolBar extends ChatEvent {
  final bool isSendText;
  final int numLine;

  HandleToolBar({required this.numLine, required this.isSendText});
}
