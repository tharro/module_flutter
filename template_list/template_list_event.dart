part of 'template_list_bloc.dart';

abstract class TemplateListEvent extends Equatable {
  const TemplateListEvent();

  @override
  List<Object> get props => [];
}

class GetTemplateList extends TemplateListEvent {
  /// When user pull to refresh
  final bool isFreshing;

  /// When user scroll to end the list
  final bool isLoadingMore;

  const GetTemplateList({this.isFreshing = false, this.isLoadingMore = false});
}
