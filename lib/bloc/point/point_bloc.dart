import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:gswattanaapp/bloc/point/point_event.dart';
import 'package:gswattanaapp/bloc/point/point_state.dart';
import 'package:gswattanaapp/src/models/point_response.dart';
import 'package:gswattanaapp/src/services/point_service.dart';

class PointBloc extends Bloc<PointEvent, PointState> {
//  final PointService pointService;
  var _pointservice = PointService();

//
//  PointBloc({this.pointService});

  @override
  PointState get initialState => Loading();

  @override
  Stream<PointState> mapEventToState(
    PointEvent event,
  ) async* {
    if (event is FetchPoint) {
      try {
        final items = await _pointservice.fetchPoint();
        yield PointLoaded(items: items);
      } catch (ex) {
        yield Failure(ex);
      }
    }
  }
}
