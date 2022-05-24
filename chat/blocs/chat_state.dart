part of 'chat_bloc.dart';

class ChatState extends Equatable {
  final bool? isSendText;
  final int? numLine;
  const ChatState({this.numLine, this.isSendText});

  factory ChatState.empty() {
    return const ChatState(isSendText: false, numLine: 1);
  }

  ChatState copyWith({bool? isSendText, int? numLine}) {
    return ChatState(
        isSendText: isSendText ?? this.isSendText,
        numLine: numLine ?? this.numLine);
  }

  @override
  List<Object?> get props => [isSendText, numLine];
}
