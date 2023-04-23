import 'package:plugin_helper/index.dart';

import '../../api/apiUrl.dart';
import '../../index.dart';
import '../../models/template_list/template_list_model.dart';
import '../../repositories/template_list/template_list_repository.dart';

part 'template_list_event.dart';
part 'template_list_state.dart';

class TemplateListBloc extends Bloc<TemplateListEvent, TemplateListState> {
  TemplateListRepository templateListRepositories = TemplateListRepository();
  TemplateListBloc() : super(TemplateListState.empty()) {
    on<GetListTemplateList>(_getListTemplateList);
  }

  // Handle load data
  void _getListTemplateList(
      GetListTemplateList event, Emitter<TemplateListState> emit) async {
    if (event.isLoadingMore &&
        (state.listTemplateList.next == null ||
            state.listTemplateList.isLoadingMore)) {
      return;
    }

    if (event.isFreshing && state.listTemplateList.isRefreshing) {
      return;
    }

    try {
      emit(state.copyWith(
          listTemplateList: state.listTemplateList.copyWith(
              isLoadingMore: event.isLoadingMore,
              isLoading: !event.isLoadingMore && !event.isFreshing,
              isRefreshing: !event.isLoadingMore && event.isFreshing)));
      ListModel<TemplateListModel> newTemplateListList =
          await templateListRepositories.getTemplateList(
              url: event.isLoadingMore
                  ? state.listTemplateList.next!
                  : APIUrl.listTemplateList);
      emit(state.copyWith(
          listTemplateList: newTemplateListList.copyWith(
              results: event.isLoadingMore
                  ? state.listTemplateList.results! +
                      newTemplateListList.results!
                  : newTemplateListList.results)));
    } catch (e) {
      emit(state.copyWith(
          listTemplateList: state.listTemplateList.copyWith(
        errorMessage: event.isLoadingMore ? null : e.parseError.message,
        isRefreshing: false,
        isLoading: false,
        isLoadingMore: false,
      )));

      if (event.isLoadingMore) {
        Helper.showToastBottom(message: e.parseError.message);
      }
    }
  }
}
