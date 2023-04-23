part of 'template_list_bloc.dart';

class TemplateListState extends Equatable {
  final ListModel<TemplateListModel> listTemplateList;

  const TemplateListState({
    required this.listTemplateList,
  });

  factory TemplateListState.empty() {
    return const TemplateListState(listTemplateList: ListModel());
  }

  TemplateListState copyWith({ListModel<TemplateListModel>? listTemplateList}) {
    return TemplateListState(
      listTemplateList: listTemplateList ?? this.listTemplateList,
    );
  }

  @override
  List<Object?> get props => [
        listTemplateList,
      ];
}
