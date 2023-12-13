import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:gswattanaapp/bloc/saving/saving_event.dart';
import 'package:gswattanaapp/bloc/saving/saving_state.dart';
import 'package:gswattanaapp/src/models/saving_response.dart';
import 'package:gswattanaapp/src/services/saving_service.dart';

class SavingBloc extends Bloc<SavingEvent, SavingState> {
//  final SavingService savingService;
  var _savingservice = SavingService();

//
//  SavingBloc({this.savingService});

  @override
  SavingState get initialState => Loading();

  @override
  Stream<SavingState> mapEventToState(
    SavingEvent event,
  ) async* {
    if (event is FetchSaving) {
      try {
        final items = await _savingservice.fetchSaving();
        yield SavingLoaded(items: items);
      } catch (ex) {
        yield Failure(ex);
      }
    }
  }
}
