import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:gswattanaapp/bloc/savingmt/savingmt_event.dart';
import 'package:gswattanaapp/bloc/savingmt/savingmt_state.dart';
import 'package:gswattanaapp/src/services/savingmt_service.dart';

class SavingMtBloc extends Bloc<SavingMtEvent, SavingMtState> {
//  final SavingMtService savingMtService;
  var _savingMtservice = SavingMtService();

//
//  SavingMtBloc({this.savingMtService});

  @override
  SavingMtState get initialState => Loading();

  @override
  Stream<SavingMtState> mapEventToState(
    SavingMtEvent event,
  ) async* {
    if (event is FetchSavingMt) {
      try {
        final items = await _savingMtservice.fetchSavingMt();
        yield SavingMtLoaded(items: items);
      } catch (ex) {
        yield Failure(ex);
      }
    }
  }
}
