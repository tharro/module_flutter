import 'package:bloc/bloc.dart';
import 'package:plugin_helper/plugin_helper.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatState.empty()) {
    on<HandleToolBar>((event, emit) {
      emit(
          state.copyWith(isSendText: event.isSendText, numLine: event.numLine));
    });
  }
}
