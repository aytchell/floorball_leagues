import 'package:bloc/bloc.dart';
import 'package:floorball/api/models/season_info.dart';

class AvailableSeasons {
  AvailableSeasons(this.seasons);

  final List<SeasonInfo> seasons;
}

class AvailableSeasonsCubit extends Cubit<AvailableSeasons> {
  AvailableSeasonsCubit() : super(AvailableSeasons([]));

  void setSeasons(List<SeasonInfo> seasons) => emit(AvailableSeasons(seasons));
}
